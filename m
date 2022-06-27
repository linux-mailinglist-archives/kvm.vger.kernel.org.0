Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D84A55CABB
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238003AbiF0TVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 15:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235186AbiF0TVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 15:21:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2886EB4A4
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 12:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656357700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tC29q+aNgStWTf3T1gdIerdLoXO+91zXobwFBrVQGCE=;
        b=dOvh7pe3R8Z3KPzNSk/9Xn7+IdI0ydUIJeHjaonalkpRLUzVlp0bk5WhPFLDjSLGGeltnL
        hjR1DEfwWTKUZdV5HjQ/FnqqWXd9b7wssD6yYteJ121UtcnF3+I7RocJSZDUsNooTA/CFW
        wWwrJZM692OMkuTRMEbeyHu8q8G2vRA=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-Firmgh8MN2-KULCvC7ug0g-1; Mon, 27 Jun 2022 15:21:39 -0400
X-MC-Unique: Firmgh8MN2-KULCvC7ug0g-1
Received: by mail-il1-f198.google.com with SMTP id n14-20020a056e021bae00b002d92c91da8aso6134505ili.15
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 12:21:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tC29q+aNgStWTf3T1gdIerdLoXO+91zXobwFBrVQGCE=;
        b=FtJohdHISNm/4tyP2qadlLOxvoldFiPoJQydc0jshy2b2HGxxIN3ifU0w0n4DHZhXM
         Yj6x+nZ7pI0Wsida0IiFVwdIl/UINBqx3yFsNJSDye9BjMQYxyyZNh5s+4MA6FFN0gCy
         ICHDVrOpCbmRMDu2U9GpPf0SPa4MhFx4kecr8c3J4PSaUenwJnW8bylirRV/f2cz+hCd
         fYzwufveiZFIsEIu2FhlzWKsA7zAwIl3eqDUOMzOMgNMJRz7fNEw0wGsH1tsKN3O2+he
         ek5fqWuCZGbaqFuOMz1ZKucRPe4ONiTRQ6zJOLbmynH/fN4TwyscC6mQhWjtajtZLkXQ
         rkSg==
X-Gm-Message-State: AJIora9QS2yET+qVbivnYLzNrly4UAWHW8MYSIS4B3DGQtSI34syn11M
        O7nXXMab60SGNV6AoscVWNNLWIJ2eSw8XP7HlQW+RPimOtHP5PTwB8inQRPYRFEIAE8PP2pDkWD
        qbwCPR1DGTzPt
X-Received: by 2002:a5e:c016:0:b0:675:398:4713 with SMTP id u22-20020a5ec016000000b0067503984713mr7609126iol.149.1656357698908;
        Mon, 27 Jun 2022 12:21:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ugeHJeLAFVVzGHnn/nqnvt4TYEqjk+64UlN9WD7leHiuAGXnJQAVJhcrElur2pHlk/kXOBWA==
X-Received: by 2002:a5e:c016:0:b0:675:398:4713 with SMTP id u22-20020a5ec016000000b0067503984713mr7609111iol.149.1656357698650;
        Mon, 27 Jun 2022 12:21:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k6-20020a02cb46000000b00331743a983asm3707166jap.179.2022.06.27.12.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 12:21:38 -0700 (PDT)
Date:   Mon, 27 Jun 2022 13:21:36 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        jgg@nvidia.com, baolu.lu@linux.intel.com, iommu@lists.linux.dev
Subject: Re: [PATCH v3 1/2] vfio/type1: Simplify bus_type determination
Message-ID: <20220627132136.2b902875.alex.williamson@redhat.com>
In-Reply-To: <194a12d3434d7b38f84fa96503c7664451c8c395.1656092606.git.robin.murphy@arm.com>
References: <194a12d3434d7b38f84fa96503c7664451c8c395.1656092606.git.robin.murphy@arm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Jun 2022 18:51:44 +0100
Robin Murphy <robin.murphy@arm.com> wrote:

