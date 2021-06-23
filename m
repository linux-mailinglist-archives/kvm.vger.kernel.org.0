Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8E23B15B7
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 10:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhFWIWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 04:22:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:58364 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229929AbhFWIWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 04:22:11 -0400
IronPort-SDR: oNHpvvzF6tRn1hGzBzhSzTcbLCSR9QkX8Zio9W/dYQB2gUl1k4Pi08RYCWemIMeW3Q+lBzqsVE
 C/hwcdfpu4EQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="187600807"
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="187600807"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 01:19:44 -0700
IronPort-SDR: pe0VRQ33/4QRSr3cl3RVGleYMoEC/jYroZ4q5bVM2BQVA/CsV5FmoAg95eTUrXllJsHvlzLZ1k
 IWfrw4Tuzv1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="454569299"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jun 2021 01:19:43 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 01:19:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 23 Jun 2021 01:19:43 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 23 Jun 2021 01:19:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzoPeR0mq3Hx06/+tN/AeOSGIGia8k05uqJbec7592IGmwlr2dasIHz9nnHtK24YS4etqzv8DyVMWbwZUszlMvQjKPyYOvmnDK1OCJ+9N3J4PcGeHTgPGqv13414QyRSm4buvtYoGQ72FbLJZj9mb3SqQCwUo/jceoA5LTA9OHcFmF2Wl0/J0Hw2fCbK8G5Z1HHSdincuYH9F69wrdqL/Vv7NZTG6GmDX4xag1mIZwVllEQSX0puX5zkF/0VPfW6ilUXUBvk2WD/QEIQE1isyi1aVRB5dj3mLOzwR7SrqCEQl7GcuiqJXH1mNRAx44vqiAHYpDE3rSDcxhs8+44mXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQtJJPSi2L/YfMVaVtdQES5mPbIYV2GLMgkxMrPnrRI=;
 b=YzhUsjw0uakh5E8vXUmDuLJLCKlHAS31550g9F/sJ+O4r/EniWCpQ9kgo3ZdNW6mwwUuvAakFm6PHTnxCZCjNvpBtfbdqSjYXM3YpT/MFRQIdRQy+BoLkE1VNWGpQCaw2v9N4sevP3V2wfGNDkF9I+TDcT3ms8AtZihOZJwMeJ54pExPSi4yrvaIPp1HD0YePE3Nqh6gRtBedDzdxiACIdgGWUCwIzb0jd8pzsHNkaTLEzRvUs6Ra2Vf8MVg8xLR+aHPmxyqKQQn3n4UGnLOFl8AQEaDqLdbEFggIp9530Rlt6rmsoiNPF6CcZz8UzdR9AbvG93qGt5uIbEcMkaB1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQtJJPSi2L/YfMVaVtdQES5mPbIYV2GLMgkxMrPnrRI=;
 b=LW+1DOIY5+/Qnq97mCWQ0EueEHvXfZcoBz6b8dDJh/Obby8oidDJjQ389AP9QunSIN1TNGHCarYETG8YpCBrL9Ou7pcKKGOvypcNajZJtD0Scl97o5p1G3tHAGKJDylD4+C+qNHjG/TSb4ol45MEagjqwHdMfhh6WhKBGq5aVsA=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1520.namprd11.prod.outlook.com (2603:10b6:301:b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Wed, 23 Jun
 2021 08:19:41 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4242.024; Wed, 23 Jun
 2021 08:19:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     David Gibson <david@gibson.dropbear.id.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
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
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ97BhCb3gd8AUyldaDZ6yOMNABLsqGAAN/dRYAAFU5FAAAaxTKAADwI6AAAwQ1+AAB5vHCAAUN/JAAAT74kgAADDUUAAOVz9OA=
Date:   Wed, 23 Jun 2021 08:19:40 +0000
Message-ID: <MWHPR11MB1886854A9D8CB0C8DD9A156F8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com> <YLcpw5Kx61L7TVmR@yekko>
 <20210602165838.GA1002214@nvidia.com> <YLhsZRc72aIMZajz@yekko>
 <YLn/SJtzuJopSO2x@myrica> <YL8O1pAlg1jtHudn@yekko> <YMI/yynDsX/aaG8T@myrica>
 <YMq6voIhXt7guI+W@yekko> <YMzR46luaG7hXsJi@myrica>
 <20210618183054.GK1002214@nvidia.com>
In-Reply-To: <20210618183054.GK1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.143.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ce49a85-44cf-4ee5-b117-08d9361fa637
x-ms-traffictypediagnostic: MWHPR11MB1520:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB152076F4C144C89787D554F78C089@MWHPR11MB1520.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HCNp4SEd0OUywfzYLJ7zMqpz2+UeHaPMfRFUz+r8UoO9mX1KsSXAwgYH6lCG90vFeMWWfIwZX3xv3CqWneFDl2gI1p0ojZQEIRaysyAObGcS9oQemZloAqYoNZ/XjfI4smddGw4DOjuWiYXNF/moeDY6heC5pIpte+zBGU9VFmyyruDWFxAXovWIz0zjSmc/LqfbdmRhCWwcnXL3UWzb18aXeyz2aI9/yPtU2VDB/GeOsctw558e3Utdc3fCx1dY3dmUW+A7rYrUAG8MP8QYy5PllZ/1DestO2GJaEw/YQqXa4eSSg9j7BuqdazxyR+doq+YYEOe0YQp14gknIQtjC6JoippOzXTI29dqwPUvM3TDF/tdUTRpmrLW2ej1Wx1Mb5I7pzCHq+j1D/iURyfRBAA8RH23ZjO9kbRHk8tiXYW6tdTkZb+rtte7w+wgT5hjgmBQpUfqvYKBRIR8rrFX9ivZF7/mOA5aAQnKU15LELSdPjW36VU2rOUaseeSF0o1vSYyxvARhx7FXco8u9I1LPMQ/wpPj7RJuuJnnpoECoGMBNbIiK4UMk8etljXR5Z/ysRbT8OUDLcK3rWIynClH9vZC6RcKOfKQzF+yrAAWcErUwfXYk8WZu4iRogntA/SUcddhFThzKoHfbbFUVidg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(39860400002)(376002)(396003)(66556008)(66476007)(66446008)(66946007)(64756008)(26005)(33656002)(186003)(76116006)(2906002)(52536014)(8936002)(6506007)(478600001)(7416002)(83380400001)(38100700002)(122000001)(54906003)(110136005)(71200400001)(86362001)(55016002)(4326008)(7696005)(5660300002)(8676002)(9686003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pERLwujITI5U1koa+/Vu4qApzT5IxU8tclK8H9msea+XmZ4mrf2LbOnqsQOP?=
 =?us-ascii?Q?e+76wucUF9Xq7dpvu6xc4H+Zgbp5L+D6k5sotr/cKVUzvMiLInEebCN36CZQ?=
 =?us-ascii?Q?rhcyBG/kNC+e9olib6i/0Oe7rpWmaGFklOCKHUxBQMUEp8YEHgGFRX1IwO/S?=
 =?us-ascii?Q?2gNPRE1HfBcIZeBlRnKur1ZtsNyHaNiW78gcnDdArHI8W0CANN0QS2E/yiPC?=
 =?us-ascii?Q?LS6Klf4MZl4EYEanydjitnuILqZArDHx6NiDmQD5DCzDoAMkaoiIDakPh0fn?=
 =?us-ascii?Q?bO7HUdQMhQJF6otkhcmB4ES7/wcVW7vA+yMhm+HpYg0fjfeW9aAn+Kz6idqv?=
 =?us-ascii?Q?CSdsD6Ew6F/TANNJo7LJvzR34ErMS0PS7maLcOziPQ/NbUri8BWNhx2BEq1d?=
 =?us-ascii?Q?qoeyRAR5w+f+etSDmZ04+CQjKWsrJoKiqiC+CIC1YKdkc+vip37EodZpXfCq?=
 =?us-ascii?Q?9/f86r9Xrs7nrRsT3T1VfAYhFt3MHrPm21cYXA6s9uZIKJIQJwTzbbYkhySM?=
 =?us-ascii?Q?K5Y1guLZWvUPPU8oYdg2vgKSMmcu8vCniUYggvKtRFdNDSTb4UkuUXBRHc1P?=
 =?us-ascii?Q?IFWjrcMHg/ruYR87CNBU4Pj2qifQumY8/npYRyzB9ODu53jopvYKnPTvK33X?=
 =?us-ascii?Q?W46T7JlS1xHaQJPv8T5z5Sn/UyWpccx3rPbWyyWVZPZcJ2Q4bHBjzuAv89f5?=
 =?us-ascii?Q?KZmVIJBC0B4JwT6dLR2OqOkeHQvBx1cARM1tUhM2c9BYehHXGzP2g+QdsptS?=
 =?us-ascii?Q?Kl9m1hx/94g7R/+2RPqIFlcwDeSU8sSrLJJ6uG3mDSqvly85xVHbAK7inWqj?=
 =?us-ascii?Q?wqcgksYeRCx1lcD9qwt/COSSjWjv61rDI7tAYs38TTf1YzOz1U7VLr5Z1fNo?=
 =?us-ascii?Q?dyYqadzFfNjfs2eyOKqQtPZBv9KOQDmGj2Fj3Gi9LVZyOc1/5CGFkfQGUa/f?=
 =?us-ascii?Q?MKH6rjJsjebY0VUwtV0uujCLKXtiCTrvoOUB7b0MVFDH5nt252q7Kl6FY8bP?=
 =?us-ascii?Q?2BEntXsCrgh1m1ks2EJ0H9GubITLbkzW/nnu9IRNq0bWl9JbshkQCOmNi4fn?=
 =?us-ascii?Q?RPWmB8kwvf+Mb1HMcsPu8mCg4njeG6Lhphm1hKH6AXlwYLe3C2wIMJ3H7LBb?=
 =?us-ascii?Q?rg2o3q9t/5Ww/EG6UHZ0WCJYJFkF9Dgy7JVb/7l06ne8KmFEjoPlGuhnklEn?=
 =?us-ascii?Q?Ib5DX1PNErU3wTNBftuYgkidWX04trlWaoXWqItGTlDrbftH+OAnPxB4ps6Z?=
 =?us-ascii?Q?ab0iRXESeQ/YqwbrMm4j86PiP/HAjGtKqRm679G3Ot2tkM+K537C8o/BUnuT?=
 =?us-ascii?Q?pWgX6SZEuUGXnnI6188YnVz1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce49a85-44cf-4ee5-b117-08d9361fa637
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2021 08:19:40.8550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uK1zzI4yf29/QiW7det7duXHaGa91Zr+L8H4R5UOIwoVniuY5LHtvQawLhGq7lRxLZxre+0jq1ASsPsqpJgm2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1520
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, June 19, 2021 2:31 AM
>=20
> On Fri, Jun 18, 2021 at 07:03:31PM +0200, Jean-Philippe Brucker wrote:
>=20
> > configuration. The Arm SMMUs have a lot of small features that
> > implementations can mix and match and that a user shouldn't have to car=
e
> > about, and there are lots of different implementations by various
> > vendors.
>=20
> This is really something to think about carefully in this RFC - I do
> have a guess that a 'HW specific' channel is going to be useful here.

Agree.

>=20
> If the goal is for qemu to provide all these fiddly things and they
> cannot be SW emulated, then direct access to the fiddly HW native
> stuff is possibly necessary.
>=20
> We've kind of seen this mistake in DRM and RDMA
> historically. Attempting to generalize too early, or generalize
> something that is really a one off. Better for everyone to just keep
> it as a one off.
>=20

Yes. Except some generic info (e.g. addr_width), most format info can=20
be exposed via a vendor specific data union region. There is no need=20
to define those vendor bits explicitly in the uAPI. Kernel IOMMU driver=20
and vIOMMU emulation logic know how to interpret them.=20

Take VT-d for example, all format/cap info are carried in two registers
(cap_reg and ecap_reg) thus two u64 fields are sufficient...=20

Thanks
Kevin
