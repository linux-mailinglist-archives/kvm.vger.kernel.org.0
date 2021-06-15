Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1ADC3A8D04
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 01:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhFOX6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 19:58:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:59745 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhFOX6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 19:58:37 -0400
IronPort-SDR: /1cSLOadzC74JU2Qw3wC8rVnmPfcuZ67htmTue/UZ+9u0wusL2JEDrM9SDbyO9StiZK8DR+2TQ
 Ej15Fliscoow==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="203065892"
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="203065892"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 16:56:32 -0700
IronPort-SDR: EuqGH+XT8DGedFSVdhlD912IizGA+ugPjuLam46bpXY5ds3FcsADfmCp/CjOCDFTfXdkwRrVUE
 tVMqnsiDRLpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="415549439"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 15 Jun 2021 16:56:32 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 15 Jun 2021 16:56:31 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 15 Jun 2021 16:56:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 15 Jun 2021 16:56:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGj27oYfqHywQkt+OY2aDzHc7jHSn6Xw7EF/fnQ+e0XK5IQQVbNshzjLboKNT4Xo7SUcZI6DRqSOgHrfhHxNIBqxo6rvw/vITsxLDuCZDVpDxWFKGc0DmWKBpBtnghij9IOjvKNN0YZa5+ywA8w+1/xibK9PjsJSJelBQOumkuKX31PTmTE+htx+J4KCPN99nUmtq1/gZfouNWSr1qCdCBjdYuRvt4vAuL0bNi6pygGrW4kNxCJpqcfKwJUM8gCC5SXYvv1V/kSTFTzhOTCwM6f7rGPnl8YCWRWVrWUS2gMFjpqACM50Va5lI+GRG/pzhVtlMZ3Ee0hwqGVDapqHvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wMXgoowU8/fdJ2Dypb5RF8K8dYN754TsWbk+vCCOSA=;
 b=nsgOaU480JdKW+PFTJNGstMw6gtI/S1ad9ObhOx2Ia29MoY4xVdbiOApEyhX2GNvS79+f7ES6eo6jC40SHoP35Kruqae4xXZgykcE2G8BklUQMu8EwKskjai8xkbQ/6MNa7nwDQbups2n7uEzM1ljCvqU6kZoS1rDjZW0dqvqMJA13rbNvyeuf+SF4rg0NLc2/Hdh6HZrpwjZCp9ERYkSca4O5uH+rqQdnYgSyQbbYGF4ePkRz9FBR0Q2NJbPhXce0NozGXbSsMQmS9TMHWc8ElXHr3FaeasYEtJiHxFqeLKFRwkDxiyAMFEBY0NhmPx0VNOxl+IfkYCbvs5T0fTXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wMXgoowU8/fdJ2Dypb5RF8K8dYN754TsWbk+vCCOSA=;
 b=Wy8qj1Cxki8FQGANARCTQkeH+VAXBPWwuK9trbsod9vZCaz6Fle493+V0fK1L6Id3c/J0XdcKSRtd6tRCwbFkgWj3iR8iz7dSqt5XQLkD+rfeMYlTt4MM3ckZ4TC8ohlqjiUeVIOyitSv9LLyvYCrNZZ31qyZlvz3JK/RgoVrqo=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4521.namprd11.prod.outlook.com (2603:10b6:303:55::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 15 Jun
 2021 23:56:28 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4219.025; Tue, 15 Jun
 2021 23:56:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Gibson" <david@gibson.dropbear.id.au>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ97BhCb3gd8AUyldaDZ6yOMNABTUTCAAQiuDaAADwOFgAJSmyVgAA0fjwAAEFKEEAAASwWAAAAgcXAAATmRgAAAC9Rg
Date:   Tue, 15 Jun 2021 23:56:28 +0000
Message-ID: <MWHPR11MB1886FD4121F754A6F7C2102A8C309@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
 <MWHPR11MB188621A9D1181A414D5491198C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603130519.GY1002214@nvidia.com>
 <MWHPR11MB1886BA2258AFD92D5249AC488C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615150630.GS1002214@nvidia.com>
 <MWHPR11MB1886E9553A5054DF7D51F27D8C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615230215.GA1002214@nvidia.com>
 <MWHPR11MB1886A0CAB3AFF424A4A090038C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615234057.GC1002214@nvidia.com>
In-Reply-To: <20210615234057.GC1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.71.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f64648c0-1d0d-43df-7ddf-08d930593111
x-ms-traffictypediagnostic: MW3PR11MB4521:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4521F1E9DF38B73DC0F8A7698C309@MW3PR11MB4521.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VHMG9g0Fuq598A2iGgf0xcG+GXNMxibFIN25SdSw5P6l+NLdFPb3doSrhqVJm0wvKff48mNPFf9nSoZ3yP4PS4a95nLEunoEpMCUwNZbQOas2DZCnveBO0lH+okjkIt1sXM3TYDSSOY2YLGTz9y7Oz41KcFo08mBUrYL/lhddmeU2i5+sKcck6ssBba02SUjXZAPRTbVwWC96Dw3xjid7+2Y9dn4i9nhC6jUq1aYepQJClQyIWDv10vWFm86sRGVd6eNq5DUty066DvYdF7H24SxxNX4wShFCpcab9h2YJ4wujSby4F3aEB5JpsBNNbG+Mti7Er7zM56TaZjZjvKMuPS2Egisul+BMEf5B7ztbpeQJHiIZCiPRaIMsT4o3x2ricVgLI1n3zaF9bSlrmKqQQ4RUEUZSq4mEwkuB42RtxruNxNRD7TPdKbpsQ/WMsqRpOT6Lc72FOf9VdmMyHlz9URWyygOu31NUQDnF2zj0JbCu+y4fQY0Jz+0bNsVoFzSxnRtwyeLdohX5CNhNsR7QLHGjqNcgosx+zlasN6Z+LMMPVl0dLFygYkNw3hNbrAjBgPH2XV9mXs76OrL/e6ZRgi+qUO7fDmV0kjJIrs7oI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(71200400001)(316002)(8676002)(186003)(26005)(9686003)(7416002)(55016002)(6506007)(8936002)(6916009)(52536014)(7696005)(86362001)(478600001)(38100700002)(122000001)(54906003)(4326008)(5660300002)(66446008)(66946007)(76116006)(66476007)(66556008)(64756008)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jTwFziYnSYs+wIebsoy3h8a1TCQPrNBYS4zsjv6tbLTcv7s6UvKsvE76NrYW?=
 =?us-ascii?Q?J597gfc6K5mmnTY4a9VzwLL0P3gAWOPUKcojDNa7x4I0/KD9A9Dci2v/ReHO?=
 =?us-ascii?Q?TyIXaM66cWKxwsCzFznJNHGOW33BhGfXShwytmIfPaP6N7dlTxKpQKm0nLPt?=
 =?us-ascii?Q?qhMiTuJvk0PAJKqzSooq4T3kp8b+NuvjWGk3T/wHG6+bf9vwGPpn3EixWnLn?=
 =?us-ascii?Q?Ko4dmEZeKTXMSgXMV9dstzYSgvw5cCuhMRPjohHUcQwL2jo6s4Vnc2+lUFI7?=
 =?us-ascii?Q?51viVjx3rKvxm2jfHMy3a6dUnRg8Xlk8ZpNZ5LqcIeNu4nNQ84iqmflVn9Nm?=
 =?us-ascii?Q?n+aCYG4Kq8d8l69wIz6IhcBqrpVJUCN031c99/j2fy+wKPKbva0QA4Ku7eQH?=
 =?us-ascii?Q?xvtLCNbJ5F1D9AEP1JLld1n7+djm6HK6UUgyDiR8GWSZ8xS1s/YIPk9CanMS?=
 =?us-ascii?Q?Y0ftTnM+z0+w+XQUe0ndOA6xFHDS+ZEnkBVpeEIWTXy4iEFG0hRHbiur849E?=
 =?us-ascii?Q?zBoUdQiM0hVSwc9tUmYPBhgOsDi27e/xfYYY5lHU1wUDl7kG0f6OZ7vIjoD6?=
 =?us-ascii?Q?EEepEGR42RqssCotJZaCq+GJnawTu/zWNvMqseiGpZBCLlIi0Nk99ua8RU9c?=
 =?us-ascii?Q?QzZl2T7kNKKsy4bwWAwjysTs3c10JK3mdar2Cv9Pbk3T9OxYBLh9hgllyLs6?=
 =?us-ascii?Q?950FIvnzJwfBEI4MX9P0wyMhsSie8iYTtkBUL0NjZG0NWMSJEBTj2nbZS5oN?=
 =?us-ascii?Q?oDzxxrO8lUFYsFCPzeYnZGmo0EcvujRo9ICPFEBW94HloLPRHqpTvRvPxJCP?=
 =?us-ascii?Q?Njrjps5r76aehrsSI/CYw7xXn/oFZWDpY8Z/aQz9UPRyw3sc53sP9Qn9f9iO?=
 =?us-ascii?Q?6VkEHB7GDL0wy6gj+uPPblUsprlz72aK0gby2pV0uazmhc+0EhHfVbbMMmij?=
 =?us-ascii?Q?nT7yRZj201wGGpBNGh/Z+aleaTVcQsAv2ClRcETJALgrv6IBHy9P0njKvrYe?=
 =?us-ascii?Q?kqbWSaXtNuNG7T5nOnd0heT6mA8KcsdVvwQLkNOTHyf9w5Rze47hlKzhD61A?=
 =?us-ascii?Q?Hl+KHOMV2L1OMVJ2Y+MABsCep60wul2Gd8KXZoX5gu9SrrngF8TQBJqHqOht?=
 =?us-ascii?Q?sNREgYkYpeDYA5oF1uOJEhBDrXz9FAXFDXSoRk3261O/F/Fn1k3kE47kQVS0?=
 =?us-ascii?Q?i50SGOw/t+Rz3D/yWWzv0MRnYjTFip2vtHMZwZdb/px+b+vkUq79cK4T61uQ?=
 =?us-ascii?Q?HIzGqnFEmh2Ev4u/xiymlDDlwBjkQZ1BXhpm9+dbJZrQjccvRtKC2YXO23NM?=
 =?us-ascii?Q?PITWI5o+KA9V4s0pT5MtWBPC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f64648c0-1d0d-43df-7ddf-08d930593111
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2021 23:56:28.2328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YBbcAGKe1b4pnXMnC1JTtCVVIq6XEYlzPpjhDrY0B6M93oHMtWwC/zkHtKHnsOD9NYKbGhMwoLB/Od8fl2ekVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4521
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, June 16, 2021 7:41 AM
>=20
> On Tue, Jun 15, 2021 at 11:09:37PM +0000, Tian, Kevin wrote:
>=20
> > which information can you elaborate? This is the area which I'm not
> > familiar with thus would appreciate if you can help explain how this
> > bus specific information is utilized within the attach function or
> > sometime later.
>=20
> This is the idea that the device driver needs to specify which bus
> specific protocol it uses to issue DMA's when it attaches itself to an
> IOASID. For PCI:

What about defining some general attributes instead of asking iommu
fd to understand those bus specific detail?

>=20
> - Normal RID DMA

this is struct device pointer

> - PASID DMA

this is PASID or SSID which is understood by underlying iommu driver

> - ENQCMD triggered PASID DMA

from iommu p.o.v there is no difference from last one. In v2 the device
driver just needs to communicate the PASID virtualization policy at
device binding time, e.g.  whether vPASID is allowed, if yes whether
vPASID must be registered to the kernel, if via kernel whether per-RID
vs. global, etc. This policy is then conveyed to userspace via device=20
capability query interface via iommu fd.

> - ATS/PRI enabled or not

Just a generic support I/O page fault or not

>=20
> And maybe more. Eg CXL has some other operating modes, I think
>=20
> The device knows what it is going to do, we need to convey that to the
> IOMMU layer so it is prepared properly.
>=20

Yes, but it's not necessarily to have iommu fd understand bus specific
attributes. In the end when /dev/iommu uAPI calls iommu layer interface,
it's all bus agnostic.=20

Thanks
Kevin
