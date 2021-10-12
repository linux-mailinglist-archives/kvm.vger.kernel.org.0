Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9685429E4E
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 09:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhJLHKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 03:10:54 -0400
Received: from mga05.intel.com ([192.55.52.43]:4416 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233553AbhJLHKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 03:10:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="313257040"
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="313257040"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 00:08:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="547350050"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 12 Oct 2021 00:08:40 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 00:08:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 12 Oct 2021 00:08:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 12 Oct 2021 00:08:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7e1YPFpJUVmbD2QiwwnBTRd8zRylW5cfTjXjkPHk50vnbrmqEEvanowHLkFLJPBRivdHYhcAReyOqg8BJCEYy5FU3U7Wp6Jf++Dx0zeAaM4auOMi2z+fLGuk7noVuyicIMaWWbnd3gqkUXbtpPMltttzXI1ayPDTHTvIyW/tRrNRqs+90dp2etB2o21pOmgTQcTDxji+4H62GkTGQl8cgGPtq3kf9ZLtoGZwCz44JLNLJYP+rXQCmPTBfl6gM6BGPobuBHnIAMAfdqu6WRk2/Ieg8AsSs0v17TW2tNh9dKhWLOWVdaJ2sFKt2++JGgdmgLtBKA+YT1xhxXxAdTjGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6xOpe2iwxycbGhowEu+BbqYz/yphwGtotHKVQVKe7SU=;
 b=jMI5DM+4QgTh8tMz4nCi43F64dVXvg3BeFfHVvl8vS0SImQPH9PqxmpBVuuXobg8DxMKEYPTs6TK5FUjzXgWoPWbqv8Y/yRGyXnX55RjCfdHrzY8TR/LprnyFMWMlr4paHXhO0sXpWFQGIl65uH5aBEOrp+od463aEfTSGZd14Cx2lRlwGDabEjZhpL5sB7L5pVHETbyA1E6OO0S08eVQTzqC31pgwCKxcNDpKHZUng3yu3BXLCi2jhlgwjiXifDA+JicfDTNohCc01aJCFKSosYicglh5uTD4ZcFBMQA1jRocF9f3d2DiVZlUZDYbY19zHeh3MUTxe4csfZDk4Gbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xOpe2iwxycbGhowEu+BbqYz/yphwGtotHKVQVKe7SU=;
 b=MzJQmE2S2N72VkL7eWj4/TFLS/ZtN2XUqkJR7btmeUu09/PkpiJ9m05321oQIXOrfdvGLg9C3tf2JJDrDzvfoSCbkVJGa8FdL0xWdiv32X2lDmiPXaf+s3Hh+Rv1NK8+c4TzeYFZMWHFIP+2+ulMQe6IggUNuMyWdrxss4tDNdc=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5356.namprd11.prod.outlook.com (2603:10b6:408:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 07:08:39 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 07:08:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 4/5] vfio: Use a refcount_t instead of a kref in the
 vfio_group
Thread-Topic: [PATCH 4/5] vfio: Use a refcount_t instead of a kref in the
 vfio_group
Thread-Index: AQHXtxtH6yLGWtQULUqtsTKXz67IWavO/xJg
Date:   Tue, 12 Oct 2021 07:08:39 +0000
Message-ID: <BN9PR11MB5433B02AF50ACFBBFB29FD658CB69@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <4-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <4-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf12c7f6-373f-4b23-3e04-08d98d4f1de0
x-ms-traffictypediagnostic: BN9PR11MB5356:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB535627E8315BEF758015C53A8CB69@BN9PR11MB5356.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1plbo39r2pLbM2buqVHA/PBf0hrZxx3EwG43ZcBy9Nh/F2Eoh0mUo3d6OZ9ZAzj2kl3JH0CsfdWlumkoSSFkQkC+pO0Cf2Hn0F1yuzEe1L83mzQzk6d3yTObsfUbj13kzqEjBZHm2T1BGX+elQQNi1S27+iWzP35OmnMcRm/Gqz1rosRbYIvnMAVXIUkfaqVI/Fs+MEsLUObxHIDQeOp0L31yxybr/pfjD8zbosG0fnZXuECk805fxWKNYnbpM0qEVpKCwITYqRMgBTraEJjlJ33iXuWtBVYkCOl0xMZ4MXH0WPFdjMr+QiSRceUGmD0h9vJXNZm09wmVwZKBtnHUYBu65IZ9fbCebjD8NEoqwA24STfdti5e6TZVh04/LHbx0+A/FwPezPswYkzfR/A50so6rumfNRUSWy5XPPygq2m/25dnolvIS00g0B6QPIiH9y2NXnblMiwPpEHWMVWvLPxqgAlPFbk/+LvYwea+1T3sL5Ov2IwF/8QWNC56whuCZn2uFpJOpdcPJkdBea0aAV/HSiTIAcKv6RFEam8bA3Ao4yGmY13kgqMbfYuKV229flbNIHfXI+2WUo9w0cm1uxMve64snosT6XH9uVdpUwoXwbiJuVzoehYmigJ8av2Udxpv6wE178CZZnsRIcKLhVVClrrRE0abEx22ZweVHOHQsTPy+4wBR/zloimIitZgdCQ+wZ32anPx0vYisWWmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(2906002)(83380400001)(107886003)(122000001)(38100700002)(86362001)(71200400001)(110136005)(4326008)(66946007)(9686003)(6506007)(508600001)(8676002)(26005)(8936002)(5660300002)(54906003)(316002)(7696005)(64756008)(38070700005)(66446008)(66556008)(66476007)(55016002)(76116006)(52536014)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Xxe7KOXLb3jy0kW4A3Wh/lOqkTd4Pm8DkuhvpspKvHFfJt7Cq6S2+zOkXSSs?=
 =?us-ascii?Q?DOQRe3kbZI84i8A9N/7uNzaX/iP5Yh54fETVdvCtfFfHDGDxSTZyRssdrKap?=
 =?us-ascii?Q?BIdY6pjucXz0IFX164TDC27yohYJsLHHjsNSG9DHxEui7m5EkSzf08wyxoKE?=
 =?us-ascii?Q?3uR5kapG8TuLgYiS9aWk2BwwMvFrNcjEJ+v1Bj7bFm2l01k0Q+a06lLfVEyZ?=
 =?us-ascii?Q?mvJ2IjQNlcdzmGM+kjFUkPRhh4TxznOCG97iQqYb6m4RUXj482fPJQK+ehij?=
 =?us-ascii?Q?MRgQAC7Ecky9tHHmDNnk+vp/TUbt8trcDtP2XvURER9UItZWL2pUA2XiT43j?=
 =?us-ascii?Q?kG+1LGpOXg6EfV25JRW80bJtpOfIAeusudBm0fJx353uCEwfoNnBl4N72+6m?=
 =?us-ascii?Q?VIeRYp/KNeNH7DiwbDHVD7EkaGp5oIfyzsn42uSmFh1o1CSSGScdewmS3BVt?=
 =?us-ascii?Q?MmHeqBjmikX3Z3ikUmm4xHwq9hM2XD99KO1LDSeshS/ITiu81vox9SGeOTos?=
 =?us-ascii?Q?R+gfq/42QLqZ1oKocYgnz0FOoMMsG8UvQ+826dv6Fj4s/XNdjeVoQvXmYF2t?=
 =?us-ascii?Q?ND+rypS0y55MsN3NZv8j0CMvEeQPR/KX0hV4+I4SQr1v1FPrITHverE1MBKF?=
 =?us-ascii?Q?a2xZJvO1xZ7mdY6gKw0iE+3LpY59PTHuTkR7fl3K73qC/7Gx8zeX556G+rLg?=
 =?us-ascii?Q?GIvr11meNit+2dC5Ys7JHrVrpaP2nUM1mvWrkijGJNX3US8adOxZz3Tw7fHT?=
 =?us-ascii?Q?9olkFXst6p5S6zq8ip9kbRHynQbYBC0LvA18RFK0YauoUmgbJ8E5L8DSdF9P?=
 =?us-ascii?Q?gqyAU9kghU4P0xO0bjhsJ+rgY4deKJgZHEoyC2Z+cqBpSJO5ZbT9s9gIJhoi?=
 =?us-ascii?Q?oT+lEPReCfcbZLyOaageC83Hn2epbWZsc7c0M6vxSgs4y1hUGiZI8uSwzuOV?=
 =?us-ascii?Q?NZH72aahV3ktaVW+00bVpsnFJjYyVECsDmEiCEELAkhfdhJOUiNyuxhq0c3j?=
 =?us-ascii?Q?6jxrWkkC3j1jsAKl3C88THnZWbmowJUv8WWSvSZtqAcfBn08vq0W7xifAtfA?=
 =?us-ascii?Q?PBPcf7mjbgQb0lMy2EOrC9Nk8LvrfrqghL0cRF9FzkIuF1KOCL+HgX9z5CUI?=
 =?us-ascii?Q?wYfv9tv0Xzv8oX/Hl5ZsbmKBLZZxOTIiXCTPtaT/5zYfZKM89cdLe93O3Lsw?=
 =?us-ascii?Q?5qUIASMj5LmdsSIxHvLq/cHn3LhUtNqDL6buWMM4Iesb85lFvmmZ4TCurr5c?=
 =?us-ascii?Q?pqjhX9vvedLPsRjfjRMMX33AIp82z46vmHgSMmF3z4ywApp2aKyf15knsWfJ?=
 =?us-ascii?Q?47NMvu0DceAJOhrvzXnqfLo9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf12c7f6-373f-4b23-3e04-08d98d4f1de0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 07:08:39.1081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FYkzCyUYWDTr0A07DuYW1Aqtwr3ehri6i7HFN+R6doljTKkwd2SOGRKgQ3kerc42s0lWdWw0S/5Gg4r/cCSg7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5356
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, October 2, 2021 7:22 AM
>=20
> The next patch adds a struct device to the struct vfio_group, and it is
> confusing/bad practice to have two krefs in the same struct. This kref is
> controlling the period when the vfio_group is registered in sysfs, and
> visible in the internal lookup. Switch it to a refcount_t instead.
>=20
> The refcount_dec_and_mutex_lock() is still required because we need
> atomicity of the list searches and sysfs presence.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index bf233943dc992f..dbe7edd88ce35c 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -69,7 +69,7 @@ struct vfio_unbound_dev {
>  };
>=20
>  struct vfio_group {
> -	struct kref			kref;
> +	refcount_t users;
>  	int				minor;
>  	atomic_t			container_users;
>  	struct iommu_group		*iommu_group;
> @@ -381,7 +381,7 @@ static struct vfio_group *vfio_create_group(struct
> iommu_group *iommu_group,
>  	if (!group)
>  		return ERR_PTR(-ENOMEM);
>=20
> -	kref_init(&group->kref);
> +	refcount_set(&group->users, 1);
>  	INIT_LIST_HEAD(&group->device_list);
>  	mutex_init(&group->device_lock);
>  	INIT_LIST_HEAD(&group->unbound_list);
> @@ -441,10 +441,10 @@ static struct vfio_group *vfio_create_group(struct
> iommu_group *iommu_group,
>  	return group;
>  }
>=20
> -/* called with vfio.group_lock held */
> -static void vfio_group_release(struct kref *kref)
> +static void vfio_group_put(struct vfio_group *group)
>  {
> -	struct vfio_group *group =3D container_of(kref, struct vfio_group, kref=
);
> +	if (!refcount_dec_and_mutex_lock(&group->users, &vfio.group_lock))
> +		return;
>=20
>  	WARN_ON(!list_empty(&group->device_list));
>  	WARN_ON(atomic_read(&group->container_users));
> @@ -456,15 +456,9 @@ static void vfio_group_release(struct kref *kref)
>  	vfio_group_unlock_and_free(group);
>  }
>=20
> -static void vfio_group_put(struct vfio_group *group)
> -{
> -	kref_put_mutex(&group->kref, vfio_group_release,
> &vfio.group_lock);
> -}
> -
> -/* Assume group_lock or group reference is held */
>  static void vfio_group_get(struct vfio_group *group)
>  {
> -	kref_get(&group->kref);
> +	refcount_inc(&group->users);
>  }
>=20
>  static struct vfio_group *vfio_group_get_from_minor(int minor)
> @@ -1662,6 +1656,7 @@ struct vfio_group
> *vfio_group_get_external_user(struct file *filep)
>  	if (ret)
>  		return ERR_PTR(ret);
>=20
> +	/* Since the caller holds the fget on the file users must be >=3D 1 */
>  	vfio_group_get(group);
>=20
>  	return group;
> --
> 2.33.0

