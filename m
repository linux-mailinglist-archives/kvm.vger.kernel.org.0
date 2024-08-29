Return-Path: <kvm+bounces-25352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3599C964620
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E02BC284D93
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 13:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82CE01AAE1E;
	Thu, 29 Aug 2024 13:15:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBB61AD9E0;
	Thu, 29 Aug 2024 13:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937305; cv=none; b=uAueBuv73KYKAMWGhyF+SQTs0UHML2+JXi5kwwAhiGawWLs76nUA+5g9tPB3cgVxoH6meHKg/jVNKmfWOg43aVxnAC2J7zyxeKZaKsgxl/fWrrLAqVgHnzLnwrCPxge1V4i8ggmz/Q96ZHN0w+hNsU7ncvxO1//vjh/y1RSbE8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937305; c=relaxed/simple;
	bh=lihYB3H/FMQYtWTitMrBFoX9tv8ZBPb3PyGsDX7yvMU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PR73RHl6MVzDOiv37ePlprufzNxzONmsyZ1gpLVzhMw+4p6f7Doyp0ZleVNShYNYpzddAF1O/nsyRZGc3vXjuiyC/Va2m/VfmeBLWjsKl7Lb3GcIyvz38mTCezJZknv/xeDPfRpj0b4rYsicrDLbRXIFm3W2BK6069QQidfs27I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WvhZs2vJ2z1j7gZ;
	Thu, 29 Aug 2024 21:14:45 +0800 (CST)
Received: from dggpemf500003.china.huawei.com (unknown [7.185.36.204])
	by mail.maildlp.com (Postfix) with ESMTPS id EEE1E140136;
	Thu, 29 Aug 2024 21:14:57 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf500003.china.huawei.com (7.185.36.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 29 Aug 2024 21:14:57 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Thu, 29 Aug 2024 14:14:55 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Nicolin Chen <nicolinc@nvidia.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, "Guohanjun (Hanjun Guo)"
	<guohanjun@huawei.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Mostafa Saleh
	<smostafa@google.com>
Subject: RE: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Thread-Topic: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Thread-Index: AQHa+JkQkcFFSAeDsUqyXyGP6/LaZLI7ju0AgAFNDID///2PgIAAHqvg///xn4CAAU4tEA==
Date: Thu, 29 Aug 2024 13:14:54 +0000
Message-ID: <d2ad792fe9dd44d38396c5646fa956c6@huawei.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
 <7debe8f99afa4e33aa1872be0d4a63e1@huawei.com>
 <Zs9a9/Dc0vBxp/33@Asurada-Nvidia>
 <cd36b0e460734df0ae95f5e82bfebaef@huawei.com>
 <Zs9ooZLNtPZ8PwJh@Asurada-Nvidia>
In-Reply-To: <Zs9ooZLNtPZ8PwJh@Asurada-Nvidia>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0



> -----Original Message-----
> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Wednesday, August 28, 2024 7:13 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>; acpica-devel@lists.linux.dev;
> Guohanjun (Hanjun Guo) <guohanjun@huawei.com>;
> iommu@lists.linux.dev; Joerg Roedel <joro@8bytes.org>; Kevin Tian
> <kevin.tian@intel.com>; kvm@vger.kernel.org; Len Brown
> <lenb@kernel.org>; linux-acpi@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; Lorenzo Pieralisi <lpieralisi@kernel.org>; Ra=
fael J.
> Wysocki <rafael@kernel.org>; Robert Moore <robert.moore@intel.com>;
> Robin Murphy <robin.murphy@arm.com>; Sudeep Holla
> <sudeep.holla@arm.com>; Will Deacon <will@kernel.org>; Alex Williamson
> <alex.williamson@redhat.com>; Eric Auger <eric.auger@redhat.com>; Jean-
> Philippe Brucker <jean-philippe@linaro.org>; Moritz Fischer
> <mdf@kernel.org>; Michael Shavit <mshavit@google.com>;
> patches@lists.linux.dev; Mostafa Saleh <smostafa@google.com>
> Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
>=20
> On Wed, Aug 28, 2024 at 06:06:36PM +0000, Shameerali Kolothum Thodi
> wrote:
> > > > > As mentioned above, the VIOMMU series would be required to test
> the
> > > > > entire nesting feature, which now has a v2 rebasing on this serie=
s.
> > > > > I tested it with a paring QEMU branch. Please refer to:
> > > > > https://lore.kernel.org/linux-
> > > > > iommu/cover.1724776335.git.nicolinc@nvidia.com/
> > > >
> > > > Thanks for this. I haven't gone through the viommu and its Qemu
> branch
> > > > yet.  The way we present nested-smmuv3/iommufd to the Qemu seems
> to
> > > > have changed  with the above Qemu branch(multiple nested SMMUs).
> > > > The old Qemu command line for nested setup doesn't work anymore.
> > > >
> > > > Could you please share an example Qemu command line  to verify this
> > > > series(Sorry, if I missed it in the links/git).
> > >
> > > My bad. I updated those two "for_iommufd_" QEMU branches with a
> > > README commit on top of each for the reference command.
> >
> > Thanks. I did give it a go and this is my command line based on above,
>=20
> > But it fails to boot very early:
> >
> > root@ubuntu:/home/shameer/qemu-test# ./qemu_run-simple-iommufd-
> nicolin-2
> > qemu-system-aarch64-nicolin-viommu: Illegal numa node 2
> >
> > Any idea what am I missing? Do you any special config enabled while
> building Qemu?
>=20
> Looks like you are running on a multi-SMMU platform :)
>=20
> Would you please try syncing your local branch? That should work,
> as the update also had a small change to the virt code:
>=20
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 161a28a311..a782909016 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1640,7 +1640,7 @@ static PCIBus
> *create_pcie_expander_bridge(VirtMachineState *vms, uint8_t idx)
>      }
>=20
>      qdev_prop_set_uint8(dev, "bus_nr", bus_nr);
> -    qdev_prop_set_uint16(dev, "numa_node", idx);
> +    qdev_prop_set_uint16(dev, "numa_node", 0);
>      qdev_realize_and_unref(dev, BUS(bus), &error_fatal);

