Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E27D2B145F
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 03:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKMCmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 21:42:09 -0500
Received: from mga03.intel.com ([134.134.136.65]:41403 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgKMCmI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 21:42:08 -0500
IronPort-SDR: gAaqoklF7Lb/3p7ZrCcy0XCK8cytrVk5EqupY8pOZnD+HkCPAR62XuA8y3o+QgMXjm5nHw1+gj
 AqlWC7SaYNHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9803"; a="170523333"
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="scan'208";a="170523333"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 18:42:07 -0800
IronPort-SDR: qXqwrFziFU220KVY8UhnjCsLDvrcBm8d7B7ASnXe7l9pX5ST4uyObPY9Z1gFUGHBPs+LstgD3b
 2RFQsK+QJ9SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="scan'208";a="357345760"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 12 Nov 2020 18:42:06 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Nov 2020 18:42:06 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 12 Nov 2020 18:42:06 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 12 Nov 2020 18:42:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vr6mO/e0JFvXZGRQ7URSOBDNPwL5CI+onShoQlOcJwP98dIi+aWR5y3bbPc6VRRoUXitC2cDnU9wzT5rAmBjNnUaO1yUfOYhS41XHZ3LJwRfatLAvTvzb7F2sQzdMxBE4XFGKBoLIW6OinUc6nJ+gJulfp4IouJ/W3Mgri6sAH0hjteeDAdHlEjCefGXBH3efy38XSU1b9UsMIBQyGcsl5R2b7J1KvTU5R6ALASiXUtFQRGABTUVXtOVXT+CUFck0eCskNAkKCPr4hJfJ+OecO3S15zyKQKY3mSS6YWoXipC6glHU4I0mFzEH/Z+mxTUoM8mUXGchUyL7/3xzdpfCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EU/uArnFcuwBsbsVnc2alVWSYlypA4HC7m1pc6H6T/o=;
 b=Me3fN64jbFPa3silIy4HXc6Bf5+yWdZa0KlATmDhtUaJFvgs5nOroapkbJYhz7njTmUtoAw2BYRBHTsvARySpZnKJ4ajdCOr6/jybiZpEeaB/hAk2Hj6nKnuIDLAp6uqGXfCAfb8w6E0baeB8kkwHd+iVgiKGLGTIE2YEfL2GUg18g/Xbg6XLb6+smByLgdTE2AFP87769hRULQrFZbsBVi9UOssXDeBId9cGsZaDBjRMuI9GN0Qaj8H49jpgGsfToF8CXNAWPvuBvh8lLoF+sYgRIATr6RLYDhkPQO3zQMEeR36RBRqIsiAdLfreEFaoJfdjD2YtXyhdLXbPQOtqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EU/uArnFcuwBsbsVnc2alVWSYlypA4HC7m1pc6H6T/o=;
 b=kmXtNd+TEdEC5klsVB0aUtJ3hBC/5Cm5mb/z7kPGpmCc5edJNO+C6E7GN7BltrLB/tCyPMRiEVbnjuwnMvY9axYepLtps17FlWAp0zjDZq9kfRiCo9z95CCN+PftiZBTUqQRM6I5G3J2R7qVffe/ZADTi/gsygPG1RN+6L0a3tI=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MW3PR11MB4699.namprd11.prod.outlook.com (2603:10b6:303:54::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Fri, 13 Nov
 2020 02:42:03 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::7ccb:c84d:5042:b50e%10]) with mapi id 15.20.3541.025; Fri, 13 Nov
 2020 02:42:02 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Topic: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcIAAp6mAgAD1diCAAJvfgIAADi9AgAAGfICAArW6cIAAY8KAgAA79QCAABGDgIAAY1IAgAAHBYCAAsnwAIAAVwYAgAC+sACAAGcnAIAAVyaAgABtcgCAAFeIgIAAPx2AgAEDTgCAAnqggIAANQ4AgAA8P1A=
Date:   Fri, 13 Nov 2020 02:42:02 +0000
Message-ID: <MWHPR11MB1645F27808F1F5E79646A3A88CE60@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de> <20201110141323.GB22336@otc-nc-03>
 <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201112193253.GG19638@char.us.oracle.com>
 <877dqqmc2h.fsf@nanos.tec.linutronix.de>
