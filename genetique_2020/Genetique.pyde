#Leo Perrat

imgSize = 40 #taille de l'image sur laquelle on travaille
nbAngles = 16 #nombre d'angles que peuvent prendre les individus
maxGenome = 20 #maximum de gènes au moment de la création d'un individu
minGenome = 7 #minimum de gènes au moment de la création d'un individu
symbole = "I" #glyphe à approcher
generations = 100 #nombre de générations successives à effectuer
population = 1000 #taille de la nurserie
epaisseurRect = 5 #epaisseur des rectangles des individus
nbCandidates = 10 #nombre des meilleurs candidats retenus à chaque génération
candidatesDistribution = 0.5 #répartition des chances de tomber sur chaque candidat, pour 0.5 on a 0.5 chances de tomber sur le premier, 0.25 sur le deuxieme, 0.125 sur le 3eme, etc...
mutationChanceAddDelete = 0.8 #chances de mutation AddDelete
mutationChanceAdd = 0.5 #chances de mutation Add
mutationChanceDelete = 0.5 #chances de mutation Delete



#============================================================================================================
#Effectue des tirages au sort entre 0 et 1 jusqu'à tomber sur un nombre inférieur à distribution, renvoie le nombre de tirages, qui est borné par maximum
def randomDistribution(distribution,maximum):
    i = 0
    while i < maximum and random(0,1) < distribution:
        i += 1
    return i




#============================================================================================================
#Représente un gene rectangle
class Rectangle:
    def __init__(self, longueur, angle, posX, posY):
        self.longueur = longueur
        self.angle = angle
        self.posX = posX
        self.posY = posY
    
    #Getters
    def getLongueur(self):
        return self.longueur
    
    def getAngle(self):
        return self.angle
    
    def getPosX(self):
        return self.posX
    
    def getPosY(self):
        return self.posY
    
    #Setters
    def setLongueur(self,longueur):
        self.longueur = longueur
        
    def setAngle(self,angle):
        self.angle = angle
        
    def setPosX(self,posX):
        self.posX = posX
    
    def setPosY(self,posY):
        self.posY = posY
        
        

        
