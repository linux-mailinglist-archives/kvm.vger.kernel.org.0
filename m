Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC1441D7D1
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 12:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349984AbhI3KfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 06:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349972AbhI3KfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 06:35:19 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560DBC06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 03:33:36 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l18-20020a05600c4f1200b002f8cf606262so7990387wmq.1
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 03:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ClOTz/czY4oI64rzJtLLTprqersW1WZ3UxUbkRSunI0=;
        b=q+0y5cUx0pM5xAXd9rFB+2TbqS16LQDpJqNisDwC+zRbUPYdm0x2tN2I4jGADIKWdo
         Z6Rmg1LBjvD0U+lbZHVncOeHbWEzo6DTx4j/vHIPLAddqpGbfp9B0SrwLQd9BSPJauZr
         pgi4zLKE3yUk8HInLzgtqnp4yWEeyTDx+hokIuH2Vqw5Gkh+znIfyFVR68RplyMaQqIi
         300GvZwMPWNP88uDYzycq2i/slMp88Ydfvw6DtH8LMR9o9fD5Xq5OjGoWssYpYLGJiw+
         6CFym6xccfUdcJypN02A+RKhGaoOT52czvNe45fwXbPLnSqvMMH5VNPfRn4UdjhwHdq2
         DNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ClOTz/czY4oI64rzJtLLTprqersW1WZ3UxUbkRSunI0=;
        b=M38Uokbqe86m0pboDPHzCGEGQRuw0T2Blg7PeAS1ok1+/8GFZH07xo3pG/doyAHcyL
         PiGk9TAcPbOOy8C7SQgrpOsO66cI46fsewsZPjbtImi6zISzdjBaDO6TUGoXAVyZUq5c
         W8bcWJVjcUfmm+6oubQj04cQngDtl5t21hz1eaSOO8giXbNVKAA6ZaX++gK2NQQtYPub
         qkfaixxxNu4ttjtYoqbJjCGeaIbYENi0CBwedIvrlMGpYURXdKhnMRGD40YKi0Oq0xTW
         ZHaPVGArOkoifVBYkYA5hqoDdAiq3l6zQIXJCCdjrxMbqS0uo/bOD5d9wuHGVn23rQ9D
         X04Q==
X-Gm-Message-State: AOAM531Xa6xr4Y1TUSKRWUMU7Kon6Nd/rTtNwC/FNfJVvFGWmLjJJdCr
        ZopHSroBYZPDtMGNZgckynfWnA==
X-Google-Smtp-Source: ABdhPJwhVvXXZXdlPItKlpNndOzQ9KbEhrdXbLjx7tfpvI/2kBpGRZ4Qz4ldiDgmI+V7wQlqYvW+Dg==
X-Received: by 2002:a05:600c:3b83:: with SMTP id n3mr4618919wms.50.1632998014911;
        Thu, 30 Sep 2021 03:33:34 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id m4sm4568115wml.28.2021.09.30.03.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 03:33:34 -0700 (PDT)
Date:   Thu, 30 Sep 2021 11:33:13 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>, "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <YVWSaU4CHFHnwEA5@myrica>
References: <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YUxTvCt1mYDntO8z@myrica>
 <20210923112716.GE964074@nvidia.com>
 <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923122220.GL964074@nvidia.com>
 <BN9PR11MB5433D75C09C6FDA01C2B7CF48CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210929123630.GS964074@nvidia.com>
 <BN9PR11MB5433C9B5A0CD0B58163859EC8CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433C9B5A0CD0B58163859EC8CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 08:30:42AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe
> > Sent: Wednesday, September 29, 2021 8:37 PM
> > 
> > On Wed, Sep 29, 2021 at 08:48:28AM +0000, Tian, Kevin wrote:
> > 
> > > ARM:
> > >     - set to snoop format if IOMMU_CACHE
> > >     - set to nonsnoop format if !IOMMU_CACHE
> > > (in both cases TLP snoop bit is ignored?)
> > 
> > Where do you see this? I couldn't even find this functionality in the
> > ARM HW manual??
> 
> Honestly speaking I'm getting confused by the complex attribute
> transformation control (default, replace, combine, input, output, etc.)
> in SMMU manual. Above was my impression after last check, but now
> I cannot find necessary info to build the same picture (except below 
> code). :/
> 
> > 
> > What I saw is ARM linking the IOMMU_CACHE to a IO PTE bit that causes
> > the cache coherence to be disabled, which is not ignoring no snoop.
> 
> My impression was that snoop is one way of implementing cache
> coherency and now since the PTE can explicitly specify cache coherency 
> like below:
> 
>                 else if (prot & IOMMU_CACHE)
>                         pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
>                 else
>                         pte |= ARM_LPAE_PTE_MEMATTR_NC;
> 
> This setting in concept overrides the snoop attribute from the device thus
> make it sort of ignored?

To make sure we're talking about the same thing: "the snoop attribute from
the device" is the "No snoop" attribute in the PCI TLP, right?

The PTE flags define whether the memory access is cache-coherent or not.
* WB is cacheable (short for write-back cacheable. Doesn't matter here
  what OI or RWA mean.)
* NC is non-cacheable.

         | Normal PCI access | No_snoop PCI access
  -------+-------------------+-------------------
  PTE WB | Cacheable         | Non-cacheable
  PTE NC | Non-cacheable     | Non-cacheable

Cacheable memory access participate in cache coherency. Non-cacheable
accesses go directly to memory, do not cause cache allocation.

On Arm cache coherency is configured through PTE attributes. I don't think
PCI No_snoop should be used because it's not necessarily supported
throughout the system and, as far as I understand, software can't discover
whether it is.

[...]
> Maybe I'll get a clearer picture on this after understanding the difference 
> between cache coherency and snoop on ARM.

The architecture uses terms "cacheable" and "coherent". The term "snoop"
is used when referring specifically to the PCI "No snoop" attribute. It is
also used within the interconnect coherency protocols, which are invisible
to software.

Thanks,
Jean

