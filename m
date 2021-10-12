Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64B042A08D
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 11:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbhJLJGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 05:06:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:57057 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235458AbhJLJGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 05:06:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="224509316"
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="224509316"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 02:04:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="591675458"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 12 Oct 2021 02:04:50 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 02:04:50 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 02:04:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 12 Oct 2021 02:04:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 12 Oct 2021 02:04:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EH1hAiZnmzpVwGJgXuwOrbsRKuF720ClUVSeK0Nxf754ZAqNqHcxzu6psXPFSPwhXSbwkm4/pdTQY52+eS2U/HJSBhWeWF6T39Xkl2LE/6Q0l2YEgrzIaO4quIMKbRHwEJfJ4N8J96d2lYrShFL1/jih88F9gApc8/ZJDouYscVzL+t0xqaYp2DCDMc6iMO0SQJq1x0tysFR/3nl7Lz9gXNWicNWoWYTMg9oZXcigfCbqJvlroFU/1yVmS/xZCBVnswi1poM8o+XmnAcZFe+O3LS+FemwnOOB88BwZdspplzHF3XdAnFw9Ulzajy2JR3Ihy72vThtO+QwvdNyepTdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Par1y8tbmlSat+BMnq/SdSC3KLi605KMiiQiOmIyXk=;
 b=dgttY1sHofY8GvziKUT2Bc8BRjiFKbCE/5zMc/N1H58GrJmV9H7Rch1wEqKUEq/4eMo6j5dYRJSww4atnczcu8oFnWfxmepZ2vZKObxP0bDQZJtGGgrmMv0IPiGwqopYiLLZgHiOyi7jvB76hu/uyA6wXU7AP3jFFLBQnMWFGgp+NmFkGJreZa9WEOX0d+3JPQzmt0vHWbA+nciYKAulP7MNIVuXRUtyr3q/jVXfeuKrB3YoUDU8yIS8NsmiBw3tOocRrblh68xNCfPQUE0I2IQ9p2iFGl1iPkYbr6T7kpds23JLLdJ4IVv72nXiCRH2RiVlPMnfMymwNMHeoLEwGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Par1y8tbmlSat+BMnq/SdSC3KLi605KMiiQiOmIyXk=;
 b=sEJvWHwmSZjDg2QoHAQmxNlpA54TK7AFKRlyOCwXJJn+R82Mzqz5RBiOLkGfd0SYzH/cQZoiyGjgLJ95/e1mC07OEe6F3v+ICfKUS2jweOUrqL7pb/u3EudPavR1SkiVnIYdYn1VkZvSGxMvX11IBUYbMgrGgh3qZKWyMk6SsnQ=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5577.namprd11.prod.outlook.com (2603:10b6:510:eb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 09:04:43 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 09:04:43 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH 4/5] vfio: Use a refcount_t instead of a kref in the
 vfio_group
Thread-Topic: [PATCH 4/5] vfio: Use a refcount_t instead of a kref in the
 vfio_group
