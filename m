Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F353994A4
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 22:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhFBUjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 16:39:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229552AbhFBUjW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 16:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622666258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TL5RCeD6URaQW+iNoSmRFKX2AmrwBTs64Rz3fDPVQnU=;
        b=hkUcOwerbOUHron5RguhWuS74t2Y5bsGy79ijh9Ij3FQmR/SUTJGoUizwaqQGWc+qW4rBk
        k/Sp70lFXXBybLxVYsFSwUUxK/w4H1/yWzjVRc0QaeMoOWHolXVVjUKF4VY6Y6j49rCzxa
        yFJRwVb6Pz4hIVl1HqpWc6LXJmIveMk=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-GT2ph5FDMnaKgSMGQ8qEEA-1; Wed, 02 Jun 2021 16:37:37 -0400
X-MC-Unique: GT2ph5FDMnaKgSMGQ8qEEA-1
Received: by mail-oi1-f199.google.com with SMTP id p5-20020acabf050000b02901eed1481b82so1754661oif.20
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 13:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TL5RCeD6URaQW+iNoSmRFKX2AmrwBTs64Rz3fDPVQnU=;
        b=jelhxfOshkNY3BxGz/vxxon5wOIwGA8X6OLFcHACsySeT3gfavN6w0/YCxH8O5xp8i
         3SLVH7ZCgqJa/v5bop2UWLbLmBlpPQlGda9/7gaqbPXeISJAlJQiWthWzsw1I6FV1Z2Q
         q1ggs9RshRaH7vxN77GbkOWIsP3drA4HlxPDq+TVG9arSE3iB6NErlaXvLB6cUXS2yxS
         KDJFehxhdN/N7Lv9mPxlo3zcJWdmDnCU39PX7ddIQy65IfxwX4QKgf/nHZ7qa9v0kvng
         InY3X/AIfvqn+3cdgO4ISUooViOuqbdKgDMXlktMi7dNHeMcBnKIksp2vZkDDtJmnvO5
         hfIQ==
X-Gm-Message-State: AOAM532BOO1jEzu9p/cO3wegpPWskM0khhqBa7FekB5TQVrOvONPxkff
        HAW2ePueQBAUT5d+zT/xBMvU6ihwvBwRTmCKaQ2LiaXz8joMTA/KyC6oDvMgS3sgDk7oG6k5fbh
        xL2fniOQkUVNx
X-Received: by 2002:a05:6830:18ee:: with SMTP id d14mr2615015otf.347.1622666256098;
        Wed, 02 Jun 2021 13:37:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTGOm/+QC96xO7+b3hYQUsHRLgYBQr4fcc4vLi2KEeMHHCtYSbE2eryQSUu9BcVRPF7Kuerw==
X-Received: by 2002:a05:6830:18ee:: with SMTP id d14mr2614981otf.347.1622666255750;
        Wed, 02 Jun 2021 13:37:35 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id t39sm195560ooi.42.2021.06.02.13.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 13:37:35 -0700 (PDT)
Date:   Wed, 2 Jun 2021 14:37:34 -0600
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
Message-ID: <20210602143734.72fb4fa4.alex.williamson@redhat.com>
In-Reply-To: <20210602195404.GI1002214@nvidia.com>
References: <20210528200311.GP1002214@nvidia.com>
        <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210601162225.259923bc.alex.williamson@redhat.com>
        <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210602160140.GV1002214@nvidia.com>
        <20210602111117.026d4a26.alex.williamson@redhat.com>
        <20210602173510.GE1002214@nvidia.com>
        <20210602120111.5e5bcf93.alex.williamson@redhat.com>
        <20210602180925.GH1002214@nvidia.com>
        <20210602130053.615db578.alex.williamson@redhat.com>
        <20210602195404.GI1002214@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2 Jun 2021 16:54:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jun 02, 2021 at 01:00:53PM -0600, Alex Williamson wrote:
> >=20
> > Right, the device can generate the no-snoop transactions, but it's the
> > IOMMU that essentially determines whether those transactions are
> > actually still cache coherent, AIUI. =20
>=20
> Wow, this is really confusing stuff in the code.
>=20
> At the PCI level there is a TLP bit called no-snoop that is platform
> specific. The general intention is to allow devices to selectively
> bypass the CPU caching for DMAs. GPUs like to use this feature for
> performance.

Yes

> I assume there is some exciting security issues here. Looks like
> allowing cache bypass does something bad inside VMs? Looks like
> allowing the VM to use the cache clear instruction that is mandatory
> with cache bypass DMA causes some QOS issues? OK.

IIRC, largely a DoS issue if userspace gets to choose when to emulate
wbinvd rather than it being demanded for correct operation.

