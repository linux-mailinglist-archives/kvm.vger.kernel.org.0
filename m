Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4E02A654B
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 14:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbgKDNeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 08:34:20 -0500
Received: from mga05.intel.com ([192.55.52.43]:9177 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgKDNeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 08:34:19 -0500
IronPort-SDR: Nkjtov1G33QmxJcb4rMZM88Hab5SSV5cSTG/i4DaiIHx2E/Y3m8mOPO+yGoGWzLxeHBj9euly0
 RC1oilHyJ9xA==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="253925571"
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="253925571"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 05:34:16 -0800
IronPort-SDR: NgmbVQYUcA3bunZ2Xc8+nvxnfoCDayXtqYHuae/pzxuOoFu0y+Gbn5LRMbre0iqteDSQUBsP/K
 NeZSVjum2iLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="396904957"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga001.jf.intel.com with ESMTP; 04 Nov 2020 05:34:16 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 4 Nov 2020 05:34:15 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 4 Nov 2020 05:34:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 4 Nov 2020 05:34:14 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 4 Nov 2020 05:34:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7lGj3ng95F/4jAOdI6SbCwhFd1kkBaoRFqH8kBKqhKeWaUXqH9AYgtKq9xT82qaSeMoYueG/X8rjCeAtPrZDj2Wu/+qES97zS2gc0skNp5WX9ltSCZUi3jmPr5DqSZfIZMiqVH8rpu40cdUekgs7cfeP5z88bQF5W+u1SkWJX4mIJqj3hqsaUKIgc++QqMR4JZDC5cQ75EC0D6FxXTxm0q1kydPEAvZhox3khPfU7kScbnrIwlUW59T/7XBrB6FVzsviVyNcIi3KgBKLwqUyfnnNMS6kpoCnOoeQm29Gwjf4Qix82MaN0Q7vwV0/3eKanCoHdGpDorfAXlBouwNqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUa7URo6e3RjfsFpxP1bfWc/ExA9aIlFv0nuCFFkhms=;
 b=UZztkX4aPrZGgzMdovmUeDO0Cr+g/ANnFtzZ1GXmvMluH2PYfoNJqe4Sj1Y6PZxzLhz6XCGxcOmJ/P1IkIzFEHW7x9AAZft3VPad0X6UHUoPvUsyP8QWO2lAHlfG6NvLFStn19XXX43tS3WaneuR9hss0bIt7RiywNOX/OMzwr7C15W02K0LDPuwuByPEB8/2IJ23I4+brk/jWq3ZQN0rNxy0xZxxSrSCNdxgWphBtqlLjCdsLmnM+mMXqZcbGZGodUovPh47PkV+DzVjMEJ0wyA08QIqlJR0MO2cTU0LRp/lNcmVSZkijjchxQ++3ZHxM5eaDpyh9OKvIWo0FNCHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUa7URo6e3RjfsFpxP1bfWc/ExA9aIlFv0nuCFFkhms=;
 b=d23bIfTr6KtnC3/cvJSM3nX04l52RBX8a89ORgWYAg7xAog+nOb9Gv025G8oBnuqgaKMJf0Dr4axNPKE60Zlb1f8xxC2DqOitIYjCEXmQEQVNLvbSwrKHcZs9sLL98qfWyu4Hzo0PO/EW5mIZ9Vms5hAh+AmyLLF++YlJPphMMo=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1501.namprd11.prod.outlook.com (2603:10b6:301:d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Wed, 4 Nov
 2020 13:34:08 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::f8e3:1ce2:fcb2:29b5]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::f8e3:1ce2:fcb2:29b5%8]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 13:34:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jing.lin@intel.com" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
Thread-Index: AQHWru26nCdjGLbk80+ZhPfx8iZ806mwjmaAgAAYm4CAABfkAIAAARAAgAQYdwCAAOAGcIAAp6mAgAD1diCAAJvfgIAADi9A
Date:   Wed, 4 Nov 2020 13:34:08 +0000
Message-ID: <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201030195159.GA589138@bjorn-Precision-5520>
 <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
 <20201030224534.GN2620339@nvidia.com>
 <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
 <20201102132158.GA3352700@nvidia.com>
 <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103124351.GM2620339@nvidia.com>
 <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104124017.GW2620339@nvidia.com>
