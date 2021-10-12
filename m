Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4CB42A05D
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhJLIxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:53:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:53459 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235225AbhJLIxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 04:53:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="214233198"
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="214233198"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 01:51:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="562546962"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Oct 2021 01:51:17 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 01:51:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 12 Oct 2021 01:51:17 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 12 Oct 2021 01:51:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipcSClxUeI7Udv/ce8b2zXU0p/CSR0avftkyzHVK05S8gBxvN8XgavAiOmLKME0ISseO5hdzqoeFtO+PKWdxSIv/g2fGRCjp4vq5ulbd6p22qGJRT9StN7ms81qcKhhfrR2+2H5AVDTA2E8exwjL3J5O1ZW3V7sZaaaUblw39ZvHmrI8g7hdty0tvcjLZLfMzbBk+d6ziPcgDa9QM9c5bmToIda0YGKiEVqsZry8K1W9iFnLT9/uuz2rMcntPAet2FA3WAzqTobNIp2MMWPRk+agQ1XcabTB3stbe8LtoUx5YFt8NgvbYNKIZSxady3cpe1qQ6V7Ly6xqqPKcCUb5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Qn31kUxeq5GKl5rKiguvRViuXukiAWomcEwnsjfEEg=;
 b=MIYQNsTcJRUIuxRvlvkGN/zHPbrv7OfnKMyb5Q0co+l3T7H/lHvTMe1X9Hp6QXox/bTkwCnFDB1Mm0EPSgjMPVlIcSA2XjsvRsYK3DFx8vQJiUXenbWxosVKpkC8BgvhX1dW5xs/dAhqGPsEBI1b6G1NE0zKwWHlVzzkQNzjWpzUroT0hjTJO801oI+GoNN6kEw4tK65CaLX6O+yrP1ycy7YD/oiUGHs7uuEMTWCE2o7cBSG/iW4KEFWDQ+DK2iE16s/WIAr9aBDL0+0g5nf3LO6h6JNrHLK6UkmrOnD7bEwtvnuJHdNs+CaqrhKQdOEi1Qa1VGK0dbDCpGyiCm/NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Qn31kUxeq5GKl5rKiguvRViuXukiAWomcEwnsjfEEg=;
 b=PxHbMwBxwHMnRR6jXuXt8zKoakI5v0D5e5npdFVX1wmGwSi505YG/GR+ZCb5nFJ6N9qv5yC48ij4e+DPuK5uzzeq2BTVGER/miOjfANCU0rNgB7G9SzQYwoIo1h/rqNhfbkDrD5AzJTiuAmhGPxtWWjVzPkRdAGkaNzGgsITehA=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 08:51:16 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 08:51:16 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH 1/5] vfio: Delete vfio_get/put_group from
 vfio_iommu_group_notifier()
Thread-Topic: [PATCH 1/5] vfio: Delete vfio_get/put_group from
 vfio_iommu_group_notifier()
