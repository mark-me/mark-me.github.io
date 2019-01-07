# Creating a project


Creating a directory to hold the project
```bash
mkdir my_first_python
```

Creating the Conda environment
```bash
conda create --name my_first_python python=3.6
```

Activating the Conda environment
```bash
source activate my_first_python
```

Install packages
```bash
conda install pandas numpy nb_conda
```

Exporting the Conda environment for re-using
```bash
conda env export > environment.yaml
```

Re-using the exported enviroment
```bash
conda env create -f environment.yaml
```

Add to Jupyter notebook
```bash
python -m ipykernel install --user --name my_first_python --display-name "Python (my_first_python)"
```
