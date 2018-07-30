from setuptools import setup

setup(
    name='tf-jerakia',
    version='0.1.0',
    packages=['tf-jerakia'],
    include_package_data=True,
    description='Terraform Jerakia module',
    author='Jon Ander Novella',
    install_requires=[
        'jerakia'
    ]
)
