Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B7E396F0D
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbhFAIjw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:39:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:14211 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231139AbhFAIju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:39:50 -0400
IronPort-SDR: lnaO/ir8U4pnoPnr6QOFeHEueLfXHbi41Z0FSsEPfSRQZugOi7ET7vkGRnFWfw1BpLxYuoYrG6
 arPtxdSCGf3Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="201634730"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="201634730"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:38:08 -0700
IronPort-SDR: 9rp6pOGsIEs8ILyyrY7eJ9xFu2Nl6QFFV0mqWywHwKYYFnEOBQRhOXhIxmQXVnIBt/FHLTIwb8
 WXnLo9Pbci+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="446877303"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jun 2021 01:38:07 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 1 Jun 2021 01:38:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 1 Jun 2021 01:38:03 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 1 Jun 2021 01:38:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wmu3/f6VPMcRJqWI564bg8xdihNeDoEtra1wd4rG05g8W+bLtkXLajo8RRATAM4QfafI8oc2ZZN9xWvzr1vaYl+G9mmj4v9DpJlJcpaNW1H1EHh+j2A/4nerwTJRw1kPNJZn+mkKYgKDsBM3mGlE1wEc9EJmYrPS0tOA1CAHr/coOum4hbaMTqBHh/BCmYxjH6ZMoO7ybXX9XQ9/+8GZ+0jiIE5PQS//M7Xu3MxqP0Mc4Mxt+WWwIDVKqjTxsBeCXxNEQzIAIlldx3kH68KEWeZ0kbRL2mnYUgmwsqnQGL3+CYtRW9DKfzyFayqdoC3HXT2tGLAql24aFg8AbzO7WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1s+XpvQfIJOaOHcOGr/hS/vtPq3/S4uaLmSyveQ52k=;
 b=GBO3SJ/p7ev+bWTcctYsxa6nKQcUC1CTq0yNE1yZy9rZ5Hgs8PFCeAqA0e25Uk6fvKbB35UDNSL5g8yToYsAcOypGTVAg2IUI4t0mWrXF/gGfUOYMg+w2QlrqGwqytHtbgOHx1Kv6qT0og3EnZZyOVFA+zGtheu7Hmz0SzkSDVdWNXZOq9/t5v6pAUtz2JcfSwkueVkq2qaXbT1rnhYuyTmKypzBBkum4TkwX0eNsSYhiNSC84bkYKkfJY4eS3+gr6v93dFJdOxIV1RzT8GF5TnaGtscDzGsz2uq3IXjT/ferwl3peSFfO/iQl5EZs3avCo5pGo6aIM9U4PJcL2vVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1s+XpvQfIJOaOHcOGr/hS/vtPq3/S4uaLmSyveQ52k=;
 b=E9+Hao1tIhJ0Tg29zZAz/OhvZhCLwydsHuL18+ykrLhlc4O5OY5A0U+eLMBo/HBskasdBSmu+GCwcBLNhQ8dO317pU2PKv5BmwDvsyw3MowJmZgb00lblyOPdAN64kRs0Y2Jc8sweu+0bJKtmtx4ae4BEEsZDbIYOuD/Qqeqk6o=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1837.namprd11.prod.outlook.com (2603:10b6:300:10f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 08:38:01 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 08:38:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
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
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBLsqGAALCWeVA=
Date:   Tue, 1 Jun 2021 08:38:00 +0000
Message-ID: <MWHPR11MB1886A17F36CF744857C531148C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
In-Reply-To: <20210528195839.GO1002214@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 97a59c20-8036-4b93-4c88-08d924d890c5
x-ms-traffictypediagnostic: MWHPR11MB1837:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1837EE6279D8BF24DE21A7E78C3E9@MWHPR11MB1837.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +/mSFDpmGyNSZP8QRpp3cX4adfzDSuY1JNi4ag66SmJL/TrBDQOF7id/R1kSKfijfGX07Y2MDXGmDgr1f0y3BGLFsmhE4RqVzH+oJoGCqA75e6fsW8FS/jWjvMWrCkSizW1erCgScT//5WdqJbhCTlgYSL+QMQBF+2KTUPGJcUWWYdyDD6SIX7HEL0gcfxBPC9uObMAj53q6hPNk9gShoSjP0TY/49b9bUGr+P9TMWVvZsE+vBmddHDLFIvy8BG9Twa9Cdy/aBXH6ZCQxfx/KEN97o1pna9pp6L1u+1VG9aj0LQknV1lgn9JUz4DFQq4OWmey3I5cr8oXeN7kV2Dng2aGuMM2t8G0+3h1Xh1XdM03fsCfgsS2s5rv6mLhReoG8Agx12MXjHcCVuQ9ULhPBb806RXAFADdzD/45HKuBPY9V7t0FyvccfbklNeP0BwzUlnsaAaTeh5CcAmBeXvLuKW0xnmdlzsHNeFGsrqux1XCs/ZV48y2BHAXqhjBBFCaYBOaQMg75MPv15tCjb5X71T/BrtoECrOmw24nUxx5oPnbQHSyWwaJG+HxHU3ANxkKwciFZ9qxF276U9TdQIHQc973rlzIq/v0bFrFaTK3c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(346002)(39860400002)(6506007)(38100700002)(55016002)(33656002)(7416002)(5660300002)(71200400001)(9686003)(6916009)(7696005)(26005)(186003)(83380400001)(478600001)(122000001)(64756008)(30864003)(66446008)(76116006)(316002)(66946007)(8936002)(8676002)(2906002)(66556008)(66476007)(86362001)(54906003)(52536014)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qu3J82PnHrSqrNSYjg6XMpnX3kGbYogZvfQ7ZKdXH94WxoLUNp/1+0XphYqV?=
 =?us-ascii?Q?Lx5E4DkG9zMTiMk21pVOOO3LOicYtBKXbujDYRZwierZxCuPFlV+Gh0Un2Qd?=
 =?us-ascii?Q?4VjowgZcV+Vzj+r7QfwSEWx0Ng5ryJkUaQOga0bnosGikIn/w5wVR66W8kmo?=
 =?us-ascii?Q?YQIqgWtTsvBAfXLNN2nVbomVvkE//NSc39fMpebgJAZeKiSI3dHzJ8WZIzcR?=
 =?us-ascii?Q?eCoQAJnnE+Lb5vToz7sMZGdwlfGRe3z7dRRgg1KY9fU1NziwhSOMYCH8kFnF?=
 =?us-ascii?Q?exh5TlfvY4eUGl17FRF4QSOuIAnS82JgKGgEhnJ6pM+5XNHm1esxHk0nxRoU?=
 =?us-ascii?Q?eNb7ca++A3yvCqPtjvPTtWyiFQ73jy6WarjiXcvRWvevmfykGA6Fl8YdM4og?=
 =?us-ascii?Q?8Ih3k0ARy9f6MZDybsKdBxzGVYOVcoQyrw1kPw35kvX20Q0kEIKtc/DqGJa2?=
 =?us-ascii?Q?GpFcMRp0gpSRzfXIlm2Y842paabdImD8x3c6EhcxvycBUfYQ8r+ZO7Q/mcRZ?=
 =?us-ascii?Q?q7nT9utJUiZfbbcWxsrrH93KtOim4D0lEVHYbsEUHHh8Re21d+5MRsDaS90P?=
 =?us-ascii?Q?JlNz0lVoA+XQP8/bRMDh7Efb0hcVDdvKDUG68mDO8XNllLd0SCFGRmNT9F3V?=
 =?us-ascii?Q?88aEitIdL+dbtSdfyDioHrV9mgr6zfoOQhrE0ri5T+cD+gU3st0e28UKIkds?=
 =?us-ascii?Q?j3Qn9Yp7yQJ4zDqCY+Uh4OHKHpLG0vyugv936wbxVRxe9XQuFN+OIcj0Svov?=
 =?us-ascii?Q?1BeJ2aOpUFSU2asecnIMc3QIp9Zh81aKauzOTnsmQlVxtaKW/mbudjqMCmh5?=
 =?us-ascii?Q?uxmXzsb3tv9J44S/0wxoISagViS5pLxjfdDLjTn0SZ9IpWH51rIQuKJP6TFK?=
 =?us-ascii?Q?8qC2OfeW4Etb98S2x7lQHKtufh+6n8Wlhbrvp1sKP9BK4ni8t8i/O9ID9YQy?=
 =?us-ascii?Q?9vJFHo2ab0pNIIBxduNY6PUizHdqhZYktdiwqx7ObplvQVRCjaqInQ6OXKKN?=
 =?us-ascii?Q?Z1YSVLk+4aZefiwcj+3EFUHYmNSWvJIrLAiAdymneRAWg0GkvGIYiPg9iRsm?=
 =?us-ascii?Q?HIbm15bvc6CdrHvfx57qjlYlj8gseGvwwss2iJS+r2Dk7GjLQx3uf6Hkge6l?=
 =?us-ascii?Q?k0DvQajs+A2RQb5cz26N2ARjKxSAp1hcuAO7hnx7XHxl7/DZsaSjXszR91fW?=
 =?us-ascii?Q?BavRx3yR/bJvrwr5oUYYb17bhkvqWHGmuhnKKUi1wjnzVMR4ljKLPyTt+6bm?=
 =?us-ascii?Q?zURkPoouCQ4ZgDPTqqMU38TEXe1pI4QcamZzJPDtDw+4918GPlRcJ4SIzgym?=
 =?us-ascii?Q?hpljbNg3SfRJ6XuE+EcIdbSz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a59c20-8036-4b93-4c88-08d924d890c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 08:38:00.7452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C0znJX1JSXhvxOTN07h5xnAf1lE08d0bTCUReUuyNDTBsNt4YYcpPXGkjkiqK4skVvzDMSLMjkgeYwJ29eeWfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1837
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, May 29, 2021 3:59 AM
>=20
> On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> >
> > 5. Use Cases and Flows
> >
> > Here assume VFIO will support a new model where every bound device
> > is explicitly listed under /dev/vfio thus a device fd can be acquired w=
/o
> > going through legacy container/group interface. For illustration purpos=
e
> > those devices are just called dev[1...N]:
> >
> > 	device_fd[1...N] =3D open("/dev/vfio/devices/dev[1...N]", mode);
> >
> > As explained earlier, one IOASID fd is sufficient for all intended use =
cases:
> >
> > 	ioasid_fd =3D open("/dev/ioasid", mode);
> >
> > For simplicity below examples are all made for the virtualization story=
.
> > They are representative and could be easily adapted to a non-virtualiza=
tion
> > scenario.
>=20
> For others, I don't think this is *strictly* necessary, we can
> probably still get to the device_fd using the group_fd and fit in
> /dev/ioasid. It does make the rest of this more readable though.

Jason, want to confirm here. Per earlier discussion we remain an
impression that you want VFIO to be a pure device driver thus
container/group are used only for legacy application. From this
comment are you suggesting that VFIO can still keep container/
group concepts and user just deprecates the use of vfio iommu
uAPI (e.g. VFIO_SET_IOMMU) by using /dev/ioasid (which has
a simple policy that an IOASID will reject cmd if partially-attached=20
group exists)?

>=20
>=20
> > Three types of IOASIDs are considered:
> >
> > 	gpa_ioasid[1...N]: 	for GPA address space
> > 	giova_ioasid[1...N]:	for guest IOVA address space
> > 	gva_ioasid[1...N]:	for guest CPU VA address space
> >
> > At least one gpa_ioasid must always be created per guest, while the oth=
er
> > two are relevant as far as vIOMMU is concerned.
> >
> > Examples here apply to both pdev and mdev, if not explicitly marked out
> > (e.g. in section 5.5). VFIO device driver in the kernel will figure out=
 the
> > associated routing information in the attaching operation.
> >
> > For illustration simplicity, IOASID_CHECK_EXTENSION and IOASID_GET_
> > INFO are skipped in these examples.
> >
> > 5.1. A simple example
> > ++++++++++++++++++
> >
> > Dev1 is assigned to the guest. One gpa_ioasid is created. The GPA addre=
ss
> > space is managed through DMA mapping protocol:
> >
> > 	/* Bind device to IOASID fd */
> > 	device_fd =3D open("/dev/vfio/devices/dev1", mode);
> > 	ioasid_fd =3D open("/dev/ioasid", mode);
> > 	ioctl(device_fd, VFIO_BIND_IOASID_FD, ioasid_fd);
> >
> > 	/* Attach device to IOASID */
> > 	gpa_ioasid =3D ioctl(ioasid_fd, IOASID_ALLOC);
> > 	at_data =3D { .ioasid =3D gpa_ioasid};
> > 	ioctl(device_fd, VFIO_ATTACH_IOASID, &at_data);
> >
> > 	/* Setup GPA mapping */
> > 	dma_map =3D {
> > 		.ioasid	=3D gpa_ioasid;
> > 		.iova	=3D 0;		// GPA
> > 		.vaddr	=3D 0x40000000;	// HVA
> > 		.size	=3D 1GB;
> > 	};
> > 	ioctl(ioasid_fd, IOASID_DMA_MAP, &dma_map);
> >
> > If the guest is assigned with more than dev1, user follows above sequen=
ce
> > to attach other devices to the same gpa_ioasid i.e. sharing the GPA
> > address space cross all assigned devices.
>=20
> eg
>=20
>  	device2_fd =3D open("/dev/vfio/devices/dev1", mode);
>  	ioctl(device2_fd, VFIO_BIND_IOASID_FD, ioasid_fd);
>  	ioctl(device2_fd, VFIO_ATTACH_IOASID, &at_data);
>=20
> Right?

Exactly, except a small typo ('dev1' -> 'dev2'). :)

