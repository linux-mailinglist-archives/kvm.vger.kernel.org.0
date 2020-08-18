Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572CE247BB8
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 03:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgHRBJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 21:09:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:46438 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgHRBJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 21:09:07 -0400
IronPort-SDR: Z+3YWi9UcULeJSupfJQ0M3wo2DHPvEL7OgDgJIM2tCk65mnC2EqqYaYxlfzS9k7xyXLyBI/luy
 PbQ31/xBN08w==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="134341875"
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="134341875"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 18:09:06 -0700
IronPort-SDR: thCIKDEUUlh5Wqc8ztoXafFY37n9BEaHSxF/2/Zec7UJe5jRG6yUv2pjLKufWEqOYsWKSdRwAa
 iKfspx+LFqPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="296666516"
Received: from fmsmsx601-2.cps.intel.com (HELO fmsmsx601.amr.corp.intel.com) ([10.18.84.211])
  by orsmga006.jf.intel.com with ESMTP; 17 Aug 2020 18:09:05 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Aug 2020 18:09:04 -0700
Received: from fmsmsx124.amr.corp.intel.com (10.18.125.39) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Aug 2020 18:09:04 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx124.amr.corp.intel.com (10.18.125.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 17 Aug 2020 18:09:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 17 Aug 2020 18:09:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2DnYqOTHuDLgtEsH9Um6KExxgSSVWQpJht3nfe06d1C0fqal6MtYylR4T3Z+RAOymf8hBbG9A01tWF9KaKx0H+DHUk8SqRltIIZFtAzT5oKJ/Exuq9WEQ2WDHOZfReI9cKcBpgVfW8sl2iYD9PZjEJFCdNcZoNlD0BXKjrRH+HEozpzJp/efnE6tvfGEApFxBVIwUmACm2HH9c8Tn8kWhYbs/n12dUR8/1qKoBJNM8oPIU81Pm7WYoTwfRKYv2q2mkNBj7oVfwplZlRK0qP7lzDc9q9Dafuo19GNU3TZnd0LmFmk7RO+UXK5WRCBniimSE3BFeJaY6LeKwfONb0+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLHqtgVyUwyN27DkR8EGxm+8uNPliZsytfwDxwCltDQ=;
 b=ennkBYtJITVseHAalQPr1oHePKhRJLTtT7DElHBzKNyuhtSnkZMPDHWWlJ8aupMvMXdnSXWE0070j9qjvSRVG0528l9+dGsCKWzpkL1wi/1xMQJzn0FZyhFvuTMJCmOSJXdGEjlGgrDE/JEcjfkCvDRgugRb0yxp4nr2SlnyuuzBDJ++A5Vy/5/+cEXgD0V4yTf7PbduCCJipKM++sg3BKKRX2pJPLEGeKG7DRSUQ8xI4XYI00O4z7vJ6mHrPLLRGM1q9d7ucIZ/QiSUpDTFgqS8AcLYGXNRFH2iQ+kl3rOErjgiyYdyiOBVo2a6Kl+fzELarJZwakV4ujz35ws5IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLHqtgVyUwyN27DkR8EGxm+8uNPliZsytfwDxwCltDQ=;
 b=HjDeFxKwCow6BaHmLjPP3+22i/9SQ8bmwfMVEv/xE+NJQb9+QimZ+cC+s4+sdWD6d3trwpJAIcNRxN3ZYlZR0m3jHiDZlsDHGCugHbSxns0Cyq/67xWQOfC7xhaBZY1xevjIH3xuAjPgy9iYGKK5SOrAf67fNepLkgloLoyCKTs=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MW3PR11MB4668.namprd11.prod.outlook.com (2603:10b6:303:54::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Tue, 18 Aug
 2020 01:09:01 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 01:09:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
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
Thread-Index: AQHWX3hut2htBlMVB0qfW0Pa+gZbC6kSPbuAgABwW8CAAzMrAIAUgAoAgAJJ4oCABDO9YIAG4akAgAPzRxCAAX50gIAAAjDA
Date:   Tue, 18 Aug 2020 01:09:01 +0000
Message-ID: <MWHPR11MB164579D1BBBB0F7164B07A228C5C0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200814133522.GE1152540@nvidia.com>
 <MWHPR11MB16456D49F2F2E9646F0841488C5F0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200818004343.GG1152540@nvidia.com>
In-Reply-To: <20200818004343.GG1152540@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f51708b6-d6c3-4510-64ff-08d843134b20
x-ms-traffictypediagnostic: MW3PR11MB4668:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4668F5E069E86F80EA459FF18C5C0@MW3PR11MB4668.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QiQdJQ3hnbImlMPckHLmgNhb9ls+Sjcel5/VzMymDjjXzGgCBYcCpQS9hoyfMAo0MKLRCFb4NANdmdOkdyV1a/UDuHOb1/XVgUYhrFvdxM/JtvBTvSjlZ8rHfe3Y2AMN/y5RmiZksn4l1uZvJ+yIMdN/xxL++cjXswZa1zN9t7VLSI18rYdhqdov1B/LGs2bMa5vode3YEa/ZJapPVGysb1uGfi6jgnrDixVCeIkSIYmfBymHrSd3cs94CUixS01CKdDKUH/sGHI/GKVOW7yFr9iNrzKiNlX/ah+oxhYrWrb3FnSOTdcbKr3SXDDr2UnRMWlbXpYVCDInyj0mnrukg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(9686003)(52536014)(8936002)(71200400001)(6916009)(33656002)(66556008)(66946007)(66446008)(66476007)(76116006)(478600001)(4326008)(64756008)(8676002)(55016002)(2906002)(6506007)(316002)(83380400001)(54906003)(5660300002)(186003)(26005)(7416002)(86362001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: W3qz0/OComwpG8fnjoxFikyFyZZQeD/JuM59adl7SOQpJIAp880nVq+55HwjLUab2BAnMQzJnfbUNVC37xVmCixt2LaVUmyMgF6A5cwbgyJ9JxX7UrGzvJJVTQ7EZqZJSNQElC/t6dFaukmMtwGI2B15H8aMsvVrHV9F3UOpfs9OBI4ykuR+4Yfkak0Hdeeg0ftnmGpqQB2qIcpp8UtW/GE5eBYkwFOjYTi5FZ6CXI4kwee95EgyLhZUMm6GIziN35Pp+10rxBbQOJadfn6RFOF+UREqFT6tZisbvVqm3lnPUPrVMjsvkqKuB4Trw4Lg5GWRBI9ndK4PebVVTMqks/FKsE2oB7RFuCL5+TyNeEdVjO/SrAcSulTjhsbt9HDkgR9OIYJavK9BHtDCGBkx8eHSSsEjfRMzpf27CmWn6hklzaf6yizFhMVNYHGE63FAe7zT++p3635efymA3spNkn8PGcINZ3PlwyPhoW2d0e/dTP47xmBdVGU7EtAIOKeS/BWP96rqYTgYDnSA0tEknt16UUZn7eMRQoe4YT3tKk+XRYo1klThRgTr6I6m+hQSRJtHXcNQilYJGaRhs5ohhcnRXszU0HUPiIP/I/YM4nsRBQdSpLSGOHEIXsjUbZWNq2MVFLpVC52y60QFnhtFPg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f51708b6-d6c3-4510-64ff-08d843134b20
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2020 01:09:01.5729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tvV+C2UyD4jCWgcEMdJwxyWo77OJECvc34xaXhfq6c+MabiJYULWRIn1HZHxT9k5yeGw3s1BtgFaslyB4MLevw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4668
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, August 18, 2020 8:44 AM
>=20
> On Mon, Aug 17, 2020 at 02:12:44AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe
> > > Sent: Friday, August 14, 2020 9:35 PM
> > >
> > > On Mon, Aug 10, 2020 at 07:32:24AM +0000, Tian, Kevin wrote:
> > >
> > > > > I would prefer to see that the existing userspace interface have =
the
> > > > > extra needed bits for virtualization (eg by having appropriate
> > > > > internal kernel APIs to make this easy) and all the emulation to =
build
> > > > > the synthetic PCI device be done in userspace.
> > > >
> > > > In the end what decides the direction is the amount of changes that
> > > > we have to put in kernel, not whether we call it 'emulation'.
> > >
> > > No, this is not right. The decision should be based on what will end
> > > up more maintable in the long run.
> > >
> > > Yes it would be more code to dis-aggregate some of the things
> > > currently only bundled as uAPI inside VFIO (eg your vSVA argument
> > > above) but once it is disaggregated the maintability of the whole
> > > solution will be better overall, and more drivers will be able to use
> > > this functionality.
> > >
> >
> > Disaggregation is an orthogonal topic to the main divergence in
> > this thread, which is passthrough vs. userspace DMA. I gave detail
> > explanation about the difference between the two in last reply.
>=20
> You said the first issue was related to SVA, which is understandable
> because we have no SVA uAPIs outside VFIO.
>=20
> Imagine if we had some /dev/sva that provided this API and user space
> DMA drivers could simply accept an FD and work properly. It is not
> such a big leap anymore, nor is it customized code in idxd.
>=20
> The other pass through issue was IRQ, which last time I looked, was
> fairly trivial to connect via interrupt remapping in the kernel, or
> could be made extremely trivial.
>=20
> The last, seemed to be a concern that the current uapi for idxd was
> lacking seems idxd specific features, which seems like an quite weak
> reason to use VFIO.
>=20

The difference in my reply is not just about the implementation gap
of growing a userspace DMA framework to a passthrough framework.
My real point is about the different goals that each wants to achieve.
Userspace DMA is purely about allowing userspace to directly access
the portal and do DMA, but the wq configuration is always under kernel=20
driver's control. On the other hand, passthrough means delegating full=20
control of the wq to the guest and then associated mock-up (live migration,
vSVA, posted interrupt, etc.) for that to work. I really didn't see the
value of mixing them together when there is already a good candidate
to handle passthrough...

Thanks
Kevin
