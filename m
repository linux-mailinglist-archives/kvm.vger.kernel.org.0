Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D63533CF52
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 09:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhCPIJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 04:09:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:40557 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234131AbhCPIJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 04:09:24 -0400
IronPort-SDR: 0osmy6BcxnT5K62H85eRoBxeKkeseYc7ABqY1hpwhIZZMoRTSkNXNX8vuAJG05hc0ZT1YEXZJ0
 Dz803CkAH0+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="189311641"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="189311641"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 01:09:24 -0700
IronPort-SDR: ksdrvMW719IkMwrIkyAlUxPPstx2+hM5elAZ5Unq4CgnyLtdPmAHkyAxQnPK/0V9uadWF9vT2B
 KgzgcwymEKiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="511313707"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2021 01:09:23 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 01:09:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 01:09:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 01:09:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QizmDlPagvIJMgvtot+6PXjeBKXiQ3oSvBzlyWK80Q73eh/isb4ll6FZd2LJSm/a290xfG6NBH6DltqCNpWhJeaP9d5y+Q1tidKXJNN5bGHm5vdJlqen4i6VWMdmSvi10yvWX4JlocxkfEVh8H4TK9gBMkNZA3QK0O7QJ48ce/G1dzawNH+MnfjrV5SC4ZCM6ahDbZNH7gClbhce/bKxNDMMResk6nKemJvE224o+0aBl1yGuAT/m+Z926ulLSTeLvgp4l23l9EsZxFeinB0ADzHS6pOUFrrppMrKploMXth2Y/BY7n+xEDmtruKxAdOtUeKQy0RZXQP4NNSr4px3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUNQOZa3HG++z3iIEJJWB9OEhlW1u7SkOoGM07yhGMA=;
 b=EcIsjyQoforCvIqfPG6odk/m0lsu8NGzFb33iCwvIhsGVcfN5CTsZW6McBWQ89X6+qc6c8BmeITydmgE5zDhebQWs4NPMwOFS5Ioolmlqryv8Bj4pmcUU6Tk4a5VSWJh+GmItg7cWk15I0S+QFBmvjbunGZWjeLoS+ZM0q+u+BbaCqdw0fDfm1xtS1xFfh/QEgJtCQYBctRML3zRVb5ZqcuN2+zXhgFH/PFPsdadwdfq6J9ySqEdc8OHZ1as5WOzGE/ExACJZNlxDQTSgHTjzCVLXmALeSt/4n9aTtD8fryuGmVc6w1BSYCPyDz6v/RSVRUntBHR30kYt3EF4TEWVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUNQOZa3HG++z3iIEJJWB9OEhlW1u7SkOoGM07yhGMA=;
 b=WbLWAjXraNNg0HKS9bCkwIkl7bBGzk6LP/eAR8Bnoy1fklU6YzCPpHRD475ZN0lp5HR9eP5d5Axn9Ap4cwKE4odUQyGhMvNaxSklyurwwjb3GbRTMoajwMdHqOh39qDt0LCd7LDLpf8wWWU/wyA/Gh7UbxOlX21vmpSShXx0m2A=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR1101MB2174.namprd11.prod.outlook.com (2603:10b6:301:50::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 08:09:19 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 08:09:19 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 10/14] vfio/mdev: Use
 vfio_init/register/unregister_group_dev
Thread-Topic: [PATCH v2 10/14] vfio/mdev: Use
 vfio_init/register/unregister_group_dev