>=20
> >
> > 5.2. Multiple IOASIDs (no nesting)
> > ++++++++++++++++++++++++++++
> >
> > Dev1 and dev2 are assigned to the guest. vIOMMU is enabled. Initially
> > both devices are attached to gpa_ioasid. After boot the guest creates
> > an GIOVA address space (giova_ioasid) for dev2, leaving dev1 in pass
> > through mode (gpa_ioasid).
> >
> > Suppose IOASID nesting is not supported in this case. Qemu need to
> > generate shadow mappings in userspace for giova_ioasid (like how
> > VFIO works today).
> >
> > To avoid duplicated locked page accounting, it's recommended to pre-
> > register the virtual address range that will be used for DMA:
> >
> > 	device_fd1 =3D open("/dev/vfio/devices/dev1", mode);
> > 	device_fd2 =3D open("/dev/vfio/devices/dev2", mode);
> > 	ioasid_fd =3D open("/dev/ioasid", mode);
> > 	ioctl(device_fd1, VFIO_BIND_IOASID_FD, ioasid_fd);
> > 	ioctl(device_fd2, VFIO_BIND_IOASID_FD, ioasid_fd);
> >
> > 	/* pre-register the virtual address range for accounting */
> > 	mem_info =3D { .vaddr =3D 0x40000000; .size =3D 1GB };
> > 	ioctl(ioasid_fd, IOASID_REGISTER_MEMORY, &mem_info);
> >
> > 	/* Attach dev1 and dev2 to gpa_ioasid */
> > 	gpa_ioasid =3D ioctl(ioasid_fd, IOASID_ALLOC);
> > 	at_data =3D { .ioasid =3D gpa_ioasid};
> > 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
> > 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
> >
> > 	/* Setup GPA mapping */
> > 	dma_map =3D {
> > 		.ioasid	=3D gpa_ioasid;
> > 		.iova	=3D 0; 		// GPA
> > 		.vaddr	=3D 0x40000000;	// HVA
> > 		.size	=3D 1GB;
> > 	};
> > 	ioctl(ioasid_fd, IOASID_DMA_MAP, &dma_map);
> >
> > 	/* After boot, guest enables an GIOVA space for dev2 */
> > 	giova_ioasid =3D ioctl(ioasid_fd, IOASID_ALLOC);
> >
> > 	/* First detach dev2 from previous address space */
> > 	at_data =3D { .ioasid =3D gpa_ioasid};
> > 	ioctl(device_fd2, VFIO_DETACH_IOASID, &at_data);
> >
> > 	/* Then attach dev2 to the new address space */
> > 	at_data =3D { .ioasid =3D giova_ioasid};
> > 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
> >
> > 	/* Setup a shadow DMA mapping according to vIOMMU
> > 	  * GIOVA (0x2000) -> GPA (0x1000) -> HVA (0x40001000)
> > 	  */
>=20
> Here "shadow DMA" means relay the guest's vIOMMU page tables to the HW
> IOMMU?

