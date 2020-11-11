Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26C92AE99D
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 08:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgKKHTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 02:19:55 -0500
Received: from mga06.intel.com ([134.134.136.31]:33600 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgKKHOd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 02:14:33 -0500
IronPort-SDR: RZbYyh8zc6OUBrvEzmBI1zaBjKjx9DgD3ieQo6bLhoZ4ByhwTdditjzzAFMAWFMhbjgJV8v54D
 RPoANNEy0wUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="231731018"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="231731018"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 23:14:14 -0800
IronPort-SDR: zxqHeAxxWTmBvtMjLUwAla0/nY4NlPKU4ye/o8qyGV2YROWx7dxC7K5sdCA95FjRKk9dNx8qGx
 vCWVsuHrUHCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="541672621"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 10 Nov 2020 23:14:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Nov 2020 23:14:14 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Nov 2020 23:14:14 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 10 Nov 2020 23:14:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJVHesPnhqha8cf6HTkT1tlxc5WN2lwnUB+n2o3wmlROZdhoE0A8FzcIk2PAtbNCJS1jlGq0i+6Kt5kb+rMWsnJqh9Ev5F2MXZZQCyssrL8myhFAoShr4IL1eD07e2KnrZ9w8Y2u5nflshZy09avDCd0MlyL2i4Bdt9TR7kQcqKNVGP7chYlZuvOK5B0LUDikXjwX9BXTy9HkzF24Pi8EWlHzl2aQYTfvO7SW6AN4Hk1nN4tKU+hhPk5qbEEZoPJz6Y1gstF5Qz37dDpJMlDolpfuhzNY4wDazaYdiVuTxffYgeOyDgoomySaKSNJC9kZbgREkTGFQ+lYS6qj3ljgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHHO/3yZRflJ7IUkcu/5rURxOi/MsnUX70m/etAaeks=;
 b=eGODvlbT+lDG5Pg9l3MVzSfZ/nEDtoRHYEmMvfqY7e3RCzQTGSLDuHYiWobePW58R5XM3j5DKKRGtfukrp3A1ausY+e0wW33TJJavQG09EzGeFS4BozXIDiLYiQfNSGlGAofsA9W1m4lzHYmHDYOwXgd6n2E1/5uTKrjuFgszIxQ5rB9wj7HznifEo3rkpY6/vYX5V+nXvQXjz7L5l84JrTpOO4tQZzsBXQbolGnLNAUzDwIt726TKYaTYzu/Tu8Z6AO7VUhDX95F+WDg8X1gdHcr5ndq6q+iBjfWWFJUgjfcSqmII5cww9yDwixSI0h2l3AgzbzX6jS88bZMbJ+Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHHO/3yZRflJ7IUkcu/5rURxOi/MsnUX70m/etAaeks=;
 b=S9Q0OI6sZvflXjcxfkwjQyHs7acKeEkua97hSIZB8HTCA/DfftnQGy7RSOLUnzDJ4R/Ln2Sfea1vVD3s8+vPTE067mK8pevsLrqN3DJQR1GSdfSKcXomdKjG1RQdDfts9hZztwCW7M7o3xXcP4FKq4xpOgyYDjs6y5z2c3jnfHc=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by CO1PR11MB5204.namprd11.prod.outlook.com (2603:10b6:303:95::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 07:14:06 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e%10]) with mapi id 15.20.3541.025; Wed, 11 Nov
 2020 07:14:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Bjorn Helgaas" <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Topic: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcIAAp6mAgAD1diCAAJvfgIAADi9AgAAGfICAArW6cIAAY8KAgAA79QCAABGDgIAAY1IAgAAHBYCAAsnwAIAAVwYAgAC+sACAAGcnAIAAVyaAgABtcgCAAFeIgIAAPx2AgAEDTgA=