Thread-Index: AQHXtxtG/4xhcpx/QE2zCYa18BuF66vPEJfg
Date:   Tue, 12 Oct 2021 08:51:16 +0000
Message-ID: <PH0PR11MB5658E449B5EED04056A4180BC3B69@PH0PR11MB5658.namprd11.prod.outlook.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <1-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <1-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cfbc9478-f7f3-469d-03f8-08d98d5d73b5
x-ms-traffictypediagnostic: PH0PR11MB5626:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5626E48CD1634C933E6B065DC3B69@PH0PR11MB5626.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: blqAtZWLm2niGxwScx0RV9yhdkZXkQQe0bNrRLbOj/gaCH1s6YC3xyJrVzLGMFsvKH3zzURRp0cOzuK9f+4nmFkMhpqXluxDRfNKoAx1KOWaF7rf3dpmCuYX884BJXpMrPMYuw+dRNqaNIEshB5JlCGGlvSEm47zq3gLh9lkvNT2mAwjBnh0vdPiheCrtuImF1jaowVk4/TBCziWURsFX9cB/azYiDbhfy3/IeCOzf4AyzVWcTI+z7v7Zl4juawOQ8naIzT/Ztk/beM6/xBZSQFQMGhOq+Kx04ADo2KhnCzbJlZ+U/uWAsXp6gIOIk73SE10k4plQXT7urSiDmWN+m7DhFFIxsyvVbKQWIPFuG8FqMIljZV91mtVope7DeeV72i7mLXrQpAk8qI1um3cIJoajx649YN3af3Owtb9bXBe5Mff5FUyaSYDycvmKFo+B8e3dnkM9B47ayBMih4GBgUJ3b9yhLPNtwMqdTHJrOjic+k8OCNQYI9Avi2Tq3zEzeNtNIHVK91jkRMfZ40VZnQochwKJZ9e8h/X2eK0yfjpe8CwbEoVmp86u3t6RQE26r4SJJzhmZL6+z56dwWxZz8sxQGXOWhm4rm/57YyIeKlvbjR6Y0LV5w8z5DKiJz3isq42PYPqrL8ychTOjc/ig9Viym6fAtaHU7ZhmUZb/5PEDuJROThNNFY+8egB7Q/W32wJ7tT12PTQsLluci0Yw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(6506007)(71200400001)(55016002)(26005)(186003)(508600001)(316002)(7696005)(33656002)(2906002)(38100700002)(9686003)(8676002)(38070700005)(122000001)(66946007)(86362001)(110136005)(54906003)(76116006)(8936002)(52536014)(4326008)(66446008)(66476007)(83380400001)(107886003)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OZ+jJ9rf0SI0P/xLLhvMifdOREyaB7h2/0lQ/RoqizMSHeCfIM8f7SWoi7j1?=
 =?us-ascii?Q?OMbCQ8b0qhUVMWQGd4nfPF2sFg1q0mrNtHv3EDo6WBCsfLQ7+B+8h0Ieyk52?=
 =?us-ascii?Q?y9CEaDKnm1PDPCUkxI6D9dIx0P1nb4bYLv9Loui2QPrOumNWT5s25em1v6nF?=
 =?us-ascii?Q?5Gv+Pn4l4OojQy799iWFwLTrUT/6r7e7kDptUIBRNYZNgKS6tilQdPp5c1pg?=
 =?us-ascii?Q?AHm0ArNA7bhByiDE2EBu3/XvSAR7HfWxUgv9VEbTB9z1v/su3NopClmP3N4G?=
 =?us-ascii?Q?Sx/DjKs4bwjsM/DkWyw2oUtLaamX7VRE4VoVXLyPpkL1gnTVE0EnVjDHWTHk?=
 =?us-ascii?Q?dTD4VTzZFjFOJP+SEOMYefJmQlNqChzi3oWgb/aFT241YVZGKZb/TPKusHGm?=
 =?us-ascii?Q?51mOVlcLMJGu0PJVNAyPEIPPBCZl2hvD5MQ8drlFPFXDN1SenOkytXrf9jRh?=
 =?us-ascii?Q?ypEVDRZeBV1pLYMEyHXhi94u0VF3PQ+Q5MkvUsQSvbf7vGMopiUVnsIWQR1F?=
 =?us-ascii?Q?ELySR8fYLYwfIWWfeJ81o9kz8t+xBcMy2oJoujv7/ld1ztQiWpwSJxrDnXQx?=
 =?us-ascii?Q?5caCHFXAF21nazFb98gAJ9jhoiFeVkUQdtoO8GsibBB+XiRKS+dzKAr1VtIT?=
 =?us-ascii?Q?D4qPmtoITB1PGV4XSjxlv6/vt9TASaVndxwT9WNZ1Ica7bupDprQkrs/sVJ0?=
 =?us-ascii?Q?wmPoUfOt/UY06cd7E8mSQVpiPX8jdDS5qckBWQR3pjSt9kJU4X2OtSkAeF0H?=
 =?us-ascii?Q?+Zszj5CZm1iVHVFCp5ZQM9Ud0sc3G4lLiDgM5ZrbQCxM6qPP/T7xCQeAsqzN?=
 =?us-ascii?Q?bNBnxP0ItCxXkZzho6Bsz5AsSAAYrGPpqJK+ul9Heh097A7UOklAdylI7tEr?=
 =?us-ascii?Q?5qo14G5LX8VUMO/UQZloMfhSWq9HkkjwFCCvQKdJMKtTbsFOSyxWsVNkJAug?=
 =?us-ascii?Q?SPEhHNa9aeBk9qIN7G1FKJZetU/KjJ/bf37NACZFIfDyqBjixvqCeLmozVel?=
 =?us-ascii?Q?AeWyQtsrCd+LJbG9sq/zjkveEV12jl2u2ajfvoa1+ykBNvrhYA0rn9kpuh0J?=
 =?us-ascii?Q?fQ3pCDKiYlNY2UcnjWMEN7BONgRzi6r3DEm4JyaW6BAVUzjFAXZj/AP8y3Js?=
 =?us-ascii?Q?amP1dwHzA5HauG/ZIdRUo4V40AvofzBkdnlpHqRV0mEjqnfdaQ8i1Hjjkqun?=
 =?us-ascii?Q?17XFcuaRbKvSPiBnVAP1+s4nHwoST/wAcGa/XC95vnH5ewb99EaxY86cXkfK?=
 =?us-ascii?Q?r6y8UeGNSxUMSqgAD85wnhm/lzHTYv3aYvWJ13dDAOu1OfFYyMv3yUrQ4JaH?=
 =?us-ascii?Q?aD6Y+iqZNnYY49Gutm58VJhN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfbc9478-f7f3-469d-03f8-08d98d5d73b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 08:51:16.1218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qyvSNnlfWuRkOGNXrd3RzZ675RENxlNsEl6Si6MpNcV6/zFB1xfSZK4kLynaUjRJze2BpNXvRD9mjLWQFqC/1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5626
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, October 2, 2021 7:22 AM
>=20
> iommu_group_register_notifier()/iommu_group_unregister_notifier() are
> built using a blocking_notifier_chain which integrates a rwsem. The
> notifier function cannot be running outside its registration.
>=20
> When considering how the notifier function interacts with create/destroy
> of the group there are two fringe cases, the notifier starts before
> list_add(&vfio.group_list) and the notifier runs after the kref
> becomes 0.
>=20
> Prior to vfio_create_group() unlocking and returning we have
>    container_users =3D=3D 0
>    device_list =3D=3D empty
> And this cannot change until the mutex is unlocked.
>=20
> After the kref goes to zero we must also have
>    container_users =3D=3D 0
>    device_list =3D=3D empty
>=20
> Both are required because they are balanced operations and a 0 kref means
> some caller became unbalanced. Add the missing assertion that
> container_users must be zero as well.
>=20
> These two facts are important because when checking each operation we see=
:
>=20
> - IOMMU_GROUP_NOTIFY_ADD_DEVICE
>    Empty device_list avoids the WARN_ON in vfio_group_nb_add_dev()
>    0 container_users ends the call
> - IOMMU_GROUP_NOTIFY_BOUND_DRIVER
>    0 container_users ends the call
>=20
> Finally, we have IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER, which only
> deletes
> items from the unbound list. During creation this list is empty, during
> kref =3D=3D 0 nothing can read this list, and it will be freed soon.
>=20
> Since the vfio_group_release() doesn't hold the appropriate lock to
> manipulate the unbound_list and could race with the notifier, move the
> cleanup to directly before the kfree.
>=20
> This allows deleting all of the deferred group put code.

