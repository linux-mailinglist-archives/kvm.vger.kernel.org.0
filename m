Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42118204590
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 02:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732014AbgFWAeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 20:34:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44669 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731959AbgFWAeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 20:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592872462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rKCACp1pp0svcRKAl5T0TGaQyVIj2FJ3eEL22BVoN6g=;
        b=NwgnLvyef3knu2oJqlotSicI+oSGldR5MJyyAFCpEEbYrVgaipNPEpDK2ZdvEQ4TWc8Cus
        PQ5Ys7eup+HzGdiBfiAuWIMpLC2EdTNA0JKcGjWXf90QcF5zeBXfA3CpuGvBEn3gQLqe60
        Ipedlb1mC+mqzd0Q7/6YoZUUh/q6VU0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-SJzMmwVzNsG1Knx2BJuudQ-1; Mon, 22 Jun 2020 20:34:20 -0400
X-MC-Unique: SJzMmwVzNsG1Knx2BJuudQ-1
Received: by mail-wr1-f71.google.com with SMTP id z3so6440789wrr.7
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 17:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rKCACp1pp0svcRKAl5T0TGaQyVIj2FJ3eEL22BVoN6g=;
        b=UbvEwermxmDlkokL0ZLsBy8Ra7cSmU0Rht7FfXfnfeW7Vu7cBkgpW5tIZovA+XYwKG
         H1kl6RqaT0tG8sfJ6AaH9SLbu68/I7gqt+7Lu9jTCABR1LSw3mKQ7eyU7Wx6ItjX9iVN
         vyFol06PRPG7Dd/5ZB3gk5MJSbZA6cwsBVCjm/bzS9VfFfiNV3x5+kqG/udC0bzwGHFm
         SKXOGTQfR4wWN+3aBkfqKmUPQ9tBnFAqd/GF4akwKo32i6B49SH7IMTS9tAIcluuOO7p
         CuMj5MOTlrO0ZrpLYiqqyagGRjsgDL1mmZ6a47/Jt1rfM92/+Ygqt3ESISgAFjxpeXOa
         y0Ow==
X-Gm-Message-State: AOAM5331RqA/jDtqYx5ja5SKceBkE/ZF4RwltzLqO/m4kEuy1aH42Gct
        3nOmtF/pCJ56orX8x9bV8eGVkLz+L/wAaED/SIDMwnMandlcGz4oWZUitDWbUWmDslknpWnydMa
        clzrodS3WDsxy
X-Received: by 2002:a05:6000:1190:: with SMTP id g16mr12744187wrx.286.1592872459330;
        Mon, 22 Jun 2020 17:34:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9NEZQYujEBQjfuQ4n0S3Qvkhi0Zk5ugAodZHawa47DX5pWfq/XWtyaxlBr6Ujubq9wPSpxA==
X-Received: by 2002:a05:6000:1190:: with SMTP id g16mr12744167wrx.286.1592872459078;
        Mon, 22 Jun 2020 17:34:19 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id d201sm1328768wmd.34.2020.06.22.17.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 17:34:18 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] Fix out-of-tree builds
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>
References: <20200511070641.23492-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9ed1d7f8-9d3b-54a0-5c7d-e29856d12d79@redhat.com>
Date:   Tue, 23 Jun 2020 02:34:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200511070641.23492-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/05/20 09:06, Andrew Jones wrote:
> Since b16df9ee5f3b out-of-tree builds have been broken because we
> started validating the newly user-configurable $erratatxt file
> before linking it into the build dir. We fix this not by moving
> the validation, but by removing the linking and instead using the
> full path of the $erratatxt file. This allows one to keep that file
> separate from the src and build dirs.
> 
> Fixes: b16df9ee5f3b ("arch-run: Add reserved variables to the default environ")
> Reported-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  configure | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/configure b/configure
> index 5d2cd90cd180..f9d030fd2f03 100755
> --- a/configure
> +++ b/configure
> @@ -17,7 +17,7 @@ environ_default=yes
>  u32_long=
>  vmm="qemu"
>  errata_force=0
> -erratatxt="errata.txt"
> +erratatxt="$srcdir/errata.txt"
>  
>  usage() {
>      cat <<-EOF
> @@ -89,7 +89,8 @@ while [[ "$1" = -* ]]; do
>  	    environ_default=no
>  	    ;;
>  	--erratatxt)
> -	    erratatxt="$arg"
> +	    erratatxt=
> +	    [ "$arg" ] && erratatxt=$(eval realpath "$arg")
>  	    ;;
>  	--help)
>  	    usage
> @@ -169,9 +170,6 @@ if test ! -e Makefile; then
>  
>      echo "linking scripts..."
>      ln -sf "$srcdir/scripts"
> -
> -    echo "linking errata.txt..."
> -    ln -sf "$srcdir/errata.txt"
>  fi
>  
>  # link lib/asm for the architecture
> 

Pushed, thanks.

Paolo