> Since IOMMU groups are mandatory for drivers to support, it stands to
> reason that any device which has been successfully added to a group
> must be on a bus supported by that IOMMU driver, and therefore a domain
> viable for any device in the group must be viable for all devices in
> the group. This already has to be the case for the IOMMU API's internal
> default domain, for instance. Thus even if the group contains devices on
> different buses, that can only mean that the IOMMU driver actually
> supports such an odd topology, and so without loss of generality we can
> expect the bus type of any device in a group to be suitable for IOMMU
> API calls.
> 
> Furthermore, scrutiny reveals a lack of protection for the bus being
> removed while vfio_iommu_type1_attach_group() is using it; the reference
> that VFIO holds on the iommu_group ensures that data remains valid, but
> does not prevent the group's membership changing underfoot.
> 
> We can address both concerns by recycling vfio_bus_type() into some
> superficially similar logic to indirect the IOMMU API calls themselves.
> Each call is thus protected from races by the IOMMU group's own locking,
> and we no longer need to hold group-derived pointers beyond that scope.
> It also gives us an easy path for the IOMMU API's migration of bus-based
> interfaces to device-based, of which we can already take the first step
> with device_iommu_capable(). As with domains, any capability must in
> practice be consistent for devices in a given group - and after all it's
> still the same capability which was expected to be consistent across an
> entire bus! - so there's no need for any complicated validation.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
> 
> v3: Complete rewrite yet again, and finally it doesn't feel like we're
> stretching any abstraction boundaries the wrong way, and the diffstat
> looks right too. I did think about embedding IOMMU_CAP_INTR_REMAP
> directly in the callback, but decided I like the consistency of minimal
> generic wrappers. And yes, if the capability isn't supported then it
> does end up getting tested for the whole group, but meh, it's harmless.
> 
>  drivers/vfio/vfio_iommu_type1.c | 42 +++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index c13b9290e357..a77ff00c677b 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1679,18 +1679,6 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> -static int vfio_bus_type(struct device *dev, void *data)
> -{
> -	struct bus_type **bus = data;
> -
> -	if (*bus && *bus != dev->bus)
> -		return -EINVAL;
> -
> -	*bus = dev->bus;
> -
> -	return 0;
> -}
> -
>  static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  			     struct vfio_domain *domain)
>  {
> @@ -2153,13 +2141,25 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
>  	list_splice_tail(iova_copy, iova);
>  }
>  

Any objection if I add the following comment:

/* Redundantly walks non-present capabilities to simplify caller */

Thanks,
Alex

> +static int vfio_iommu_device_capable(struct device *dev, void *data)
> +{
> +	return device_iommu_capable(dev, (enum iommu_cap)data);
> +}
> +
> +static int vfio_iommu_domain_alloc(struct device *dev, void *data)
> +{
> +	struct iommu_domain **domain = data;
> +
> +	*domain = iommu_domain_alloc(dev->bus);
> +	return 1; /* Don't iterate */
> +}
> +
>  static int vfio_iommu_type1_attach_group(void *iommu_data,
>  		struct iommu_group *iommu_group, enum vfio_group_type type)
>  {
>  	struct vfio_iommu *iommu = iommu_data;
>  	struct vfio_iommu_group *group;
>  	struct vfio_domain *domain, *d;
> -	struct bus_type *bus = NULL;
>  	bool resv_msi, msi_remap;
>  	phys_addr_t resv_msi_base = 0;
>  	struct iommu_domain_geometry *geo;
> @@ -2192,18 +2192,19 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  		goto out_unlock;
>  	}
>  
> -	/* Determine bus_type in order to allocate a domain */
> -	ret = iommu_group_for_each_dev(iommu_group, &bus, vfio_bus_type);
> -	if (ret)
> -		goto out_free_group;
> -
>  	ret = -ENOMEM;
>  	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
>  	if (!domain)
>  		goto out_free_group;
>  
> +	/*
> +	 * Going via the iommu_group iterator avoids races, and trivially gives
> +	 * us a representative device for the IOMMU API call. We don't actually
> +	 * want to iterate beyond the first device (if any).
> +	 */
>  	ret = -EIO;
> -	domain->domain = iommu_domain_alloc(bus);
> +	iommu_group_for_each_dev(iommu_group, &domain->domain,
> +				 vfio_iommu_domain_alloc);
>  	if (!domain->domain)
>  		goto out_free_domain;
>  
> @@ -2258,7 +2259,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	list_add(&group->next, &domain->group_list);
>  
>  	msi_remap = irq_domain_check_msi_remap() ||
> -		    iommu_capable(bus, IOMMU_CAP_INTR_REMAP);
> +		    iommu_group_for_each_dev(iommu_group, (void *)IOMMU_CAP_INTR_REMAP,
> +					     vfio_iommu_device_capable);
>  
>  	if (!allow_unsafe_interrupts && !msi_remap) {
>  		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",

