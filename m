Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED306349FD4
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhCZCaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:30:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:62073 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230120AbhCZCaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:30:00 -0400
IronPort-SDR: U9BiNXcd005uBkq4nSYF9a/gbPN3pAsK2csOQYw0F8OsGU7OsXQ6C+ooC1pbE9LDPTiTGvWzEF
 5VnezWR7rHjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="191159279"
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="191159279"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 19:29:59 -0700
IronPort-SDR: Up5hcEdRud8cf1wziawurR8QtQQufn/MQj0eIwApVDyX0pWsaUErAwc+sk+MXkYk2n0rdjZTlP
 fWKTjYVVyhNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="375313212"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga003.jf.intel.com with ESMTP; 25 Mar 2021 19:29:59 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 19:29:58 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 19:29:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 19:29:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 19:29:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxsR+oD0yu+CSc7yCUFwb9BKE4tnidND8yOsoGdWy77k5Q9+Oj69n+PX6iSOaNZpdzC/lHG03m09b+x154FeP0SM4hIZ4Mvp9Pz8qq4IUMP2a7ltpJyK1WtIY/lBMAc3A4N4O5yIUUw1vG+Zl6NG3DUR36KzPQYC42If9YSbu9hu7cIazulekE8RBBl0/0rVct2N5X49VpYg6GNiT6NEP1OMHHHfJ6gMpp3a5m5h7Uud5c8iTTXIDYhd9JRkF45sfwHfZ1LnPxtg1ZDsaL31n4Jv5sORquALl+v9B/cRVI05slCMvZfS9gfJbx3awjap4xr+YifEWCVlzTxtIrZ9aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFVSCMROQaPuCNSTewJvgIP3gMf523MefNzs9y4IQKc=;
 b=Mc/J6abbYQCSUa4NF4bj2iNBgYGJS51tFY7iPSf3YBfJ9YJhlDCZ4dVuKU+o7rAy93luGPfQCJE62cRKyZwDB4djbhcWqQWu8yd6of9KUUV/fiPjfNWtVlBA0zeldBpy/Ttpzkbh592igiyWO4C1uhst045QhsitxJ1BuC1wvQ8NUc7OSGmmzqIaSQXz235fjoSqD+66GDEk7aDxFNZl9lW+n4Q/D+rzLqbedFI8fYZa8VZxNSn3fAbuGzOLHsr7S+w07WfedDZBcTPcBGcBtk4QeDEursWj26sDoL8KoPe4/NhefOIUeq9/k17m56LrjifiDHgAzX7XvIFgViukdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFVSCMROQaPuCNSTewJvgIP3gMf523MefNzs9y4IQKc=;
 b=JP8BbaeBtl8jbqlhVcemxP4TzR4pnTa+WgcRqakU+p2ChDtJt/HQpVilV9kFDqpxzeFdog1pV7PU68qwF7VH+yYbg6yJcofeD5XlsitNyex9+z4gE951gaDkVI/2VTFGBCS/VcGqLF/gkQr/wXlLqOY96vxFWymMilZLvZqP+as=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1326.namprd11.prod.outlook.com (2603:10b6:300:21::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 02:29:57 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 02:29:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH 04/18] vfio/mdev: Use struct mdev_type in struct
 mdev_device
Thread-Topic: [PATCH 04/18] vfio/mdev: Use struct mdev_type in struct
 mdev_device
