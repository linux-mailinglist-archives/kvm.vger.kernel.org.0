Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AB12EC7EC
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 03:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbhAGCFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 21:05:15 -0500
Received: from mga06.intel.com ([134.134.136.31]:39073 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbhAGCFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 21:05:14 -0500
IronPort-SDR: rpfjyvl29yKNrA04nVl+Sbrs++innHhJIrSd8oZDYZV17h7HcZRuKkcw3naICjLZVSRG5pGdgs
 JIkEfdq6ytxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="238909868"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="238909868"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 18:04:33 -0800
IronPort-SDR: 20nWvjBC8MtXLFnTMJBYbWOxSaK40eFR/XqFH7Wbq7K4UpLPJPi1zRu4rw3kubQGsEan2cWKW1
 mkyf+La0CUvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="387735550"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 06 Jan 2021 18:04:32 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Jan 2021 18:04:32 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Jan 2021 18:04:31 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 6 Jan 2021 18:04:31 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 6 Jan 2021 18:04:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xg/PkQBki24js4QEFSmJLsDPoCZVBw00bF55p/hZ1un4MjdeDsLjkSY0ONHNUO1NZpSadTFcGS1ZsjeKRcO3bRypjWsi5xvStRkzN7NNSpMR2Ty021U3XC8MYUmg/gxMHndV1lviGh7uSNaYLbdykJhVsuHz9ee6nLoV+3BR729RmiWTidgtYMD1bmliVYWF0ysmXc5+ub/RQDL92HhIXLaCfQgpgQcTf+DUv4XRc8haNuYUkmOB+CWNOQljuk5qJZU8IurHyLeTiIkxbdlvcJSNeIxKEz35Bcwk/ophWfPaJbwxf6P16tZU75bXvnp/82ODzOLx2UxfTedq3BtpbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGmyIRGNzvh9VDyPStjJ8tOsK+hgRwyP/abTCpils3c=;
 b=WWSuQS9+jdHh/HLWfY9+q4GeG0rZ5iz2DHl9SN5oUnoU4KpjmemIluBx/kCaDlkQAoLbqbAwHf73GgGeGp1mmI5eeYJOb5fVXy5KEcth0IqVj4qmfJhc4zpGZX0UyoZwmjyB7lABhoeybYTKxy2+GfwWZq4gkvS7Um0aKntqS+ghgoOaSjIktSFKZY6yV7evmbe1vFhEpQMnd/Lnggajf1FHt6VluzOYf9fTPixo7FKaH+6JkAv8s1keMEjMejRKgxeHhNZn/qNzniEdQVuYV/WvAupL8rZhQOhC/kciMY2kSKevi0iXLJUAfe2EKExD4r5hyJ/SMBFWI76vf9k6XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGmyIRGNzvh9VDyPStjJ8tOsK+hgRwyP/abTCpils3c=;
 b=yP7Q0lSA4S7j/C08B+7/+tYWbPyvNwO3uy77gRqffVNhO6Cog9f5HiriLPBbHeuBJWkquS5BMei40pKTGv3sOIwfOavhhps7WSTdIgW0qE01BUqZqBgwiuCN3us63o+t7E5vGwAoys/IIAbUu1xwsizkNWnn4/WCX0XB6PInNVs=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1838.namprd11.prod.outlook.com (2603:10b6:300:10c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 7 Jan
 2021 02:04:29 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::1d96:5d95:3a17:2419]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::1d96:5d95:3a17:2419%4]) with mapi id 15.20.3742.006; Thu, 7 Jan 2021
 02:04:29 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [RFC PATCH v2 1/1] platform-msi: Add platform check for subdevice
 irq domain
Thread-Topic: [RFC PATCH v2 1/1] platform-msi: Add platform check for
 subdevice irq domain
Thread-Index: AQHW49Su6SbTQ4wqJ0uR1rOXugZzS6oaHGmAgABEJ4CAAAhrgIAATyyAgAAKtQCAAKJjIA==
Date:   Thu, 7 Jan 2021 02:04:29 +0000
Message-ID: <MWHPR11MB18867EE2F4FA0382DCFEEE2B8CAF0@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210106022749.2769057-1-baolu.lu@linux.intel.com>
 <20210106060613.GU31158@unreal>
 <3d2620f9-bbd4-3dd0-8e29-0cfe492a109f@linux.intel.com>
 <20210106104017.GV31158@unreal> <20210106152339.GA552508@nvidia.com>
 <20210106160158.GX31158@unreal>