#============================================================================================================
#Représente un individu qui possède un nombre de genes rectangles
class Individu:
    def __init__(self):
        self.rectangles = []    
    
    #Ajoute un gene défini
    def simpleAdd(self,rectangle):
        self.rectangles.append(rectangle)
        
    #Mute un individu en lui ajoutant un gene aléatoire
    def mutationAdd(self):
        global imgSize
        global nbAngles
        longueur = random(1,imgSize)
        angle = random(0,nbAngles)
        posX = random(1,imgSize)
        posY = random(1,imgSize)
        self.rectangles.append(Rectangle(longueur, angle, posX, posY))
    
    #Mute un individu en lui supprimant un gene aléatoire
    #Laisse toujours au moins un gene
    #Retourne le gene supprimé
    def mutationDelete(self):
        if(self.getNbGenes() > 1):
            gene = int(random(0,len(self.rectangles)-1))
            res = self.rectangles[gene]
            del self.rectangles[gene]
            return res
    
    #Mute un individu en lui modifiant entierement un gene
    def mutationAddDelete(self):
        self.mutationDelete()
        self.mutationAdd()
    
    #Donne un nombre aléatoire de genes aléatoires à un individu
    def create(self,minGenome,maxGenome):
        nbGenes = int(random(minGenome,maxGenome))
        for i in range(nbGenes):
            self.mutationAdd()
    
    #Fusionne deux individus
    def merge(self,ind):
        res = Individu()
        #On prend la moitié des genes de chaque individu
        
        nbGenes1 = (self.getNbGenes() // 2)
        nbGenes2 = (ind.getNbGenes() // 2)
        
        #Pour éviter la réduction progressive du nombre de gènes dû à la division entiere, on rajoute un gène à l'individu créé quand il y a un reste à la division
        if nbGenes1 == 0:
            reste1 = 0
        else:
            reste1 = (self.getNbGenes() % 2)
        for i in range(nbGenes1 + reste1):
            res.simpleAdd(self.mutationDelete())
        for i in range(nbGenes2):
            res.simpleAdd(ind.mutationDelete())
            
        return res
    
    #Retourne le nombre de genes (rectangles) de l'individu
    def getNbGenes(self):
        return len(self.rectangles)
    
    #Retourne la liste des genes (rectangles) de l'individu
    def getRectangles(self):
        return self.rectangles

    #Fonction de coût principale
    def __cost(self):
        global img
        global symbole
        global epaisseurRect
        img.beginDraw()
        img.noSmooth()
        # fond blanc
        img.background(255)
        # dessin en rouge
        img.fill(255, 0, 0)
        img.noStroke()
        img.textAlign(CENTER, BOTTOM)
        img.textSize(img.height)
        img.text(symbole, img.width / 2, img.height)
    
            # dessin en vert
        img.fill(0, 255, 0, 127)
    
        #pour tous les rectangles :  positionX  positionY, angle, longueur
        for rectangle in self.rectangles:
            img.pushMatrix()
            img.translate(rectangle.getPosX(), rectangle.getPosY())
            img.rotate(rectangle.getAngle() * (2*PI / 8))
            img.rect(0, 0, epaisseurRect, rectangle.getLongueur())
            img.popMatrix()
            
        img.endDraw()
        
        totalCoverage = 1 #pixels de l'individu
        correctCoverage = 0 #pixels de l'individu correctements positionnés
        targetCoverage = 1 #pixels du glyphe
        for i in range(0,len(img.pixels)):
            if red(img.pixels[i]) != 255:
                if green(img.pixels[i]) != 255:
                    totalCoverage += 1
                    correctCoverage += 1
                else:
                    totalCoverage += 1
            else:
                if green(img.pixels[i]) != 255:
                    targetCoverage += 1
         
        #return correctCoverage           
        #return float(correctCoverage)/float(totalCoverage)
        return float(correctCoverage)/float(totalCoverage * targetCoverage)
    
    #Fonction de coût sans affichage
    def cost(self):
        global img
        res = self.__cost()
        img.beginDraw()
        img.clear()
        img.endDraw()
        return res
    
    #Fonction de coût avec affichage à la position posX,posY
    def costDisplay(self,posX,posY):
        global img
        res = self.__cost()
        image(img,posX,posY)
        fill(0,0,0)
        text(res,posX,posY+img.height)
        img.beginDraw()
        img.clear()
        img.endDraw()
        return res
    
    def copy(self):
        ind = Individu()
        for rectangle in self.rectangles:
            ind.simpleAdd(rectangle)
        return ind
    
    

        
#============================================================================================================
#Représente une population d'un nombre nbIndividus d'individus
class Nurserie:
    def __init__(self):
        self.individus = []
        
    def create(self,nbIndividus,minGenome,maxGenome):
        for i in range(nbIndividus):
            ind = Individu()
            ind.create(minGenome,maxGenome)
            self.individus.append(ind)
        
    #Renvoie une liste des coûts de chaque individu
    def cost(self):
        res = []
        for ind in self.individus:
            res.append(ind.cost())
        return res
    
    #Renvoie une liste des coûts de chaque individu avec affichage à la position posX,posY
    def costDisplay(self,posX,posY):
        global imgSize
        res = []
        for i in range(len(self.individus)):
            posXAcc = posX + (imgSize*i)%( (width // imgSize) * imgSize)
            posYAcc = posY + ((imgSize*i)//( (width // imgSize) * imgSize) * imgSize)
            res.append(self.individus[i].costDisplay(posXAcc,posYAcc))
        return res
    
    #Crée une nouvelle générations d'individus basée sur la précédente
    #Retourne le meilleur candidat de la population actuelle
    def generation(self,nbCandidates,mutationChanceAddDelete,mutationChanceAdd,mutationChanceDelete):
        candidates = []
        
        #Calcul des coûts de la population actuelle
        costs = self.cost()
        
        #Recherche des nbCandidates meilleurs candidats de la population actuelle
        for i in range(nbCandidates):
            bestCandidate = 0
            for j in range(1,len(costs)):
                if costs[j] > costs[bestCandidate]:
                    bestCandidate = j
            candidates.append(self.individus[bestCandidate])
            del costs[bestCandidate]
            
        newGen = []
        
        #Création des individus de la nouvelle génération en reproduisant entre eux les nbCandidats meilleurs candidats
        for i in range(len(self.individus)):
            #Les candidats sont triés dans l'ordre décroissant de score ce qui permet d'utiliser la fonction randomDistribution() qui va permettre de choisir en priorité les candidats au début de la liste
            candidatesCopy = list(candidates)
            ind1Pos = randomDistribution(candidatesDistribution,nbCandidates-1)
            ind2Pos = randomDistribution(candidatesDistribution,nbCandidates-2)
            ind1 = candidatesCopy[ind1Pos].copy()
            del candidatesCopy[ind1Pos] #Pour éviter que l'individu se reproduise avec lui même, ce qui évite les superpositions de rectangles intempestives
            ind2 = candidatesCopy[ind2Pos].copy()
            ind3 = ind1.merge(ind2)
            
            if random(0,1) < mutationChanceAddDelete:
                for i in range(int(random(1,ind3.getNbGenes()))):
                    ind3.mutationAddDelete()
            
            if random(0,1) < mutationChanceAdd:
                for i in range(int(random(1,ind3.getNbGenes()))):
                    ind3.mutationAdd()
                
            if random(0,1) < mutationChanceDelete:
                ind3.mutationDelete()
                
            
            newGen.append(ind3)
        
        self.individus = list(newGen)
        return candidates[0]
    
    #Fonction de génération avec affichage à la position posX,posY du meilleur candidat de la population actuelle
    def generationDisplay(self,nbCandidates,candidatesDistribution,mutationChanceAddDelete,mutationChanceAdd,mutationChanceDelete,posX,posY):
        candidates = []
        
        #Calcul des coûts de la population actuelle
        costs = self.cost()
        
        #Recherche des nbCandidates meilleurs candidats de la population actuelle
        for i in range(nbCandidates):
            bestCandidate = 0
            for j in range(1,len(costs)):
                if costs[j] > costs[bestCandidate]:
                    bestCandidate = j
            candidates.append(self.individus[bestCandidate])
            del costs[bestCandidate]
        candidates[0].costDisplay(posX,posY)
        
        newGen = []
        
        #Création des individus de la nouvelle génération en reproduisant entre eux les nbCandidats meilleurs candidats
        for i in range(0,len(self.individus)):
            #Les candidats sont triés dans l'ordre décroissant de score ce qui permet d'utiliser la fonction randomDistribution() qui va permettre de choisir en priorité les candidats au début de la liste
            candidatesCopy = list(candidates)
            ind1Pos = randomDistribution(candidatesDistribution,nbCandidates-1)
            ind2Pos = randomDistribution(candidatesDistribution,nbCandidates-2)
            ind1 = candidatesCopy[ind1Pos].copy()
            del candidatesCopy[ind1Pos] #Pour éviter que l'individu se reproduise avec lui même, ce qui évite les superpositions de rectangles intempestives
            ind2 = candidatesCopy[ind2Pos].copy()
            ind3 = ind1.merge(ind2)
            
            if random(0,1) < mutationChanceAddDelete:
                for i in range(int(random(1,ind3.getNbGenes()))):
                    ind3.mutationAddDelete()
            
            if random(0,1) < mutationChanceAdd:
                for i in range(int(random(1,ind3.getNbGenes()))):
                    ind3.mutationAdd()
                
            if random(0,1) < mutationChanceDelete:
                ind3.mutationDelete()
                
                
            newGen.append(ind3)
        
        self.individus = list(newGen)
        return candidates[0]
    
    
    
    
    

def setup():
    size(1120,1120)
    global imgSize
    global img
    img = createGraphics(imgSize, imgSize)
    noLoop()

def draw():
    global maxGenome
    global minGenome
    global imgSize
    global generations
    global population
    global nbCandidates
    global candidatesDistribution
    global mutationChanceAddDelete
    global mutationChanceAdd
    global mutationChanceDelete
    
    nur = Nurserie()
    nur.create(population,minGenome,maxGenome)
    
    #Regenere la nurserie un nombre generations de fois et affiche les meilleurs candidats en grille
    #L'affichage n'est pas en temps réel il faut attendre que toutes les générations soient effectuée avant que l'affichage se produise
    for i in range(generations):
        posXAcc = (imgSize*i)%( (width // imgSize) * imgSize)
        posYAcc = ((imgSize*i)//( (width // imgSize) * imgSize) * imgSize)
        nur.generationDisplay(nbCandidates,candidatesDistribution,mutationChanceAddDelete,mutationChanceAdd,mutationChanceDelete,posXAcc,posYAcc)
