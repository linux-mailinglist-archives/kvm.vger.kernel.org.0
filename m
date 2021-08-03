Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2593DF4EB
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 20:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbhHCSp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 14:45:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239231AbhHCSp2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 14:45:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628016316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UvUhv+ZQ5f+lrSxqwGliv7yj8/wc9J7N0e9W712tbT4=;
        b=IWpQ9AfiduxK8/6fGnSbkDjdQgoWp63VWe3G1Np7MyG53yzJGjvVPH/oEEZmk3nBLd63KF
        /HjcV1jDDmglEmThH9Q69U9CoZ/ZTE06nsANE8dUgnZjbn16sBKh391PDmq7vOXp9pdcUg
        cZXdFkVCue2M4dz3lDKiLhXcdsvDRwU=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-0q1XIo1yPEGH3LFXQtmu5A-1; Tue, 03 Aug 2021 14:45:15 -0400
X-MC-Unique: 0q1XIo1yPEGH3LFXQtmu5A-1
Received: by mail-oi1-f197.google.com with SMTP id e17-20020a0568081491b02901f566a77bb8so9031209oiw.7
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 11:45:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UvUhv+ZQ5f+lrSxqwGliv7yj8/wc9J7N0e9W712tbT4=;
        b=imVw5wS3ndPIuOpWc29NSWAiVcN2oe6e5nsJ7j4uD1QHppfCiWt5OPbyhG74MWQuVA
         INhX5GflefDJZw8WJF88utEMYn4xcCBfGc6V+cHYz6NqvW/mXabMltcBHV3Ycx+BF+++
         BzKCl8Xs0WG2T+sYzeY+bYs0PSP69oJEnmkJqe75aD6siKLJOjJsC/995d4cemhJh18X
         lw1owWVs2CaTTl+jV7h9zwDFkLR0wOynEAgRqCaqN9nREjXFe9p+ii+8FR2skc0AaT5S
         9NFqMSnn/4hMmOOKaMBh9cCSoMT8QpKzbbnYDruumg0nUYacADbhTBmhNKj1uH0K+BS1
         vYdg==
X-Gm-Message-State: AOAM531t9Ocm30a6u7zyLCezWHWl/q+n0ncbJTUBUYqzlJevrkBbB1Dp
        1DAVaUW89cw/eFI7NwcHxufdlBBGTxAd18ySxm/tpz7RGUhIMiP5YThMITfqwpPqB5X/qzdkQdp
        ++QiJalM6hCwn
X-Received: by 2002:a9d:7310:: with SMTP id e16mr15998614otk.215.1628016314658;
        Tue, 03 Aug 2021 11:45:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2XltwJjoQjqVHZZ1XIFO619OUuvMfR70qmWfMpJEkHflkPBVTEgMMr4phWF3JwHKJSPKgRw==
X-Received: by 2002:a9d:7310:: with SMTP id e16mr15998606otk.215.1628016314517;
        Tue, 03 Aug 2021 11:45:14 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id f23sm461986oou.5.2021.08.03.11.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 11:45:14 -0700 (PDT)
Date:   Tue, 3 Aug 2021 12:45:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio: Use config not menuconfig for VFIO_NOIOMMU
Message-ID: <20210803124513.51267f67.alex.williamson@redhat.com>
In-Reply-To: <0-v1-3f0b685c3679+478-vfio_menuconfig_jgg@nvidia.com>
References: <0-v1-3f0b685c3679+478-vfio_menuconfig_jgg@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 16 Jul 2021 15:39:12 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> VFIO_NOIOMMU is supposed to be an element in the VFIO menu, not start
> a new menu. Correct this copy-paste mistake.
> 
> Fixes: 03a76b60f8ba ("vfio: Include No-IOMMU mode")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Just a minor loose patch to get out of the way
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 67d0bf4efa1606..e44bf736e2b222 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -29,7 +29,7 @@ menuconfig VFIO
>  
>  	  If you don't know what to do here, say N.
>  
> -menuconfig VFIO_NOIOMMU
> +config VFIO_NOIOMMU
>  	bool "VFIO No-IOMMU support"
>  	depends on VFIO
>  	help

Applied to vfio next branch for v5.15 with Connie's R-b.  Thanks,

Alex

