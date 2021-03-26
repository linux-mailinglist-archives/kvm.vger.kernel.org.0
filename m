Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A08834A062
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 04:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhCZDxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 23:53:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:27789 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhCZDxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 23:53:31 -0400
IronPort-SDR: MJQoJmeeyeiD10Bn0qLTIOC7yrk3KmYMcFUdIIDqMDx27OG9eK2/b0eKE3U0NdIz7wOW9sWTkj
 LpT54JPnILmg==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="252426014"
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="252426014"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 20:53:29 -0700
IronPort-SDR: dQh2rP15n9uarG+qM8UDUSRD/TTmBofm3AaWgJbYqF5ZN31mxa4dBXE56hxVngxEHuTpR7JoL+
 Cw0kOQTFhOnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="375334022"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga003.jf.intel.com with ESMTP; 25 Mar 2021 20:53:15 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 20:53:14 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 20:53:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 20:53:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 20:53:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VArC/sQ+fvRkpXAQJ8ORWMugGHH3aRIrpVCi/TaAy2Y7sqkLo/Kx/IcOfz7jqraZ8sVpez7HWpl6RPSB3wBzc32GgXlTo/hC5Nhxawrbh1nj8ciptzPsR1qfjw/WKAz+TLgJe3Uecp3WjsF9PQcj0lL7+Ru1eqRauhTmDPRUIuZ9F4GCxXZH1VdtTwHY42x6mBvTMk4ZKD3fvgwAnafE/5lAx3IDZ7Xx8s08OSyyo7m4cvVz0ZpWb8m5TAEYqDMSMC/JQwqffxkg3Rxnj459Rp8n8qL7vc/VAmV0EqxN+lXxEaK/lLlGKoo0nn1x/yJaj5y2mcxosEerqMcpP9JE5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QIF0rToPwnXjJGFF9GJFMN2mrYm+YPpwEXfT3sBNFU=;
 b=g63Oc0sgzvblgqxdQXIdEzJvNl/cIO42UdZcb2XTPhyd86gbfrTo+SWVhbBsKaqKSPZaPh6IIIgClhs6GGKV+Mwitc/RjuNKBOFvs1wNutjIQyMhhWQ3efL3GDrCh7bGQ4sHn1bBCx5TEAo9z76+8tcvCpqyHrX0Q4mqndsscJqZNjmoFwuH70prP1aEb1CAPmDV9EGArbfQ89qftICdl69ulL+2PeUkYPys3EEMsfWu/jCAGXf8h5mXVD4lzWPOLHcPVPpUCdn83k9ZFsbQ2iEg4CV6DvoYW0x+d1DEf5owm7FqXlLoks1pCRHzdAs68Ja7ZffvsV0f/4PwwIseFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QIF0rToPwnXjJGFF9GJFMN2mrYm+YPpwEXfT3sBNFU=;
 b=ZIRCfEwIySXMLmbZkVVddLbjdt9xfTiqxUNOydyYIeK361UM+w+SPmUijVQ/eRQlSKP9CNnYVYaakVLHcIOoTb0ewgYy4KF2axupnkNwY7IhnwBsTLqVZlV49GAOB9chl5bbZ+eoxNYxFtwpKb9EEzqvI6YGwyXNVEorCDsvdII=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB0078.namprd11.prod.outlook.com (2603:10b6:301:67::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Fri, 26 Mar
 2021 03:53:10 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 03:53:10 +0000
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
Subject: RE: [PATCH 10/18] vfio/mdev: Remove duplicate storage of parent in
 mdev_device
Thread-Topic: [PATCH 10/18] vfio/mdev: Remove duplicate storage of parent in
 mdev_device
Thread-Index: AQHXIA314QKI26uvGE6aXFr+EROjYaqVpK7w
Date:   Fri, 26 Mar 2021 03:53:10 +0000
Message-ID: <MWHPR11MB18864F0836984277A52BB4CB8C619@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <10-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <10-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 5c72b7f8-97d4-48f8-503b-08d8f00aac6b
x-ms-traffictypediagnostic: MWHPR11MB0078:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB0078490BCE99C52A6A45DB2C8C619@MWHPR11MB0078.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nBDLM1YkbqE0+GQcEKgeaTe6gJVkQw26smoXkrLGXO9X+MHOxAeqhubSwFJFyw3AWXwzdfPXaQ5TZk5a7WSXEENeooWcwyu6JktTcT1AF5NrvAbYSwDq5zGM1O6nPgkh4EnzX7VFYBHLumIiO27601fRQRTS9u69D0Dr7/XIkiUg78d5MZeDkHEfdakCtQFnfnjofCFaKOqGMH4OPIEMIGYBL7Az0Rm30GOd5Z3OkP9Jn8itbFkz6DmIw3tx7p38NrBVxXTi3MX81LZT9NTb/4der7VHL14xMNBQEHvUpde1Cqu2GWx8lb8soIYvs0p2W/MPD4nIe7l6Ou7eKBnXtvBWDyfK6In8WZZ/mkdLP6oCwGfraCSXjlRF3K3jWleanhGf+RMiF+buBpvctzEGR6NNKyy6j96zz3nTktQuQ2xfhJtXZS8d+qNczeoMndgo92ZVE9FXgI3V12mE2TsCw2r8Hz3KJW4YN4hddq49UWKRWMVl3W2vtNX7kjsHK51nTk95/CMG8xG8VtE8DNtJZG+EK1753YIKBHlDw2bbgqGkI7kpKfjWCITLVhAly7c8YtHx9/Hkq5YAxiC1rl+MES488wV58S4xfZ9dEVgXJW24g52n1lHMzq4EwtAOzM3VDvLECc6hI+DACkMf/OnN0193fJAuIPWdwxbkMeTuz+w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(366004)(39860400002)(376002)(76116006)(6506007)(7696005)(33656002)(26005)(83380400001)(38100700001)(86362001)(478600001)(5660300002)(55016002)(66556008)(71200400001)(64756008)(66446008)(66476007)(52536014)(186003)(66946007)(54906003)(8936002)(2906002)(8676002)(4326008)(9686003)(7416002)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fLkgkDlTsQ+8MnTX/rKl39ob0wn0nOIbA+Xfg2ucO44dRyk+TMOWTIkPjksn?=
 =?us-ascii?Q?Xzg00zwdyizFRFGPH/TB44qNipuWWvaCd7OFxfoRvaE6xJ3ViTrjBlkPmZ0o?=
 =?us-ascii?Q?t3ymOBchI96zkFsrPVEfV35lcR25UqTmsA5rveWkgj/RL2DyhOnrC+L/yQxS?=
 =?us-ascii?Q?8yN+TJCS21g9RF3SDRkVJGaDhkrV6gcl/lixXVBp3ccDiLQ+LVbVRjzU3WY3?=
 =?us-ascii?Q?b9pXzrdm8EEldNBVrqnVSv5F0fViJzS16Kf2tl8jlVL+Jp/biOG7Z24Eepfp?=
 =?us-ascii?Q?lre+gxYrhS1SEWCU7QH1+vBlrfjJpZX4UAel3DCjd9yqCxMvyQHtYjMbKcFC?=
 =?us-ascii?Q?IjK9/y+cX3bSksQbb6om0XKRJ9B+coMlg2r8K9Ila6hn3mJaxyA9Yas54HrW?=
 =?us-ascii?Q?TmtDMnZ3J2uWGTInAesibRw8UdkUKC1t0BAjQ03udBrMgR4w9jYlReIHH/Ll?=
 =?us-ascii?Q?8CQbNC1g7IEvR6+jPPwOTgSTNEZDtnhSzsoHhiR4ehseumLSXyhzBugCY6sq?=
 =?us-ascii?Q?wzJxdwKzodKvb26whcboV+yMixrDa4/VesRdQDAK3qkjj3vbD9G80rx5QNGL?=
 =?us-ascii?Q?6Wl7+77ulIuTc/7xHUVo5JsIZotwxHwpFHCvySHVC7U+9StZxI5wfqfWUJq3?=
 =?us-ascii?Q?tExpfxfYjA7PWKpgSpFJFN8+02JMEvZRhKziMjXKaoUEQRWQQ2m0esU+N2EI?=
 =?us-ascii?Q?uch+8T2MRKMPW/mkYiuAeJczVfFZM1BmBekeAJJAuBzBO8Y5U6PJO7tW+LzD?=
 =?us-ascii?Q?RVrnI3ZLNlPXhztCxpWIIKHYtLE/JoLK8yCRzmY7VhYIgl6u2uwjLXYQyDIA?=
 =?us-ascii?Q?gxPbGNqSaa7kQVeYOZmnsu60YjL0gFvL9y7P6cw0fRmMriSAc9wRNnVFzmK5?=
 =?us-ascii?Q?DxB63PCjUm39L5UpBewb5VshZyO//64M+58X0A5KkmNBkGAQIMbyZeWBXsbY?=
 =?us-ascii?Q?+3uQ3POlHlIbHOpjGDv6x00ZM2pC+Bznr3XDPQkWdegUF0XQzJbnS1AquuhG?=
 =?us-ascii?Q?d8X/1wjmo6mRDLT6jWMM1FlrncHlPy1dSuUT4Pkuek3vtu3aw+2xkm8kQJMY?=
 =?us-ascii?Q?u62Y1U5j1k5XgihafNgyoDLFwwH5ocI5nIXM3KLRmov9VtK8WOqaIvNyUkO/?=
 =?us-ascii?Q?GB4kxKICLlmXEZuxMjd9DOu7IzmFrKw1vpEbiS+Ewzx9/EJoyxt6epojEQTS?=
 =?us-ascii?Q?GJ+7AenAEyozHpHkTe3wV3LHldrUzbKtIkhspM/0tBM7Ol/pWgYriESo49nZ?=
 =?us-ascii?Q?qeyTq1CTqaT1D7GxJzjVtmXEeC7txOXMrpA+Qs4u0Zktxo0EVCjgZpdNZ57L?=
 =?us-ascii?Q?mTkIBCTTzx1/f2S/4cibm0MD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c72b7f8-97d4-48f8-503b-08d8f00aac6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 03:53:10.4609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UnDd2M7n4yKkxxqcSXUWNW5zjXWkfK6MwtRGUJEEl5W0c7JgabBn36IMuFeyfB+PUXH1V6q0We4PsOfteprmFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0078
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 24, 2021 1:55 AM
>=20
> mdev_device->type->parent is the same thing.
>=20
> The struct mdev_device was relying on the kref on the mdev_parent to also
> indirectly hold a kref on the mdev_type pointer. Now that the type holds =
a
> kref on the parent we can directly kref the mdev_type and remove this
> implicit relationship.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_core.c | 13 +++++--------
>  drivers/vfio/mdev/vfio_mdev.c | 14 +++++++-------
>  include/linux/mdev.h          |  1 -
>  3 files changed, 12 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 4b5e372ed58f26..493df3da451339 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -29,7 +29,7 @@ static DEFINE_MUTEX(mdev_list_lock);
>=20
>  struct device *mdev_parent_dev(struct mdev_device *mdev)
>  {
> -	return mdev->parent->dev;
> +	return mdev->type->parent->dev;
>  }
>  EXPORT_SYMBOL(mdev_parent_dev);
>=20
> @@ -58,12 +58,11 @@ void mdev_release_parent(struct kref *kref)
>  /* Caller must hold parent unreg_sem read or write lock */
>  static void mdev_device_remove_common(struct mdev_device *mdev)
>  {
> -	struct mdev_parent *parent;
> +	struct mdev_parent *parent =3D mdev->type->parent;

What about having a wrapper here, like mdev_parent_dev? For
readability it's not necessary to show that the parent is indirectly
retrieved through mdev_type.

>  	int ret;
>=20
>  	mdev_remove_sysfs_files(mdev);
>  	device_del(&mdev->dev);
> -	parent =3D mdev->parent;
>  	lockdep_assert_held(&parent->unreg_sem);
>  	ret =3D parent->ops->remove(mdev);
>  	if (ret)
> @@ -212,7 +211,7 @@ static void mdev_device_release(struct device *dev)
>  	struct mdev_device *mdev =3D to_mdev_device(dev);
>=20
>  	/* Pairs with the get in mdev_device_create() */
> -	mdev_put_parent(mdev->parent);
> +	kobject_put(&mdev->type->kobj);

Maybe keep mdev_get/put_parent and change them to accept "struct
mdev_device *" parameter like other places.

>=20
>  	mutex_lock(&mdev_list_lock);
>  	list_del(&mdev->next);
> @@ -250,9 +249,8 @@ int mdev_device_create(struct mdev_type *type,
> const guid_t *uuid)
>  	mdev->dev.release =3D mdev_device_release;
>  	mdev->dev.groups =3D parent->ops->mdev_attr_groups;
>  	mdev->type =3D type;
> -	mdev->parent =3D parent;
>  	/* Pairs with the put in mdev_device_release() */
> -	mdev_get_parent(parent);
> +	kobject_get(&type->kobj);
>=20
>  	guid_copy(&mdev->uuid, uuid);
>  	list_add(&mdev->next, &mdev_list);
> @@ -300,7 +298,7 @@ int mdev_device_create(struct mdev_type *type,
> const guid_t *uuid)
>  int mdev_device_remove(struct mdev_device *mdev)
>  {
>  	struct mdev_device *tmp;
> -	struct mdev_parent *parent;
> +	struct mdev_parent *parent =3D mdev->type->parent;
>=20
>  	mutex_lock(&mdev_list_lock);
>  	list_for_each_entry(tmp, &mdev_list, next) {
> @@ -321,7 +319,6 @@ int mdev_device_remove(struct mdev_device *mdev)
>  	mdev->active =3D false;
>  	mutex_unlock(&mdev_list_lock);
>=20
> -	parent =3D mdev->parent;
>  	/* Check if parent unregistration has started */
>  	if (!down_read_trylock(&parent->unreg_sem))
>  		return -ENODEV;
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.=
c
> index cc9507ed85a181..922729071c5a8e 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -24,7 +24,7 @@
>  static int vfio_mdev_open(struct vfio_device *core_vdev)
>  {
>  	struct mdev_device *mdev =3D to_mdev_device(core_vdev->dev);
> -	struct mdev_parent *parent =3D mdev->parent;
> +	struct mdev_parent *parent =3D mdev->type->parent;
>=20
>  	int ret;
>=20
> @@ -44,7 +44,7 @@ static int vfio_mdev_open(struct vfio_device
> *core_vdev)
>  static void vfio_mdev_release(struct vfio_device *core_vdev)
>  {
>  	struct mdev_device *mdev =3D to_mdev_device(core_vdev->dev);
> -	struct mdev_parent *parent =3D mdev->parent;
> +	struct mdev_parent *parent =3D mdev->type->parent;
>=20
>  	if (likely(parent->ops->release))
>  		parent->ops->release(mdev);
> @@ -56,7 +56,7 @@ static long vfio_mdev_unlocked_ioctl(struct vfio_device
> *core_vdev,
>  				     unsigned int cmd, unsigned long arg)
>  {
>  	struct mdev_device *mdev =3D to_mdev_device(core_vdev->dev);
> -	struct mdev_parent *parent =3D mdev->parent;
> +	struct mdev_parent *parent =3D mdev->type->parent;
>=20
>  	if (unlikely(!parent->ops->ioctl))
>  		return -EINVAL;
> @@ -68,7 +68,7 @@ static ssize_t vfio_mdev_read(struct vfio_device
> *core_vdev, char __user *buf,
>  			      size_t count, loff_t *ppos)
>  {
>  	struct mdev_device *mdev =3D to_mdev_device(core_vdev->dev);
> -	struct mdev_parent *parent =3D mdev->parent;
> +	struct mdev_parent *parent =3D mdev->type->parent;
>=20
>  	if (unlikely(!parent->ops->read))
>  		return -EINVAL;
> @@ -81,7 +81,7 @@ static ssize_t vfio_mdev_write(struct vfio_device
> *core_vdev,
>  			       loff_t *ppos)
>  {
>  	struct mdev_device *mdev =3D to_mdev_device(core_vdev->dev);
> -	struct mdev_parent *parent =3D mdev->parent;
> +	struct mdev_parent *parent =3D mdev->type->parent;
>=20
>  	if (unlikely(!parent->ops->write))
>  		return -EINVAL;
> @@ -93,7 +93,7 @@ static int vfio_mdev_mmap(struct vfio_device
> *core_vdev,
>  			  struct vm_area_struct *vma)
>  {
>  	struct mdev_device *mdev =3D to_mdev_device(core_vdev->dev);
> -	struct mdev_parent *parent =3D mdev->parent;
> +	struct mdev_parent *parent =3D mdev->type->parent;
>=20
>  	if (unlikely(!parent->ops->mmap))
>  		return -EINVAL;
> @@ -104,7 +104,7 @@ static int vfio_mdev_mmap(struct vfio_device
> *core_vdev,
>  static void vfio_mdev_request(struct vfio_device *core_vdev, unsigned in=
t
> count)
>  {
>  	struct mdev_device *mdev =3D to_mdev_device(core_vdev->dev);
> -	struct mdev_parent *parent =3D mdev->parent;
> +	struct mdev_parent *parent =3D mdev->type->parent;
>=20
>  	if (parent->ops->request)
>  		parent->ops->request(mdev, count);
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 349e8ac1fe3382..fb582adda28a9b 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -14,7 +14,6 @@ struct mdev_type;
>=20
>  struct mdev_device {
>  	struct device dev;
> -	struct mdev_parent *parent;
>  	guid_t uuid;
>  	void *driver_data;
>  	struct list_head next;
> --
> 2.31.0

