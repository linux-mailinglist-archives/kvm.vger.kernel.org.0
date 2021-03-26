Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A064034A043
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 04:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhCZDcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 23:32:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:4178 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhCZDbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 23:31:42 -0400
IronPort-SDR: QaJadBVS9s6g/d5XMDcYjWomsWs2kFmxrJYoymN/dNe38xoLHXTYwwmGiuRGwfTrIYDqMRy9yl
 4znTYQZj0fgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="255064891"
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="255064891"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 20:31:41 -0700
IronPort-SDR: oz477HEJ66ts954dKZ3wcVZOyjLhOAQc8QzjnDVPn2S/ns6DM5xXzbmKlw7nIX2ku/WWs1eAfg
 eqEDqhdMqSIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="443130737"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 25 Mar 2021 20:31:41 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 20:31:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 20:31:40 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.57) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 20:31:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QixKIlzbJWwONaAWSpLOKT2BnQSX7FVT0gYS0MQJS5euXSMeueViJGDgu/OF1vt5lsyAE41jOfTnD6BKiPjo3RzoR2zd4HMM1bzcbvZSZ7oVoPCxIs885SiU+ThKrBxRvUm0oyV8Si6lh6olKAFWUgrRjXCCQx1cir9yFEi7trXR72ilgr1kWGmLDxr/wScEUHEL9WpayyWnL0fLPncFDskwLeLT38PJVHHglfnvHx3ndQl6whfvdFW7YMEV0KuHd6bhdXOJi3Z2Rxvigo4TjRqZDvLiCTFeX6IWn+301baNOzYR34DdtsyQZq7N+L3qs/eGZq6u+7eplnZssL+boQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLjSYOtxaumbQjl8BqDvIsBPvhQnTdBn4uJ5JlUSYB4=;
 b=KO6aGnyfvQCKk7P0tZmSqHhgmqwTDLrxDG+0I/NZSZn9FNmHsa0M8PgC+SfVXXUuh1QuqV/wtY/pJ+iJXOo2nBYCK7cHN0bcT/FZfVclYTV/Qk52wilmVMja329kRz97LFc9m7AH4shW+inwc4IowTKCq/iO+dcz9lsuWudqqXX3W+hsGRNlsBOoDBvYSgFDD2oL79U6ja+8JCXo8cPOMTXRLKAIfKjgfWLw1pYRrlc9mY8lZ+EawwRvrtxqhaH2WWYkWUlxc97U8JiKdYuLyC/QDcQIa9/eCoPi10aM9so1lOCqGjVdhUns62C1nEvaKxHYX0G0Fz5AkxX91fgDyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLjSYOtxaumbQjl8BqDvIsBPvhQnTdBn4uJ5JlUSYB4=;
 b=jL6mv+El7nVb/MKA+0PFoRA9SVSzOVuWgRr37iTa1cw+Y1A1u1SotaJyFHDNSjE6zxGORRO3bZ5XLX1cGQpnomKYrJY8W0Z856eRml2we0FSsylP1bXhIWFwClJeTMQfQXnnb4Kf5zYSxFPzHhuzYvHR+qO2JpEOfU7ZLHca1WI=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB4932.namprd11.prod.outlook.com (2603:10b6:303:98::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 03:31:38 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 03:31:38 +0000
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
Subject: RE: [PATCH 08/18] vfio/mdev: Reorganize mdev_device_create()
Thread-Topic: [PATCH 08/18] vfio/mdev: Reorganize mdev_device_create()
Thread-Index: AQHXIA3q9lE4ogaG6kK1jMCZehbxM6qVoNkg
Date:   Fri, 26 Mar 2021 03:31:38 +0000
Message-ID: <MWHPR11MB1886AF9D6F7F37B553AF9C358C619@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <8-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <8-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 74a5ee35-4d90-4340-f9ee-08d8f007aa47
x-ms-traffictypediagnostic: CO1PR11MB4932:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB493265F11C0FA9C8AB53FB228C619@CO1PR11MB4932.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ArsVW0UsonrQ5Uze1t5cyLMML39//eZjiqBsKSPNXoCOfyo/O51vWKUxQCJtHHKXH/PvCXOoa5uKO17od3iITbVP+V1+wHtWRf/j9rsmjrBSnD8zDQE3/hJ5oAsucZW3/LvP6t1APljUgV+8xsFxfaR7dym3aLEYw+6DfZwrG1fuLCjVmX4uFHznM7IC9f7l84sRhHY4u1tFPrTQLd3+lpgty07FoI71/f7t7jfRWyaKRdrPvzSmmxAQ5ToF3k0Z0A+7DhDixh04gW2TsXsrIQcX5Ki4rx6piKj1FKXgja6VEXevMQEoz2i6xXmm+4pdrbxmFAgCtb07VAcSv/GRSW4+lET98kCHy1mq3Q1/xgMcylYgeUNXermgQudhe1LMOnH79tVOlbfUxpBokD+9o2IHErwiVDcytlozqVNAf5GEQqqNipCehRybZ9P7CE6dt6OJn5kJ49jlrq9Mr7Ku7gqdXhan1qha7L1MEkN0Ap8LCOZ1MWt0WYQjMP+kEvTRzm8qRvNPL7Y3L6FAzgaqChZdAUtkGxJ5BXVJZGcHdNPAyhYD0pKGWVNklgZSyONPZyse9BqmEB7QI4DP48XEvu5an/LB9XLlDmn6ahYXnjOrgb2xMhzNATSVlmxqG0EWjcAJQpyrnFNTU8thQxe18P09k24kj3+jwh6+s06aLT4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(39860400002)(366004)(376002)(66476007)(76116006)(66446008)(64756008)(83380400001)(8676002)(8936002)(5660300002)(33656002)(66946007)(52536014)(86362001)(38100700001)(66556008)(9686003)(4326008)(7696005)(110136005)(478600001)(2906002)(316002)(26005)(55016002)(71200400001)(6506007)(7416002)(54906003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?AusL1uuIDO/Uf6aLSi3hQQ3npnVEo1N0u0daAXCyysEeUjLHl3QMm9NMK/ar?=
 =?us-ascii?Q?zgntFcC0UjHaP94rxPPbJAY2y8AmNo1K+bFHyil4mUPNcPugkE29B55MIzCg?=
 =?us-ascii?Q?kAwOnxptm0/RL8IzOtP3YK5ZpZVtJKoNJCUiEe1dwT23v0R0a/v5B/gxLyGx?=
 =?us-ascii?Q?Svo8GV1FWyyjm7/epZTIzK8SgXITpCF5OlK6seKMyIKRdU68AVp2/1F8Yy3n?=
 =?us-ascii?Q?RjnK01HgDyzYWtaZxsqGXl/CeOZxT2J/qdZihOTZZJwPaVfTyaStLF9wOkrn?=
 =?us-ascii?Q?Tdea+Xm5KpfD2N7j5v/cfzS3XprRdYE90z8tEn05VDecUp/mIJ9+T8cy90XT?=
 =?us-ascii?Q?b7SPfSFrgzKkeJAimJSHKtWCaay/CtC80qPWovjddxMYV7bDwaXLsDqQjj7e?=
 =?us-ascii?Q?F0Ayts/nEWUmPsa3o9hFEwYQf9u0UrhaQGjx/nh8t4uwAB5bB2PIYeTKSHhA?=
 =?us-ascii?Q?9RmhQpdCYp6aCSoLxJlJRjaa5dbZxmUnF6ScmCAlYim7L96EM+BjbcdcfKwh?=
 =?us-ascii?Q?A6D8pAJX/+g6H4LxE9VA6l5dVmwCShZHwwXDx2XPyjWPLBcLvYkzI6Z7BPB+?=
 =?us-ascii?Q?XXFZnzUJbnCSZLdsh1yx0VR2mbNBqGW9D+C6tDIyWYdt9+B9F1V39b3QWP8Q?=
 =?us-ascii?Q?8BJCq7iPzBEQrxHp3/lHl2M5aF505gZkADSsp2dTYWYyk9w/XgPkDsbRW0+e?=
 =?us-ascii?Q?prB88eQi7AVaEA8pFwuA9D1a9vpuLSyiGX1rmxmqKDrEPa0jortVEH00K5HC?=
 =?us-ascii?Q?1E2yMJ6sVdu8xqwZb7UdlzdBVyHvlrxxsstoHfiLsrYd892cjN7/vM0sZaJK?=
 =?us-ascii?Q?1R/6GY5PYWMY2j0ihBVa9dHfs0XgovgWx0pZn1sUBHWBQJuZT1yVdERXc5kj?=
 =?us-ascii?Q?ztVSC0KRJiig49mB/kFhRakPwa2c9Nw2owIL5HjE2HXr7DqrkSMnRMxxDHGZ?=
 =?us-ascii?Q?dKtm1TPNvMDwcEu3JvEHKUBqsmYOzrXIdY0GIOY09TS/8SYFKzOGYA1e+5Jf?=
 =?us-ascii?Q?3zbw+sAd1pKTGXDAWVk86XPoPyhrLYL2kPV0jwkJdUfQlVsIwGJ2y0b7FL4+?=
 =?us-ascii?Q?/8NtTbs4AO+LwzStHuRMcICRaR3maT904+sz3CATDo1LY2rxiorKH/Yo/nB8?=
 =?us-ascii?Q?oAoS9IBllAl62IrqH/W30idmixfmxl72PYxyQxtN1VDVJhDmWTvx7QMz6wjg?=
 =?us-ascii?Q?kVfwrsUkmDX3e7yJPo6ykiOSes6CCKjUr8c2unTZ/Hsc+0opAG+zd+0qUQK6?=
 =?us-ascii?Q?wR3+R8hPj95GK72iZ+amW3C9tJHVQvBaEATtnGBnUzDS04BDLQGOzJfZXxoP?=
 =?us-ascii?Q?FV6QpP/HiVkjmeTSEqK/dp/6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74a5ee35-4d90-4340-f9ee-08d8f007aa47
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 03:31:38.3057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7kKVmv3XQBrotSendW6in+R8uUn4O3mkcYgxr+Gw58ficjd48xh0gqJZHTdWH+CEruNxVaqqg2YM/JTucpbbGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4932
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 24, 2021 1:55 AM
>=20
> Once the memory for the struct mdev_device is allocated it should
> immediately be device_initialize()'d and filled in so that put_device()
> can always be used to undo the allocation.
>=20
> Place the mdev_get/put_parent() so that they are clearly protecting the
> mdev->parent pointer. Move the final put to the release function so that
> the lifetime rules are trivial to understand.
>=20
> Remove mdev_device_free() as the release function via device_put() is now
> usable in all cases.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/mdev/mdev_core.c | 46 +++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 7ec21c907397a5..517b6fd351b63a 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -71,7 +71,6 @@ static void mdev_device_remove_common(struct
> mdev_device *mdev)
>=20
>  	/* Balances with device_initialize() */
>  	put_device(&mdev->dev);
> -	mdev_put_parent(parent);
>  }
>=20
>  static int mdev_device_remove_cb(struct device *dev, void *data)
> @@ -208,8 +207,13 @@ void mdev_unregister_device(struct device *dev)
>  }
>  EXPORT_SYMBOL(mdev_unregister_device);
>=20
> -static void mdev_device_free(struct mdev_device *mdev)
> +static void mdev_device_release(struct device *dev)
>  {
> +	struct mdev_device *mdev =3D to_mdev_device(dev);
> +
> +	/* Pairs with the get in mdev_device_create() */
> +	mdev_put_parent(mdev->parent);
> +
>  	mutex_lock(&mdev_list_lock);
>  	list_del(&mdev->next);
>  	mutex_unlock(&mdev_list_lock);
> @@ -218,59 +222,50 @@ static void mdev_device_free(struct mdev_device
> *mdev)
>  	kfree(mdev);
>  }
>=20
> -static void mdev_device_release(struct device *dev)
> -{
> -	struct mdev_device *mdev =3D to_mdev_device(dev);
> -
> -	mdev_device_free(mdev);
> -}
> -
>  int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
>  {
>  	int ret;
>  	struct mdev_device *mdev, *tmp;
>  	struct mdev_parent *parent =3D type->parent;
>=20
> -	mdev_get_parent(parent);
>  	mutex_lock(&mdev_list_lock);
>=20
>  	/* Check for duplicate */
>  	list_for_each_entry(tmp, &mdev_list, next) {
>  		if (guid_equal(&tmp->uuid, uuid)) {
>  			mutex_unlock(&mdev_list_lock);
> -			ret =3D -EEXIST;
> -			goto mdev_fail;
> +			return -EEXIST;
>  		}
>  	}
>=20
>  	mdev =3D kzalloc(sizeof(*mdev), GFP_KERNEL);
>  	if (!mdev) {
>  		mutex_unlock(&mdev_list_lock);
> -		ret =3D -ENOMEM;
> -		goto mdev_fail;
> +		return -ENOMEM;
>  	}
>=20
> +	device_initialize(&mdev->dev);
> +	mdev->dev.parent  =3D parent->dev;
> +	mdev->dev.bus =3D &mdev_bus_type;
> +	mdev->dev.release =3D mdev_device_release;
> +	mdev->dev.groups =3D parent->ops->mdev_attr_groups;
> +	mdev->type =3D type;
> +	mdev->parent =3D parent;
> +	/* Pairs with the put in mdev_device_release() */
> +	mdev_get_parent(parent);
> +
>  	guid_copy(&mdev->uuid, uuid);
>  	list_add(&mdev->next, &mdev_list);
>  	mutex_unlock(&mdev_list_lock);
>=20
> -	mdev->parent =3D parent;
> +	dev_set_name(&mdev->dev, "%pUl", uuid);
>=20
>  	/* Check if parent unregistration has started */
>  	if (!down_read_trylock(&parent->unreg_sem)) {
> -		mdev_device_free(mdev);
>  		ret =3D -ENODEV;
>  		goto mdev_fail;
>  	}
>=20
> -	device_initialize(&mdev->dev);
> -	mdev->dev.parent =3D parent->dev;
> -	mdev->dev.bus     =3D &mdev_bus_type;
> -	mdev->dev.release =3D mdev_device_release;
> -	dev_set_name(&mdev->dev, "%pUl", uuid);
> -	mdev->dev.groups =3D parent->ops->mdev_attr_groups;
> -	mdev->type =3D type;
> -
>  	ret =3D parent->ops->create(&type->kobj, mdev);
>  	if (ret)
>  		goto ops_create_fail;
> @@ -295,9 +290,8 @@ int mdev_device_create(struct mdev_type *type,
> const guid_t *uuid)
>  	parent->ops->remove(mdev);
>  ops_create_fail:
>  	up_read(&parent->unreg_sem);
> -	put_device(&mdev->dev);
>  mdev_fail:
> -	mdev_put_parent(parent);
> +	put_device(&mdev->dev);
>  	return ret;
>  }
>=20
> --
> 2.31.0

