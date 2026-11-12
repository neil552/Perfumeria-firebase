// Configuración compartida por los módulos Android del proyecto.
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Mantiene las salidas de compilación de los subproyectos bajo una ruta común.
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    // Elimina solo el directorio de compilación configurado arriba.
    delete(rootProject.layout.buildDirectory)
}