'shadow' means the merged mapping: GIOVA(0x2000) -> HVA (0x40001000)

>=20
> > 	dma_map =3D {
> > 		.ioasid	=3D giova_ioasid;
> > 		.iova	=3D 0x2000; 	// GIOVA
> > 		.vaddr	=3D 0x40001000;	// HVA
>=20
> eg HVA came from reading the guest's page tables and finding it wanted
> GPA 0x1000 mapped to IOVA 0x2000?

yes

>=20
>=20
> > 5.3. IOASID nesting (software)
> > +++++++++++++++++++++++++
> >
> > Same usage scenario as 5.2, with software-based IOASID nesting
> > available. In this mode it is the kernel instead of user to create the
> > shadow mapping.
> >
> > The flow before guest boots is same as 5.2, except one point. Because
> > giova_ioasid is nested on gpa_ioasid, locked accounting is only
> > conducted for gpa_ioasid. So it's not necessary to pre-register virtual
> > memory.
> >
> > To save space we only list the steps after boots (i.e. both dev1/dev2
> > have been attached to gpa_ioasid before guest boots):
> >
> > 	/* After boots */
> > 	/* Make GIOVA space nested on GPA space */
> > 	giova_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> > 				gpa_ioasid);
> >
> > 	/* Attach dev2 to the new address space (child)
> > 	  * Note dev2 is still attached to gpa_ioasid (parent)
> > 	  */
> > 	at_data =3D { .ioasid =3D giova_ioasid};
> > 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
> >
> > 	/* Setup a GIOVA->GPA mapping for giova_ioasid, which will be
> > 	  * merged by the kernel with GPA->HVA mapping of gpa_ioasid
> > 	  * to form a shadow mapping.
> > 	  */
> > 	dma_map =3D {
> > 		.ioasid	=3D giova_ioasid;
> > 		.iova	=3D 0x2000;	// GIOVA
> > 		.vaddr	=3D 0x1000;	// GPA
> > 		.size	=3D 4KB;
> > 	};
> > 	ioctl(ioasid_fd, IOASID_DMA_MAP, &dma_map);
>=20
> And in this version the kernel reaches into the parent IOASID's page
> tables to translate 0x1000 to 0x40001000 to physical page? So we
> basically remove the qemu process address space entirely from this
> translation. It does seem convenient

