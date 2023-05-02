Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CF86F445F
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 14:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbjEBM4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 08:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbjEBM4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 08:56:12 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44B8526B;
        Tue,  2 May 2023 05:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683032157; x=1714568157;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=emHuFR3Zbf6e/bZDKkoGRDfU3IlWFWxnN6m6siYUXR4=;
  b=NZQuVygehUCnbify7btnf85x5NYRK3UuvyzYU5Zx78b5a0gvBqqlCTG4
   Vy2ai+fDRD9fR6Kn4iP6isot4nmPpqYwygGGjE7tjGFKYO3JI6yiJh0eg
   H4hM195hSh+r9q43a/EA61ZPyEjGCzp5rX2CHC6WdRF6QKHUTB7CaviwO
   qe22K797jH9HKw/dN7jDuImPR+y64jP+/KVCFtlxzLbYo/7LtwokQfenf
   C6fqDLgVZop4MLve2n5jo1640U/ZnR2X/BhLDwVJj9gFe6F+VhKjVp9Sj
   2ZV05iv45JJ+tSkllQ3o6aDkhH2nkusHgyebz/ybniH/0OjnjH/nY7SG6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10697"; a="328019151"
X-IronPort-AV: E=Sophos;i="5.99,244,1677571200"; 
   d="scan'208";a="328019151"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2023 05:55:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10697"; a="1026064995"
X-IronPort-AV: E=Sophos;i="5.99,244,1677571200"; 
   d="scan'208";a="1026064995"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 02 May 2023 05:55:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 2 May 2023 05:55:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 2 May 2023 05:55:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 2 May 2023 05:55:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g61Sk1U4craXvMi7DipE7RoIPaCGhx7dvWBVd717Qs1hNZiAJZDGKLwFB0KgMJV7ct3ErVzd1h3iwD9xu6CbYOV3+z+KS0nCm+z8b1nL9Pm1eQJpuNa3koUxYKN+oi+JISYhyD9ETZlHStuBUnH/aT5AsBE6HWoDvnu/tENZCWWpQcibVwpF9rwUnFqE1YiOVUU8f5iT+gCmZb+ZiGE7szNJKZJvfhlAy/6uIucRfGrWiBn8bW9vf1GJhUTQpqqih52nb/TqjRHjwn6pEgNH5QJuXFByejHBVsW+ETV6pSEqZ3mlq1lOFVtq2bn9sEHbMRK6Kl9yEQafMr3V/haXrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yxYF3IlfZpiMIajw/L/vsFvUZq1P8bYQBeLTmFpKnrE=;
 b=ViGn1skHevcLS+ux8ROvuIvBEsWIZJn+EBiz98NS7RuAQURQXcdBYEv2ksJFtY0GAox+rGC67BrONlGBHT54gF4UVgpO8n0g7NUvEbdE/oZVB19JZkoaQ2zBuFXBWoINHLLl/4FiG+xcppaxM8hakvcSH9Yts0jHJ4d0zTKhfskDDksOuo2+oAOU0tL6s/Lsnl6DhmoWfpTfY8trTYmRgP5sC8+a3SvVxpBcsJg/2swEAwxPUcPewRdQ2lQR4IwMeVv7LGDhinp3iC7ycbeGhKJtEuoaTkwnki4pyJA7sy2Z18HES4+3FHDevXQcp3PrQAInYsEm9a2lS5p3Ti3I5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB7819.namprd11.prod.outlook.com (2603:10b6:610:125::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 12:55:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6340.021; Tue, 2 May 2023
 12:55:47 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 9/9] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v4 9/9] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZeE8NMs2VKXFFVEeChj4nzOnsha8/tVEAgAdBPJA=
Date:   Tue, 2 May 2023 12:55:47 +0000
Message-ID: <DS0PR11MB7529EC445E51A08050852BE8C36F9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
        <20230426145419.450922-10-yi.l.liu@intel.com>
 <20230427155524.732c878d.alex.williamson@redhat.com>
