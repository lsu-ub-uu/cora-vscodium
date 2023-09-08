#! /bin/bash

VSCODIUM="cora-vscodium"

JS_OLD="diva-react-client "
JS="diva-react-spa-bff diva-react-spa "

JS_CONTAINER_OLD="diva-docker-react-client "
JS_CONTAINER="diva-react-spa-docker diva-react-spa-bff-docker "

ALL_JS=$JS_OLD" "$JS" "$JS_CONTAINER_OLD" "$JS_CONTAINER



ALL=$VSCODIUM" "$ALL_JS
