mutable struct ADNode
    root::Bool
    val::Float64
    dval::Float64
    grad::Array{Float64}
    parent::Array{ADNode}
end

import Base.+
import Base.-
import Base.*
import Base./
import Base.sin
import Base.cos
import Base.length

function length(A::ADNode)
    return 1
end

# ADN op. ADN
function +(A::ADNode,B::ADNode)
    return ADNode(false,A.val+B.val,0.0,[1.0;1.0],[A;B])
end

function -(A::ADNode,B::ADNode)
    return ADNode(false,A.val-B.val,0.0,[1.0,-1.0],[A;B])
end

function *(A::ADNode,B::ADNode)
    return ADNode(false,A.val*B.val,0.0,[B.val;A.val],[A;B])
end

function /(A::ADNode,B::ADNode)
    return ADNode(false,A.val/B.val,0.0,[1/B.val;(-A.val)/B.val^2],[A;B])
end

function sin(A::ADNode)
    return ADNode(false,sin(A.val),0.0,[cos(A.val)],[A])
end

function cos(A::ADNode)
    return ADNode(false,cos(A.val),0.0,[-sin(A.val)],[A])
end
#---------------------

# Float64 op. ADN
function +(A::Float64,B::ADNode)
    return ADNode(false,A+B.val,0.0,[1.0],[B])
end
function +(A::ADNode,B::Float64)
    return B+A
end

function -(A::Float64,B::ADNode)
    return (-A)+B
end
function -(A::ADNode,B::Float64)
    return (-B)+A
end

function *(A::Float64,B::ADNode)
   return ADNode(false,A*B.val,0.0,[A],[B])
end
function *(A::ADNode,B::Float64)
   return B*A
end

function /(A::Float64,B::ADNode)
   return ADNode(false,A/B.val,0.0,[-A/B.val^2],[B])
end
function /(A::ADNode,B::Float64)
   return (1/B)*A
end
#---------------------

# Int64 op. ADN
function +(A::Int64,B::ADNode)
    return convert(Float64,A)+B
end
function +(A::ADNode,B::Int64)
    return A+convert(Float64,B)
end

function -(A::Int64,B::ADNode)
    return convert(Float64,A)-B
end
function -(A::ADNode,B::Int64)
    return A-convert(Float64,B)
end

function *(A::Int64,B::ADNode)
   return convert(Float64,A)*B
end
function *(A::ADNode,B::Int64)
   return A*convert(Float64,B)
end

function /(A::Int64,B::ADNode)
   return convert(Float64,A)/B
end
function /(A::ADNode,B::Int64)
   return A/convert(Float64,B)
end
#-------------------

# 
function ADbackward(f)
    function g(x)
        print("into g(x),x is ",x," \n")
        X=Array{ADNode}
        X=[ADNode(true,each,0.0,[0.0],[]) for each in x]
        Y=f(X)
        
        ret=[]
        #print("***************\n",Y,"\n*************\n")
        if length(Y) == 1
            Y = [Y]
        end
        for i=1:length(Y)
            Y[i].dval=1.0
            cur=Y[i]
            #print("\n",cur.val,"\n")
            #print(X,"\n")
            #use DFS to branch all path from Y[i] to all roots
            path=[]
            for par in cur.parent
                pushfirst!(path,par)
            end
            while length(path) != 0
                #print("\nright now the path is\n",path,"\n")
                print("\nright now, cur is \n",cur,"\n")
                for j=1:length(cur.parent)
                    cur.parent[j].dval += cur.dval*cur.grad[j]
                end
                #print("after updated, cur is \n", cur,"\n")
                #get a new node from the head
                cur = popfirst!(path)
                #push its parents to the list
                for par in cur.parent
                    pushfirst!(path,par)
                end
            end
            #print(X,"\n\n")
            temp_ans=[a.dval for a in X]
            print(temp_ans,"\n")
            #ret=[ret temp_ans]
            append!(ret,temp_ans)
            if i != length(Y)
                X=[ADNode(true,each,0.0,[0.0],[]) for each in x]
                Y=f(X)
            end
        end
        #the input is already documented in the X, which should be simultaneously updated.
        NoY=convert(Int64,(length(ret)/length(x)))
        NoX=length(x)
        #temp=Array(Float64,NoY,NoX)
        #for i=1:length(ret)
        #end
        ret=reshape(ret,NoX,NoY)
        return ret
    end
    return g
end