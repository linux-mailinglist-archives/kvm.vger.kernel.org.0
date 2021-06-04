Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B0B39B261
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 08:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhFDGKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 02:10:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:45613 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229820AbhFDGKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 02:10:19 -0400
IronPort-SDR: 61+OtExLDB+B8b+QMpzBK/HLfumuLP5uEkXxqko/SZ13qAHLrnc7ChEw4n8AmXNAMH5ROJ5rXJ
 6l08o47vw/Ag==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="202372035"
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="202372035"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 23:08:33 -0700
IronPort-SDR: B1sfWR+8awBOguLyofc+qd0bIdlJClReBSm0EkfXoRbjRwaQ9/W2lryMtIVUdjuAg/emWEg7Xo
 MNxIiKewvAOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="448147637"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 03 Jun 2021 23:08:33 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 23:08:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 3 Jun 2021 23:08:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 3 Jun 2021 23:08:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dB9ak3mhMLWk08xQ/A+dZk5Wo5SXSvYReD5YdWYoET+E2YB+6LFvmfrkS3VgY02+krUC8phyN5C4UX2m8WzTzJlNR2/xA8piSOZvhn1MoeCxkLmPZ7DM/L+sGPeNh14zULP7S1hOUxYSKznCanRdo97kuBuhOwLJj1MyW3F4ON/D9aqfkYdxWmMa7ia2jryVgdGLckZs9cBWF2UUtq9QNRhNm1ErNm1P26nZ6unSxE5JtAgxB+hyWERh+PN5CYgUw5Vp3UqJ4+c9I2dYbFL6j51Gu3r36b/+llmjTB6xHw/9wD/d1ZsS9Ic1A+4NTBi7MHK2EffmK7EK+FOkS72E8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Go8zzEDmm/LaFFSo0eReOvhHh+T9Ks8CnYPRzM51/lk=;
 b=GxyWRLg7XQTEhMmpJGZpRF4877jmo0E/498Ew+Vmt89E/MkGiYb6+iCrHStXnFoI1hcOFzqu1fUMrWsj0KaWaPenSd/ofzQ6QfEpr1lHuzaEt/zXIFxbuZNu0ZNp3sz3p8qmdrPvjeVWGl/4fyL5U6hs/MyA/uJB3aai/LqOInXNxXLjBCDFpg5y8q7dNuPJPlfSSe4GR5ufetY0qduAW7zJ6ykvvk/MeTUyjEYvEjIQxNeM2DwmYmiI7YinHVYAWr5yKVYpk9olXDzSlUo6IHL/0NDdFjd0iYp1aqY6pVqUYW2RjguCdBSS61FZeQQzd2BWCjEsZ3HOo9oxuQQOQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Go8zzEDmm/LaFFSo0eReOvhHh+T9Ks8CnYPRzM51/lk=;
 b=fnjtMUCfdhnEeQSbVOsz8zrQ59i3C6NZSFEAzB7jXCtVznjhl5p6M7Y/tlWCtmpNcJ66Di1O1uyY8RWc/wojCOEcYp90mYN4mTzzY9cNSb1SkaOpEQVGhkm7ZBMXSKNqztmUIdDWlcrIM1pC+7oCHE/21XAz9AuqIpv9VyhYHQw=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1549.namprd11.prod.outlook.com (2603:10b6:301:c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Fri, 4 Jun
 2021 06:08:28 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.023; Fri, 4 Jun 2021
 06:08:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        David Gibson <david@gibson.dropbear.id.au>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBLsqGAAN/dRYAAFU5FAAAaxTKAAA16g4AAJNcEoA==
Date:   Fri, 4 Jun 2021 06:08:28 +0000
Message-ID: <MWHPR11MB18860FD2BA740E11B3A6B2B58C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com> <YLcpw5Kx61L7TVmR@yekko>
 <20210602165838.GA1002214@nvidia.com> <YLhsZRc72aIMZajz@yekko>
 <20210603121105.GR1002214@nvidia.com>
In-Reply-To: <20210603121105.GR1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc5e9fbb-2dd5-432d-2e3b-08d9271f2bf9
x-ms-traffictypediagnostic: MWHPR11MB1549:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1549EDFE0406C0800BCE26BA8C3B9@MWHPR11MB1549.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k2ICEGW6KawqlMGV4k+IhJDfw7VwnTtktTJqVv9tEjJrCRL9+nsLnnxz8Hl3pjKmg3sJ4gJ7cGuOi4/FHnbXGIHKJnzLwmgocI6MpKAQkF15Ju9jhWvAOpBme+7yItLQz9WmsV5+bVzJzEQDojrc3ds/B4W2j7Am2Ed3OzPN567YhNuufAHjpLrRjIOgp0KLnG1uQbHpOB0Faet6Z/xdO71sNDrsuIk8nMD3crif9g33sRr+2yZQsDBNoOs6KKbo/+iVYBvWlI0igO69+xkY4YW0fZW37J8qwdpz/LtX9qe9c6i0rxMOuk1PQxHXZBBj2zx/LUeavHnW01/wsZwuJBXa98FfX2YHDAhUNmZ69NEU5eHQ3XZAWP2imZWML/+BxFhRXJu6QvPG2GFVaQWWdO7DVMfBIMKXOQIWlEuVFc4wznydOFt4LyYh1Ty0Z0DVInnVe63w6OLcGnlJ2XXmuD5WMxdf0y2tLQ5w4k6ANnHwk5+pLpEFOec+dmtc0gZk2kLm3YIa3TLSnp3P5sOHOCI0x7pZzpibFcaUErfjNVDkjKdGJIXM81bNyOenQvyivP0XCqBACTYY59feYd5mbNkFUxz1OC4KCn92F+MIm6E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(396003)(39860400002)(346002)(5660300002)(7416002)(76116006)(52536014)(4326008)(66476007)(86362001)(66556008)(38100700002)(66946007)(66446008)(110136005)(122000001)(54906003)(8936002)(64756008)(33656002)(83380400001)(9686003)(55016002)(478600001)(8676002)(26005)(186003)(6506007)(2906002)(7696005)(71200400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KWhsMgsWdFywHeabn5ji/CI0Zy3aelMAvC3ChOQrvOHL1r+oU9qkeWYCTPAS?=
 =?us-ascii?Q?rwBpeJQnFJGO2ZoI31jdkKYeuKxF3iqJ3wW9OjaCz3D85dW9r7J/mVqTxSsV?=
 =?us-ascii?Q?gioREmixgPwzhxqcJg85Ee0ykvJVdaLHEQGXXmtsCWd3MIn8hdlr2XZNNpXQ?=
 =?us-ascii?Q?gFDonujUP9a5/rBJfQM/OTjKne7CZ2L6cEco4OMAx2rG8tSTXTdmCiuHp2hi?=
 =?us-ascii?Q?orLwkUR+Ht4yT/NlMlEWOJkIQTBGB7kXV/48OIjt4z06q+mI+PEMPJptlyiz?=
 =?us-ascii?Q?ghKwTVlmhVaT5AGUXVNo6uyWHtxvee5S4yNxuayVNR6V8L1A+rjbDihMe2gW?=
 =?us-ascii?Q?RuSeQoLxKW9LV3HTApD0eOJtA8ekhg9+/QCf1HIqIuCSBj0iG7tp2e8SRPzh?=
 =?us-ascii?Q?S9I9aIp2gBxyx6l7hymUYf9w4fcyOhjd+WNkTxZy4tBGOd36gsT/KjsIPvgS?=
 =?us-ascii?Q?OFu9DPjuk8pB7tguX4fEyBEW2ncXaUFmkwtT38Z7Q22UPZUz+5TcxzkDHUwM?=
 =?us-ascii?Q?OhfRIj9bKXP82sNPXhGgDwexjfi/51ZHtVTHtJe71uIOJx9FMMupgIlMviIU?=
 =?us-ascii?Q?jx1flyIXV4VAc9q6ar0r2qT62SuumWTzx2DZMyqS2bx32F4tIiNc0UCHy/Ze?=
 =?us-ascii?Q?IsgO17BoIYUrBu8YBnr4uy3RFOQPQS7VkmQxQLHp7F//BYO61q8TP3nCmfoE?=
 =?us-ascii?Q?0+VRwPps/yeyRGcEVMsBOnA4wCdvno/ZPW/Nx21Ja4wKw2Bg20IMYzkzuQ2K?=
 =?us-ascii?Q?/zBiscdlmgy1kkxcZ5zpeZrQdCrDLnmTBjzS8q8+bPEsNrtQuUACwOZClXmf?=
 =?us-ascii?Q?QXwVkC313vUeFdmcmgQlPIJudcBZl81QyGuLYUZJtSQ0TgS8PB4Woe/TX67z?=
 =?us-ascii?Q?bg3B5297BGRswzep0VaSSxJEgRmda5ptGkGO7EVA1x0H0N9FZjhW4qdZIaET?=
 =?us-ascii?Q?ah0+r8r3ftIfxgNCbXqfr8groAxQWA/t5ubxT01IxsOxKfENAQMm8uJ8mgOz?=
 =?us-ascii?Q?s27tnZLCl8d6+RoWNI6nGDvNUDRA/MzsAdtjDKwrFHy7iRXZECbfp8IO4DS7?=
 =?us-ascii?Q?6d6BXO8yknw3aysRgkjkmYEyPom2fTyEfQolb0rKwBRWar6zuaWdCaJARjX/?=
 =?us-ascii?Q?83W1fTysAXEmYAYBZYc9x9E0OkZv5jWHs0qDR1d2KwDto1s3NUoB9J94iDaw?=
 =?us-ascii?Q?Yf/PZSsNKS17lWZkRdMExwJJxXj2PM3lrfSjCFLnJKWAqH0acOGzGm+L+PGb?=
 =?us-ascii?Q?0pfpeqI3zsrPHHmaEN0nyOPomk2UzHmCVygskkuF4FEA61CmNL4xku8EEOSc?=
 =?us-ascii?Q?Hy2X3KYcTlagkWwUsof4jpJ/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc5e9fbb-2dd5-432d-2e3b-08d9271f2bf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 06:08:28.1947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wh+64C1aZ4yjGQKE5n8AWAzCk/MbW+uTnP5ewwAjrXK3oqGiwFQE6Xm7Egf6Eo9hLpeliQx6sm2pRgbpsN1rrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1549
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 3, 2021 8:11 PM
>=20
> On Thu, Jun 03, 2021 at 03:45:09PM +1000, David Gibson wrote:
> > On Wed, Jun 02, 2021 at 01:58:38PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Jun 02, 2021 at 04:48:35PM +1000, David Gibson wrote:
> > > > > > 	/* Bind guest I/O page table  */
> > > > > > 	bind_data =3D {
> > > > > > 		.ioasid	=3D gva_ioasid;
> > > > > > 		.addr	=3D gva_pgtable1;
> > > > > > 		// and format information
> > > > > > 	};
> > > > > > 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);
> > > > >
> > > > > Again I do wonder if this should just be part of alloc_ioasid. Is
> > > > > there any reason to split these things? The only advantage to the
> > > > > split is the device is known, but the device shouldn't impact
> > > > > anything..
> > > >
> > > > I'm pretty sure the device(s) could matter, although they probably
> > > > won't usually.
> > >
> > > It is a bit subtle, but the /dev/iommu fd itself is connected to the
> > > devices first. This prevents wildly incompatible devices from being
> > > joined together, and allows some "get info" to report the capability
> > > union of all devices if we want to do that.
> >
> > Right.. but I've not been convinced that having a /dev/iommu fd
> > instance be the boundary for these types of things actually makes
> > sense.  For example if we were doing the preregistration thing
> > (whether by child ASes or otherwise) then that still makes sense
> > across wildly different devices, but we couldn't share that layer if
> > we have to open different instances for each of them.
>=20
> It is something that still seems up in the air.. What seems clear for
> /dev/iommu is that it
>  - holds a bunch of IOASID's organized into a tree
>  - holds a bunch of connected devices
>  - holds a pinned memory cache
>=20
> One thing it must do is enforce IOMMU group security. A device cannot
> be attached to an IOASID unless all devices in its IOMMU group are
> part of the same /dev/iommu FD.
>=20
> The big open question is what parameters govern allowing devices to
> connect to the /dev/iommu:
>  - all devices can connect and we model the differences inside the API
>    somehow.

I prefer to this option if no significant block ahead.=20

>  - Only sufficiently "similar" devices can be connected
>  - The FD's capability is the minimum of all the connected devices
>=20
> There are some practical problems here, when an IOASID is created the
> kernel does need to allocate a page table for it, and that has to be
> in some definite format.
>=20
> It may be that we had a false start thinking the FD container should
> be limited. Perhaps creating an IOASID should pass in a list
> of the "device labels" that the IOASID will be used with and that can
> guide the kernel what to do?

In Qemu case the problem is that it doesn't know the list of devices
that will be attached to an IOASID when it's created. This is a guest-
side knowledge which is conveyed one device at a time to Qemu=20
though vIOMMU.

I feel it's fair to say that before user wants to create an IOASID he
should already check the format information about the device which
is intended to be attached right after then when creating the IOASID
the user should specify a format compatible to the device. There is=20
format check when IOASID is created, since its I/O page table is not
installed to the IOMMU yet. Later when the intended device is attached
to this IOASID, then verify the format and fail the attach request if
incompatible.

Thanks
Kevin