Date:   Wed, 11 Nov 2020 07:14:05 +0000
Message-ID: <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de> <20201110141323.GB22336@otc-nc-03>
In-Reply-To: <20201110141323.GB22336@otc-nc-03>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac9576f3-b74d-472a-7553-08d886116053
x-ms-traffictypediagnostic: CO1PR11MB5204:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5204F99D82961EAEBF7AF1CF8CE80@CO1PR11MB5204.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BhDb+ptacRpm+jZBQbTSoFKbuzkgCWZ1HLMPA6n79oCYIrQdqXPL7aAkLZbaRnO+GoZpfQPpe7DtX5duGGqJQfgbIc339ry07HTJ1mbP66sTGpFsWmfmib+/TyHm10kk33p91ai2kvSBNRoj/D46IE92gievX/o8tLB6naf+azmflc7691itv92XT1kg8b+Kwia68huTpuKaIq2RF1EwF82/oiswEH9x1eViPqbfzha7EW1sYQu4wXAV9mneaX/AgUUSVy7qTnG0GmCxBUeqO9VN0XzhDVhqpwq/SYTdYi4iljJM59eCpq+FOHoOqszdNg5tw039WqKIkuJMewSp4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(186003)(83380400001)(55016002)(7696005)(76116006)(54906003)(478600001)(110136005)(9686003)(2906002)(7416002)(26005)(66446008)(33656002)(66476007)(66946007)(316002)(66556008)(5660300002)(8676002)(64756008)(71200400001)(6506007)(8936002)(52536014)(86362001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: EGIzG+VcZzamQcCdtlWJRilOsEcieXLdW37zQzLidGZY/VxHG4Kaoq+B1sIxE+0dJn6c97DT0MKmk0r9dUmfrMupeWGeS07Vrp+tcImQh17XLqPntazT2AQUz0VKJY5sbdD+V2IKw1an3pGJ2gbwsl6Khq0O7X/A7OOawOg79zzIuRiG1UxTUrmnIzzAVwFEJMaCR979Crz/OURWcmpVu2lTWHhCMugkT5ia25XsR3k1LTJ+JSdmpF89THbqZhHSzNVvLuSrW/0cZL0eV/1Sr0mREXO693LCY/Dne1s/3PYt63OhhqTSOnG4nLp/uJA2HAaokFuvIVAZMjNE96bqBEYkub5WpW/e7bhc+B5D6AdPHaCgxDYz0AFwxQdtCyBzBttQm4lczF/jneZevDc0MneHUd0O1byDDlDROLXzR8Ibtoo8+8mhWZeJwtCxP2sq7z+E8ffDe4Sy+2RQqNoEZbzpsqBoIkGKecMWTYk6TYcTT5YBIBdFrjgH1Y4Bie2MnXpmctZ10a/YdZJ5PPImrO1MPuskgzk1xFc/ocK6jhm7x67wwRtAwifZS8jvBg9uOCT9CFNp1nHBOaUVQVT9RJD3sCuzgOZDAnuvkTvN91GCgDkbZDmzirmnbWxt8dPMK+p7vZ1NRFO+AC7GZcBmsA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9576f3-b74d-472a-7553-08d886116053
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 07:14:05.3656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DnML76P3EQNcl7k6HR6zMJSkj0DYp3npSwQh8iBV18pNzAV8n2CCdnb0oPGl2x3jZzA/L8/AO1W0snmXhLAnIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5204
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Raj, Ashok <ashok.raj@intel.com>
> Sent: Tuesday, November 10, 2020 10:13 PM
>=20
> Thomas,
>=20
> With all these interrupt message storms ;-), I'm missing how to move
> towards
> an end goal.
>=20
> On Tue, Nov 10, 2020 at 11:27:29AM +0100, Thomas Gleixner wrote:
> > Ashok,
> >
> > On Mon, Nov 09 2020 at 21:14, Ashok Raj wrote:
> > > On Mon, Nov 09, 2020 at 11:42:29PM +0100, Thomas Gleixner wrote:
> > >> On Mon, Nov 09 2020 at 13:30, Jason Gunthorpe wrote:
> > > Approach to IMS is more of a phased approach.
> > >
> > > #1 Allow physical device to scale beyond limits of PCIe MSIx
> > >    Follows current methodology for guest interrupt programming and
> > >    evolutionary changes rather than drastic.
> >
> > Trapping MSI[X] writes is there because it allows to hand a device to a=
n
> > unmodified guest OS and to handle the case where the MSI[X] entries
> > storage cannot be mapped exclusively to the guest.
> >
> > But aside of this, it's not required if the storage can be mapped
> > exclusively, the guest is hypervisor aware and can get a host composed
> > message via a hypercall. That works for physical functions and SRIOV,
> > but not for SIOV.
>=20
> It would greatly help if you can put down what you see is blocking
> to move forward in the following areas.
>=20