Thread-Index: AQHXtxtHMia+bWlPB0SpYOkMrV/m/avPIRfg
Date:   Tue, 12 Oct 2021 09:04:43 +0000
Message-ID: <PH0PR11MB5658F19D95D095CB87C0CFF7C3B69@PH0PR11MB5658.namprd11.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: b597367a-f7fb-4491-c97a-08d98d5f54ec
x-ms-traffictypediagnostic: PH0PR11MB5577:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5577F2923075DD43EC210F09C3B69@PH0PR11MB5577.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XmHwhoFgMGSzZMe17AkM1681Kp/T3pmZ4pcjnVuFWmf/N1II3qEntxUAT/ncfjXDW9fCwIeI2ezrcdwauGgtYgDyBhzliDcQZx7VReGpzJI1guU4Xk04OZdPXHNSazBWq6t7066iYrfxsBkD5lSsMn0vo9Tv/838Wau6+TXxFZXx2k4ly001IwEKHLmyJPmW96t/kPN+AGY44ZUbY6dx+5dafL41c2//XcY1JOC5DkG50Qb/ldt3AkQI5lTzS42NjVQZmPrWvVwDoIufypq0zcwipuuE0U2CnnffbNXz+0FeUf8UgvgUhdVJhwRypEJrDZ8cdjmANcmZ+uOTUpjMIaKfiqH8J9xp9984eHKGh4bsj68QoIZ9n32g6T7VicfzvK2CUK/mD67VNCbfW8bey8k/GUUtZcptFVOBsxEoIOcZFOiIsOv+11nQ31FdvrszZrkTSrId/r15gY36QmmsG5qEgZAJuL8ZyUPvl3D+m6VRQEsfpSHjJCAyRApqY++f31MeRcP1zpOZCBR+9Xx1pPd9/794L86YdgQoTH9QzQ0vbVE5fR2GGRUvVLbMa803QJjotkjTqr0GBOv8V5JET70Z90fI0DfLFSjKaLhz3+wn2iNZNls+QkOD3uHgab9RDjv33/jaS47OE+NmfGc2Wg3LePKBQ2nOaNZlhnrbDmMG9ziE8P5/p5ITm2j2zYvzRUSx9kVoz1btLY91R70IWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(66476007)(66556008)(66946007)(83380400001)(2906002)(66446008)(64756008)(107886003)(9686003)(8676002)(71200400001)(186003)(76116006)(508600001)(55016002)(5660300002)(86362001)(7696005)(38100700002)(54906003)(6506007)(38070700005)(4326008)(33656002)(26005)(122000001)(316002)(110136005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bY9TLWvBvpiWxl5tRCb5WEtQOWQV2y8BhBpZZO2zfQOIBT08jSuMT9DMfiQc?=
 =?us-ascii?Q?DobbuGwhj7uQE9PQH9LXArJ9ts6TbemRbFRcncFDljE3h2toKaWa3UXsarLe?=
 =?us-ascii?Q?UEKvjVUopPHul9bHjKJp+dM6WGYFOim0u8tLVfC5q0Ob1U10pl9B+BFewApB?=
 =?us-ascii?Q?2Cp3USpjgMa61b58DZCsZ5WOKpUpsxZnmbo6Vr8djGkTEy+e14FSAGgjx+CK?=
 =?us-ascii?Q?xb5M+cBZyoY/5Se5wloekD69qhlqUjheYeRjoZyJ7YFhzg/94dyoC6D0tOrO?=
 =?us-ascii?Q?pCc99FHWq+Az6MP92+/JHiTgjY7/nk6vBZdYhMf5YHai8M5f8fhihIOu1D+F?=
 =?us-ascii?Q?6addT1fMxOMjzV8eP6b+Zv9ly49ucpbfX15LqqtCb5M0i2/fl0r5G4Vii9aY?=
 =?us-ascii?Q?qQbFmLsCoAmlWMDmuT1Isboks4ifFvjvT5r+8Hu/nwJPipSjx5w9De/Pibur?=
 =?us-ascii?Q?vTxtVMvdtwiHPtogql3mihRASzOxwiM3cxSM64bNGEndLOvtpdBQBH5p/7Nx?=
 =?us-ascii?Q?I2dbSy8jKOHHrDg9LzkE8F0oEB2/aaLN8oVYpWkCXTFRgn+P28t34+9WD3QP?=
 =?us-ascii?Q?KtcgHDLC6HnPni91tNDKz0BfqBQpED5jyOI1UWnedjjNJUpGy+6lOnJ7SiCi?=
 =?us-ascii?Q?cpfvb7sGAZ6/N1Qi5445vACau5aws3Mxf8yElkZY1GsDemdN7WJWcYVRm7uX?=
 =?us-ascii?Q?6IiZIslOypW9hDQG4q8lvwq24JeygWMofidKJQmtMAbOXfVyFd9db07RG+UZ?=
 =?us-ascii?Q?ylbxrirl5Y5Pp68veRay0iRCzuZx2AYZgKqmR4EH0xU1ZhrQzKxYBaBppWI4?=
 =?us-ascii?Q?YSzj5FtTjk2VvpxNL6Z7xCSCWNjV+nyKMGMvm/GMO5AJNnZXT5LiVNfX2aDp?=
 =?us-ascii?Q?x+4faVp6cclHEF4uuGkc0Hr+Bt17garIy4oZs8qY9sFKK8NdDu78CrzJh0AB?=
 =?us-ascii?Q?GbVMtidbp4WxTnFnXw+21IKhQneHy2ISHdG4GZT/7LnI2xgFVLn7bu3VVZPz?=
 =?us-ascii?Q?Jb6F5GCzZ7o6yhcTiq5O/T620UZ91AJx2g9EN4VN6ItLprg0ItijhzcHDPfq?=
 =?us-ascii?Q?3GeoipCi8KIyy0lgH54eHJuuG/B1wux/Nb1QxGv1PWRH2n+utRPOhuHq0ji7?=
 =?us-ascii?Q?UYeMe3yMjAsFjNclhtspoUuMryLP40RuZKXqDZR56dmZApLQtvtZ9t7T4vb9?=
 =?us-ascii?Q?7MDej0vTOf+LSzXd/wgPPfiT+wSnn8KFjF//EduBmw8GWPKtIpd+y5TnpJZ0?=
 =?us-ascii?Q?cMqB3/5ZWkRkfMht39mgSOwZYZezmoZof6NeZigVpSG7GuFiyfeSMu3/9yc9?=
 =?us-ascii?Q?w6IJF9sS4Rx/cN+Qu09tBuWg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b597367a-f7fb-4491-c97a-08d98d5f54ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 09:04:43.5023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: INcSYQ9wvB02AFd/Uzsl0SHTVBd04eeAa3+sknB4Ur1JfOd+NjoQXKAwWv/r8BGtSoCZdXJEeVWKPvkq3JStqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5577
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
> -	kref_put_mutex(&group->kref, vfio_group_release, &vfio.group_lock);
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

s/on the file users must be >=3D 1/on the file, group->users must be >=3D 1=
/

not native speaker, but may be clearer per me. ^_^

Reviewed-by: Liu Yi L <yi.l.liu@intel.com>

Regards,
Yi Liu

>  	vfio_group_get(group);
>=20
>  	return group;
> --
> 2.33.0
>=20

