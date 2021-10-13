Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249F642C2AA
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbhJMOSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:18:03 -0400
Received: from mga06.intel.com ([134.134.136.31]:42477 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232587AbhJMOSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:18:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="288308323"
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="288308323"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 07:15:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="491482070"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 13 Oct 2021 07:15:58 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 13 Oct 2021 07:15:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 13 Oct 2021 07:15:58 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 13 Oct 2021 07:15:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnYAyCGBHkTFVvXFspUAnyfnJtD5Ntm9a1cOy510wF4NS9LaAqtOn/91HbI4fCvNwV0easI0rz/wtF3cuget6f7eyVBeBJOJg6/7qoncBRGs6frWJn7rc/gDTBsAYDg1fOfadIZynzp/1LTGVg0YT/Uav++DLsXf/r8gPWUk8hD3cxoKVbu5KqUlzL5zQzaKqIbDkXGAqIONwF/0EG04emyZXq/XS+Np2vrELx2EpoiKe5WyiCQPtYMalCAIFW7/IQniPXANUiTp/bl/79qsEEK77cjFek3Dn1+vOIHXby7SlZXIwnZe5sm7hal8I0CGfvK/V8MJ4u1WNta8xY8DEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8f2YhDEomXu5X5j+FaqeJJLvps67pNalAlhPwu2Fbig=;
 b=JidCuL0T7i6ytirGhPPFtlBDkR+Z4geRn9cn7fpE70Cu24bEmqcYQxQMKE+pXYWNsIw6tBwgrku4Yowdq7oJumFQ1bq0EGfB9JN90JBg0CJWPdtJ5yS8pIgqw9cHinRtMY5+jLQssGnMJskDh3wzndngVaG34jmURdf2mCy14eGm3IgVJd2UOO9pbJScYrWOz8qGr39q7lvwz+Pwo1nAhn0oyWcuuPi3u9IbrV1nHzOOPeEn7WDlakIwYzp2eYe5ty63Vx2Jy4Foif5WeBFItosmJ0d6NHlb5+9h+xhNm8GPqRctWrMG4vFpvVf7gMnzLKj53Zb/uAAaV6DxLYq6hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8f2YhDEomXu5X5j+FaqeJJLvps67pNalAlhPwu2Fbig=;
 b=QguowVmmXawzDuDfju93uAnqPnDTcr+Z/ijuex68G1raybGprWGIW1MX8YphrgPfbEVkVtgNCmawIBAEFINuCIWrgXEBR1vOP6uRAAouo72ph8pSrcUNxOdU1chB/CTqfivFEfV78xn00wDtjWCV0oHF08kKE9Q6Zm1SpD1wWpc=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5675.namprd11.prod.outlook.com (2603:10b6:510:d4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 14:15:54 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 14:15:54 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Thread-Topic: [PATCH 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Thread-Index: AQHXtxtaSyERD8vZ0EK3Th0ISTa6e6vPHdkggAHVbICAABf3UA==
Date:   Wed, 13 Oct 2021 14:15:54 +0000
Message-ID: <PH0PR11MB565819A305CDFA1BF3181F32C3B79@PH0PR11MB5658.namprd11.prod.outlook.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <5-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <PH0PR11MB56589648466D3F7F899F9F5FC3B69@PH0PR11MB5658.namprd11.prod.outlook.com>
 <20211013124921.GB2744544@nvidia.com>
In-Reply-To: <20211013124921.GB2744544@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdcdbe86-eeff-40c3-9f5d-08d98e53f84a
x-ms-traffictypediagnostic: PH0PR11MB5675:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5675A5F6AF5CF365B2696E76C3B79@PH0PR11MB5675.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m+QUedED2tNtUXmpVISzT6zRZv/tQNkETbK4zFdSr1yWDujhnKRoor733ofWvDVryF26IXz4/QS5QsCoVDcZdqAt7Q6jsKbH4Hc4472ToYCdgpoKlEWLNefSx6kHt46SYEXcfHCzFq661Kijp945U2D+w14l7IXEQHqtMyCugnaCqTip5A2B5sNqjliUCIdgFnLmhZTCibwyzvlrtEeH7fpRa2wgGpYaDLMYZni5uANe/ogXKffVA9+lawcgpIF9WDBIDTSDlEG4YSjcnspUFOT1e50G7sRLnwwuV777TEOcdoYkYH24MM67aqCcayX60sJt7dD0IqTnXCO7K9kZ09km0cPMVt9M8pkwTPeo+l41RBAX4c9F6SjFIAv0rFMUVqoOrl019m3FlKIr1mGVkinSSLKpkwSDrpV9tTLwavKlfG9kjpGBAgJMGqVYHvrxoqkORIQNyQmgTc27K18LwFeTa4E/DPhSxV6rF4cRiG0VIHs1+QZrSEyZY224jNDsvT/l3c5P2PwEQZF1WAR9nXjGzl1EePNmqFBUosI9z4oUrxlTCsbvmIwfhLVbtuw53dCXhif7xAN2WjQMriDsF2oZaQE1GhHUIMHa2Idlkv0wcPkMPP10medmQu/ZkcP9QkoiFYsOgEb8ukCgZHBVsbJIQyL37vtla8J1JC+i76Se1FFkL/l6lC2tu9kIjfXuSe2IJLCocR64x6npCkYMpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(2906002)(55016002)(86362001)(508600001)(7696005)(82960400001)(5660300002)(52536014)(54906003)(316002)(6506007)(38100700002)(6916009)(66946007)(38070700005)(64756008)(4326008)(66556008)(66476007)(33656002)(76116006)(66446008)(71200400001)(122000001)(83380400001)(4744005)(26005)(8936002)(8676002)(186003)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GFXAHYl43iAvVSTjcyWyxY4opeMkvL3r8/0+LVDLTdAgyaHKM1bHkMRDwtfk?=
 =?us-ascii?Q?+6MpvmHw+afQJBebxpgf7HGvoTpOs2uV2rtK3r+lTa/dvhPMoDuKLDwusMZZ?=
 =?us-ascii?Q?S1UfP671fURD97smowETVN6+qm+AQ/QEahypidJddfYXsZVxLSq+zHY4fatY?=
 =?us-ascii?Q?+jO3co0fKEsCyBQe+otIqjq4BtjJRP+ll4cVE5pIzHSQNml3VJ29OWOM/+d5?=
 =?us-ascii?Q?PWPnfx/xzQuktoab4MzP+Fr0oVzhkqqpV1x/mhj5yA5t8xz2rOhSTtDXkIQs?=
 =?us-ascii?Q?jjt1hNEtozP059ktOiMiQwHkOLbW9f6Bz+a0maBuZwTaq5afkf9tjyvAuG4N?=
 =?us-ascii?Q?VhsAd36NP4Wr2VCK0v1z1UTwlpTNS5oYzZG30GrATfTtCfvBpBSJZ0hGxzsz?=
 =?us-ascii?Q?ezjzMUkXlEtKX6o0wQLDC58zu/gElmKsWFztCRHWMwk0hN9YgZjz4sEZSg3M?=
 =?us-ascii?Q?Jvy7fQn9AVstOXKhaA21Yz8ycE/4qmcebvatDrLP1rDJITz1bxIFJ25T1sEL?=
 =?us-ascii?Q?wo7G5q6tknTF3sw7dujnzaH39v7nPeq1hzOBMMB4IPx7Z0GLR+WRsAg40iGS?=
 =?us-ascii?Q?GqGbmtRq1/Bb/n7tBusrdLyDzL86XYGnA6/4f4fZbPUve1Xgdbx0s3RGKE/Z?=
 =?us-ascii?Q?AUmo+PptDLmqSMnTUeNwyTOdnLA3MHH2v/Yw8OTMJ+TBevd8Ae7AHWTzsCGX?=
 =?us-ascii?Q?3fYq3Wkfo2W8cBl4uDUS173iLDZ1oAQdSPBGV+Zyu3ewU0hOhbL3XHzs7fzf?=
 =?us-ascii?Q?gqlOZ+tcTAKwK2vvsKgkjuBFcg3RPSB2eZq5sqj0sxFhhMa3laEOqc/31B1C?=
 =?us-ascii?Q?dL/9as7Ce5xr3XsE3MW9kt4FF82gfqqeKR+jsaAvV9rwjwZSOeBVSa5SCPS6?=
 =?us-ascii?Q?86LPfMxke0LLuVBnDGlS3LLsUKM7bPjMkLLsiVxgXDzoPzDxlucr7YCIf1XT?=
 =?us-ascii?Q?T0NbCu5+SswZGNKW2GRNIjb5yMIsEH4EldTIgdN508Afx4IDs29qKfYuCusL?=
 =?us-ascii?Q?BNfmZYesjHp+E0kBnuV1pf4YUoM41WlAM559NO1wn/Y/Q12dKFmG5oenMZmq?=
 =?us-ascii?Q?znlFJhvT2Iwr+V7UaT0W+5nYsz6nUjgb62UPzzCsTBrnV/VrKmaujrnS6xPF?=
 =?us-ascii?Q?UQsTvjwZcmX/QLNxDq0RF+86oreUexGwIVUR4Esbezr8o+8PUD7MLsU7uZUS?=
 =?us-ascii?Q?sje7dpZG+dDDHdxVy2rYw79N7xLaPwgZV41PA1Q9hEpjyVor8hqsw4zSUrsu?=
 =?us-ascii?Q?IO8+Fvkf1H0SS6lp2+2z8qE1JQ95QCFptP8cI2OdMc5PXjlZkT+OGjeBsSao?=
 =?us-ascii?Q?408t+wogixq5GIi0YBLFW8/W?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdcdbe86-eeff-40c3-9f5d-08d98e53f84a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 14:15:54.7052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hvNBZs2CY8ovEXKTEQpUid3BGtVpXrsRbifpNg0aBkNgOhHe/ibdNrZXCyKXfZfzlzja+PozqUHWy0h6KQJvbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5675
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, October 13, 2021 8:49 PM
>=20
> On Tue, Oct 12, 2021 at 08:57:22AM +0000, Liu, Yi L wrote:
> > > +	ret =3D __vfio_group_get_from_iommu(iommu_group);
> > > +	if (ret)
> > > +		goto err_unlock;
> > >
> > > -	minor =3D vfio_alloc_group_minor(group);
> > > -	if (minor < 0) {
> > > -		vfio_group_unlock_and_free(group);
> > > -		return ERR_PTR(minor);
> > > +	err =3D cdev_device_add(&group->cdev, &group->dev);
> > > +	if (err) {
> > > +		ret =3D ERR_PTR(err);
> > > +		goto err_unlock;
> >
> > should this err branch put the vfio_group reference acquired
> > in above __vfio_group_get_from_iommu(iommu_group);?
>=20
> No, if ret was !NULL then the reference is returned to the caller via
> the err_unlock
>=20
> This path to cdev_device_add has ret =3D NULL so there is no reference
> to put back.

oh, yes. only if ret is NULL will go ahead to this place.

Thanks,
Yi Liu
