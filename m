Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2625B3F814B
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 05:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhHZDwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 23:52:16 -0400
Received: from mga05.intel.com ([192.55.52.43]:58241 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhHZDwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 23:52:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="303239586"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="303239586"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 20:51:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="444409825"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga002.jf.intel.com with ESMTP; 25 Aug 2021 20:51:25 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 20:51:24 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 20:51:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 25 Aug 2021 20:51:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 20:51:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2m2HOyLaKA3JktBHsluQBFkEO9P12Gv0RnBQEe7DJbh6V3oRDZm/4FDr6yMKZSayBTXvN7AfRx6vExpWI8uG1pMbsFNC8Q6+yKFsdG9nCtgeD3X8+YFGlsgpl+/4vECkleMPUJd7OOfRm8qQXEHFVdk5z9+UF7s9P5AIuVbfUfHmZDFlU7n7gcPrhTKnpJDr3xEkd/FCA/eUwQspHtSlCgT0EjwGd3GnhOPoGFRNQ7lN024yHa+BIfMZOKyoan5yL6qOyha+4mfOPoBDUaG9mlDJj/tk2g01f98vrYQSiYnvbMDQljKdOwDLVtvf9Yr5buAtFLEsXLUd1hCz1QvFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCCrc2LHVz81v78uhaSL9HX0Ary614vfufhALFcgU14=;
 b=oZktbArlQepCeArCQ5e5swlFbONpwE8LhuBITFm0fA72dj51BRIyf8I+2E6WtWUSJrOF6iStMlLC7a/95M4h4t1yLS3sXNv8CsHW0OtC9g3KOQardgDl0ZjfX/DwpQFTWTbcvbu/UzuWz1LcyR5JHuHU5SUT2IvQeLAxQOT3JgTMYK65s0pkFmZIdJJBbpVKMcKXSA0tIQ7Cb6QlMEF9M6PRtsZ91iisYUyt1xCpDolLluRQeLZUe3ZF5cxH8TvVgDvF2Tl2G1oVHqoDvCnERwKheoFTPtybzaMKQg3/tkLpwvePQh84uXiFmje823D51wFjm9piPabYMSBlw3YMOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCCrc2LHVz81v78uhaSL9HX0Ary614vfufhALFcgU14=;
 b=m9LXG9hq2r3hJcjEVK2cl8AsAqvSNx39wKlTEbYjkaoB4ztSWCWdqvgTWpA6GTg/LykbT8W9xOShEPP8DvF14ATcEvdriEMMLTeybszEnFuRUzE0ubYX5QD8uyF1cIEZjxHaJhgGK7xIS8/cRXuIf4/WrkajAIv8VngIfASg1b4=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB4068.namprd11.prod.outlook.com (2603:10b6:405:7c::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 03:51:23 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 03:51:23 +0000
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
Subject: RE: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
Thread-Topic: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
Thread-Index: AQHXmc/IhMP+UWtqaESk2TETt54mkquFJw9Q
Date:   Thu, 26 Aug 2021 03:51:23 +0000
Message-ID: <BN9PR11MB5433B7F9D3C6D176734FC9978CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-12-hch@lst.de>
In-Reply-To: <20210825161916.50393-12-hch@lst.de>
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
x-ms-office365-filtering-correlation-id: e8663a46-95b0-4470-d659-08d96844c5c3
x-ms-traffictypediagnostic: BN6PR11MB4068:
x-microsoft-antispam-prvs: <BN6PR11MB40682E3AECD14E97AF7294BF8CC79@BN6PR11MB4068.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u6ANIif5ZdSC1xAYBMdVfKnn1JggfIeEMo3VQ3HEbHUmjNFST7fbK4siVRVpePn62Ju3K55k/A908bbvFIqSqjEP6fL0R486BZtiLXVsPKnNahXXSbIn5TX31OP7GtbPZvdL+ltq7flwsAafJg2QQcifP8XF5hEssXtzfRfmJX+eBN0WlHlZYTclFhhrVCjf81J0WyUpBmby9pFqx0DvOCKS+K6BQR6EQyvB6ky0Q36Ix9fLoKZuBzNRWxC5oDeCb/GKC7QB/dYgBUfvDpUX4vKgSwwWTkaOxKXrqSjSFamXhlCy2PddWNAYo0o715S3g13wjX3lM0RRhq/HwHaYMeQUu/z6/cWtj0CvcFeP5DUUWwZdUajpfPI3dBeUTxRRMltxBwoJpiZCVJ9ohSdNh6SVlP9xIhpg/jvzDGP4lMovBQtnp2UUmKfMqhstj5FIMHi3mMyleeGUDcKjV5P6k7xWIDGwVHmtO0gOiD2q3j/+Yj6BQiyL1RJD2yUs0qUwYxS83aDZcn7mpFi60wkyhMlACumkRy/Dj5F9/GzdGqR5qTfTg3y8jZaup3q3PYfWB9o5H23rMroUtc13EQIp3CiLZpZn66g4Z0iAx6AYW5fs/lSpMPJ8YNHAwzsSgAYn9TPekMvSYwO4jYKHiGvsO4xs0CM8jZLvMaa40aF9LHyHb2ZirWAPpcLp0fRhwq6eMX5lHrhlG9W0xg3hInMlZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(52536014)(5660300002)(38070700005)(8676002)(478600001)(38100700002)(83380400001)(2906002)(4326008)(186003)(9686003)(7696005)(66476007)(54906003)(66556008)(26005)(6506007)(122000001)(66946007)(110136005)(86362001)(33656002)(76116006)(71200400001)(64756008)(66446008)(8936002)(55016002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KhbZOcy+kBagAbPvZhTj/pC5Dk3ZEXT4TDXc2UuxYeSkMBGFB1F9+IxE7p35?=
 =?us-ascii?Q?k3Y5nEiXtk45beJHhWR0JefroEjDBhSVZrZync7N0sqmUqKH2yCafBw+t/vU?=
 =?us-ascii?Q?Ye1RVjYRizdne+onDtkr5VM3e39MPpfUXKUUjh+MPH3YI9CNHxc8wp/ZYfkW?=
 =?us-ascii?Q?w//zAo819W8cnUpWl3VMfZrctbO9jI/ROVkbj7OYjvtzA0mc6jF/VxlMBRF4?=
 =?us-ascii?Q?gKjvgCiATIPg40ZJv3fF5/XmOfHKy2drchkx9q5DnSJVgS5mkrDVRjwAO212?=
 =?us-ascii?Q?Dcl2vRJJyXdQXQPm7xAnWqhKwX8QhH3NTp+gp1Wa7K77nFkdDmReIy+UvFrY?=
 =?us-ascii?Q?km3pcuDnWtnNBn1Zwy5ADF5i7MHjDxTdyB264hw5KwQSZAIoIX0EEGdA7GYy?=
 =?us-ascii?Q?nGSeExvUWtEKlW3PknfiWOUZyg6+cREFo1u/QjFMKpnRo2/OOVp9/SrMs7vv?=
 =?us-ascii?Q?Fkepw8lvYmg1O2pHspJABcD+ogwreSXjPrSqnGoEnEDvPpgdxkBQfylKpf6H?=
 =?us-ascii?Q?/rm+eWX5kcenZQVRNTOETSuXlKNjdPuk5OtQ5Eaj601+Cx/2wRrGMt/REIMN?=
 =?us-ascii?Q?T7frYe3FMr682p+ZiXoxsELhlKM/a56hU3MydmifMUhb32EB3uGkI2WmRoEc?=
 =?us-ascii?Q?NjKY1tzwKsyMy3r/+/h8uJzzhsqCUy60NeZLxbZOo1uj7lH662IpkJqweshM?=
 =?us-ascii?Q?pffG5Ds1MQ05I3+gJeTZ0AxnenUYsL8NJqqoY6iSBsWSecc5JNBzuVS0Qm7J?=
 =?us-ascii?Q?MJLmaXX5QtHKbRKa2K9MaS6Re47JE/szPNhckd7V/c/CzwvZuHUeV11wd0YI?=
 =?us-ascii?Q?ztqJYJEdECYuxoDZaST0FzcvcgB8Z8jHXtjuOETC7ezydnHyI3cS7ijltGj4?=
 =?us-ascii?Q?DAIjFqrTRpaLtWFzuoWkoKKTIHYTrDQDNKaaAEn90T8bPEANWe9WfnfCxIpg?=
 =?us-ascii?Q?EdwT7KParri0uMOBMc84kmaVpa443jvtIprNf/K4bOnMR3D+0yM8CZHpTaY0?=
 =?us-ascii?Q?xxzRkJ2cxmK8dh6TAKIOepXK0Z/BvSesRNXHhOeCUKMd8B1qZr4A1VUxu+hS?=
 =?us-ascii?Q?oJhp7oGPgylc3VUoqrgF6uRyh6HBje6ZbqBM/ZD9WJ+vSxqUpiHBqjomxzXp?=
 =?us-ascii?Q?xg2x/DL3VfCBC02vo2tnGVWiq0HJjmVUBZaRMI457UGmCAAd9zp0/NxB9zZc?=
 =?us-ascii?Q?oU5pWgOVQuH+aeZxnTaTQKt2a3SB2pkbwKH6x3lrha/HWAoJCfEUueDDgaFg?=
 =?us-ascii?Q?xglhi8jfm0vwgyeLFjc8xFJ+D24JYvedKeBTzbH5Ha9zJPHihORwrhunejg5?=
 =?us-ascii?Q?eISaAjWnuxvcJnyJ/KigZe78?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8663a46-95b0-4470-d659-08d96844c5c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 03:51:23.3083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SompVq0V2Tk+RYvcnjRIl0ZQysN8fXRTlJm9x9brZeUmpyW5l7l4shU1Xy8WujhjOZ6Zs2N0zM9XT+efU66grw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4068
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
> Pass the group flags to ->attach_group and remove the messy check for
> the bus type.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

This is a nice cleanup.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c                 | 11 +++++------
>  drivers/vfio/vfio.h                 |  7 ++++++-
>  drivers/vfio/vfio_iommu_spapr_tce.c |  2 +-
>  drivers/vfio/vfio_iommu_type1.c     | 19 ++-----------------
>  4 files changed, 14 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index f73158fce8c446..8b31eca02e0be7 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -68,9 +68,6 @@ struct vfio_unbound_dev {
>  	struct list_head		unbound_next;
>  };
>=20
> -#define VFIO_EMULATED_IOMMU	(1 << 0)
> -#define VFIO_NO_IOMMU		(1 << 1)
> -
>  struct vfio_group {
>  	struct kref			kref;
>  	int				minor;
> @@ -198,7 +195,7 @@ static long vfio_noiommu_ioctl(void *iommu_data,
>  }
>=20
>  static int vfio_noiommu_attach_group(void *iommu_data,
> -				     struct iommu_group *iommu_group)
> +		struct iommu_group *iommu_group, unsigned int flags)
>  {
>  	return 0;
>  }
> @@ -1105,7 +1102,8 @@ static int __vfio_container_attach_groups(struct
> vfio_container *container,
>  	int ret =3D -ENODEV;
>=20
>  	list_for_each_entry(group, &container->group_list, container_next) {
> -		ret =3D driver->ops->attach_group(data, group->iommu_group);
> +		ret =3D driver->ops->attach_group(data, group->iommu_group,
> +						group->flags);
>  		if (ret)
>  			goto unwind;
>  	}
> @@ -1363,7 +1361,8 @@ static int vfio_group_set_container(struct
> vfio_group *group, int container_fd)
>  	driver =3D container->iommu_driver;
>  	if (driver) {
>  		ret =3D driver->ops->attach_group(container->iommu_data,
> -						group->iommu_group);
> +						group->iommu_group,
> +						group->flags);
>  		if (ret)
>  			goto unlock_out;
>  	}
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index a78de649eb2f16..1e02433d3992ef 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -9,6 +9,10 @@ enum vfio_iommu_notify_type {
>  	VFIO_IOMMU_CONTAINER_CLOSE =3D 0,
>  };
>=20
> +/* flags for group->flags and ->attach_group */
> +#define VFIO_EMULATED_IOMMU	(1 << 0)
> +#define VFIO_NO_IOMMU		(1 << 1)
> +
>  /**
>   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
>   */
> @@ -20,7 +24,8 @@ struct vfio_iommu_driver_ops {
>  	long		(*ioctl)(void *iommu_data, unsigned int cmd,
>  				 unsigned long arg);
>  	int		(*attach_group)(void *iommu_data,
> -					struct iommu_group *group);
> +					struct iommu_group *group,
> +					unsigned int flags);
>  	void		(*detach_group)(void *iommu_data,
>  					struct iommu_group *group);
>  	int		(*pin_pages)(void *iommu_data,
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c
> b/drivers/vfio/vfio_iommu_spapr_tce.c
> index 3efd09faeca4a8..7567328d347d25 100644
> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -1239,7 +1239,7 @@ static long
> tce_iommu_take_ownership_ddw(struct tce_container *container,
>  }
>=20
>  static int tce_iommu_attach_group(void *iommu_data,
> -		struct iommu_group *iommu_group)
> +		struct iommu_group *iommu_group, unsigned int flags)
>  {
>  	int ret =3D 0;
>  	struct tce_container *container =3D iommu_data;
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index 39e2706d0b3f34..ca3c995c84166f 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -36,7 +36,6 @@
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>
>  #include <linux/workqueue.h>
> -#include <linux/mdev.h>
>  #include <linux/notifier.h>
>  #include <linux/dma-iommu.h>
>  #include <linux/irqdomain.h>
> @@ -1934,20 +1933,6 @@ static bool vfio_iommu_has_sw_msi(struct
> list_head *group_resv_regions,
>  	return ret;
>  }
>=20
> -static bool vfio_bus_is_mdev(struct bus_type *bus)
> -{
> -	struct bus_type *mdev_bus;
> -	bool ret =3D false;
> -
> -	mdev_bus =3D symbol_get(mdev_bus_type);
> -	if (mdev_bus) {
> -		ret =3D (bus =3D=3D mdev_bus);
> -		symbol_put(mdev_bus_type);
> -	}
> -
> -	return ret;
> -}
> -
>  /*
>   * This is a helper function to insert an address range to iova list.
>   * The list is initially created with a single entry corresponding to
> @@ -2172,7 +2157,7 @@ static void vfio_iommu_iova_insert_copy(struct
> vfio_iommu *iommu,
>  }
>=20
>  static int vfio_iommu_type1_attach_group(void *iommu_data,
> -					 struct iommu_group *iommu_group)
> +		struct iommu_group *iommu_group, unsigned int flags)
>  {
>  	struct vfio_iommu *iommu =3D iommu_data;
>  	struct vfio_iommu_group *group;
> @@ -2207,7 +2192,7 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  	if (ret)
>  		goto out_free;
>=20
> -	if (vfio_bus_is_mdev(bus)) {
> +	if (flags & VFIO_EMULATED_IOMMU) {
>  		if (!iommu->external_domain) {
>  			INIT_LIST_HEAD(&domain->group_list);
>  			iommu->external_domain =3D domain;
> --
> 2.30.2

