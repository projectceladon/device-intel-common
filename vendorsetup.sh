if [ -f device/intel/mixins/mixin-update ]; then
    if ! device/intel/mixins/mixin-update --dry-run; then
        echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
        echo '+ Product configuration and mixins are out of sync                      +'
        echo '+ PLEASE RE-RUN device/intel/mixins/mixin-update and commit the result! +'
        echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
    fi
fi
