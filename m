Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834583C60B0
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 18:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhGLQjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 12:39:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhGLQjl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 12:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626107812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MtrPeL1MW5g9H7qmJOUpT+3Y4CWR41HGQODgw/zxeBs=;
        b=gRVYqrRYr/O0Xs8gh7WUoBjPIfvrJs0fyabPdf3ks++Wj1nPANLMChPL0eQLhAdeHU/p10
        o9qmLGAZ7xRxCPopJ5w+vk9E4gG4ZGU9LnWPoIVd2DyIF1r6SABVO7mMO5FH2k0nyfx3Hp
        DFqvO9n0FGFo/dEunRiIGMEOcwHlKYc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-lmNCuTAOPZCAKX7TMJZMdQ-1; Mon, 12 Jul 2021 12:36:51 -0400
X-MC-Unique: lmNCuTAOPZCAKX7TMJZMdQ-1
Received: by mail-il1-f197.google.com with SMTP id s12-20020a056e02216cb02901f9cee02769so5762842ilv.11
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 09:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MtrPeL1MW5g9H7qmJOUpT+3Y4CWR41HGQODgw/zxeBs=;
        b=L0hR3SrmTrh0woIb1em8WatiZdkiYkmJXIqxDy4mPeaCAMtCj8NWGP9YYAfzqhSc5Q
         k2uLOmVrPlE6/f5xrJa6pE3e0YKchWsHa8PnM+sk1ZVcW0NtkY9X/1pujjv8i7Y369Hv
         CHgUF+PKeZiWXZaahumAJfNtbd5A/0uBdXmdQYP1rf693gfusLHp/qy1oDj6p+rDq5Yp
         OrUtIcQno5XuRhQClUI894z2PUGg/E6lXeJcrrDc20tSh59KZ43Ub0yFT9ONQparlS26
         sz74V3pj8yvre9tISeHlb2k3dXkA0/q/3fUL3j6CgpSd04UzoyWlTwT1Dq0LwCb0xWl3
         Teag==
X-Gm-Message-State: AOAM531QnNwttp9ImpNzKZR1kmSHEuqwg9c6/TCRpFm/GyiNb5n0VB/d
        8NNs4tR+lZ96UQ82j38bZb+/uZEaQBv3v9qkcpOM6kRIJoRETv5B3r5Z3mOiHm+3giR5GLDtw75
        nxvZppyLZ/K7w
X-Received: by 2002:a05:6638:3594:: with SMTP id v20mr44398387jal.25.1626107810375;
        Mon, 12 Jul 2021 09:36:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfZs7GgsE/lzYFDtyQMKvJJdBgqUsxHSeDXSOj4Dft5q8ck5jfD4jmnOq1o4WYVKlXhNT6cA==
X-Received: by 2002:a05:6638:3594:: with SMTP id v20mr44398375jal.25.1626107810195;
        Mon, 12 Jul 2021 09:36:50 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id m24sm8288360ion.3.2021.07.12.09.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 09:36:49 -0700 (PDT)
Date:   Mon, 12 Jul 2021 18:36:47 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com,
        kvm-ppc@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        maz@kernel.org, vivek.gautam@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 1/5] lib: arm: Print test exit status
 on exit if chr-testdev is not available
Message-ID: <20210712163647.oxntpjapur4z23sl@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702163122.96110-2-alexandru.elisei@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021 at 05:31:18PM +0100, Alexandru Elisei wrote:
> The arm64 tests can be run under kvmtool, which doesn't emulate a
> chr-testdev device. In preparation for adding run script support for
> kvmtool, print the test exit status so the scripts can pick it up and
> correctly mark the test as pass or fail.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/chr-testdev.h |  1 +
>  lib/arm/io.c      | 10 +++++++++-
>  lib/chr-testdev.c |  5 +++++
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
> index ffd9a851aa9b..09b4b424670e 100644
> --- a/lib/chr-testdev.h
> +++ b/lib/chr-testdev.h
> @@ -11,4 +11,5 @@
>   */
>  extern void chr_testdev_init(void);
>  extern void chr_testdev_exit(int code);
> +extern bool chr_testdev_available(void);
>  #endif
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 343e10822263..9e62b571a91b 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -125,7 +125,15 @@ extern void halt(int code);
>  
>  void exit(int code)
>  {
> -	chr_testdev_exit(code);
> +	if (chr_testdev_available()) {
> +		chr_testdev_exit(code);

chr_testdev_exit() already has a 'if !vcon goto out' in it, so you can
just call it unconditionally. No need for chr_testdev_available().

> +	} else {
> +		/*
> +		 * Print the test return code in the format used by chr-testdev
> +		 * so the runner script can parse it.
> +		 */
> +		printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
> +	}
>  	psci_system_off();
>  	halt(code);
>  	__builtin_unreachable();
> diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
> index b3c641a833fe..301e73a6c064 100644
> --- a/lib/chr-testdev.c
> +++ b/lib/chr-testdev.c
> @@ -68,3 +68,8 @@ void chr_testdev_init(void)
>  	in_vq = vqs[0];
>  	out_vq = vqs[1];
>  }
> +
> +bool chr_testdev_available(void)
> +{
> +	return vcon != NULL;
> +}
> -- 
> 2.32.0
>

Thanks,
drew 

