Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24712397C63
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 00:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhFAWYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 18:24:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234863AbhFAWYO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 18:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622586151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQ6OOCiaBJ+Tmwz5+IKCbPSSgkslxV7sVjnAnThBj/I=;
        b=QFx5/2YQFLheMt9tT9vDaiGlYB9IoriOPHFxarmsYmeC+8jseGbC3SpXmQqcIRIutnmI5K
        Us0iSE/PMBNzM2cBcjtgdq4hfUj65nSY8a9CkhH5ko5yPhLf5CkVLBEaVqTHTTz4QaYX5S
        83WHuDngofJx5vL4Lj+cOp5bXxF5wgM=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-RB37QnVlMoSFtMeQvHsyFQ-1; Tue, 01 Jun 2021 18:22:30 -0400
X-MC-Unique: RB37QnVlMoSFtMeQvHsyFQ-1
Received: by mail-ot1-f71.google.com with SMTP id 88-20020a9d06e10000b029030513a66c79so454500otx.0
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 15:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QQ6OOCiaBJ+Tmwz5+IKCbPSSgkslxV7sVjnAnThBj/I=;
        b=RCRvmiQL5M+U9dxFqgslNZRzzt4bbZnnEjuDGpc29AIetNDaFvTEUIfqf/tjmNGPwT
         JxbJp9tL0TQh4DK1eWcxFJedyELA53X4YNytrLQKQzjgasX0OGW2L9ECkRCRHlziiTmn
         PPlRTVK0Zp3DZ5JBSPw/xQrRgrIvFMLdLdaiBy7SSzujE9mIZwRHjXqtTaqoWKC78DNg
         UC5X442QVsFwTVM4rn/RLyekHcuYhnhFrgb217CIbTOQ93VgQpsYj27EjqVYCo7tQ8Qd
         G+3jK7ZR/4idVbDKfFjCBdO5i1C4iSBvPBHO+QqJujol6TiPL2YVjuPbrEc59seKWsUf
         J8Ig==
X-Gm-Message-State: AOAM531h5WFkhMUs9CnEzW1dBvl2OuH7menscOoQZJzV4bi7hNT8J7p+
        dwKNJe7S/3t5Ok0pgMgSqQl44mlR8rR74GXfIMYBgepx8JIRHAo6Ss1YICHhN2FiIKh0C17RRT1
        QRBwqXe5tc9k2
X-Received: by 2002:aca:6505:: with SMTP id m5mr18776744oim.93.1622586150038;
        Tue, 01 Jun 2021 15:22:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxi5D5R/YKBkpuFV42WBo2g+RPZt7CRIoVFlvzPv1SWguiDXnA+px3cN3uoGLgwkwtxnkMPhw==
X-Received: by 2002:aca:6505:: with SMTP id m5mr18776727oim.93.1622586149841;
        Tue, 01 Jun 2021 15:22:29 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id w10sm3658007oou.35.2021.06.01.15.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 15:22:29 -0700 (PDT)
Date:   Tue, 1 Jun 2021 16:22:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210601162225.259923bc.alex.williamson@redhat.com>
In-Reply-To: <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210528200311.GP1002214@nvidia.com>
        <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Jun 2021 07:01:57 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> I summarized five opens here, about:
> 
> 1)  Finalizing the name to replace /dev/ioasid;
> 2)  Whether one device is allowed to bind to multiple IOASID fd's;
> 3)  Carry device information in invalidation/fault reporting uAPI;
> 4)  What should/could be specified when allocating an IOASID;
> 5)  The protocol between vfio group and kvm;
> 
...
> 
> For 5), I'd expect Alex to chime in. Per my understanding looks the
> original purpose of this protocol is not about I/O address space. It's
> for KVM to know whether any device is assigned to this VM and then
> do something special (e.g. posted interrupt, EPT cache attribute, etc.).

Right, the original use case was for KVM to determine whether it needs
to emulate invlpg, so it needs to be aware when an assigned device is
present and be able to test if DMA for that device is cache coherent.
The user, QEMU, creates a KVM "pseudo" device representing the vfio
group, providing the file descriptor of that group to show ownership.
The ugly symbol_get code is to avoid hard module dependencies, ie. the
kvm module should not pull in or require the vfio module, but vfio will
be present if attempting to register this device.

With kvmgt, the interface also became a way to register the kvm pointer
with vfio for the translation mentioned elsewhere in this thread.

The PPC/SPAPR support allows KVM to associate a vfio group to an IOMMU
page table so that it can handle iotlb programming from pre-registered
memory without trapping out to userspace.

> Because KVM deduces some policy based on the fact of assigned device, 
> it needs to hold a reference to related vfio group. this part is irrelevant
> to this RFC. 

All of these use cases are related to the IOMMU, whether DMA is
coherent, translating device IOVA to GPA, and an acceleration path to
emulate IOMMU programming in kernel... they seem pretty relevant.

> But ARM's VMID usage is related to I/O address space thus needs some
> consideration. Another strange thing is about PPC. Looks it also leverages
> this protocol to do iommu group attach: kvm_spapr_tce_attach_iommu_
> group. I don't know why it's done through KVM instead of VFIO uAPI in
> the first place.

AIUI, IOMMU programming on PPC is done through hypercalls, so KVM needs
to know how to handle those for in-kernel acceleration.  Thanks,

Alex

