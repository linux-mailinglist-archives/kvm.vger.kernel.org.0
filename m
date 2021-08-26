Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DEB3F8075
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 04:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237096AbhHZC2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 22:28:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:2109 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236800AbhHZC2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 22:28:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="204786642"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="204786642"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 19:27:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="508213806"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 25 Aug 2021 19:27:21 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 19:27:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 25 Aug 2021 19:27:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 19:27:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xvv6mabBBe/errEcf2ccG9XffShre6Hveu8TUME3en/73s4sKtG8H1GbQb8lq1ms/sZP5L+Fdaguz2y5giq7k66Dpci2Pj3tTB1pGDKTKyKGVlwxuj0BFQfyFPR4oVUc+/K933gzSvn4Sc579flkxnctFfTZeOERxrFj2YM5IGFj/oFpA//oKhZ63iWHsXrhdJpFf5Xj/ys55Ysj8nrxDNz9AD5GYJ2tugAxIhk+IuUCc1hn6/jz3EFbHkeb3ndZqQFS/Vl7ulwCH3hQwr+gQF0skzV5PyQ9CLYzHLZDfFAVyekgrZEIXuZ37nIe7fu97yL3rHLlPt5qVaTKW0dLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8ulZySf5JYaoWB0Y37MgrdeuC+1FUNTwRyDENd8KxE=;
 b=dKY38VD7tvjvJI+HmVbUkZ48qdex1tNfUtPyfsVccwEoflVETJYsVjAIdRIO7Hk7+11H7mvmfytjW/Yx2XD5SebskEJyaAhLT2STYSICIzqt2cLvpHVS2TuyTAYfXFuLS8lpcnrxLPgb0eanYrcSXFZZVwGd4DzHzzd9ROQnjNK9KyGXR02AI9VnKVo2du1EZqb2Vbp0FG+oPbpkGdMoHKoZFQ0bBr+2+9udCR81GQ4iHAIMYsQgqz0tFKeqq+MNt3Wu5hJTwoyx7D8VocIXwW+5taraT6VVqVET18hG5KZ/pVurC5PLU+GeKqX2bDIlstW0VmfK8iI5DBGYkyLFhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8ulZySf5JYaoWB0Y37MgrdeuC+1FUNTwRyDENd8KxE=;
 b=m/aGxAqvsWlSNcrcuTxWLhzKBcdTklIGctCY75+N6t1hSAqPyjWo8VKtYvxUAtn8zBNyjhs8CQxYgLZXzlr2XdYIwLMKssrB6ZwHTaEhsJi7bfOBXALbx6Ujoth2XWUekNdSTMHa70nV09ujh+LipGqZj1mHW5ZjvnRUfM27wGw=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2292.namprd11.prod.outlook.com (2603:10b6:405:4d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Thu, 26 Aug
 2021 02:27:14 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 02:27:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 06/14] vfio: remove the iommudata hack for noiommu groups
