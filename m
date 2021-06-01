Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CDA396DAF
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 09:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhFAHEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 03:04:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:52952 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232953AbhFAHEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 03:04:31 -0400
IronPort-SDR: 5qMcpsMFa9NP7X3gYMTZefaWgxnoZeMNfAj7G+mhl1pE0U+sIApofe8rwz8+eM7PcVJIsjNXLC
 zHZXgVb01a6w==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="203521748"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="203521748"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 00:02:48 -0700
IronPort-SDR: gmWqsYYm+2phMmp/DdUuKUTrssnfruaoSpHYm+OvhRrV9wv83ik/v/Mf/maKlE74EI95vt/mv1
 KoA1bhLzsprA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="549635096"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga001.fm.intel.com with ESMTP; 01 Jun 2021 00:02:26 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 1 Jun 2021 00:02:02 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 1 Jun 2021 00:02:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 1 Jun 2021 00:02:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 1 Jun 2021 00:02:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSAyTJ0LiREU7VqQANOTgm3vsuxulO+zo6j0ev511JjWGRvqP1H0Knden4gFRMvxHeewJsEOfnviItbNA+/PpzJg/EgBChFV4KODsD5VZ5Pnbv3TU3ofZSsRbsgvu2sqWdxDDDvyfCnUYPWzmcwsHPgRM1gUYW5w6BxTV4qOTHCip2BRwC59LOPtlvhRrpjy/TjckCC7Av+2IplTIHmnR5w0XT0Cik/4mFOO2BuUEeLe0Bwwz8sotQ8uSFpVK+5LhpSo9+g87BKd//PA7saaaD7A5Et1NBYyqAuwrcGsRy4iLjC4e3i3k86mS72bjNNZmee5KiKxT4A2OT5SE7wj5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cObJlZJnjcb8iaSCTW7TpsLspRnKGTkgSdsbad4VEc=;
 b=WMk0axlgKnBla6ccQYjTMO98tKDHYe+UjbwYmbu8hoEbGzB1HNPGfvY4RQoC2hXm5v4fStI5J1xqvIvLfkdCqRvMvT+5zgumhHU1SSdg3V65vqEtot9sWQQt88nkrCRxdeoj6y2aNCiAedKOmw0+2MnIBMYeXogG6ry5MBDlbqyGacyeZ43bAI8hB7sry+87m8Czyc/8OUf4e8ZyHU9n8p/iDYztAQ86UNmol5KJshtvTk6bBKlTmKtv3t4UBjab0fYztflVSUX8ZaEkGx1CfvJdqgN35Ad7rRMmwI+9KV0JCc8AQ6HArAuArwYaMdTh4o9FsUHv/5kZtd576oAfhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cObJlZJnjcb8iaSCTW7TpsLspRnKGTkgSdsbad4VEc=;
 b=GL79IFCCEHLFqEuzteV3OrXzZcunEbUhz5CFf8a28iV1xXM8TpFOEQXttGDjBvhJcHf4B1IVWMdtakHaV1VCi2oSUY2OpGCMBQl2WTX88WbP1KIeBFlcKj6a1RF9hKPrGk70oaQkqT/tLMAm4528cRo+a8x4kivXJlFWTjbyE/U=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1696.namprd11.prod.outlook.com (2603:10b6:300:23::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 07:01:58 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 07:01:58 +0000
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
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBL2ymAAKTbxpA=
Date:   Tue, 1 Jun 2021 07:01:57 +0000
Message-ID: <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528200311.GP1002214@nvidia.com>
In-Reply-To: <20210528200311.GP1002214@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 2e0dee32-9d85-4df6-daa8-08d924cb25c5
x-ms-traffictypediagnostic: MWHPR11MB1696:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1696558CD0016D7144461B428C3E9@MWHPR11MB1696.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Upp/+Hh0KLDnr+n0pj1o/NjAUJjoC9YR9zQ/awk23mnYZS7fIHFceoORQj5R4+tZ7v/MhJeCWUYfrYdg2AgtjUhr+1RrJhgT3zXoRVvFC6T8I3otMZMejYsGv8qjJsO7IY7h/6ncpZg1XAg3p2g4c6kieBC+eSB4LmPUk7FyAkFbWrOP+E1C/bnW/Ik0wb3v4XwowuSjFZaxJE4WxlGa2J82sTM4Vxjc2xeXvy31reNGm8Pxh2gLfIybYno0R+uwvCK4oACjJEILp47yLB2DkcDQyCgvfbwBfKrQl+zi2L8hogPCPHmwBHi9W7XFPi8DFeeQ2w6TlWptiYdp+0gqaCIdacBnqt4TknV/qZHea2cuVuIaDmlwsX97dHI5uYrBc5aQO0r2R28pXeqIpDIxQFiLXbbuiAuny3hGuhwfDQ5Z/L8wsb5aZlr5nRaU8waDSpoA/rCTITyDGxodHDm4Ho4Y92ZpCzFWwGGHtBrNVkU7bU3kE+Z2qgh6z5qEaJexsGy4kONIBQKGJo2PeswWu2CFcLYTbQ3wZmxIunfYqGXnAyLhjGvWGexdbYooj/CFVKHvZUy3AroVHTeSdqNjfKZ2mjYk6p2liv593Pci4c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(376002)(39860400002)(396003)(26005)(76116006)(64756008)(86362001)(52536014)(9686003)(83380400001)(8676002)(33656002)(54906003)(5660300002)(122000001)(6916009)(316002)(71200400001)(2906002)(478600001)(4326008)(55016002)(66556008)(7696005)(66946007)(8936002)(66476007)(38100700002)(186003)(66446008)(6506007)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ef+aLEt5Dhjm0htq736QZaR9pYDvzbVRIAzgB+5wjbdMSYAVxDBDsW98UrKm?=
 =?us-ascii?Q?owv9ovtw0hbncNQSB1ueo+pS+CbaOZ2+EdXKsiqmeAqmZ0siXWsV0T9u/BeL?=
 =?us-ascii?Q?qDLuzNkyISkv+7+jxH6hKhlotnKNAoMO2p8WmSsyk/72CVZHYY+y2Dr2UykE?=
 =?us-ascii?Q?xohaoTNAerEBHxuDb3UknqV+v/qPslLH9TI3xWQZ7Zhb+S7CFo0h7Kcco9dB?=
 =?us-ascii?Q?PFPbyn63IUjUcjPY5PpBWsfciQFa6sqGqjU20zXTnduzAj0Vnh5aBYQf8SeK?=
 =?us-ascii?Q?RVlxA1HqKEDMk2EglfoCZkMNvJTxu/vz4A2xCD1Vr1Y5Lqw0wtKwbXtIsCQw?=
 =?us-ascii?Q?oAVNkpOPqw+/uBnfE8Y4/kOejNn7Va5M7ihrfSHvxtYOp8+NWiy/ZeffrfHy?=
 =?us-ascii?Q?uMmGZ19PrkNSe2PTTYS/g6xXJ8k4EwT75TbfjYUvix4hzw+Wf9A0ta5m27zu?=
 =?us-ascii?Q?ge29CW7RF/+RXFMxh8x5ojZQ1kgWtURR0toOQ2Yz/WgDEiGdxPbPHHF/KqB4?=
 =?us-ascii?Q?sUvNglbeW72J6ReshmAzru8kw9Nn3luLchPD5QQAfAFgSpyDE5j5IUZiImL8?=
 =?us-ascii?Q?xJhFAg5dQuFaOgMzbMcjx18lUieDuk/cwdW+WDpN5yAHf5mBEvPc5Hhbq1Q2?=
 =?us-ascii?Q?UUN08iejqsVtCNVQqcxx1JLjQw71MqXJb/dPXleOuIcLEb5xG0QQHNdLkI5h?=
 =?us-ascii?Q?FY1ctjhD0Nj8EOFS+YW0TSVzBYL7D44VJ6wzxMoQM89SWrBLOIZAxciyuDhG?=
 =?us-ascii?Q?yFsQ7fRxQiwBiMSFoB+S8Gln2voelTYGOw63ltJcPz2K5YfBvtyDCSq+fA89?=
 =?us-ascii?Q?T+abX+q2KgWEnReUHtDdNQLC7el5v3HxcCSu65v2zj1VcZy4riMxX2kKffJU?=
 =?us-ascii?Q?ku2J2NVGhzfmvWdnYsEmUocdSg0ZfMxcco3FKNYTZXLVH7bLfN/bXr5zuyfr?=
 =?us-ascii?Q?wewb9hibayGb7SCZDFjdy9MBJm1JiqJYEbZeo+auG22aAAcim8sEpGJ7hGC2?=
 =?us-ascii?Q?f1Owh4Xw1fSmAdh7H+SGfR5yL5ALQzTYgOdktqxYfywa+4cQT8gqC9U670ju?=
 =?us-ascii?Q?bYoJ+X7hZuuXH3E57ypt7zpAySpORP4ihUwGIsuQZbPGkSoGpxsJatlLio/U?=
 =?us-ascii?Q?wd1HTE1Rvx1832MXMQfBoPuzILUdtJD0KPUnJDaHlpX8R8h6FrtIRlkEpli+?=
 =?us-ascii?Q?STT/c0lYCjka4lE4HfzVwmnJ0b6Cvc6zNC1atjrssC7qYPrfuTHCqPxJX+7k?=
 =?us-ascii?Q?2c6UswQS2VbYJ1wPnX/HbUcCL6oiNCeTkcv66tQfPOXxci615CNIuI8IHuk0?=
 =?us-ascii?Q?gmghXghhdbQNDi0fvkQc5caM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e0dee32-9d85-4df6-daa8-08d924cb25c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 07:01:57.8151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UUDtFZy3lwItgWYc5ejTMg45VYD+Wq/FkQzy2siLcDyeUFDPROJnjWMrSBK3EfKdMV/ANk4ObdiWTuq/vfcOoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1696
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, May 29, 2021 4:03 AM
>=20
> On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> > /dev/ioasid provides an unified interface for managing I/O page tables =
for
> > devices assigned to userspace. Device passthrough frameworks (VFIO,
> vDPA,
> > etc.) are expected to use this interface instead of creating their own =
logic to
> > isolate untrusted device DMAs initiated by userspace.
>=20
> It is very long, but I think this has turned out quite well. It
> certainly matches the basic sketch I had in my head when we were
> talking about how to create vDPA devices a few years ago.
>=20
> When you get down to the operations they all seem pretty common sense
> and straightfoward. Create an IOASID. Connect to a device. Fill the
> IOASID with pages somehow. Worry about PASID labeling.
>=20
> It really is critical to get all the vendor IOMMU people to go over it
> and see how their HW features map into this.
>=20

Agree. btw I feel it might be good to have several design opens=20
centrally discussed after going through all the comments. Otherwise=20
they may be buried in different sub-threads and potentially with=20
insufficient care (especially for people who haven't completed the
reading).

I summarized five opens here, about:

1)  Finalizing the name to replace /dev/ioasid;
2)  Whether one device is allowed to bind to multiple IOASID fd's;
3)  Carry device information in invalidation/fault reporting uAPI;
4)  What should/could be specified when allocating an IOASID;
5)  The protocol between vfio group and kvm;

