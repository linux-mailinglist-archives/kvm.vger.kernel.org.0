Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A5B1A107F
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 17:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgDGPqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 11:46:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31756 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726637AbgDGPqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 11:46:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586274362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cjZxTnYiiQOiGbCeQOJMkwdfCCa6o8kDSXhq/4N/Y40=;
        b=gPSYfOX4Yi2xEnsUqOWmMU7MxKua+DWqXGISe9RzPGKsBk2HNpU5haXC6khd3/4SsPFQuC
        VYUofKCh1osN5zg5PZmIX9JCYarwzHxHThDTGMD7nnUv010+UMNEmeiZvo0CM8RSeBahLd
        ZvnNgw3RQwifTqyx4GSdwN6pN3Aml3Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-4B0QzFpmNBmJV75PdjRGLw-1; Tue, 07 Apr 2020 11:45:59 -0400
X-MC-Unique: 4B0QzFpmNBmJV75PdjRGLw-1
Received: by mail-wr1-f72.google.com with SMTP id 91so2179321wro.1
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 08:45:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cjZxTnYiiQOiGbCeQOJMkwdfCCa6o8kDSXhq/4N/Y40=;
        b=GpFWCjxPr8TL6/aZp45Aa8xwNRgJec3eZ7RL9FQXkC5EzoNNdOcl3s6HM/ixpdL9V/
         ie0h4/Ww+8ny6Fw/3kXmGTTCK+fc81JIB/RYY0wG7s4zSGG11hPcwqNJr4IVtFNmp8eS
         2VmQt2Or7RLqH/iRZKehE9twumNzwNKnPgPZDsmJBYklnv5DNl9CDO4rdWcUQFUNn3Zs
         nhDDNocoiX5A+yE5VN219byaPRa38KFrxTsieEmNjyEGp2GY4dma5LVknOtc9ohFiX1y
         8K31+yCIBWvZr6MDvh/AfDpdpOabUchTLbx2rzVlLgZvMMfTHNNZZylVrwL86evq2WCk
         2+bA==
X-Gm-Message-State: AGi0PuYxYVYDC5G9ozYndJqIojgVgEHcvdOmtkLhftU31iMrZNpEuIXG
        iTAKf1m1rX/0moIH9X2x6Om9mTX1GPU+8ihN1HjIXhfMiduxJt8Pw0owvqWLcB+hoMvyyl/t31Y
        hFO+Ww8rQl9F6
X-Received: by 2002:a1c:741a:: with SMTP id p26mr2787408wmc.104.1586274358014;
        Tue, 07 Apr 2020 08:45:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypKESKYRIxOxNwNLbOzKtQVyp0wJ110m669FoTW85m3Hkw1+G3BjPPoxewjP5oIKFsLQEugm1A==
X-Received: by 2002:a1c:741a:: with SMTP id p26mr2787389wmc.104.1586274357706;
        Tue, 07 Apr 2020 08:45:57 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id n131sm2861031wmf.35.2020.04.07.08.45.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 08:45:57 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests v2] arch-run: Add reserved variables to the
 default environ
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     lvivier@redhat.com, thuth@redhat.com, david@redhat.com,
        frankja@linux.ibm.com
References: <20200407113312.65587-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ea6a1988-c718-f0a4-7428-e01ecffe00dd@redhat.com>
Date:   Tue, 7 Apr 2020 17:45:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200407113312.65587-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/20 13:33, Andrew Jones wrote:
> Add the already reserved (see README) variables to the default
> environ. To do so neatly we rework the environ creation a bit too.
> mkstandalone also learns to honor config.mak as to whether or not
> to make environs, and we allow the $ERRATATXT file to be selected
> at configure time.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
> 
> v2: Improve error handling of missing erratatxt files.
> 
>  configure               |  13 ++++-
>  scripts/arch-run.bash   | 125 +++++++++++++++++++++++++---------------
>  scripts/mkstandalone.sh |   9 ++-
>  3 files changed, 97 insertions(+), 50 deletions(-)
> 
> diff --git a/configure b/configure
> index 579765165fdf..5d2cd90cd180 100755
> --- a/configure
> +++ b/configure
> @@ -17,6 +17,7 @@ environ_default=yes
>  u32_long=
>  vmm="qemu"
>  errata_force=0
> +erratatxt="errata.txt"
>  
>  usage() {
>      cat <<-EOF
> @@ -37,6 +38,8 @@ usage() {
>  	    --[enable|disable]-default-environ
>  	                           enable or disable the generation of a default environ when
>  	                           no environ is provided by the user (enabled by default)
> +	    --erratatxt=FILE       specify a file to use instead of errata.txt. Use
> +	                           '--erratatxt=' to ensure no file is used.
>  EOF
>      exit 1
>  }
> @@ -85,6 +88,9 @@ while [[ "$1" = -* ]]; do
>  	--disable-default-environ)
>  	    environ_default=no
>  	    ;;
> +	--erratatxt)
> +	    erratatxt="$arg"
> +	    ;;
>  	--help)
>  	    usage
>  	    ;;
> @@ -94,6 +100,11 @@ while [[ "$1" = -* ]]; do
>      esac
>  done
>  
> +if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
> +    echo "erratatxt: $erratatxt does not exist or is not a regular file"
> +    exit 1
> +fi
> +
>  arch_name=$arch
>  [ "$arch" = "aarch64" ] && arch="arm64"
>  [ "$arch_name" = "arm64" ] && arch_name="aarch64"
> @@ -194,7 +205,7 @@ FIRMWARE=$firmware
>  ENDIAN=$endian
>  PRETTY_PRINT_STACKS=$pretty_print_stacks
>  ENVIRON_DEFAULT=$environ_default
> -ERRATATXT=errata.txt
> +ERRATATXT=$erratatxt
>  U32_LONG_FMT=$u32_long
>  EOF
>  
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index da1a9d7871e5..8348761d86ff 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -28,9 +28,9 @@ run_qemu ()
>  {
>  	local stdout errors ret sig
>  
> +	initrd_create || return $?
>  	echo -n "$@"
> -	initrd_create &&
> -		echo -n " #"
> +	[ "$ENVIRON_DEFAULT" = "yes" ] && echo -n " #"
>  	echo " $INITRD"
>  
>  	# stdout to {stdout}, stderr to $errors and stderr
> @@ -195,60 +195,91 @@ search_qemu_binary ()
>  
>  initrd_create ()
>  {
> -	local ret
> -
> -	env_add_errata
> -	ret=$?
> +	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
> +		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
> +		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
> +		export KVM_UNIT_TESTS_ENV=$(mktemp)
> +		env_params
> +		env_file
> +		env_errata || return $?
> +	fi
>  
>  	unset INITRD
>  	[ -f "$KVM_UNIT_TESTS_ENV" ] && INITRD="-initrd $KVM_UNIT_TESTS_ENV"
>  
> -	return $ret
> +	return 0
>  }
>  
> -env_add_errata ()
> +env_add_params ()
>  {
> -	local line errata ret=1
> +	local p
>  
> -	if [ -f "$KVM_UNIT_TESTS_ENV" ] && grep -q '^ERRATA_' <(env); then
> -		for line in $(grep '^ERRATA_' "$KVM_UNIT_TESTS_ENV"); do
> -			errata=${line%%=*}
> -			[ -n "${!errata}" ] && continue
> +	for p in "$@"; do
> +		if eval test -v $p; then
> +			eval export "$p"
> +		else
> +			eval export "$p="
> +		fi
> +		grep "^$p=" <(env) >>$KVM_UNIT_TESTS_ENV
> +	done
> +}
> +
> +env_params ()
> +{
> +	local qemu have_qemu
> +	local _ rest
> +
> +	qemu=$(search_qemu_binary) && have_qemu=1
> +
> +	if [ "$have_qemu" ]; then
> +		if [ -n "$ACCEL" ] || [ -n "$QEMU_ACCEL" ]; then
> +			[ -n "$ACCEL" ] && QEMU_ACCEL=$ACCEL
> +		fi
> +		QEMU_VERSION_STRING="$($qemu -h | head -1)"
> +		IFS='[ .]' read -r _ _ _ QEMU_MAJOR QEMU_MINOR QEMU_MICRO rest <<<"$QEMU_VERSION_STRING"
> +	fi
> +	env_add_params QEMU_ACCEL QEMU_VERSION_STRING QEMU_MAJOR QEMU_MINOR QEMU_MICRO
> +
> +	KERNEL_VERSION_STRING=$(uname -r)
> +	IFS=. read -r KERNEL_VERSION KERNEL_PATCHLEVEL rest <<<"$KERNEL_VERSION_STRING"
> +	IFS=- read -r KERNEL_SUBLEVEL KERNEL_EXTRAVERSION <<<"$rest"
> +	KERNEL_SUBLEVEL=${KERNEL_SUBLEVEL%%[!0-9]*}
> +	KERNEL_EXTRAVERSION=${KERNEL_EXTRAVERSION%%[!0-9]*}
> +	! [[ $KERNEL_SUBLEVEL =~ ^[0-9]+$ ]] && unset $KERNEL_SUBLEVEL
> +	! [[ $KERNEL_EXTRAVERSION =~ ^[0-9]+$ ]] && unset $KERNEL_EXTRAVERSION
> +	env_add_params KERNEL_VERSION_STRING KERNEL_VERSION KERNEL_PATCHLEVEL KERNEL_SUBLEVEL KERNEL_EXTRAVERSION
> +}
> +
> +env_file ()
> +{
> +	local line var
> +
> +	[ ! -f "$KVM_UNIT_TESTS_ENV_OLD" ] && return
> +
> +	for line in $(grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=' "$KVM_UNIT_TESTS_ENV_OLD"); do
> +		var=${line%%=*}
> +		if ! grep -q "^$var=" $KVM_UNIT_TESTS_ENV; then
>  			eval export "$line"
> -		done
> -	elif [ ! -f "$KVM_UNIT_TESTS_ENV" ]; then
> +			grep "^$var=" <(env) >>$KVM_UNIT_TESTS_ENV
> +		fi
> +	done
> +}
> +
> +env_errata ()
> +{
> +	if [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> +		echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
> +		return 2
> +	elif [ "$ERRATATXT" ]; then
>  		env_generate_errata
>  	fi
> -
> -	if grep -q '^ERRATA_' <(env); then
> -		export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
> -		export KVM_UNIT_TESTS_ENV=$(mktemp)
> -		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
> -		[ -f "$KVM_UNIT_TESTS_ENV_OLD" ] && grep -v '^ERRATA_' "$KVM_UNIT_TESTS_ENV_OLD" > $KVM_UNIT_TESTS_ENV
> -		grep '^ERRATA_' <(env) >> $KVM_UNIT_TESTS_ENV
> -		ret=0
> -	fi
> -
> -	return $ret
> +	sort <(env | grep '^ERRATA_') <(grep '^ERRATA_' $KVM_UNIT_TESTS_ENV) | uniq -u >>$KVM_UNIT_TESTS_ENV
>  }
>  
>  env_generate_errata ()
>  {
> -	local kernel_version_string=$(uname -r)
> -	local kernel_version kernel_patchlevel kernel_sublevel kernel_extraversion
>  	local line commit minver errata rest v p s x have
>  
> -	IFS=. read -r kernel_version kernel_patchlevel rest <<<"$kernel_version_string"
> -	IFS=- read -r kernel_sublevel kernel_extraversion <<<"$rest"
> -	kernel_sublevel=${kernel_sublevel%%[!0-9]*}
> -	kernel_extraversion=${kernel_extraversion%%[!0-9]*}
> -
> -	! [[ $kernel_sublevel =~ ^[0-9]+$ ]] && unset $kernel_sublevel
> -	! [[ $kernel_extraversion =~ ^[0-9]+$ ]] && unset $kernel_extraversion
> -
> -	[ "$ENVIRON_DEFAULT" != "yes" ] && return
> -	[ ! -f "$ERRATATXT" ] && return
> -
>  	for line in $(grep -v '^#' "$ERRATATXT" | tr -d '[:blank:]' | cut -d: -f1,2); do
>  		commit=${line%:*}
>  		minver=${line#*:}
> @@ -269,16 +300,16 @@ env_generate_errata ()
>  		! [[ $s =~ ^[0-9]+$ ]] && unset $s
>  		! [[ $x =~ ^[0-9]+$ ]] && unset $x
>  
> -		if (( $kernel_version > $v ||
> -		      ($kernel_version == $v && $kernel_patchlevel > $p) )); then
> +		if (( $KERNEL_VERSION > $v ||
> +		      ($KERNEL_VERSION == $v && $KERNEL_PATCHLEVEL > $p) )); then
>  			have=y
> -		elif (( $kernel_version == $v && $kernel_patchlevel == $p )); then
> -			if [ "$kernel_sublevel" ] && [ "$s" ]; then
> -				if (( $kernel_sublevel > $s )); then
> +		elif (( $KERNEL_VERSION == $v && $KERNEL_PATCHLEVEL == $p )); then
> +			if [ "$KERNEL_SUBLEVEL" ] && [ "$s" ]; then
> +				if (( $KERNEL_SUBLEVEL > $s )); then
>  					have=y
> -				elif (( $kernel_sublevel == $s )); then
> -					if [ "$kernel_extraversion" ] && [ "$x" ]; then
> -						if (( $kernel_extraversion >= $x )); then
> +				elif (( $KERNEL_SUBLEVEL == $s )); then
> +					if [ "$KERNEL_EXTRAVERSION" ] && [ "$x" ]; then
> +						if (( $KERNEL_EXTRAVERSION >= $x )); then
>  							have=y
>  						else
>  							have=n
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index c1ecb7f99cdc..9d506cc95072 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -36,7 +36,7 @@ generate_test ()
>  
>  	echo "#!/usr/bin/env bash"
>  	echo "export STANDALONE=yes"
> -	echo "export ENVIRON_DEFAULT=yes"
> +	echo "export ENVIRON_DEFAULT=$ENVIRON_DEFAULT"
>  	echo "export HOST=\$(uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/')"
>  	echo "export PRETTY_PRINT_STACKS=no"
>  
> @@ -59,7 +59,7 @@ generate_test ()
>  		echo 'export FIRMWARE'
>  	fi
>  
> -	if [ "$ERRATATXT" ]; then
> +	if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
>  		temp_file ERRATATXT "$ERRATATXT"
>  		echo 'export ERRATATXT'
>  	fi
> @@ -99,6 +99,11 @@ function mkstandalone()
>  	echo Written $standalone.
>  }
>  
> +if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> +	echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
> +	exit 2
> +fi
> +
>  trap 'rm -f $cfg' EXIT
>  cfg=$(mktemp)
>  
> 

Queued, thanks.

Paolo

