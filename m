Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9416F3F8062
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 04:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbhHZCV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 22:21:29 -0400
Received: from mga17.intel.com ([192.55.52.151]:16727 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235677AbhHZCV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 22:21:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="197888203"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="197888203"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 19:20:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="464968055"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 25 Aug 2021 19:20:41 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 19:20:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 25 Aug 2021 19:20:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 19:20:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eyg+qkcjvcJA7YAbwM58FwmQolfBY0cfMlQ+YZIiC9fw9+Z3hB+IXEWBJLhSR3J4pnK9vT7i/Gnx65Hf0iU7J3ARw28QqQyX9BQJhK43wsEd+PV9+7AdrqKfkHBFaeH8OvqBp9S71tCwCG3+0HRGi+otQB8KMlhX5Ny9rXc/COFIMGdseaVXSBIxXr+xEblSh1McUVp4Q7M4AeUWRUp1syPdc2iKlVImfGtd2iNGLfHqV0SBWaox9Jtb/jIVLlRpwWvKy6h9C7dz3o3MeJbTLfuckivKdn7yE8J9LygwkL6Qih8WHEIxdkceW1CWFlQzjMDIPXV57YCI+MVUcHFAvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQ9KtGQzTMvLnlsqHs/cD2Iwu9HSw6gdxgXuBtQXLYY=;
 b=W4DprFtYsJ3c8IMb2PaCtIgR46LvrHqae2aOTFh7zwrKjlGSelhNMY8/OBjZXiB3+zxcitVT5Hnb5+qp5cNxHbukHPFbuDNq+YitQYv6GYiS1taJ6aUibXSebH6ZZSm3qGqzhFSYW8h8avNq49Q3THeNRJ5pFyZRUjBty0dgl3in4mQbYM4a4y0CTgEUhJcAmFFUGlUZkyCD1Gp7KKmKHxTq7+PVXzi/QoDqX2I1h1IBVYfjFLvlxwgmjJ03o6dZ4LXb+GW2AMc0zo0N+un9uJjf7yieOQPSFssnspiDcAnrE8aR5m0tEzy31Whp/e38/TrDx3lZTkRRlrZe7l6UUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQ9KtGQzTMvLnlsqHs/cD2Iwu9HSw6gdxgXuBtQXLYY=;
 b=qEudXHoFFXCiGN3wWBDA64k+qPsmjd6Gi1rm7MK5BNpf5iwVTwQlVI0ClkTIrAhrA7h3BQ8eml98QwEz3BvCrFEuiD1vo0/vzx9HbVM05QGHIwlsJd6gDa3JXxmfMIK5yGsiNJJt2l9bXJ6b8n2kI5UzhJf/3DCG9Z453indnik=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN7PR11MB2851.namprd11.prod.outlook.com (2603:10b6:406:ac::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 26 Aug
 2021 02:20:37 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 02:20:37 +0000
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
Subject: RE: [PATCH 05/14] vfio: refactor noiommu group creation
Thread-Topic: [PATCH 05/14] vfio: refactor noiommu group creation
Thread-Index: AQHXmc5o8bkJqkz7w0eMrd/KN8HERKuFCE/Q
Date:   Thu, 26 Aug 2021 02:20:37 +0000
Message-ID: <BN9PR11MB54335C6A47F5D5CC564648388CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-6-hch@lst.de>
In-Reply-To: <20210825161916.50393-6-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: 466a66c7-9528-4d78-3834-08d9683817e6
x-ms-traffictypediagnostic: BN7PR11MB2851:
x-microsoft-antispam-prvs: <BN7PR11MB285113812E43ADF2AC1D5AEA8CC79@BN7PR11MB2851.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K5d90mFRJUbytQ9YTzozcNHPwbVcAmN1zl+ymBwxcjhTReJSxw9XMBmcsrFfqeF9qHasxo5dGRR5m9x6s/ONPnKDpDT3uypyO2PSH2hGYaxWYL9QELZhWE2vgtLXtLJDs9wV3WovDb3FRZ8JSOAiLMNzxcc+EyzM1hDbl1Y1iJOsiTnLtuaqMoYjPuBZyBOAVi4x7fEAbee3M9HBhLIFP4GU/Ecg/k2QuJh8wQwZofXwUYMtBM6U46/K8yfWIdAlTdn6WO5AOi+OYW9iACBvF841Pwe2CBkHGhYLYHaHm4RMzP4nKi87/nt5LW0rSBGqcfnCdSosUWzKcvN8amKYbaKowBbb9Wmkd69YJwdYvVyKbGFRdZCsOdxaqfj7Zw/y3mkmoRdGcJGvuqgE7DmQEVws6DwYwXER0xYWK+uQGder6Apv4VoHtJkvvIJ4xcev/133VAviKYEq3DCUE1SgvuMYVtwHwDWMOh8nEKBcRz9WPoHheqTG1Bl6CYDUnz1TOO54afEj94h8tfWA3xFJCVGKsNM3Huzu6vVnzomujn/KzbxK6uToRNX5kUyc03iwk44tM/aYysPyIjwtHJt8IfF0hETLpKXtNDM9tffl51ZjLWaoN5VCSLPVIGh3uHYTGE4En/axHoQxqdzV+kxjvTPw2VxMal8ua7CMO9x5g3A6GvAfJ6zTJKzEKUgjsyvDZ7OxKYmhmWTbmXzB2ZlYAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(54906003)(71200400001)(122000001)(316002)(8936002)(4326008)(478600001)(66446008)(52536014)(8676002)(5660300002)(26005)(7696005)(33656002)(38100700002)(38070700005)(55016002)(110136005)(186003)(66946007)(9686003)(66476007)(83380400001)(64756008)(76116006)(86362001)(2906002)(6506007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f5ODMQU4hSNYHP0gpMWQWrFWZHiSGCjh4SIFz9PnFBrh88mzBrn7xMHK9Ez/?=
 =?us-ascii?Q?AiH5qZVoL1gPD5QqBRqPeDNcJ0kLvDT02Wtg1m4xvNn5WC7DY1IRz62n6Ycw?=
 =?us-ascii?Q?ko6JFpaVD4oJyunrsZSCuLXqrEy2snLHC+McirOBx6wGs6e2TpKPXN9oKM6H?=
 =?us-ascii?Q?hPjNUOBBsThZYrDbg4hN2Mt49waxrRfAgVgxCmX4wpRLiKTDKov+kxZ+v3Sk?=
 =?us-ascii?Q?5tz4u1IPZAKfGjWjpsXFCkNu172/G9up8X5z7j7lkiOqeHp9l+Hij+QiH73v?=
 =?us-ascii?Q?/bua48LGw532reVXd2tfQrqQsAu5VKgSj4WUIwblAq+oAaUeWk9Vbknj5vp3?=
 =?us-ascii?Q?uMKR7v4wJM+ey4t86T89jGwWQkrUGONYtNZB48KXn85tU7aWzgi7E4cF1/Hy?=
 =?us-ascii?Q?zHrr149Fz85+PDKbNq0LTXAqmF68dIx/LAUmeuDiL0VPwYSa0z0L9W4Jvy/W?=
 =?us-ascii?Q?R8mYM9iJbOAGCJc4UE4IituqoIGyWLsKGTSzzwnkdCzl49aRENhlTdDcU7zn?=
 =?us-ascii?Q?kET+JGpAkZJ6ODCbeK5xu4sEWUYnTDhMdAlYsvX/d0WJrHc3rYW3rz+Fn6HP?=
 =?us-ascii?Q?aImhJRCZJNt3uxU5mqZD0XMzG7pcNH1XyQ+xp/MaCxQBctOuEzNyth6kdDY3?=
 =?us-ascii?Q?JIM7ZrA2kYLDYWUPPgLfdACoaszRAxUTtriugJK5D7Sp2UziUFZYxzugbWxJ?=
 =?us-ascii?Q?B0EZw9DzAzdXAJeVTuawi3fvLokf5uPpRz3+QwNHT9qr+c+nh07ORu/Xba7z?=
 =?us-ascii?Q?RvWcSCIQB3R9Kqtz066oXh7fKjDdyTV84GXH5YaNj2unTrBs8HfzW/tpo0Fp?=
 =?us-ascii?Q?3DC3W9sqaFH7Ox/XG0/mpwL18hdCK2zSZIldGLiFpl2oZeJYk4h5g9n97Ogb?=
 =?us-ascii?Q?WZ6aKXHOXz4UftJmnfWruVpdxPezhTO8aJ7UrId6qgbuIf3E57+Gp4h0Baa/?=
 =?us-ascii?Q?ZjZZGayR0yxdKlpaiwOrFG2mKfW+igSPKW1fP+DV+2JuNO1OXxtojhEVPq7b?=
 =?us-ascii?Q?oWsn64BayisKk1G6diYFDYw3OnkSUYUVosRkY5GC51MxR3QZFLXZtXea0GJk?=
 =?us-ascii?Q?h9f3lPnGjg1j2d04S81/R0ZM+1+3KmXtNKnyhty5A41OjFePmlL9g2/wvEi5?=
 =?us-ascii?Q?6J3nC9gK7SsGFVrGUVb6PgcmvQhur7Hio4dkWSQ5WFdGNP4zZM7FEcmX4ATI?=
 =?us-ascii?Q?3BsRItT3B58rT0Og/ncaMZZNZRhlVJnKQopgeVJcksLrDaKSofRDFytJ6pZO?=
 =?us-ascii?Q?vBnzHtddznNrghXmM39NWZ29O2p0gTsHpYwEwP4LfCKY20mQlgsCMAMdtSnx?=
 =?us-ascii?Q?mRsxLqvKYQeXIzuuvrB241G5?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 466a66c7-9528-4d78-3834-08d9683817e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 02:20:37.6732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4LqV3E9aLMCalFkAtwdL4ErBT17qCmdO/xfNqSC7TsewtfbBskxEaUvNvD1WqUxoiE2/NmGFacDHNq6vAepPIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2851
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
> Split the actual noiommu group creation from vfio_iommu_group_get into a
> new helper, and open code the rest of vfio_iommu_group_get in its only
> caller.  This creates an antirely separate and clear code path for the

antirely -> entirely

> noiommu group creation.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 99 ++++++++++++++++++++++++---------------------
>  1 file changed, 52 insertions(+), 47 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 207c1bbac1829a..d440828505d9d7 100644
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
>  static void vfio_iommu_group_put(struct iommu_group *group, struct
> device *dev)
>  {
>  #ifdef CONFIG_VFIO_NOIOMMU
> @@ -833,12 +789,61 @@ void vfio_uninit_group_dev(struct vfio_device
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
> +		if (group) {

no need to add taint if group allocation fails

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
> @@ -854,7 +859,7 @@ struct vfio_group *vfio_group_find_or_alloc(struct
> device *dev)
>  	return group;
>=20
>  out_put:
> -	vfio_iommu_group_put(iommu_group, dev);
> +	iommu_group_put(iommu_group);
>  	return group;
>  }
>=20
> --
> 2.30.2

