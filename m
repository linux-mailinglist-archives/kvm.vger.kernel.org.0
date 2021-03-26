Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66737349F50
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhCZCFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:05:38 -0400
Received: from mga04.intel.com ([192.55.52.120]:27110 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229972AbhCZCFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:05:06 -0400
IronPort-SDR: /3LiQlAmB6Y2x/jocx6YFwsXO1RQI4NOyQx8pszu2hkFHzvccIF/YIUCLgHdqw4UfHkdEE1L7f
 54J1gQkIgcNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="188774031"
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="188774031"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 19:05:05 -0700
IronPort-SDR: mXqLuv0kiCqtBPjbL30llwCA6lpi4GgX6ey9MYV93BS9IhQO1n+V0GzIA1dQ6rkpNo3yoFS/hF
 HJFNfe5M9FDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="608730963"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 25 Mar 2021 19:05:05 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 19:05:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 19:05:05 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 19:05:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gax5nlmslRliuNegyClK0/qo2sELyAN5yzJZhL0gZ9MTcVwPoI18xGgzeXMaWQeoaVIzuMYuUJkvLn425Q8vVY0tAwiGYBFfZ4218zORMle9m1ZO/pBbVTCzn7oV8pChavOwnedFhk2RnBGTkJ4QYnIXwXXFmTkfJ0HEXdEHb6sXirLRnZWQQabX8mIokh5L+UqDYJCS4EgeU0LfbK2H/PUWq/kjlACkuKeg5HShUo6gTTRD2z1J+Y+xVmg7nhUpYN4qfLDAtiivRcamlecbWkBvwJt/gXS43BtT1yWmpj+DzjJ9dUXVzi0TEJcjwB1O2bpFbdLayqK7wclaLLaWmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdQSQCkK+ofEZwHe3q2oyOq9x+g9b80r/lipcfhRIH0=;
 b=GlZEtKh82zNduZcQylmZk2eFiBeHma8U/+7vRLZAIosnEor/i6aeie5lHt2jZAijro5p7RmQsFBAUYaiANX754VTekeXjyGRQyIfam86he2MlLSrt0DwM+JllGuYwRjqJpfAqdVEDIMTnB9lxRjBU5VIN9IoiYqMewXgDsORu5hMFoB0TlQmv6TIt918rPH7o5mJ4tVOosaBttXksuQjR7TGPavFJEJKFI8DE9fiXd0FOrPs3zsZf/N45IE1ZPAuYZnTD09t4KsZ6nekzr/Mlu5rABWH128pGhArqo7jioJJMXFVo5aU2lofOnfLsF8Xy2renQ9s56/vWhODXuVtFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdQSQCkK+ofEZwHe3q2oyOq9x+g9b80r/lipcfhRIH0=;
 b=sqVT/j9lj85YPQ5xcvdvpwXoqZuRJY5rzQSJ2JD4SXcEpKcDznkx1VeB+ZM7VFAJCLxidhyc6c70C1KX59PNi1HKMnbpzC6d/2rXwMAVbOokjJafeTOy/ZtKsvZk2zBrX/4J5NYOB7p/beFJ7/5Ohvn+Jwmjim3VvBn0eYwrD9c=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4761.namprd11.prod.outlook.com (2603:10b6:303:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 02:04:53 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 02:04:53 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH 02/18] vfio/mdev: Add missing typesafety around
 mdev_device
Thread-Topic: [PATCH 02/18] vfio/mdev: Add missing typesafety around
 mdev_device
Thread-Index: AQHXIA3tnZahzyNqaEuqKVewKBJs5KqViJig
Date:   Fri, 26 Mar 2021 02:04:52 +0000
Message-ID: <MWHPR11MB188655B06A2B743A630651228C619@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <2-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <2-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.220]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98b7ece3-e10b-41fb-ed57-08d8effb8bb4
x-ms-traffictypediagnostic: MW3PR11MB4761:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4761734AA260D2361D75B5D38C619@MW3PR11MB4761.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TaC4dILIHkICHIYxDHEUXFbOZc/8Lf9HSF11LF89l3xAaey/TG6dr/rSzavql6lTA3AjzMLjA0g910CIXGfLeY+uueCWbFecyxEoTGb9eQYnKnys2DUXrSIqQvX283ClpeE9Wl+AWaRhANYsdVM/t7g/ot+NdoqKmbMo7JbIFweS5RInaPdNdKwttezqhDiYH3a8ToWwDjahp6FzUPhTDMQq/Pe7p9De+IqbYlC6PbC8Wl/subQpxdzTvz0E85cVXgWLZCPStfMlN+FAz8O7iRIhLM3fCh/BkOPPWAS0qejJ/bOCZftJLBzTdDwanWGlb1qy23HvKh7hoalAkxLb6d5dtqGiqxw65qN/wELdUykbEhsf1ix8Q/Pr0lxHo+0x/LE8VOlA6Sq3XHk7s35ECj9ikTK88lNL1tO9cGT00P7ucUOoMD79GOB9Q243oEVxDce5tHW8CUxZ6FRGu8fnY9k5j5pjncipK42u/g4u/Y8w2rrW0mbYNrJOovqFOwAxRRsZRcjfLInKMKcsS3dO7HbNE3STP4FmOvJoMX7nEG0YaTHae36mDI3LWfM9/FPDd3j9teG4G4ojTptdGIZDAhXvyVqTKXnrS0bzkDrkeBOgIC5WyAXXHSxHRJksSU5r7b7A/8Y+avOPVtRzsQEKWD3Dq8SXrBnU2dHKxoSoKGs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(346002)(376002)(39860400002)(7696005)(86362001)(71200400001)(478600001)(66556008)(5660300002)(64756008)(66446008)(7416002)(83380400001)(316002)(55016002)(52536014)(110136005)(30864003)(66476007)(54906003)(186003)(33656002)(9686003)(26005)(2906002)(8676002)(4326008)(38100700001)(76116006)(6506007)(66946007)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3ZQGAUl2LMB64XX26LfK1NfCMYHdYk7SFactYz1bb+F+XT4eJroyKQmvpjrr?=
 =?us-ascii?Q?JkSXWtM+Jw+oXBRkVv6jL6w6hIARiLseVjLPWNBTDafyhAKIMbukCtKcb2A/?=
 =?us-ascii?Q?Q8EwyqPcUvbfeDAtX/+5nNpR55xCcyY+UqbnjK0WaMRIRlvfzVFxsCdELN/m?=
 =?us-ascii?Q?BEjyXYyoyijlWre8m+2b5aK37ic34W0igVxawr75jEOPZ3lC1i99FYgsAk5d?=
 =?us-ascii?Q?TIvFQLm16s9ghm1BUGhKw6eXv+PDn+ENwS1WmpM7pVrq4hQiwJFMRvYvGwYx?=
 =?us-ascii?Q?Y6EerudmEaH6a+d/8rAztND1ysHn9/hL23o3RtP+iO3S0FZzffa8Lw8IwxFH?=
 =?us-ascii?Q?bVoA6F8/p4hMyrn77kqDYgGdpd+GJo6ylIcL9QSb0y9tbNwFvmc3wFIjK0yN?=
 =?us-ascii?Q?sr4bIKLPIECOYArnAAFH0/20P8lA7/NZv1K5UQG0TiCDAKfvJaHmWelFGatW?=
 =?us-ascii?Q?M6ZEfu+KvFDxJDgbMWoubQl7E1S+3jYRYPr2R+bxBOWOjo5oygClVJL7erfC?=
 =?us-ascii?Q?TReEmCbeiUF7jKsB6uqpWrUUX/eBNoQLlJkDi16UB/nvj6J2N7ImcPMW5Bos?=
 =?us-ascii?Q?3aXV/7Xm6MQn0aoTOUg1TilZ/bjFU8U7IGR9sMW5kR8U7aceipIcAHzWYU3N?=
 =?us-ascii?Q?nMsRn/CxZeHv8HmsHpQJzypcQ6hZH+qnKxx+sTdGP8h60PSFyKjVZifScJKC?=
 =?us-ascii?Q?iL9cENn4luOdJh+DYxzU73rQmz586ZPEm2XPyBOZeO+NqKMBHABakcL0NFMM?=
 =?us-ascii?Q?54SeMmuvw+dW6L6cm72XDCnqgKwtWGrcE1QAO0/csSanftfmVETAr7qPXRxn?=
 =?us-ascii?Q?T5mpR68y802wc0kLkm7fg/uDsWGBZr8De3DTlrPUjcdrZqDJ+aTJCD1HMsJP?=
 =?us-ascii?Q?7atmoxqyDDtvoDQXMRNFs1oKSFweXVYayzUqZwCXXCZBw6lMM+ul38/mz6CY?=
 =?us-ascii?Q?aksvfLzZicCDO8P5S5kEhm3+aMjs3Te4hvz8LUx7rQBNr+l2fHb1Vj8TcrOy?=
 =?us-ascii?Q?c4CGRXMkgP0xtBw6jUeXE3bcfVx1mccGntHdtw609EpWR5Q9Lx510h6gLvZP?=
 =?us-ascii?Q?NKa7RKyB+MNqamkkbHysVkmm69kFj3+hZ3ufAoAuTMqK/UzcvbspOGT+Ldcw?=
 =?us-ascii?Q?0/NGMHvY8hToQNapU1drIXZP/MBGqn/AAsYHyhQdyxHCMXirbapO7Om8RGie?=
 =?us-ascii?Q?DbrVR9l5DWu8LY2iX/j6h9zkmlhiuPZZH/fGlqkkKF5JPoeoDCKCLuhQwZRr?=
 =?us-ascii?Q?w1SPstHqxtGvTJW837+pErLYWDFXBGewYuyD2hLt1vSPc3Jf6e6I4lsPgLFF?=
 =?us-ascii?Q?uxwzH5FsjN4jHNU4E5Fyj0cu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b7ece3-e10b-41fb-ed57-08d8effb8bb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 02:04:53.1165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GTwi98VTQc+Z/sunqA8jn1WVFarphjIMBusojwwkuX6Lp3PYuIX4RAFXxdvD0m3lya6u+T/xPEyofLMZ+qSf6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4761
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 24, 2021 1:55 AM
>=20
> The mdev API should accept and pass a 'struct mdev_device *' in all
> places, not pass a 'struct device *' and cast it internally with
> to_mdev_device(). Particularly in its struct mdev_driver functions, the
> whole point of a bus's struct device_driver wrapper is to provide type
> safety compared to the default struct device_driver.
>=20
> Further, the driver core standard is for bus drivers to expose their
> device structure in their public headers that can be used with
> container_of() inlines and '&foo->dev' to go between the class levels, an=
d
> '&foo->dev' to be used with dev_err/etc driver core helper functions. Mov=
e
> 'struct mdev_device' to mdev.h
>=20
> Once done this allows moving some one instruction exported functions to
> static inlines, which in turns allows removing one of the two grotesque
> symbol_get()'s related to mdev in the core code.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  .../driver-api/vfio-mediated-device.rst       |  4 +-
>  drivers/vfio/mdev/mdev_core.c                 | 64 ++-----------------
>  drivers/vfio/mdev/mdev_driver.c               |  4 +-
>  drivers/vfio/mdev/mdev_private.h              | 23 +------
>  drivers/vfio/mdev/mdev_sysfs.c                | 26 ++++----
>  drivers/vfio/mdev/vfio_mdev.c                 |  7 +-
>  drivers/vfio/vfio_iommu_type1.c               | 25 ++------
>  include/linux/mdev.h                          | 58 +++++++++++++----
>  8 files changed, 83 insertions(+), 128 deletions(-)
>=20
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> b/Documentation/driver-api/vfio-mediated-device.rst
> index 25eb7d5b834ba3..c43c1dc3333373 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -105,8 +105,8 @@ structure to represent a mediated device's driver::
>        */
>       struct mdev_driver {
>  	     const char *name;
> -	     int  (*probe)  (struct device *dev);
> -	     void (*remove) (struct device *dev);
> +	     int  (*probe)  (struct mdev_device *dev);
> +	     void (*remove) (struct mdev_device *dev);
>  	     struct device_driver    driver;
>       };
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 6de97d25a3f87d..057922a1707e04 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -33,36 +33,6 @@ struct device *mdev_parent_dev(struct mdev_device
> *mdev)
>  }
>  EXPORT_SYMBOL(mdev_parent_dev);
>=20
> -void *mdev_get_drvdata(struct mdev_device *mdev)
> -{
> -	return mdev->driver_data;
> -}
> -EXPORT_SYMBOL(mdev_get_drvdata);
> -
> -void mdev_set_drvdata(struct mdev_device *mdev, void *data)
> -{
> -	mdev->driver_data =3D data;
> -}
> -EXPORT_SYMBOL(mdev_set_drvdata);
> -
> -struct device *mdev_dev(struct mdev_device *mdev)
> -{
> -	return &mdev->dev;
> -}
> -EXPORT_SYMBOL(mdev_dev);
> -
> -struct mdev_device *mdev_from_dev(struct device *dev)
> -{
> -	return dev_is_mdev(dev) ? to_mdev_device(dev) : NULL;
> -}
> -EXPORT_SYMBOL(mdev_from_dev);
> -
> -const guid_t *mdev_uuid(struct mdev_device *mdev)
> -{
> -	return &mdev->uuid;
> -}
> -EXPORT_SYMBOL(mdev_uuid);
> -
>  /* Should be called holding parent_list_lock */
>  static struct mdev_parent *__find_parent_device(struct device *dev)
>  {
> @@ -107,7 +77,7 @@ static void mdev_device_remove_common(struct
> mdev_device *mdev)
>  	int ret;
>=20
>  	type =3D to_mdev_type(mdev->type_kobj);
> -	mdev_remove_sysfs_files(&mdev->dev, type);
> +	mdev_remove_sysfs_files(mdev, type);
>  	device_del(&mdev->dev);
>  	parent =3D mdev->parent;
>  	lockdep_assert_held(&parent->unreg_sem);
> @@ -122,12 +92,10 @@ static void mdev_device_remove_common(struct
> mdev_device *mdev)
>=20
>  static int mdev_device_remove_cb(struct device *dev, void *data)
>  {
> -	if (dev_is_mdev(dev)) {
> -		struct mdev_device *mdev;
> +	struct mdev_device *mdev =3D mdev_from_dev(dev);
>=20
> -		mdev =3D to_mdev_device(dev);
> +	if (mdev)
>  		mdev_device_remove_common(mdev);
> -	}
>  	return 0;
>  }
>=20
> @@ -332,7 +300,7 @@ int mdev_device_create(struct kobject *kobj,
>  	if (ret)
>  		goto add_fail;
>=20
> -	ret =3D mdev_create_sysfs_files(&mdev->dev, type);
> +	ret =3D mdev_create_sysfs_files(mdev, type);
>  	if (ret)
>  		goto sysfs_fail;
>=20
> @@ -354,13 +322,11 @@ int mdev_device_create(struct kobject *kobj,
>  	return ret;
>  }
>=20
> -int mdev_device_remove(struct device *dev)
> +int mdev_device_remove(struct mdev_device *mdev)
>  {
> -	struct mdev_device *mdev, *tmp;
> +	struct mdev_device *tmp;
>  	struct mdev_parent *parent;
>=20
> -	mdev =3D to_mdev_device(dev);
> -
>  	mutex_lock(&mdev_list_lock);
>  	list_for_each_entry(tmp, &mdev_list, next) {
>  		if (tmp =3D=3D mdev)
> @@ -390,24 +356,6 @@ int mdev_device_remove(struct device *dev)
>  	return 0;
>  }
>=20
> -int mdev_set_iommu_device(struct device *dev, struct device
> *iommu_device)
> -{
> -	struct mdev_device *mdev =3D to_mdev_device(dev);
> -
> -	mdev->iommu_device =3D iommu_device;
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL(mdev_set_iommu_device);
> -
> -struct device *mdev_get_iommu_device(struct device *dev)
> -{
> -	struct mdev_device *mdev =3D to_mdev_device(dev);
> -
> -	return mdev->iommu_device;
> -}
> -EXPORT_SYMBOL(mdev_get_iommu_device);
> -
>  static int __init mdev_init(void)
>  {
>  	return mdev_bus_register();
> diff --git a/drivers/vfio/mdev/mdev_driver.c
> b/drivers/vfio/mdev/mdev_driver.c
> index 0d3223aee20b83..44c3ba7e56d923 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -48,7 +48,7 @@ static int mdev_probe(struct device *dev)
>  		return ret;
>=20
>  	if (drv && drv->probe) {
> -		ret =3D drv->probe(dev);
> +		ret =3D drv->probe(mdev);
>  		if (ret)
>  			mdev_detach_iommu(mdev);
>  	}
> @@ -62,7 +62,7 @@ static int mdev_remove(struct device *dev)
>  	struct mdev_device *mdev =3D to_mdev_device(dev);
>=20
>  	if (drv && drv->remove)
> -		drv->remove(dev);
> +		drv->remove(mdev);
>=20
>  	mdev_detach_iommu(mdev);
>=20
> diff --git a/drivers/vfio/mdev/mdev_private.h
> b/drivers/vfio/mdev/mdev_private.h
> index 74c2e541146999..bb60ec4a8d9d21 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -24,23 +24,6 @@ struct mdev_parent {
>  	struct rw_semaphore unreg_sem;
>  };
>=20
> -struct mdev_device {
> -	struct device dev;
> -	struct mdev_parent *parent;
> -	guid_t uuid;
> -	void *driver_data;
> -	struct list_head next;
> -	struct kobject *type_kobj;
> -	struct device *iommu_device;
> -	bool active;
> -};
> -
> -static inline struct mdev_device *to_mdev_device(struct device *dev)
> -{
> -	return container_of(dev, struct mdev_device, dev);
> -}
> -#define dev_is_mdev(d)		((d)->bus =3D=3D &mdev_bus_type)
> -
>  struct mdev_type {
>  	struct kobject kobj;
>  	struct kobject *devices_kobj;
> @@ -57,11 +40,11 @@ struct mdev_type {
>  int  parent_create_sysfs_files(struct mdev_parent *parent);
>  void parent_remove_sysfs_files(struct mdev_parent *parent);
>=20
> -int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type)=
;
> -void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type)=
;
> +int  mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type
> *type);
> +void mdev_remove_sysfs_files(struct mdev_device *mdev, struct
> mdev_type *type);
>=20
>  int  mdev_device_create(struct kobject *kobj,
>  			struct device *dev, const guid_t *uuid);
> -int  mdev_device_remove(struct device *dev);
> +int  mdev_device_remove(struct mdev_device *dev);
>=20
>  #endif /* MDEV_PRIVATE_H */
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> b/drivers/vfio/mdev/mdev_sysfs.c
> index 917fd84c1c6f24..6a5450587b79e9 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -225,6 +225,7 @@ int parent_create_sysfs_files(struct mdev_parent
> *parent)
>  static ssize_t remove_store(struct device *dev, struct device_attribute =
*attr,
>  			    const char *buf, size_t count)
>  {
> +	struct mdev_device *mdev =3D to_mdev_device(dev);
>  	unsigned long val;
>=20
>  	if (kstrtoul(buf, 0, &val) < 0)
> @@ -233,7 +234,7 @@ static ssize_t remove_store(struct device *dev, struc=
t
> device_attribute *attr,
>  	if (val && device_remove_file_self(dev, attr)) {
>  		int ret;
>=20
> -		ret =3D mdev_device_remove(dev);
> +		ret =3D mdev_device_remove(mdev);
>  		if (ret)
>  			return ret;
>  	}
> @@ -248,34 +249,37 @@ static const struct attribute *mdev_device_attrs[] =
=3D
> {
>  	NULL,
>  };
>=20
> -int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type)
> +int mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type
> *type)
>  {
> +	struct kobject *kobj =3D &mdev->dev.kobj;
>  	int ret;
>=20
> -	ret =3D sysfs_create_link(type->devices_kobj, &dev->kobj,
> dev_name(dev));
> +	ret =3D sysfs_create_link(type->devices_kobj, kobj, dev_name(&mdev-
> >dev));
>  	if (ret)
>  		return ret;
>=20
> -	ret =3D sysfs_create_link(&dev->kobj, &type->kobj, "mdev_type");
> +	ret =3D sysfs_create_link(kobj, &type->kobj, "mdev_type");
>  	if (ret)
>  		goto type_link_failed;
>=20
> -	ret =3D sysfs_create_files(&dev->kobj, mdev_device_attrs);
> +	ret =3D sysfs_create_files(kobj, mdev_device_attrs);
>  	if (ret)
>  		goto create_files_failed;
>=20
>  	return ret;
>=20
>  create_files_failed:
> -	sysfs_remove_link(&dev->kobj, "mdev_type");
> +	sysfs_remove_link(kobj, "mdev_type");
>  type_link_failed:
> -	sysfs_remove_link(type->devices_kobj, dev_name(dev));
> +	sysfs_remove_link(type->devices_kobj, dev_name(&mdev->dev));
>  	return ret;
>  }
>=20
> -void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type)
> +void mdev_remove_sysfs_files(struct mdev_device *mdev, struct
> mdev_type *type)
>  {
> -	sysfs_remove_files(&dev->kobj, mdev_device_attrs);
> -	sysfs_remove_link(&dev->kobj, "mdev_type");
> -	sysfs_remove_link(type->devices_kobj, dev_name(dev));
> +	struct kobject *kobj =3D &mdev->dev.kobj;
> +
> +	sysfs_remove_files(kobj, mdev_device_attrs);
> +	sysfs_remove_link(kobj, "mdev_type");
> +	sysfs_remove_link(type->devices_kobj, dev_name(&mdev->dev));
>  }
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.=
c
> index ae7e322fbe3c26..91b7b8b9eb9cb8 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -124,9 +124,8 @@ static const struct vfio_device_ops
> vfio_mdev_dev_ops =3D {
>  	.request	=3D vfio_mdev_request,
>  };
>=20
> -static int vfio_mdev_probe(struct device *dev)
> +static int vfio_mdev_probe(struct mdev_device *mdev)
>  {
> -	struct mdev_device *mdev =3D to_mdev_device(dev);
>  	struct vfio_device *vdev;
>  	int ret;
>=20
> @@ -144,9 +143,9 @@ static int vfio_mdev_probe(struct device *dev)
>  	return 0;
>  }
>=20
> -static void vfio_mdev_remove(struct device *dev)
> +static void vfio_mdev_remove(struct mdev_device *mdev)
>  {
> -	struct vfio_device *vdev =3D dev_get_drvdata(dev);
> +	struct vfio_device *vdev =3D dev_get_drvdata(&mdev->dev);
>=20
>  	vfio_unregister_group_dev(vdev);
>  	kfree(vdev);
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index 4bb162c1d649b3..90b45ff1d87a7b 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1923,28 +1923,13 @@ static bool vfio_iommu_has_sw_msi(struct
> list_head *group_resv_regions,
>  	return ret;
>  }
>=20
> -static struct device *vfio_mdev_get_iommu_device(struct device *dev)
> -{
> -	struct device *(*fn)(struct device *dev);
> -	struct device *iommu_device;
> -
> -	fn =3D symbol_get(mdev_get_iommu_device);
> -	if (fn) {
> -		iommu_device =3D fn(dev);
> -		symbol_put(mdev_get_iommu_device);
> -
> -		return iommu_device;
> -	}
> -
> -	return NULL;
> -}
> -
>  static int vfio_mdev_attach_domain(struct device *dev, void *data)
>  {
> +	struct mdev_device *mdev =3D to_mdev_device(dev);
>  	struct iommu_domain *domain =3D data;
>  	struct device *iommu_device;
>=20
> -	iommu_device =3D vfio_mdev_get_iommu_device(dev);
> +	iommu_device =3D mdev_get_iommu_device(mdev);
>  	if (iommu_device) {
>  		if (iommu_dev_feature_enabled(iommu_device,
> IOMMU_DEV_FEAT_AUX))
>  			return iommu_aux_attach_device(domain,
> iommu_device);
> @@ -1957,10 +1942,11 @@ static int vfio_mdev_attach_domain(struct
> device *dev, void *data)
>=20
>  static int vfio_mdev_detach_domain(struct device *dev, void *data)
>  {
> +	struct mdev_device *mdev =3D to_mdev_device(dev);
>  	struct iommu_domain *domain =3D data;
>  	struct device *iommu_device;
>=20
> -	iommu_device =3D vfio_mdev_get_iommu_device(dev);
> +	iommu_device =3D mdev_get_iommu_device(mdev);
>  	if (iommu_device) {
>  		if (iommu_dev_feature_enabled(iommu_device,
> IOMMU_DEV_FEAT_AUX))
>  			iommu_aux_detach_device(domain, iommu_device);
> @@ -2008,9 +1994,10 @@ static bool vfio_bus_is_mdev(struct bus_type
> *bus)
>=20
>  static int vfio_mdev_iommu_device(struct device *dev, void *data)
>  {
> +	struct mdev_device *mdev =3D to_mdev_device(dev);
>  	struct device **old =3D data, *new;
>=20
> -	new =3D vfio_mdev_get_iommu_device(dev);
> +	new =3D mdev_get_iommu_device(mdev);
>  	if (!new || (*old && *old !=3D new))
>  		return -EINVAL;
>=20
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 27eb383cb95de0..52f7ea19dd0f56 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -10,7 +10,21 @@
>  #ifndef MDEV_H
>  #define MDEV_H
>=20
> -struct mdev_device;
> +struct mdev_device {
> +	struct device dev;
> +	struct mdev_parent *parent;
> +	guid_t uuid;
> +	void *driver_data;
> +	struct list_head next;
> +	struct kobject *type_kobj;
> +	struct device *iommu_device;
> +	bool active;
> +};
> +
> +static inline struct mdev_device *to_mdev_device(struct device *dev)
> +{
> +	return container_of(dev, struct mdev_device, dev);
> +}
>=20
>  /*
>   * Called by the parent device driver to set the device which represents
> @@ -19,12 +33,17 @@ struct mdev_device;
>   *
>   * @dev: the mediated device that iommu will isolate.
>   * @iommu_device: a pci device which represents the iommu for @dev.
> - *
> - * Return 0 for success, otherwise negative error value.
>   */
> -int mdev_set_iommu_device(struct device *dev, struct device
> *iommu_device);
> +static inline void mdev_set_iommu_device(struct mdev_device *mdev,
> +					 struct device *iommu_device)
> +{
> +	mdev->iommu_device =3D iommu_device;
> +}
>=20
> -struct device *mdev_get_iommu_device(struct device *dev);
> +static inline struct device *mdev_get_iommu_device(struct mdev_device
> *mdev)
> +{
> +	return mdev->iommu_device;
> +}
>=20
>  /**
>   * struct mdev_parent_ops - Structure to be registered for each parent
> device to
> @@ -126,16 +145,25 @@ struct mdev_type_attribute
> mdev_type_attr_##_name =3D		\
>   **/
>  struct mdev_driver {
>  	const char *name;
> -	int  (*probe)(struct device *dev);
> -	void (*remove)(struct device *dev);
> +	int (*probe)(struct mdev_device *dev);
> +	void (*remove)(struct mdev_device *dev);
>  	struct device_driver driver;
>  };
>=20
>  #define to_mdev_driver(drv)	container_of(drv, struct mdev_driver, driver=
)
>=20
> -void *mdev_get_drvdata(struct mdev_device *mdev);
> -void mdev_set_drvdata(struct mdev_device *mdev, void *data);
> -const guid_t *mdev_uuid(struct mdev_device *mdev);
> +static inline void *mdev_get_drvdata(struct mdev_device *mdev)
> +{
> +	return mdev->driver_data;
> +}
> +static inline void mdev_set_drvdata(struct mdev_device *mdev, void *data=
)
> +{
> +	mdev->driver_data =3D data;
> +}
> +static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
> +{
> +	return &mdev->uuid;
> +}
>=20
>  extern struct bus_type mdev_bus_type;
>=20
> @@ -146,7 +174,13 @@ int mdev_register_driver(struct mdev_driver *drv,
> struct module *owner);
>  void mdev_unregister_driver(struct mdev_driver *drv);
>=20
>  struct device *mdev_parent_dev(struct mdev_device *mdev);
> -struct device *mdev_dev(struct mdev_device *mdev);
> -struct mdev_device *mdev_from_dev(struct device *dev);
> +static inline struct device *mdev_dev(struct mdev_device *mdev)
> +{
> +	return &mdev->dev;
> +}
> +static inline struct mdev_device *mdev_from_dev(struct device *dev)
> +{
> +	return dev->bus =3D=3D &mdev_bus_type ? to_mdev_device(dev) : NULL;
> +}
>=20
>  #endif /* MDEV_H */
> --
> 2.31.0

