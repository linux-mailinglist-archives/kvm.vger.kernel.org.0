Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DD242D5D2
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 11:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhJNJTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 05:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhJNJTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 05:19:09 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33260C061570
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 02:17:05 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id y3so17372576wrl.1
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 02:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FrgyuWuLBh+n7WKszWkjTNYtblIyVmh6I5CBKj1hWB8=;
        b=TsyMUaXWrwrpOlM9MWYA18WinOqWNt4plrRIGzrMB0OM7Do6UEo+nrDybRA61Q3fkx
         uMilZDmdCFpgn2qwq7SvKR7R/+yQRL9zG3DT0A6CNLPFNunAZ1iBnl7u7AkFh7hwRaVl
         bswPMUvbcmRxrjF1LcwqdxOGNl+o/yb67ode4ZMQUso6ruWO70TNh6Z5OO5D7NIpBLs+
         VKlcobhOy61G/syI0EvJUO3EmPST/CXD/UjTefKE04jRTiGpeZvCHRhYgaeWiVoy9NTG
         IDkJ2avypEJgRksjI+UL1wBztVRQj8JqFRAUY+9/oZBCyPWqeJEJyfYOkvb3i5YemDPk
         F2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FrgyuWuLBh+n7WKszWkjTNYtblIyVmh6I5CBKj1hWB8=;
        b=0yoH4TEP7OF3nR8iiKuLjQh8A5pK1nTcj+AiiVphSuYnLMVa4CiK6FwnS1FYWlE0cb
         DLAfe3hxEtMEzDaI9C2f4r3h7wsWMTFlo+oOdIsV/KFCfji5ZitdiGzFpT2IHr6SaUEL
         FNQjEs80BtfxWTDX2lF1BoYJU0j1KHdwMWy4owJyimU4mGijaCCirRTWBclpGG1XaLpj
         mLF8d59ayrnSoMckHe4aRleuo6Jvsl1hijY7Z6flhT9Is9pK7fF4cXOVLV6KNG9pG0Gc
         6EioYFu5VLiMU8HOpa458EfbeBcCSExPiVnb9lrD7JWVqMl2ZPZvbo8ShPg76+UnnauC
         EOEA==
X-Gm-Message-State: AOAM530kR8k3rX0LOhhfJun4LfTjmfLwSvggj70u+rrZgQrT3R/TNs4U
        L3BzDTEZRUUOWUBjiyaO+sMpWA==
X-Google-Smtp-Source: ABdhPJxGzZVVDndK1R0NgQS1IezodYR5L12iZ+mavVph1JDLzdW1K114hQLpj+m41awWtqlqZ07zrA==
X-Received: by 2002:a5d:58ec:: with SMTP id f12mr5266196wrd.24.1634203023719;
        Thu, 14 Oct 2021 02:17:03 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id m36sm1815815wms.6.2021.10.14.02.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 02:17:02 -0700 (PDT)
Date:   Thu, 14 Oct 2021 10:16:41 +0100
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
Message-ID: <YWf1eXjYOR5Su5Zn@myrica>
References: <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YUxTvCt1mYDntO8z@myrica>
 <20210923112716.GE964074@nvidia.com>
 <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923122220.GL964074@nvidia.com>
 <BN9PR11MB5433D75C09C6FDA01C2B7CF48CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210929123630.GS964074@nvidia.com>
 <BN9PR11MB5433C9B5A0CD0B58163859EC8CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YVWSaU4CHFHnwEA5@myrica>
 <BN9PR11MB543330751AD68F70E89BC0FA8CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB543330751AD68F70E89BC0FA8CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 14, 2021 at 08:01:49AM +0000, Tian, Kevin wrote:
> > From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Sent: Thursday, September 30, 2021 6:33 PM
> > 
> > The PTE flags define whether the memory access is cache-coherent or not.
> > * WB is cacheable (short for write-back cacheable. Doesn't matter here
> >   what OI or RWA mean.)
> > * NC is non-cacheable.
> > 
> >          | Normal PCI access | No_snoop PCI access
> >   -------+-------------------+-------------------
> >   PTE WB | Cacheable         | Non-cacheable
> >   PTE NC | Non-cacheable     | Non-cacheable
> 
> This implies that PCI no-snoop supersedes PTE flags when it's supported
> by the system?
> 

Yes, no way for the SMMU to ignore no-snoop, as far as I can see

Thanks,
Jean
