Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DE041C44D
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 14:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343546AbhI2MKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 08:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245563AbhI2MKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 08:10:02 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB26C061753
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 05:08:20 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u18so3868003wrg.5
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 05:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iyf25v6ccH6pcjIZwVpHGzum+qBnQrA4I/SRUwhCtyo=;
        b=T8zIfXgeaPrEEdWOzvwNTpI4xwVcEDwynYkx5VAeTJ7rV02Hb29+luk4+do/R4tlYM
         WHxuynFzb2jIPamYr5joLM1NbqFkLNQ0oXsf3Cq1vMqmpxFgE+EvcDk2f7Ua7SsG6agX
         W5014cw1JRdT8BGfZPqE1nw7yLc3PKzbdYCmg8bHyHxkqJIC7qlZAsC3mMiRPMmQ1Q6B
         /n70Y9v5VrEqVNrQ4oRHi2obyy5TfM1Zz0e7jjuVuSsi1WBQAwvr1/X1uZYPwnsN9sCC
         VxAv5M5BafhvPiWSTATDETbfoIlTsGYDjGkhoPQ0oWwEIQbt2gGpFvIj8HH9WyqbKgW3
         VCtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iyf25v6ccH6pcjIZwVpHGzum+qBnQrA4I/SRUwhCtyo=;
        b=olQFB3/04z2eVKVRgIu/2tDKqoy6xHypm6T8D763vTP/6o04TwAksqvM8tpu741u67
         ArwaE+Y+iJvJPpq+fY55V2ilw8QAYN8LkzC61VgCya12r12M3bUDRLqI40p5f5glEdt8
         4iBNHgf45L8ATfyxYUvEaYz4NLKvlFIfDDLXi7sKzvRyiehsntrPDN71hjM7nYcaxZng
         LkMX+pI/BKx5Uc4DqXOYkYrBy4aVdaVAThHq8Pjr1/BN2HAlqCYIHA4kOLnhX6hrebhp
         pG6oVw8ipCLfbATLBG1nW4FytwpId4I7zcJHBm1vuM/trlS1FnKJZ5dnADWyED+S/Ob5
         ttOA==
X-Gm-Message-State: AOAM532Lz8gjT7c1WixbMO01XLB37+uWcIXutVZOrmo2B0vfz0UQ7wqX
        heiL1ozszk/VGJ1CfTHUxgXycw==
X-Google-Smtp-Source: ABdhPJwTIS8HQpJZEByh3RukfaJyygW8l9IQlLTBVa0HSIUytOml9PkySYthSBAciSjRupn3Iw7g/g==
X-Received: by 2002:adf:fe8c:: with SMTP id l12mr6440976wrr.210.1632917299207;
        Wed, 29 Sep 2021 05:08:19 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id i27sm1502404wmb.40.2021.09.29.05.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 05:08:18 -0700 (PDT)
Date:   Wed, 29 Sep 2021 13:07:56 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 17/20] iommu/iommufd: Report iova range to userspace
Message-ID: <YVRXHDwROV2ASnVJ@myrica>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-18-yi.l.liu@intel.com>
 <YUtCYZI3oQcwKrUh@myrica>
 <PH0PR11MB56580CB47CA2CF17C86CD0D0C3A99@PH0PR11MB5658.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB56580CB47CA2CF17C86CD0D0C3A99@PH0PR11MB5658.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 10:44:01AM +0000, Liu, Yi L wrote:
> > From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Sent: Wednesday, September 22, 2021 10:49 PM
> > 
> > On Sun, Sep 19, 2021 at 02:38:45PM +0800, Liu Yi L wrote:
> > > [HACK. will fix in v2]
> > >
> > > IOVA range is critical info for userspace to manage DMA for an I/O address
> > > space. This patch reports the valid iova range info of a given device.
> > >
> > > Due to aforementioned hack, this info comes from the hacked vfio type1
> > > driver. To follow the same format in vfio, we also introduce a cap chain
> > > format in IOMMU_DEVICE_GET_INFO to carry the iova range info.
> > [...]
> > > diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> > > index 49731be71213..f408ad3c8ade 100644
> > > --- a/include/uapi/linux/iommu.h
> > > +++ b/include/uapi/linux/iommu.h
> > > @@ -68,6 +68,7 @@
> > >   *		   +---------------+------------+
> > >   *		   ...
> > >   * @addr_width:    the address width of supported I/O address spaces.
> > > + * @cap_offset:	   Offset within info struct of first cap
> > >   *
> > >   * Availability: after device is bound to iommufd
> > >   */
> > > @@ -77,9 +78,11 @@ struct iommu_device_info {
> > >  #define IOMMU_DEVICE_INFO_ENFORCE_SNOOP	(1 << 0) /* IOMMU
> > enforced snoop */
> > >  #define IOMMU_DEVICE_INFO_PGSIZES	(1 << 1) /* supported page
> > sizes */
> > >  #define IOMMU_DEVICE_INFO_ADDR_WIDTH	(1 << 2) /*
> > addr_wdith field valid */
> > > +#define IOMMU_DEVICE_INFO_CAPS		(1 << 3) /* info
> > supports cap chain */
> > >  	__u64	dev_cookie;
> > >  	__u64   pgsize_bitmap;
> > >  	__u32	addr_width;
> > > +	__u32   cap_offset;
> > 
> > We can also add vendor-specific page table and PASID table properties as
> > capabilities, otherwise we'll need giant unions in the iommu_device_info
> > struct. That made me wonder whether pgsize and addr_width should also
> > be
> > separate capabilities for consistency, but this way might be good enough.
> > There won't be many more generic capabilities. I have "output address
> > width"
> 
> what do you mean by "output address width"? Is it the output address
> of stage-1 translation?

Yes, so the guest knows the size of GPA it can write into the page table.
For Arm SMMU the GPA size is determined by both the SMMU implementation
and the host kernel configuration. But maybe that could also be
vendor-specific, if other architectures don't need to communicate it. 

> >
> and "PASID width", the rest is specific to Arm and SMMU table
> > formats.
> 
> When coming to nested translation support, the stage-1 related info are
> likely to be vendor-specific, and will be reported in cap chain.

Agreed

Thanks,
Jean
