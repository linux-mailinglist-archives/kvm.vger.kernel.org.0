Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1DE24029A
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 09:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHJHck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 03:32:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:21036 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgHJHci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 03:32:38 -0400
IronPort-SDR: ttIkmWBoJMb0uydMKHdqXgVFliY+NF5EjqlJ8WzhzAZG2dcZSo3kjfPoT7c5khyy2j4p0Mlqly
 +N7QvhHsK5FQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9708"; a="217831219"
X-IronPort-AV: E=Sophos;i="5.75,456,1589266800"; 
   d="scan'208";a="217831219"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 00:32:34 -0700
IronPort-SDR: +ML65rf9EeAp+R9gDDt1eK15EPy84Sx0DMEhK/7CTxRGf41jfqTcG2qvOgV3oYXBsuQmxFqBCl
 khmFtWV2Oa6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,456,1589266800"; 
   d="scan'208";a="438598955"
Received: from orsmsx606-2.jf.intel.com (HELO ORSMSX606.amr.corp.intel.com) ([10.22.229.86])
  by orsmga004.jf.intel.com with ESMTP; 10 Aug 2020 00:32:33 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Aug 2020 00:32:33 -0700
Received: from orsmsx113.amr.corp.intel.com (10.22.240.9) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 10 Aug 2020 00:32:33 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX113.amr.corp.intel.com (10.22.240.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 10 Aug 2020 00:32:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 10 Aug 2020 00:32:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPiTDh022K3+niu1r6C5nWNTEMElI1EKIS8Xey10pWgWDFKVfnFtlPiETADUgTtYCWSDZJvMWJR3LZHz/B8spNVihW1srmMVnuipts1SSOirYTqF2epoZvN4xMY1r4nZ3BbnrqUbMtW91ri9lq8qSNpZud1P2u+OQ9LCiR17ycXYYdgWLkR17M7uhAdAo/Z3/lnPQUcIZf+VUE6PJj4t4tSTLqkrbetrf9YZOJxASvjC64mXNAwyzBSjr0T8i9jnehxq1rZnB2oI6w+LNsFUaxp8wodoHFbmTrtAp15YqQbEHUyiqBPtwUB3r48C+nRitxCbQQ38gxkWeOKNs+bWoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1YMKJx7vVtGH+Rjq9BaAAAWu83LWv+v7IN1RLc9UWw=;
 b=mVd9J+n9E4/T5Nm6irXqZ8J5oGG8bPvLYrONlOmDYb97ZBmi7l0AbsRF25wJOJaW1C7IqHSpvp9tSGgDaAWiHatz+vYzC0gZHm2727l99jviRz++ZxWn4h+TRHyhslTAoaK6M70tBgx4JaFXEJOv9d6bkwiCidQfFBgoOxUzRMp+6TURIDk4xie30x5CuVPdsyNXSDcsjPUV5zkwHeSL0zD3Pt5oYyFdOf2fLi1XuXAUBjZID4sNQ4yVjjapxzGYg3RObW903pvflW2Mo9aTaZgBj72JOQLUcLLtcDRb6stES/wTVPU0v6/TeLCmX0uMqFRbGK6DingmleKw599TDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1YMKJx7vVtGH+Rjq9BaAAAWu83LWv+v7IN1RLc9UWw=;
 b=YD7ckJEhixgCL44OnmgDcEU8iskmqOlayicNoBOXEXkFbN+19VwcoZgCwywpZGVYCrgUvd/dVZUUENMTR2fAaaiIYP01iMTFhOJuXlM6iGZeh1mMf1f5dH6PNqjB0k4X2xhnOgBwUE1q15kB/MjyNlCp2FJuleRMTqoA/2Pq/Rc=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1918.namprd11.prod.outlook.com (2603:10b6:300:110::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15; Mon, 10 Aug
 2020 07:32:25 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3261.024; Mon, 10 Aug 2020
 07:32:25 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC v2 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Thread-Topic: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Thread-Index: AQHWX3hut2htBlMVB0qfW0Pa+gZbC6kSPbuAgABwW8CAAzMrAIAUgAoAgAJJ4oCABDO9YA==
Date:   Mon, 10 Aug 2020 07:32:24 +0000
Message-ID: <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
In-Reply-To: <20200807121955.GS16789@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.202]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b41d2bc3-517b-4ac0-9dd3-08d83cff86e7
x-ms-traffictypediagnostic: MWHPR11MB1918:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB191830CA624EEAB8AE9538C88C440@MWHPR11MB1918.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J5vhZqrZGvae0eZnF5Rwts1SL7vM77cwU3ApwngWlhBaVRu7yPSySSm1BqOHkQQv72W8n4U+vFNq5n27SCVP/kuosxrbWBy/6n+pE1VTUd+GIvVMmZfsSvKK/6POqBQTACiyiB5uOXVhaHwYk2DPtLWXLZCpMJm+XjZvzB0vrsn841od8VRMaUIbXheuAF96oWwjrleeOgJL02mMmQXC9z0PqbWBB0VLhRFXSPTxTj0GHNEHjRYLNx4HonR0rS2ljXVa93w33ytT0ZSo6ePhbkBlLIVOvnqgM7jQ0IRz/+2NnPVRY8FjAbXtp4bbj8lSCFI23E7wOwuTC0kbmSPTtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(186003)(4326008)(7696005)(5660300002)(66946007)(66476007)(64756008)(66446008)(66556008)(76116006)(86362001)(110136005)(54906003)(316002)(7416002)(83380400001)(33656002)(52536014)(2906002)(6506007)(26005)(71200400001)(8936002)(55016002)(9686003)(478600001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 5hAIPDhtN6BbCXLay8MjWZodero2NCta114TxGMe4/RW1LEgwJdYohjYr1nWNNlwRRBO2iOUqIsAAOWBWRsK8exq0faupIJRPR+UhTAyEjIx0bo/q4NApQJUywzRUC0Kbs6aUVeZZ3AlfH95XbcwUh/9W80d/pFKaUbzLF3Tn2Um7p1Lt5RGleUfhpf1plnPqOK2A7tua1sR71d6n09c8MhS1b6v80NDReXfrcjwFgDXZOv0NTRg0/13kHnvZ75/j6wLf1mWBqxTXNfBOcx6wVP/NOhGBXOnAV16OekQI12EThiy8gyXE0PHqvbGFgqcMUkNnAc7ahSA3VZ583Doqkbm5m+m5MsDuaz4hPJRLsPc3EVghJkJDNqQF7X8aavKEKNpZFMzTaOHO/vkD1184JVp3yQOBz2sN/SvXZd5VNwzoGh2JsQ4wCVjQe/YUJHNL3IlsRKPBRQmVYfLbSaL5ZoqH41SPYfhLMgccd42hymdXw6ePN/3SpWIRlU8uvRSWaaWhpdsYvmrqjqvfIBzw02R/9UDe4VOFd7Ll/sfUyJ2ACuUB6XnmpJf065oaK5fVu+Hqgd2RBZDL88ptkUaoltI5/sV3xiK89m7gYW/5h4lcsz3dnFWxwjXWE8qCMJGF9snOySOCTxNKcNV1wSTCg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b41d2bc3-517b-4ac0-9dd3-08d83cff86e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2020 07:32:24.7029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wu3Dq503EKUMxzWJTYDHLCC34pmR3Qx8BCWKFXv0aXfRJm4CV5aAESiowZhvyKRTZaHVG75VzhHorXv7oh22/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1918
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, August 7, 2020 8:20 PM
>=20
> On Wed, Aug 05, 2020 at 07:22:58PM -0600, Alex Williamson wrote:
>=20
> > If you see this as an abuse of the framework, then let's identify those
> > specific issues and come up with a better approach.  As we've discussed
> > before, things like basic PCI config space emulation are acceptable
> > overhead and low risk (imo) and some degree of register emulation is
> > well within the territory of an mdev driver.
>=20
> What troubles me is that idxd already has a direct userspace interface
> to its HW, and does userspace DMA. The purpose of this mdev is to
> provide a second direct userspace interface that is a little different
> and trivially plugs into the virtualization stack.

No. Userspace DMA and subdevice passthrough (what mdev provides)
are two distinct usages IMO (at least in idxd context). and this might=20
be the main divergence between us, thus let me put more words here.=20
If we could reach consensus in this matter, which direction to go=20
would be clearer.

First, a passthrough interface requires some unique requirements=20
which are not commonly observed in an userspace DMA interface, e.g.:

- Tracking DMA dirty pages for live migration;
- A set of interfaces for using SVA inside guest;
	* PASID allocation/free (on some platforms);
	* bind/unbind guest mm/page table (nested translation);
	* invalidate IOMMU cache/iotlb for guest page table changes;
	* report page request from device to guest;
	* forward page response from guest to device;
- Configuring irqbypass for posted interrupt;
- ...

Second, a passthrough interface requires delegating raw controllability
of subdevice to guest driver, while the same delegation might not be
required for implementing an userspace DMA interface (especially for
modern devices which support SVA). For example, idxd allows following
setting per wq (guest driver may configure them in any combination):
	- put in dedicated or shared mode;
	- enable/disable SVA;
	- Associate guest-provided PASID to MSI/IMS entry;
	- set threshold;
	- allow/deny privileged access;
	- allocate/free interrupt handle (enlightened for guest);
	- collect error status;
	- ...

We plan to support idxd userspace DMA with SVA. The driver just needs=20
to prepare a wq with a predefined configuration (e.g. shared, SVA,=20
etc.), bind the process mm to IOMMU (non-nested) and then map=20
the portal to userspace. The goal that userspace can do DMA to=20
associated wq doesn't change the fact that the wq is still *owned*=20
and *controlled* by kernel driver. However as far as passthrough=20
is concerned, the wq is considered 'owned' by the guest driver thus=20
we need an interface which can support low-level *controllability*=20
from guest driver. It is sort of a mess in uAPI when mixing the
two together.

Based on above two reasons, we see distinct requirements between=20
userspace DMA and passthrough interfaces, at least in idxd context=20
(though other devices may have less distinction in-between). Therefore,
we didn't see the value/necessity of reinventing the wheel that mdev=20
already handles well to evolve an simple application-oriented usespace=20
DMA interface to a complex guest-driver-oriented passthrough interface.=20
The complexity of doing so would incur far more kernel-side changes=20
than the portion of emulation code that you've been concerned about...
=20
>=20
> I don't think VFIO should be the only entry point to
> virtualization. If we say the universe of devices doing user space DMA
> must also implement a VFIO mdev to plug into virtualization then it
> will be alot of mdevs.

Certainly VFIO will not be the only entry point. and This has to be a=20
case-by-case decision.  If an userspace DMA interface can be easily=20
adapted to be a passthrough one, it might be the choice. But for idxd,=20
we see mdev a much better fit here, given the big difference between=20
what userspace DMA requires and what guest driver requires in this hw.

>=20
> I would prefer to see that the existing userspace interface have the
> extra needed bits for virtualization (eg by having appropriate
> internal kernel APIs to make this easy) and all the emulation to build
> the synthetic PCI device be done in userspace.

In the end what decides the direction is the amount of changes that
we have to put in kernel, not whether we call it 'emulation'. For idxd,
adding special passthrough requirements (guest SVA, dirty tracking,
etc.) and raw controllability to the simple userspace DMA interface=20
is for sure making kernel more complex than reusing the mdev
framework (plus some degree of emulation mockup behind). Not to
mention the merit of uAPI compatibility with mdev...

Thanks
Kevin
