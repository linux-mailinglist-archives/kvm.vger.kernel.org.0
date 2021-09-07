Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD1840271E
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 12:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhIGK0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 06:26:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232704AbhIGK0r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 06:26:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631010340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YkR6zwo7S5sLkEP3Hl3y8Gt+KIK6HBJlddNqv1cks4k=;
        b=cfwsFXwEPTJ6sEweVQxvKrjHf84Somzk53aAWWZtPeEuL+0ZicFJta/XDrUTOFZ2oLoiMF
        gg9wzVF5eQl9zV2yo5EoeFZ610krN50Ti03B1rRcQHR/x2CVVerNy4541CnRiEGS8JiUZI
        +JQCpw+bkbOMHImcDDS/YfhlRG08RSU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-4CTBFcn4NGasrMNDrAGobg-1; Tue, 07 Sep 2021 06:25:39 -0400
X-MC-Unique: 4CTBFcn4NGasrMNDrAGobg-1
Received: by mail-wm1-f71.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so3219597wmj.8
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 03:25:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YkR6zwo7S5sLkEP3Hl3y8Gt+KIK6HBJlddNqv1cks4k=;
        b=HXLCI+Xr1I32Ofol3/sWU1PEJ13u+qBJQie4Ow4Ec9mFEmJjtnJu+8+gd+n3d/MzZ+
         Y3F1EMQnQ0yhcAYOP8Q6mIM5Xq2Qmu/NWuvfbKyKaCjMfZy624jVOFD+FRlouPKHya3u
         9xIpmkjpnRVm8U+ngHMArnoFRw6ivlcje7E4IEISxVEaodqgBbJAz5VVV5J06yGCfXNr
         cVXM1vrecM/RESSDBr/7xYbHeE0et08FNA8ajVHvjUx87+m4mPrpreCVqJ6iY6WZ1kPx
         D1yqaMcbs3QsA53R0pi2828PjE3Y97DUxSwY9ZNZuOMq/TPbdI1eDEzfIHDXiCL24Dcc
         pnbA==
X-Gm-Message-State: AOAM53385+KEcyL6h4TSCIAt6fxNjkNnZ75mFh+uZytNhFoGKgjkSn3u
        3Lr0WDXPYHgjHogjIKQ4LkvrEq+eJ7NOr05KLmySMWOMKNIDD39ufgtZrdgziWmS7+JF0KMrHaH
        B6uIaeIz1OFxu
X-Received: by 2002:a5d:6486:: with SMTP id o6mr17366341wri.193.1631010338760;
        Tue, 07 Sep 2021 03:25:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSuexDTec5nPjCkxud+p5tgz5pAvum9LG2zR+d+af/JuudrOVT+AYs0JNtNTuoPUbk+lGqwQ==
X-Received: by 2002:a5d:6486:: with SMTP id o6mr17366315wri.193.1631010338595;
        Tue, 07 Sep 2021 03:25:38 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id t11sm2252710wmi.23.2021.09.07.03.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 03:25:38 -0700 (PDT)
Date:   Tue, 7 Sep 2021 12:25:36 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com,
        kvm-ppc@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        maz@kernel.org, vivek.gautam@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 5/5] configure: Ignore --erratatxt
 when --target=kvmtool
Message-ID: <20210907102536.jhycvnazlmj7qyto@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-6-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702163122.96110-6-alexandru.elisei@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021 at 05:31:22PM +0100, Alexandru Elisei wrote:
> kvmtool runs a test using the -f/--firmware argument, which doesn't load an
> initrd, making specifying an errata file useless. Instead, configure forces
> all erratas to be enabled via the CONFIG_ERRATA_FORCE define in
> lib/config.h.
> 
> Forbid the --erratatxt option when kvm-unit-tests is configured for kvmtool
> and let the user know that all erratas are enabled by default.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> I'm not sure if printing an error is too strong here and a simple warning would
> suffice. Suggestions welcome!
> 
>  configure | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/configure b/configure
> index 395c809c9c02..acd288239f80 100755
> --- a/configure
> +++ b/configure
> @@ -24,7 +24,8 @@ u32_long=
>  wa_divide=
>  target=
>  errata_force=0
> -erratatxt="$srcdir/errata.txt"
> +erratatxt_default="$srcdir/errata.txt"
> +erratatxt="_NO_FILE_4Uhere_"
>  host_key_document=
>  page_size=
>  earlycon=
> @@ -50,7 +51,8 @@ usage() {
>  	                           enable or disable the generation of a default environ when
>  	                           no environ is provided by the user (enabled by default)
>  	    --erratatxt=FILE       specify a file to use instead of errata.txt. Use
> -	                           '--erratatxt=' to ensure no file is used.
> +	                           '--erratatxt=' to ensure no file is used. This option is
> +	                           invalid for arm/arm64 when target=kvmtool.

Do we need to always specifiy arm/arm64 when talking about target=kvmtool?
How much more effort would an x86 kvmtool target be to add?

>  	    --host-key-document=HOST_KEY_DOCUMENT
>  	                           Specify the machine-specific host-key document for creating
>  	                           a PVM image with 'genprotimg' (s390x only)
> @@ -147,11 +149,6 @@ if [ -n "$host_key_document" ] && [ ! -f "$host_key_document" ]; then
>      exit 1
>  fi
>  
> -if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
> -    echo "erratatxt: $erratatxt does not exist or is not a regular file"
> -    exit 1
> -fi
> -
>  arch_name=$arch
>  [ "$arch" = "aarch64" ] && arch="arm64"
>  [ "$arch_name" = "arm64" ] && arch_name="aarch64"
> @@ -184,6 +181,21 @@ else
>      fi
>  fi
>  
> +if [ "$target" = "kvmtool" ]; then
> +    if [ "$erratatxt" ] && [ "$erratatxt" != "_NO_FILE_4Uhere_" ]; then
> +        echo "--erratatxt is not supported for target=kvmtool (all erratas enabled by default)"
> +        usage
> +    fi
> +else
> +    if [ "$erratatxt" = "_NO_FILE_4Uhere_" ]; then
> +        erratatxt=$erratatxt_default
> +    fi
> +    if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
> +        echo "erratatxt: $erratatxt does not exist or is not a regular file"
> +        exit 1
> +    fi
> +fi

switch

> +
>  [ -z "$processor" ] && processor="$arch"
>  
>  if [ "$processor" = "arm64" ]; then
> -- 
> 2.32.0
>

Otherwise looks good to me.

Thanks,
drew 