For 1), two alternative names are mentioned: /dev/iommu and=20
/dev/ioas. I don't have a strong preference and would like to hear=20
votes from all stakeholders. /dev/iommu is slightly better imho for=20
two reasons. First, per AMD's presentation in last KVM forum they=20
implement vIOMMU in hardware thus need to support user-managed=20
domains. An iommu uAPI notation might make more sense moving=20
forward. Second, it makes later uAPI naming easier as 'IOASID' can=20
be always put as an object, e.g. IOMMU_ALLOC_IOASID instead of=20
IOASID_ALLOC_IOASID. :)

Another naming open is about IOASID (the software handle for ioas)=20
and the associated hardware ID (PASID or substream ID). Jason thought=20
PASID is defined more from SVA angle while ARM's convention sounds=20
clearer from device p.o.v. Following this direction then SID/SSID will be=20
used to replace RID/PASID in this RFC (and possibly also implying that=20
the kernel IOASID allocator should also be renamed to SSID allocator).=20
I don't have better alternative. If no one objects, I'll change to this new
naming in next version.=20

For 2), Jason prefers to not blocking it if no kernel design reason. If=20
one device is allowed to bind multiple IOASID fd's, the main problem
is about cross-fd IOASID nesting, e.g. having gpa_ioasid created in fd1=20
and giova_ioasid created in fd2 and then nesting them together (and
whether any cross-fd notification required when handling invalidation
etc.). We thought that this just adds some complexity while not sure=20
about the value of supporting it (when one fd can already afford all=20
discussed usages). Therefore this RFC proposes a device only bound=20
to at most one IOASID fd. Does this rationale make sense?

