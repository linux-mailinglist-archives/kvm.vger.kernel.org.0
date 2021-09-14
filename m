Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EA840A2F9
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 04:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbhINCBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 22:01:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:63332 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhINCBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 22:01:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="244175397"
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="244175397"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 19:00:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="699132677"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 13 Sep 2021 19:00:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 13 Sep 2021 19:00:26 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 13 Sep 2021 19:00:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 13 Sep 2021 19:00:26 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 13 Sep 2021 19:00:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZfcRbvSAzYs60xc+EJE10CT2BhCOMF2NU4EbcZHZdNUD5T9Z0p7BK6VCpwdTfyK0DBpH3Upxo30/oQx2cIjlceinOBAtl1wVc5kSa2xN7WqVA84EiMJ68ICawJy8InT0mBEceK1jaQJruCcn0mwMFCDEyrG28UtzH/SkeL5C+Zk5oKDD1M+G25S6JRkIWbhbSf0KqgwPt0XDrGB06sijBTKSIHbAUzdZAUxEVJGavbwtsAe7wJYUu+PiAbhBKPsjCWDUM2/6XFGtDh4VFSoqs74iTI2ibvIdsC2f9sJPjYmXSQUWE6+fjfqeQhxLyBiRSh4YMGUKIy1gUplDLTEWnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=U7shxgotbUAthcc4kYUjb3dsJ9VMxdb1QBHcBoZGxXc=;
 b=FRobecRELGQnTiM+lj79lfPR1dat7H8mZuHLwWrZAwNfD0KaYRg1gxLoMAwPR/M/ojAMeRs5mH5Vol0w492MfCXCRRNctNozx0bLl34ycWN0ZiWuYic6uuMZ6rSgiQHegH4l6Ct+jm2a81593Qzan+DcfEEnZpiFqMvSCptJcr24iBOaNi4LLIjXuETKz85qqsA9nodPs+wbXXYeBQsmgFXnkCXEtC9i987e2T7tJjhEFtJPIfRB1yJNVRUo/k1c+BPmUozjhjtHKzelsnRHoQ6hktXXdz+PTq/ec16HtUcLhI7dgyGs5MswFqBwgdl515pUC2JSCFKD9hHRjaP2qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7shxgotbUAthcc4kYUjb3dsJ9VMxdb1QBHcBoZGxXc=;
 b=Z0/glBn0c8FlCmWmCSPJBWpj6GKlqaYHvgj5kgJaedmTue3TvaRToCoFhhFlpOFn/WnkaJUr5bwh6im2Iey7s0EzbTek9UN9XhM/DnlkXsdXlKwhYAIFebBw7xIEUQx1c3T4CtKV8wLc9sTMAyIRQ7Up6eqc6rLFrH+o3MFL4Tk=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1699.namprd11.prod.outlook.com (2603:10b6:404:3c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 02:00:23 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 02:00:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>
Subject: RE: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc helper
Thread-Topic: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc helper
Thread-Index: AQHXqHAffIZpeWYO0U6DDQHZgWVhqKuixw0w
Date:   Tue, 14 Sep 2021 02:00:22 +0000
Message-ID: <BN9PR11MB54334154B18C62F7A8E0B6F48CDA9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210913071606.2966-1-hch@lst.de>
 <20210913071606.2966-5-hch@lst.de>
In-Reply-To: <20210913071606.2966-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 660a6e67-50e5-44a0-8739-08d9772369ae
x-ms-traffictypediagnostic: BN6PR11MB1699:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB169969DCBF018D156145AE128CDA9@BN6PR11MB1699.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yF001pGrBla1MyhWJJ+/Bgobu2Ybsk2T5QJiUnXmM0N7GADgHu2n9bGKBD1q6P9yQ/vvD1Se1p0ds0CA91D21fQs5F6aptl/EkDIyzKm/JCkShJDGE7s0VGMidEygGTS6M7Xq0ZLbwascF3VzFcaEBtMoh33hcYHQWavdU4Z85JqnYbUj7CiOz9PHM+uIjrtdnAogeoB5JcqVEBddakBBrB2RJgI5wo8gwSvJAeMhrvI4jwaIivFdg8gZgJn0i7UjDcuWhHAgX+oZ+dstejkg0yOo6Ygi3ruVXoqtXxyo2o1uuN5EG9eUyxwAyjQ1FDcZ8TFm+bMqwJNKo1PVkRx+BW4wy+J5TF3q17A9jEkWGXMQHW4WODeI4FnRXusK51gEUVZn0MkB9bzaB2WzzSR2jkokZ7w1lGsUzDFp4Cd/RoNk38ssm3BMOroK6iEio8bVegeyxrwfTYWr34RiZhlteUr739q6gHCtBoNSs92zXsqq4ecNxRJe85a4SM714usxRZH7ZCGPc0zIaFZIURaCgWfOEX+OTEF7I1DROyl2UCxdBIZgOz/6johO8SzwvRZrX8P2tJhC4gHy6/POByqgWwbXL3p13fQoCIUeiTdXZgXVbYD7e39it3Xz2Vv9EzfiRAo2LQAN23t94xNawsS9/90xrO+6EH4dkOTgsd0b8R5H9zpg/BXacPCBNZmJz7y/oYRPoZwZEK1Y0Kj+JGCGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(9686003)(66946007)(122000001)(110136005)(186003)(6506007)(26005)(38100700002)(7696005)(71200400001)(54906003)(5660300002)(66556008)(64756008)(66446008)(66476007)(316002)(38070700005)(4326008)(76116006)(8936002)(2906002)(52536014)(86362001)(83380400001)(478600001)(8676002)(33656002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aBmtQ7DYpH4WehwLs5vqcV2lnINpRvctx2iirKUewtajzoXth6u4itmHG4Zt?=
 =?us-ascii?Q?YMtnvpbYsVJXqWVxQ7ywSAoaI8ui8OpRt8Hdu30Rf0ccUhhY9om+bZAiAMxC?=
 =?us-ascii?Q?EvA1OkmzbGY7vc/sIaR59zDAZOkHtCuCi40IHkZY/Ar5akHPJQuyLIyyVKol?=
 =?us-ascii?Q?AJgze1AZN1MVHr/ZdoNNo4iz9tP/114RpfUi/Un6SsnlwDGK/PuYZuN+Lnzo?=
 =?us-ascii?Q?oJFzvgXDTtej2ZnsPeMXvQaVziOG0/hIRM0Z7y/Oy19m6k02QD6u9OrNxdk/?=
 =?us-ascii?Q?A8KYhfemhPk/mjf3X1gpDs+rMH2FyiYEXfAKBn+yTP74mgZn7Ly/XKn6ImoG?=
 =?us-ascii?Q?/GNf1XVMVEd0Njov40fJGi5s0v96lyEfy0/PA06UraNsI9arDwSP4ILVavbU?=
 =?us-ascii?Q?pCGJhpDW9RvmoFn2ovwtPv/MoxU2MMBAE0KC3MKmxLefvoBtM6iELy2o7ksN?=
 =?us-ascii?Q?Fha9dN6hPcLeNrAuNLt46MBk29OxmYPaEfGZuMiGMUM7IObc8oUXm/v4Bpbo?=
 =?us-ascii?Q?ShzGzm8DuG9L4LkG+2bC3KGO+qMvO6Pj790UciH01llvBOXF5Qq+xu80Xpxw?=
 =?us-ascii?Q?SpYWslliow50R5V0oxRyEJ5lDGfig27OkBVAFbx2cyNwtppwGvys/+97czDQ?=
 =?us-ascii?Q?0VvDfHlVeJah93Wisv+0rYEx2Rq2LFNp1NDhftkPm+/JUt6BdvM0cZ/ZbmLc?=
 =?us-ascii?Q?TvDYxkL8mcec83tCpHDJ7/BdBCWJDxyCjLfG2aScKBW9vdxWCypbwzGLNS4d?=
 =?us-ascii?Q?L/m7cS9orYFJMC+TXHskL3GQBG6qUEJnw2j49f/H6Hh5FLMFawA9Ay/8RjCU?=
 =?us-ascii?Q?5PrhrfmCoXHBYjXgGO3Z9swzWJaXhwHGvFK+RP7hZ14Bh9Lca0ghfWEOJZrf?=
 =?us-ascii?Q?tunggUh/w51Y8BztcQTRVTKeUGvkBD3CKnAZTbV4aAvG4tUOKIf8UbPuPtYg?=
 =?us-ascii?Q?YB9fLerRMjawcUhuJ0QjVu3HlbcGtPDX4epGUPHGL3Q3pn+1qqOVcTLsE6aC?=
 =?us-ascii?Q?raLkmr6KW7abuUtz9Jt/zm9DYzPoQqEg/9dcIiCBY9ED8p4KlS89eYbwp7yO?=
 =?us-ascii?Q?HRnXH3InkBylh7wy5dD6AG45n+dQ+DOkVgsBybPcUmu07Agc+WB2caqPwINQ?=
 =?us-ascii?Q?Kud8yh44M3/vG3hKjGfZ5q5+XqeKH9Qt0zNNZnMI5Fe9LoYvV6TLmz9zo8Yd?=
 =?us-ascii?Q?8VvMWuzZ22ESVcvk03MomZINV7WmlWoNsiFPdB6PiMvQaTwmzOn6QPxnzXFL?=
 =?us-ascii?Q?nj0Pq9tERapxJPcoaVbrn4CKzKiUKz4hGB0YbWYzK4ur+1aetq/VYWDPEc+4?=
 =?us-ascii?Q?4JoCnw8ZSTkHyEDInbFSUlWC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 660a6e67-50e5-44a0-8739-08d9772369ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 02:00:22.9485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j3HChdBB6dzw1kH/FbPEqrjCUqEFX141TsTif8GiBMwq1x6+tj2xaxhuBBx8/blawyfMffhBLWJR13crViuXHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1699
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Monday, September 13, 2021 3:16 PM
>=20
> Factor out a helper to find or allocate the vfio_group to reduce the
> spagetthi code in vfio_register_group_dev a little.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 60 ++++++++++++++++++++++++++-------------------
>  1 file changed, 35 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 8bd4b0b96b94a3..2b2679c7126fdf 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -823,10 +823,39 @@ void vfio_uninit_group_dev(struct vfio_device
> *device)
>  }
>  EXPORT_SYMBOL_GPL(vfio_uninit_group_dev);
>=20
> +struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> +{
> +	struct iommu_group *iommu_group;
> +	struct vfio_group *group;
> +
> +	iommu_group =3D vfio_iommu_group_get(dev);
> +	if (!iommu_group)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* a found vfio_group already holds a reference to the iommu_group
> */
> +	group =3D vfio_group_get_from_iommu(iommu_group);
> +	if (group)
> +		goto out_put;
> +
> +	/* a newly created vfio_group keeps the reference. */
> +	group =3D vfio_create_group(iommu_group);
> +	if (IS_ERR(group))
> +		goto out_remove;
> +	return group;
> +
> +out_remove:
> +#ifdef CONFIG_VFIO_NOIOMMU
> +	if (iommu_group_get_iommudata(iommu_group) =3D=3D &noiommu)
> +		iommu_group_remove_device(dev);
> +#endif
> +out_put:
> +	iommu_group_put(iommu_group);
> +	return group;
> +}
> +
>  int vfio_register_group_dev(struct vfio_device *device)
>  {
>  	struct vfio_device *existing_device;
> -	struct iommu_group *iommu_group;
>  	struct vfio_group *group;
>=20
>  	/*
> @@ -836,36 +865,17 @@ int vfio_register_group_dev(struct vfio_device
> *device)
>  	if (!device->dev_set)
>  		vfio_assign_device_set(device, device);
>=20
> -	iommu_group =3D vfio_iommu_group_get(device->dev);
> -	if (!iommu_group)
> -		return -EINVAL;
> -
> -	group =3D vfio_group_get_from_iommu(iommu_group);
> -	if (!group) {
> -		group =3D vfio_create_group(iommu_group);
> -		if (IS_ERR(group)) {
> -#ifdef CONFIG_VFIO_NOIOMMU
> -			if (iommu_group_get_iommudata(iommu_group) =3D=3D
> &noiommu)
> -				iommu_group_remove_device(device->dev);
> -#endif
> -			iommu_group_put(iommu_group);
> -			return PTR_ERR(group);
> -		}
> -	} else {
> -		/*
> -		 * A found vfio_group already holds a reference to the
> -		 * iommu_group.  A created vfio_group keeps the reference.
> -		 */
> -		iommu_group_put(iommu_group);
> -	}
> +	group =3D vfio_group_find_or_alloc(device->dev);
> +	if (IS_ERR(group))
> +		return PTR_ERR(group);
>=20
>  	existing_device =3D vfio_group_get_device(group, device->dev);
>  	if (existing_device) {
>  		dev_WARN(device->dev, "Device already exists on
> group %d\n",
> -			 iommu_group_id(iommu_group));
> +			 iommu_group_id(group->iommu_group));
>  		vfio_device_put(existing_device);
>  #ifdef CONFIG_VFIO_NOIOMMU
> -		if (iommu_group_get_iommudata(iommu_group) =3D=3D
> &noiommu)
> +		if (iommu_group_get_iommudata(group->iommu_group) =3D=3D
> &noiommu)
>  			iommu_group_remove_device(device->dev);
>  #endif
>  		vfio_group_put(group);
> --
> 2.30.2

