Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795B93F8145
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 05:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhHZDuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 23:50:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:22033 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhHZDuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 23:50:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="197896937"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="197896937"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 20:49:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="598339524"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 25 Aug 2021 20:49:12 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 20:49:11 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 25 Aug 2021 20:49:11 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 20:49:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWFCPDDmOB9UgSezTt9fRjSlFNHhvt+ciO01S259rjiHZ12SOmg15JF5vmwNxgKRq7D0o2vsm9WfbRY1zl3kqnx5GhGtHZmisXkbJRBx2Ag/xIf2XHU6aNNAUCvq3xGRjNpEd35EfhNPBr9n/u5QNnroLPM4phdKGixxq6miRwUIKx8OFGqg1SJRTVtPWM0alLx+QH6VOBCBR85ACvwDuOYtPsHmBot9YxCd/7eSD4xvsbXFOtvKBYjbFJq/UDNMI8yOWtCBm3AFKWwhwG2DbVKb6iEELgZJ+5xBMgzf+bi2I9vGcH4mFuDQSZNn3tDMcan0XkMVdDuVUxYWHrcLgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Phqq+SAyEEluwO/b2h4rJzbWXzgeuzzXlSvmKUGTsg=;
 b=fcOz2mN+7+Hfv6pYmaOUkD354ZK16SbWFRh1FBs0+fmqo542n11DT7mqGPBAGahwICIyd1GrjkUZVictZUNBJLwb5C3GIMDLX7zxnXX9dO+m3V1xNB1bizCurvBBBFKiVaOMvmhFr2RzqspgiOk21dDyKrI2FTuGbImYUi4NZP00ksfzsCizey6iV2bMFFGKOnKqmvoJiLvhxN7FbQ6RKMr8FV5IWwGj80r8IXQM/dA11isamRWIBtelLzf0g58ARAjHcAa5hdOFvwjVIUO9DkX4xmHaw4qEehdzqnxB8HLmnCj+VsfLnThYH68gc6KuOnDtUkX4WLXnCpmla1iwmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Phqq+SAyEEluwO/b2h4rJzbWXzgeuzzXlSvmKUGTsg=;
 b=AMu7rbera6/nVwQAxKtQjzGgiZZfelT3bGNxihkJWzRL0E+AybfqiELCl3ILyA/OS8nPLAZsRTpNiBGHYGn7WD/1ResWGtwcV577/O/zmGkfsBa2CUbJ2BZQTsuKPTS1uEHdnPEiP2fGqVt7kWM0B7WtbPCIwFJJN4Jr/4Mv08s=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB4068.namprd11.prod.outlook.com (2603:10b6:405:7c::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 03:49:09 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 03:49:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 10/14] vfio: remove the unused mdev iommu hook
