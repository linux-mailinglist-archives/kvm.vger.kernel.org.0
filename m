Return-Path: <kvm+bounces-5445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEB49821F42
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 17:10:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46BA6284270
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 16:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2BA114F92;
	Tue,  2 Jan 2024 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JNteW7S8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296E514F73
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704211810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bBpBokPo04jWOIoRcBmhnD3bzusG0ZZLP3nngj1nknc=;
	b=JNteW7S83c1U+uQsj3NPD/OCh1HTRoPwOEJknzUff9EFKZvdtuq49tmFnNXsowhfjdGkpx
	uYMnj+hLgw55kplr/M7Hhv5Mty46xCfbuPM18v2WviizEUJn38bh7sRc8QM2inpwG7++0V
	c+p0bUL8nwt/Hr11fDN7EVRqGY5Yv4U=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-h-MuaeI4NCeHrJfgqd0RbA-1; Tue, 02 Jan 2024 11:10:04 -0500
X-MC-Unique: h-MuaeI4NCeHrJfgqd0RbA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-36007df1516so66328875ab.1
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 08:10:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704211804; x=1704816604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bBpBokPo04jWOIoRcBmhnD3bzusG0ZZLP3nngj1nknc=;
        b=kN+OzHessin9Aef1rET5x8moMwq0A34GwYR3j6cAF/K8jRZq6KNn4dqVsHkn8bbfFJ
         QJT+5BZhKv5Ex/wqhBNIx8VJ/6yaCFvgtSZVKOx7T2zvEXAqxm5JWKFcHxhHUvTsBzJF
         IVPZDxHVo2lxjIXliK8vlJwsEzFJYJil/ymyJPuQ2+MXDINyY6RLRfsxQMVzYm3gFKBM
         PJ/pBdUTgPiVn9sY6I43IkI1nO7TuSMkzrgU/EECj9izctIb74E2UojGSb2irIkmefuz
         OpDC3N6ZEuh26IlXJVEmcTREtXYb+XAt+Q4x4bZnyeYLyt3BNGxpC1XBnD1QX0dyjyUp
         M66A==
X-Gm-Message-State: AOJu0YwUS9/L0IkrWLM6b9xdL3C5YzI9bRMNrKSsDRdOdbuONP86WDT5
	0qROmtiCb8jGQNrPdoc9ehruBCOmWa9hfdgg64jMuS7Dh2LC9IkvVTuo2gyLkMsLHdQ4w+FoENA
	lEiGKoRhTpG0hy1NLiRe7
X-Received: by 2002:a05:6e02:15c8:b0:360:17bc:4b91 with SMTP id q8-20020a056e0215c800b0036017bc4b91mr14400671ilu.30.1704211803896;
        Tue, 02 Jan 2024 08:10:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGoQUDi8sai2N1OOmWodXNVWhATfexdwBOLX+vBswwM1lOXEJNl0mmrf+/JY0D0fGUeoQHEaQ==
X-Received: by 2002:a05:6e02:15c8:b0:360:17bc:4b91 with SMTP id q8-20020a056e0215c800b0036017bc4b91mr14400656ilu.30.1704211803541;
        Tue, 02 Jan 2024 08:10:03 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id d4-20020a92d5c4000000b0035fac895f48sm7974796ilq.29.2024.01.02.08.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 08:10:02 -0800 (PST)
Date: Tue, 2 Jan 2024 09:10:01 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com"
 <shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
 <kevin.tian@intel.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "brett.creeley@amd.com" <brett.creeley@amd.com>, "horms@kernel.org"
 <horms@kernel.org>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
 <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj
 Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 1/1] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Message-ID: <20240102091001.5fcc8736.alex.williamson@redhat.com>
In-Reply-To: <BY5PR12MB3763179CAC0406420AB0C9BAB095A@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20231217191031.19476-1-ankita@nvidia.com>
	<20231218151717.169f80aa.alex.williamson@redhat.com>
	<BY5PR12MB3763179CAC0406420AB0C9BAB095A@BY5PR12MB3763.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 21 Dec 2023 12:43:28 +0000
Ankit Agrawal <ankita@nvidia.com> wrote:

