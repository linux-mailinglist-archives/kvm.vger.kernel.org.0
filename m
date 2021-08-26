Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127223F81C4
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 06:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238022AbhHZEdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 00:33:06 -0400
Received: from mga06.intel.com ([134.134.136.31]:15317 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhHZEdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 00:33:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="278674130"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="278674130"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 21:32:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="474073175"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 25 Aug 2021 21:32:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 21:32:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 25 Aug 2021 21:32:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 21:32:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JL+5/mn1bKro1k08z0J7fhDB8CvHJXUHFBM3mlDFaal6cnKLL7cvV9CvUW4tcmL2ms21f+Avc4YIHiUEaDJ10SNBd0x9zdB+QD+5fULRuFHS0qptCfR+ViP1T8Leb9hBnqcyX0kRrSB6S+oAU1ta1DhWQ0m/h+jl5tnH0dzfqccqrYbYxnBJOt1mEe3YWJj0rQLmkDrSBhmaty/84M8cxbVy7JIQHjIXIK0v4z75UqTcGrsxeDQZ5QDnZN1PPkcsY7mL2P56wmyB45SOKej+f6P/GAnD6reh01nZOvI2NgzshEhiVq5QIQweoBykorsjXaKBJkWOKEKOYrh6tV7VRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5RE6BP5aoSxiet+xajV1Yd8HLDBmenR270lFUfzu3Cs=;
 b=FwKmJMMgPRjdRCs6KQxuYIYEgbt6aWXNw5mNBSwB+VZKKAx0BBR4ajtqQ2kQAu7ew9/n7B2cd7cSELiEp8QnrSSczO6VZBEL89bGoHRBelCB0V2ONXzJ63+Db33Tckf7VorbTkQeIBNA3HClAMEuDtntlAy352o42JJYjdGvEvyN5Z9zI5RqAohHk/ultwKZK5sA7jbaFz7kNqBILDtGqaZw/gWWB2VTHFK0IvRUQHpWmhHAy6s9B8g4TQvuh/tOkx6s3YiJa1NE8Up2R8vCwPgjDtcJFG90b02xsThMerGBHYv4/q80/Z9tuhVx70Rb3jVIl21dT5szEKuCQ5OHWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5RE6BP5aoSxiet+xajV1Yd8HLDBmenR270lFUfzu3Cs=;
 b=vLz2G0Dz1vgXzDBu/fgBaBFFfWJRB74WPRJBEw6k4R0HIuHMn3tq17UhuDWtQfaec4hekdv1HMEpcjKiSKcr1fArq/WR01At/9jw+vJDhTQ02JSeEPtOCc0UOyirJFG9UU7pUqex5vTUyefEASWodt3Z91ruZvlb1bnp71mqFUw=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN8PR11MB3601.namprd11.prod.outlook.com (2603:10b6:408:84::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 04:32:01 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 04:32:01 +0000
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
Subject: RE: [PATCH 14/14] vfio/iommu_type1: remove
 IS_IOMMU_CAP_DOMAIN_IN_CONTAINER
Thread-Topic: [PATCH 14/14] vfio/iommu_type1: remove
 IS_IOMMU_CAP_DOMAIN_IN_CONTAINER
Thread-Index: AQHXmdBDpMOma75Z/UyaCoPRRAu14auFMtFw
Date:   Thu, 26 Aug 2021 04:32:01 +0000
Message-ID: <BN9PR11MB543306FF96BBCEAA7B97681C8CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-15-hch@lst.de>
In-Reply-To: <20210825161916.50393-15-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: 69f963a4-5843-44d3-e4f7-08d9684a730f
x-ms-traffictypediagnostic: BN8PR11MB3601:
x-microsoft-antispam-prvs: <BN8PR11MB3601C0E7199AE834B6434FE68CC79@BN8PR11MB3601.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:248;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YZAAlv8dDUT5zW+acWvE1gtYEOArQVusHxvwGp4DpyIT6r9Rwp3l/X9qUYLsRKVeoDpOcy2rT9HQhXvBRjgvTRFsRoHDSjmHPQ3tLynbJzE2qRn1TpfOYZMO7FivzLnIHZfT+z6fIHm++ppweDjLlMNT/o1/oJ9pGwBWzUa3arwyCV33GJ92GXilnNnDaijarGtMWlECw5dIYJagYgAivWWNvTPO0hmfGsFvsR/sfSdBiKO0uTZC0Bfsz2UMW2g84coXyBIjm1/Yy8zCUvKgklbBfYXIq8v787cM4EdRO5307B4sHoCmZxDfXWnNaWYU0W9xxkBso3/MHDTgxtqY54Uvhr1M2qQSeIgqyeNWab+1aXwztGiCzShNXLcLT0oeZRtP1NhqMzNossHlcossX3cCdKlkbfRWxU2SbTpLBPVwbJNhV5c9pNmu7MJFVlYNIqOJuopBTrjheGUyGLxGbBADh0NJW9dnasHR6t358Z9EhhtB+b6iBp/Up4WDAY1NmYHB9AYFa7shTIzBOdVECQTCXUEfXRD/LUFRc7fD9wGgPfotw/wGhkPmOX4TOg/JSQSdceMwJjsELk4C+dt4m2Evl29mj2BvwbzTV8BZ3I1gXJn/fOxxRYM3cD5XX5DaqzG1S1QtpHZJOKwQLGanti9wETS4NgdLofEaFyX0+aiYhIkiqV7yJ2wX4tJfzD1zJtQzuJ3nMLFep36Meoo9Nw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(4326008)(2906002)(33656002)(38100700002)(83380400001)(186003)(38070700005)(26005)(54906003)(316002)(6506007)(9686003)(7696005)(86362001)(71200400001)(478600001)(52536014)(110136005)(55016002)(122000001)(8676002)(8936002)(5660300002)(66946007)(66446008)(64756008)(66556008)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?COf+6t7rC1t+AwR3VmRWeshH5y66StRRGJFm3aPSDdLyTgLh6DwY4HaJFtvW?=
 =?us-ascii?Q?CJFU4bbRO9m/pLAhvzuYvQzyHvCA+6aisXAFO5I19jIy0298/sSz+G08fdsu?=
 =?us-ascii?Q?PZ4IJgheE/fg/+jLiA6uNCHl2xMjYp914dQCvtkJj6vGQKncOIWP3kfTwmIz?=
 =?us-ascii?Q?GL+C5RWPlJmu2Ex5lmT/iYnTHf9t/aAEtgmzs8dSH4J6q4F2titoiECqj3Fq?=
 =?us-ascii?Q?a+XcAqKYsramZattffMS1pXVZBZwmj5DM2914autEug+gvarqr8hrDx32NDr?=
 =?us-ascii?Q?9/8mXmSszrfPeaKyFrddpwxs3YHHgQ7RdiLMGYBfC4kDDYKP6oH4z6UalFbv?=
 =?us-ascii?Q?cw6s5akqx99LjsT7R9VmyvJDl2t5TZ49Sdbq6XLkjiuAxtCw1TF9YhlscYzW?=
 =?us-ascii?Q?X5Fw7+lDNeMsds6rjKRSJlkksO1R92yiBr7WyiZIMm+ZsukTDhRg+Wi5CZZ4?=
 =?us-ascii?Q?l/e62qxnIBy6GCEZpSeapTpYXILonXu5t4FkLX0IBdwEFSNb5DxI/NMQw7ML?=
 =?us-ascii?Q?cTGH0iFpdhiEO5Ydh8Y9hYfGP/L/rtsasC72EvT5USMyvRhdG6bpep94KJnE?=
 =?us-ascii?Q?9tKVd0KVcvK65RJ0zsh8VnuOtkgkPE7kOs2Qp96jZPH0Hw4C70YjeFl7EAi6?=
 =?us-ascii?Q?+Zg7e40F7rn3Y3ZQ5u0gRl8U8qGyA8txq/MHXeYV5+0M4Au3jEMJE0N1yBEf?=
 =?us-ascii?Q?EpmbzMp+RgOGNvdTfWiJg2+5lw51znBKmhvYKwrJ/Tas87SGqaIpmHithtLN?=
 =?us-ascii?Q?Q1z5pfvCoyeI4/SxYKL4BAi+ulzwv+S1NzXi/Qr9FAcpMn2gpciYR6HfQYE5?=
 =?us-ascii?Q?vxxFOIgVzlR32iCS4R7WFYWkn4JsVoHZOu1rfSoH2tPcO1nfJHji0qiBi56y?=
 =?us-ascii?Q?zg3HwCnXA6SNttpAGj/+DGlSiuVZSOHbRBjP5xk/b6KJGiclSUO+dCzhGmvF?=
 =?us-ascii?Q?fQ0U2SH98MlACo+XgG4o/7xF4BXCfpGnNIpYmHqUnRC8tdGeVyiaoZy827Y2?=
 =?us-ascii?Q?t6C6joRPxWsixqEzC2PBQLNvKH9+Nxg/Bbng5yYgCgjI1rVR0DmouXIOOUZg?=
 =?us-ascii?Q?Teof0fY7DWesHYchh6T8l7pXo7DYAnHyq3LAhe5X2IWYJZMT02hcwfYhULwJ?=
 =?us-ascii?Q?xDRry3hoISUCzzXziD5xgGCGBhNhVX1IkT/vQQ+piU4dqjnQsiAgpSzc64B0?=
 =?us-ascii?Q?49Nsmb73jshopNb9q4liu7+cShBzWXXhovD+CJxEaSydPGL3sAUNq5Wscd47?=
 =?us-ascii?Q?/b5j+twwHWKL8mT10BgbjVjq1WNvL5fV7z5kk+gV3VX+7qvIziCvxOA6aY3t?=
 =?us-ascii?Q?e2qd4yQyjruFJVUd2XtO4bzS?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f963a4-5843-44d3-e4f7-08d9684a730f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 04:32:01.6238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eJGvX+JuD00BZoQFYuC6dintBV/qvgb3yaQiGCwvHfob7drC5I5z0rXw2TlTh+1Jv//3MZCptxlOGS4beGTZCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3601
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
> IS_IOMMU_CAP_DOMAIN_IN_CONTAINER just obsfucated the checks being
> performed, so open code it in the callers.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio_iommu_type1.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index 871cd2867999cb..7ecf5ca01764a5 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -140,9 +140,6 @@ struct vfio_regions {
>  	size_t len;
>  };
>=20
> -#define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> -					(!list_empty(&iommu->domain_list))
> -
>  #define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) /
> BITS_PER_BYTE)
>=20
>  /*
> @@ -880,7 +877,7 @@ static int vfio_iommu_type1_pin_pages(void
> *iommu_data,
>  	 * already pinned and accounted. Accounting should be done if there
> is no
>  	 * iommu capable domain in the container.
>  	 */
> -	do_accounting =3D !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
> +	do_accounting =3D list_empty(&iommu->domain_list);
>=20
>  	for (i =3D 0; i < npage; i++) {
>  		struct vfio_pfn *vpfn;
> @@ -969,7 +966,7 @@ static int vfio_iommu_type1_unpin_pages(void
> *iommu_data,
>=20
>  	mutex_lock(&iommu->lock);
>=20
> -	do_accounting =3D !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
> +	do_accounting =3D list_empty(&iommu->domain_list);
>  	for (i =3D 0; i < npage; i++) {
>  		struct vfio_dma *dma;
>  		dma_addr_t iova;
> @@ -1090,7 +1087,7 @@ static long vfio_unmap_unpin(struct vfio_iommu
> *iommu, struct vfio_dma *dma,
>  	if (!dma->size)
>  		return 0;
>=20
> -	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
> +	if (list_empty(&iommu->domain_list))
>  		return 0;
>=20
>  	/*
> @@ -1667,7 +1664,7 @@ static int vfio_dma_do_map(struct vfio_iommu
> *iommu,
>  	vfio_link_dma(iommu, dma);
>=20
>  	/* Don't pin and map if container doesn't contain IOMMU capable
> domain*/
> -	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
> +	if (list_empty(&iommu->domain_list))
>  		dma->size =3D size;
>  	else
>  		ret =3D vfio_pin_map_dma(iommu, dma, size);
> @@ -2473,7 +2470,7 @@ static void vfio_iommu_type1_detach_group(void
> *iommu_data,
>  		kfree(group);
>=20
>  		if (list_empty(&iommu->emulated_iommu_groups) &&
> -		    !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +		    list_empty(&iommu->domain_list)) {
>  			WARN_ON(iommu->notifier.head);
>  			vfio_iommu_unmap_unpin_all(iommu);
>  		}
> --
> 2.30.2

