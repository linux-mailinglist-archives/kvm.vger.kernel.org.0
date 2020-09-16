Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B96526C71C
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 20:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgIPSSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 14:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727897AbgIPSRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 14:17:53 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6656AC061D7F
        for <kvm@vger.kernel.org>; Wed, 16 Sep 2020 09:21:12 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z9so3680652wmk.1
        for <kvm@vger.kernel.org>; Wed, 16 Sep 2020 09:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g0JgrWFzihrjVNM/RM97BMwwjlCtIPznA6TNm/molSw=;
        b=aAw6eQdBpE7GtAmG/rhsFEmSpYrC8VM6bVOy+Ki9gIzm5zO4GmCuFCsga/gDel+cyz
         RT2Ax5Q5wF6wKEWvgkUIjVDYrKJAsgQI3j5JwLU/OFG2vxSGfP1kcoVWhikg3WS3ercG
         /dnk83vADJYHsGeJzvlBLjmf+uzXSlUUwhcDaN98Yr4hCO9uvgooQH31SO8MDLw/H6xX
         lNn4q0IfDgTzfD4id45l6Z5L+9jxheAH1Dajv1jBnzvwF14skKH5ZDyLyhsrILSAkVux
         pPY2AI/xaatbmnd/fidvj3hw395ODPBI4jAEFy2GmFcnMPVm1VTE+l9e6J+HS0961bVV
         IiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g0JgrWFzihrjVNM/RM97BMwwjlCtIPznA6TNm/molSw=;
        b=XJ5dpE/CClYDkk4P5/NNasgfuLgJlNR3gBMs6KE5yd/zqaGwxdDPaL23F3ys7OYzA6
         SR++PCjnHhZjwn0qRMWA/JqL8hycf08cC5APNIVhwHD0xjqByb6laMD4iLkTkc32mFCC
         sF2M98VIbonCyw/gkVwvB1QSf1yhsjRw6grGhq7yfH/9c+pHjbNE5LYj8L4hvzDXI57J
         hbwg7Hz4/kCkboYb9+RQahkZkhFSszGknl2Q2cX60lelJj+XJYRGI/YyuXvdziQMFv2X
         TQe2xmdz8KZbmUWP6E9V97QgmA4EaUUXZ+daZTyLEjqgLbH08ogUk5MDLAdVTkWXDTwS
         OWfw==
X-Gm-Message-State: AOAM5311b1HGgGnSxfQjXu0MXwFziDF2vIK6HgLRwmPAwsD5iqUk0DxX
        j47E8dVgv8uUWGVGw5n5TEGmww==
X-Google-Smtp-Source: ABdhPJwRsqk/eXagqfhZcEsmfcd5VzH7wZXscIvOW7qb13b1cJBRB/FR2tW5PnytJ7L4dWo4B2eTzg==
X-Received: by 2002:a7b:c397:: with SMTP id s23mr5739869wmj.174.1600273270873;
        Wed, 16 Sep 2020 09:21:10 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id s5sm33513252wrm.33.2020.09.16.09.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 09:21:10 -0700 (PDT)
Date:   Wed, 16 Sep 2020 18:20:52 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <20200916162052.GE5316@myrica>
References: <20200914163354.GG904879@nvidia.com>
 <20200914105857.3f88a271@x1.home>
 <20200914174121.GI904879@nvidia.com>
 <20200914122328.0a262a7b@x1.home>
 <20200914190057.GM904879@nvidia.com>
 <20200914163310.450c8d6e@x1.home>
 <20200915142906.GX904879@nvidia.com>
 <MWHPR11MB1645934DB27033011316059B8C210@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200916083217.GA5316@myrica>
 <20200916145148.GD6199@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916145148.GD6199@nvidia.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 16, 2020 at 11:51:48AM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 16, 2020 at 10:32:17AM +0200, Jean-Philippe Brucker wrote:
> > And this is the only PASID model for Arm SMMU (and AMD IOMMU, I believe):
> > the PASID space of a PCI function cannot be shared between host and guest,
> > so we assign the whole PASID table along with the RID. Since we need the
> > BIND, INVALIDATE, and report APIs introduced here to support nested
> > translation, a /dev/sva interface would need to support this mode as well.
> 
> Well, that means this HW cannot support PASID capable 'SIOV' style
> devices in guests.

It does not yet support Intel SIOV, no. It does support the standards,
though: PCI SR-IOV to partition a device and PASIDs in a guest.

> I admit whole function PASID delegation might be something vfio-pci
> should handle - but only if it really doesn't fit in some /dev/sva
> after we cover the other PASID cases.

Wouldn't that be the duplication you're trying to avoid?  A second channel
for bind, invalidate, capability and fault reporting mechanisms?  If we
extract SVA parts of vfio_iommu_type1 into a separate chardev, PASID table
pass-through [1] will have to use that.

Thanks,
Jean

[1] https://lore.kernel.org/linux-iommu/20200320161911.27494-1-eric.auger@redhat.com/
