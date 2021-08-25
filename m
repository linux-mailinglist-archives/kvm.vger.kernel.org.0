Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB8D3F6CAC
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 02:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbhHYAjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 20:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHYAjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 20:39:06 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C52C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:38:22 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id l3so18452977qtk.10
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/5QAdz/36Etr/KRXNdd87P9Q+NwJprB8ae9RU61bFHo=;
        b=lAL9RxlursJQLIDDG+P1VwiGIxOri0QPqhLBrcEX5l0stAjssgPXOVDJ/B+YmvW0LI
         pVauBDVwDgRTUIbvzCUesSt7YCjOLBU4UHlD+6UQazsnOCDS0H0J7EpChZ2DPmQeTXeK
         8vJ2h+ihxK9NX52XsZ40Qii6YAvswOI8ZQNuupjMHt1h0QkPveLFGdWVtiZAIxd01/qT
         ZGJRFXE65y9aVRRWO5F+G5NlnWMue7PShP2XKrWCxpScaVGU7UYlWQAhscNmwokuGldB
         QVrvydrlL96QFbwg6P4EM0Zl9JkV5wg0rGABToF9L6YrCzRwt/xlqGxF6gQSkWpZ/oZZ
         NGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/5QAdz/36Etr/KRXNdd87P9Q+NwJprB8ae9RU61bFHo=;
        b=ddjaIU8d7xJ28Sxzmf33Tt8cmreE1TrRaFPhOhgIK2rKyRL3FGtKfHr7QuCfoVxuRW
         2bzqmTqmbc6VwjUI90eRePamtMSOcE66QH7lAw1mV6HpYc2YJQMPDVPl5OQZmMmt5hjQ
         +tff6xzDkxPFMwOXgrn1ooCuDNedaymNkH7OrkMN75usLg9uRyvSmf3uNR72imeat+ec
         SKP/Zzn4JFDkNsscVZnvtQ9nu4hPEU/dwZbuxTyi+35nlVIUCBQPSCeYC5Kxdh0RxJ3n
         AiwicXuughTXedZYafulOuI5SBpzyodg1R4Xzq8B47i7HF+kT/L2Y2M4t2rK/Si++sq1
         MEOA==
X-Gm-Message-State: AOAM531EQofY9E6USPvnv46LfbtOMYJ3ICqmLjyXVpNh7gwftwhbSvOC
        NdOzUJ5BTbfhNDFzmDLslbUCYA==
X-Google-Smtp-Source: ABdhPJwOQYc2Qwuodyc7XL/LUq4nCtsbt9De2eRssJqMRurOW54QZi2mTUC9MuuNe4cVlRzdERA0+A==
X-Received: by 2002:ac8:65cc:: with SMTP id t12mr35256484qto.245.1629851901241;
        Tue, 24 Aug 2021 17:38:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id z6sm11760694qke.24.2021.08.24.17.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:38:20 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIgvs-004jIs-7f; Tue, 24 Aug 2021 21:38:20 -0300
Date:   Tue, 24 Aug 2021 21:38:20 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 14/14] vfio/iommu_type1: remove
 IS_IOMMU_CAP_DOMAIN_IN_CONTAINER
Message-ID: <20210825003820.GU543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-15-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:49PM +0200, Christoph Hellwig wrote:
> IS_IOMMU_CAP_DOMAIN_IN_CONTAINER just obsfucated the checks being
> performed, so open code it in the callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