In-Reply-To: <20230427155524.732c878d.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH3PR11MB7819:EE_
x-ms-office365-filtering-correlation-id: 895db5ba-ac4c-4511-dab7-08db4b0c8cc1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r7uz9yb3TF3jSEWlkeiduVbyeIy3DnVgXhAMI1pHwpWoZuLskRVrIOpeCO7TqW/MS/pwztDbvmNslqqJ24L4jUBrmBRinQ5hMSpa1eQpkNI3suJIpBMJsRjf83GbTt0bmwdcGqL3W9jgO8MKJe+6gbsnEcJYEVFmX0m0rfu4nK5j7hhK3EwuUEssGF5wR4PsFGQ87bwk7yn0jY4Eoe5Lb9cQiqPXno5aNoX3ZBfrr//tJ3sEr9jP/0pXlr4gjwPhsYA3Gh5oIwXBIyLWk7sF+WM4qwl/z27kLQq6fTJYbnQ3+Ov68UFkKPoTNyyhdXvpnTZUgmzy3dZoFuDEmMaiUjWCcYzzXoE8MmBg6bRvwSpl2lp6GhIrUZXDiyEaTE6Y6cPcfH9y9Uc6OtoSR8duh7zq3mf+QOtl4v7xTX2fgV5oBPGr0bYwdEy7WZBRGTQSHOx6lilUE/dtj/ftbTbqPXgiDsNrAzk3ERHkjHR/RVcxITa9C0GZnqy7U/1sVixzbWyQXYM1TaPAEhp0lIXlJXMWtbwFC3qnY3rJPbAqCDIR5Z3OX2DT5WNImQnpvhoWo2ZLlTfActrQNy5tFIyx53PeyGcGAkZZvbTYZiCOjwPaaYQJ796VLJeMUO/oy6+s5hXwRjfe4V8tXivLc02OPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(122000001)(5660300002)(52536014)(38100700002)(8936002)(8676002)(76116006)(66556008)(66946007)(41300700001)(66476007)(66446008)(64756008)(4326008)(6916009)(316002)(82960400001)(2906002)(55016003)(38070700005)(86362001)(7416002)(9686003)(6506007)(26005)(7696005)(71200400001)(186003)(83380400001)(33656002)(478600001)(54906003)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iPLYB17Y7mh8EPYe+FLuJ7Up3OkyTInJaRP/kPK9vJxJE/bYvduE4j4IbniV?=
 =?us-ascii?Q?CX7JKI+F/FwhZJaGyjkkJDPBg63GQvSaW8ZfbmUl7AMVb/c/NTPgOMsY7TOx?=
 =?us-ascii?Q?mToS5GbjU0pduRceOVhDkafCWFrNtA5fD46shkumS+wTm2PGAPm/GCSZjkwv?=
 =?us-ascii?Q?/sfkXyXlbndEdz+67FqYhrfcyutxu6RWcMYy12qHPlsfgFJ75emhqkIBuQEf?=
 =?us-ascii?Q?Sm0JdYeGxLHBIbMzad/kTGHhpcmGYRkHay/QuHW2SHF9DH91Z0N2qazaDXDE?=
 =?us-ascii?Q?AFBPNoRnkBLGPtl1Kh9Qw1xi0bN9l+5hqoH8btFXSoTtQV/XCJsI1j0Xfu4y?=
 =?us-ascii?Q?yyIaToo9HLvF44jv1MAsGZvo9wNRLHXstqld9jDjpYZ27OHWtYoML3W544eY?=
 =?us-ascii?Q?jI1Ff/L9i3WxJprsuLVuIzrNpm2zx1Z5vYtQM2atbVqcMAV/1GDdRP/5920i?=
 =?us-ascii?Q?ErZ3k42YRu7Db89lkYW3SGpkuQKu5RQPU0OZbrCmEK4+TTOucnWpmL0gH5NX?=
 =?us-ascii?Q?iy237c1xim+qbXfW60UvhL/v0BoOs84CV+rhkfc2/kKwULwSSqdVRJ3lIKRW?=
 =?us-ascii?Q?ZyU2+OoWr+wCvO25ZhEzRffN9FI76hkkXMMqaqf12eA7YSYudk3zhG96OE6J?=
 =?us-ascii?Q?amUandmLmmM52CHUcAHmT8mGDgBx1wu3SOkzvc1Dust7Nm5XzLHA2p6eThtG?=
 =?us-ascii?Q?p5S2ZahibkvEA0WqOZdjKywFxmL+QUc4v+OlncPUozP88UHXMAH3HXEz+WWm?=
 =?us-ascii?Q?6GACS2RflmUWiV6yExcoTbLvkhaxoDhn2j4FI/tBYuvpyBdEZVVRyD/ofmYw?=
 =?us-ascii?Q?52JpyO0p+BSKbTvD9M0SUqkDF848KGI02gI5he5nQIQPQKgbtFM9C06g5dAR?=
 =?us-ascii?Q?athLwkGyPRMRr+vk0EtpzncT2cep2iTyFx8p23jpUXbyshEjZSO0NttXVnhG?=
 =?us-ascii?Q?1vWqFauRnnPWF8W+0XCeXBKre7vCJCAJAxVWOY0cazGMefywH2dGwTYA25O5?=
 =?us-ascii?Q?bLi1uAhlNO5ghmPA2sHxPyvBWd0mFI+ZklCQwCm2taLf685hby9CD625BfQb?=
 =?us-ascii?Q?U0bDl2EIFvqCHJ/1G1IgkL2QQ7uNauV7GPxmiL6ZZ9B7cL9zBZTUQIPU9Ims?=
 =?us-ascii?Q?vaC497YB+XhA3urJOw5oeyfBJqSi07uUxNjjlNuicTKQyGkGYp4gr2DiT/Ir?=
 =?us-ascii?Q?Xmjv2BVIquxwu+HSfYqHzQgER8VZJsS69dUG4H9In40gn1aWC2XK4ACFrA5v?=
 =?us-ascii?Q?FCyEL92TR0hmqsN77EAcFANuTgwOwoe8ESJIHjjqB3v6LS+Y3ruloMMK1Op9?=
 =?us-ascii?Q?gTQK7xZe5MnmA8piQYc20jrrviFsB+v2ZA1kc8Nc0j7rg6YXZE5P0FGHJOa6?=
 =?us-ascii?Q?p+I9PHCkigcEjfCUMCbfxHPpCnnCzdb0bQ9Z6hABbnQUJ4iR+y41hgm4L91d?=
 =?us-ascii?Q?Tcce/nbkCny8Q+MtQ0CjIV21RRR88p0HiaVuKaCMREkf+V1mA1FeghbUuThu?=
 =?us-ascii?Q?f7om2IG43aljtJvYeoTGvm1bJ7pLbG2n7oCCf+xNyq3DXUkCtutUGKG6nAXs?=
 =?us-ascii?Q?pUlvEzOVpVEsRbv/S6M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 895db5ba-ac4c-4511-dab7-08db4b0c8cc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2023 12:55:47.5694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vnZiksNhaSjzTs4bYfQT4NJX1/3z6h+GckWuuCXFcQFt2a+ugYkJgCJITEx/ZoRr2Q04NYILFqZLfzNBqA6Uig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7819
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, April 28, 2023 5:55 AM
>=20
> On Wed, 26 Apr 2023 07:54:19 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This is the way user to invoke hot-reset for the devices opened by cdev
> > interface. User should check the flag VFIO_PCI_HOT_RESET_FLAG_RESETTABL=
E
> > in the output of VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl before doing
> > hot-reset for cdev devices.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 66 +++++++++++++++++++++++++++-----
> >  include/uapi/linux/vfio.h        | 22 +++++++++++
> >  2 files changed, 79 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_p=
ci_core.c
> > index 43858d471447..f70e3b948b16 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -180,7 +180,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_co=
re_device
> *vdev)
> >  struct vfio_pci_group_info;
> >  static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set=
);
> >  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> > -				      struct vfio_pci_group_info *groups);
> > +				      struct vfio_pci_group_info *groups,
> > +				      struct iommufd_ctx *iommufd_ctx);
> >
> >  /*
> >   * INTx masking requires the ability to disable INTx signaling via PCI=
_COMMAND
> > @@ -1364,8 +1365,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct
> vfio_pci_core_device *vdev,
> >  	if (ret)
> >  		return ret;
> >
> > -	/* Somewhere between 1 and count is OK */
> > -	if (!array_count || array_count > count)
> > +	if (array_count > count)
> >  		return -EINVAL;
>=20
> Doesn't this need a || vfio_device_cdev_opened(vdev) test as well?
> It's invalid to pass fds for a cdev device.  Presumably it would fail
> later collecting group fds as well, but might as well enforce the
> semantics early.

