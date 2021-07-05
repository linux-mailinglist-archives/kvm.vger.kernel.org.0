Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF8E3BB738
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 08:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhGEGhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 02:37:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229817AbhGEGhg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 02:37:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625466899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dUn2BLJAFkyaHY1ZuaHGYZbVrSRfM4IcVOnAHiEUpR8=;
        b=JXpMHg0eaoemgiv811epzyIMlFrjDRlU2aOhdRHJuYqX0nIWUmG28wb5Mszet2fAAQKL4N
        qcB2FtmQwYYmSSJu2obOSjwdgYmxMVTlkahLdlqdgYGP4sTeviLDxsZMDCwTVhRH4RpoYU
        lJimrkAna1Fu7p2QNZPSrUDPBukYhgU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-v3IsYUHjM2ySKwe2hzwj3g-1; Mon, 05 Jul 2021 02:34:57 -0400
X-MC-Unique: v3IsYUHjM2ySKwe2hzwj3g-1
Received: by mail-ed1-f71.google.com with SMTP id y18-20020a0564022712b029038ffac1995eso8631115edd.12
        for <kvm@vger.kernel.org>; Sun, 04 Jul 2021 23:34:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dUn2BLJAFkyaHY1ZuaHGYZbVrSRfM4IcVOnAHiEUpR8=;
        b=gi1w+GQDmmj031kUReFaOE6PuxumMS1T3hCOx5zS/7+C5836UXbGMo4QwO4wK/xm/p
         2p7Q/uV9S07VwKn3shTFPLoOepWjL3/PnesfMhheXphgf0m7Fj4itFueChY3B+wLxaj2
         OU2tj0HU9doIt2LP6Gs+m+pwCWTY9HewajYONQ1DMo6YTs/p0F+Fk9rvbv0b5nIXBQRr
         NXHt4NYHV9EaPluq1omJ7lMKsnllz6MFN1W1bpaz0J0c55GYjChTFhs7a2R0lL4Wgo1n
         8r9SYaPxM5F+zMrQTw03kFxgbRnyzbtQgTfSLv8lNL5O49ZOKHz9sHtuwSHNsbpXnzpm
         jj8Q==
X-Gm-Message-State: AOAM532WUWdWFcZjkvgRHvELxTsM8p6X82vvucZojGhUSStVLlcuaI4a
        YUKrBdsTREugprKu/QcPjXY2/6FaSqwurHA9LGqyLoenBirhVwRpidIrAezgAj5Q5pq7enfNn+r
        w1aGHpf2wlPzJ
X-Received: by 2002:a05:6402:1001:: with SMTP id c1mr14439025edu.26.1625466896742;
        Sun, 04 Jul 2021 23:34:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrRq3MRlQH+mGsiMRP8CKAZ/zYD48i3O+gBiuOktjRvq+QwTg+tzV3G5Q/ybjcyomyf2ha9w==
X-Received: by 2002:a05:6402:1001:: with SMTP id c1mr14439011edu.26.1625466896604;
        Sun, 04 Jul 2021 23:34:56 -0700 (PDT)
Received: from redhat.com ([2.55.4.39])
        by smtp.gmail.com with ESMTPSA id ja11sm3945759ejc.62.2021.07.04.23.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 23:34:54 -0700 (PDT)
Date:   Mon, 5 Jul 2021 02:34:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vDPA/ifcvf: implement management netlink framework
 for ifcvf
Message-ID: <20210705023354-mutt-send-email-mst@kernel.org>
References: <20210630082145.5729-1-lingshan.zhu@intel.com>
 <20210630082145.5729-3-lingshan.zhu@intel.com>
 <1ebb3dc8-5416-f718-2837-8371e78dd3d0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ebb3dc8-5416-f718-2837-8371e78dd3d0@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 05, 2021 at 01:04:11PM +0800, Jason Wang wrote:
> > +static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> > +{
> > +	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
> > +	struct device *dev = &pdev->dev;
> > +	struct ifcvf_adapter *adapter;
> 
> 
> adapter is not used.

It's used in error handling below. It's not *initialized*.

> 
> > +	u32 dev_type;
> > +	int ret;
> > +
> > +	ifcvf_mgmt_dev = kzalloc(sizeof(struct ifcvf_vdpa_mgmt_dev), GFP_KERNEL);
> > +	if (!ifcvf_mgmt_dev) {
> > +		IFCVF_ERR(pdev, "Failed to alloc memory for the vDPA management device\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	dev_type = get_dev_type(pdev);
> > +	switch (dev_type) {
> > +	case VIRTIO_ID_NET:
> > +		ifcvf_mgmt_dev->mdev.id_table = id_table_net;
> > +		break;
> > +	case VIRTIO_ID_BLOCK:
> > +		ifcvf_mgmt_dev->mdev.id_table = id_table_blk;
> > +		break;
> > +	default:
> > +		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", dev_type);
> > +		ret = -EOPNOTSUPP;
> > +		goto err;
> > +	}
> > +
> > +	ifcvf_mgmt_dev->mdev.ops = &ifcvf_vdpa_mgmt_dev_ops;
> > +	ifcvf_mgmt_dev->mdev.device = dev;
> > +	ifcvf_mgmt_dev->pdev = pdev;
> > +
> > +	ret = pcim_enable_device(pdev);
> > +	if (ret) {
> > +		IFCVF_ERR(pdev, "Failed to enable device\n");
> > +		goto err;
> > +	}
> > +
> > +	ret = pcim_iomap_regions(pdev, BIT(0) | BIT(2) | BIT(4),
> > +				 IFCVF_DRIVER_NAME);
> > +	if (ret) {
> > +		IFCVF_ERR(pdev, "Failed to request MMIO region\n");
> > +		goto err;
> > +	}
> > +
> > +	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
> > +	if (ret) {
> > +		IFCVF_ERR(pdev, "No usable DMA configuration\n");
> > +		goto err;
> > +	}
> > +
> > +	ret = devm_add_action_or_reset(dev, ifcvf_free_irq_vectors, pdev);
> > +	if (ret) {
> > +		IFCVF_ERR(pdev,
> > +			  "Failed for adding devres for freeing irq vectors\n");
> > +		goto err;
> > +	}
> > +
> > +	pci_set_master(pdev);
> > +
> > +	ret = vdpa_mgmtdev_register(&ifcvf_mgmt_dev->mdev);
> > +	if (ret) {
> > +		IFCVF_ERR(pdev,
> > +			  "Failed to initialize the management interfaces\n");
> >   		goto err;
> >   	}
> > @@ -533,14 +610,21 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >   err:
> >   	put_device(&adapter->vdpa.dev);
> > +	kfree(ifcvf_mgmt_dev);
> >   	return ret;
> >   }

