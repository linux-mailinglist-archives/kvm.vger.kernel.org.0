Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86E139912E
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 19:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFBRNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 13:13:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhFBRNH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 13:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622653883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rQnb3uVEkzGJfWKHipZhsatLwyXBgLRi/IklHpC5SOg=;
        b=EjaBMidFKYHk6KhkqSMVoTb+Vui9wCINIPExntX6Fba1lF1KW1NllETK8mUA6EyerpXqbN
        QdLcgfRPjAcTjyj9KcV2Q1jxcmZG3vSnPeYRYhrSSEArUUvAGMmEtf64Qx1TE+fLIqpaka
        WFJ8PyI2GrqDa4OgM2SaWskVqJH8LQ0=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-cEsGiKWMNqqGgViQQh8MuQ-1; Wed, 02 Jun 2021 13:11:20 -0400
X-MC-Unique: cEsGiKWMNqqGgViQQh8MuQ-1
Received: by mail-oi1-f199.google.com with SMTP id e17-20020aca13110000b02901e586ebcc79so1530631oii.0
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 10:11:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rQnb3uVEkzGJfWKHipZhsatLwyXBgLRi/IklHpC5SOg=;
        b=uG4xMSI1mLOuBAFK/gq2zMcHFSWXJHd8YMwEw2fvgBTTTQMoUH0IsEyiRE/Ex99iwN
         OSk0AmXUAYUVGiePTzrKd4pS2aysb0vL73X32LS+DMTM+ajp0AslkZVSsnAUp76gucAN
         QfYtf3hyzMrTjWpPIMulsKP80uI8qar0025sLBGRzKcMYz9AdSH9thw6qBDJyGO/uNV5
         gWiNv6QKQYjCrwDMEZKplDWbD89PCrRvelQPmysV411cEDGiFuF57R70sWZJwi4i2l8E
         UjWct8V1N2EE1vs4CM1GjcUHOLK3HSDoXkNZR3OXjjin1Tv2QIT4Yht/PNvfKgTBnzyj
         mXPg==
X-Gm-Message-State: AOAM533F9se34FhK9lYm4YYs7iwgiVQiJD4BtHSZEqlm08DR060Y9iHN
        j2q/ccbNiBXX2KqqUg5X2VOq5qLV04erD1MndHcw7YWLkTUibbCOLgwarbpMCVfllwsPD3WBIYU
        JgmutQGdklWki
X-Received: by 2002:a05:6808:5cf:: with SMTP id d15mr1617203oij.15.1622653879852;
        Wed, 02 Jun 2021 10:11:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiquf9XvQwTSgxCIyQwkKRXmIc+IfSqYwX9h2rpwZV2d2yRmfp0luOh6jW5cB/WpGo7V6a2A==
X-Received: by 2002:a05:6808:5cf:: with SMTP id d15mr1617181oij.15.1622653879635;
        Wed, 02 Jun 2021 10:11:19 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id x187sm106687oia.17.2021.06.02.10.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 10:11:18 -0700 (PDT)
Date:   Wed, 2 Jun 2021 11:11:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210602111117.026d4a26.alex.williamson@redhat.com>
In-Reply-To: <20210602160140.GV1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210528200311.GP1002214@nvidia.com>
        <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210601162225.259923bc.alex.williamson@redhat.com>
        <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210602160140.GV1002214@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2 Jun 2021 13:01:40 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jun 02, 2021 at 02:20:15AM +0000, Tian, Kevin wrote:
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, June 2, 2021 6:22 AM
> > > 
> > > On Tue, 1 Jun 2021 07:01:57 +0000
> > > "Tian, Kevin" <kevin.tian@intel.com> wrote:  
> > > >
> > > > I summarized five opens here, about:
> > > >
> > > > 1)  Finalizing the name to replace /dev/ioasid;
> > > > 2)  Whether one device is allowed to bind to multiple IOASID fd's;
> > > > 3)  Carry device information in invalidation/fault reporting uAPI;
> > > > 4)  What should/could be specified when allocating an IOASID;
> > > > 5)  The protocol between vfio group and kvm;
> > > >  
> > > ...  
> > > >
> > > > For 5), I'd expect Alex to chime in. Per my understanding looks the
> > > > original purpose of this protocol is not about I/O address space. It's
> > > > for KVM to know whether any device is assigned to this VM and then
> > > > do something special (e.g. posted interrupt, EPT cache attribute, etc.).  
> > > 
> > > Right, the original use case was for KVM to determine whether it needs
> > > to emulate invlpg, so it needs to be aware when an assigned device is  
> > 
> > invlpg -> wbinvd :)

Oops, of course.
   
> > > present and be able to test if DMA for that device is cache
> > > coherent.  
> 
> Why is this such a strong linkage to VFIO and not just a 'hey kvm
> emulate wbinvd' flag from qemu?

IIRC, wbinvd has host implications, a malicious user could tell KVM to
emulate wbinvd then run the op in a loop and induce a disproportionate
load on the system.  We therefore wanted a way that it would only be
enabled when required.

> I briefly didn't see any obvios linkage in the arch code, just some
> dead code:
> 
> $ git grep iommu_noncoherent
> arch/x86/include/asm/kvm_host.h:	bool iommu_noncoherent;
> $ git grep iommu_domain arch/x86
> arch/x86/include/asm/kvm_host.h:        struct iommu_domain *iommu_domain;
> 
> Huh?

Cruft from legacy KVM device assignment, I assume.  What you're looking
for is:

kvm_vfio_update_coherency
 kvm_arch_register_noncoherent_dma
  atomic_inc(&kvm->arch.noncoherent_dma_count);

need_emulate_wbinvd
 kvm_arch_has_noncoherent_dma
  atomic_read(&kvm->arch.noncoherent_dma_count);

There are a couple other callers that I'm not as familiar with.

> It kind of looks like the other main point is to generate the
> VFIO_GROUP_NOTIFY_SET_KVM which is being used by two VFIO drivers to
> connect back to the kvm data
> 
> But that seems like it would have been better handled with some IOCTL
> on the vfio_device fd to import the KVM to the driver not this
> roundabout way?

Then QEMU would need to know which drivers require KVM knowledge?  This
allowed transparent backwards compatibility with userspace.  Thanks,

Alex

