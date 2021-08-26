Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814F63F8009
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 03:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbhHZBuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 21:50:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:22321 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhHZBun (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 21:50:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="217649899"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="217649899"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 18:49:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="684714750"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 25 Aug 2021 18:49:51 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 18:49:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 25 Aug 2021 18:49:51 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 18:49:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqYfef+O+QZ9wP2wTWmT/2odKlBegZjtBRUb33z4zeU3+nBLSU/B2P63PwVUG1PWp/pHt4YmXkKUdCQiIkzexszZRIXDfmtuZV3ugG4CADhbD1St9I3aELuFvuA4Lslocmcj5i1rvm5WuGgshBi2N1SPgpZw8CMguMFueJnRWuBwTmH3BfWvJAmV8MMxst+M93PoQnRHL4Zm+mfIvzhW4xIpfspGBbUlN+Xqdbl/0J3FXiwOx5NCeqm0isQqK/4nX7WmhwN6QKCWSTe0BJmzKI51Mj0i5cv+90z62NbtXqdwmSvuLNJ90+RUyQYHqYqOhY7YhxqECbIRD0/ndfWTJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xJ1FOsdtnGhX2l1IEPaTsa8Vza/Y9JL4zVmIFbuOgY=;
 b=CpNJEXxp8LSp5H73gKyBYmxqm6C9x5gNDb5h8Qw9Rajh47ys+RvnHEowUJe0jOUVjpN92kpiWjeVAhO4BLZPoIubXzjtsehPiGDVeDB09KVeWVxqQbYztQycXflu4NrfWNqew0caZ4lU9RnaumbWg2kocgw6fDJ0QjfAYVx2k2L5cyWv97nHMjmoNgEuFRtdjIEXBfb/YX7ier4Nbi5S2akPCHX/eip+LbXz9uDXSPnM4/Mr4fUqXBV/cjLCMGsJvOBKI4Gu2x2rbZ+etqjF7LoPvNP5xBqiWLb8i1UFqnuh4eaeiHAw5d90cYovBo6Zxm5CgvCB6z3R3L9cNTQs7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xJ1FOsdtnGhX2l1IEPaTsa8Vza/Y9JL4zVmIFbuOgY=;
 b=jFa5EgrjovlBGh5oGpgfXG+0WAJCAhj+aoM7ApWxjvvjZjbn2UUwAeXqkHy5zp89I/G5h3yJJW6XBMIUPQNmFfRgotzZ4vitxLQiv+kNE6FLVBgi1mm+WJwPEFfkT+DEg3lA796LcMnZrW1ghWdglxu99depWI22REpr8iI7lgM=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2146.namprd11.prod.outlook.com (2603:10b6:405:50::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Thu, 26 Aug
 2021 01:49:50 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 01:49:50 +0000
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
Subject: RE: [PATCH 02/14] vfio: factor out a vfio_iommu_driver_allowed helper
Thread-Topic: [PATCH 02/14] vfio: factor out a vfio_iommu_driver_allowed
 helper
Thread-Index: AQHXmc34wmLaH/X/wUiKAsKIe+HwZKuFBZ+w
Date:   Thu, 26 Aug 2021 01:49:50 +0000
Message-ID: <BN9PR11MB54338361DA47BCC2F07713828CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-3-hch@lst.de>
In-Reply-To: <20210825161916.50393-3-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: 50fa147b-1205-4db3-8d48-08d96833caab
x-ms-traffictypediagnostic: BN6PR1101MB2146:
x-microsoft-antispam-prvs: <BN6PR1101MB2146EDB14DE2496E9898408C8CC79@BN6PR1101MB2146.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:459;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VddjIfRA8irpchoXRdHvkbmbRf4qOc9slCovQhdinxQOmZaYtuCD0wrrt3m0z4eQenkcOD+vSam0cLLoMB/YGJie1/i1mIeodKPFZOXjMble8vHz4VgJpoZnM+vM+92L+g+lW3n24xvvDwr/Rjfxw4jdlaEcVmXT5933n/cjLcoFoPq//XiGLuNwlIp9HOThGY8Ahny6jTflhX7P2HVdrKwx7GgHa9kRspnlmk7C03Q+efY1j252fDlbLrVRUg5phrLzrAfoR0DSY8jqoTW2PYVg8RDbHrRFEZq7+JVptR4fvJDtRGX71lOFXiNyBcEB8Epzh4EwPeoMO+rT+6p2FqqFoOcwBikrXwS1MlwOll4c9wc9IDWp+LwCmjq3LjGp/OCA+6vGMr4Kaxk1l+t5v/Xp1njIIlLdKNI/5ElST+GXbUp3P5jC94SqWw3e3hPCYHrcuAuscy7TWPB8AnVF3OvUMCgUfBXr+5leBh/ykQ318CkHSF+dOH8z9d+ulTdtk9l6Mvc6epuqfta0wAYEhnO9nix3eELBsFenrJEbnRLJDfIlk4Pnppr5RXrhV9qr75i3lxu0Wxf7A6mxBl6he5TC/6XMM8sOJU3gfLcrN4uL3dx7u3OZ4WjnnV5i2zGnAust1pJMPbXYmNPCP9HMlmZj98lRt4v34GBui437jJHf2wyv63CQanZIXfT2bzXRXfEoDeATDjUr4xt2YF9x1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(83380400001)(86362001)(122000001)(71200400001)(76116006)(66946007)(8676002)(38100700002)(8936002)(66556008)(66446008)(66476007)(64756008)(33656002)(5660300002)(110136005)(55016002)(9686003)(54906003)(52536014)(316002)(26005)(7696005)(186003)(38070700005)(2906002)(6506007)(478600001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RjnuNWNeDTQQ1hs+li7Wr48swADeP4pLVjlpBKhbRPq7LWmomu0rrWj1tYKt?=
 =?us-ascii?Q?/kQcE15fHP6K/l+iK2UKd/R5YwRkddyN4wXq89iacZ53yWaJRqABSM219g7L?=
 =?us-ascii?Q?bpR8spl+AH5mSWFguYl0/xZWEZjC8OA+K3O/8zL50h1s7a0amgXGABBR9Id3?=
 =?us-ascii?Q?hQy9vCGFcxsNJL4454aFfAyx4b6vmgEwJ36U3cSmSe5moePsxZaKdFrI6wX1?=
 =?us-ascii?Q?ytDic6693TxVEbBUyJjzDa8N1qp21/XEBKr8ugYl1S6OVQayUm9mrrvcZS4+?=
 =?us-ascii?Q?emVGWRwUueVj//WabgvXUzFXGq16UhHM4m0uk4XQFsKquSUAjud6TvCOyMiS?=
 =?us-ascii?Q?XgNd1+ZYziIkX7rTpj4faK+m0E+GF7ZwSxbbt2yGSCLVg4B6l2aEm3jQAFUC?=
 =?us-ascii?Q?j/+KVZSnNQYuthYwg719Jh9VrT2DyOgQZafG0MYsNQ0UKIn19q7bL1Bx54A+?=
 =?us-ascii?Q?DkO2hD6ic1phPpDn6zmJl06KKQ5BvgD9h345Md8ghdSHxPGhwLNQc1vsSCi3?=
 =?us-ascii?Q?BJE9Zew7GDQYZyfflWmX8ceDhCb2k4trqgQ7dijTjRhzmxbRLWDHla6cPH3I?=
 =?us-ascii?Q?sinv9EvJLq/WRJGPO5vCV9LEHfHfFi3dUWaxyzCVWY990iI2Tw978VoH7O8z?=
 =?us-ascii?Q?hMAc9J/5Xw/fC7Zi1Nyqba2ECaS+m2zLIQkcLudqk/qfcN3bCTZjdEsfhKlt?=
 =?us-ascii?Q?+0+U896LfeSrCFnyyaVh1t3NumF69gwARAuY9nTe2Me6+32nNhW70awV/gjN?=
 =?us-ascii?Q?J9bdWGGtTb0UslokooVCKJUeGOOkjZqVKjnV2Xjpse+xZ/pnNn4eSU3peY/O?=
 =?us-ascii?Q?ha462m9dLNnRpCxtvc3LC+8mDsccHbjFVSybEcUQWfzIVGY5HTJwXA1aUZRS?=
 =?us-ascii?Q?WxJL4ag2xH696NbGzmZOEZJj42ej4Vfir2NtX8jla4SP+tMUF8a3TACvs9Iw?=
 =?us-ascii?Q?9K9nCz+RRe6c0QV27iDx77cr7RO/qGL6KH3ceIkOwrtx5rudatlygW0Na28u?=
 =?us-ascii?Q?ykSowFHWK7xkKE+25C9O91cIdcbi02g2X4J9Btp0NjM1C+CYLXvpjArqLyTE?=
 =?us-ascii?Q?xe3x/gE1DB5dSaJHmGQFSZjUAr3oFJ7FFh5yHJIGRjQEt+vlp2DfpgjiPfeM?=
 =?us-ascii?Q?CbF+/TyArri7DM1KymrxY6PftB0zALz7kFjXzlz+smJRIrPFRA0uqm7soRYR?=
 =?us-ascii?Q?7bxb35+06Q4lr9ow7pUcHfcadMgM8azjFmj09YZMsqRsgDL9WjEKSrpWvGfx?=
 =?us-ascii?Q?+G+oUGx0bpClXtka5H0m/fXioj8OUU2NMEHrOYWmAM84MbmPbXKpDo67GhJS?=
 =?us-ascii?Q?y5FPxdeDCYYlFJ+T3oRfJqXN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50fa147b-1205-4db3-8d48-08d96833caab
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 01:49:50.1003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kQT8hsgJfw83YfoW9GOl60nV2o7d0jOU18dW2WZ/7GbvNDf74q96caSnlsMqyHMCHOmP2VYyLfBnGr4lQ5osUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2146
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
> Factor out a little helper to make the checks for the noiommu driver less
> ugly.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 33 +++++++++++++++++++--------------
>  1 file changed, 19 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 5bd520f0dc6107..6705349ed93378 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -267,8 +267,23 @@ static const struct vfio_iommu_driver_ops
> vfio_noiommu_ops =3D {
>  	.attach_group =3D vfio_noiommu_attach_group,
>  	.detach_group =3D vfio_noiommu_detach_group,
>  };
> -#endif
>=20
> +/*
> + * Only noiommu containers can use vfio-noiommu and noiommu
> containers can only
> + * use vfio-noiommu.
> + */
> +static inline bool vfio_iommu_driver_allowed(struct vfio_container
> *container,
> +		const struct vfio_iommu_driver *driver)
> +{
> +	return container->noiommu =3D=3D (driver->ops =3D=3D &vfio_noiommu_ops)=
;
> +}
> +#else
> +static inline bool vfio_iommu_driver_allowed(struct vfio_container
> *container,
> +		const struct vfio_iommu_driver *driver)
> +{
> +	return true;
> +}
> +#endif /* CONFIG_VFIO_NOIOMMU */
>=20
>  /**
>   * IOMMU driver registration
> @@ -1031,13 +1046,10 @@ static long vfio_ioctl_check_extension(struct
> vfio_container *container,
>  			list_for_each_entry(driver, &vfio.iommu_drivers_list,
>  					    vfio_next) {
>=20
> -#ifdef CONFIG_VFIO_NOIOMMU
>  				if (!list_empty(&container->group_list) &&
> -				    (container->noiommu !=3D
> -				     (driver->ops =3D=3D &vfio_noiommu_ops)))
> +				    !vfio_iommu_driver_allowed(container,
> +							       driver))
>  					continue;
> -#endif
> -
>  				if (!try_module_get(driver->ops->owner))
>  					continue;
>=20
> @@ -1109,15 +1121,8 @@ static long vfio_ioctl_set_iommu(struct
> vfio_container *container,
>  	list_for_each_entry(driver, &vfio.iommu_drivers_list, vfio_next) {
>  		void *data;
>=20
> -#ifdef CONFIG_VFIO_NOIOMMU
> -		/*
> -		 * Only noiommu containers can use vfio-noiommu and
> noiommu
> -		 * containers can only use vfio-noiommu.
> -		 */
> -		if (container->noiommu !=3D (driver->ops =3D=3D
> &vfio_noiommu_ops))
> +		if (!vfio_iommu_driver_allowed(container, driver))
>  			continue;
> -#endif
> -
>  		if (!try_module_get(driver->ops->owner))
>  			continue;
>=20
> --
> 2.30.2