Thread-Topic: [PATCH 06/14] vfio: remove the iommudata hack for noiommu groups
Thread-Index: AQHXmc5sZLNI6xMhekOMzTAC5eh35KuFDrRA
Date:   Thu, 26 Aug 2021 02:27:14 +0000
Message-ID: <BN9PR11MB54332A883615E3C3581F77868CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-7-hch@lst.de>
In-Reply-To: <20210825161916.50393-7-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04ae63f9-5d56-4b4e-069a-08d96839049a
x-ms-traffictypediagnostic: BN6PR1101MB2292:
x-microsoft-antispam-prvs: <BN6PR1101MB2292BA2E8BACF940002907048CC79@BN6PR1101MB2292.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:425;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PrCVIboWdoOcaY0L5NXLqPEl3UxMYgDv7chdFWCQRcJ6V9txZvlyP1+iVHLF/Ka1dKi1IsfLa7jSs82qekbu5SzkyvserV9G6z/bgVryV9f5EOTvXb3DK4zqO1E+wHoJ9qDIZxZFv77ocwE/EeZtQB7Yr+wXyAOAHrg70s6izvu10dpTepFpieSbCVoQOtz9rTpAKai5zPB6yXGCWZAz35S2ZBGRhMkkXGhdwX/gcqLtgZk24CODvdUiQHNzkgdmBLmIqWtfHsqIyid6jQoPh8xQnArkIPKvouA2u6V0MF0hj8GbYyFwbUh3a5s4FiKjZ4t4mUlOFTu70mHRLx8d1DIk58aCpN9LvvXS46Ut9+BEu+oTPJmWYhGLNB+RLEpWgdP44DlORjvn2ZHqG68qo9vVnXsR9opvdRngpNSlKYR36NZqTRIUezie3DLF5L20abF9k71epQP2Pq+Wjqe/AUrKQ1eBj0rfbYl7iK94IPdAxP9X+9E1r/ZcUUUHNufa2wFszsQrj5LlX0wdHd6JPXNL4ZoED0nSkheZXYvvVUHaPaUQyrT2Y3j7iUr3ZbPKhZgfort4HGvj6VGruU4ekgV553jE8TCNfqkpSzOX75oTmOpQIkWzqr/ydb2BdZcXBvKslwvsiVV9EnP5l1ExAX2TXUEp0xjp75h9dfIKfqbHyNJ0K4Uuh6tx+NdbA25ZvThMeNiLuBZe2sW32B36PQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(7696005)(8936002)(54906003)(66946007)(6506007)(2906002)(8676002)(83380400001)(110136005)(478600001)(316002)(33656002)(9686003)(86362001)(5660300002)(186003)(71200400001)(38070700005)(55016002)(52536014)(38100700002)(66446008)(26005)(76116006)(66476007)(66556008)(64756008)(122000001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3WL5llmTE+a7augfI12onsjI04LFq2kwpGT9/BwfZFFeWQG269Z327J7GmHe?=
 =?us-ascii?Q?WhaqEXHZ/4wR6A1CdL4ENbSrQDtSm9whsUenR1KnBsVfmjpGmTNW7LdVL6xL?=
 =?us-ascii?Q?78YumQvBk6tKl+Xye35ap7cepKjlLVQEIGZHWESDpnhwBJZ+Yyz+dfjo78pe?=
 =?us-ascii?Q?yK1mkRbVp//WPSu83tmh9cJ3NPTnMWK6jfcbVDyKZvK/4gKJ/34sCjNIM8Ly?=
 =?us-ascii?Q?fS/03VeK6mRNlHYR2IM7s/CJeUNxG7qH9TWo323ixxI3Byehzl4FE/QZoRF2?=
 =?us-ascii?Q?7B7+uHeGoxX/wuV4BLHNLcz68uxoIraWDJuiKHaEocZLGbRH9nbvw8PNT/+B?=
 =?us-ascii?Q?9rngQj3FdPUS5dRCNtXFYsKMeEvQYKg7Hkhk540/oFDi6S0zs1b0KJHk7t+Q?=
 =?us-ascii?Q?yCSYnPIZEBsQqkNUHG+neT9dX66RPF4cPTgxB3tvD7N4Ii58JYNOVolG8aze?=
 =?us-ascii?Q?ncQdpJTjEOo66BeoVMHNlQx27E7LVlk3qNipZBYxQRWZEOIG9u30IXVgsF4r?=
 =?us-ascii?Q?35A9+Wy/4oT4ZbkMCCpxFvh4f7OSLxaeirDIyoSRSeDZr6vQ8v5+i8ep3Yqe?=
 =?us-ascii?Q?gmcFgTpNAo9Dr9HIf1oTl5rFD3WAcvugBlRJ+xPCIUaohO3bEFVHonefaVkS?=
 =?us-ascii?Q?r4On8caHzakjK9+zvfO/LhLX3jFxReCRBxCH0E2uEzR7EzeY3liOemNZI2S6?=
 =?us-ascii?Q?jZEqqAeaaPxBDedNqdaOW5+0sDC+pwUV0VBK/+q27omUR0eDzR7PIwh02nam?=
 =?us-ascii?Q?MyN0hI2um3zkDnM08IbaMSuyhl3ThsvKs/bMzEwpwWW+UEXfup1ODwWyXwPo?=
 =?us-ascii?Q?77LG/WOLocfqDHzcTENjiII6EhVwlCunkJJ90pwwU3V+r4MgDzEmB9pHVAkJ?=
 =?us-ascii?Q?xyrKeoWiKehwi1arCw89PQzlIa0PESnd2JEZJYFPBeQ5Hl4+GHJ7EvxJ98SO?=
 =?us-ascii?Q?f2n4GgdUig+bji3pknRpxRML5f2dRU67ykhGfG3XWcmebPSHk++HxExOEwAK?=
 =?us-ascii?Q?JDugp2l6DvjrQLWKp/fnMg76nmYb+5Wj/w/Bo/WT7P4mpzxVU1e8JAKXLmmZ?=
 =?us-ascii?Q?+1EnLXsgHv0o29OI1C9pLxhjgsKpTyonXqIInmoDxok5LQ1W13IvlBGO3NeE?=
 =?us-ascii?Q?F2CDAaVYS3RceGqwELrjNdw8Y/gpD+1QbK8iBC6QfIYfKFN/XNieZQeNqwR7?=
 =?us-ascii?Q?SouSQZzsfiq1zVz6CLSDE6uQqDf4FieH3dogdZw1J7b7OGEUq1CIQrOI2zWH?=
 =?us-ascii?Q?M9fE0L3q3k7i1W1E/tcY0g6aA5sdaGok2meuYwSrN9FuAO6hv17V0SV6AoX5?=
 =?us-ascii?Q?8D+MY1Dl9UVZMmSxf/i2V+IP?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04ae63f9-5d56-4b4e-069a-08d96839049a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 02:27:14.8377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ypz60T0WzUG7qFG9r6tElE5fuSjaTMSObbqpR8Jj0QMZTA4rw65upeLNdAUMmp3s7kjyOe2DkSD7XfSxbgJnbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2292
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
> Just pass a noiommu argument to vfio_create_group and set up the
> ->noiommu flag directly, and remove the now superflous
> vfio_iommu_group_put helper.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 30 +++++++++++-------------------
>  1 file changed, 11 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index d440828505d9d7..71e0d3c4f1ac08 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -169,16 +169,6 @@ static void vfio_release_device_set(struct
> vfio_device *device)
>  	xa_unlock(&vfio_device_set_xa);
>  }
>=20
> -static void vfio_iommu_group_put(struct iommu_group *group, struct
> device *dev)
> -{
> -#ifdef CONFIG_VFIO_NOIOMMU
> -	if (iommu_group_get_iommudata(group) =3D=3D &noiommu)
> -		iommu_group_remove_device(dev);
> -#endif
> -
> -	iommu_group_put(group);
> -}
> -
>  #ifdef CONFIG_VFIO_NOIOMMU
>  static void *vfio_noiommu_open(unsigned long arg)
>  {
> @@ -345,7 +335,8 @@ static void vfio_group_unlock_and_free(struct
> vfio_group *group)
>  /**
>   * Group objects - create, release, get, put, search
>   */
> -static struct vfio_group *vfio_create_group(struct iommu_group
> *iommu_group)
> +static struct vfio_group *vfio_create_group(struct iommu_group
> *iommu_group,
> +		bool noiommu)
>  {
>  	struct vfio_group *group, *tmp;
>  	struct device *dev;
> @@ -364,9 +355,7 @@ static struct vfio_group *vfio_create_group(struct
> iommu_group *iommu_group)
>  	atomic_set(&group->opened, 0);
>  	init_waitqueue_head(&group->container_q);
>  	group->iommu_group =3D iommu_group;
> -#ifdef CONFIG_VFIO_NOIOMMU
> -	group->noiommu =3D (iommu_group_get_iommudata(iommu_group)
> =3D=3D &noiommu);
> -#endif
> +	group->noiommu =3D noiommu;
>  	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
>=20
>  	group->nb.notifier_call =3D vfio_iommu_group_notifier;
> @@ -801,12 +790,11 @@ static struct vfio_group
> *vfio_noiommu_group_alloc(struct device *dev)
>  		return ERR_CAST(iommu_group);
>=20
>  	iommu_group_set_name(iommu_group, "vfio-noiommu");
> -	iommu_group_set_iommudata(iommu_group, &noiommu, NULL);
>  	ret =3D iommu_group_add_device(iommu_group, dev);
>  	if (ret)
>  		goto out_put_group;
>=20
> -	group =3D vfio_create_group(iommu_group);
> +	group =3D vfio_create_group(iommu_group, true);
>  	if (IS_ERR(group)) {
>  		ret =3D PTR_ERR(group);
>  		goto out_remove_device;
> @@ -853,7 +841,7 @@ static struct vfio_group
> *vfio_group_find_or_alloc(struct device *dev)
>  		goto out_put;
>=20
>  	/* a newly created vfio_group keeps the reference. */
> -	group =3D vfio_create_group(iommu_group);
> +	group =3D vfio_create_group(iommu_group, false);
>  	if (IS_ERR(group))
>  		goto out_put;
>  	return group;
> @@ -884,7 +872,9 @@ int vfio_register_group_dev(struct vfio_device
> *device)
>  		dev_WARN(device->dev, "Device already exists on
> group %d\n",
>  			 iommu_group_id(group->iommu_group));
>  		vfio_device_put(existing_device);
> -		vfio_iommu_group_put(group->iommu_group, device->dev);
> +		if (group->noiommu)
> +			iommu_group_remove_device(device->dev);
> +		iommu_group_put(group->iommu_group);
>  		return -EBUSY;
>  	}
>=20
> @@ -1029,7 +1019,9 @@ void vfio_unregister_group_dev(struct vfio_device
> *device)
>  	if (list_empty(&group->device_list))
>  		wait_event(group->container_q, !group->container);
>=20
> -	vfio_iommu_group_put(group->iommu_group, device->dev);
> +	if (group->noiommu)
> +		iommu_group_remove_device(device->dev);
> +	iommu_group_put(group->iommu_group);
>  }
>  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
>=20
> --
> 2.30.2