Thread-Index: AQHXF6PuD69WnGQkf0iWKju/XE/NpaqGR0Cg
Date:   Tue, 16 Mar 2021 08:09:19 +0000
Message-ID: <MWHPR11MB18869E91B6DCC8A74A30E3B68C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <10-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <10-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce4af9f1-9803-4798-9adf-08d8e852ccd7
x-ms-traffictypediagnostic: MWHPR1101MB2174:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2174D6E413F98ADA07061EBA8C6B9@MWHPR1101MB2174.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G1FguccCJDT9uxPGuCu7/n6WU8YwsukKwA4QotStCJoMmF2nRQSZ6JeVN7P9nTPc86bSYV0Mltmv65yQWSsBK0tAidaq96Sa8PXuKszmNcw46TuFdxNFDtlII98jZe1T9WdXNO7ydfEBC2CosncPHzh9cOxhJi6UV6gklbcZZ+4z5ZH3uUF7A6Qow0WUMI/Vn+VPlmvpgixb87l+On+/DarSVhIMi2cGFhP+TvCDFgJaWRo2+s046B5hZpLUT/glnWkxy6IivGxgL+vdmTnd6kyDxhcQaWz5rQBPpY5UAPkkEENvEWOa3ye3gkpJhWPae7gVghGXqbO7eQ5QeDUIfafYxS0rof6zi0qjRebxlW+1yAghVXCBr0KqcwOl8Z+NIafWf/sDMlXY5ZGhsO//sYy8PXL+9uH837meprJQtkygeLfy65yvuCbpT/TeMSCJ3DGfjv8reAsWbQPp+tNAD7CYRVkVyHQq2y6fUsxXE9KOHKsYpWn6aTQHG34LdDt79hGLUJ9XnKF/D+UKoj8+6cK9Mg1SJXygzRrRf+Exoe2KYWM7GHdN0kHx4vv4/q00izPnHxMv2wC7Iwwb8t6ZD02IIf5JaOZBJR0V2Q6gj2E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(396003)(39860400002)(64756008)(4326008)(76116006)(26005)(66476007)(8676002)(55016002)(66556008)(52536014)(54906003)(316002)(66446008)(478600001)(5660300002)(7416002)(6506007)(83380400001)(7696005)(86362001)(9686003)(71200400001)(8936002)(110136005)(33656002)(66946007)(2906002)(186003)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?27HKbpr7ZlJ4Bpu7Ok9KcBwhJqHUNuUM7o5aYgmJHBxrBgK7ebusbQNxyjpj?=
 =?us-ascii?Q?RgD8duf4GJD2jFslSjUraOZPPoS9J8/pqC9Yj0a2dVG3N3UoGqBmQ1gDgHlY?=
 =?us-ascii?Q?1Ekr3m94owzTKijlpX3eQl3hdiYC5FTBw/rADCBVceWt3pYil6cGNA1rxIOs?=
 =?us-ascii?Q?ZjIPoYkgW8h8eLV3rxdQx3fOHCfLAegE2Wd/x3ZV0CiEb6bJdh8N1y8XKacH?=
 =?us-ascii?Q?u1i7gmF7gkiW+ljslbxcP7XTVN2ZgmvXVMrTkaaX7EXiSwOIkSJa1YPMwfhD?=
 =?us-ascii?Q?2lEBqmmbjVUUBKFoTCo9Hob2gV6/iGDIO3Vdjf/UA3gSJUSRYkV6EEQS8ZVV?=
 =?us-ascii?Q?QWZLUcezJ/gqQ3B/PhljFMrxDlnVCv/7LZRhvJeo4fVIipvXAOt7WKkaAbzx?=
 =?us-ascii?Q?UPFVklXAbafvL0MvKvsdRqlZ6HurjJWiGH+8Xr3CBaxlxE+qIpVAS6p98gAf?=
 =?us-ascii?Q?In1V6EnWePjLR57BK43e/Z88Qb8PbY17TaPNfG8pi6dwDcwNv+vMVHp/1bD3?=
 =?us-ascii?Q?CrKY1fikeFpSk+8BcXzDR8q+QZKXqINT7ZWN3Zo5SmSG5zthzbO5sxBcFXk9?=
 =?us-ascii?Q?cfNy4oG92U5Q22r2rSSyIs3k0f011+pz24tt5tio8NMgD+AF+wXQeh0I2vWu?=
 =?us-ascii?Q?wk8cC+c7xZK1dgnbg4UUd26QEALmsVaf07KXoLhF39xxi1HaDVKcVaIg/obj?=
 =?us-ascii?Q?4Kb+1Q3wKnpiv+rJWnzdmkuHQLPDfSRIj57klRC0e4ibYKdV9cLWJ/M3Leaa?=
 =?us-ascii?Q?17AvliTaN3kOLVQoSdTHOVeOp0b6EzNR2r/W5McSC/XgBQqVQJUDbIF5sxnQ?=
 =?us-ascii?Q?6Kuj1aCg9memU8SfmP/X4BVeOPFrxqV3rByTzw3ZoWdA98L2fKMC0svTb8Vt?=
 =?us-ascii?Q?VGH3T9ppkMeDnkKrxMK1nYyTgbVvA4PVD5H+3ivFkWMAB+E1ekK9bS668bX7?=
 =?us-ascii?Q?KVsQHrNAV1PGinvnptqefdFNDqOO+NqmlB4FAs9jTatfRQubchfcd7g0P4qY?=
 =?us-ascii?Q?xg7qcsGQoVgV3XcMsljijqPYEMnuPyaBCj6SdWG9frCV2OaUX/WzMXroEyHB?=
 =?us-ascii?Q?Br/GqcYhJTpdYXTFxEzzdvgxi6Y+NRCJJ0TvABJ9wmJFv1oifAUZ7tzWFxkf?=
 =?us-ascii?Q?WxD21Xk3XsehVY+LkILUyLSQKtdW7bfw7AfsyhQoaPSDGJkmaM8ohsehBq3l?=
 =?us-ascii?Q?1HImrnGJ9r3WmCWodTjfYmfTSW/3ruPbYWb2WAjCwgg9mMlk97hWu3UQ4laB?=
 =?us-ascii?Q?NZeWEMWrJDUqvlQIg50UTlMczfqKcAXhNOJMHXHGYvWTpPkxdr9iyO0/QbI1?=
 =?us-ascii?Q?Yrlz4M9IOKLvhOEic48sIISU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4af9f1-9803-4798-9adf-08d8e852ccd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 08:09:19.2790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0p0LyxH/YTWet7b6qU5wnOmlcR2eFRKZW9ej1aJvrHRnwKJmz4IWT0FvAtMzZugkRD3cXhVIoaCBelaq5+mt6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2174
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, March 13, 2021 8:56 AM
>=20
> mdev gets little benefit because it doesn't actually do anything, however
> it is the last user, so move the code here for now.

