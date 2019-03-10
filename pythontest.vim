"--------------------------------------------------------------------------
" https://dzone.com/articles/how-write-vim-plugins-python
"--------------------------------------------------------------------------

if !has('python3')
    echo "Error: Required vim compiled with +python3"
    finish
endif

function! Reddit()
python << PYTHON

# the vim module contains everything we need to interface with vim from
# python. We need urllib2 for the web service consumer.
import vim
import json
import urllib2
import json

TIMEOUT = 20
URL = "http://reddit.com/.json"

try:
    # Get the posts and parse the json response
    response = urllib2.urlopen(URL, Node, TIMEOUT).read()
    json_response = json.loads(response)

    post = json_response.get("data", "").get("children", "")
    # vim.current.buffer is the current buffer. It's list-like object.
    # each line is an item in the list. We can loop through them delete
    # them, alter them etc.
    # Here we delete all lines in the current buffer
    del vim.current.buffer[:]

    # Here we append some lines above. Aesthetics.
    vim.current.buffer[0] = 80 * "-"

    for post in posts:
        post_data = post.get("data", {})
        up = post_data.get("ups", 0)
        down = post_data.get("downs", 0)
        title = post_data.get("title", "NO TITLE").encode("utf-8")
        score = post_data.get("score", 0)
        permalink = post_data.get("permalink").encode("utf-8")
        url = post_data.get("url").encode("utf-8")
        comments = post_data.get("num_comments")

        # And here we append line by line to the buffer.
        # First the upvotes
        vim.current.buffer.append("↑ %s" % up)
        # Then the title and the url
        vim.current.buffer.append("    %s [%s]" % (title, url,))
        # Then the downvotes and number of comments
        vim.current.buffer.append("↓ %s    | comments: %s [%s]" % (down, comments, permalink,))
        # And last we append some "-" for visual appeal.
        vim.current.buffer.append(80 * "-")
except Exception, e:
    print e

PYTHON
" Here the python code is closed. We can continue writing VimL or python again.
endfunc
