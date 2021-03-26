Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3BB34A12B
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 06:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhCZFwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 01:52:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:49577 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCZFw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 01:52:28 -0400
IronPort-SDR: dDGjO6lEThTWz+55C6JMHZg8ICD5B+QGBVh+00WkM8KLZrW8PTZmBC/7GeKp1jdbSvpQ4FM7tK
 nvUMT+5ODLkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="187790794"
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="187790794"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 22:52:28 -0700
IronPort-SDR: pDeDvfs4l27W0RRqvS1MOGtZv5eNb+wxp3zQZiDzfFGTdXTGZiBTmdpt4SceXk5CToZ4EsMcQq
 luJbCEU7Dn6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="514942064"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 25 Mar 2021 22:52:28 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 22:52:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 22:52:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 22:52:27 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 22:52:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRQrYa1gmJi2oy94HFaAyCIu4ReAu+bxfI75XJkwEHf2eX7fkCkmzu3D3d+ZIuxB0G5lNOGSM40ZV9O3oPXq2cG0nhIWWtnjqdmwan64fP46UbiqizQHwRgrrEP9K8459gUBsVSSwD1TPnaNfQiFDRfZEBd2VP8aTzK6wCpXsfSmi4mwODDtokvIlXDJv4jvKfZYqxGdh35nu4d5v10Yhrk8ET05LekqRnS23nvZt/iggvncHc1GCmIxzw2X7/WALX7nMOkssX+oUdUG6PE6bIIKO72PtMWG8JEXx4v7vm/km9+Dv6X5kB8M5PFGjDFFxyt8FfwRpu8sje0Znm+q7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LT2FelQOwFfxAZEn6Y9bKnMLEDDIpCciHuZtE4/xHaI=;
 b=exFHMCfo1Kn+vFTidWb0NEccXnBIQZjetN2frhWWr+HRGij1i9M00gV3ffUq6aYEX4aOF6LINbhKpTln8rzNZhCKfWNo/byazrSXRsOb8v+x9xAN/dZ5QRD+gJi5cQ7/pjkDl8bgoBLvcBueGhSod8fvxLqnQOzke6v4HlfxoKRhgqA/bRaCfiMVi+U0s/O+Qt3L23HKOIqZDNSAKm8qt01vmoYugegyC88Bv1yvi4PvyQFmd+eZp0b2ynL7V4NT03Ofr8h9/xAzfkIbifWEtrccPkGMEQsdmrLg6AXqApmmMRST/U8YCyEGes6mHc/UMn6Zd9xtUozwgMkQ8ZJl9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LT2FelQOwFfxAZEn6Y9bKnMLEDDIpCciHuZtE4/xHaI=;
 b=s3uXniZBKq1aXWEcMcivWf25HvGNE1uEdssen38jfAtVhSLATLf2y9eVRJ66vqd7dvGh13QcgDYaiegRHzI/L2E+C7S0q3PO+E+RGXyDaH6UUVWk2eFAkDKCf96LxMdbl4G7FLACL89RLC/h8DDtfFc+IYlV+Q4GzZQfw05h66A=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1344.namprd11.prod.outlook.com (2603:10b6:300:23::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 05:52:22 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 05:52:22 +0000
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
Subject: RE: [PATCH 11/18] vfio/mdev: Add mdev/mtype_get_type_group_id()
Thread-Topic: [PATCH 11/18] vfio/mdev: Add mdev/mtype_get_type_group_id()
Thread-Index: AQHXIA3x0EzyiEKgFkeSXLmdYoJ7FqqVyCCg
Date:   Fri, 26 Mar 2021 05:52:22 +0000
Message-ID: <MWHPR11MB188649903C00137979C3AD838C619@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <11-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <11-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.214]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1fdf339-4825-483e-2bab-08d8f01b5366
x-ms-traffictypediagnostic: MWHPR11MB1344:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB13449E589F2DFD879B1461318C619@MWHPR11MB1344.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:188;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oVCM0H+0cjL6xBL3kgeU3yuARUD81Z43gkW/ZlYXpF7NsKafMcvztYwJ+Ghb36p9Jfm167PoafM2AlBd4QgNHZcrnnNM4Hc9MHgPeIlWZaXTlpKFXspsC0JjowbIHYJH/Q59OA79WLKoM7H1ZXAePPfH/kGsC1RBAkPHvlfvzU8AizJ4nGTlihYFDSdwnXc73MHRY7Jg+vXYFOoirJGN5uMT4c7SDmCsYw6CKFthlDvQGjGji++nM6fLzxKuEqjUwLCYObQRKUl0t774JhcV4GqpyIvFqXpR/gVwiNO28CXUYPyFGK3+YNe90wy9xpZbs2GKPrx/OlJMHoCbWGd8tQAfOkvNceI3G9OA71TqLGOOL/G0pur+KkKQWE6OIQeqWcP+kg9QzNrmwJulguTXA31+SQir8Zy0oxpodLzOeu7/6PuP4n2ZmjRKZi1kdeT6xOrBQZKMbLB4SxJE5mrLT1bHKz30+uvk+aTiDxMhX3Kf42K+q4rNamk6Id20sRTsD4TXz3Z7/Hueu4vmOxrBFkpbnwTydKWXmDHbSv8CKRwpcdmTE+yv3wJ9U2ij3bal0MjZDCArq0QVRGtFdU7ladCsxM1GbGi6Q4wh2cO9Wv6NHfN/x4rlbbmas/A/gvBertOJkAZ4axnlrfUQP998IQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(478600001)(54906003)(38100700001)(83380400001)(110136005)(33656002)(26005)(186003)(86362001)(7696005)(6506007)(5660300002)(316002)(9686003)(66556008)(66946007)(2906002)(7416002)(8936002)(71200400001)(8676002)(4326008)(76116006)(52536014)(66446008)(55016002)(66476007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8b2lNpHn92dq0ekCMvz+ePBaemdI7YOGQcUzYMuQYcrABEwMR2crRY1uOrA6?=
 =?us-ascii?Q?q6okNvnmq0aLGqYsXlEU+XBueszikdbrUW6LRUvCQr3COCIGLU1R8qLyU5tp?=
 =?us-ascii?Q?SuwRxaKfe6Jq5tixtu9iBu/U09cNYnZVF1KfFrtb5arAUIC6KIBkuMvoA0T7?=
 =?us-ascii?Q?krqe+QJOiVHRcQMWODBcnjJzx3a1bGDI9mfqHAOIvAAlofPQDPnaRr4ga1oZ?=
 =?us-ascii?Q?E6QodJHd8cEiQTtH5Un9pRAk1WTG5ahZl5p9Ohn+nhiaD+UmRd2vSVHPbGBW?=
 =?us-ascii?Q?ZmhC9sX1X+/xiIEnR8Hji7pu+61Lmvw38grBokX7icaVpGNq/pJLP22u1ruq?=
 =?us-ascii?Q?MGJxq8Wh3+fPmJUCmXjaZ3z5dSsAa5yoEH2D5HN2F/klWmIFOQAriiR6Pr+n?=
 =?us-ascii?Q?xvCBiAYRrwAgZ91KtkzXL07szuNr5syzx8906mvCh9d5QB/NC16COBguZKLk?=
 =?us-ascii?Q?3yuFHT5q3d5BLvipQSZusmGEek2ZXLfC6uw2dSRiXiVvGYoc36oTuDuoal/7?=
 =?us-ascii?Q?zMn62fxJYJ3RC27dnYmU8L15+QXbItGekZr0dKsTXBdTpCzI9eknOEJgh0df?=
 =?us-ascii?Q?6+T4CCwlb1IkwcuOwEpB1i5XL7ZU1aWxOC1wt4VehhMym7tXkY1Xq0fj5BQE?=
 =?us-ascii?Q?4jeLgMJs/qdVsOgHP1Ycl0MuRteJDKN/h7yDtcyYd0QEAfMl0KENxCd7G3YR?=
 =?us-ascii?Q?ZacfXgFrZ5E10wDTZq43wMKJd1nqHYbw5mu1BfVB/19W/y2mRHZwyF8h1lPd?=
 =?us-ascii?Q?lzEI+FnMR2HegE2s7IXiR7QBraWBOvIz8/6Obmo5DwtLtlq9Ag1Xann68reE?=
 =?us-ascii?Q?rRRUlRZusrD3SOqPaCMiw/deQOY211xIzt6X2nuyTGTbZqc0+eqphRKebAq4?=
 =?us-ascii?Q?CRBrQJoJWWW+fq5ubVZSE3H63nPQ1qfGFPokaKIpgFR4gw4DVwJKEVd0GLzo?=
 =?us-ascii?Q?kuVtTMbeNXcZwuLbOdiKqu3x0V3dy+zwhA1zYSuWGyceyP58RlPMRf2Fo/Al?=
 =?us-ascii?Q?eAcsQRqvrUrtuOdQ6iDvAL9vlgH0cWIHxGc56q6iZ0H2cbQs2TWJ7NYmmRTR?=
 =?us-ascii?Q?x6apOmw3y9Od2yYECzLZGDe1+/94iii9vB+hVyfxl6QD9Z+m8hnEw8YN4Ktp?=
 =?us-ascii?Q?t9HYvzFrYBaWoHYpgWjxEhAwVAM8wtDOTkgwCA1ePdcS0ybF4F6eHvaQuCbU?=
 =?us-ascii?Q?TE8zFhyr8Uh7fzJjpKP8IWFE0bpLqi7d1cqb5nDZE23boEz9XUWob4GPkVnN?=
 =?us-ascii?Q?xYguxXjBRpitgeXsniy6zFIWdwKke0nVbk4whmMuYCTacRCh1UFCFZygHbLq?=
 =?us-ascii?Q?aWlkr+5eLNfybTz/cmBYcSJL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1fdf339-4825-483e-2bab-08d8f01b5366
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 05:52:22.5723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fykm6ktqL+pzbcze2C2gGabKACQpShTgfbu3d87NN5emt1re21tyjALFqJ2YzrIkOQ8pf/AAz7ibiCE591NbeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1344
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 24, 2021 1:55 AM
>=20
> This returns the index in the supported_type_groups array that is
> associated with the mdev_type attached to the struct mdev_device or its
> containing struct kobject.
>=20
> Each mdev_device can be spawned from exactly one mdev_type, which in
> turn
> originates from exactly one supported_type_group.
>=20
> Drivers are using weird string calculations to try and get back to this
> index, providing a direct access to the index removes a bunch of wonky
> driver code.
>=20
> mdev_type->group can be deleted as the group is obtained using the
> type_group_id.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/mdev/mdev_core.c    | 20 ++++++++++++++++++++
>  drivers/vfio/mdev/mdev_private.h |  2 +-
>  drivers/vfio/mdev/mdev_sysfs.c   | 15 +++++++++------
>  include/linux/mdev.h             |  3 +++
>  4 files changed, 33 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 493df3da451339..3ba5e9464b4d20 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -33,6 +33,26 @@ struct device *mdev_parent_dev(struct mdev_device
> *mdev)
>  }
>  EXPORT_SYMBOL(mdev_parent_dev);
>=20
> +/*
> + * Return the index in supported_type_groups that this mdev_device was
> created
> + * from.
> + */
> +unsigned int mdev_get_type_group_id(struct mdev_device *mdev)
> +{
> +	return mdev->type->type_group_id;
> +}
> +EXPORT_SYMBOL(mdev_get_type_group_id);
> +
> +/*
> + * Used in mdev_type_attribute sysfs functions to return the index in th=
e
> + * supported_type_groups that the sysfs is called from.
> + */
> +unsigned int mtype_get_type_group_id(struct kobject *mtype_kobj)
> +{
> +	return container_of(mtype_kobj, struct mdev_type, kobj)-
> >type_group_id;
> +}
> +EXPORT_SYMBOL(mtype_get_type_group_id);
> +
>  /* Should be called holding parent_list_lock */
>  static struct mdev_parent *__find_parent_device(struct device *dev)
>  {
> diff --git a/drivers/vfio/mdev/mdev_private.h
> b/drivers/vfio/mdev/mdev_private.h
> index 10eccc35782c4d..a656cfe0346c33 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -29,7 +29,7 @@ struct mdev_type {
>  	struct kobject *devices_kobj;
>  	struct mdev_parent *parent;
>  	struct list_head next;
> -	struct attribute_group *group;
> +	unsigned int type_group_id;
>  };
>=20
>  #define to_mdev_type_attr(_attr)	\
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> b/drivers/vfio/mdev/mdev_sysfs.c
> index d43775bd0ba340..91ecccdc2f2ec6 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -92,9 +92,11 @@ static struct kobj_type mdev_type_ktype =3D {
>  };
>=20
>  static struct mdev_type *add_mdev_supported_type(struct mdev_parent
> *parent,
> -						 struct attribute_group
> *group)
> +						 unsigned int type_group_id)
>  {
>  	struct mdev_type *type;
> +	struct attribute_group *group =3D
> +		parent->ops->supported_type_groups[type_group_id];
>  	int ret;
>=20
>  	if (!group->name) {
> @@ -110,6 +112,7 @@ static struct mdev_type
> *add_mdev_supported_type(struct mdev_parent *parent,
>  	type->parent =3D parent;
>  	/* Pairs with the put in mdev_type_release() */
>  	mdev_get_parent(parent);
> +	type->type_group_id =3D type_group_id;
>=20
>  	ret =3D kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
>  				   "%s-%s", dev_driver_string(parent->dev),
> @@ -135,8 +138,6 @@ static struct mdev_type
> *add_mdev_supported_type(struct mdev_parent *parent,
>  		ret =3D -ENOMEM;
>  		goto attrs_failed;
>  	}
> -
> -	type->group =3D group;
>  	return type;
>=20
>  attrs_failed:
> @@ -151,8 +152,11 @@ static struct mdev_type
> *add_mdev_supported_type(struct mdev_parent *parent,
>=20
>  static void remove_mdev_supported_type(struct mdev_type *type)
>  {
> +	struct attribute_group *group =3D
> +		type->parent->ops->supported_type_groups[type-
> >type_group_id];
> +
>  	sysfs_remove_files(&type->kobj,
> -			   (const struct attribute **)type->group->attrs);
> +			   (const struct attribute **)group->attrs);
>  	kobject_put(type->devices_kobj);
>  	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
>  	kobject_del(&type->kobj);
> @@ -166,8 +170,7 @@ static int add_mdev_supported_type_groups(struct
> mdev_parent *parent)
>  	for (i =3D 0; parent->ops->supported_type_groups[i]; i++) {
>  		struct mdev_type *type;
>=20
> -		type =3D add_mdev_supported_type(parent,
> -					parent->ops-
> >supported_type_groups[i]);
> +		type =3D add_mdev_supported_type(parent, i);
>  		if (IS_ERR(type)) {
>  			struct mdev_type *ltype, *tmp;
>=20
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index fb582adda28a9b..41e91936522394 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -46,6 +46,9 @@ static inline struct device
> *mdev_get_iommu_device(struct mdev_device *mdev)
>  	return mdev->iommu_device;
>  }
>=20
> +unsigned int mdev_get_type_group_id(struct mdev_device *mdev);
> +unsigned int mtype_get_type_group_id(struct kobject *mtype_kobj);
> +
>  /**
>   * struct mdev_parent_ops - Structure to be registered for each parent
> device to
>   * register the device to mdev module.
> --
> 2.31.0