Yes, it is.

>=20
> >
> >  	group_fds =3D kcalloc(array_count, sizeof(*group_fds), GFP_KERNEL);
> > @@ -1414,7 +1414,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct
> vfio_pci_core_device *vdev,
> >  	info.count =3D array_count;
> >  	info.files =3D files;
> >
> > -	ret =3D vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
> > +	ret =3D vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
> >
> >  hot_reset_release:
> >  	for (file_idx--; file_idx >=3D 0; file_idx--)
> > @@ -1429,6 +1429,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct
> vfio_pci_core_device *vdev,
> >  {
> >  	unsigned long minsz =3D offsetofend(struct vfio_pci_hot_reset, count)=
;
> >  	struct vfio_pci_hot_reset hdr;
> > +	struct iommufd_ctx *iommufd;
> >  	bool slot =3D false;
> >
> >  	if (copy_from_user(&hdr, arg, minsz))
> > @@ -1443,7 +1444,12 @@ static int vfio_pci_ioctl_pci_hot_reset(struct
> vfio_pci_core_device *vdev,
> >  	else if (pci_probe_reset_bus(vdev->pdev->bus))
> >  		return -ENODEV;
> >
> > -	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg=
);
> > +	if (hdr.count)
> > +		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, ar=
g);
> > +
> > +	iommufd =3D vfio_iommufd_physical_ictx(&vdev->vdev);
> > +
> > +	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL, iommufd);
>=20
> Why did we need to store iommufd in a variable?