Agree. We really need some guidance on how to move forward. I think all
people in this thread are aligned now that it's not Intel or IDXD specific =
thing,
e.g. need architectural solution, enabling IMS on PF/VF is important, etc. =
But
what we are not sure is whether we need complete all requirements in one
batch, or could evolve step-by-step as long as the growing path is clearly
defined.=20

IMHO finding a way to disable IMS in guest is more important than supportin=
g
IMS on PF/VF, since the latter requires hypercall which is not always avail=
able
in all scenarios. Even if Linux includes hypercall support for all existing=
 archs
and hypervisors, it could run as an unmodified guest on a new hypervisor=20
before this hypervisor gets its enlightenments into the Linux. So it is mor=
e
prominent to find a way to force using MSI/MSI-x inside guest, as it allows
such PFs/VFs still functional though not benefiting all scalability merits =
of IMS.

If such two-step plans can be agreed, then the next open is about how to
disable IMS in guest. We need a sane solution when checking in the initial=
=20
host-only-IMS support. There are several options discussed in this thread:

1. Industry standard (e.g. a vendor-agnostic ACPI flag) followed by all=20
platforms, hypervisors and OSes. It will require collaboration beyond=20
Linux community;

2. IOMMU-vendor specific standards (DMAR, IORT, etc.) to report whether
IMS is allowed, implying that IMS is tied to the IOMMU. This tradeoff is=20
acceptable since IMS alone cannot make SIOV working which relies on the=20
IOMMU anyway. and this might be an easier path to move forward and
even not require to wait for all vendors to extend their tables together.
On physical platform the FW always reports IMS as 'allowed' and there is
time to change it. On virtual platform the hypervisor can choose to hide=20
IMS in three ways:
	a) do not expose IOMMU
	b) expose IOMMU, but using the old format
	c) expose IOMMU, using the new format with IMS reported 'disallowed'

a/b can well support legacy software stack.

However, there is one potential issue with option 1/2. The construction
of the virtual ACPI table is at VM creation time, likely based on whether a=
=20
PV interrupt controller is exposed to this guest. However, in most cases th=
e
hypervisor doesn't know which guest OS is running and whether it will
use the PV controller when the VM is being created. If IMS is marked as
'allowed' in the virtual DMAR table, an unmodified guest might just go to=20
enable it as if it's on the native platform. Maybe what we really required =
is=20
a flag to tell the guest that although IMS is available you cannot use it w=
ith=20
traditional interrupt controllers?

3. Use IOMMU 'caching mode' as the hint of running as guest and disable
IMS by default as long as 'caching mode' is detected. iirc all IOMMU vendor=
s=20
provide such capability for constructing shadow IOMMU page table. Later
when hypercall support is detected for a specific hypervisor/arch, that pat=
h=20
can override the IOMMU hint to enable IMS.

Unlike the first two options, this will be a Linux-specific policy but self
contained. Other guest OSes may not follow this way though.

4. Using CPUID to detect running as guest. But as Thomas pointed out, this
approach is less reliable as not all hypervisors do this way.

Thoughts?

Thanks
Kevin