Thread-Topic: [PATCH 10/14] vfio: remove the unused mdev iommu hook
Thread-Index: AQHXmc+AqQvwaEAbSk6DOSK3+yJkjKuFHegA
Date:   Thu, 26 Aug 2021 03:49:09 +0000
Message-ID: <BN9PR11MB5433FEF51BA85A97BE9E8D588CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-11-hch@lst.de>
In-Reply-To: <20210825161916.50393-11-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ec6876c-2c9b-44d3-d217-08d96844761e
x-ms-traffictypediagnostic: BN6PR11MB4068:
x-microsoft-antispam-prvs: <BN6PR11MB4068F3EB9B7F61F0A8A584218CC79@BN6PR11MB4068.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:372;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4b6/J6hOZNg+WfoZuXY22PAfFx5PXPHtghN22OJ3ZPH5AXEbvf79obp8u3VNHUytKgbxuEhT+GcgIIyoo5XpWLudyM0tlG6NQA+rr2FFM+VmwXbAchnnVscoXSWgRObHN9aKm+9Ax/mkqmeFaaD8UP3LdDeGtz5ej3AnazMGe0Fhm2D+vBJ+4YPlE4MnB7RkWinzEoRijU/PvrIDqPbdixn/MES6PynDFNrVtKAC1T9geB1oimh02Mdm1Uawchu9hDk0+FqWukozfkUnWz7bCMeTsRb4N+93k7TZ8bM5jKqQsWrTBSFEWclSz7J1A2Hvthcn3rNp2JAKqOlAKqWiugzpvxHkn/CQPjAPVlckC2WxFGK56jFdKdLRPcOvpydKfXlLaROPcP52OmTaKG49YIbUHZ2hAWTUnObyBpKXgiTn5RafUgsYK8UfDzQkGfgiEjA7FSLAjIQ/RdvMGLnJqhaimNWwnVgyWx1tQTaVkA6ROr7DSIw2BVdEVddapKZ/xHEJjmbFDGJaf5VzlcFqWtjpnjsq7KYqAnPSwsGMsaoYadyILEzmBrVNYQ3bXkbIxVTKJjiAGY2WZy3lANQXGGOPP+myFwvBwDPFFmKt6fR+wPgblH6M6N47c2LoxpfRmf/FpRU2qn5to+MgHfxmAbNLkX88MGvn+3l6njvJQip8o6VBWJKvZgEpteHTFlU+pHPUJElkPbcp7TDnqxBkyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(52536014)(5660300002)(38070700005)(8676002)(478600001)(38100700002)(83380400001)(2906002)(4326008)(186003)(9686003)(7696005)(66476007)(54906003)(66556008)(26005)(6506007)(122000001)(66946007)(110136005)(86362001)(33656002)(76116006)(71200400001)(64756008)(66446008)(8936002)(55016002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8Lq3z17sdn7BVikvaDrVn+ExBLalbeUQ4bHNmFKu6T/6grpaCctt6SKyBKeU?=
 =?us-ascii?Q?nOe/JD73aPw0zORhWKi4lEUy8N3psB0gzOPDhS1XzA3K0xWDPuK0UY+PbgpG?=
 =?us-ascii?Q?NlBBoAVxtNUnjlPO2VoThO2zMIO7OA0g3iCZyMCWfetV5UY3PGTBDmPHnpd6?=
 =?us-ascii?Q?bRlVZqk2icJ5qfbvQ+KtQwGmkw9+JM1dMa2JRtaQ41BhlBAtRa7iPgG34ePi?=
 =?us-ascii?Q?ePAqGj+yxyiTx6AHmA+XG3X9YXP6atOb+UPy6B34m0sjGb9LKFJL4XAYpkux?=
 =?us-ascii?Q?HvoKfAEuwhF0NHqhNiS2J84QDJp0Oz3lxPM4R6FgOvi//6y19nDlCJpfeep5?=
 =?us-ascii?Q?R5PACc7sXtxJCS5R08Y9hxEtOEBkJQvXZru10cN9d6NxBq7FXNgn4IowdSAd?=
 =?us-ascii?Q?J9iX1jV8yQVci82VyY1JdS0XMvNrHo3MBsl7HT4UXeVt4Ilb5NAC/83z7H61?=
 =?us-ascii?Q?yjmwtRFLpAJZSC1qTQMFD73sDp5TuSSI8TFhdUAQZuNu9BKwQCZ90z4kxsmD?=
 =?us-ascii?Q?lVAem9MNpoNemKxl3MgeuAYTpaX40OMjhfEsQjyXwyG6pT6lOimO/gGRcExm?=
 =?us-ascii?Q?aRqBDPh3Q0B7elzCC2DEEB3+WqL3CXmQWgI3/FwS2ti24labjnIwIvrTJXLw?=
 =?us-ascii?Q?XWiBnk6gisJLBO0syieVItqA8T/bZ9lt2Dvl5Zx2MkAwDUB1p4GGJ0lou6YA?=
 =?us-ascii?Q?7/RuRtIEJN4PEa5NuCOvwEyis0GZKP9KLo+2Gou4BKJQ/KxmdTX46qZ2NXu2?=
 =?us-ascii?Q?6/v/F67KCZnfuEw1GZ28EOM1pf3StjJbRVcfiVFVdCjyFKwhIUosreGYoaJl?=
 =?us-ascii?Q?Cwf+Q46Pt6Ak4MbezkPwpYQYEuzCJVrbBhD3cURUVhrs9WeBzeOC4Fa4Wnt1?=
 =?us-ascii?Q?mXOoSVoDeFNqyVDHil9euAeOfan6A7PkKhe/oPaJytrts1jNQlYnIVA1vSv6?=
 =?us-ascii?Q?/xxIRAUFkj4vA5sJYZeYfok/CR2kvUFYfqV+MP5WtMZXOnyEmyIPkY6xp0pa?=
 =?us-ascii?Q?14bM3NJaNjSVrQEwBNc3fVT+dILaoo1eh3pleDk9U4ssM7INheAY7hWwX0Uf?=
 =?us-ascii?Q?T/d1txIF4159hh2DPN0d62lzVcAkcMjK+D2waik8OPV/SZX5gBFDBXi6aMb4?=
 =?us-ascii?Q?0oNkykn4jiFiHasjS7HmfRhXnPZDmtT+eyIbS9wmMCHijSEeUbQGGSFNg5vr?=
 =?us-ascii?Q?gxsYlTucfxJbaqiXU4HrQnuxLOxkGPwW7YLjJC8VXsEYbMFNNod4Pg50kwb7?=
 =?us-ascii?Q?68cnPZQo3rzpyBMRICZZeKu6jYTTlYGQ2CSogJqyo1uENYXYryznCwTqfLLV?=
 =?us-ascii?Q?X6GcGLbLciGkDF8kFGM/JXBO?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec6876c-2c9b-44d3-d217-08d96844761e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 03:49:09.7456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x4Pm8pi7fNv3UfR7SUmcTkMEUm/N1oSlSOYMJPZLq6Z/cKDdiEg7lum25TyL5BOrQCCzK12Ja7shYn/MK5bjvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4068
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
> The iommu_device field in struct mdev_device has never been used
> since it was added more than 2 years ago.
>=20
> This is a manual revert of commit 7bd50f0cd2
> ("vfio/type1: Add domain at(de)taching group helpers").
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio_iommu_type1.c | 133 +++++++-------------------------
>  include/linux/mdev.h            |  20 -----
>  2 files changed, 26 insertions(+), 127 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index 92777797578e50..39e2706d0b3f34 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -114,7 +114,6 @@ struct vfio_batch {
>  struct vfio_iommu_group {
>  	struct iommu_group	*iommu_group;
>  	struct list_head	next;
> -	bool			mdev_group;	/* An mdev group */
>  	bool			pinned_page_dirty_scope;
>  };
>=20
> @@ -1935,61 +1934,6 @@ static bool vfio_iommu_has_sw_msi(struct
> list_head *group_resv_regions,
>  	return ret;
>  }
>=20
> -static int vfio_mdev_attach_domain(struct device *dev, void *data)
> -{
> -	struct mdev_device *mdev =3D to_mdev_device(dev);
> -	struct iommu_domain *domain =3D data;
> -	struct device *iommu_device;
> -
> -	iommu_device =3D mdev_get_iommu_device(mdev);
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
> -	struct mdev_device *mdev =3D to_mdev_device(dev);
> -	struct iommu_domain *domain =3D data;
> -	struct device *iommu_device;
> -
> -	iommu_device =3D mdev_get_iommu_device(mdev);
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
> -				   struct vfio_iommu_group *group)
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
> -				    struct vfio_iommu_group *group)
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
>  static bool vfio_bus_is_mdev(struct bus_type *bus)
>  {
>  	struct bus_type *mdev_bus;
> @@ -2004,20 +1948,6 @@ static bool vfio_bus_is_mdev(struct bus_type
> *bus)
>  	return ret;
>  }
>=20
> -static int vfio_mdev_iommu_device(struct device *dev, void *data)
> -{
> -	struct mdev_device *mdev =3D to_mdev_device(dev);
> -	struct device **old =3D data, *new;
> -
> -	new =3D mdev_get_iommu_device(mdev);
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
> @@ -2278,38 +2208,25 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  		goto out_free;
>=20
>  	if (vfio_bus_is_mdev(bus)) {
> -		struct device *iommu_device =3D NULL;
> -
> -		group->mdev_group =3D true;
> -
> -		/* Determine the isolation type */
> -		ret =3D iommu_group_for_each_dev(iommu_group,
> &iommu_device,
> -					       vfio_mdev_iommu_device);
> -		if (ret || !iommu_device) {
> -			if (!iommu->external_domain) {
> -				INIT_LIST_HEAD(&domain->group_list);
> -				iommu->external_domain =3D domain;
> -				vfio_update_pgsize_bitmap(iommu);
> -			} else {
> -				kfree(domain);
> -			}
> -
> -			list_add(&group->next,
> -				 &iommu->external_domain->group_list);
> -			/*
> -			 * Non-iommu backed group cannot dirty memory
> directly,
> -			 * it can only use interfaces that provide dirty
> -			 * tracking.
> -			 * The iommu scope can only be promoted with the
> -			 * addition of a dirty tracking group.
> -			 */
> -			group->pinned_page_dirty_scope =3D true;
> -			mutex_unlock(&iommu->lock);
> -
> -			return 0;
> +		if (!iommu->external_domain) {
> +			INIT_LIST_HEAD(&domain->group_list);
> +			iommu->external_domain =3D domain;
> +			vfio_update_pgsize_bitmap(iommu);
> +		} else {
> +			kfree(domain);
>  		}
>=20
> -		bus =3D iommu_device->bus;
> +		list_add(&group->next, &iommu->external_domain-
> >group_list);
> +		/*
> +		 * Non-iommu backed group cannot dirty memory directly, it
> can
> +		 * only use interfaces that provide dirty tracking.
> +		 * The iommu scope can only be promoted with the addition
> of a
> +		 * dirty tracking group.
> +		 */
> +		group->pinned_page_dirty_scope =3D true;
> +		mutex_unlock(&iommu->lock);
> +
> +		return 0;
>  	}
>=20
>  	domain->domain =3D iommu_domain_alloc(bus);
> @@ -2324,7 +2241,7 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  			goto out_domain;
>  	}
>=20
> -	ret =3D vfio_iommu_attach_group(domain, group);
> +	ret =3D iommu_attach_group(domain->domain, group->iommu_group);
>  	if (ret)
>  		goto out_domain;
>=20
> @@ -2391,15 +2308,17 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  	list_for_each_entry(d, &iommu->domain_list, next) {
>  		if (d->domain->ops =3D=3D domain->domain->ops &&
>  		    d->prot =3D=3D domain->prot) {
> -			vfio_iommu_detach_group(domain, group);
> -			if (!vfio_iommu_attach_group(d, group)) {
> +			iommu_detach_group(domain->domain, group-
> >iommu_group);
> +			if (!iommu_attach_group(d->domain,
> +						group->iommu_group)) {
>  				list_add(&group->next, &d->group_list);
>  				iommu_domain_free(domain->domain);
>  				kfree(domain);
>  				goto done;
>  			}
>=20
> -			ret =3D vfio_iommu_attach_group(domain, group);
> +			ret =3D iommu_attach_group(domain->domain,
> +						 group->iommu_group);
>  			if (ret)
>  				goto out_domain;
>  		}
> @@ -2436,7 +2355,7 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  	return 0;
>=20
>  out_detach:
> -	vfio_iommu_detach_group(domain, group);
> +	iommu_detach_group(domain->domain, group->iommu_group);
>  out_domain:
>  	iommu_domain_free(domain->domain);
>  	vfio_iommu_iova_free(&iova_copy);
> @@ -2601,7 +2520,7 @@ static void vfio_iommu_type1_detach_group(void
> *iommu_data,
>  		if (!group)
>  			continue;
>=20
> -		vfio_iommu_detach_group(domain, group);
> +		iommu_detach_group(domain->domain, group-
> >iommu_group);
>  		update_dirty_scope =3D !group->pinned_page_dirty_scope;
>  		list_del(&group->next);
>  		kfree(group);
> @@ -2689,7 +2608,7 @@ static void vfio_release_domain(struct
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
> index 68427e8fadebd6..15d03f6532d073 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -18,7 +18,6 @@ struct mdev_device {
>  	void *driver_data;
>  	struct list_head next;
>  	struct mdev_type *type;
> -	struct device *iommu_device;
>  	bool active;
>  };
>=20
> @@ -27,25 +26,6 @@ static inline struct mdev_device
> *to_mdev_device(struct device *dev)
>  	return container_of(dev, struct mdev_device, dev);
>  }
>=20
> -/*
> - * Called by the parent device driver to set the device which represents
> - * this mdev in iommu protection scope. By default, the iommu device is
> - * NULL, that indicates using vendor defined isolation.
> - *
> - * @dev: the mediated device that iommu will isolate.
> - * @iommu_device: a pci device which represents the iommu for @dev.
> - */
> -static inline void mdev_set_iommu_device(struct mdev_device *mdev,
> -					 struct device *iommu_device)
> -{
> -	mdev->iommu_device =3D iommu_device;
> -}
> -
> -static inline struct device *mdev_get_iommu_device(struct mdev_device
> *mdev)
> -{
> -	return mdev->iommu_device;
> -}
> -
>  unsigned int mdev_get_type_group_id(struct mdev_device *mdev);
>  unsigned int mtype_get_type_group_id(struct mdev_type *mtype);
>  struct device *mtype_get_parent_dev(struct mdev_type *mtype);
> --
> 2.30.2

