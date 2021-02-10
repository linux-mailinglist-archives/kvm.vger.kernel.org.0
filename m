Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0B131681B
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 14:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhBJNfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 08:35:43 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5319 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhBJNfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 08:35:38 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023e1000000>; Wed, 10 Feb 2021 05:34:56 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 13:34:55 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 13:34:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQXZn3vGoPYu6b3nF0PFBEB7JBQhCLazRlc4shMC7ElBt0exX+ltqYE74Ny+DOykFDyyTAVTxYX9eQv+9O7JZW79WCK23TMlMhu3LpQQafmZFQm8kMilGvpuGG0cxbBJzYfcEgpqiuYSypGfPYgGr5Q6qiXAg3idbM1B3mKr6rYZDuCP8wdZI33WYxqZrWZ5j4zCCqG9lfVAlHDBF897Kgr++g29zCgtPe0GQz4NoMBbwq1Vi3+sebadvuYFJTIpxNbdviJ7QuRHRrPBAZ17k0jhnB9BwLhNF1UEUtT3gP7XxHNa0wliwJWmT2fQtR6UFD3CINgJi+Ik9Mxyl+5dkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BX90xb9kBpIhs/sBVmCDM0VJTidLOFK8DWfcHaOsyF8=;
 b=k/uTPLAnZgjnou8OzgW6G71AoDmMwi5iL2p68xM6YjB3cpcVXX/RD70xy/Th8PtUiKhAhcOscWehjZH+RINi3r96rVIE+eZRm0ZvLvZJxNdqKN76WhkxcYoRzxlHoMewB3qB1JYg1g+c36tpu0hDXjcqB1SsJfRTjebhnrTpiDhcDxJ6OGri9hoBWdA9HK9hT9mmA4ms2awhUyqhJOZc2JW9wugiIw4myNXOp65VMxvo24oK4i2gVByzt+Reu4JKM7DTr7t9+T9OEwn8HXc7s/dj/gDCrvzYVA3C/KHEvXpWerZ2ZR8Ah6Wr++eWVBeDsL5WcHN66h4i/4a9Kwb2nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2488.namprd12.prod.outlook.com (2603:10b6:4:b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Wed, 10 Feb
 2021 13:34:54 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 13:34:53 +0000
Date:   Wed, 10 Feb 2021 09:34:52 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "liranl@nvidia.com" <liranl@nvidia.com>,
        "oren@nvidia.com" <oren@nvidia.com>,
        "tzahio@nvidia.com" <tzahio@nvidia.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "yarong@nvidia.com" <yarong@nvidia.com>,
        "aviadye@nvidia.com" <aviadye@nvidia.com>,
        "shahafs@nvidia.com" <shahafs@nvidia.com>,
        "artemp@nvidia.com" <artemp@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "ACurrid@nvidia.com" <ACurrid@nvidia.com>,
        "gmataev@nvidia.com" <gmataev@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 0/9] Introduce vfio-pci-core subsystem
Message-ID: <20210210133452.GW4247@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <MWHPR11MB18867A429497117960344A798C8D9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <MWHPR11MB18867A429497117960344A798C8D9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR11CA0021.namprd11.prod.outlook.com
 (2603:10b6:208:23b::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR11CA0021.namprd11.prod.outlook.com (2603:10b6:208:23b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 13:34:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l9pds-005rQn-CM; Wed, 10 Feb 2021 09:34:52 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612964096; bh=UoQcNyiFY97yQ+UdvJgsciYzIHzh/G0qVQ0SuDeyD0Y=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:Content-Transfer-Encoding:In-Reply-To:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=YDAaNnaB5PcakRan0aZm22dMMZSFuEDzFLm8vBOlA482JhmspGm5KJcdRRwdTlirO
         r8qes3XHLDNAB4gJrU2mxAc1QfsAw2eAsRINZ8iOF8vL/s+1i2FQTAKEaz34wFHRxY
         2Q2rAzPdck0IeE0bOqisABhvmT1BdtUgbL8ikaGLXei3wtR+wcUyBQQlsxbDS9G81r
         d6h5ms6l0dhmYnpR00rmjqBFr6SjFb+/in5849AAOdvhnvgnhpqLAbk6fHcF+kWL6F
         q7QlYv0JVpD/iNfPof872CmBfshe8Z53nCMDzlF3N7EndGtznv3dYHH+clImOtuqji
         ZqsdBUZqZcP1A==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 07:52:08AM +0000, Tian, Kevin wrote:
> > This subsystem framework will also ease on adding vendor specific
> > functionality to VFIO devices in the future by allowing another module
> > to provide the pci_driver that can setup number of details before
> > registering to VFIO subsystem (such as inject its own operations).
>=20
> I'm a bit confused about the change from v1 to v2, especially about
> how to inject module specific operations. From live migration p.o.v
> it may requires two hook points at least for some devices (e.g. i40e=20
> in original Yan's example):

IMHO, it was too soon to give up on putting the vfio_device_ops in the
final driver- we should try to define a reasonable public/private
split of vfio_pci_device as is the norm in the kernel. No reason we
can't achieve that.

>  register a migration region and intercept guest writes to specific
> registers. [PATCH 4/9] demonstrates the former but not the latter
> (which is allowed in v1).

And this is why, the ROI to wrapper every vfio op in a PCI op just to
keep vfio_pci_device completely private is poor :(

> Then another question. Once we have this framework in place, do we=20
> mandate this approach for any vendor specific tweak or still allow
> doing it as vfio_pci_core extensions (such as igd and zdev in this
> series)?

I would say no to any further vfio_pci_core extensions that are tied
to specific PCI devices. Things like zdev are platform features, they
are not tied to specific PCI devices

> If the latter, what is the criteria to judge which way is desired? Also w=
hat=20
> about the scenarios where we just want one-time vendor information,=20
> e.g. to tell whether a device can tolerate arbitrary I/O page faults [1] =
or
> the offset in VF PCI config space to put PASID/ATS/PRI capabilities [2]?
> Do we expect to create a module for each device to provide such info?
> Having those questions answered is helpful for better understanding of
> this proposal IMO. =F0=9F=98=8A
>=20
> [1] https://lore.kernel.org/kvm/d4c51504-24ed-2592-37b4-f390b97fdd00@huaw=
ei.com/T/

SVA is a platform feature, so no problem. Don't see a vfio-pci change
in here?

> [2] https://lore.kernel.org/kvm/20200407095801.648b1371@w520.home/

This one could have been done as a broadcom_vfio_pci driver. Not sure
exposing the entire config space unprotected is safe, hard to know
what the device has put in there, and if it is secure to share with a
guest..

> MDEV core is already a well defined subsystem to connect mdev
> bus driver (vfio-mdev) and mdev device driver (mlx5-mdev).

mdev is two things

 - a driver core bus layer and sysfs that makes a lifetime model
 - a vfio bus driver that doesn't do anything but forward ops to the
   main ops

> vfio-mdev is just the channel to bring VFIO APIs through mdev core
> to underlying vendor specific mdev device driver, which is already
> granted flexibility to tweak whatever needs through mdev_parent_ops.

This is the second thing, and it could just be deleted. The actual
final mdev driver can just use vfio_device_ops directly. The
redirection shim in vfio_mdev.c doesn't add value.

> Then what exact extension is talked here by creating another subsystem
> module? or are we talking about some general library which can be
> shared by underlying mdev device drivers to reduce duplicated
> emulation code?

IMHO it is more a design philosophy that the end driver should
implement the vfio_device_ops directly vs having a stack of ops
structs.

Jason
