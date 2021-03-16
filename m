Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC6633CEBC
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 08:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhCPHiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 03:38:17 -0400
Received: from mga07.intel.com ([134.134.136.100]:47556 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhCPHiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 03:38:14 -0400
IronPort-SDR: cIimulcX0EV9amDPxKlyiKfvRemA8cDf/Sjz+dXlwwcilvpxni7dFQKj8zhzccbtwI77S2/3G+
 2owR0hv39qaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="253231993"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="253231993"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 00:38:13 -0700
IronPort-SDR: zfIw7Gp+NVf+gcL601+jdHBlL1P7IvpDyZTdHq9dlBnAGl+4arad31OXd40y5aN2DAWxjNuexB
 b5t4EeUb8ChA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="388378330"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2021 00:38:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 00:38:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 00:38:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 00:38:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 00:38:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CsH0uvF3id/ZN1yrh4kmNrQ6WfyuP8PLK58/PjAcyhUyjuvjSVb3bz4eN6VRChZ9mazG6DZvX8yM+VoNu/6MPrtZgpCC1rUdicQJSc4McuWSVhjp5g9yTzGEkpY3e3e77eIDeMz35c8+SWOm8/XHY3XH7vnKH1seQi+VldscaiFCTW86r9zFnlLV/qXXT4CNzRvKVsIg3OMC9aUDWpG4HiZ1p0zCJsRUa82ts22F8FBQF9ZKGNWpQThK8hm9M3iF4jqHi1Hqutnh99AdvHMr0svUHeBjEiUqYMHmRoypTeRni8RZadMCQzYjV8oHcCf7M2xCdMmz4NB3WSy4nu+q0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5D/IVgO9DPuDZoQRAN9BJ7BCsnsyxoS5xhXFtdcgQYw=;
 b=gfxsLQJAea6RPfw/aS3gCNRmk0Jwdpwrjg29cBucQaphl9zUCpL9SB8anTNNYry7yhFY6pX/tCaorje4Zwrzx7JecTiWl5sfAYIyxamgWpl/h/1qzS0vgwlg9bexMsVD42bHPyibF58o2RqXuescnd7c1zZNwmJaM+SiZ+KuPAeVNS68ajyv571CGPcLvjzT3KBTVGUSjzRNJEmQhp3J7YXU4JeXN0iiPKE4wHyVEh/Myi2iXL9T+xOv9GSYvFgVID4m1YNuVnX7o5W/PTqIp2OmdnQGwlJ1AZ5GZCmrih8VKuVKCltIy065N4756NmotsOb90EP8S8HyCn2IS7kqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5D/IVgO9DPuDZoQRAN9BJ7BCsnsyxoS5xhXFtdcgQYw=;
 b=C7/JVuhVkjBEPeHYam9C/PiPaUhw9MwRh5P/wSbGgpx44V92HH0icRmqw9lEyvdmKnQF+zJIC3aK2B6iORMkGKcomP8n/+AwQPYJsXZfCUAgImTPi0QwRMLxKfXsy/HDXSMjJnduXTuCbffR4REKsr0ySh/1MQBobMNaVSucpYk=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR1101MB2176.namprd11.prod.outlook.com (2603:10b6:301:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 07:38:09 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 07:38:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH v2 02/14] vfio: Simplify the lifetime logic for
 vfio_device
Thread-Topic: [PATCH v2 02/14] vfio: Simplify the lifetime logic for
 vfio_device
Thread-Index: AQHXF6PnTydSuu+eQEO/mNtNOK79qaqGPibg
Date:   Tue, 16 Mar 2021 07:38:09 +0000
Message-ID: <MWHPR11MB18865B08DE53D9E9EE04DA5B8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <2-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <2-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63f6a943-ad29-478f-ce0b-08d8e84e725a
x-ms-traffictypediagnostic: MWHPR1101MB2176:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2176CC29ADC5562BF84507C18C6B9@MWHPR1101MB2176.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PvQ0ETqEbDeKGzK7Bwg4FXVNZJ561maf+twxTgJk3E2OPnDET18XobElAWFWlMF5yW36TLMSWoSReIqbZBfXE7RVCpuPS5joeHMegdjBLL8hwKblB/wvIvxABSN37NYqFgPEwZqLjD+P+trUUkB4lG/JT62RCM9303nrEYrxaOzhJHONO1X47cdDWo4ajA16g/b4GyXse+unWy4MPrcRbB616+JH/bwn0xtNQdl/tMBIXXMy29+d0OLRZguJjZVlH9LFRV+INPqF3GQGSd9iHT4qPVkZ0rEip+tojZkknyG9iIYcsvzuC2VOZFuJR3Vt/TOqKG+GXoFc/j62P9108xzgzJn6EGqcR0fORtEdcJrhQnFeJZ6EtOhlu5ljCHfUaA51Xk3LjaDU41vVmIysMKMyMriUJdw5uPfx3e5VlTyS/59qF3V0aal8S3RWM2ijsVJaentgcKX1HRZBT4v+UwVlCZ8nVnLRADODpyf6Lf1TsbaOjQZIT0Xc+BsaBX7UpLqw3LhePqLzeOeDJWehX1Dtz4228of9ixiZ9Ar6d6tP+Y771o0cSZnChNAkFywa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(366004)(39860400002)(346002)(33656002)(478600001)(26005)(71200400001)(2906002)(55016002)(4326008)(186003)(86362001)(9686003)(83380400001)(7696005)(5660300002)(8676002)(54906003)(110136005)(8936002)(66946007)(316002)(66556008)(76116006)(64756008)(66476007)(52536014)(6506007)(7416002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?r5z6nCj+IxgRy45eu0gzwEde50rMNmmVZvYvxNpDqtniYR12mgvIYY29K73o?=
 =?us-ascii?Q?GyJUnhVv7Zlugunt6FHf0rXDpGm+KZfiZwlQTYQz90xIgz+ZwX8IdB0qByeh?=
 =?us-ascii?Q?IPoKlMxaTm9JWWo9Yu18ZQHk/Gg8MZNbi4sij6KquSt3btAA2YhJdmfG08LS?=
 =?us-ascii?Q?YpifIt2enHtMXyfm34R21msNIiIPzBznjlpAuLHhe4XODyXXptHJauF7z+ie?=
 =?us-ascii?Q?ggvohRkaqg51cFQOMUuQRCVblqBopyfkF2esvdJH9bi0NiNB451UpEfGQBzP?=
 =?us-ascii?Q?z0Yf6WLL8zL+CJqlcOqKe5X1ouJlwAm+gPzul7osKjm3utFLezIjvdAh+vEc?=
 =?us-ascii?Q?DDhDa+bK1mp0Dzk+U9YumbwtsT3HkLUtmVSuG6BHBwkopLGDWIIPtya5PamE?=
 =?us-ascii?Q?joER7lsbBZGjx84hYOstidti5ropN3z15y8IHZyIs08L1jNEA/Ttr0PtiKKM?=
 =?us-ascii?Q?GUHV4OWP8b7vZ1z9hx+JkbyDfwEf6BqtrX7ttZUEYW6fLPeuC2f11+NgRRul?=
 =?us-ascii?Q?8Dbef+0tx6Cd0ivzHIZtWbNtPGuIFGhgAMX/13z9YPmgX8CUMNyFp6T6lEY9?=
 =?us-ascii?Q?irENCwtYXD9VlQHCuKyRbrLmSMSWd/bGbp2uH54s0dUEAvs7v8lRuKS4OrHD?=
 =?us-ascii?Q?VQYfFXsOcKXYhCOkrZbItz9ZPbBWF/BblpQt29oYmin8zp890QCc4BrVXP1S?=
 =?us-ascii?Q?I1KUGNrwEJtLpjQrLtRLKuJR0FMwsV7mjqb97sSUu6HAjIB6RnNhmF8DaUJG?=
 =?us-ascii?Q?inPo3Vbfred3O3K2Ca82DiKuhUASGnZC+xh+6FA3IR06embGb6/0icB2zuEK?=
 =?us-ascii?Q?eR0JL23TKGCQgmyyoZBwk3d7xyve0JrxDqooX6dhTRayF7AUJLWOc+8UfD0s?=
 =?us-ascii?Q?wqQR/H1oHXlQSnWibac6PnesDqj4NGLp4JAyYeP1r/pfSezsqnuKDphZDL9U?=
 =?us-ascii?Q?fyK7sJueJnNHWp8FMaxrKWXu+avxj5nIOaAvgg7eoU820G3JpXgi/gjbKTYH?=
 =?us-ascii?Q?hUS9sthIgTl2COTzHxuaaegf+BF0zXPZyO1z8oXfy9bYFWKf7OV12Ja89tEm?=
 =?us-ascii?Q?jKkH9o34j7t3KBDv0tZbtOL2xr8SDq6iyEuSSasfFSTuTVp5+jw3ml+6GL2T?=
 =?us-ascii?Q?hWpUzktv1cIA6RNsezdKSIamF6GdKUxpMeoyfaXvKQlXNXfgJbQx78XIUW8C?=
 =?us-ascii?Q?Qsvk80zTYr2g+1XB0JSOri/IUXt8LxDEuaBp5Xbar8MUA0+dceNj7jXws/TU?=
 =?us-ascii?Q?HqOJjlMUivgiSsSGxNU+qp89yfhTVlFdrGOM3ib7C9YtkaPy/RQKtwClCzx1?=
 =?us-ascii?Q?v258trcgenYOwrTaNil08BrY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f6a943-ad29-478f-ce0b-08d8e84e725a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 07:38:09.4382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kWbi33hZKdoACzNU8bfbgoSaXhDmjPIXa19IvxYCUsv3qA3FUnlr4T53lZlS5wvrrByCa8u2aJRkZecvkCOgkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2176
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, March 13, 2021 8:56 AM
>=20
> The vfio_device is using a 'sleep until all refs go to zero' pattern for
> its lifetime, but it is indirectly coded by repeatedly scanning the group
> list waiting for the device to be removed on its own.
>=20
> Switch this around to be a direct representation, use a refcount to count
> the number of places that are blocking destruction and sleep directly on =
a
> completion until that counter goes to zero. kfree the device after other
> accesses have been excluded in vfio_del_group_dev(). This is a fairly
> common Linux idiom.
>=20
> Due to this we can now remove kref_put_mutex(), which is very rarely used
> in the kernel. Here it is being used to prevent a zero ref device from
> being seen in the group list. Instead allow the zero ref device to
> continue to exist in the device_list and use refcount_inc_not_zero() to
> exclude it once refs go to zero.
>=20
> This patch is organized so the next patch will be able to alter the API t=
o
> allow drivers to provide the kfree.
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 79 ++++++++++++++-------------------------------
>  1 file changed, 25 insertions(+), 54 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 15d8e678e5563a..32660e8a69ae20 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -46,7 +46,6 @@ static struct vfio {
>  	struct mutex			group_lock;
>  	struct cdev			group_cdev;
>  	dev_t				group_devt;
> -	wait_queue_head_t		release_q;
>  } vfio;
>=20
>  struct vfio_iommu_driver {
> @@ -91,7 +90,8 @@ struct vfio_group {
>  };
>=20
>  struct vfio_device {
> -	struct kref			kref;
> +	refcount_t			refcount;
> +	struct completion		comp;
>  	struct device			*dev;
>  	const struct vfio_device_ops	*ops;
>  	struct vfio_group		*group;
> @@ -544,7 +544,8 @@ struct vfio_device *vfio_group_create_device(struct
> vfio_group *group,
>  	if (!device)
>  		return ERR_PTR(-ENOMEM);
>=20
> -	kref_init(&device->kref);
> +	refcount_set(&device->refcount, 1);
> +	init_completion(&device->comp);
>  	device->dev =3D dev;
>  	/* Our reference on group is moved to the device */
>  	device->group =3D group;
> @@ -560,35 +561,17 @@ struct vfio_device
> *vfio_group_create_device(struct vfio_group *group,
>  	return device;
>  }
>=20
> -static void vfio_device_release(struct kref *kref)
> -{
> -	struct vfio_device *device =3D container_of(kref,
> -						  struct vfio_device, kref);
> -	struct vfio_group *group =3D device->group;
> -
> -	list_del(&device->group_next);
> -	group->dev_counter--;
> -	mutex_unlock(&group->device_lock);
> -
> -	dev_set_drvdata(device->dev, NULL);
> -
> -	kfree(device);
> -
> -	/* vfio_del_group_dev may be waiting for this device */
> -	wake_up(&vfio.release_q);
> -}
> -
>  /* Device reference always implies a group reference */
>  void vfio_device_put(struct vfio_device *device)
>  {
> -	struct vfio_group *group =3D device->group;
> -	kref_put_mutex(&device->kref, vfio_device_release, &group-
> >device_lock);
> +	if (refcount_dec_and_test(&device->refcount))
> +		complete(&device->comp);
>  }
>  EXPORT_SYMBOL_GPL(vfio_device_put);
>=20
> -static void vfio_device_get(struct vfio_device *device)
> +static bool vfio_device_try_get(struct vfio_device *device)
>  {
> -	kref_get(&device->kref);
> +	return refcount_inc_not_zero(&device->refcount);
>  }
>=20
>  static struct vfio_device *vfio_group_get_device(struct vfio_group *grou=
p,
> @@ -598,8 +581,7 @@ static struct vfio_device
> *vfio_group_get_device(struct vfio_group *group,
>=20
>  	mutex_lock(&group->device_lock);
>  	list_for_each_entry(device, &group->device_list, group_next) {
> -		if (device->dev =3D=3D dev) {
> -			vfio_device_get(device);
> +		if (device->dev =3D=3D dev && vfio_device_try_get(device)) {
>  			mutex_unlock(&group->device_lock);
>  			return device;
>  		}
> @@ -883,9 +865,8 @@ static struct vfio_device
> *vfio_device_get_from_name(struct vfio_group *group,
>  			ret =3D !strcmp(dev_name(it->dev), buf);
>  		}
>=20
> -		if (ret) {
> +		if (ret && vfio_device_try_get(it)) {
>  			device =3D it;
> -			vfio_device_get(device);
>  			break;
>  		}
>  	}
> @@ -908,13 +889,13 @@ EXPORT_SYMBOL_GPL(vfio_device_data);
>   * removed.  Open file descriptors for the device... */
>  void *vfio_del_group_dev(struct device *dev)
>  {
> -	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>  	struct vfio_device *device =3D dev_get_drvdata(dev);
>  	struct vfio_group *group =3D device->group;
>  	void *device_data =3D device->device_data;
>  	struct vfio_unbound_dev *unbound;
>  	unsigned int i =3D 0;
>  	bool interrupted =3D false;
> +	long rc;
>=20
>  	/*
>  	 * When the device is removed from the group, the group suddenly
> @@ -935,32 +916,18 @@ void *vfio_del_group_dev(struct device *dev)
>  	WARN_ON(!unbound);
>=20
>  	vfio_device_put(device);
> -
> -	/*
> -	 * If the device is still present in the group after the above
> -	 * 'put', then it is in use and we need to request it from the
> -	 * bus driver.  The driver may in turn need to request the
> -	 * device from the user.  We send the request on an arbitrary
> -	 * interval with counter to allow the driver to take escalating
> -	 * measures to release the device if it has the ability to do so.
> -	 */

Above comment still makes sense even with this patch. What about
keeping it? otherwise:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> -	add_wait_queue(&vfio.release_q, &wait);
> -
> -	do {
> -		device =3D vfio_group_get_device(group, dev);
> -		if (!device)
> -			break;
> -
> +	rc =3D try_wait_for_completion(&device->comp);
> +	while (rc <=3D 0) {
>  		if (device->ops->request)
>  			device->ops->request(device_data, i++);
>=20
> -		vfio_device_put(device);
> -
>  		if (interrupted) {
> -			wait_woken(&wait, TASK_UNINTERRUPTIBLE, HZ *
> 10);
> +			rc =3D wait_for_completion_timeout(&device->comp,
> +							 HZ * 10);
>  		} else {
> -			wait_woken(&wait, TASK_INTERRUPTIBLE, HZ * 10);
> -			if (signal_pending(current)) {
> +			rc =3D wait_for_completion_interruptible_timeout(
> +				&device->comp, HZ * 10);
> +			if (rc < 0) {
>  				interrupted =3D true;
>  				dev_warn(dev,
>  					 "Device is currently in use, task"
> @@ -969,10 +936,13 @@ void *vfio_del_group_dev(struct device *dev)
>  					 current->comm,
> task_pid_nr(current));
>  			}
>  		}
> +	}
>=20
> -	} while (1);
> +	mutex_lock(&group->device_lock);
> +	list_del(&device->group_next);
> +	group->dev_counter--;
> +	mutex_unlock(&group->device_lock);
>=20
> -	remove_wait_queue(&vfio.release_q, &wait);
>  	/*
>  	 * In order to support multiple devices per group, devices can be
>  	 * plucked from the group while other devices in the group are still
> @@ -992,6 +962,8 @@ void *vfio_del_group_dev(struct device *dev)
>=20
>  	/* Matches the get in vfio_group_create_device() */
>  	vfio_group_put(group);
> +	dev_set_drvdata(dev, NULL);
> +	kfree(device);
>=20
>  	return device_data;
>  }
> @@ -2362,7 +2334,6 @@ static int __init vfio_init(void)
>  	mutex_init(&vfio.iommu_drivers_lock);
>  	INIT_LIST_HEAD(&vfio.group_list);
>  	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
> -	init_waitqueue_head(&vfio.release_q);
>=20
>  	ret =3D misc_register(&vfio_dev);
>  	if (ret) {
> --
> 2.30.2

