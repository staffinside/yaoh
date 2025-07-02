{
    'name': "School",
    'summary': "School Management System",
    'description': """
        School Management System for student records
    """,
    'author': "My Company",
    'website': "https://www.yourcompany.com",
    'category': 'Education',
    'version': '0.1',
    'depends': ['base'],
    'data': [
        'security/ir.model.access.csv',
        'views/views.xml',
    ],
    'demo': [
        'demo/demo.xml',
    ],
    'application': True,
}