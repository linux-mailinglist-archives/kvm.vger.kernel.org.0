Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFF93F9AEB
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 16:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhH0Ogd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 10:36:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232477AbhH0Ogc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 10:36:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630074943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MI7XqhEPHQ0KdrOH7I14agQ5SNxf4ytxsbZUk5i/1a4=;
        b=X1kqypNKncGI07gdP2I2LlWb022qwAX+xwGhK6MLNrxOP3pj/vZxRPpR+cDa99iejntF80
        1EFN7rEn/W4BV7JgVSNKbjTfvRDo5wxjKC358X88JYIcwN/mYKuY2OSvbJBFmaZ2SzRhdw
        sW2kcqFkfVrBAzJ+sgM/Ljp03i9rumk=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-FXZD1WFON-KH17A9CMsV3A-1; Fri, 27 Aug 2021 10:35:41 -0400
X-MC-Unique: FXZD1WFON-KH17A9CMsV3A-1
Received: by mail-io1-f72.google.com with SMTP id f1-20020a5edf01000000b005b85593f933so4085549ioq.14
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 07:35:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MI7XqhEPHQ0KdrOH7I14agQ5SNxf4ytxsbZUk5i/1a4=;
        b=KyACZU8W2UlRd0J+kRonIhw8+MnuMrTF/BPGUxDuZ6msoeKmTaEgQCKXHsa+vsfzBC
         RnrOlnUFq3TvpmaKMUcCwYLBngStS7Nk0gOF77lucl8TIuE0INSeMdfwPPZWR1qPyHj3
         xEtgYuo5kJhAKU5o1piv15h2PnsNilJVTXsZrxOx4r7S5CCqYFGcO5PNI0ssgNfcMpm6
         2cxpo0MFGSNGJD0hKCw4ty0wqgaXKPtb6iFA7z23iU6djOU+v+lLB2rygway10ZlyLNx
         ceR4YSfpU4lcDKyaH9gRp4TpMrIrsQKxQUpAkE/dy+Z0cNYY93EiqV232zzmI2gMjimU
         fNnw==
X-Gm-Message-State: AOAM531QstyFsEafqDljANBT3W18+zsTU9aI2BrDATBSzk8NEn7iiEpq
        CSuHiUk2HOZUoB3fYDtBazumM/K2bHh/Hr4NgzbQW3ejP6VQKz62K2Y9QpfAkkkCVCcnCe7tgL6
        B2L+J1NnHiZKX
X-Received: by 2002:a6b:5c17:: with SMTP id z23mr7384482ioh.3.1630074940816;
        Fri, 27 Aug 2021 07:35:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+CLjWgtsCi9oNdw60RVFvrcdC1pkSocHH0MY0/zSm9ztI54sLuhAqJOLqiN/jETE61gHCdQ==
X-Received: by 2002:a6b:5c17:: with SMTP id z23mr7384396ioh.3.1630074939672;
        Fri, 27 Aug 2021 07:35:39 -0700 (PDT)
Received: from redhat.com (c-73-14-100-188.hsd1.co.comcast.net. [73.14.100.188])
        by smtp.gmail.com with ESMTPSA id o11sm3499022ilf.86.2021.08.27.07.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 07:35:39 -0700 (PDT)
Date:   Fri, 27 Aug 2021 08:35:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc
 helper
Message-ID: <20210827083538.2fdb8676.alex.williamson@redhat.com>
In-Reply-To: <20210826233558.GT1721383@nvidia.com>
References: <20210826133424.3362-1-hch@lst.de>
        <20210826133424.3362-5-hch@lst.de>
        <20210826135413.239e6d4e.alex.williamson@redhat.com>
        <20210826233558.GT1721383@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Aug 2021 20:35:58 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Aug 26, 2021 at 01:54:13PM -0600, Alex Williamson wrote:
> > On Thu, 26 Aug 2021 15:34:14 +0200
> > Christoph Hellwig <hch@lst.de> wrote:
> >   
> > > Factor out a helper to find or allocate the vfio_group to reduce the
> > > spagetthi code in vfio_register_group_dev a little.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > >  drivers/vfio/vfio.c | 59 ++++++++++++++++++++++++++-------------------
> > >  1 file changed, 34 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > index 18e4c7906d1b3f..852fe22125520d 100644
> > > +++ b/drivers/vfio/vfio.c
> > > @@ -823,10 +823,38 @@ void vfio_uninit_group_dev(struct vfio_device *device)
> > >  }
> > >  EXPORT_SYMBOL_GPL(vfio_uninit_group_dev);
> > >  
> > > +struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> > > +{
> > > +	struct iommu_group *iommu_group;
> > > +	struct vfio_group *group;
> > > +
> > > +	iommu_group = vfio_iommu_group_get(dev);
> > > +	if (!iommu_group)
> > > +		return ERR_PTR(-EINVAL);
> > > +
> > > +	/* a found vfio_group already holds a reference to the iommu_group */
> > > +	group = vfio_group_get_from_iommu(iommu_group);
> > > +	if (group)
> > > +		goto out_put;
> > > +
> > > +	/* a newly created vfio_group keeps the reference. */
> > > +	group = vfio_create_group(iommu_group);
> > > +	if (IS_ERR(group))
> > > +		goto out_put;
> > > +	return group;
> > > +
> > > +out_put:
> > > +#ifdef CONFIG_VFIO_NOIOMMU
> > > +	if (iommu_group_get_iommudata(iommu_group) == &noiommu)
> > > +		iommu_group_remove_device(dev);
> > > +#endif  
> > 
> > When we get here via the first goto above, it doesn't match the code
> > we're removing below.   
> 
> If we are in noiommu mode then the group is a new singleton group and
> vfio_group_get_from_iommu() cannot succeed, so the out_put cannot
> trigger for the noiommu path.
> 
> This is all improved in patch 6 where the logic becomes clear:
> 
> +	iommu_group = iommu_group_get(dev);
> +#ifdef CONFIG_VFIO_NOIOMMU
> +	if (!iommu_group && noiommu && !iommu_present(dev->bus)) {
> +		/*
> +		 * With noiommu enabled, create an IOMMU group for devices that
> +		 * don't already have one and don't have an iommu_ops on their
> +		 * bus.  Taint the kernel because we're about to give a DMA
> +		 * capable device to a user without IOMMU protection.
> +		 */
> +		group = vfio_noiommu_group_alloc(dev);
> +		if (group) {
> +			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> +			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n");
> +		}
> +		return group;
> 
> Eg we never do a pointless vfio_group_get_from_iommu() on a no-iommu
> group in the first place, we just create everything directly.
> 
> It would be fine to add an extra label and then remove it in patch 6,
> but it is also fine this way and properly cleaned by the end.

I agree that it's resolved later in the series, but it's confusing
here, particularly because in patch 1 we need to come to the conclusion
that path is unreachable, thus the different return paths, then we
ignore it here with a common exit.  Thanks,

Alex

