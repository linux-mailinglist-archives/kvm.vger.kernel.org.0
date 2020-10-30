Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5764229FDBD
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 07:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbgJ3GQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 02:16:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:64677 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ3GQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 02:16:36 -0400
IronPort-SDR: idqoT+TRjetfqUJiuGRlpGccN307sckun7NSEp6FZt05Vojvr9VyU7VDrRxEtXDGWyCdkc0bGP
 bUncHHPluN8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="165979294"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="165979294"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 23:16:34 -0700
IronPort-SDR: Fyqz3wGcW3AXGPQM28eJY3kjRhZouFhw2YbQaEuhTJZ0kZ3jNIWf2/0I2HSOjUd/IKG5Vd7kdt
 dHjODarKcwug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="351758351"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 29 Oct 2020 23:16:34 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Oct 2020 23:16:34 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Oct 2020 23:16:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 29 Oct 2020 23:16:33 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 29 Oct 2020 23:16:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnij14CAVEdeGsXIIjaBkyoq+8TikXRaYz4oStugK39PcY+rTdCM7AV74DWQjA8EkQ2QwySTZVyCuMuxlZdmQU9C4ELNhF4ZB2TetNDQ+2keI5ycb+bNJbTbvfdh2is4NUzx0Sva6HiKBudi4Gej8TiLAQWROspYYHYIb1MWaHZAYi0qiDSBsTAHDKtJASQm5O+cXkfG1Es9jMJ/ZDVUCai4SGU8PQVd7JwpgsGCpCQViiIkZK3bTLpS7YQv7SSRPRkt4F4+irLhtUo1sLP95BgDm7zcb7lmjnDj6zEQQDH3AUeUBZ35uQrdvvN5ZI6vwErqsZ4Bi15+HM53HJqoIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwwAMR2fVNUbyMy7IkfeEHH8h5apBN4C0dTbURmAcIc=;
 b=ktNwGSk7318qhrK8DFrb+hKPs7bb53mYYMmZNAlbGegna1qZ0sRgXaOXaHNfZZhZOFMLHifKFVUdS5qzRLUufnpIceuhdyS9E3rWpgex7ANpvhQaZ8e6u2n8MR460g29KTDQEF13bQuXs4pqpirkwBfsssnVlcqlRn759Sh26jDuwnHdvsnFOLPyKpIzHnj8Y+Qn3FATPYvQSctwZzT0G3p1FM5BZ5pFE1l1PVbm55d7Znhw8EwohpRBwEXKCNOcUyz/H7OQQCAi0YDOSZpod89wzANvVDAydlsYRvXODkg2YnO54DT48Fpa3h4D0qas0gAbRgqiLWQsEQpNCFWevw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwwAMR2fVNUbyMy7IkfeEHH8h5apBN4C0dTbURmAcIc=;
 b=NJrVYNv8sXECLcZLyDr1CTUPxI+bqsYYRKrUFtznV3F/xMOsgOhJfyQjb0I7LXjk1nNiPgFcskstnPcvY1mjO/Ti3GTjD7Hd5gUeW0YjqG7k/zVTgZGpfhpPCvBGJr8voKKMxbcXvJWOPUF9laUvXNH5+2Z8PSZLS731Ph6z22Q=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MW3PR11MB4569.namprd11.prod.outlook.com (2603:10b6:303:54::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Fri, 30 Oct
 2020 06:16:29 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b%8]) with mapi id 15.20.3477.034; Fri, 30 Oct 2020
 06:16:29 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Zeng, Xin" <xin.zeng@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 5/5] vfio/type1: Use mdev bus iommu_ops for IOMMU
 callbacks
Thread-Topic: [PATCH v6 5/5] vfio/type1: Use mdev bus iommu_ops for IOMMU
 callbacks
Thread-Index: AQHWrnpLhLumsNZ8HUeaWFi0GpwRZ6mvqoTg
Date:   Fri, 30 Oct 2020 06:16:28 +0000
Message-ID: <MWHPR11MB1645DEBE7C0E7A61D22081DD8C150@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201030045809.957927-1-baolu.lu@linux.intel.com>
 <20201030045809.957927-6-baolu.lu@linux.intel.com>
