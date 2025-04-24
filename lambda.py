TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Request Headers</title>
    <style>
        body {{ margin: 20px; }}
        * {{ font-family: Helvetica, sans-serif; }}
    </style>
</head>
<body>
    <h1>Request Headers</h1>
    <ul>
    {headers}
    </ul>
</body>
</html>
"""

def html_format(headers):
    # Converts headers to "<li> header </li>" list
    headers = [
        f"<li><strong>{header_name}</strong>: {header_value}</li>"
        for header_name, header_value in headers.items()
    ]
    headers = "\n".join(headers)
    return TEMPLATE.format(headers=headers)

def text_format(headers):
    # Converts headers to "* header: value" list
    headers = [
        f"* {header_name}: {header_value}"
        for header_name, header_value in headers.items()
    ]
    return "\n".join(headers)

"""
This function will simply print the headers it received.
If ?format=html is present, it will print the headers in HTML format.
Otherwise, it is a just a text page.
"""
def lambda_handler(event, context):
    headers = event.get('headers', {})

    # Check if format query parameter is present
    query_params = event.get('queryStringParameters', {}) or {}
    if query_params.get('format') == 'html':
        content_type = 'text/html'
        body = html_format(headers)
    else:
        content_type = 'text/plain'
        body = text_format(headers)
    
    return {
        'statusCode': 200,
        'statusDescription': '200 OK',
        'isBase64Encoded': False,
        'headers': {
            'Content-Type': content_type,
        },
        'body': body
    }
