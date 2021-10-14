Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A5F42D02E
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 04:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhJNCNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 22:13:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:58515 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229496AbhJNCNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 22:13:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="214523698"
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="214523698"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 19:11:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="524878282"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga001.jf.intel.com with ESMTP; 13 Oct 2021 19:11:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 13 Oct 2021 19:11:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 13 Oct 2021 19:11:04 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 13 Oct 2021 19:09:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggx9T6vNF4KduStAD0tY+LQffxFsdADgJQVXmzbZZPU7WXP5LC35Tht9tEF2OENJyXKjmAZC2dyVEJ+9bdJytkHJWJtiiyp+/TSxVRDnCkvL0K146ImOud8OPF0+D9c6Oe/1LZojaOgdi7DIAt5LkZVfcyJNQIpw51CuOTMr8WCoqwSrTS7caVwSuK8sZI6rfcYN07Ujlkyz2KE0OnnXN/mN4AfxQALUlkHg3RUjz1p2Q3SErQvxD8PDJPjdPLrXk6qqe7uHL25Pw3ucULZllbtEMXsOK4KDcYRmp7ZG2ePjv/62Fniym3GDlX2QeslzMRYTlVPWL414mcShSiOPsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNGP9ZyWgsPV0ExLoQ7ZlXX79GGjE5UovyqO7zJYOS4=;
 b=kBB5ftvGKPinwAQszgIFB1aVRSXGbEehaTqQbfAiEDJ2T66b+MPcCYTnYK7RMRjivspWSzoVxm8bKZaDMxZ14Gme5DLLxbIY/XsfFBEX5yT6dYwAwkR5efdpuqeqyocG/XzmT9WHptzf6G2yuWWyEO77Oo3uS9nPIHxPVAorcmBzQFH6k+TzlUbwWAJC0w+FVT2KnKyWflIRQ2mV38mr8Fs7TfD10NPomJqKZdAs08LjPkyMdJGj+CbThL9se+iRtDfvXjF/XZtUN4aOltY+x0YBKY/ZUhEQA8ySUnXViZ/K2SMByp1Gwi7dqxxqpPnbt88So/A2+Bxle134B6zR+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNGP9ZyWgsPV0ExLoQ7ZlXX79GGjE5UovyqO7zJYOS4=;
 b=xH+P+X9VWFFA4XlyivO72cQyvkR9SzaBiZIHZ1HI66pc2b1iN9FeMrsT9QDQNmvz9EV45lPjRin2IRZX5O2yLXddCeFjbCfFqBl7fWpMjuZFrrSy+lOZUL+0movcXYgt8JnRv6u/bKABs1dzjKnj3TmrQlPahuNidfulj9OLadM=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5340.namprd11.prod.outlook.com (2603:10b6:408:119::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 02:09:38 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 02:09:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Thread-Topic: [PATCH v2 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Thread-Index: AQHXwD6VHUN8fWviL0ultf7+RIGu46vRwGqA
Date:   Thu, 14 Oct 2021 02:09:38 +0000
Message-ID: <BN9PR11MB5433DBAD81D116D757F755B48CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
 <5-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <5-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e22cffcc-7262-4e17-de27-08d98eb7ad4d
x-ms-traffictypediagnostic: BN9PR11MB5340:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB534028F3086AFFB054BE4BEB8CB89@BN9PR11MB5340.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:381;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y/QULQZ+v3u6VxRC6V6WiRe9s3oZVUCY7r9xqUuJjdnvmnq+ep1w1ee4U6++6s0AWU0SjRtROYx/ox/8Gp40m/awnOH5DhRf69YBoksQyxCHXA+uHCU1EHu5mRjtOdccbCf08FYBUQejxK7IMz2+snTyCq1mSurlwV5lwzkVUfSxRn47+osCBGlva2EwFhqeHK0PBDsan3v6rsnDpW1ZUi0zVM0iDB2X+KX6l1+WUnXB+evesmhau9V1i8JAl4VKKogDzzDRjznjL2Ysrh4LF3+/z22NcE9zEPTzSFK97ivZS/1oImXfeBw8yAm4SHXuigiWzhPEED7aDkrLYQx/wKB+bhNGtAoZIiQUhyyofi6EqNI2mlCa4om6yXmHdTLTSsOvev4zPfTw+cLkAoSQF81j92R1yGg1aYpmcnQ4d3dWXhwYjDDqyQaMl3erdmmlA31+kHF/6YfQUmlQnwkTJz9BkSyEF/R4CkXENmnbJhE6B1Mih4gvE/kq8nJCN1JzUvin+cTLTSgN6w0Q+UQPrx+JVzFhR7VGFw1pw0k2wz1Nri9bv4bxirTouMt5g5qObkQy7IuISLzwhPwktCThYsGcdks/BM/G1FpgnRq3l2cpR50EjyiR8yNn+oiDXnumCo8pH46JD63H6DT8my8qrtqZiaXXWJA99e33OA4FVBdGJcVP0uupbzEu8N6UhimPRI9D13g+szjYojK/Hvn/SA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38070700005)(4326008)(66446008)(76116006)(66556008)(26005)(52536014)(122000001)(508600001)(5660300002)(107886003)(7696005)(83380400001)(186003)(316002)(71200400001)(30864003)(86362001)(8936002)(38100700002)(110136005)(8676002)(66946007)(2906002)(82960400001)(54906003)(33656002)(66476007)(6506007)(64756008)(55016002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Pqab+WOEOpGNRXqsdx2hiO8lJfy+Z/wVfaSaOcLyJeS/t/GfHzBgM9KTYlA3?=
 =?us-ascii?Q?ASSTF8BVIHojqCEf7IZP59UYSLpFQCFyRB0XJSYVrHWX2wRhhNTIFc596/pt?=
 =?us-ascii?Q?4REHXzrbjWoKyI2Xs7RwFbQvzjPg5nV9K4HFlOvripfDHUZgEdl4ZWcP3Itp?=
 =?us-ascii?Q?4Q7KJEDc9pA2r0wCAYAtqBgVEM7xDNEZkkrHqQ96nhha5oPmqQOrLjvC9JTV?=
 =?us-ascii?Q?1mPwYp7Ai4LMBRJ8b4J/poV4r4XIUUCN4oRzRuWelmXecRI4zovGZ+sWdg2X?=
 =?us-ascii?Q?uR71y3yLQHwUPU6sJO66MaeJpRUNrwADcZkesJsbNMSmYXExy0tc3h2eroOU?=
 =?us-ascii?Q?pe4iHZTKRqHTJs69SpaFuVMfkkp+URBY2nbUDI1kIavcsdC3Z8l0IFlEIKrh?=
 =?us-ascii?Q?bQPUltIDhd7bSIuPAvoUuEPfKBJQjLn0fykCsCnGYT5BW1JvBeLqZ2mw8ye5?=
 =?us-ascii?Q?6V1zBH0K1tDeJuIhmoQX6yV9uxhhk6liMDX99O1ZOQFJGI3z58ZGvXdWfb6z?=
 =?us-ascii?Q?IvLM267SGPACsQWJI6R+Vt3hafJfkCtoMFPrWrywXRV6mVEUln1RCiMxHuTV?=
 =?us-ascii?Q?Ged9bRbCHCfTgMwGl3oJyY38JhFZQWH0NoCB5NM5VroqZyY/B5MD9Co1BZmm?=
 =?us-ascii?Q?aqdNgAwukmAJRTZAnXHvghn6VhcbgJCEK5l7j5xwOz37y/SYl9sILLOh4cr1?=
 =?us-ascii?Q?90JH/MIVWizzStU5P9on6fIhDKqutSw4R9EwCYtnhWAR9K7UZUEje5MPnPow?=
 =?us-ascii?Q?YMGwCFMUJMFh5PJHp7jyboL6C9SHSbLFrAM7ikTs4VHVVIxunpJfjg16HSWM?=
 =?us-ascii?Q?JzF9ZjcClTob0TWSV1JFyhKAmHlBeX6iWPZr2rmXWHNI//Utn8DNx4ZkDiAW?=
 =?us-ascii?Q?zH8V0tLnQNbqpIi97Q721e7T53BIOsgJh3Myg9i4IsYbk8imO4Ejvyq4/eWZ?=
 =?us-ascii?Q?XcOFS5tvayW9GdIOFxxLfYqClC5689QluTKBSGaS466k5M47DEecB4QIKenR?=
 =?us-ascii?Q?bN1KmiTAB2i54PlKQmt4dqupyNz3O3g1BCf1AFU+p4OPe3N0YOqzGfA1+35h?=
 =?us-ascii?Q?YPuYC5HqsLhzU/eXLVfjKWO6fYn0zdvP/jm8YzGyQgLHQSTwWNFMSP3Afpbj?=
 =?us-ascii?Q?GUmxbX2J9r3MGtVw+eNJenQIaICPe/pXihjRakMfy8768qgh5sI/jDO9ksCA?=
 =?us-ascii?Q?p/Y7dB2WTANKpv28gi7iAc3y4vdJIzVIb7Ke2AjYckiwZC50DE+BSFvNUil+?=
 =?us-ascii?Q?jcEK9qjJHD4VE0AaUBUtyC+VNYoJtpXoJDP5w08DRaTL8KKZkUyJru/meyEd?=
 =?us-ascii?Q?m/o3hDVJVJVF7ZP3W0rOlZ5t?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e22cffcc-7262-4e17-de27-08d98eb7ad4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 02:09:38.5355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B/eNXmolLmcnxEa1cuc10mI9z0etZMz0fI1f40M1bH5brlEcQnTTsOadvDkyVtv0DMpMYP9MMCJjIuAGwTX9Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5340
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, October 13, 2021 10:28 PM
>=20
> Modernize how vfio is creating the group char dev and sysfs presence.
>=20
> These days drivers with state should use cdev_device_add() and
> cdev_device_del() to manage the cdev and sysfs lifetime.
>=20
> This API requires the driver to put the struct device and struct cdev
> inside its state struct (vfio_group), and then use the usual
> device_initialize()/cdev_device_add()/cdev_device_del() sequence.
>=20
> Split the code to make this possible:
>=20
>  - vfio_group_alloc()/vfio_group_release() are pair'd functions to
>    alloc/free the vfio_group. release is done under the struct device
>    kref.
>=20
>  - vfio_create_group()/vfio_group_put() are pairs that manage the
>    sysfs/cdev lifetime. Once the uses count is zero the vfio group's
>    userspace presence is destroyed.
>=20
>  - The IDR is replaced with an IDA. container_of(inode->i_cdev)
>    is used to get back to the vfio_group during fops open. The IDA
>    assigns unique minor numbers.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 192 ++++++++++++++++++++++----------------------
>  1 file changed, 94 insertions(+), 98 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 60fabd4252ac66..528a98fa267120 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -43,9 +43,8 @@ static struct vfio {
>  	struct list_head		iommu_drivers_list;
>  	struct mutex			iommu_drivers_lock;
>  	struct list_head		group_list;
> -	struct idr			group_idr;
> -	struct mutex			group_lock;
> -	struct cdev			group_cdev;
> +	struct mutex			group_lock; /* locks group_list */
> +	struct ida			group_ida;
>  	dev_t				group_devt;
>  } vfio;
>=20
> @@ -69,14 +68,14 @@ struct vfio_unbound_dev {
>  };
>=20
>  struct vfio_group {
> +	struct device 			dev;
> +	struct cdev			cdev;
>  	refcount_t			users;
> -	int				minor;
>  	atomic_t			container_users;
>  	struct iommu_group		*iommu_group;
>  	struct vfio_container		*container;
>  	struct list_head		device_list;
>  	struct mutex			device_lock;
> -	struct device			*dev;
>  	struct notifier_block		nb;
>  	struct list_head		vfio_next;
>  	struct list_head		container_next;
> @@ -98,6 +97,7 @@
> MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE,
> no-IOMMU mode.  Thi
>  #endif
>=20
>  static DEFINE_XARRAY(vfio_device_set_xa);
> +static const struct file_operations vfio_group_fops;
>=20
>  int vfio_assign_device_set(struct vfio_device *device, void *set_id)
>  {
> @@ -281,19 +281,6 @@ void vfio_unregister_iommu_driver(const struct
> vfio_iommu_driver_ops *ops)
>  }
>  EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
>=20
> -/**
> - * Group minor allocation/free - both called with vfio.group_lock held
> - */
> -static int vfio_alloc_group_minor(struct vfio_group *group)
> -{
> -	return idr_alloc(&vfio.group_idr, group, 0, MINORMASK + 1,
> GFP_KERNEL);
> -}
> -
> -static void vfio_free_group_minor(int minor)
> -{
> -	idr_remove(&vfio.group_idr, minor);
> -}
> -
>  static int vfio_iommu_group_notifier(struct notifier_block *nb,
>  				     unsigned long action, void *data);
>  static void vfio_group_get(struct vfio_group *group);
> @@ -322,22 +309,6 @@ static void vfio_container_put(struct vfio_container
> *container)
>  	kref_put(&container->kref, vfio_container_release);
>  }
>=20
> -static void vfio_group_unlock_and_free(struct vfio_group *group)
> -{
> -	struct vfio_unbound_dev *unbound, *tmp;
> -
> -	mutex_unlock(&vfio.group_lock);
> -	iommu_group_unregister_notifier(group->iommu_group, &group-
> >nb);
> -
> -	list_for_each_entry_safe(unbound, tmp,
> -				 &group->unbound_list, unbound_next) {
> -		list_del(&unbound->unbound_next);
> -		kfree(unbound);
> -	}
> -	iommu_group_put(group->iommu_group);
> -	kfree(group);
> -}
> -
>  /**
>   * Group objects - create, release, get, put, search
>   */
> @@ -366,71 +337,112 @@ vfio_group_get_from_iommu(struct
> iommu_group *iommu_group)
>  	return group;
>  }
>=20
> -static struct vfio_group *vfio_create_group(struct iommu_group
> *iommu_group,
> -		enum vfio_group_type type)
> +static void vfio_group_release(struct device *dev)
>  {
> -	struct vfio_group *group, *existing_group;
> -	struct device *dev;
> -	int ret, minor;
> +	struct vfio_group *group =3D container_of(dev, struct vfio_group, dev);
> +	struct vfio_unbound_dev *unbound, *tmp;
> +
> +	list_for_each_entry_safe(unbound, tmp,
> +				 &group->unbound_list, unbound_next) {
> +		list_del(&unbound->unbound_next);
> +		kfree(unbound);
> +	}
> +
> +	mutex_destroy(&group->device_lock);
> +	mutex_destroy(&group->unbound_lock);
> +	iommu_group_put(group->iommu_group);
> +	ida_free(&vfio.group_ida, MINOR(group->dev.devt));
> +	kfree(group);
> +}
> +
> +static struct vfio_group *vfio_group_alloc(struct iommu_group
> *iommu_group,
> +					   enum vfio_group_type type)
> +{
> +	struct vfio_group *group;
> +	int minor;
>=20
>  	group =3D kzalloc(sizeof(*group), GFP_KERNEL);
>  	if (!group)
>  		return ERR_PTR(-ENOMEM);
>=20
> +	minor =3D ida_alloc_max(&vfio.group_ida, MINORMASK, GFP_KERNEL);
> +	if (minor < 0) {
> +		kfree(group);
> +		return ERR_PTR(minor);
> +	}
> +
> +	device_initialize(&group->dev);
> +	group->dev.devt =3D MKDEV(MAJOR(vfio.group_devt), minor);
> +	group->dev.class =3D vfio.class;
> +	group->dev.release =3D vfio_group_release;
> +	cdev_init(&group->cdev, &vfio_group_fops);
> +	group->cdev.owner =3D THIS_MODULE;
> +
>  	refcount_set(&group->users, 1);
>  	INIT_LIST_HEAD(&group->device_list);
>  	mutex_init(&group->device_lock);
>  	INIT_LIST_HEAD(&group->unbound_list);
>  	mutex_init(&group->unbound_lock);
> -	atomic_set(&group->container_users, 0);
> -	atomic_set(&group->opened, 0);
>  	init_waitqueue_head(&group->container_q);
>  	group->iommu_group =3D iommu_group;
> -	/* put in vfio_group_unlock_and_free() */
> +	/* put in vfio_group_release() */
>  	iommu_group_ref_get(iommu_group);
>  	group->type =3D type;
>  	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
>=20
> +	return group;
> +}
> +
> +static struct vfio_group *vfio_create_group(struct iommu_group
> *iommu_group,
> +		enum vfio_group_type type)
> +{
> +	struct vfio_group *group;
> +	struct vfio_group *ret;
> +	int err;
> +
> +	group =3D vfio_group_alloc(iommu_group, type);
> +	if (IS_ERR(group))
> +		return group;
> +
> +	err =3D dev_set_name(&group->dev, "%s%d",
> +			   group->type =3D=3D VFIO_NO_IOMMU ? "noiommu-" :
> "",
> +			   iommu_group_id(iommu_group));
> +	if (err) {
> +		ret =3D ERR_PTR(err);
> +		goto err_put;
> +	}
> +
>  	group->nb.notifier_call =3D vfio_iommu_group_notifier;
> -	ret =3D iommu_group_register_notifier(iommu_group, &group->nb);
> -	if (ret) {
> -		iommu_group_put(iommu_group);
> -		kfree(group);
> -		return ERR_PTR(ret);
> +	err =3D iommu_group_register_notifier(iommu_group, &group->nb);
> +	if (err) {
> +		ret =3D ERR_PTR(err);
> +		goto err_put;
>  	}
>=20
>  	mutex_lock(&vfio.group_lock);
>=20
>  	/* Did we race creating this group? */
> -	existing_group =3D __vfio_group_get_from_iommu(iommu_group);
> -	if (existing_group) {
> -		vfio_group_unlock_and_free(group);
> -		return existing_group;
> -	}
> +	ret =3D __vfio_group_get_from_iommu(iommu_group);
> +	if (ret)
> +		goto err_unlock;
>=20
> -	minor =3D vfio_alloc_group_minor(group);
> -	if (minor < 0) {
> -		vfio_group_unlock_and_free(group);
> -		return ERR_PTR(minor);
> +	err =3D cdev_device_add(&group->cdev, &group->dev);
> +	if (err) {
> +		ret =3D ERR_PTR(err);
> +		goto err_unlock;
>  	}
>=20
> -	dev =3D device_create(vfio.class, NULL,
> -			    MKDEV(MAJOR(vfio.group_devt), minor), group,
> "%s%d",
> -			    group->type =3D=3D VFIO_NO_IOMMU ? "noiommu-" :
> "",
> -			    iommu_group_id(iommu_group));
> -	if (IS_ERR(dev)) {
> -		vfio_free_group_minor(minor);
> -		vfio_group_unlock_and_free(group);
> -		return ERR_CAST(dev);
> -	}
> -
> -	group->minor =3D minor;
> -	group->dev =3D dev;
> -
>  	list_add(&group->vfio_next, &vfio.group_list);
>=20
>  	mutex_unlock(&vfio.group_lock);
>  	return group;
> +
> +err_unlock:
> +	mutex_unlock(&vfio.group_lock);
> +	iommu_group_unregister_notifier(group->iommu_group, &group-
> >nb);
> +err_put:
> +	put_device(&group->dev);
> +	return ret;
>  }
>=20
>  static void vfio_group_put(struct vfio_group *group)
> @@ -448,10 +460,12 @@ static void vfio_group_put(struct vfio_group
> *group)
>  	WARN_ON(atomic_read(&group->container_users));
>  	WARN_ON(group->notifier.head);
>=20
> -	device_destroy(vfio.class, MKDEV(MAJOR(vfio.group_devt), group-
> >minor));
>  	list_del(&group->vfio_next);
> -	vfio_free_group_minor(group->minor);
> -	vfio_group_unlock_and_free(group);
> +	cdev_device_del(&group->cdev, &group->dev);
> +	mutex_unlock(&vfio.group_lock);
> +
> +	iommu_group_unregister_notifier(group->iommu_group, &group-
> >nb);
> +	put_device(&group->dev);
>  }
>=20
>  static void vfio_group_get(struct vfio_group *group)
> @@ -459,20 +473,10 @@ static void vfio_group_get(struct vfio_group
> *group)
>  	refcount_inc(&group->users);
>  }
>=20
> -static struct vfio_group *vfio_group_get_from_minor(int minor)
> +/* returns true if the get was obtained */
> +static bool vfio_group_try_get(struct vfio_group *group)
>  {
> -	struct vfio_group *group;
> -
> -	mutex_lock(&vfio.group_lock);
> -	group =3D idr_find(&vfio.group_idr, minor);
> -	if (!group) {
> -		mutex_unlock(&vfio.group_lock);
> -		return NULL;
> -	}
> -	vfio_group_get(group);
> -	mutex_unlock(&vfio.group_lock);
> -
> -	return group;
> +	return refcount_inc_not_zero(&group->users);
>  }
>=20
>  static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
> @@ -1481,11 +1485,11 @@ static long vfio_group_fops_unl_ioctl(struct file
> *filep,
>=20
>  static int vfio_group_fops_open(struct inode *inode, struct file *filep)
>  {
> -	struct vfio_group *group;
> +	struct vfio_group *group =3D
> +		container_of(inode->i_cdev, struct vfio_group, cdev);
>  	int opened;
>=20
> -	group =3D vfio_group_get_from_minor(iminor(inode));
> -	if (!group)
> +	if (!vfio_group_try_get(group))
>  		return -ENODEV;
>=20
>  	if (group->type =3D=3D VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
> {
> @@ -2295,7 +2299,7 @@ static int __init vfio_init(void)
>  {
>  	int ret;
>=20
> -	idr_init(&vfio.group_idr);
> +	ida_init(&vfio.group_ida);
>  	mutex_init(&vfio.group_lock);
>  	mutex_init(&vfio.iommu_drivers_lock);
>  	INIT_LIST_HEAD(&vfio.group_list);
> @@ -2320,11 +2324,6 @@ static int __init vfio_init(void)
>  	if (ret)
>  		goto err_alloc_chrdev;
>=20
> -	cdev_init(&vfio.group_cdev, &vfio_group_fops);
> -	ret =3D cdev_add(&vfio.group_cdev, vfio.group_devt, MINORMASK + 1);
> -	if (ret)
> -		goto err_cdev_add;
> -
>  	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
>=20
>  #ifdef CONFIG_VFIO_NOIOMMU
> @@ -2332,8 +2331,6 @@ static int __init vfio_init(void)
>  #endif
>  	return 0;
>=20
> -err_cdev_add:
> -	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
>  err_alloc_chrdev:
>  	class_destroy(vfio.class);
>  	vfio.class =3D NULL;
> @@ -2349,8 +2346,7 @@ static void __exit vfio_cleanup(void)
>  #ifdef CONFIG_VFIO_NOIOMMU
>  	vfio_unregister_iommu_driver(&vfio_noiommu_ops);
>  #endif
> -	idr_destroy(&vfio.group_idr);
> -	cdev_del(&vfio.group_cdev);
> +	ida_destroy(&vfio.group_ida);
>  	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
>  	class_destroy(vfio.class);
>  	vfio.class =3D NULL;
> --
> 2.33.0

