Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBB336EC88
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 16:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240111AbhD2OmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 10:42:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240062AbhD2OmU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 10:42:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619707293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xuXI8WbytCjzlShJ6hpRX4oLXXWI11SEtwQvo6ESyvo=;
        b=TRSJMpwYsgVM3myrMidKLx44c/6Oxh6dob7raC2XG4aAMG2AwAEH/IG3Ebj76pdybvOqGZ
        2p2eguB4PHGrkdK6/9B8IEObtefAFwvspPm8EsVzpwcvUOo2riINo4NfSQTx+r6aCRHRiO
        +hSZdAdyfhmZx/BpMzUrvoY8mV1sDp8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-7GxxX9H9Mp2GsvB6aarWyQ-1; Thu, 29 Apr 2021 10:41:31 -0400
X-MC-Unique: 7GxxX9H9Mp2GsvB6aarWyQ-1
Received: by mail-ed1-f69.google.com with SMTP id z12-20020aa7d40c0000b0290388179cc8bfso2678480edq.21
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 07:41:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xuXI8WbytCjzlShJ6hpRX4oLXXWI11SEtwQvo6ESyvo=;
        b=r6ftekbYjuZlFWWHrJDPwh2pBFjR6g3CZonEbQWjTN5VC8HlYEqpTqH3OEDLuelBHq
         Tnd2hoczvXQ8avQyYhz4jT3/5ccyaX756JeaXltPxzRKYWmv652Fr18VHYKHazZejrsf
         zvLxeEQ44ATLpZLKKFERNd4NncWOiP5NkI15ZNPAg4HrzVw7XoudSLyn+j6mBQSVLUIR
         TD3TTJ4ug+vYBCGI1x2DdTl5wmnAiw0j++zJnl59kctoYcfUomXxS8iH4BFppytNI3cU
         oGCmuLIjOUcRE3f9enRElgSECe9B7HuhXuU0NHV6xl5OkU3+nhvdMU0kNcsZf4+7edbb
         dibA==
X-Gm-Message-State: AOAM533jlLaaYs9fk+sSlR25JAfAtUAW9mc8SlQsIgpnsBXb8YyxVBud
        iRa7uYDFwaMdFq8ggBOvkWl2MPKrhE2CdYNs+gk7YqfBzKMc+l9YxheXe4RottLsw/GlwDJX9Ze
        X50to4iN2HpCx
X-Received: by 2002:a05:6402:5203:: with SMTP id s3mr18501774edd.360.1619707290339;
        Thu, 29 Apr 2021 07:41:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrIL7coZCsSIfxJlhgbwG2Z8UKHVm79pl60hkgoMG718BNmVPQQZ8S+x3fVv7iMrnwUFgfzQ==
X-Received: by 2002:a05:6402:5203:: with SMTP id s3mr18501753edd.360.1619707290118;
        Thu, 29 Apr 2021 07:41:30 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id g22sm99240ejz.46.2021.04.29.07.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 07:41:29 -0700 (PDT)
Date:   Thu, 29 Apr 2021 16:41:27 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3] configure: arm: Replace --vmm with
 --target