In-Reply-To: <20201030045809.957927-6-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6ee2395-c7c2-4786-96b6-08d87c9b56c6
x-ms-traffictypediagnostic: MW3PR11MB4569:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4569F20DAC9E6445F959C6E98C150@MW3PR11MB4569.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j3FKYWEp++gLvNymYN8cgQPAaO7i+aTbwfaM3fQXqFq/rgUOzD785C5k1kYteWAftKSW6Bres2V8qhWgQbeLojw6UY/eAudwJG/Bnn8pGp/OvRzcxmn7Kxig1iNoYxsbaFbsr12XTLHjYHf9MpRD3ZiDPuBE0fCltTDVnQgQKRzZZdO0R2ORZRgYpqoV5VyOHvf0eXPapAFtyASjWFdQEBdki5UiYwe8NSoy5dGyFQmCfxE9ZBb/qKoCmzQMAwY+HI6Bu3Ti+3yKpDzxHDkZk+WBGtTgFptnm8CHYasbS9kS5FTQ3oTXdUapS5C5Q2CqzCBYDcGsaUa2ehbmMPI5FA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(86362001)(2906002)(55016002)(8676002)(33656002)(6506007)(71200400001)(8936002)(66476007)(186003)(76116006)(66556008)(64756008)(66946007)(66446008)(26005)(7696005)(52536014)(5660300002)(478600001)(83380400001)(9686003)(4326008)(54906003)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tljHWVQhrZoHrdtk/us49wH8ZubvyawaaR1/0/W0wsNYcbbvAU0W7WIUxAUdpOsZUGWeVO/inx40+18gafZcbNkBUKMPgfrGzAhzyMzT+eLfG9gZERzCcbSMid15EVWYFcE4cIukH7NRMJ0Wnb4TCm2p4WDP8z0S/8+ym6WpMPmqHtINAeyeJ0DaFj2dHod/9mIf4FXnOcA6Kmry/DbMTHDuoTKe1+qOAMQeGMix6fUPwPOE+tNkPiSprbJ+IpQ8HpLZEtltABHqxAhxYCRhU+joiBBJOj2RdgEM+Q/H47L7imgCpt4uxjZpSM3FdFY5U5K58COTfWkJjFaLbAy1LYfeTA4ktAM9NLk6cjmR707awZ9mzFkbwuPn4xl5+qHn2d/E9Gvbd5Tm5+LjYIa+9TiikQZ44yQN3U2UOghdAaoffKICvToB72ZPEF07ze1sHvWpmR5zQTTq2m4lDgXBoThQEooYBUB8s0ZZoRmHEeM06ywLh4sVtpXdR0Ix3Iz/CBVpNej1AKGfPJZtncy6x2yGEBPykdW+IX9/7hTTfqyWzjhpjwkfvdnkTMO/WqpEXEUv7qHGD2yr78iisRt0hEZDyd5FKrw/C61ov0KbRclxDY29pfQxV1cbPG2lv9Z+JZV6i9IEGxSRV8RLFM6nFw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ee2395-c7c2-4786-96b6-08d87c9b56c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 06:16:28.9725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eQVEP5G8aLPFCvPXAmmfaD52McDnoZUMkypckF7lJ6k2puOuDilFyoImLYrpB8D4cGO23+ehU1LiUaA+kMK55g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4569
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Friday, October 30, 2020 12:58 PM
>=20
> With the IOMMU driver registering iommu_ops for the mdev_bus, the
> IOMMU
> operations on an mdev could be done in the same way as any normal device
> (for example, PCI/PCIe). There's no need to distinguish an mdev from
> others for iommu operations. Remove the unnecessary code.

This is really a nice cleanup as the output of this change! :)

Thanks
Kevin