yes.

>=20
> > 5.4. IOASID nesting (hardware)
> > +++++++++++++++++++++++++
> >
> > Same usage scenario as 5.2, with hardware-based IOASID nesting
> > available. In this mode the pgtable binding protocol is used to
> > bind the guest IOVA page table with the IOMMU:
> >
> > 	/* After boots */
> > 	/* Make GIOVA space nested on GPA space */
> > 	giova_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> > 				gpa_ioasid);
> >
> > 	/* Attach dev2 to the new address space (child)
> > 	  * Note dev2 is still attached to gpa_ioasid (parent)
> > 	  */
> > 	at_data =3D { .ioasid =3D giova_ioasid};
> > 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
> >
> > 	/* Bind guest I/O page table  */
> > 	bind_data =3D {
> > 		.ioasid	=3D giova_ioasid;
> > 		.addr	=3D giova_pgtable;
> > 		// and format information
> > 	};
> > 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);
>=20
> I really think you need to use consistent language. Things that
> allocate a new IOASID should be calle IOASID_ALLOC_IOASID. If multiple
> IOCTLs are needed then it is IOASID_ALLOC_IOASID_PGTABLE, etc.
> alloc/create/bind is too confusing.
>=20
> > 5.5. Guest SVA (vSVA)
> > ++++++++++++++++++
> >
> > After boots the guest further create a GVA address spaces (gpasid1) on
> > dev1. Dev2 is not affected (still attached to giova_ioasid).
> >
> > As explained in section 4, user should avoid expose ENQCMD on both
> > pdev and mdev.
> >
> > The sequence applies to all device types (being pdev or mdev), except
> > one additional step to call KVM for ENQCMD-capable mdev:
> >
> > 	/* After boots */
> > 	/* Make GVA space nested on GPA space */
> > 	gva_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> > 				gpa_ioasid);
> >
> > 	/* Attach dev1 to the new address space and specify vPASID */
> > 	at_data =3D {
> > 		.ioasid		=3D gva_ioasid;
> > 		.flag 		=3D IOASID_ATTACH_USER_PASID;
> > 		.user_pasid	=3D gpasid1;
> > 	};
> > 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
>=20
> Still a little unsure why the vPASID is here not on the gva_ioasid. Is
> there any scenario where we want different vpasid's for the same
> IOASID? I guess it is OK like this. Hum.