will remove it.

> >  }
> >
> >  static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
> > @@ -2415,6 +2421,9 @@ static bool vfio_dev_in_groups(struct vfio_pci_co=
re_device
> *vdev,
> >  {
> >  	unsigned int i;
> >
> > +	if (!groups)
> > +		return false;
> > +
> >  	for (i =3D 0; i < groups->count; i++)
> >  		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
> >  			return true;
> > @@ -2488,13 +2497,38 @@ static int vfio_pci_dev_set_pm_runtime_get(stru=
ct
> vfio_device_set *dev_set)
> >  	return ret;
> >  }
> >
> > +static bool vfio_dev_in_iommufd_ctx(struct vfio_pci_core_device *vdev,
> > +				    struct iommufd_ctx *iommufd_ctx)
> > +{
> > +	struct iommufd_ctx *iommufd =3D vfio_iommufd_physical_ictx(&vdev->vde=
v);
> > +	struct iommu_group *iommu_group;
> > +
> > +	if (!iommufd_ctx)
> > +		return false;
> > +
> > +	if (iommufd =3D=3D iommufd_ctx)
> > +		return true;
> > +
> > +	iommu_group =3D iommu_group_get(vdev->vdev.dev);
> > +	if (!iommu_group)
> > +		return false;
> > +
> > +	/*
> > +	 * Try to check if any device within iommu_group is bound with
> > +	 * the input iommufd_ctx.
> > +	 */
> > +	return vfio_devset_iommufd_has_group(vdev->vdev.dev_set,
> > +					     iommufd_ctx, iommu_group);
> > +}
>=20
> This last test makes this not do what the function name suggests it
> does.  If it were true, the device is not in the iommufd_ctx, it simply
> cannot be within another iommu ctx.

Yes. it actually means not possible to be in another iommufd_ctx.

>=20
> > +
> >  /*
> >   * We need to get memory_lock for each device, but devices can share m=
map_lock,
> >   * therefore we need to zap and hold the vma_lock for each device, and=
 only then
> >   * get each memory_lock.
> >   */
> >  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> > -				      struct vfio_pci_group_info *groups)
> > +				      struct vfio_pci_group_info *groups,
> > +				      struct iommufd_ctx *iommufd_ctx)
> >  {
> >  	struct vfio_pci_core_device *cur_mem;
> >  	struct vfio_pci_core_device *cur_vma;
> > @@ -2525,10 +2559,24 @@ static int vfio_pci_dev_set_hot_reset(struct
> vfio_device_set *dev_set,
> >
> >  	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list=
) {
> >  		/*
> > -		 * Test whether all the affected devices are contained by the
> > -		 * set of groups provided by the user.
> > +		 * Test whether all the affected devices can be reset by the
> > +		 * user.
> > +		 *
> > +		 * If user provides a set of groups, all the opened devices
> > +		 * in the dev_set should be contained by the set of groups
> > +		 * provided by the user.
> > +		 *
> > +		 * If user provides a zero-length group fd array, then all
> > +		 * the affected devices must be bound to same iommufd_ctx as
> > +		 * the input iommufd_ctx.  If there is device that has not
> > +		 * been bound to iommufd_ctx yet, shall check if there is any
> > +		 * device within its iommu_group that has been bound to the
> > +		 * input iommufd_ctx.
> > +		 *
> > +		 * Otherwise, reset is not allowed.
> >  		 */
> > -		if (!vfio_dev_in_groups(cur_vma, groups)) {
> > +		if (!vfio_dev_in_groups(cur_vma, groups) &&
> > +		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx)) {
>=20
>=20
> Rather than mangling vfio_dev_in_groups() and inventing
> vfio_dev_in_iommufd_ctx() that doesn't do what it implies, how about:
>=20
> bool vfio_device_owned(struct vfio_device *vdev,
> 		       struct vfio_pci_group_info *groups,
> 		       struct iommufd_ctx *iommufd_ctx)
> {
> 	struct iommu_group *group;
>=20
> 	WARN_ON(!!groups =3D=3D !!iommufd_ctx);
>=20
> 	if (groups)
> 		return vfio_dev_in_groups(vdev, groups));
>=20
> 	if (vfio_iommufd_physical_ictx(vdev) =3D=3D iommufd_ctx)
> 		return true;
>=20
> 	group =3D iommu_group_get(vdev->dev);
> 	if (group)
> 		return vfio_devset_iommufd_has_group(vdev->vdev.dev_set,
> 						     iommufd_ctx, group);
> 	return false;
> }

Will follow above suggestion.

> Seems like such a function would live in vfio_main.c

It may require to make the struct vfio_pci_group_info visible outside
of vfio-pci. This seems to be strange to make vfio_main.c to refer pci
specific structure.

>=20
> >  			ret =3D -EINVAL;
> >  			goto err_undo;
> >  		}
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 4b4e2c28984b..1241d02d8701 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -710,6 +710,28 @@ struct vfio_pci_hot_reset_info {
> >   * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
> >   *				    struct vfio_pci_hot_reset)
> >   *
> > + * Userspace requests hot reset for the devices it operates.  Due to t=
he
> > + * underlying topology, multiple devices can be affected in the reset
> > + * while some might be opened by another user.  To avoid interference
> > + * the calling user must ensure all affected devices are owned by itse=
lf.
> > + * The ownership proof needs to refer the output of
> > + * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO.  Ownership can be proved as:
> > + *
> > + *   1) An array of group fds - This is used for the devices opened vi=
a
> > + *				the group/container interface.
> > + *   2) A zero-length array - This is used for the devices opened via
> > + *			      the cdev interface.  User should check the
> > + *			      flag VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID
> > + *			      and flag VFIO_PCI_HOT_RESET_FLAG_RESETTABLE
> > + *			      before using this method.
> > + *
> > + * In case a non void group fd array is passed, the devices affected b=
y
> > + * the reset must belong to those opened VFIO groups.  In case a zero
> > + * length array is passed, the other devices affected by the reset, if
> > + * any, must be either bound to the same iommufd as this VFIO device o=
r
> > + * in the same iommu_group with a device that does.  Either of the two
> > + * methods is applied to check the feasibility of the hot reset.
>=20
> This should probably just refer to the concept of ownership described
> in the INFO ioctl and clarify that cdev opened device must exclusively
> provide an empty array and group opened devices must exclusively use an
> array of group fds for proof of ownership.  Mixed access to devices
> between cdev and legacy groups are not supported by this interface.
> Thanks,

Sure. Will make it in next version.

Regards,
Yi Liu

>=20
> Alex
>=20
> > + *
> >   * Return: 0 on success, -errno on failure.
> >   */
> >  struct vfio_pci_hot_reset {