That makes some progress. But still I am not seeing the assigned
dev  in Guest.

-device vfio-pci-nohotplug,host=3D0000:75:00.1,iommufd=3Diommufd0

root@ubuntu:/# lspci -tv#

root@ubuntu:/# lspci -tv
-+-[0000:ca]---00.0-[cb]--
 \-[0000:00]-+-00.0  Red Hat, Inc. QEMU PCIe Host bridge
             +-01.0  Red Hat, Inc Virtio network device
             +-02.0  Red Hat, Inc. QEMU PCIe Expander bridge
             +-03.0  Red Hat, Inc. QEMU PCIe Expander bridge
             +-04.0  Red Hat, Inc. QEMU PCIe Expander bridge
             +-05.0  Red Hat, Inc. QEMU PCIe Expander bridge
             +-06.0  Red Hat, Inc. QEMU PCIe Expander bridge
             +-07.0  Red Hat, Inc. QEMU PCIe Expander bridge
             +-08.0  Red Hat, Inc. QEMU PCIe Expander bridge
             \-09.0  Red Hat, Inc. QEMU PCIe Expander bridge

The new root port is created, but no device attached.

But without iommufd,
-device vfio-pci-nohotplug,host=3D0000:75:00.1

root@ubuntu:/# lspci -tv
-[0000:00]-+-00.0  Red Hat, Inc. QEMU PCIe Host bridge
           +-01.0  Red Hat, Inc Virtio network device
           +-02.0  Red Hat, Inc. QEMU PCIe Expander bridge
           +-03.0  Red Hat, Inc. QEMU PCIe Expander bridge
           +-04.0  Red Hat, Inc. QEMU PCIe Expander bridge
           +-05.0  Red Hat, Inc. QEMU PCIe Expander bridge
           +-06.0  Red Hat, Inc. QEMU PCIe Expander bridge
           +-07.0  Red Hat, Inc. QEMU PCIe Expander bridge
           +-08.0  Red Hat, Inc. QEMU PCIe Expander bridge
           +-09.0  Red Hat, Inc. QEMU PCIe Expander bridge
           \-0a.0  Huawei Technologies Co., Ltd. Device a251

We can see dev a251.

And yes the setup has multiple SMMUs(8).

Thanks,
Shameer