>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    |  18 -----
>  drivers/vfio/mdev/mdev_driver.c  |   6 ++
>  drivers/vfio/mdev/mdev_private.h |   1 -
>  drivers/vfio/vfio_iommu_type1.c  | 128 +++----------------------------
>  include/linux/mdev.h             |  14 ----
>  5 files changed, 18 insertions(+), 149 deletions(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 6b9ab71f89e7..f4fd5f237c49 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -386,24 +386,6 @@ int mdev_device_remove(struct device *dev)
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
> index 0d3223aee20b..487402f16355 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -18,6 +18,9 @@ static int mdev_attach_iommu(struct mdev_device
> *mdev)
>  	int ret;
>  	struct iommu_group *group;
>=20
> +	if (iommu_present(&mdev_bus_type))
> +		return 0;
> +
>  	group =3D iommu_group_alloc();
>  	if (IS_ERR(group))
>  		return PTR_ERR(group);
> @@ -33,6 +36,9 @@ static int mdev_attach_iommu(struct mdev_device
> *mdev)
>=20
>  static void mdev_detach_iommu(struct mdev_device *mdev)
>  {
> +	if (iommu_present(&mdev_bus_type))
> +		return;
> +
>  	iommu_group_remove_device(&mdev->dev);
>  	dev_info(&mdev->dev, "MDEV: detaching iommu\n");
>  }
> diff --git a/drivers/vfio/mdev/mdev_private.h
> b/drivers/vfio/mdev/mdev_private.h
> index 7d922950caaf..efe0aefdb52f 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -31,7 +31,6 @@ struct mdev_device {
>  	void *driver_data;
>  	struct list_head next;
>  	struct kobject *type_kobj;
> -	struct device *iommu_device;
>  	bool active;
>  };
>=20
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index bb2684cc245e..e231b7070ca5 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -100,7 +100,6 @@ struct vfio_dma {
>  struct vfio_group {
>  	struct iommu_group	*iommu_group;
>  	struct list_head	next;
> -	bool			mdev_group;	/* An mdev group */
>  	bool			pinned_page_dirty_scope;
>  };
>=20
> @@ -1675,102 +1674,6 @@ static bool vfio_iommu_has_sw_msi(struct
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
> -static int vfio_mdev_attach_domain(struct device *dev, void *data)
> -{
> -	struct iommu_domain *domain =3D data;
> -	struct device *iommu_device;
> -
> -	iommu_device =3D vfio_mdev_get_iommu_device(dev);
> -	if (iommu_device) {
> -		if (iommu_dev_feature_enabled(iommu_device,
> IOMMU_DEV_FEAT_AUX))
> -			return iommu_aux_attach_device(domain,
> iommu_device);
> -		else
> -			return iommu_attach_device(domain,
> iommu_device);
> -	}
> -
> -	return -EINVAL;
> -}
> -
> -static int vfio_mdev_detach_domain(struct device *dev, void *data)
> -{
> -	struct iommu_domain *domain =3D data;
> -	struct device *iommu_device;
> -
> -	iommu_device =3D vfio_mdev_get_iommu_device(dev);
> -	if (iommu_device) {
> -		if (iommu_dev_feature_enabled(iommu_device,
> IOMMU_DEV_FEAT_AUX))
> -			iommu_aux_detach_device(domain, iommu_device);
> -		else
> -			iommu_detach_device(domain, iommu_device);
> -	}
> -
> -	return 0;
> -}
> -
> -static int vfio_iommu_attach_group(struct vfio_domain *domain,
> -				   struct vfio_group *group)
> -{
> -	if (group->mdev_group)
> -		return iommu_group_for_each_dev(group->iommu_group,
> -						domain->domain,
> -						vfio_mdev_attach_domain);
> -	else
> -		return iommu_attach_group(domain->domain, group-
> >iommu_group);
> -}
> -
> -static void vfio_iommu_detach_group(struct vfio_domain *domain,
> -				    struct vfio_group *group)
> -{
> -	if (group->mdev_group)
> -		iommu_group_for_each_dev(group->iommu_group,
> domain->domain,
> -					 vfio_mdev_detach_domain);
> -	else
> -		iommu_detach_group(domain->domain, group-
> >iommu_group);
> -}
> -
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
> -static int vfio_mdev_iommu_device(struct device *dev, void *data)
> -{
> -	struct device **old =3D data, *new;
> -
> -	new =3D vfio_mdev_get_iommu_device(dev);
> -	if (!new || (*old && *old !=3D new))
> -		return -EINVAL;
> -
> -	*old =3D new;
> -
> -	return 0;
> -}
> -
>  /*
>   * This is a helper function to insert an address range to iova list.
>   * The list is initially created with a single entry corresponding to
> @@ -1999,7 +1902,7 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  	struct vfio_iommu *iommu =3D iommu_data;
>  	struct vfio_group *group;
>  	struct vfio_domain *domain, *d;
> -	struct bus_type *bus =3D NULL;
> +	struct bus_type *bus =3D NULL, *mdev_bus;
>  	int ret;
>  	bool resv_msi, msi_remap;
>  	phys_addr_t resv_msi_base =3D 0;
> @@ -2037,15 +1940,10 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  	if (ret)
>  		goto out_free;
>=20
> -	if (vfio_bus_is_mdev(bus)) {
> -		struct device *iommu_device =3D NULL;
> -
> -		group->mdev_group =3D true;
> -
> -		/* Determine the isolation type */
> -		ret =3D iommu_group_for_each_dev(iommu_group,
> &iommu_device,
> -					       vfio_mdev_iommu_device);
> -		if (ret || !iommu_device) {
> +	mdev_bus =3D symbol_get(mdev_bus_type);
> +	if (mdev_bus) {
> +		if (bus =3D=3D mdev_bus && !iommu_present(bus)) {
> +			symbol_put(mdev_bus_type);
>  			if (!iommu->external_domain) {
>  				INIT_LIST_HEAD(&domain->group_list);
>  				iommu->external_domain =3D domain;
> @@ -2070,8 +1968,6 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>=20
>  			return 0;
>  		}
> -
> -		bus =3D iommu_device->bus;
>  	}
>=20
>  	domain->domain =3D iommu_domain_alloc(bus);
> @@ -2089,7 +1985,7 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  			goto out_domain;
>  	}
>=20
> -	ret =3D vfio_iommu_attach_group(domain, group);
> +	ret =3D iommu_attach_group(domain->domain, iommu_group);
>  	if (ret)
>  		goto out_domain;
>=20
> @@ -2157,15 +2053,15 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  	list_for_each_entry(d, &iommu->domain_list, next) {
>  		if (d->domain->ops =3D=3D domain->domain->ops &&
>  		    d->prot =3D=3D domain->prot) {
> -			vfio_iommu_detach_group(domain, group);
> -			if (!vfio_iommu_attach_group(d, group)) {
> +			iommu_detach_group(domain->domain,
> iommu_group);
> +			if (!iommu_attach_group(d->domain, iommu_group))
> {
>  				list_add(&group->next, &d->group_list);
>  				iommu_domain_free(domain->domain);
>  				kfree(domain);
>  				goto done;
>  			}
>=20
> -			ret =3D vfio_iommu_attach_group(domain, group);
> +			ret =3D iommu_attach_group(domain->domain,
> iommu_group);
>  			if (ret)
>  				goto out_domain;
>  		}
> @@ -2202,7 +2098,7 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  	return 0;
>=20
>  out_detach:
> -	vfio_iommu_detach_group(domain, group);
> +	iommu_detach_group(domain->domain, iommu_group);
>  out_domain:
>  	iommu_domain_free(domain->domain);
>  	vfio_iommu_iova_free(&iova_copy);
> @@ -2385,7 +2281,7 @@ static void vfio_iommu_type1_detach_group(void
> *iommu_data,
>  		if (!group)
>  			continue;
>=20
> -		vfio_iommu_detach_group(domain, group);
> +		iommu_detach_group(domain->domain, iommu_group);
>  		update_dirty_scope =3D !group->pinned_page_dirty_scope;
>  		list_del(&group->next);
>  		kfree(group);
> @@ -2466,7 +2362,7 @@ static void vfio_release_domain(struct
> vfio_domain *domain, bool external)
>  	list_for_each_entry_safe(group, group_tmp,
>  				 &domain->group_list, next) {
>  		if (!external)
> -			vfio_iommu_detach_group(domain, group);
> +			iommu_detach_group(domain->domain, group-
> >iommu_group);
>  		list_del(&group->next);
>  		kfree(group);
>  	}
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 0ce30ca78db0..f7aee86bd2b0 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -12,20 +12,6 @@
>=20
>  struct mdev_device;
>=20
> -/*
> - * Called by the parent device driver to set the device which represents
> - * this mdev in iommu protection scope. By default, the iommu device is
> - * NULL, that indicates using vendor defined isolation.
> - *
> - * @dev: the mediated device that iommu will isolate.
> - * @iommu_device: a pci device which represents the iommu for @dev.
> - *
> - * Return 0 for success, otherwise negative error value.
> - */
> -int mdev_set_iommu_device(struct device *dev, struct device
> *iommu_device);
> -
> -struct device *mdev_get_iommu_device(struct device *dev);
> -
>  /**
>   * struct mdev_parent_ops - Structure to be registered for each parent
> device to
>   * register the device to mdev module.
> --
> 2.25.1

