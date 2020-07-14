Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602A121EDAF
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 12:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgGNKMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 06:12:54 -0400
Received: from mga04.intel.com ([192.55.52.120]:5072 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgGNKMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 06:12:53 -0400
IronPort-SDR: sZ1ybuOJyUAC8gP5kUej4GnrmqeB/cWW6N2DhNFGtmO7CPQV1YWzWmKCNTNLMZ6qeE/9DP1tx/
 FEsXnIwj67ZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="146338849"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="146338849"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 03:12:52 -0700
IronPort-SDR: AX08XsjGxE2Z7stKMtgs3whgCDfVNWV+h68M4joWz+7DPCAR9/zPy445jWA2W5ZkFX9Z49jO5N
 Y7SFkLbkLcIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="324502807"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Jul 2020 03:12:52 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 03:12:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 03:12:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3wuaWb8Zm6k2nKfJf9Qr0Amn+f+zXGPP9HixOG5BDnrHize6g3+7IWIJlr7WMS2Sf6ytWMkHoFhxK6tAoDwxp/XMQ6fCBQCThvUmoSZ6XVLrcSqLUrzRMwQOibDrV9fuApfvQifjFBc4IohKKox7ilgsrdp5CqookpILGlzngROKiRUsRhY8qD204Dp3vaLKXh7dydzbkazKl3FTcxdCWnXkF9Qm0MHkmoqyQgAMTVCmLGvzivZouNzC3rwAd8BOD6WZc8jmZ5ItHzap9v/GOk+Mm3fcPn1Ai1+QtWHyijePYsA21fC54tsj3UjbJBqdG/mGCx1Ot7dT0hRaxUG3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdpXGoK+FFwCBETKvGnURfFxSXfOgV3MDhKEhxgETnQ=;
 b=e+3JelzhsWCDtFSgeyJMrKKEV9xnfG6GDwkQTrMsg0y9J2t7ANCRTTJr4Fa8HxAGjkyfK756sTk2GF2cZd6P/FaFD+sIWXcqT84luFTsnPLSB7jP3r7GQCqFtkFb/bbAPbPw7QWiB4LVBObBEvuOHfLl21Ts7Hup54dc2NWgtDKiUAaG4uS9SREBfu/KlD91YX4lyi91zluzsbe40aX6J1ty95yCmKfJildU2yPgTUOFjY4VSAYr7qimuG4R02Zka6CL7eo5XzIi9YpXtgmCP8SVGxxVVGXamrEuxasML46EguJUAZRchsz/4dbIV52P0Y9tFsDAERXo5o/ry+p/Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdpXGoK+FFwCBETKvGnURfFxSXfOgV3MDhKEhxgETnQ=;
 b=xloR6YC+GGockon40kMndkrh3izdFAEbuU5Q4DEy4VpXjC5Pc+pUx5KiwmulqQA2J4HwVyekjLWggLhAd+rImg1zngCGu2FNxIRPtb9Z4hCLP3Oul0M9KTE791ER3Avhs92SWDHxYzXmbPDNaRlDrrf91Hc6QbpVm+IOA2Q75wA=
Received: from CY4PR11MB1432.namprd11.prod.outlook.com (2603:10b6:910:5::22)
 by CY4PR11MB1702.namprd11.prod.outlook.com (2603:10b6:903:2e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Tue, 14 Jul
 2020 10:12:49 +0000
Received: from CY4PR11MB1432.namprd11.prod.outlook.com
 ([fe80::b46e:9dcb:b46b:884a]) by CY4PR11MB1432.namprd11.prod.outlook.com
 ([fe80::b46e:9dcb:b46b:884a%4]) with mapi id 15.20.3174.026; Tue, 14 Jul 2020
 10:12:49 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Will Deacon <will@kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
Thread-Topic: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
Thread-Index: AQHWWD2lVc+q/avNRU2WMQZyTvsTFakFfrYAgAFdguA=
Date:   Tue, 14 Jul 2020 10:12:49 +0000
Message-ID: <CY4PR11MB1432226D0A52D099249E95A0C3610@CY4PR11MB1432.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-4-git-send-email-yi.l.liu@intel.com>
 <20200713131454.GA2739@willie-the-truck>
In-Reply-To: <20200713131454.GA2739@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.220]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb8a1c13-c6f7-453e-9d53-08d827de7699
x-ms-traffictypediagnostic: CY4PR11MB1702:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB17020A1F401752EEA24CAC0EC3610@CY4PR11MB1702.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: umtRxVfMVBzbhzjE34Rju7JgPpc+tA2fo2GCNWL1SdSgEAKNZPo+hibN1ziO3IBVUkJtFsAvqksRWHVt/e1VNy5+56oRORFhlCiTIytend6R2mXBAiIWT2Zh82SeeVwjxfDFr0GBcp0wsie+3ZJUT6PKToylWM4IwJSPQ04mKcSeMWcOdtc7kmga44DCb+Ku8A8JsayQcj3/EGWygdKRRN8midW800ldntV9uE94OZtKdkQZb29iBSV92WGBTS9KQXj480iN0leJcp0liZprjTYAAEULtA6qRBEw991GLyehQdLtPauRTQHk6MA69zdJJVyOyrTsSoHf8MMj7o9gzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1432.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(2906002)(9686003)(33656002)(8936002)(52536014)(7696005)(66556008)(66476007)(64756008)(66446008)(76116006)(6916009)(66946007)(478600001)(55016002)(83380400001)(6506007)(54906003)(316002)(5660300002)(186003)(26005)(4326008)(8676002)(7416002)(86362001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: LutDe3Nn90BwVYEuHMm3VUcexDXDUAM+OqPrXtUGNRPRyq3YFrjK2YsYlLHBZolueRfL4Z+wQl3mJ+HaGzA0tef0v13Sk6mXRHP/Mid4X/KgosvQtFOEjZF+BT53uEZOTebmDsYsj1eMPe2pwUtoEKSu8c5uCfJIaFyggaq16wLNNLtSF01rgOmx5tU2f8CDMFar8wv5OvSsq4PVOKo5pd9lvKTafYkMOixKm7UCQfs6QQtnJvol54m7dVAEIxkUguhllFDY6uFm4/dYEMKp1ACt9aN/5+G00X0IkBmqNUwh3GXUv+8yXHyEanMX2JfR/LpQYnY+Yxn+uHBgBoYgRde0vNJW1bmNVxmuAGrME6OViX8mDDrlDKswbbeoDJFlL5GiqLhVLXPobt/xMh97mmBWFFajGAH2DYHXzAyTQCNe8NvRj8YHhqJkyXSRR4T+P1wQbNZP7ed3+/Lukd2r8KLfl/mIss73p+pKJVyCLIlJ2QyoLnA8o/29y3Vl90Se
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1432.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb8a1c13-c6f7-453e-9d53-08d827de7699
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 10:12:49.7187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2gN0RhdRA/UBYovUmejkc8irzvqmPYkkz3Z5nD3SdQnaOVxZRvzq5cYQlXotpbJkjlgPTjZyNo/xtmynixZYvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1702
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

> From: Will Deacon <will@kernel.org>
> Sent: Monday, July 13, 2020 9:15 PM
>=20
> On Sun, Jul 12, 2020 at 04:20:58AM -0700, Liu Yi L wrote:
> > This patch is added as instead of returning a boolean for DOMAIN_ATTR_N=
ESTING,
> > iommu_domain_get_attr() should return an iommu_nesting_info handle.
> >
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Robin Murphy <robin.murphy@arm.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Suggested-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> > v4 -> v5:
> > *) address comments from Eric Auger.
> > ---
> >  drivers/iommu/arm-smmu-v3.c | 29 +++++++++++++++++++++++++++--
> >  drivers/iommu/arm-smmu.c    | 29 +++++++++++++++++++++++++++--
> >  2 files changed, 54 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> > index f578677..ec815d7 100644
> > --- a/drivers/iommu/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm-smmu-v3.c
> > @@ -3019,6 +3019,32 @@ static struct iommu_group
> *arm_smmu_device_group(struct device *dev)
> >  	return group;
> >  }
> >
> > +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain
> *smmu_domain,
> > +					void *data)
> > +{
> > +	struct iommu_nesting_info *info =3D (struct iommu_nesting_info *)data=
;
> > +	unsigned int size;
> > +
> > +	if (!info || smmu_domain->stage !=3D ARM_SMMU_DOMAIN_NESTED)
> > +		return -ENODEV;
> > +
> > +	size =3D sizeof(struct iommu_nesting_info);
> > +
> > +	/*
> > +	 * if provided buffer size is smaller than expected, should
> > +	 * return 0 and also the expected buffer size to caller.
> > +	 */
> > +	if (info->size < size) {
> > +		info->size =3D size;
> > +		return 0;
> > +	}
> > +
> > +	/* report an empty iommu_nesting_info for now */
> > +	memset(info, 0x0, size);
> > +	info->size =3D size;
> > +	return 0;
> > +}
>=20
> Have you verified that this doesn't break the existing usage of
> DOMAIN_ATTR_NESTING in drivers/vfio/vfio_iommu_type1.c?

I didn't have ARM machine on my hand. But I contacted with Jean
Philippe, he confirmed no compiling issue. I didn't see any code
getting DOMAIN_ATTR_NESTING attr in current drivers/vfio/vfio_iommu_type1.c=
.
What I'm adding is to call iommu_domai_get_attr(, DOMAIN_ATTR_NESTIN)
and won't fail if the iommu_domai_get_attr() returns 0. This patch
returns an empty nesting info for DOMAIN_ATTR_NESTIN and return
value is 0 if no error. So I guess it won't fail nesting for ARM.

@Eric, how about your opinion? your dual-stage vSMMU support may
also share the vfio_iommu_type1.c code.

Regards,
Yi Liu

> Will