> Thanks Alex and Cedric for the review.
>=20
> >> +/*
> >> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights re=
served
> >> + */
> >> +
> >> +#include "nvgrace_gpu_vfio_pci.h" =20
> >
> > drivers/vfio/pci/nvgrace-gpu/main.c:6:10: fatal error: nvgrace_gpu_vfio=
_pci.h: No such file or directory
> >=C2=A0=C2=A0=C2=A0 6 | #include "nvgrace_gpu_vfio_pci.h" =20
>=20
> Yeah, managed to miss the file. Will fix that in the next version.
>=20
> >> +
> >> +static bool nvgrace_gpu_vfio_pci_is_fake_bar(int index)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 return (index =3D=3D RESMEM_REGION_INDEX ||
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 index =3D=3D USEMEM_=
REGION_INDEX);
> >> +} =20
> >
> > Presumably these macros are defined in the missing header, though we
> > don't really need a header file just for that.=C2=A0 This doesn't need =
to be
> > line wrapped, it's short enough with the macros as is. =20
>=20
> Yeah that and the structures are moved to the header file.
>=20
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 info.flags =3D VFIO_REGION_INFO_FLAG_READ |
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 VFIO_REGION_INFO_FLAG_WRITE |
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 VFIO_REGION_INFO_FLAG_MMAP; =20
> >
> > Align these all:
> >
> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.flags =3D VFIO_REGION_IN=
FO_FLAG_READ |
> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VFIO_REGION_INFO_FLAG_WRITE |
> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VFIO_REGION_INFO_FLAG_MMAP=
; =20
>=20
> Ack.
>=20
> >> +
> >> +static bool range_intersect_range(loff_t range1_start, size_t count1,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 loff_t range2_start, size_t count2,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 loff_t *start_offset,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t *intersect_count,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t *register_offset) =20
> >
> > We should put this somewhere shared with virtio-vfio-pci. =20
>=20
> Yeah, will move to vfio_pci_core.c
>=20
> >> +
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 if (range_intersect_range(pos, count, PCI_BA=
SE_ADDRESS_2, sizeof(val64),
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &copy_offset, &copy_count, &register_o=
ffset)) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 bar_size =3D roundup_pow_of_two(nvdev->resmem.memlength);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 nvdev->resmem.u64_reg &=3D ~(bar_size - 1);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 nvdev->resmem.u64_reg |=3D PCI_BASE_ADDRESS_MEM_TYPE_64 |
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 PCI_BASE_ADDRESS_MEM_PREFETCH;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 val64 =3D cpu_to_le64(nvdev->resmem.u64_reg); =20
> >
> > As suggested and implemented in virtio-vfio-pci, store the value as
> > little endian, then the write function simply becomes a
> > copy_from_user(), we only need a cpu native representation of the value
> > on read. =20
>=20
> Ack.
>=20
> >> +
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 if (range_intersect_range(pos, count, PCI_CO=
MMAND, sizeof(val16),
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &copy_offset, &copy_count, &register_o=
ffset)) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (copy_from_user((void *)&val16, buf + copy_offset, copy_count))
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EFAULT;
> >> +
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (le16_to_cpu(val16) & PCI_COMMAND_MEMORY)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nvdev->bars_disabled =
=3D false;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 else
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nvdev->bars_disabled =
=3D true; =20
> >
> > nvdev->bars_disabled =3D !(le16_to_cpu(val16) & PCI_COMMAND_MEMORY);
> >
> > But you're only tracking COMMAND_MEM relative to user writes, memory
> > will be disabled on reset and should not initially be enabled. =20
>=20
> I suppose you are suggesting we disable during reset and not enable until
> VM driver does so through PCI_COMMAND?

Unless we're working with a VF, MMIO space of a physical device is
governed by the the memory enable bit in the command register, so how
do we justify that these manufactured BARs don't have standard physical
function semantics, ie. they're accessible regardless of the command
register?  Further, if we emulate any of those semantics, we should
emulate all of those semantics, r/w as well as mapped access.

> > But then also, isn't this really just an empty token of pretending this
> > is a PCI BAR if only the read/write and not mmap path honor the device
> > memory enable bit?=C2=A0 We'd need to zap and restore vmas mapping these
> > BARs if this was truly behaving as a PCI memory region. =20
>=20
> I can do that change, but for my information, is this a requirement to be
> PCI compliant?=20

I think it all falls into the justification of why this variant driver
chooses to expose these coherent and non-coherent ranges as PCI BARs.
A PCI BAR would follow the semantics that its accessibility is governed
by the memory enable bit.  The physical platform exposes these as
ranges exposed through ACPI, maybe in part exactly because these ranges
live outside of the PCI device semantics.

> > We discussed previously that access through the coherent memory is
> > unaffected by device reset, is that also true of this non-cached BAR as
> > well? =20
>=20
> Actually, the coherent memory is not entirely unaffected during device re=
set.
> It becomes unavailable (and read access returns ~0) for a brief time duri=
ng
> the reset. The non-cached BAR behaves in the same way as they are just
> as it is just a carved out part of device memory.=20

