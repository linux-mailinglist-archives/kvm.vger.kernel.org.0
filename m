Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E753226BF5A
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 10:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgIPIcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 04:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgIPIci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 04:32:38 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC075C06174A
        for <kvm@vger.kernel.org>; Wed, 16 Sep 2020 01:32:37 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id o8so9098510ejb.10
        for <kvm@vger.kernel.org>; Wed, 16 Sep 2020 01:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lsTHEaMa7NWcCiDhQh+LAwtpF5hf7liWYfCO2nfxQUY=;
        b=Weqz4/aGFFZyyeuPB8AeHDH5MYDjqn1CD5KyBnY3YIxMqGv8uH8zataEVx7IPzu/t5
         UE6CNn4OHhrAkbP0ygegXzbgzv3tDgzt6VkRCErSvyYCxVJnhuJsOODoh0ZIJUQSTran
         znXRkdzuyfz+MUTCqc9qrJ7+QBgjP958NJ39KjIZ4kGHc14gnP0uKR26r31mWVmldktZ
         iuRN3yskbjWuLoecBPenGexvNHb+JjxTdqzgIvj4fRxtrP1P3rhRDYP3mByi08SAlcmC
         YniViRXWYSvEygaLvfzUc7KaSzn1JvNSR8cMCFz9kM4mlu1uDbRv9A8X/7iVNmB16eXQ
         2hQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lsTHEaMa7NWcCiDhQh+LAwtpF5hf7liWYfCO2nfxQUY=;
        b=tIY8OYDzST8LAOcSw1SkHB/oirOe6I7pfC6YZylKpPtDGbWD70pEbDrXGBkvMjkYhz
         PwkCQazeS8ZBf6VyabKcG13kSrzhUdcIeCPWqi8Fm/rJjTLjkfKCrjt/mzMSjSeMSN+X
         wEX/4vNnt7tKwsUc8lKHIU8Dz0YKwmP4Ug/yYlX/ITXDoDIcJrBTK3C+dcztfBSGS9Sc
         B/e82MXZUeflGKHKuGifQd8G6buhzq0eLdhDd94L0hJWpQZ1HtHeG1YlyBzsUHVjkipa
         qz28CXYEvDhRwPBF7VytGHNPi3+ZteAwroe3s9uux8Mz4ClSOObpbl3fywp6TrnN5gIY
         rtrw==
X-Gm-Message-State: AOAM5300NW1dFgmrZ5tJl2QtSQrI01PwKdPgosOjVV8AZMP9XMiH3uL8
        iQ1dYQARkMEFoZENBGzMwJR27Q==
X-Google-Smtp-Source: ABdhPJxCMjyEvUmXkRyRWGahwWFRcdqvEJJ1mvM4W7oJWaX7Wi/HjXfv84eXyjZEt5oaWl9swiJlzQ==
X-Received: by 2002:a17:906:4cd6:: with SMTP id q22mr23775429ejt.139.1600245156191;
        Wed, 16 Sep 2020 01:32:36 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id k19sm12010499ejo.40.2020.09.16.01.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 01:32:35 -0700 (PDT)
Date:   Wed, 16 Sep 2020 10:32:17 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200916083217.GA5316@myrica>
References: <20200914134738.GX904879@nvidia.com>
 <20200914162247.GA63399@otc-nc-03>
 <20200914163354.GG904879@nvidia.com>
 <20200914105857.3f88a271@x1.home>
 <20200914174121.GI904879@nvidia.com>
 <20200914122328.0a262a7b@x1.home>
 <20200914190057.GM904879@nvidia.com>
 <20200914163310.450c8d6e@x1.home>
 <20200915142906.GX904879@nvidia.com>
 <MWHPR11MB1645934DB27033011316059B8C210@MWHPR11MB1645.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645934DB27033011316059B8C210@MWHPR11MB1645.namprd11.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 16, 2020 at 01:19:18AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, September 15, 2020 10:29 PM
> >
> > > Do they need a device at all?  It's not clear to me why RID based
> > > IOMMU management fits within vfio's scope, but PASID based does not.
> > 
> > In RID mode vfio-pci completely owns the PCI function, so it is more
> > natural that VFIO, as the sole device owner, would own the DMA mapping
> > machinery. Further, the RID IOMMU mode is rarely used outside of VFIO
> > so there is not much reason to try and disaggregate the API.
> 
> It is also used by vDPA.
> 
> > 
> > PASID on the other hand, is shared. vfio-mdev drivers will share the
> > device with other kernel drivers. PASID and DMA will be concurrent
> > with VFIO and other kernel drivers/etc.
> > 
> 
> Looks you are equating PASID to host-side sharing, while ignoring 
> another valid usage that a PASID-capable device is passed through
> to the guest through vfio-pci and then PASID is used by the guest 
> for guest-side sharing. In such case, it is an exclusive usage in host
> side and then what is the problem for VFIO to manage PASID given
> that vfio-pci completely owns the function?

And this is the only PASID model for Arm SMMU (and AMD IOMMU, I believe):
the PASID space of a PCI function cannot be shared between host and guest,
so we assign the whole PASID table along with the RID. Since we need the
BIND, INVALIDATE, and report APIs introduced here to support nested
translation, a /dev/sva interface would need to support this mode as well.

Thanks,
Jean
