Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C29D417B31
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 20:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346349AbhIXSje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 14:39:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345615AbhIXSje (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 14:39:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632508679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8izOp3w0kyjaONGOd6G+dgaLPoBS4GfuW3k+OdP5y4=;
        b=foilflFlm3bZLVfX49tdUrlm4CxnptuIrTXFw5wAH9xbpyeA82Qh+A84dZoe2XgYqkZH0A
        USzjcf7WW6OLbv3vDBQ/c3YymuCbFwIjFPmZUeuf92VxWds/TaNzP/IRHQm31Ug8oByHVp
        cQ4MgLGEU8SAjv0aua9Bd1b3ByYD56E=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-k1x5pN_fNv6JsGLt6VS0xQ-1; Fri, 24 Sep 2021 14:37:58 -0400
X-MC-Unique: k1x5pN_fNv6JsGLt6VS0xQ-1
Received: by mail-ot1-f70.google.com with SMTP id k21-20020a9d7015000000b0054d5b451decso1171898otj.3
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 11:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p8izOp3w0kyjaONGOd6G+dgaLPoBS4GfuW3k+OdP5y4=;
        b=ZdA56D0K/BNcRCxCosd4D0HCuk6DEZByIo6pzdJeWFl8Mt4k4EkUXm0hSEkd62dkKs
         LPt8hS1zuoEIKmLZKXcrsxAUktOdExbPcDIAvN2tw23XYqL2bYIPsNal4t5XeBo31ZLw
         iydRHq6PS6RMrWI9g/esGWsUKAMuig9MwBMVYx8EGSU0rzdB5tLp3at8sr+sv2h8cx6M
         GLtxrNwdkD0RSAZ6U3AkrfNl5eFhovR4KYdnax21ewolkWCbnU3Kcff8D7r66yhDOHHp
         QqYXPXD0dLrkBcmaJezS8Wb1Kx34QSNwMA1e6ock4hT32tJme/GTnF6scarYAoQqwkC3
         hgdA==
X-Gm-Message-State: AOAM531cg3RqwhiKekcDnNrclvOZusxxBRT3KPtC11o8I0QmMOcSqlmj
        41dVbrTNKhyq7Nd7VS/ZTsxf4jtGbEutLm2m92F5vLp8M8DowyzCKa6Bm3EWnR31FaUSX/Znzn3
        EWKGJ2xGUoZ1G
X-Received: by 2002:a05:6830:13c2:: with SMTP id e2mr5417059otq.160.1632508677760;
        Fri, 24 Sep 2021 11:37:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+xTO/WIrlRoeZRSdG41a20dNxAhKJvL50z9NlXenoNRhwPFaBqjtq3aAnciKS6L9jmFMbdg==
X-Received: by 2002:a05:6830:13c2:: with SMTP id e2mr5417035otq.160.1632508677368;
        Fri, 24 Sep 2021 11:37:57 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id 21sm2362872oix.1.2021.09.24.11.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 11:37:57 -0700 (PDT)
Date:   Fri, 24 Sep 2021 12:37:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 13/15] vfio/iommu_type1: initialize pgsize_bitmap in
 ->open
Message-ID: <20210924123755.76041ee0.alex.williamson@redhat.com>
In-Reply-To: <20210924174852.GZ3544071@ziepe.ca>
References: <20210924155705.4258-1-hch@lst.de>
        <20210924155705.4258-14-hch@lst.de>
        <20210924174852.GZ3544071@ziepe.ca>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Sep 2021 14:48:52 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, Sep 24, 2021 at 05:57:03PM +0200, Christoph Hellwig wrote:
> > Ensure pgsize_bitmap is always valid by initializing it to ULONG_MAX
> > in vfio_iommu_type1_open and remove the now pointless update for
> > the external domain case in vfio_iommu_type1_attach_group, which was
> > just setting pgsize_bitmap to ULONG_MAX when only external domains
> > were attached.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> >  drivers/vfio/vfio_iommu_type1.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index a48e9f597cb213..2c698e1a29a1d8 100644
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -2196,7 +2196,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> >  		if (!iommu->external_domain) {
> >  			INIT_LIST_HEAD(&domain->group_list);
> >  			iommu->external_domain = domain;
> > -			vfio_update_pgsize_bitmap(iommu);
> >  		} else {
> >  			kfree(domain);
> >  		}
> > @@ -2582,6 +2581,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
> >  	mutex_init(&iommu->lock);
> >  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
> >  	init_waitqueue_head(&iommu->vaddr_wait);
> > +	iommu->pgsize_bitmap = ULONG_MAX;  
> 
> I wonder if this needs the PAGE_MASK/SIZE stuff?
> 
>    iommu->pgsize_bitmap = ULONG_MASK & PAGE_MASK;
> 
> ?
> 
> vfio_update_pgsize_bitmap() goes to some trouble to avoid setting bits
> below the CPU page size here

Yep, though PAGE_MASK should already be UL, so just PAGE_MASK itself
should work.  The ULONG_MAX in the update function just allows us to
detect sub-page, ex. if the IOMMU supports 2K we can expose 4K minimum,
but we can't if the min IOMMU page is 64K.  Thanks,

Alex