In-Reply-To: <20210106160158.GX31158@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.88.226.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f21101f8-3d70-4933-040c-08d8b2b09158
x-ms-traffictypediagnostic: MWHPR11MB1838:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1838B0432F64A3B8D69F324B8CAF0@MWHPR11MB1838.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zC1Yh8JZQlgYFWtmmfBFjIXer5uHduYvwV+l0+OiO5RK//FA9n2/R0/cp5nP1H95Des622M3WXNKQ1qqAC8C/8iDgP8b1DmX4PQu/gw3sXrPvMamirl5afq1nY3bHXVzndu+XlRD7Gs745IlykLrHZEhYuJIUw7LI1X8F2/phTZ4So4sQG9eysaerlQotbRZaUyh1GpmtEeqaHW5F6oDaOhJGrexd6cUWBF6MBJvQeCQYBX1k+hdSQVtcN+V2N6KKGoXw67eRIEufMFPcwIRBwDoBqyGTqKKwjGd5WKucpBWnWCzNX2Ar0Ueux6QGQKeWBuXn4b/IoYhOCbNDDbOq1PXBaR0nn9Yme3yZamVFEimKskF98rFLQK8GTX+7Fb7bMxM4jMLEdkTwIMoMGx2YQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(186003)(6506007)(9686003)(2906002)(26005)(66946007)(8676002)(55016002)(66446008)(76116006)(52536014)(33656002)(7416002)(71200400001)(66556008)(64756008)(5660300002)(66476007)(83380400001)(478600001)(316002)(54906003)(86362001)(110136005)(7696005)(8936002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CjrEtsK/LaOxP/4eIxMnaodHAuTbJXqfEZkt8BzPT6OFx2EB3tMZntDXUJCl?=
 =?us-ascii?Q?dUogdcgEEMhVny3tXg2tV4HjjFLnstBRUFuTMeCnDiGL+yZbXHmQejOE5/ZA?=
 =?us-ascii?Q?OZVp3CjilBDT2Sx2/ERCA7qpAXQJdKSeolzKZExQ1WWPCZra5XOnR5K8GmRq?=
 =?us-ascii?Q?5e50FKKE3wSDjJi/5XSjZzmZSWgbud5iboS0bCIuO5saRYHsvd1JHzncUhde?=
 =?us-ascii?Q?qxKByoHMmNaGpd87wHPXnB7qMckFOzulwmiXW9RcDPSn2htGLF/LmyLNYZM6?=
 =?us-ascii?Q?5NKPFDQP3Bm7xSGS11mELNoFKWjJLVe5W6gFStg/kMCqjFIwkF5C7rrqPjc7?=
 =?us-ascii?Q?slashgTTO+d6tX/yIb6HZ7eyIGaUiTwP74ADpzVF/DbfKeh9AqsTFIDSTux4?=
 =?us-ascii?Q?kbkmu1dpEYDAjS/F7ZnQQQeCcjYwXwrgaUh0jxIlds/dByo1aro6kAFCd5ao?=
 =?us-ascii?Q?J10ZqB4zqmyN6/5iOUTM/8Y9RATj4diRAaW3whim2TT4HPXE0GLcMtpwhZWP?=
 =?us-ascii?Q?sOJ6/9F8wu7AXOr1Pkf6u/9YbpC40FyMOqRUy9C5QnSkyNQu8CTr215woZd5?=
 =?us-ascii?Q?Ugroxdo7ITYXtDYz1b7zwob8m+gotAgtaDpw9i9Zh67XdwvGi9uc+mR4uoJN?=
 =?us-ascii?Q?E+7ibdiOSRYR7bgW9AwBgXGLQcH+73HJPw70Ec7Y4IKHS/UPz4crDjFSoUpY?=
 =?us-ascii?Q?Ieh203CHxmrZ+yiW6a3wgz4uBGmtZm6OaFgTcVmZoy5kju7vwybwhjUFQtWC?=
 =?us-ascii?Q?6Smthlalz/4fBo/ardl1x3emf6Lz49ILTY4IGoDoa7+MhX5IvFV4uwmaG85d?=
 =?us-ascii?Q?cW5o8oHMDfn8JczTddqHfC0dd/oxTxJQRCztlYrTilBODC9IBZF83D71HflZ?=
 =?us-ascii?Q?13eusXuerDhTuLWvqGYvIr+c/R5DHkgmyeF2PWURr0vq9uZ6W3ge0sMVKW1t?=
 =?us-ascii?Q?nyCCbLvnaT7zS0Tp9TPsubKnK9TLkkuaCsHSGlj0x90=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f21101f8-3d70-4933-040c-08d8b2b09158
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2021 02:04:29.4198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PqKX/vgsm7XCAxXgZuFcIfmJDcdWFzMaiEsck9Hs4DvuLWxgLni+AlWq8MJfFdz4bMACMejfw/L8slW1xFBHIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1838
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, January 7, 2021 12:02 AM
>=20
> On Wed, Jan 06, 2021 at 11:23:39AM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 06, 2021 at 12:40:17PM +0200, Leon Romanovsky wrote:
> >
> > > I asked what will you do when QEMU will gain needed functionality?
> > > Will you remove QEMU from this list? If yes, how such "new" kernel wi=
ll
> > > work on old QEMU versions?
> >
> > The needed functionality is some VMM hypercall, so presumably new
> > kernels that support calling this hypercall will be able to discover
> > if the VMM hypercall exists and if so superceed this entire check.
>=20
> Let's not speculate, do we have well-known path?
> Will such patch be taken to stable@/distros?
>=20

There are two functions introduced in this patch. One is to detect whether
running on bare metal or in a virtual machine. The other is for deciding=20
whether the platform supports ims. Currently the two are identical because
ims is supported only on bare metal at current stage. In the future it will=
 look=20
like below when ims can be enabled in a VM:

bool arch_support_pci_device_ims(struct pci_dev *pdev)
{
	return on_bare_metal() || hypercall_irq_domain_supported();
}

The VMM vendor list is for on_bare_metal, and suppose a vendor will
never be removed once being added to the list since the fact of running
in a VM never changes, regardless of whether this hypervisor supports
extra VMM hypercalls. hypercall_irq_domain_supported will actually=20
detect in hypervisor-specific way whether ims can be enabled in a VM=20
(return true only when a 'new' kernel runs on a 'new' hypervisor). In=20
this way no backporting is required when running a 'new' kernel on an
'old' hypervisor.

Thanks
Kevin
