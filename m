Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A5236CA1C
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 19:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbhD0RLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 13:11:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236392AbhD0RLB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 13:11:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619543417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C2Sf4ABwZ69tuh9yBcDqXJGyy1ZZ54o5G9Q7ZZIQnos=;
        b=DhkmgBXt3cerMLAQnITvjbEB/RAKAhH281O8fBYrEWFkn4qbVm3gfcCVcaGoBM4ULLQnIs
        EpC6pLpu5koGILrbyOZ9MeA5bQSqsTweaVoEFvVfJGDzjSTg2skzd2rLmawuT+qFbq4Akk
        SgRF20H67uyCOMHR+gzPOKzvtvQJSi8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-KdB6NBnWMKSi-cfGXrcllw-1; Tue, 27 Apr 2021 13:10:15 -0400
X-MC-Unique: KdB6NBnWMKSi-cfGXrcllw-1
Received: by mail-ej1-f70.google.com with SMTP id ji8-20020a1709079808b029037c921a9ea0so11475941ejc.9
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 10:10:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C2Sf4ABwZ69tuh9yBcDqXJGyy1ZZ54o5G9Q7ZZIQnos=;
        b=aPuOJAmoN2QfbinlGzhEAE+yHunIgmTrZrcdXP+5TpQWMSoRGP5egNP3e2IDbqwt3y
         9JjMT7/Ee6he2jrXAdHYkEf2XCPEl64C6E3b4nDjieA2D66SJhuAufQGQj+dTDOP0pVb
         4aZ7+Oh5+GFzb4Fsctnwds9d3OEZK025B0/ByJLBsUKVvUtYJrUBPM3HuD6hzlQD7uhH
         h53UpjRCRLhK/3kUiZtayPkEV2PV8CISXv4yCBsnmYMEe2x06XQHG5aSUVcp7/ePz6x1
         rPrvbqW2oZ35B/JClFdxlf+cOdTnZzj+FTINsMHqjlxWpvPHN2BNbwt5Qm6ZMP+LhlNp
         SVVw==
X-Gm-Message-State: AOAM530d1fs9UPSRekBW1LubTBdswfTTB/e4Jz4TnUsJ1eKhTuNkGul5
        9GheGHQvQ0BOiG7g9IFie/6WomtJu95Puzd+h4iFQMdYlGtjOwNHYb79qcHRzSYt2ZqsUNYp+tB
        PJcaQOnCIf/8W
X-Received: by 2002:a05:6402:3109:: with SMTP id dc9mr5677606edb.13.1619543413953;
        Tue, 27 Apr 2021 10:10:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB1bTSrBv7eL5ESsqyHUsok/cKDQZo8Jx2cXyrR0WSAdcEfUJ7kBZIiCmgxEChxnhyKT/ArA==
X-Received: by 2002:a05:6402:3109:: with SMTP id dc9mr5677588edb.13.1619543413796;
        Tue, 27 Apr 2021 10:10:13 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id hd30sm270127ejc.59.2021.04.27.10.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 10:10:13 -0700 (PDT)
Date:   Tue, 27 Apr 2021 19:10:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] configure: arm: Replace --vmm with
 --target
Message-ID: <20210427171011.ymu7j5sen76c4xb3@gator.home>
References: <20210427163437.243839-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427163437.243839-1-alexandru.elisei@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 05:34:37PM +0100, Alexandru Elisei wrote:
> The --vmm configure option was added to distinguish between the two virtual
> machine managers that kvm-unit-tests supports, qemu or kvmtool. There are
> plans to make kvm-unit-tests work as an EFI app, which will require changes
> to the way tests are compiled. Instead of adding a new configure option
> specifically for EFI and have it coexist with --vmm, or overloading the
> semantics of the existing --vmm option, let's replace --vmm with the more
> generic name --target.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> Changes in v2:
> 
> * Removed the RFC tag and cover letter.
> * Removed --vmm entirely.
> 
>  configure | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/configure b/configure
> index 01a0b262a9f2..08c6afdf952c 100755
> --- a/configure
> +++ b/configure
> @@ -21,7 +21,7 @@ pretty_print_stacks=yes
>  environ_default=yes
>  u32_long=
>  wa_divide=
> -vmm="qemu"
> +target="qemu"
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
> @@ -177,13 +177,13 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
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
>          usage
>      fi
>  
> @@ -317,6 +317,7 @@ U32_LONG_FMT=$u32_long
>  WA_DIVIDE=$wa_divide
>  GENPROTIMG=${GENPROTIMG-genprotimg}
>  HOST_KEY_DOCUMENT=$host_key_document
> +TARGET=$target

We should only emit this TARGET=qemu to the config.mak when we're
arm/arm64, since that's what the help text says. Also, because the help
text says that the --target option is only for arm/arm64, then configure
should error out if it's used with another architecture. The nice thing
about this rename is that we can get that right this time. We didn't error
out with --vmm, but we should have. Erroring out on an unsupported
feature allows us to add support for it later without the users having
to guess if it'll work or not.

Thanks,
drew

>  EOF
>  
>  cat <<EOF > lib/config.h
> -- 
> 2.31.1
> 