Message-ID: <20210429144127.anb26s7hrfpwarjf@gator>
References: <20210429141204.51848-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429141204.51848-1-alexandru.elisei@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021 at 03:12:04PM +0100, Alexandru Elisei wrote:
> The --vmm configure option was added to distinguish between the two virtual
> machine managers that kvm-unit-tests supports for the arm and arm64
> architectures, qemu or kvmtool. There are plans to make kvm-unit-tests work
> as an EFI app, which will require changes to the way tests are compiled.
> Instead of adding a new configure option specifically for EFI and have it
> coexist with --vmm, or overloading the semantics of the existing --vmm
> option, let's replace --vmm with the more generic name --target.
> 
> Since --target is only valid for arm and arm64, reject the option when it's
> specified for another architecture, which is how --vmm should have behaved
> from the start.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> Changes in v3:
> 
> * Using --target for any architecture other than arm and arm64 generates an
>   error.
> * Don't generate the TARGET variable in config.mak for other architectures.
> * Cosmetic changes to the commit message.
> 
> Changes in v2:
> 
> * Removed the RFC tag and cover letter.
> * Removed --vmm entirely.
> 
>  configure | 32 +++++++++++++++++++++++---------
>  1 file changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/configure b/configure
> index 01a0b262a9f2..d5d223fe3a90 100755
> --- a/configure
> +++ b/configure
> @@ -21,7 +21,7 @@ pretty_print_stacks=yes
>  environ_default=yes
>  u32_long=
>  wa_divide=
> -vmm="qemu"
> +target=
>  errata_force=0
>  erratatxt="$srcdir/errata.txt"
>  host_key_document=
> @@ -35,8 +35,8 @@ usage() {
>  	Options include:
>  	    --arch=ARCH            architecture to compile for ($arch)
>  	    --processor=PROCESSOR  processor to compile for ($arch)
> -	    --vmm=VMM              virtual machine monitor to compile for (qemu
> -	                           or kvmtool, default is qemu) (arm/arm64 only)
> +	    --target=TARGET        target platform that the tests will be running on (qemu or
> +	                           kvmtool, default is qemu) (arm/arm64 only)
>  	    --cross-prefix=PREFIX  cross compiler prefix
>  	    --cc=CC		   c compiler to use ($cc)
>  	    --ld=LD		   ld linker to use ($ld)
> @@ -58,7 +58,7 @@ usage() {
>  	    --earlycon=EARLYCON
>  	                           Specify the UART name, type and address (optional, arm and
>  	                           arm64 only). The specified address will overwrite the UART
> -	                           address set by the --vmm option. EARLYCON can be one of
> +	                           address set by the --target option. EARLYCON can be one of
>  	                           (case sensitive):
>  	               uart[8250],mmio,ADDR
>  	                           Specify an 8250 compatible UART at address ADDR. Supported
> @@ -88,8 +88,8 @@ while [[ "$1" = -* ]]; do
>          --processor)
>  	    processor="$arg"
>  	    ;;
> -	--vmm)
> -	    vmm="$arg"
> +	--target)
> +	    target="$arg"
>  	    ;;
>  	--cross-prefix)
>  	    cross_prefix="$arg"
> @@ -146,6 +146,15 @@ arch_name=$arch
>  [ "$arch" = "aarch64" ] && arch="arm64"
>  [ "$arch_name" = "arm64" ] && arch_name="aarch64"
>  
> +if [ -z "$target" ]; then
> +    target="qemu"
> +else
> +    if [ "$arch" != "arm64" ] && [ "$arch" != "arm" ]; then
> +        echo "--target is not supported for $arch"
> +        usage
> +    fi
> +fi
> +
>  if [ -z "$page_size" ]; then
>      [ "$arch" = "arm64" ] && page_size="65536"
>      [ "$arch" = "arm" ] && page_size="4096"
> @@ -177,13 +186,13 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
>      testdir=x86
>  elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>      testdir=arm
> -    if [ "$vmm" = "qemu" ]; then
> +    if [ "$target" = "qemu" ]; then
>          arm_uart_early_addr=0x09000000
> -    elif [ "$vmm" = "kvmtool" ]; then
> +    elif [ "$target" = "kvmtool" ]; then
>          arm_uart_early_addr=0x3f8
>          errata_force=1
>      else
> -        echo '--vmm must be one of "qemu" or "kvmtool"!'
> +        echo '--target must be one of "qemu" or "kvmtool"!'

I switched the quotes from " to ', e.g. 'qemu'.

>          usage
>      fi
>  
> @@ -318,6 +327,11 @@ WA_DIVIDE=$wa_divide
>  GENPROTIMG=${GENPROTIMG-genprotimg}
>  HOST_KEY_DOCUMENT=$host_key_document
>  EOF
> +if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
> +cat <<EOF >> config.mak
> +TARGET=$target
> +EOF

I changed this to

    echo "TARGET=$target" >> config.mak

> +fi
>  
>  cat <<EOF > lib/config.h
>  #ifndef CONFIG_H
> -- 
> 2.31.1
> 

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew

