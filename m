Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF383F8063
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 04:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbhHZCWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 22:22:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:58995 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235677AbhHZCWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 22:22:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="217371853"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="217371853"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 19:22:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="508212737"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 25 Aug 2021 19:22:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 19:22:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 25 Aug 2021 19:22:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 19:22:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ct4nKRvNHaxD8cND1+GAB6gahmN1XOtTsCZS5c9WzrGhnawSFSO4EyVOqO7uiiAfP6SixfM8swIfHONTcTd1CabBbi4rPDHPW9SMISVL3CkrDgdn307BL7PnsWRspycJrEpzWW7Y8DTrO7yfNRKGCRK3IFZgvkWdLFIykR+mUsV+QjYvS/3j+GrPHAIEb2LRCWWqfg8JFh61+XSi5BsdRa7ZhOCznlP6+6kTGgx3Jnfv/DDe1PU/DbyXmeKNlBk1S7ixN4e9L3huihNF1exgfBhHV5i3DhwPet5MOfdfkwxPwgXk2uw4r7IV26Ns7tSm9va37433MVscotdI/zVKiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCtVuCIzYXXxxyjR2BLSJR5raHKbhz5ZETYThTAME/w=;
 b=e7bL+g6/qrhcSBvLdkVLiihUVP/0EG4Z4vqEK1xhqo7KPN1CJObTAgsuWjRC0GKnK3KB6peqr7M/OZyEGF/n0wQ4MHXZQZcfY05Kup+DvvW+ZLuF7ZIgJKS6esraBrRvxYtlBwxog0PnCiO4j7kkTS1URwDJ1iJRiZq6XCpvCIcfaCLpEWvqWpCyk3JbrSGbfq9aXMJVuOCkW6xlgewOA4ot8hGFfpv31VB+Sg8YPGo2Dgl5gNFmqMguOSzapmPoXPL4tUdOfP+C1TyHCDA/dfuv4deBYRPEaPgEHTpXPQkn6LsXUmELgqL7KScV8T+xczhPa69nyAfzgZQor9Gqig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCtVuCIzYXXxxyjR2BLSJR5raHKbhz5ZETYThTAME/w=;
 b=ODYgHQiTi9EISdM2kzdgO/wcW5iP3o5onZ7tsefkxXttkzk2ulPljhxHWnH/DEARqkJ9zLXjzlsrQQgz1Y19H1RHJlnZA2xntpC2GXSP/xQhPESKS4KfWIDjhOPAHkXx5nd72kaf62RwLg06cKyTbGVE1oCalzwnvvS6dwSNE5Q=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1267.namprd11.prod.outlook.com (2603:10b6:404:3d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 02:21:58 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 02:21:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc helper
Thread-Topic: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc helper
Thread-Index: AQHXmc5KF8hmGXn7/UyUpLsNBnaHP6uFDmoQ
Date:   Thu, 26 Aug 2021 02:21:58 +0000
Message-ID: <BN9PR11MB543356EEE0EECD2D2028119D8CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-5-hch@lst.de>
In-Reply-To: <20210825161916.50393-5-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: c3a3fecc-16fc-4208-5753-08d9683847d7
x-ms-traffictypediagnostic: BN6PR11MB1267:
x-microsoft-antispam-prvs: <BN6PR11MB1267B30AB279FD806421840E8CC79@BN6PR11MB1267.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sWRDIw+T8pI5qEAgiGYvX8FROppaM8Y7yk3UjW5IdUpvEGRCHq7k5vW64BuTTMCJj0Xy9Y3RbZ4wR4t2qIPIWDcz8aTgrTDjzWs/MHTEOJuJ7pdTaGHZz000rwqguDL7hObpxWKstNrmIYZY7b2dqTM/MFNnBRGe8lt0lFrLYR3tHbETD9eE7s74uPOBW1EniiQ11o422JmeHuRLA84FOBlTvwpJSbL39bzLdfKA8B6Z/wHR+n+VrqjwKU1GU+v4BB56s3KNvvF7IRs5KBKb16e6/JsavS2EEhmptm1AWImo+AkvYzR+7Q5z8nmlB4QsqCFF2iTgN4Oue1nD0g37Co+30TpC6JTJ5EInc14ciV/wzmRvrxldcCE9pkuO1ePJvfztY8viBNYKvW7m2uz+0L3zzoJxx2R1dhr8oI2QG8E/SUVDaM15UeIF3Qc5wLmI2ZLApmIG2muND9vxqYDEBtgbly9tTSLqa93Mn6CHegGuxZp0q5+slhmYzKdn8r2CjmfIqSCDiZ4hxJWys0bQLy+O2bZzMqGSFLueJQayUZT4lRZHmlIIrBN7pB0pPMoV5eow+29cBFXGbd+nFiraJQWTvDY8y9p78Ieiv6zIu3QvTRTZ4FsZ8V5qnOfgLPlRvjT/YGHPcP/haddXqbEQxb7pFt11Z7QZpmhUwOUVZMafmSI5DOV3Kllh3SdVR1pNVsi/mSUAXSiVt4dM2kR/8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(76116006)(66476007)(66556008)(7696005)(38070700005)(186003)(66446008)(122000001)(8936002)(4326008)(64756008)(55016002)(66946007)(316002)(8676002)(9686003)(5660300002)(54906003)(26005)(110136005)(86362001)(38100700002)(33656002)(52536014)(71200400001)(478600001)(2906002)(6506007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gOSNKFYXzMugc/1C3VVBEfj5NczshBIwSTDnnT8R+80A7KUjWorF8DU+a39u?=
 =?us-ascii?Q?dMR2Td8Lq6hwqIAKt5kaVd7toQPCHXbfJYoiBWMLQIi6Yo0nR/uEXLt7ksdv?=
 =?us-ascii?Q?9c78VUBv5eyNBr9DHSysukW2s+oIxL7q0oNs+z2a7Gzqb1fhiu2ehZmp06OW?=
 =?us-ascii?Q?XN+KXHzS32WVDHIRJxYrRKxI4PNLkmxskHFwiovv2OSxrDbRO8mj4K7/aktJ?=
 =?us-ascii?Q?Ma74NMtGqOcr2WKZHzL7G7rbkXOF9aR7Y16U0Gum/4zgm0fgoqbvXa2MrO9s?=
 =?us-ascii?Q?C+nF1nnd8kJNP+hLSUj+f3qB3JkCBD8Q0dAaDUPTqeSqPgbqkoSyanc7dnjd?=
 =?us-ascii?Q?eRrlaJCK8OxMBtsGzZvHXRuPbWv/SCOpHmnLTL012olcr/LseXDghBCp9MJL?=
 =?us-ascii?Q?rWe+XmksDkx9VuujHG98aNBvbrNFibYZUq0NJnumIlXI00OA3yC1cIHiPNVe?=
 =?us-ascii?Q?wf2k9rAy58nb+69VydV4nEK4w+Nvxefend4HAEYH7mM4WKE0PgH8HPdYPjCv?=
 =?us-ascii?Q?7sDB4Nx/WMzb8aOX02uK7xFh/0AVWGQe1cryBovQOqSOdV6JLlo2jnNv2t/A?=
 =?us-ascii?Q?HEEof/eh7ZLnKK6bHhdHevqq3MLTNhnLDbq4IaZajfVJvgJ5Es0liCUzTxYz?=
 =?us-ascii?Q?jLjdTx9AyGmwFP2c/gDEiMDjC4A9GywFG+vvp7NQA0NxTz29LR78UJByhydn?=
 =?us-ascii?Q?WEYf7tG3JbzVAV14QQf7fI/csu5TSfBmCVqgP1Ws5O6VMNg4viKgJIG81+VM?=
 =?us-ascii?Q?Wj4rac4g+fp32dfEAbFymkyQZXxNUavw3iFMweGcPtiNNJABPXlvTaeA4WKE?=
 =?us-ascii?Q?uI63Jj7dxd0Czyg+ZtY3bUlKk2Ez2KJ9AFGdddV8oUAzSo0+bZQYnWYbH66C?=
 =?us-ascii?Q?hOgymV8PJSjFSlf5rh3vmsp/njTDFv+RatHjb2y0593zZdCXwdtC2xaBEKDh?=
 =?us-ascii?Q?vPF9uSQvZn68knQrv5wzwBkBIwBzTxWzChLXXJctv8pNs6xG2/Lu8X5QFme9?=
 =?us-ascii?Q?qwEYu4kP6NwCZuB9eLwmSfijJxv6VTzAIR1x+kHlWkevtPI2krExZywJwMle?=
 =?us-ascii?Q?oNfzVJk8rkUruFqH8A0pqTR+Jj7cImLHnC9QlW2dEjCOHbfB16/eiaM3hIhs?=
 =?us-ascii?Q?KK+eCeRW/X8XmYRsLIIRXclNtHAA+NHgKfqxlsfldvs8mmF+TaZixL7mlCwf?=
 =?us-ascii?Q?5CIPGL7eGf7MIbU6P2XuCE4gb45MN+Q/fTY/MjUb5JN5iV3KAjC/nN0qbfAU?=
 =?us-ascii?Q?kSwLWhTbS+Xa9ajh1UnMmYlEYpeykpweE7ev0N6fm+KcplNjzzqbmfWP3/OB?=
 =?us-ascii?Q?/IzQtO4Hb9JQwvzc+b0DaywT?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a3fecc-16fc-4208-5753-08d9683847d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 02:21:58.1113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1pbvxV9OQDgDvloc1MjN/xZZ9TY1dbNTtPXJQHs9pJu4VBDlS4IANMSO07bx4b+nEMekzRT5XvXeV7VGOi/QUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1267
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
> Factor out a helper to find or allocate the vfio_group to reduce the
> spagetthi code in vfio_register_group_dev a little.

this will need an update if my comment on patch01 is correct.

>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio.c | 51 ++++++++++++++++++++++++++-------------------
>  1 file changed, 30 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 00aeef5bb29abd..207c1bbac1829a 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -833,10 +833,34 @@ void vfio_uninit_group_dev(struct vfio_device
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
> +		goto out_put;
> +	return group;
> +
> +out_put:
> +	vfio_iommu_group_put(iommu_group, dev);
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
> @@ -846,31 +870,16 @@ int vfio_register_group_dev(struct vfio_device
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
> -			vfio_iommu_group_put(iommu_group, device->dev);
> -			return PTR_ERR(group);
> -		}
> -	} else {
> -		/*
> -		 * A found vfio_group already holds a reference to the
> -		 * iommu_group.  A created vfio_group keeps the reference.
> -		 */
> -		vfio_iommu_group_put(iommu_group, device->dev);
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
> -		vfio_iommu_group_put(iommu_group, device->dev);
> +		vfio_iommu_group_put(group->iommu_group, device->dev);
>  		return -EBUSY;
>  	}
>=20
> --
> 2.30.2