and indicate that vfio_add/del_group_dev is removed in this patch.

>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/vfio_mdev.c | 24 +++++++++++++++++++--
>  drivers/vfio/vfio.c           | 39 ++---------------------------------
>  include/linux/vfio.h          |  5 -----
>  3 files changed, 24 insertions(+), 44 deletions(-)
>=20
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.=
c
> index b52eea128549ee..4469aaf31b56cb 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -21,6 +21,10 @@
>  #define DRIVER_AUTHOR   "NVIDIA Corporation"
>  #define DRIVER_DESC     "VFIO based driver for Mediated device"
>=20
> +struct mdev_vfio_device {
> +	struct vfio_device vdev;
> +};

following other vfio_XXX_device convention, what about calling it
vfio_mdev_device? otherwise,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> +
>  static int vfio_mdev_open(void *device_data)
>  {
>  	struct mdev_device *mdev =3D device_data;
> @@ -124,13 +128,29 @@ static const struct vfio_device_ops
> vfio_mdev_dev_ops =3D {
>  static int vfio_mdev_probe(struct device *dev)
>  {
>  	struct mdev_device *mdev =3D to_mdev_device(dev);
> +	struct mdev_vfio_device *mvdev;
> +	int ret;
>=20
> -	return vfio_add_group_dev(dev, &vfio_mdev_dev_ops, mdev);
> +	mvdev =3D kzalloc(sizeof(*mvdev), GFP_KERNEL);
> +	if (!mvdev)
> +		return -ENOMEM;
> +
> +	vfio_init_group_dev(&mvdev->vdev, &mdev->dev,
> &vfio_mdev_dev_ops, mdev);
> +	ret =3D vfio_register_group_dev(&mvdev->vdev);
> +	if (ret) {
> +		kfree(mvdev);
> +		return ret;
> +	}
> +	dev_set_drvdata(&mdev->dev, mvdev);
> +	return 0;
>  }
>=20
>  static void vfio_mdev_remove(struct device *dev)
>  {
> -	vfio_del_group_dev(dev);
> +	struct mdev_vfio_device *mvdev =3D dev_get_drvdata(dev);
> +
> +	vfio_unregister_group_dev(&mvdev->vdev);
> +	kfree(mvdev);
>  }
>=20
>  static struct mdev_driver vfio_mdev_driver =3D {
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index cfa06ae3b9018b..2d6d7cc1d1ebf9 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -99,8 +99,8 @@
> MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE,
> no-IOMMU mode.  Thi
>  /*
>   * vfio_iommu_group_{get,put} are only intended for VFIO bus driver prob=
e
>   * and remove functions, any use cases other than acquiring the first
> - * reference for the purpose of calling vfio_add_group_dev() or removing
> - * that symmetric reference after vfio_del_group_dev() should use the ra=
w
> + * reference for the purpose of calling vfio_register_group_dev() or
> removing
> + * that symmetric reference after vfio_unregister_group_dev() should use
> the raw
>   * iommu_group_{get,put} functions.  In particular, vfio_iommu_group_put=
()
>   * removes the device from the dummy group and cannot be nested.
>   */
> @@ -799,29 +799,6 @@ int vfio_register_group_dev(struct vfio_device
> *device)
>  }
>  EXPORT_SYMBOL_GPL(vfio_register_group_dev);
>=20
> -int vfio_add_group_dev(struct device *dev, const struct vfio_device_ops
> *ops,
> -		       void *device_data)
> -{
> -	struct vfio_device *device;
> -	int ret;
> -
> -	device =3D kzalloc(sizeof(*device), GFP_KERNEL);
> -	if (!device)
> -		return -ENOMEM;
> -
> -	vfio_init_group_dev(device, dev, ops, device_data);
> -	ret =3D vfio_register_group_dev(device);
> -	if (ret)
> -		goto err_kfree;
> -	dev_set_drvdata(dev, device);
> -	return 0;
> -
> -err_kfree:
> -	kfree(device);
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(vfio_add_group_dev);
> -
>  /**
>   * Get a reference to the vfio_device for a device.  Even if the
>   * caller thinks they own the device, they could be racing with a
> @@ -962,18 +939,6 @@ void vfio_unregister_group_dev(struct vfio_device
> *device)
>  }
>  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
>=20
> -void *vfio_del_group_dev(struct device *dev)
> -{
> -	struct vfio_device *device =3D dev_get_drvdata(dev);
> -	void *device_data =3D device->device_data;
> -
> -	vfio_unregister_group_dev(device);
> -	dev_set_drvdata(dev, NULL);
> -	kfree(device);
> -	return device_data;
> -}
> -EXPORT_SYMBOL_GPL(vfio_del_group_dev);
> -
>  /**
>   * VFIO base fd, /dev/vfio/vfio
>   */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index ad8b579d67d34a..4995faf51efeae 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -63,11 +63,6 @@ extern void vfio_iommu_group_put(struct
> iommu_group *group, struct device *dev);
>  void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
>  			 const struct vfio_device_ops *ops, void
> *device_data);
>  int vfio_register_group_dev(struct vfio_device *device);
> -extern int vfio_add_group_dev(struct device *dev,
> -			      const struct vfio_device_ops *ops,
> -			      void *device_data);
> -
> -extern void *vfio_del_group_dev(struct device *dev);
>  void vfio_unregister_group_dev(struct vfio_device *device);
>  extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
>  extern void vfio_device_put(struct vfio_device *device);
> --
> 2.30.2

