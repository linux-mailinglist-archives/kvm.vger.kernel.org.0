Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E691F349F69
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhCZCSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:18:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:1243 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhCZCRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:17:34 -0400
IronPort-SDR: G1kQzzd4+OqDoR6Q5UTVw0+yY3kSlng7/0mMJN26kgCrXid2U8UBtzjFoYQqpSv0EhKX4pjhRN
 aqnxqyiENnaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="255058237"
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="255058237"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 19:17:33 -0700
IronPort-SDR: W9MJa8q2dUZByFZYwo7d3i9vb5DV2LOKIDjy/5mpqnJzhE7DoXCHxeLt46/dHbx/FOI7u7vi/V
 8Nh6In5PKKIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="608733969"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 25 Mar 2021 19:17:33 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 19:17:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 19:17:33 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 19:17:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FoXhZlXg92HApn0qHMOe8mNdN0CbIqJCIIIB6r02D9b/CRoznXGs8ecOkgR8N5HRpKHAhmiuJQOJPeDMSQi/pTll5+CeT5gNrqdbAN3SH4Vzesxu4y6YbNPSOw6KTq8UD1nZmVXI5He471IPf2+lDrnlIF54YWL74mxDeMC1dZC79Z1DS7uIqj2H6aAJzDBNP92itiK9VLbYMmUWNZaLelmGqQUURkSCZEvE/H/PqkTmQGILu6xXIHqkYMkg2q+ljsMTekSF7EOIFWawZ9t59+4go9fCF9pneHcfxzAwo0tzAdbvkXomXD4jUXtrrxA+I8n1XMFGDX/hWLVaNLTFcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhpqOFxsAbV+Ji/QFbpWYNm8h0tmh2cyTjlhFZucE0g=;
 b=odDnGIwGwKzdl/J9JoepVpMWijBd+wQ7Kt7pwfi2ifcpFUwh7HUKUkV6m8b6HO1ghoVfIGfrcmi+8AG2cj8cxB3REM/7jn6Qq/WQQd+LxawUTRf54FpNwRoZMHV9sucsYzjNgBA/oJAOpZl5XU52AhJcyP8A+qLOSIqidPkKYJE9w+aCbOlQjocHNo43au9TWaAQr8J8OvSYQyhmza9tCA2z7kw32R2QemO7V06rL/n9MQLNpvEuNG/trzTrrIxdLhhxE5VOZw/9cmTKehOzI6lT7SOnl7R0geFxYq8ZT0+v1lGHeGBFxWvFkZxDK4z5qqGDtyDBFcKu/DPT/IP9Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhpqOFxsAbV+Ji/QFbpWYNm8h0tmh2cyTjlhFZucE0g=;
 b=dsofAzYUHB3FHGm0nd4lXKnwzIiuXlCUFA/36jzrtycaDTVfR5Rhtpw7Oc2GXGByCO5s+8Lj/X7kldrNcRQOMKbiucViCd75khBCFlg02GW2fPl7+a+0soNn6G11VpvITTdsD5Mw8E6TXA80LoBd2lzSPnu3BuAxho9vpWtafdU=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB4979.namprd11.prod.outlook.com (2603:10b6:303:99::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 02:17:11 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 02:17:11 +0000
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
Subject: RE: [PATCH 03/18] vfio/mdev: Simplify driver registration
Thread-Topic: [PATCH 03/18] vfio/mdev: Simplify driver registration
Thread-Index: AQHXIA74nnSaNq9IPE2frLducVL+LqqVjAxw
Date:   Fri, 26 Mar 2021 02:17:11 +0000
Message-ID: <MWHPR11MB1886DA0BDCC2D862307A06F48C619@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <3-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <3-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 10849b1a-ed37-42a6-3ace-08d8effd43b9
x-ms-traffictypediagnostic: CO1PR11MB4979:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4979BBB972D11CC425E339158C619@CO1PR11MB4979.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eNWUnDoWfJ2VIaXmi9z2IiyZ/piY8urTRwVRWhKpIIDWgfsTnMJghH+cwdIOFU30Kxw+Qt5vWjd4w9jorDBuPbvJI0k9tDPGjYf29D0tiks97ey9US3A+v0BBNJa1CH2bnMfkkmOj424H1ImSnXHjhzMN05oWtGeMgeaBy28QvjujtokxD7kxU9ikvQfFoHiVM9YsCAu0dPS1TcgpsHmqwYvnQH1g3ElLgeDMjNZ1ZZOQrPq56WyyxdiaoTBUgUx/TkVplIqDqm1hFaQlSRANVQcFmKGET8VpwJ9AgfB6KuRgMNfPplbgh5aheLf7lw+TH3AbikAUFgR4f550X5Jfb++DrnpiGMy0KN7m0V+xZ8vEP4OPLeub294Gsh6x+38o86KmH6q74MzYD/loy+2v17Pw5+r3bAB+UxPax/APZp2D4P3Iej8rJeWO9qJZhBkahCS+Zszqr1BUdUDOoLQKs/cWpVD9+kwv5HW1fCIZg8GUPrK9zUdFHU5WpoN7EHRZm8imDghyeGHeNag2E9R+tSBhntJxVt1pJOP4ux+cRCGbe1VORfKBJYi3EbDM5Sn3m3q90sAuDAtWqYPicTxoHVYIZBiamISDwWxez3jNIIpKnjV252G2bYeaBy0s4V72Ly4m3TK0Wk7Bu3PJGB0spCF/UCBoJtZZMHhwA8T0Ns=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(136003)(376002)(346002)(478600001)(83380400001)(54906003)(316002)(110136005)(38100700001)(26005)(33656002)(86362001)(186003)(7696005)(2906002)(66556008)(9686003)(8936002)(55016002)(7416002)(66446008)(71200400001)(76116006)(4326008)(66946007)(52536014)(6506007)(8676002)(5660300002)(66476007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?NgFlHS/KLXzeVGX8YfXWxdBwT2GIqipHvXse6UhMW7uzmVM0uQcsPbEh+BWs?=
 =?us-ascii?Q?2grayIpDjXTY/vzEf6nJgTJgd6wEiZpro99C9+fHvkFMRMaMgCycjT9Imksk?=
 =?us-ascii?Q?eoTrf2nw2hviGEUXNkNDG1Onuy4uWPgroSLV6GXue9h41r6aixMBdDGicx5d?=
 =?us-ascii?Q?DWsA7I5x3Gk3DA1l3bIe14AKJny6NVCrxuKtE6TC3YG/pKbhW/Wahx3in7Jk?=
 =?us-ascii?Q?TKcjILkF5hyHPZiGVkvgo5ThrbC4dM4satQp2M47gUKUI5ykv9/FaLEJFah7?=
 =?us-ascii?Q?Lm/WCAIT4jcUXHjb2eZZnHeiiDwN8lnXn151h1JnM1QpVzA+/kOAo4snEry5?=
 =?us-ascii?Q?OrGxJHCODrDTXCMrPL1S7iGgbtfIYy/0CmHWl+hPQqFzQXqjs/Kr24kApXT3?=
 =?us-ascii?Q?G1/il1INkxdpiyu+IRvnHoXR9PiYNMEOnOad2aFfOm4cfRejBkia4wmB66Oj?=
 =?us-ascii?Q?ts/WVWXVK+r7HKmIFgarLBoAetwrFEISGSvrfpechX9aw6lbA5PD+pa6rnrF?=
 =?us-ascii?Q?XDUkLusBT7p1z7IKLzAJVTiwZMpIcsKUtjcwCWiegTpbYPBYR0MYuxE5d1ja?=
 =?us-ascii?Q?m+In0AkHt8P/8/gtUcbgMhWDbnAZ/Zqey7jwVrjyFNZ+FjAXr4YoX2rpyEPm?=
 =?us-ascii?Q?wwQqIHj6i7eqNuRUfy3O/Kee41XS7/GherV/sulm6E0/IG6ag9u+TAKwd/67?=
 =?us-ascii?Q?NIYO/fvV37U0Ga2TMDcXmQXSwA+lXUjLFND2gwRi+w0gcFpRj7Z6YBWMlZ6p?=
 =?us-ascii?Q?R+yz7OJvj+dzfkRXI8gMzsUmuEmEyuGrwFL11CW38vUN6mgGLKL7k0TxevsA?=
 =?us-ascii?Q?HJt3jrdiJA6aTrMPuiKXwt7y2qI6SRFO0SQ/TVtHVg1gYaabXs7fRGqDXajK?=
 =?us-ascii?Q?aWOou/dpe95rkcyki98pAStcSstjdsVvOEzU4nhWugSkWurPSRIp+KTbIY5N?=
 =?us-ascii?Q?95G0I+/nxyGYN34Y2nW4LYuX3ugUDReN/dbLjV3MBkUMMYTSeh6ZKRsRxiLt?=
 =?us-ascii?Q?gaqjzD1IkUPXQYi37yDH0FW1VZYn7HW/Mx7I7saxc5XU8Tq9/pDbY4ywXz50?=
 =?us-ascii?Q?vq8h9Pp8YVaziMAIIXiMoEuWVd8P2EJmqf+MV7pC8eU4kxvVV35jQGcbqqlY?=
 =?us-ascii?Q?DPjOztTlOPDlutm8ZkoOSuw4DDFxpBNQpnmqfYwAp3e5yaF5ngTEUlYzJPLT?=
 =?us-ascii?Q?uTExa9xvIPOieCZCJfdK1SeLBunWtgOHWfOE6Q5OAg+nmdK8ax2p1MbfNq6x?=
 =?us-ascii?Q?CaGK++D//AM6EQzTWimX4hFJ6kHJkT8lJUd45aZruwOHGo2w4VeJWBF7K2Fs?=
 =?us-ascii?Q?FhnChEuTioKEs+XDonsAaSVq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10849b1a-ed37-42a6-3ace-08d8effd43b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 02:17:11.2683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vpWy8tcxVfEnkd+8x44ZTONNim2PtgLtMlz6tNBoZqShfKvrjXmeexMvfHtiR7IR/roFfKsz8A2GcEaWqpX3ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4979
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 24, 2021 1:55 AM
>=20
> This is only done once, we don't need to generate code to initialize a
> structure stored in the ELF .data segment. Fill in the three required
> .driver members directly instead of copying data into them during
> mdev_register_driver().
>=20
> Further the to_mdev_driver() function doesn't belong in a public header,
> just inline it into the two places that need it. Finally, we can now
> clearly see that 'drv' derived from dev->driver cannot be NULL, firstly
> because the driver core forbids it, and secondly because NULL won't pass
> through the container_of(). Remove the dead code.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  Documentation/driver-api/vfio-mediated-device.rst |  5 +----
>  drivers/vfio/mdev/mdev_driver.c                   | 15 +++++++--------
>  drivers/vfio/mdev/vfio_mdev.c                     |  8 ++++++--
>  include/linux/mdev.h                              |  6 +-----
>  4 files changed, 15 insertions(+), 19 deletions(-)
>=20
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> b/Documentation/driver-api/vfio-mediated-device.rst
> index c43c1dc3333373..1779b85f014e2f 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -98,13 +98,11 @@ structure to represent a mediated device's driver::
>=20
>       /*
>        * struct mdev_driver [2] - Mediated device's driver
> -      * @name: driver name
>        * @probe: called when new device created
>        * @remove: called when device removed
>        * @driver: device driver structure
>        */
>       struct mdev_driver {
> -	     const char *name;
>  	     int  (*probe)  (struct mdev_device *dev);
>  	     void (*remove) (struct mdev_device *dev);
>  	     struct device_driver    driver;
> @@ -115,8 +113,7 @@ to register and unregister itself with the core drive=
r:
>=20
>  * Register::
>=20
> -    extern int  mdev_register_driver(struct mdev_driver *drv,
> -				   struct module *owner);
> +    extern int  mdev_register_driver(struct mdev_driver *drv);
>=20
>  * Unregister::
>=20
> diff --git a/drivers/vfio/mdev/mdev_driver.c
> b/drivers/vfio/mdev/mdev_driver.c
> index 44c3ba7e56d923..041699571b7e55 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -39,7 +39,8 @@ static void mdev_detach_iommu(struct mdev_device
> *mdev)
>=20
>  static int mdev_probe(struct device *dev)
>  {
> -	struct mdev_driver *drv =3D to_mdev_driver(dev->driver);
> +	struct mdev_driver *drv =3D
> +		container_of(dev->driver, struct mdev_driver, driver);
>  	struct mdev_device *mdev =3D to_mdev_device(dev);
>  	int ret;
>=20
> @@ -47,7 +48,7 @@ static int mdev_probe(struct device *dev)
>  	if (ret)
>  		return ret;
>=20
> -	if (drv && drv->probe) {
> +	if (drv->probe) {
>  		ret =3D drv->probe(mdev);
>  		if (ret)
>  			mdev_detach_iommu(mdev);
> @@ -58,10 +59,11 @@ static int mdev_probe(struct device *dev)
>=20
>  static int mdev_remove(struct device *dev)
>  {
> -	struct mdev_driver *drv =3D to_mdev_driver(dev->driver);
> +	struct mdev_driver *drv =3D
> +		container_of(dev->driver, struct mdev_driver, driver);
>  	struct mdev_device *mdev =3D to_mdev_device(dev);
>=20
> -	if (drv && drv->remove)
> +	if (drv->remove)
>  		drv->remove(mdev);
>=20
>  	mdev_detach_iommu(mdev);
> @@ -79,16 +81,13 @@ EXPORT_SYMBOL_GPL(mdev_bus_type);
>  /**
>   * mdev_register_driver - register a new MDEV driver
>   * @drv: the driver to register
> - * @owner: module owner of driver to be registered
>   *
>   * Returns a negative value on error, otherwise 0.
>   **/
> -int mdev_register_driver(struct mdev_driver *drv, struct module *owner)
> +int mdev_register_driver(struct mdev_driver *drv)
>  {
>  	/* initialize common driver fields */
> -	drv->driver.name =3D drv->name;
>  	drv->driver.bus =3D &mdev_bus_type;
> -	drv->driver.owner =3D owner;
>=20
>  	/* register with core */
>  	return driver_register(&drv->driver);
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.=
c
> index 91b7b8b9eb9cb8..cc9507ed85a181 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -152,14 +152,18 @@ static void vfio_mdev_remove(struct mdev_device
> *mdev)
>  }
>=20
>  static struct mdev_driver vfio_mdev_driver =3D {
> -	.name	=3D "vfio_mdev",
> +	.driver =3D {
> +		.name =3D "vfio_mdev",
> +		.owner =3D THIS_MODULE,
> +		.mod_name =3D KBUILD_MODNAME,
> +	},
>  	.probe	=3D vfio_mdev_probe,
>  	.remove	=3D vfio_mdev_remove,
>  };
>=20
>  static int __init vfio_mdev_init(void)
>  {
> -	return mdev_register_driver(&vfio_mdev_driver, THIS_MODULE);
> +	return mdev_register_driver(&vfio_mdev_driver);
>  }
>=20
>  static void __exit vfio_mdev_exit(void)
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 52f7ea19dd0f56..cb771c712da0f4 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -137,21 +137,17 @@ struct mdev_type_attribute
> mdev_type_attr_##_name =3D		\
>=20
>  /**
>   * struct mdev_driver - Mediated device driver
> - * @name: driver name
>   * @probe: called when new device created
>   * @remove: called when device removed
>   * @driver: device driver structure
>   *
>   **/
>  struct mdev_driver {
> -	const char *name;
>  	int (*probe)(struct mdev_device *dev);
>  	void (*remove)(struct mdev_device *dev);
>  	struct device_driver driver;
>  };
>=20
> -#define to_mdev_driver(drv)	container_of(drv, struct mdev_driver, driver=
)
> -
>  static inline void *mdev_get_drvdata(struct mdev_device *mdev)
>  {
>  	return mdev->driver_data;
> @@ -170,7 +166,7 @@ extern struct bus_type mdev_bus_type;
>  int mdev_register_device(struct device *dev, const struct mdev_parent_op=
s
> *ops);
>  void mdev_unregister_device(struct device *dev);
>=20
> -int mdev_register_driver(struct mdev_driver *drv, struct module *owner);
> +int mdev_register_driver(struct mdev_driver *drv);
>  void mdev_unregister_driver(struct mdev_driver *drv);
>=20
>  struct device *mdev_parent_dev(struct mdev_device *mdev);
> --
> 2.31.0

