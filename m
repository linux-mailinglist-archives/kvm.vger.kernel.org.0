Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CC83A8C24
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 00:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhFOXBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 19:01:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:15447 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbhFOXBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 19:01:14 -0400
IronPort-SDR: +8/jSYjLkhupzhzz4G6l+HTC1wQGpOSjfJeeyh4hNIZY+dqejjh2+i5Y8f+f5kAVgW59eWHpAE
 rli53Nr9bDxQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="227566477"
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="227566477"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 15:59:09 -0700
IronPort-SDR: JXvR4/83KixOWKKZTPv7+BD3IQAS7CYEL0uzdCxoJ+YEpPRtSO4F+KA6xQZPYrsSXanduDSZTP
 RRo8Zh75SxNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="415533770"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga007.fm.intel.com with ESMTP; 15 Jun 2021 15:59:09 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 15 Jun 2021 15:59:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 15 Jun 2021 15:59:09 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 15 Jun 2021 15:59:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUOIfXl9kZMac9qLesPo05K9goIW42+Yfl8FR2n4qYrJp5ljKVR2E2WqBcE9O8jMabldq6tJBaSgAzYRprT5ZBw7lqpwCCqWd9EZGRDIREih0nYYuwIALMQbXHtHf3hUyZgPdAgz2u02Wc998wFF8J1lyEVgQoz9Ysicc8r463aPN0g8q6ZgtLR97wbDjSkxUWc8PMnk7MbpOE6BpLfOE5g4XzyDOi3mzwV/Y+Httn9x1g6gzN9nMs7oGRjTMKeWzUNF1aIFdtDpf3umpNfXzEITqFXeKd4byHIOur3wcAdILvULLvnUjUczXc8VllDY+2v/UjMQuSmFCfSWVbInKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+hUizCaq/ExP3GnSdv4BWfea+q+IG7mtWZ/a3DeAG0=;
 b=VInDdF9cellnnq7vtJ8cPrlc2PpUtXVQAtxZsyqgxHnpGm5I9i3whqjwgpi6vuJLTqgrdtTOvxYh+w4dsCRiWw64iFPn5U4BJcePfxS7mjvEw+hCnmtsxvlg4hZfFnifeoBkhrdx5KHubul209XqdxwraMrivNa65htXN4JtmGuEg8YufV7n8oHWc05fW1Qk4ZdYxuoFr0s0cKRXaLcM26wnlXQUcocMsLxNTASRLqcUSmDT9NGCRbP5CtgBjMpP0Uy+QfXi5Lk0ft4ZFDmyblLQaJ1qG46RQU9ubXx+tzp+FC7Rx72SLVB9mNR2QjBR2MMCzoO84+saZWUg2T2TKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+hUizCaq/ExP3GnSdv4BWfea+q+IG7mtWZ/a3DeAG0=;
 b=J7ODMpD+KijSgtX3YRxIUWh4FnBfF0jc9m7qNOjcoGtY4a0mfWY1DUc0ffu+l5jszfVmr81RbIhtBzEY+d3DGVMbE4gPUlM+4OnY+aHPYtU++GcFxfiPmc8virZIsyMXzucBJjUmNxrKAWylQexIiHquRqNA8mhzhMKaideNX2c=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4571.namprd11.prod.outlook.com (2603:10b6:303:59::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 15 Jun
 2021 22:59:07 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4219.025; Tue, 15 Jun
 2021 22:59:06 +0000
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
Thread-Index: AddSzQ97BhCb3gd8AUyldaDZ6yOMNABTUTCAAQiuDaAADwOFgAJSmyVgAA0fjwAAEFKEEA==
Date:   Tue, 15 Jun 2021 22:59:06 +0000
Message-ID: <MWHPR11MB1886E9553A5054DF7D51F27D8C309@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
 <MWHPR11MB188621A9D1181A414D5491198C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603130519.GY1002214@nvidia.com>
 <MWHPR11MB1886BA2258AFD92D5249AC488C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615150630.GS1002214@nvidia.com>
In-Reply-To: <20210615150630.GS1002214@nvidia.com>
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
x-ms-office365-filtering-correlation-id: a1bcb4be-ee64-42a5-209e-08d930512de2
x-ms-traffictypediagnostic: MW3PR11MB4571:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4571A3788B175F6925822DA08C309@MW3PR11MB4571.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uxfB8D1J3fz9R0KxSya9Y98znAaxZ4UitOgMVVucxAeXF8WvGkqVSpZu2PgQAW6LYQ2hLUebnpoXLqAejWvhg3wc8kDmAk1C8bWYQa2ZjLnJeGvaTVpsx4TAe295HZbE5FBMrudbpIzqDeR8nEZtgs2K1cnZQtEjAPHbIUxSA8be7+GuFPO6/7nh9Pg++fIcYs3xUOR/OqFxiXD/eQtX7mAqW5owd9CZHY8bGkufM8WxsysPFaidzrcBFumfHFbnobag/EohoK96ZUaE0Ua3pAsU+dDdpI7u4B4WISCHKXS9kOIHnTolUmVtMDiAlxRT/bZAsujiJTOPZWgfBsHWjSvpA9FzMunr5wc8SX8/imUqFaoIIm9z00Te1NlvTP3Aaty4VNyW3rE2tbitSL2dd6yArDWq4eY/YyIXGf0mAlUigdpSO6M3i0LRK9+k51HOziRZw+rBWw/u8Ti/Nn8jBUFfxnNXBNPfozoJHKaxR0fPJid/qHRnsBFUDNox6Hi2pLSWrqutH/4xaRE6b9DPDjNxWOjaG3UrDmYf8VEIoZexkfovFQPGUhYiL8yrOSQpvFLpcXS0Wp15GefmgqkWKE7u4TYoRtJ5TgYZkFMzNKQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(136003)(366004)(346002)(83380400001)(38100700002)(6506007)(186003)(478600001)(55016002)(316002)(122000001)(54906003)(26005)(7696005)(6916009)(66946007)(5660300002)(9686003)(2906002)(86362001)(7416002)(66446008)(4326008)(76116006)(66556008)(64756008)(66476007)(71200400001)(52536014)(33656002)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2v5tIACr1uIYKMxTGBjs1cmS5HoLvy3YDv2uCMIo5c1h1dcUvsltwH0ODUs1?=
 =?us-ascii?Q?EnksDCIZPupNgfksPes/sX7dZC3EeEPFTHEqBFTyUrmMcnHZ3acv04Llp/Uc?=
 =?us-ascii?Q?cvga06E2Bq7LxrxzyTrZwWZQuwdQnP0fTDaK3CQIbYpmL/KYZuIfg1Gx7Rmj?=
 =?us-ascii?Q?XcjETWy+ZOk/Q38FzgtlE9jjYi84L7jUxS+1Rbk6529M+e6LUBZW/0MXooO0?=
 =?us-ascii?Q?CWwQK3xxSbIlopz4KsjtPG4xjv4hB8Tl7W4MKjsK/vWiFpefamsSxBcIzL0Q?=
 =?us-ascii?Q?kxDXibDad95gay9a2AQ9iM2C9fVIf4Ftg2W2OCVEE/8PB++Dkk487AnnoChI?=
 =?us-ascii?Q?OQvoaKyBkyU4QJ8q0PUwxB/fUIKynBdn4i5DxW12pT1eb4k8iHkmdGEEUXVV?=
 =?us-ascii?Q?vxVIS/JdyrbnHyXdWpWdYCZru7omJJHceG1InGVCMT0Asl6uxz11nN1+gFks?=
 =?us-ascii?Q?XW0dqZ+Urc5S8y+hGP7vJNprTruca1Et7Z0v/Hr8I2VuQgwSbcfZ2neUUW57?=
 =?us-ascii?Q?8hkT8C0r+N7yzqstzl3yf0tgzER5RaN3rBaBiGoSFwcucyaRnoLa07Dl9LFI?=
 =?us-ascii?Q?H4S19y7HdpfYJjhqO3GX+SP8PTcWmaSE0qkoLWIVg3qfiJFuCbSqEc0h9wJt?=
 =?us-ascii?Q?hGQLtKJ157y/JoYxpxzHRboNqWn84v9Jr6zRA4yqQx2IuZXBEnDcDFyom/FO?=
 =?us-ascii?Q?kYpPpQtukre3p8i6rMreBHY0U1HIE5sa/b+2AeUNXDHrj2AMvuyxEGSdIAF8?=
 =?us-ascii?Q?IsvZV+Isjc3wJT9qrLr5kVZaeob2HvPVY8x1cgdAXpWYWsCq+eVYbQvj5wQY?=
 =?us-ascii?Q?SuLuxNT8T/xd4Mp2i8dsvMDZ6jzZW43NkpxCemC/F0qjmgoZViDLR3+SfSTt?=
 =?us-ascii?Q?Zkk1zhx9sbc4v1IbNglYH4EZQ1joj0LEi/8Z5+nPCCsrk0gErXUWeacpCiG0?=
 =?us-ascii?Q?RbGvAS13H5D6CXtrkMa2Tkr+gQ3rOxq1SgNSqclIonvJXmlZaVGFB60uD2kS?=
 =?us-ascii?Q?8ahPs1HhsHy3g6Dkbqdk6K0V3M9zPGO2BQ64oDGm2sO8lXw8lSCTRJo0HIMZ?=
 =?us-ascii?Q?94nGKMJCGV3DWh9mHU6JaTj1qmuPmg4a1+MA/sUloPyS875rAcj8UwV37K1X?=
 =?us-ascii?Q?60dEUnIBwxutdlBBaXdB6MDB8Axzk/xckNCejImeUyIkqeHMzN/d7H6s7cio?=
 =?us-ascii?Q?V+twrvdJUHZZkoihM0jbhGGhm3AzFVms3FYmALKjzgbjeemh2HJ1MHsPRhEY?=
 =?us-ascii?Q?7bOnAHeTn3zqmT6+MigABdfZsl944bLSJjP5qki8cZ0Gu6wEJJ/cWJnfTkko?=
 =?us-ascii?Q?bvTEzag0Ui8N5wind1lmoQdU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1bcb4be-ee64-42a5-209e-08d930512de2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2021 22:59:06.8594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EUcTzwWlHb7wsG48O1W75Yb5a3hCz9hIFQeCBb3DfQj+HnSbi5OtkouSerQGnKNSUBfoKgSE624/60BpdVNK7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4571
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, June 15, 2021 11:07 PM
>=20
> On Tue, Jun 15, 2021 at 08:59:25AM +0000, Tian, Kevin wrote:
> > Hi, Jason,
> >
> > > From: Jason Gunthorpe
> > > Sent: Thursday, June 3, 2021 9:05 PM
> > >
> > > On Thu, Jun 03, 2021 at 06:39:30AM +0000, Tian, Kevin wrote:
> > > > > > Two helper functions are provided to support VFIO_ATTACH_IOASID=
:
> > > > > >
> > > > > > 	struct attach_info {
> > > > > > 		u32	ioasid;
> > > > > > 		// If valid, the PASID to be used physically
> > > > > > 		u32	pasid;
> > > > > > 	};
> > > > > > 	int ioasid_device_attach(struct ioasid_dev *dev,
> > > > > > 		struct attach_info info);
> > > > > > 	int ioasid_device_detach(struct ioasid_dev *dev, u32 ioasid);
> > > > >
> > > > > Honestly, I still prefer this to be highly explicit as this is wh=
ere
> > > > > all device driver authors get invovled:
> > > > >
> > > > > ioasid_pci_device_attach(struct pci_device *pdev, struct ioasid_d=
ev
> *dev,
> > > > > u32 ioasid);
> > > > > ioasid_pci_device_pasid_attach(struct pci_device *pdev, u32
> > > *physical_pasid,
> > > > > struct ioasid_dev *dev, u32 ioasid);
> > > >
> > > > Then better naming it as pci_device_attach_ioasid since the 1st
> parameter
> > > > is struct pci_device?
> > >
> > > No, the leading tag indicates the API's primary subystem, in this cas=
e
> > > it is iommu (and if you prefer list the iommu related arguments first=
)
> > >
> >
> > I have a question on this suggestion when working on v2.
> >
> > Within IOMMU fd it uses only the generic struct device pointer, which
> > is already saved in struct ioasid_dev at device bind time:
> >
> > 	struct ioasid_dev *ioasid_register_device(struct ioasid_ctx *ctx,
> > 		struct device *device, u64 device_label);
> >
> > What does this additional struct pci_device bring when it's specified i=
n
> > the attach call? If we save it in attach_data, at which point will it b=
e
> > used or checked?
>=20
> The above was for attaching to an ioasid not the register path

Yes, I know. and this is my question. When receiving a struct pci_device
at attach time, what should IOMMU fd do with it? Just verify whether=20
pci_device->device is same as ioasid_dev->device? if saving it to per-devic=
e
attach data under ioasid then when will it be further used?

I feel once ioasid_dev is returned in the register path, following operatio=
ns
(unregister, attach, detach) just uses ioasid_dev as the main object.

>=20
> You should call 'device_label' 'device_cookie' if it is a user
> provided u64
>=20

will do.

Thanks
Kevin