Yes, it's completely sane that the guest links a I/O page table to=20
different vpasids on dev1 and dev2. The IOMMU doesn't mandate
that when multiple devices share an I/O page table they must use
the same PASID#.=20

>=20
> > 	/* if dev1 is ENQCMD-capable mdev, update CPU PASID
> > 	  * translation structure through KVM
> > 	  */
> > 	pa_data =3D {
> > 		.ioasid_fd	=3D ioasid_fd;
> > 		.ioasid		=3D gva_ioasid;
> > 		.guest_pasid	=3D gpasid1;
> > 	};
> > 	ioctl(kvm_fd, KVM_MAP_PASID, &pa_data);
>=20
> Make sense
>=20
> > 	/* Bind guest I/O page table  */
> > 	bind_data =3D {
> > 		.ioasid	=3D gva_ioasid;
> > 		.addr	=3D gva_pgtable1;
> > 		// and format information
> > 	};
> > 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);
>=20
> Again I do wonder if this should just be part of alloc_ioasid. Is
> there any reason to split these things? The only advantage to the
> split is the device is known, but the device shouldn't impact
> anything..

I summarized this as open#4 in another mail for focused discussion.

>=20
> > 5.6. I/O page fault
> > +++++++++++++++
> >
> > (uAPI is TBD. Here is just about the high-level flow from host IOMMU dr=
iver
> > to guest IOMMU driver and backwards).
> >
> > -   Host IOMMU driver receives a page request with raw fault_data {rid,
> >     pasid, addr};
> >
> > -   Host IOMMU driver identifies the faulting I/O page table according =
to
> >     information registered by IOASID fault handler;
> >
> > -   IOASID fault handler is called with raw fault_data (rid, pasid, add=
r),
> which
> >     is saved in ioasid_data->fault_data (used for response);
> >
> > -   IOASID fault handler generates an user fault_data (ioasid, addr), l=
inks it
> >     to the shared ring buffer and triggers eventfd to userspace;
>=20
> Here rid should be translated to a labeled device and return the
> device label from VFIO_BIND_IOASID_FD. Depending on how the device
> bound the label might match to a rid or to a rid,pasid

