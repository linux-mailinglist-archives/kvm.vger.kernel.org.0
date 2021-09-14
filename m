Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B029F40A30B
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 04:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhINCIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 22:08:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:63962 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229754AbhINCIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 22:08:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="244176687"
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="244176687"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 19:07:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="481587196"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 13 Sep 2021 19:07:36 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 13 Sep 2021 19:07:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 13 Sep 2021 19:07:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 13 Sep 2021 19:07:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H41S73Mwi7fjAs9Jn9vCHzprZVeeUoBeS0L0s1ovH+hcZBsTknSfJxzamjyYipr2d7Ilnhy+2vCdotL1GyUlPT+BvQk/rK5MqSjOCYnPkQU2JOFCSyRxxOvpGV0JmIUpfHK4Kdzmsr1aWl4HPR8cttqvVn+zBE8JTjO/1P0h3mxBTw+deAw0PxCC+Y+738a9wBMyAufMapSEbyG19BYujqp+VDHiN5mqmQrtZKlnOCSIu40+A7JQ7cO+pYHcF6y/CZIR3OZaNS95Asi8ELT6ILO+wSTU6oXrtsNfUfdy7EUgdo/gsH2UQ8JHUJ++FczaReXdm2FeD0W+P0CYuGKSFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HrCJY+3SyJCxdhjYfMJcXFauxYeC3WhNP8i94U71Nhg=;
 b=OS0AbSPTnmWJnKanE87fdFZEKN5dLgVIi4KRfkrjWiAIEjU57qSFwXscdHiLNmJBc2D4ys6D5Fh1f1NSFyfpv44St2QrkfFY1je+8OhwVIo2W1Upe40lhT8CRFJ43UeZKSewcTDLxSw3HrrPtLgocEbYFz/SpmEzpskPb9AQhTzrAPDAtfv31MtbzbDkbHFXMr9KU0YEn6bTRNDwjnInw9rVr2TpzmivuvgvFwb9NNZHOFDQi6S/86SpK/PRB6qe7Hf789NBvfV2Uv689VnWMGnZepXpnVfoTzdcw0L2R7E1Xe/ub1czwqtRW8qt0mX3IPgyzQCpJxdxj43BRIdgaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrCJY+3SyJCxdhjYfMJcXFauxYeC3WhNP8i94U71Nhg=;
 b=FBYBy2ADDTq8XNMquFfGQXvCZUr3DGbA9LT4AXKHq63REkQdTEgp6Nrtpv0MYOaNI7eCk+H+iSE61vAfHhkJzp+xaR4ccV95XIpftFmkA596Zdvg9cKID1+VsFMme56Y4LbNXUTsdn6DaXT+dh4AspCqAofbJsDhbIs+LBfBkg8=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5434.namprd11.prod.outlook.com (2603:10b6:408:11f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Tue, 14 Sep
 2021 02:07:34 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 02:07:34 +0000
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
Subject: RE: [PATCH 05/14] vfio: refactor noiommu group creation
Thread-Topic: [PATCH 05/14] vfio: refactor noiommu group creation
Thread-Index: AQHXqHA/sejqC22PWEqoLizneyQI+quix7Tg
Date:   Tue, 14 Sep 2021 02:07:34 +0000
Message-ID: <BN9PR11MB5433842C4B5A4053B09EB0968CDA9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210913071606.2966-1-hch@lst.de>
 <20210913071606.2966-6-hch@lst.de>
In-Reply-To: <20210913071606.2966-6-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d64666de-2a9e-49bf-8ca3-08d977246b05
x-ms-traffictypediagnostic: BN9PR11MB5434:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB54343F9331B48D10EFE3418B8CDA9@BN9PR11MB5434.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dyj/lyR755JRXOJmCjUA7UR2u6OIjo82Fhdkx0JzLWKuVU3I9to27A8MdMY3izzMi38H2RC2ubQDsr4bxY4NZEyrpJdn80wgSRcDAruEwTkkncpJUQt+qk/CVCls8JBVEnmftc9zhG9SS2hTPyk4RVPYUrtmj53HXxqyApustCyp3U9piaIiUCiYmc8/iq4VNEUVBAkCRaxZIwWbFLjVZlvvHrJK3rPPQtlOu3qQSRV+JtQk1x0HqrgIXZoWbN4uWkSaEH2OXPS9/3qUaYMsR2VwKtZUjFhS9VhbamsBjgBj5brDxbCYcNlizna0Njjnp5rdtPUKiLu/vrgBl3eo0NNLinYJB9iPsBkdLf2ZS8rGoQZfq2lq9boZB1hDr0BTxtg/7BpKAXSSDIeb6DVCrFaC1h2dmNmLivcCeVRpdr+vSX5+oczAJ9m1fCA5njQZEvOySDYU4jtgEZbE23SS9c45JBjtntO7GAGrRyw/bPAHlKjSUAwksIkNGlvdxs5oW49FGc0Owu3ZT7O+uXeDfdwR2m+FSMAwnVnhZqDFbP1XPOdIDSUwIL6jQ3ZxytMUOMO9ZzlQGrmnzWgpR3aDh3ZKhrVrMjgWGK0TDplbIYEQZPA8zesvYRf61LBpDkbN2fDCH9l5f6yVIcwc79ZmmTrJ936iej1jC35hs3VVcGZkvh4DvrlVkXzOwAIGH+YKJdeX/h0ySyU2OYLQkCmv1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(38100700002)(76116006)(122000001)(66446008)(33656002)(5660300002)(83380400001)(9686003)(52536014)(71200400001)(86362001)(8936002)(508600001)(55016002)(8676002)(6506007)(64756008)(66556008)(2906002)(186003)(7696005)(110136005)(54906003)(26005)(316002)(66946007)(66476007)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VOCLpGoreU9jYRYnq58P4lO8uF615V3FaRo85uEhfnH1h+SDC6AgKfi6pkHr?=
 =?us-ascii?Q?R5j0Y5qTIJhlI+xx8lOsRsGC6gBVfJjKthsAXEyNs/bJuO1x5Rk/859hboO1?=
 =?us-ascii?Q?5c/1PpaeFN5c+BUUSf5K6d2HEb8PXABh5CGjJviII+yKJsLKRbBKNgnFp2H1?=
 =?us-ascii?Q?X3+XewEGKLPaBqHwGy8bLQOnPT9DTEEBs2ENz14j2KlCL0B1OL38E5yIBGIZ?=
 =?us-ascii?Q?/5vH6O/LjZIQykXX4eIf5ttG/Ro0o0OSXe/s0XjF5mVGkOowKu5odWgNrlJI?=
 =?us-ascii?Q?SlcjMn4XbOzeVcw+dlbm6Q7VwgqWOYha6S1TaXE0wpkPbo50KW5KYFzvZ9l+?=
 =?us-ascii?Q?GRHheD8DLq/vOeMa71A48FXTi4IcVJXp9RaiBRD/CfIUV6FfdONT1LmvbtUm?=
 =?us-ascii?Q?fajLpHTn6vmzp35TXZBf4ZaHlLsQ0pDyux1j4Fw9wYJnYScXjtLvtbuOUVXa?=
 =?us-ascii?Q?I7F5G4cNCxwRMQWCznniPp+gR8C1aMvtlmjcbj0bH5dd7K1YvuIQdylgLG4T?=
 =?us-ascii?Q?F02XlGkueENPTdwM5XBEiJaa6ei8jAoY1GHoBeD0xDVA3cTWLtiKlLdeAxm5?=
 =?us-ascii?Q?9BEWZb7GIta+dLYBV+zQFaI+vQLW66EVTmJfF0n1UViSk5c0O+XBy+Ojpp44?=
 =?us-ascii?Q?wsXpAImDp9q4v6kqnHN6BjUqala5IKIlhKu7913MKnvO6XfaclhKoGhds0n3?=
 =?us-ascii?Q?G/UB6/Ghk0jOYL/Jx1t1FriqiOAyeDXsxPgX1CoOg3XrFNGTy9rThzPj9bBM?=
 =?us-ascii?Q?0DAQZ59sAzStv5fVhxv1oq1ZsGipkw9qD/zpUoqTY/mYw/Hya5kczpmdA5zN?=
 =?us-ascii?Q?8EFEhi6oCwVK2w+m6jTE84nKvUwi/6LDWWz4JGDUCwD0f7N1x9O41FlXEqi6?=
 =?us-ascii?Q?5+CNKtROMR4gkze0A8eKggZM+LRzVXbDwnctSm1p6G7pH+zvIObr1yq4YYTq?=
 =?us-ascii?Q?pWGLa1P3HOXP0N1Xtu3Bjyqd6JX3f/A00VQEDb8Ja5EuP240CzBITvflEk9A?=
 =?us-ascii?Q?uEyg6l/c5XYjCOlHTW6KEn7McNLIUPHC0E7a7T1rJHSWqMIKAi8+iiPz5nJU?=
 =?us-ascii?Q?S3mUrOHi2bAutrtAHV8sbnoAUFbQ95lXjButSedj3EI0/FouBIQWbnd54id6?=
 =?us-ascii?Q?hhcifuyLPuXsUR/Ag+XepmkuUY/iM55qbKHuHTcpwKxVH/808c2CER9vqUXJ?=
 =?us-ascii?Q?7LuADusp7GC6Xj7Viw5NcE7CLlvYtq+AVH9XBEuqtCb+ePkD7BP0q5xJ+08m?=
 =?us-ascii?Q?TeXo5NsRMHOeCBRJImijESLOEhJ5QdXFm5O9fGrqbLBsBSerGZbXMt9EL3en?=
 =?us-ascii?Q?4yV0UQyRvjPUUTex9saWe53j?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d64666de-2a9e-49bf-8ca3-08d977246b05
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 02:07:34.6166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zcea6Vyy9HCccWu6pKfQBTdxhaZ/yxWT+LLlvWE/H4yJXpA78zznqfpq7mX9/2F04JCRXOJPFPuV6Sz0j5Yr+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5434
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Monday, September 13, 2021 3:16 PM
>=20
> Split the actual noiommu group creation from vfio_iommu_group_get into a
> new helper, and open code the rest of vfio_iommu_group_get in its only
> caller.  This creates an entirely separate and clear code path for the
> noiommu group creation.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 104 ++++++++++++++++++++++----------------------
>  1 file changed, 52 insertions(+), 52 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 2b2679c7126fdf..b1ed156adccd04 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -169,50 +169,6 @@ static void vfio_release_device_set(struct
> vfio_device *device)
>  	xa_unlock(&vfio_device_set_xa);
>  }
>=20
> -static struct iommu_group *vfio_iommu_group_get(struct device *dev)
> -{
> -	struct iommu_group *group;
> -	int __maybe_unused ret;
> -
> -	group =3D iommu_group_get(dev);
> -
> -#ifdef CONFIG_VFIO_NOIOMMU
> -	/*
> -	 * With noiommu enabled, an IOMMU group will be created for a
> device
> -	 * that doesn't already have one and doesn't have an iommu_ops on
> their
> -	 * bus.  We set iommudata simply to be able to identify these groups
> -	 * as special use and for reclamation later.
> -	 */
> -	if (group || !noiommu || iommu_present(dev->bus))
> -		return group;
> -
> -	group =3D iommu_group_alloc();
> -	if (IS_ERR(group))
> -		return NULL;
> -
> -	iommu_group_set_name(group, "vfio-noiommu");
> -	iommu_group_set_iommudata(group, &noiommu, NULL);
> -	ret =3D iommu_group_add_device(group, dev);
> -	if (ret) {
> -		iommu_group_put(group);
> -		return NULL;
> -	}
> -
> -	/*
> -	 * Where to taint?  At this point we've added an IOMMU group for a
> -	 * device that is not backed by iommu_ops, therefore any iommu_
> -	 * callback using iommu_ops can legitimately Oops.  So, while we
> may
> -	 * be about to give a DMA capable device to a user without IOMMU
> -	 * protection, which is clearly taint-worthy, let's go ahead and do
> -	 * it here.
> -	 */
> -	add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> -	dev_warn(dev, "Adding kernel taint for vfio-noiommu group on
> device\n");
> -#endif
> -
> -	return group;
> -}
> -
>  #ifdef CONFIG_VFIO_NOIOMMU
>  static void *vfio_noiommu_open(unsigned long arg)
>  {
> @@ -823,12 +779,61 @@ void vfio_uninit_group_dev(struct vfio_device
> *device)
>  }
>  EXPORT_SYMBOL_GPL(vfio_uninit_group_dev);
>=20
> -struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> +#ifdef CONFIG_VFIO_NOIOMMU
> +static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev)
>  {
>  	struct iommu_group *iommu_group;
>  	struct vfio_group *group;
> +	int ret;
> +
> +	iommu_group =3D iommu_group_alloc();
> +	if (IS_ERR(iommu_group))
> +		return ERR_CAST(iommu_group);
>=20
> -	iommu_group =3D vfio_iommu_group_get(dev);
> +	iommu_group_set_name(iommu_group, "vfio-noiommu");
> +	iommu_group_set_iommudata(iommu_group, &noiommu, NULL);
> +	ret =3D iommu_group_add_device(iommu_group, dev);
> +	if (ret)
> +		goto out_put_group;
> +
> +	group =3D vfio_create_group(iommu_group);
> +	if (IS_ERR(group)) {
> +		ret =3D PTR_ERR(group);
> +		goto out_remove_device;
> +	}
> +
> +	return group;
> +
> +out_remove_device:
> +	iommu_group_remove_device(dev);
> +out_put_group:
> +	iommu_group_put(iommu_group);
> +	return ERR_PTR(ret);
> +}
> +#endif
> +
> +static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> +{
> +	struct iommu_group *iommu_group;
> +	struct vfio_group *group;
> +
> +	iommu_group =3D iommu_group_get(dev);
> +#ifdef CONFIG_VFIO_NOIOMMU
> +	if (!iommu_group && noiommu && !iommu_present(dev->bus)) {
> +		/*
> +		 * With noiommu enabled, create an IOMMU group for
> devices that
> +		 * don't already have one and don't have an iommu_ops on
> their
> +		 * bus.  Taint the kernel because we're about to give a DMA
> +		 * capable device to a user without IOMMU protection.
> +		 */
> +		group =3D vfio_noiommu_group_alloc(dev);
> +		if (!IS_ERR(group)) {
> +			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> +			dev_warn(dev, "Adding kernel taint for vfio-
> noiommu group on device\n");
> +		}
> +		return group;
> +	}
> +#endif
>  	if (!iommu_group)
>  		return ERR_PTR(-EINVAL);
>=20
> @@ -840,14 +845,9 @@ struct vfio_group *vfio_group_find_or_alloc(struct
> device *dev)
>  	/* a newly created vfio_group keeps the reference. */
>  	group =3D vfio_create_group(iommu_group);
>  	if (IS_ERR(group))
> -		goto out_remove;
> +		goto out_put;
>  	return group;
>=20
> -out_remove:
> -#ifdef CONFIG_VFIO_NOIOMMU
> -	if (iommu_group_get_iommudata(iommu_group) =3D=3D &noiommu)
> -		iommu_group_remove_device(dev);
> -#endif
>  out_put:
>  	iommu_group_put(iommu_group);
>  	return group;
> --
> 2.30.2

