Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F77414AFA
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 15:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhIVNrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 09:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbhIVNrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 09:47:03 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BC5C06175F
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 06:45:33 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d6so6882937wrc.11
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 06:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OqATTE/BrEowQNUew/i6t2ee/2HGj0S7vXDfrjI49UE=;
        b=DiFDtXnK5X1h8sM3UZZQRitNG46c4VhNndlN1Odh528nj4uqe1rhaiY9GrzMcSViJ1
         rdpmjBv5rgcIxCztX0ZC6gUzb0g7Av9IlCsKTuW5/TJ0I1n0JfVcD6Bti2sizUZdoN/Q
         Hajavq/eLRHSvRS+MW3GxTtRFbIXdSCyG75s1XxJjIv2L8HOSapwFmOAHtN0JmiQKrSS
         8kQV/YWauMZ9YmXgzL0VI14g/jBN6zXaVWoXggUZUtrSNRRWbyDPHlDFXNlSPomnOTYC
         nlbbobY5tGo0sKEALZSpdtpxH5Ep1jqzvBp8MH2fyzTf7VMYYYrkKbG6sdJXK1aHboA/
         oflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OqATTE/BrEowQNUew/i6t2ee/2HGj0S7vXDfrjI49UE=;
        b=SWrXdSebBGQ9ern1cwHgx+s0sW5cO/V3oXk0aRnq1bH4aAL+s3EM3KIPDjyR4bIDe+
         wj+Bu0BbEF1m40H/El9xldafAhSZGfkZCKxiZzM0XE6d+h4Ckeb6O5bggHtH79XOmgaj
         9vxDOoRJsgkasKQBdF5/okkQfoD3LXR2MW4Xkt0NVJ/x8GFCLp3qpsqzHOkydFvlMwL9
         bfNx+130H4F80dhPojZmsrlzCLvmpUnS+aIsqMMF7SIQxzFkHROWldTVJUYmaBZxQ0Fy
         lrC23Wv2BvP2DI6wmeGtdy4jWLhyqGRQPVACZX5z37rSL3o2gsZHYG3DkJq2dGW+ir6r
         mqeg==
X-Gm-Message-State: AOAM532+6mUMnIiQEiWfsYgbPcdSR3aoylW54TfyT3zjwQHgcjTTRi+A
        kK56HxmhQtzGy01WKRC77t7qKQ==
X-Google-Smtp-Source: ABdhPJxBzcwQu66fWHD0pP9MO/Sy42U55J8u2Jc1kFiULK7OUlEvJjbPdmOm0qWW1UWefraskQ1WQw==
X-Received: by 2002:a05:6000:1081:: with SMTP id y1mr42132164wrw.14.1632318331658;
        Wed, 22 Sep 2021 06:45:31 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id i2sm2158226wrq.78.2021.09.22.06.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 06:45:31 -0700 (PDT)
Date:   Wed, 22 Sep 2021 14:45:09 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <YUszZRk1vZOgVvFF@myrica>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-12-yi.l.liu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> This patch adds IOASID allocation/free interface per iommufd. When
> allocating an IOASID, userspace is expected to specify the type and
> format information for the target I/O page table.
> 
> This RFC supports only one type (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> implying a kernel-managed I/O page table with vfio type1v2 mapping
> semantics. For this type the user should specify the addr_width of
> the I/O address space and whether the I/O page table is created in
> an iommu enfore_snoop format. enforce_snoop must be true at this point,
> as the false setting requires additional contract with KVM on handling
> WBINVD emulation, which can be added later.
> 
> Userspace is expected to call IOMMU_CHECK_EXTENSION (see next patch)
> for what formats can be specified when allocating an IOASID.
> 
> Open:
> - Devices on PPC platform currently use a different iommu driver in vfio.
>   Per previous discussion they can also use vfio type1v2 as long as there
>   is a way to claim a specific iova range from a system-wide address space.

Is this the reason for passing addr_width to IOASID_ALLOC?  I didn't get
what it's used for or why it's mandatory. But for PPC it sounds like it
should be an address range instead of an upper limit?

Thanks,
Jean

>   This requirement doesn't sound PPC specific, as addr_width for pci devices
>   can be also represented by a range [0, 2^addr_width-1]. This RFC hasn't
>   adopted this design yet. We hope to have formal alignment in v1 discussion
>   and then decide how to incorporate it in v2.
> 
> - Currently ioasid term has already been used in the kernel (drivers/iommu/
>   ioasid.c) to represent the hardware I/O address space ID in the wire. It
>   covers both PCI PASID (Process Address Space ID) and ARM SSID (Sub-Stream
>   ID). We need find a way to resolve the naming conflict between the hardware
>   ID and software handle. One option is to rename the existing ioasid to be
>   pasid or ssid, given their full names still sound generic. Appreciate more
>   thoughts on this open!