Yes, I acknowledged this input from you and Jean about page fault and=20
bind_pasid_table. I summarized it as open#3 in another mail.

thus following is skipped...

Thanks
Kevin

>=20
> > -   Upon received event, Qemu needs to find the virtual routing informa=
tion
> >     (v_rid + v_pasid) of the device attached to the faulting ioasid. If=
 there are
> >     multiple, pick a random one. This should be fine since the purpose =
is to
> >     fix the I/O page table on the guest;
>=20
> The device label should fix this
>=20
> > -   Qemu finds the pending fault event, converts virtual completion dat=
a
> >     into (ioasid, response_code), and then calls a /dev/ioasid ioctl to
> >     complete the pending fault;
> >
> > -   /dev/ioasid finds out the pending fault data {rid, pasid, addr} sav=
ed in
> >     ioasid_data->fault_data, and then calls iommu api to complete it wi=
th
> >     {rid, pasid, response_code};
>=20
> So resuming a fault on an ioasid will resume all devices pending on
> the fault?
>=20
> > 5.7. BIND_PASID_TABLE
> > ++++++++++++++++++++
> >
> > PASID table is put in the GPA space on some platform, thus must be
> updated
> > by the guest. It is treated as another user page table to be bound with=
 the
> > IOMMU.
> >
> > As explained earlier, the user still needs to explicitly bind every use=
r I/O
> > page table to the kernel so the same pgtable binding protocol (bind, ca=
che
> > invalidate and fault handling) is unified cross platforms.
> >
> > vIOMMUs may include a caching mode (or paravirtualized way) which,
> once
> > enabled, requires the guest to invalidate PASID cache for any change on=
 the