So the reset behavior is at least safe, but in tying them to a PCI BAR
we don't really honor the memory enable bit.
=20
> > TBH, I'm still struggling with the justification to expose these memory
> > ranges as BAR space versus attaching them as a device specific region
> > where QEMU would map them into the VM address space and create ACPI
> > tables to describe them to reflect the same mechanism in the VM as used
> > on bare metal.=C2=A0 AFAICT the justification boils down to avoiding wo=
rk in
> > QEMU and we're sacrificing basic PCI semantics and creating a more
> > complicated kernel driver to get there.=C2=A0 Let's have an on-list
> > discussion why this is the correct approach. =20
>=20
> Sorry it isn't clear to me how we are sacrificing PCI semantics here. What
> features are we compromising (after we fix the ones you pointed out above=
)?
>=20
> And if we managed to make these fake BARs PCI compliant, I suppose the
> primary objection is the additional code that we added to make it complia=
nt?

Yes, it's possible to add support that these ranges honor the memory
enable bit, but it's not trivial and unfortunately even vfio-pci isn't
a great example of this.  The fault handling there still has lockdep
issues and arguably has more significant mm issues.  OTOH, there are no
fixed semantics or precedents for a device specific region.  We could
claim that it only supports mmap and requires no special handling
around device reset or relative to the PCI command register.  The
variant driver becomes a trivial implementation that masks BARs 2 & 4
and exposes the ACPI range as a device specific region with only mmap
support.  QEMU can then map the device specific region into VM memory
and create an equivalent ACPI table for the guest.

I know Jason had described this device as effectively pre-CXL to
justify the coherent memory mapping, but it seems like there's still a
gap here that we can't simply hand wave that this PCI BAR follows a
different set of semantics.  We don't typically endorse complexity in
the kernel only for the purpose of avoiding work in userspace.  The
absolute minimum should be some justification of the design decision
and analysis relative to standard PCI behavior.  Thanks,

Alex

> >> +=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D nvgrace_gpu_map_device_mem(nvdev, in=
dex);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 goto read_exit; =20
> >
> > We don't need a goto to simply return an error. =20
>=20
> Yes, will fix that.
>=20
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 if (index =3D=3D USEMEM_REGION_INDEX) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (copy_to_user(buf, (u8 *)nvdev->usemem.bar_remap.memaddr + offset, m=
em_count))
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EFAULT;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 } else {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 return do_io_rw(&nvdev->core_device, false, nvdev->resmem.bar_remap.ioa=
ddr,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 (char __user *) buf, offset, mem_count, 0, 0, fals=
e); =20
> >
> > The vfio_device_ops.read prototype defines buf as a char __user*, so
> > maybe look at why it's being passed as a void __user* rather than
> > casting. =20
>=20
> True, will fix that.
>=20
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 /* Check if the bars are disabled, allow access otherwise */
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 down_read(&nvdev->core_device.memory_lock);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (nvdev->bars_disabled) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up_read(&nvdev->core_de=
vice.memory_lock);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EIO;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 } =20
> >
> > Why do we need bars_disabled here, or at all?=C2=A0 If we let do_io_rw()
> > test memory it would read the command register from vconfig and all of
> > this is redundant. =20
>=20
> Yes, and I will make use of the same flag to cover the
> USEMEM_REGION_INDEX cacheable device memory accesses.
>=20
> >> -static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_=
mem,
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void __iomem *io, char =
__user *buf,
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 loff_t off, size_t coun=
t, size_t x_start,
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t x_end, bool iswr=
ite)
> >> +ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 void __iomem *io, char __user *buf,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 loff_t off, size_t count, size_t x_start,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 size_t x_end, bool iswrite) =20
> >
> > This should be exported in a separate patch and renamed to be
> > consistent with other vfio-pci-core functions. =20
>=20
> Sure, and will rename with vfio_pci_core prefix.
>=20
> >> @@ -199,6 +199,7 @@ static ssize_t do_io_rw(struct vfio_pci_core_devic=
e *vdev, bool test_mem,
> >>
> >>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return done;
> >>=C2=A0 }
> >> +EXPORT_SYMBOL(do_io_rw); =20
> >
> > NAK, _GPL.=C2=A0 Thanks, =20
>=20
> Yes, will make the change.
>=20
> >./scripts/checkpatch.pl --strict will give you some tips on how to =20
> improve the changes furthermore.
>=20
> Yes, will do that.
>=20