Looks good to me.

Reviewed-by: Liu Yi L <yi.l.liu@intel.com>

Regards,
Yi Liu

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 89 +++++----------------------------------------
>  1 file changed, 9 insertions(+), 80 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 08b27b64f0f935..32a53cb3598524 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -324,12 +324,20 @@ static void vfio_container_put(struct vfio_containe=
r
> *container)
>=20
>  static void vfio_group_unlock_and_free(struct vfio_group *group)
>  {
> +	struct vfio_unbound_dev *unbound, *tmp;
> +
>  	mutex_unlock(&vfio.group_lock);
>  	/*
>  	 * Unregister outside of lock.  A spurious callback is harmless now
>  	 * that the group is no longer in vfio.group_list.
>  	 */
>  	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
> +
> +	list_for_each_entry_safe(unbound, tmp,
> +				 &group->unbound_list, unbound_next) {
> +		list_del(&unbound->unbound_next);
> +		kfree(unbound);
> +	}
>  	kfree(group);
>  }
>=20
> @@ -361,13 +369,6 @@ static struct vfio_group *vfio_create_group(struct
> iommu_group *iommu_group,
>=20
>  	group->nb.notifier_call =3D vfio_iommu_group_notifier;
>=20
> -	/*
> -	 * blocking notifiers acquire a rwsem around registering and hold
> -	 * it around callback.  Therefore, need to register outside of
> -	 * vfio.group_lock to avoid A-B/B-A contention.  Our callback won't
> -	 * do anything unless it can find the group in vfio.group_list, so
> -	 * no harm in registering early.
> -	 */
>  	ret =3D iommu_group_register_notifier(iommu_group, &group->nb);
>  	if (ret) {
>  		kfree(group);
> @@ -415,18 +416,12 @@ static struct vfio_group *vfio_create_group(struct
> iommu_group *iommu_group,
>  static void vfio_group_release(struct kref *kref)
>  {
>  	struct vfio_group *group =3D container_of(kref, struct vfio_group, kref=
);
> -	struct vfio_unbound_dev *unbound, *tmp;
>  	struct iommu_group *iommu_group =3D group->iommu_group;
>=20
>  	WARN_ON(!list_empty(&group->device_list));
> +	WARN_ON(atomic_read(&group->container_users));
>  	WARN_ON(group->notifier.head);
>=20
> -	list_for_each_entry_safe(unbound, tmp,
> -				 &group->unbound_list, unbound_next) {
> -		list_del(&unbound->unbound_next);
> -		kfree(unbound);
> -	}
> -
>  	device_destroy(vfio.class, MKDEV(MAJOR(vfio.group_devt), group-
> >minor));
>  	list_del(&group->vfio_next);
>  	vfio_free_group_minor(group->minor);
> @@ -439,61 +434,12 @@ static void vfio_group_put(struct vfio_group *group=
)
>  	kref_put_mutex(&group->kref, vfio_group_release, &vfio.group_lock);
>  }
>=20
> -struct vfio_group_put_work {
> -	struct work_struct work;
> -	struct vfio_group *group;
> -};
> -
> -static void vfio_group_put_bg(struct work_struct *work)
> -{
> -	struct vfio_group_put_work *do_work;
> -
> -	do_work =3D container_of(work, struct vfio_group_put_work, work);
> -
> -	vfio_group_put(do_work->group);
> -	kfree(do_work);
> -}
> -
> -static void vfio_group_schedule_put(struct vfio_group *group)
> -{
> -	struct vfio_group_put_work *do_work;
> -
> -	do_work =3D kmalloc(sizeof(*do_work), GFP_KERNEL);
> -	if (WARN_ON(!do_work))
> -		return;
> -
> -	INIT_WORK(&do_work->work, vfio_group_put_bg);
> -	do_work->group =3D group;
> -	schedule_work(&do_work->work);
> -}
> -
>  /* Assume group_lock or group reference is held */
>  static void vfio_group_get(struct vfio_group *group)
>  {
>  	kref_get(&group->kref);
>  }
>=20
> -/*
> - * Not really a try as we will sleep for mutex, but we need to make
> - * sure the group pointer is valid under lock and get a reference.
> - */
> -static struct vfio_group *vfio_group_try_get(struct vfio_group *group)
> -{
> -	struct vfio_group *target =3D group;
> -
> -	mutex_lock(&vfio.group_lock);
> -	list_for_each_entry(group, &vfio.group_list, vfio_next) {
> -		if (group =3D=3D target) {
> -			vfio_group_get(group);
> -			mutex_unlock(&vfio.group_lock);
> -			return group;
> -		}
> -	}
> -	mutex_unlock(&vfio.group_lock);
> -
> -	return NULL;
> -}
> -
>  static
>  struct vfio_group *vfio_group_get_from_iommu(struct iommu_group
> *iommu_group)
>  {
> @@ -691,14 +637,6 @@ static int vfio_iommu_group_notifier(struct
> notifier_block *nb,
>  	struct device *dev =3D data;
>  	struct vfio_unbound_dev *unbound;
>=20
> -	/*
> -	 * Need to go through a group_lock lookup to get a reference or we
> -	 * risk racing a group being removed.  Ignore spurious notifies.
> -	 */
> -	group =3D vfio_group_try_get(group);
> -	if (!group)
> -		return NOTIFY_OK;
> -
>  	switch (action) {
>  	case IOMMU_GROUP_NOTIFY_ADD_DEVICE:
>  		vfio_group_nb_add_dev(group, dev);
> @@ -749,15 +687,6 @@ static int vfio_iommu_group_notifier(struct
> notifier_block *nb,
>  		mutex_unlock(&group->unbound_lock);
>  		break;
>  	}
> -
> -	/*
> -	 * If we're the last reference to the group, the group will be
> -	 * released, which includes unregistering the iommu group notifier.
> -	 * We hold a read-lock on that notifier list, unregistering needs
> -	 * a write-lock... deadlock.  Release our reference asynchronously
> -	 * to avoid that situation.
> -	 */
> -	vfio_group_schedule_put(group);
>  	return NOTIFY_OK;
>  }
>=20
> --
> 2.33.0