> So how does it work?
>=20
> What I see in the intel/iommu.c is that some domains support "snoop
> control" or not, based on some HW flag. This indicates if the
> DMA_PTE_SNP bit is supported on a page by page basis or not.
>=20
> Since x86 always leans toward "DMA cache coherent" I'm reading some
> tea leaves here:
>=20
> 	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU can enforce cache coherent DMA
> 					   transactions */
>=20
> And guessing that IOMMUs that implement DMA_PTE_SNP will ignore the
> snoop bit in TLPs for IOVA's that have DMA_PTE_SNP set?

That's my understanding as well.

> Further, I guess IOMMUs that don't support PTE_SNP, or have
> DMA_PTE_SNP clear will always honour the snoop bit. (backwards compat
> and all)

Yes.

> So, IOMMU_CAP_CACHE_COHERENCY does not mean the IOMMU is DMA
> incoherent with the CPU caches, it just means that that snoop bit in
> the TLP cannot be enforced. ie the device *could* do no-shoop DMA
> if it wants. Devices that never do no-snoop remain DMA coherent on
> x86, as they always have been.

Yes, IOMMU_CAP_CACHE_COHERENCY=3Dfalse means we cannot force the device
DMA to be coherent via the IOMMU.

> IOMMU_CACHE does not mean the IOMMU is DMA cache coherent, it means
> the PCI device is blocked from using no-snoop in its TLPs.
>=20
> I wonder if ARM implemented this consistently? I see VDPA is
> confused.. I was confused. What a terrible set of names.
>=20
> In VFIO generic code I see it always sets IOMMU_CACHE:
>=20
>         if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
>                 domain->prot |=3D IOMMU_CACHE;
>=20
> And thus also always provides IOMMU_CACHE to iommu_map:
>=20
>                 ret =3D iommu_map(d->domain, iova, (phys_addr_t)pfn << PA=
GE_SHIFT,
>                                 npage << PAGE_SHIFT, prot | d->prot);
>=20
> So when the IOMMU supports the no-snoop blocking security feature VFIO
> turns it on and blocks no-snoop to all pages? Ok..

Yep, I'd forgotten this nuance that we need to enable it via the
mapping flags.

> But I must be missing something big because *something* in the IOVA
> map should work with no-snoopable DMA, right? Otherwise what is the
> point of exposing the invalidate instruction to the guest?
>=20
> I would think userspace should be relaying the DMA_PTE_SNP bit from
> the guest's page tables up to here??
>=20
> The KVM hookup is driven by IOMMU_CACHE which is driven by
> IOMMU_CAP_CACHE_COHERENCY. So we turn on the special KVM support only
> if the IOMMU can block the SNP bit? And then we map all the pages to
> block the snoop bit? Huh?

Right.  I don't follow where you're jumping to relaying DMA_PTE_SNP
from the guest page table... what page table?  We don't necessarily
have a vIOMMU to expose such things, I don't think it even existed when
this we added.  Essentially if we can ignore no-snoop at the IOMMU,
then KVM doesn't need to worry about emulating wbinvd because of an
assigned device, whether that device uses it or not.  Win-win.

> Your explanation makes perfect sense: Block guests from using the
> dangerous cache invalidate instruction unless a device that uses
> no-snoop is plugged in. Block devices from using no-snoop because
> something about it is insecure. Ok.

No-snoop itself is not insecure, but to support no-snoop in a VM KVM
can't ignore wbinvd, which has overhead and abuse implications.

> But the conditions I'm looking for "device that uses no-snoop" is:
>  - The device will issue no-snoop TLPs at all

We can't really know this generically.  We can try to set the enable
bit to see if the device is capable of no-snoop, but that doesn't mean
it will use no-snoop.

>  - The IOMMU will let no-snoop through
>  - The platform will honor no-snoop
>=20
> Only if all three are met we should allow the dangerous instruction in
> KVM, right?

We test at the IOMMU and assume that the IOMMU knowledge encompasses
whether the platform honors no-snoop (note for example how amd and arm
report true for IOMMU_CAP_CACHE_COHERENCY but seem to ignore the
IOMMU_CACHE flag).  We could probably use an iommu_group_for_each_dev
to test if any devices within the group are capable of no-snoop if the
IOMMU can't protect us, but at the time it didn't seem worthwhile.  I'm
still not sure if it is.
=20
> Which brings me back to my original point - this is at least partially
> a device specific behavior. It depends on the content of the IOMMU
> page table, it depends if the device even supports no-snoop at all.
>=20
> My guess is this works correctly for the mdev Intel kvmgt which
> probably somehow allows no-snoop DMA throught the mdev SW iommu
> mappings. (assuming I didn't miss a tricky iommu_map without
> IOMMU_CACHe set in the type1 code?)

This support existed before mdev, IIRC we needed it for direct
assignment of NVIDIA GPUs.
=20
> But why is vfio-pci using it? Hmm?

Use the IOMMU to reduce hypervisor overhead, let the hypervisor learn
about it, ignore the subtleties of whether the device actually uses
no-snoop as imprecise and poor ROI given the apparent direction of
hardware.

=C2=AF\_(=E3=83=84)_/=C2=AF,
Alex