Thread-Index: AQHXIA3qZcNZ7s8TiU2mBLf1cGcX0qqVjmIw
Date:   Fri, 26 Mar 2021 02:29:56 +0000
Message-ID: <MWHPR11MB1886C79A69977CA40421FFA88C619@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <4-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <4-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 58ac8547-b817-449d-5d0c-08d8efff0c06
x-ms-traffictypediagnostic: MWHPR11MB1326:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1326028CDDEF84491B83543B8C619@MWHPR11MB1326.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aKgvobRFW9a4bWnG7r1il0aDOwJZqdvRozXr3MO0K5ak6psi6VJ2PI8YRfeKeB+3JBb5TrB6v6hl4NMYjbVIFC6HTZ/1BR2z2+eOytcnyWWK+i0D2bvLeZLp7UErulewfva5gopllgEk4TB7Gy+woPFrLXvm9QcBxvTewxycOCwIAvoP/QGRXHwaIyu+pl+bJNP3JvU9Tayu7YxhpVMSNxvnfRpeQ4niqc6anFMGNLbmWUClVY/mS66cuMaZW42tEXHVOgDCMFgk/0FAvVj9y8ja3aqSFPFvKDF8PwALTEKo2rMrEZkeJ3jcz8L7/pNgd+7JIivRJ34cRMIKkCW+TCMB1+kB/OMT7DgpEhWm1ajJ3EuM51RiIGy3YZ/mnh5jb+7pXrX9EAXa3hGfewwTkRMSWyuwZQAAq68R13cdkE661l6BylVagWJ/FhBP/V5SXOTcYP9bjoi7Dekhvb737tPoYE7wiYK2MCnPNfMecEB7Sw2jtIcoW7rCYqTH/6wvq0vU/dgkJHt50Gf7xIB1ucUWXiuMXTCso4ofaVAHwrz4QsyW4ZWZ0sAR7w6GhpKde4SBVHs7JkACinNowgTXWQ5Fgy3hRtXv88zivV2LoRaBLBSZR1g1SxrWeFd2qUE4w10qePjSceoHB9xTL6Pxkoy16eLt5OohmTC6ESN+TdU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(346002)(396003)(376002)(83380400001)(9686003)(4326008)(8676002)(186003)(8936002)(66476007)(55016002)(7416002)(26005)(66556008)(54906003)(71200400001)(66946007)(52536014)(110136005)(7696005)(6506007)(33656002)(66446008)(64756008)(76116006)(38100700001)(316002)(5660300002)(2906002)(478600001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?d7R2YKYGLVDCFujaPchZm/MN9pNrtLjk0Hu9/YBSLFmRZb+pztMjBPIyvvJc?=
 =?us-ascii?Q?M/z69g8mMOK9YE2vp9HkKFvOqWvIq4onnB5cWJ2TSGFSh7pdAqpeId4BrR+s?=
 =?us-ascii?Q?r1KpAZ9xgvIvX9zSd7ZNeLHQL1tKYRdeVBYk29vJKC4eCBHR8r+izPf5krXA?=
 =?us-ascii?Q?zZF3D97XfL9eCec+6vSIHjUUhXW+jr8vOp/+zWnbP0a+WC14MoWCGvouZQQ2?=
 =?us-ascii?Q?Arg8rbyQme9Y4qHSMtXPUA8+cUCcfEb+i5C6E75+fvd79gbdzYUZY6DY2+Nt?=
 =?us-ascii?Q?N6c+O5dCdrCl15/WKffgElFNKi4vP1EAh9FShB5xih8TTBazhSIafMa87nGz?=
 =?us-ascii?Q?Ivb38FXunxHZg/4JAaytPXPWjDLQVjB8HPqo0nj5JrlYooEDAvM32am1YDca?=
 =?us-ascii?Q?vh/DZJrkCI6FOieMh/vil5tO73gp9VuqWLqixOsyBmfmat7ZZjg8XaqlmlT7?=
 =?us-ascii?Q?aUOJYBVegMUXggabugfIOI8itEffqbJmOM+ewv71tEGAlAsPFgDJ35gVmM9l?=
 =?us-ascii?Q?bn+4s8yHt6UjUKueI3tKo3AiIfwOZXqIjlSZxxoLX7YgfLlW5QspFTNUB5b6?=
 =?us-ascii?Q?9J4WiEkSCkK8b6yd8PZAvaN6XvJRmdKCj2Wyz9EZ0aASfPDQFfAltjv6bKhR?=
 =?us-ascii?Q?btoEJeSSdQJcZQH58VAbLGeF+8CWx3l+3TqZPXLIMUGyBCDpYXnyhpyBWCJd?=
 =?us-ascii?Q?kw7rB9CY9Xhh4Rnq0vyeHzbdEopTd3I35wYeYoCTZDoYXJIecNYUmGq3hhPE?=
 =?us-ascii?Q?8v7tcfdRjQGUSF4eHlvIbokvazNuwogBAGq+x+ThWP4OQXLY1wDygLB5pNWU?=
 =?us-ascii?Q?e7xbTdhO19oz4n7NNImmKerZ8FB8jjXR++Dp8D98DrdVoTX8UyC5VmwGBU2b?=
 =?us-ascii?Q?QYsPImRAne8h6p5xofA0GgtkLKRTOkwlCSK11D6G289zWRna1lm42uZcoe0N?=
 =?us-ascii?Q?AuRr4SGTgfoClPD9gRZuxdvoIWKEw/SwSgzf9WJXd8TdObUJrhy6inyDbwsn?=
 =?us-ascii?Q?Ogxvt3PbCfXemb4a07iQl9Vjzc4ysW8hk/a6j84WCvDbJnHUEoUYrc3sTUPn?=
 =?us-ascii?Q?8w2CCCL89acKKBUXM6CJRUAjG+AXx6H7/uqxvWvSDdxJXMwl+YOADlwwuFeW?=
 =?us-ascii?Q?auHTygsIJLLwfqyPjOuwwXt6W/NmPUwmZshghJ05GGmYhG7vQ14Pku3tsvkC?=
 =?us-ascii?Q?0tpHmJ/fjsB0wd528yfkXLrhBiVirXdVbRGgFYhlKBDQVtsj2PTqSZy7y+e2?=
 =?us-ascii?Q?dMwYWYsmUxfOsru6Q6xwnEnok9CzoVgKaI62dWbQijbAO6s+OJIIgeGJ8hB5?=
 =?us-ascii?Q?2Ezc0N3AU5Cftu2n2BC3cmb6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58ac8547-b817-449d-5d0c-08d8efff0c06
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 02:29:56.9058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HvhYohqEq0eVPVPxlIi0ls7EAFmxA6kn2DlaToPwE1PcvHO0RaEathWXA6NZ4gjKkLu51kjlbw5zap5ZRRz0ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1326
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 24, 2021 1:55 AM
>=20
> The kobj pointer in mdev_device is actually pointing at a struct
> mdev_type. Use the proper type so things are understandable.
>=20
> There are a number of places that are confused and passing both the mdev
> and the mtype as function arguments, fix these to derive the mtype
> directly from the mdev to remove the redundancy.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 16 ++++++----------
>  drivers/vfio/mdev/mdev_private.h |  7 +++----
>  drivers/vfio/mdev/mdev_sysfs.c   | 15 ++++++++-------
>  include/linux/mdev.h             |  4 +++-
>  4 files changed, 20 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 057922a1707e04..5ca0efa5266bad 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -73,11 +73,9 @@ static void mdev_put_parent(struct mdev_parent
> *parent)
>  static void mdev_device_remove_common(struct mdev_device *mdev)
>  {
>  	struct mdev_parent *parent;
> -	struct mdev_type *type;
>  	int ret;
>=20
> -	type =3D to_mdev_type(mdev->type_kobj);
> -	mdev_remove_sysfs_files(mdev, type);
> +	mdev_remove_sysfs_files(mdev);
>  	device_del(&mdev->dev);
>  	parent =3D mdev->parent;
>  	lockdep_assert_held(&parent->unreg_sem);
> @@ -241,13 +239,11 @@ static void mdev_device_release(struct device *dev)
>  	mdev_device_free(mdev);
>  }
>=20
> -int mdev_device_create(struct kobject *kobj,
> -		       struct device *dev, const guid_t *uuid)
> +int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
>  {
>  	int ret;
>  	struct mdev_device *mdev, *tmp;
>  	struct mdev_parent *parent;
> -	struct mdev_type *type =3D to_mdev_type(kobj);
>=20
>  	parent =3D mdev_get_parent(type->parent);
>  	if (!parent)
> @@ -285,14 +281,14 @@ int mdev_device_create(struct kobject *kobj,
>  	}
>=20
>  	device_initialize(&mdev->dev);
> -	mdev->dev.parent  =3D dev;
> +	mdev->dev.parent =3D parent->dev;
>  	mdev->dev.bus     =3D &mdev_bus_type;
>  	mdev->dev.release =3D mdev_device_release;
>  	dev_set_name(&mdev->dev, "%pUl", uuid);
>  	mdev->dev.groups =3D parent->ops->mdev_attr_groups;
> -	mdev->type_kobj =3D kobj;
> +	mdev->type =3D type;
>=20
> -	ret =3D parent->ops->create(kobj, mdev);
> +	ret =3D parent->ops->create(&type->kobj, mdev);
>  	if (ret)
>  		goto ops_create_fail;
>=20
> @@ -300,7 +296,7 @@ int mdev_device_create(struct kobject *kobj,
>  	if (ret)
>  		goto add_fail;
>=20
> -	ret =3D mdev_create_sysfs_files(mdev, type);
> +	ret =3D mdev_create_sysfs_files(mdev);
>  	if (ret)
>  		goto sysfs_fail;
>=20
> diff --git a/drivers/vfio/mdev/mdev_private.h
> b/drivers/vfio/mdev/mdev_private.h
> index bb60ec4a8d9d21..debf27f95b4f10 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -40,11 +40,10 @@ struct mdev_type {
>  int  parent_create_sysfs_files(struct mdev_parent *parent);
>  void parent_remove_sysfs_files(struct mdev_parent *parent);
>=20
> -int  mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type
> *type);
> -void mdev_remove_sysfs_files(struct mdev_device *mdev, struct
> mdev_type *type);
> +int  mdev_create_sysfs_files(struct mdev_device *mdev);
> +void mdev_remove_sysfs_files(struct mdev_device *mdev);
>=20
> -int  mdev_device_create(struct kobject *kobj,
> -			struct device *dev, const guid_t *uuid);
> +int mdev_device_create(struct mdev_type *kobj, const guid_t *uuid);
>  int  mdev_device_remove(struct mdev_device *dev);
>=20
>  #endif /* MDEV_PRIVATE_H */
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> b/drivers/vfio/mdev/mdev_sysfs.c
> index 6a5450587b79e9..321b4d13ead7b8 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -67,7 +67,7 @@ static ssize_t create_store(struct kobject *kobj, struc=
t
> device *dev,
>  	if (ret)
>  		return ret;
>=20
> -	ret =3D mdev_device_create(kobj, dev, &uuid);
> +	ret =3D mdev_device_create(to_mdev_type(kobj), &uuid);
>  	if (ret)
>  		return ret;
>=20
> @@ -249,16 +249,17 @@ static const struct attribute *mdev_device_attrs[] =
=3D
> {
>  	NULL,
>  };
>=20
> -int mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type
> *type)
> +int mdev_create_sysfs_files(struct mdev_device *mdev)
>  {
>  	struct kobject *kobj =3D &mdev->dev.kobj;

What about adding a local "struct mdev_type *type" here? otherwise,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

>  	int ret;
>=20
> -	ret =3D sysfs_create_link(type->devices_kobj, kobj, dev_name(&mdev-
> >dev));
> +	ret =3D sysfs_create_link(mdev->type->devices_kobj, kobj,
> +				dev_name(&mdev->dev));
>  	if (ret)
>  		return ret;
>=20
> -	ret =3D sysfs_create_link(kobj, &type->kobj, "mdev_type");
> +	ret =3D sysfs_create_link(kobj, &mdev->type->kobj, "mdev_type");
>  	if (ret)
>  		goto type_link_failed;
>=20
> @@ -271,15 +272,15 @@ int mdev_create_sysfs_files(struct mdev_device
> *mdev, struct mdev_type *type)
>  create_files_failed:
>  	sysfs_remove_link(kobj, "mdev_type");
>  type_link_failed:
> -	sysfs_remove_link(type->devices_kobj, dev_name(&mdev->dev));
> +	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev-
> >dev));
>  	return ret;
>  }
>=20
> -void mdev_remove_sysfs_files(struct mdev_device *mdev, struct
> mdev_type *type)
> +void mdev_remove_sysfs_files(struct mdev_device *mdev)
>  {
>  	struct kobject *kobj =3D &mdev->dev.kobj;
>=20
>  	sysfs_remove_files(kobj, mdev_device_attrs);
>  	sysfs_remove_link(kobj, "mdev_type");
> -	sysfs_remove_link(type->devices_kobj, dev_name(&mdev->dev));
> +	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev-
> >dev));
>  }
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index cb771c712da0f4..349e8ac1fe3382 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -10,13 +10,15 @@
>  #ifndef MDEV_H
>  #define MDEV_H
>=20
> +struct mdev_type;
> +
>  struct mdev_device {
>  	struct device dev;
>  	struct mdev_parent *parent;
>  	guid_t uuid;
>  	void *driver_data;
>  	struct list_head next;
> -	struct kobject *type_kobj;
> +	struct mdev_type *type;
>  	struct device *iommu_device;
>  	bool active;
>  };
> --
> 2.31.0