> > PASID table. This allows Qemu to track the lifespan of guest I/O page t=
ables.
> >
> > In case of missing such capability, Qemu could enable write-protection =
on
> > the guest PASID table to achieve the same effect.
> >
> > 	/* After boots */
> > 	/* Make vPASID space nested on GPA space */
> > 	pasidtbl_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> > 				gpa_ioasid);
> >
> > 	/* Attach dev1 to pasidtbl_ioasid */
> > 	at_data =3D { .ioasid =3D pasidtbl_ioasid};
> > 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
> >
> > 	/* Bind PASID table */
> > 	bind_data =3D {
> > 		.ioasid	=3D pasidtbl_ioasid;
> > 		.addr	=3D gpa_pasid_table;
> > 		// and format information
> > 	};
> > 	ioctl(ioasid_fd, IOASID_BIND_PASID_TABLE, &bind_data);
> >
> > 	/* vIOMMU detects a new GVA I/O space created */
> > 	gva_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> > 				gpa_ioasid);
> >
> > 	/* Attach dev1 to the new address space, with gpasid1 */
> > 	at_data =3D {
> > 		.ioasid		=3D gva_ioasid;
> > 		.flag 		=3D IOASID_ATTACH_USER_PASID;
> > 		.user_pasid	=3D gpasid1;
> > 	};
> > 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
> >
> > 	/* Bind guest I/O page table. Because SET_PASID_TABLE has been
> > 	  * used, the kernel will not update the PASID table. Instead, just
> > 	  * track the bound I/O page table for handling invalidation and
> > 	  * I/O page faults.
> > 	  */
> > 	bind_data =3D {
> > 		.ioasid	=3D gva_ioasid;
> > 		.addr	=3D gva_pgtable1;
> > 		// and format information
> > 	};
> > 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);
>=20
> I still don't quite get the benifit from doing this.
>=20
> The idea to create an all PASID IOASID seems to work better with less
> fuss on HW that is directly parsing the guest's PASID table.
>=20
> Cache invalidate seems easy enough to support
>=20
> Fault handling needs to return the (ioasid, device_label, pasid) when
> working with this kind of ioasid.
>=20
> It is true that it does create an additional flow qemu has to
> implement, but it does directly mirror the HW.
>=20
> Jason