In-Reply-To: <20201104124017.GW2620339@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba2cfe07-fa35-4f43-679a-08d880c64ed2
x-ms-traffictypediagnostic: MWHPR11MB1501:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB150197347199261FA0C393058CEF0@MWHPR11MB1501.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ELV7a3eHNrew57SRPctC2SPDJZ7zwyrej5vUSFXV3/os3621UoKtAwKQQvH02rXjLeLoAbFnr5ngk+waCeHL6kXehdpLFMb8P7CtemYhNCuADlAPbC5EOCvP6A0Pofs+QMFonruQ1MfEl938mEep/mKwlzHmIonH6+Zu2K5wD4IrkifkiFjuktgVlc0B3Ar48pMB7a+3QFlGpXfxOi+1r+ks3Y8QCsJEZHbgFKywQhLhaMIGs71B4iT32E7bWv1H6AozHGnUuBqzILbYsQSOONwufpsVh2EXbCNEHfMqw4L7s799vbR3AFDCYX4BGOZ6SQxR8tB/PkWs8OPPeMqB5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(66446008)(316002)(66476007)(66556008)(478600001)(71200400001)(7416002)(186003)(64756008)(76116006)(6916009)(33656002)(66946007)(83380400001)(52536014)(4326008)(54906003)(8936002)(2906002)(55016002)(9686003)(6506007)(86362001)(7696005)(26005)(5660300002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 3Gtsv0aj1tzjidZXSbjBmciVWHedcUpD1/C/cO8vmwFhNsLep0qU3Zc5dbgZvMuw6lTntFdgDQRdAFQsk25NXkk1NVP62BqULj3nRyL2y4lc6BnkiXsje//RRhh9jhJvsTA47eLy+arQyjmYTIhiy+NlM/JXqvfKOv+WNT+mao3jip7eLohL6Wm1BVV9STx2qD4f9T9oZRrQkc1j5uZtxgZeW+C6ZScBlhP2bEdk8jGeEF5AqUEfuu6cHdzaS/ZJ/VpsGKWGqx2tfK1Z9ESRQXKvBFCNoA6dzbIraZR/gr7GAKkEgPgaTG9DdoS8HWkfk5qs3IR9Po45IkoR+6OsHmRetsNgdEWSIJQZr6G7ujibSg7Kub1W91ldXM2MifP+BYIymSZfYnA0FHNB8GN43QxfnmbuoaM01NSgIIETVCGHgge0AkkbSANO4jbRSMYyaGiMvICdb6mwq0yT//uL48TJihkKMoaTM8NsnKLJj/sBYpUqMk0EzShbN5q4Tf4OpBqt8EfTXAERfzJ+jnZBfZl00crLpMxKSLL17jHJZI1In/dlTFKT2j3DyrAwRnC8XePSroYlthEdYtzeGh1PqmEfgZ7B4W79xnE7y3p35VRL+szgU+QCIo3rIYA234xLpxAwvzqhThteTMOGGFOBuQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2cfe07-fa35-4f43-679a-08d880c64ed2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 13:34:08.5377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LimQEMCOO3PQMLGD50oBf+/+4bWtCtLJztiu75NAxbG4dyL8h1Cb0NTcAtJ7wbssxZCnlbVJXcwu7k6ELuunjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1501
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, November 4, 2020 8:40 PM
>=20
> On Wed, Nov 04, 2020 at 03:41:33AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, November 3, 2020 8:44 PM
> > >
> > > On Tue, Nov 03, 2020 at 02:49:27AM +0000, Tian, Kevin wrote:
> > >
> > > > > There is a missing hypercall to allow the guest to do this on its=
 own,
> > > > > presumably it will someday be fixed so IMS can work in guests.
> > > >
> > > > Hypercall is VMM specific, while IMS cap provides a VMM-agnostic
> > > > interface so any guest driver (if following the spec) can seamlessl=
y
> > > > work on all hypervisors.
> > >
> > > It is a *VMM* issue, not PCI. Adding a PCI cap to describe a VMM issu=
e
> > > is architecturally wrong.
> > >
> > > IMS *can not work* in any hypervsior without some special
> > > hypercall. Just block it in the platform code and forget about the PC=
I
> > > cap.
> > >
> >
> > It's per-device thing instead of platform thing. If the VMM understands
> > the IMS format of a specific device and virtualize it to the guest,
>=20
> Please no! Adding device specific emulation is just going down deeper
> into this bad architecture.
>=20
> Interrupts is a platform issue. Using emulation of MSI to dynamically

Interrupt controller is a platform issue. Interrupt source is about device.

> insert vectors to a VM was a reasonable, but hacky thing. Now it needs
> proper platform support.
>=20

why is MSI emulation a hacky thing? isn't it defined by PCISIG? I guess
that I must misunderstand your real point here...

Thanks
Kevin