To the other end there was also thought whether we should make
a single I/O address space per IOASID fd. This was discussed in previous
thread that #fd's are insufficient to afford theoretical 1M's address
spaces per device. But let's have another revisit and draw a clear
conclusion whether this option is viable.

For 3), Jason/Jean both think it's cleaner to carry device info in the=20
uAPI. Actually this was one option we developed in earlier internal
versions of this RFC. Later on we changed it to the current way based
on misinterpretation of previous discussion. Thinking more we will
adopt this suggestion in next version, due to both efficiency (I/O page
fault is already a long path ) and security reason (some faults are=20
unrecoverable thus the faulting device must be identified/isolated).

This implies that VFIO_BOUND_IOASID will be extended to allow user
specify a device label. This label will be recorded in /dev/iommu to
serve per-device invalidation request from and report per-device=20
fault data to the user. In addition, vPASID (if provided by user) will
be also recorded in /dev/iommu so vPASID<->pPASID conversion=20
is conducted properly. e.g. invalidation request from user carries
a vPASID which must be converted into pPASID before calling iommu
driver. Vice versa for raw fault data which carries pPASID while the
user expects a vPASID.

For 4), There are two options for specifying the IOASID attributes:

    In this RFC, an IOASID has no attribute before it's attached to any
    device. After device attach, user queries capability/format info
    about the IOMMU which the device belongs to, and then call
    different ioctl commands to set the attributes for an IOASID (e.g.
    map/unmap, bind/unbind user pgtable, nesting, etc.). This follows
    how the underlying iommu-layer API is designed: a domain reports
    capability/format info and serves iommu ops only after it's attached=20
    to a device.

    Jason suggests having user to specify all attributes about how an
    IOASID is expected to work when creating this IOASID. This requires
    /dev/iommu to provide capability/format info once a device is bound
    to ioasid fd (before creating any IOASID). In concept this should work,=
=20
    since given a device we can always find its IOMMU. The only gap is
    aforementioned: current iommu API is designed per domain instead=20
    of per-device.=20

Seems to close this design open we have to touch the kAPI design. and=20
Joerg's input is highly appreciated here.

For 5), I'd expect Alex to chime in. Per my understanding looks the
original purpose of this protocol is not about I/O address space. It's
for KVM to know whether any device is assigned to this VM and then
do something special (e.g. posted interrupt, EPT cache attribute, etc.).
Because KVM deduces some policy based on the fact of assigned device,=20
it needs to hold a reference to related vfio group. this part is irrelevant
to this RFC.=20

But ARM's VMID usage is related to I/O address space thus needs some
consideration. Another strange thing is about PPC. Looks it also leverages
this protocol to do iommu group attach: kvm_spapr_tce_attach_iommu_
group. I don't know why it's done through KVM instead of VFIO uAPI in
the first place.

Thanks
Kevin