In-Reply-To: <877dqqmc2h.fsf@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6db3dca5-a022-4af9-39bd-08d8877db3b2
x-ms-traffictypediagnostic: MW3PR11MB4699:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB46993F6605DA07D6FE9ED6CA8CE60@MW3PR11MB4699.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fAv7Oz6veA7eDttykgH5e4/WPKvjEOWvV5JjjkSLq2JZM8Ia1OPeetVRIQN1djEzmvomFqV4fjb38PNV3tyv0LuwKDgsvDAjITcr3jGCrT2yNMElopd+lsdB6fQF4ZWKe4/HUF4MBLgWGlUxMbPDV+8mIODdH/KvNQsH4kUbFIGzglPIbeSTwbEOCj/p9TXB39ZvGiOCqoNYO+ZKgAsTDBFUOLGo6Q69VPBunFIDy/uJyIvlEHF4WpmHQgJJB4r7df+8LKN++8CROFl/o98HZYgSVhUjFaTQRRaKo+geeQDo054G3t/ewA8cF/0LlsbA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(5660300002)(66476007)(33656002)(76116006)(71200400001)(64756008)(66556008)(66946007)(52536014)(86362001)(83380400001)(66446008)(54906003)(110136005)(9686003)(316002)(478600001)(4326008)(26005)(186003)(8936002)(45080400002)(7416002)(8676002)(7696005)(6506007)(55016002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: eTTOr/paLzEm5phxgUhbTcdlFMcfclSmossivLU2jhsv0gxHpk+yRymwm5i+sI4nBBFE6qLUZk8QwyMZxcZIdtbE2bM++KtHT+4C6Di7yovS8kOgzXl5AvxlL9w8zPOMPSh4iYyjTIN9vjVElUgzhBnzI//Ip5F7WQTpmygK18d0t5o64eaeoLgWBHTaSQYWbUw0xUssf/u/f9cXY4Rqbgq5ENRPSMObhHW64cCycfwEtSyQGaJkus6xZlDfQt7n7yy/8dlbocQZDXmilR5OuYDuIyzJyoCOuL1+5USNrJpCcFh/YCmf9GK51Sig6UmR3F4A/Lj49+CH12yk4aSHVB2ECb/RAk8yAqzT40LGZx2GYZiD7SeTo1je70RiqBjWtW5FPjaedrWXgAciCEIQBbblkEjI7haHlOnEJ56niknGKgu9p0HMH350xQB1boZnfLbJH6jWWM9lmsNBC+HMirTztFwkm1P/ggxP1R54i0vpHJgEMBPdFj/46SrSCg1cUFQrKcQ9rCrghPYihF/9pQEDKrd2EoLN/WK1qAYwDvJCw4+yirEotXIM8/trwrfvfcbfxexsExGG0fKkmDETLvDuEGZStcUbD1txMEj/016SduPJOun/KUcNHiqQvOZA//pyG9E9CkFjNxovmSTP0A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db3dca5-a022-4af9-39bd-08d8877db3b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 02:42:02.6119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /w98zTuY+AEJ9n2PL8tbhzhkxLFlRrS8VKyiNIyv7PDxHO6i5Je6o1qpssfpKwdfbrXBCKwJJuAPp06YIKTG/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4699
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Friday, November 13, 2020 6:43 AM
>=20
> On Thu, Nov 12 2020 at 14:32, Konrad Rzeszutek Wilk wrote:
> >> 4. Using CPUID to detect running as guest. But as Thomas pointed out, =
this
> >> approach is less reliable as not all hypervisors do this way.
> >
> > Is that truly true? It is the first time I see the argument that extra
> > steps are needed and that checking for X86_FEATURE_HYPERVISOR is not
> enough.
> >
> > Or is it more "Some hypervisor probably forgot about it, so lets make s=
ure
> we patch
> > over that possible hole?"
>=20
> Nothing enforces that bit to be set. The bit is a pure software
> convention and was proposed by VMWare in 2008 with the following
> changelog:
>=20
>  "This patch proposes to use a cpuid interface to detect if we are
>   running on an hypervisor.
>=20
>   The discovery of a hypervisor is determined by bit 31 of CPUID#1_ECX,
>   which is defined to be "hypervisor present bit". For a VM, the bit is
>   1, otherwise it is set to 0. This bit is not officially documented by
>   either Intel/AMD yet, but they plan to do so some time soon, in the
>   meanwhile they have promised to keep it reserved for virtualization."
>=20
> The reserved promise seems to hold. AMDs APM has it documented. The
> Intel SDM not so.
>=20
> Also the kernel side of KVM does not enforce that bit, it's up to the use=
r
> space management to set it.
>=20
> And yes, I've tripped over this with some hypervisors and even qemu KVM
> failed to set it in the early days because it was masked with host CPUID
> trimming as there the bit is obviously 0.
>=20
> DMI vendor name is pretty good final check when the bit is 0. The
> strings I'm aware of are:
>=20
> QEMU, Bochs, KVM, Xen, VMware, VMW, VMware Inc., innotek GmbH,
> Oracle
> Corporation, Parallels, BHYVE, Microsoft Corporation
>=20
> which is not complete but better than nothing ;)
>=20
> Thanks,
>=20
>         tglx

Hi, Thomas,

CPUID#1_ECX is a x86 thing. Do we need to figure out probably_on_
bare_metal for every architecture altogether, or is it OK to just
handle it for x86 arch at this stage? Based on previous discussions=20
ims is just one piece of multiple technologies to enable SIOV-like
scalability. Ideally arch-specific enablement beyond ims (e.g. the=20
IOMMU part) will be required for such scaled usage thus we=20
may just leave ims disabled for non-x86 and wait until that time to=20
figure out arch specific probably_on_bare_metal?

Thanks
Kevin
