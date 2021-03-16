Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D897333CEB4
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 08:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhCPHeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 03:34:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:24914 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232552AbhCPHeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 03:34:00 -0400
IronPort-SDR: VM8JAg5IZ4iXU9Zdlo00B6mUV2quQUvNqLdAbYlsr8xBcSvOajPp7x7B8gwHjfslyhCxUKA07j
 dkISSF0g516Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="169130271"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="169130271"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 00:33:58 -0700
IronPort-SDR: lJXdjt2e9wnB5J7J0P36P8PfT2MCuISEhEfU1GM4SoR+/8wDfOoXMwJVPg6mXE4oIoMwItKtYI
 6IuvxgJxVy4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="371894365"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 16 Mar 2021 00:33:58 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 00:33:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 00:33:57 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 00:33:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnTtzG0+PNGaLxoDj0Lk2RehSuG4qnr/JJcME2HTZewGD6iwe3/LJ0jvPXpr+9JfAaRkVqr+wzzmn3ib3qyuzedBWnv4p/HjGhLFavxSf5I/XV7wvxhhxuHry0R4D9mWwuKwhpW6hQBa95fMOrMsO7ehJHs7bD5nv9tRtUoEd1GBaBj2ByMiDErPluFA1jbDViawdANrKTBesHzvKYHeApih3o1Kw9OR5u+UUX/q2lzu84Il0dcZmRPxcQA9Exjxvrurxtna8Sn+BAKnnuwZi8YoF1YABbujw3QR21xKUeGwNHCozJQWZT0ih3wb8+phch0pcfe8SHNahKiRCVBG9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XompRusryUMLFM+W1qExjdHuYGfPL/kA6+X0/Dgdco=;
 b=H5SzXR7b6ogfUxLs0qUBNvjINfK0xu9XHGjmXBl1bAmi+w6QxP6XhhAEz0e1eUgoit5OTalvNwHHJGAnmwSubmwYT9U29dxPhMTn7V3qhTGr6Yu0ldLeoeD0O8zp3m3EbCNsorbgoAKNsoxisV1ndiRzuOenqcVDYH5gHWwE271Sm/93NjsT+6DBcFKwasJga//T7mMkRmeTK9iiM609HW9SuZdnXQT7Htjv60SD1rJpT1Y53M3RXJAKB28OFtG5h+4UOl+/zhVR056eHk8stF2vyzzlXU8xJghBB85IWP+2HVthrulQ2NoFhRxQf/2hNNIy7ey206DAB2a59JQfvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XompRusryUMLFM+W1qExjdHuYGfPL/kA6+X0/Dgdco=;
 b=pFfalTzeWiptx0dnMj79Ca7hfEtNqXc+1e9tBxrCDkjVlPVz7Iq8B+jErtiPAFt6NN966GFk0XUS3SzLwV7RSN9JI65gtu1hIG3x57ytOdYv7UWrS15pRs1Uim6Uuf3gtl18EmRC7LwWhp/2q0QvocGyJ/FgIbC4eGyazxkH2pU=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR1101MB2176.namprd11.prod.outlook.com (2603:10b6:301:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 07:33:55 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 07:33:55 +0000
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
Subject: RE: [PATCH v2 01/14] vfio: Remove extra put/gets around
 vfio_device->group
Thread-Topic: [PATCH v2 01/14] vfio: Remove extra put/gets around
 vfio_device->group
Thread-Index: AQHXF6P+5ZL3gouDMEucT8NEjICOD6qGOYzA
Date:   Tue, 16 Mar 2021 07:33:55 +0000
Message-ID: <MWHPR11MB1886F207C3A002CA2FBBB21E8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <1-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <1-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 1fe9005c-a734-493a-d2fe-08d8e84ddb07
x-ms-traffictypediagnostic: MWHPR1101MB2176:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB21762F6BEE9E4BB99D04E47D8C6B9@MWHPR1101MB2176.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XQhNhn62vBHxSSdWG1qhM9MtNpsDSqAH7f5Tpd9ckGNpapcFzmvanYZbgiEVGyI5sxV6UEHKY75SUDFmiyBj5cB90cojQhhuGYkfqS3YJlufYKhmCDZJ9N5+eWq6/dkpADXwtegNcuXYDKObiWIJZo3+/gY1gvuZWeSASAhgVTYu3jqkCXjJFdgDqd5ZSU2ge8r3wLkFyov5pSPnvjY20HrlIO4PDrMtpaVSuseCtTM61w3uXppPeKjVY7P0mcuL50t7i6iysmlLd3l6aa8e+33uOVrvkXdnvypcRtUTzvBG4UFrVrSHI8kZxQkRG3/z9bHufZmGVhDlLi0LbZFFLNRCX6lCRRUoXPAw8PcTTt3JodwOxGmtFgViKZWjyIzVRy2ahnJDQg26zvI6W4McZSYOzAVM9+V/Bv+U71morIhfRPNU6bb5TEs0qRryXBAzqMRr+gfO/EcO7qANk5lHF8s0hgs3WowqDeynTGqP62sK8S3RYd9ep+jx1WYi6c4s25DErWj6pVN4F4tmqzqwux/AqywnQWSPS2YNskF1cqNHaBpE5nc1hxVzU7UErdgk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(366004)(39860400002)(346002)(33656002)(478600001)(26005)(71200400001)(2906002)(55016002)(4326008)(186003)(86362001)(9686003)(83380400001)(7696005)(5660300002)(8676002)(54906003)(110136005)(8936002)(66946007)(316002)(66556008)(76116006)(64756008)(66476007)(52536014)(6506007)(7416002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qe7nLk33rfns1WQmxIRXr1u9kyRdd8fKW8LNCxX7Q5nHgAZVtomMCIXa0mT2?=
 =?us-ascii?Q?RpJM73HRB7S7PtFlK2BZ7HkP8wBRvQ6DoRGWf3z3x6voeJ9ejXUHBexKvPkg?=
 =?us-ascii?Q?ZdAe31MszYSGoBDR1387k/lBxsYxEQjzL1PWk3zJubhQQKcRaGthwR5fWANh?=
 =?us-ascii?Q?fBcmH7XSwnlGVM22dsby7NtkH7LSMeWJwD59ceMiYTzn/fry1qpUZohNjsUf?=
 =?us-ascii?Q?Xt9UdRopu2wRHW2j8wBESnkxv5d2OQxjiBQCgkKbJb7hioAjVk7GnbwoGMzf?=
 =?us-ascii?Q?pmaLKPhvmF3O/UrTE293+kt9sA89DU88VCooIvzMYt0ebcG9R3TFx95yLxLX?=
 =?us-ascii?Q?xzAdR/x9Z1qWcBmQmj259j0S6/qFECZC3uOClnTYUFxd2t71tG3V1bOhkhrQ?=
 =?us-ascii?Q?mI6lqJlOHbDrmAKz/LEXFhWfhsTFYk819ZxHpDQiqG+Dyk/LmVqIfy+AEwcZ?=
 =?us-ascii?Q?508uhK84zfLnLp7//mgxGv/F5GxSJz0Bt7MHr75IRro4PwL/KNXSzYmg+LXr?=
 =?us-ascii?Q?vHKaSEejMfWQE/NJxMMRixK/c5TGmUIN8jNk2q56um9gZya8xCW2ap2/EXUb?=
 =?us-ascii?Q?tmFoTsVDoc7/dFbiMxuJs4HnXXXa1Up3C2dLvS0cXcIRbGXnfmxdPx3RzsrN?=
 =?us-ascii?Q?7HRsjpmYlcrcy/c/fHNZ8qC+zCF4pOovhBcvBTABDG+F1nGVqm2HJUThuxZY?=
 =?us-ascii?Q?Bw9m9sa3HGLy2vYwKTwrCbnYv1gpJianakXCbOMRN9BICem513kCj37fAoq0?=
 =?us-ascii?Q?XeRXC9t45nufloGPAA870aOzw10T/uzzD/fZA2lBzf45ZdtCihZ98zQL5kTA?=
 =?us-ascii?Q?huz4F25o/4cM7nezjnrOy4oe9pLXT0x5i4yYc3XWODwCM2fKCnAwleaKx1iL?=
 =?us-ascii?Q?6RGF3lDd1BS+NJ66qTQHjzWvnv98cAa41oe8Z+uYR3+6DFwwnYeUkQ0rcngJ?=
 =?us-ascii?Q?QtlatC/X9kYT1cjqkoFBhJHAusTt+QRxiPFbY/VbQplJpmkCQvm5hMCqRT3u?=
 =?us-ascii?Q?jnowiBZqmgRbneY/mS3tnQWelUdsHa36V/PVaSixL8cYkyQBdyiKCDWbqSq4?=
 =?us-ascii?Q?6pwIwlH1Yg0I2CYC4GlucPGOO2FV1GjXA21WgsAMiuPV05wSdeX9FL3qUuFa?=
 =?us-ascii?Q?wfARzYekI7GJ26Nk1bc34M5JSSh/ycFcaTE7KLwZyyOjWFFaLXsCXZCHhX2j?=
 =?us-ascii?Q?mFOQn9GlAOaWE5FEbYlleiWPPW2lQbxv+e5CK3bzV45naarhEPs/Flcwe5qV?=
 =?us-ascii?Q?XyJRBu4EkkdC5XzSB4NwV7Br5FUOl/gxWaczq9X/VkfWkKCrl3WePu+iWllF?=
 =?us-ascii?Q?re60EFcFNNGqRoqJNXpw/LiB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe9005c-a734-493a-d2fe-08d8e84ddb07
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 07:33:55.3066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tVA/X8+bxnOUA+A/JX7v0Rn8eO0F6C1bzLBuoBitBTwhdIXCfxdPA9U7DvCzbhhNrnFyBh5WI6it0w8+0uvIUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2176
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, March 13, 2021 8:56 AM
>=20
> The vfio_device->group value has a get obtained during
> vfio_add_group_dev() which gets moved from the stack to vfio_device-
> >group
> in vfio_group_create_device().
>=20
> The reference remains until we reach the end of vfio_del_group_dev() when
> it is put back.
>=20
> Thus anything that already has a kref on the vfio_device is guaranteed a
> valid group pointer. Remove all the extra reference traffic.
>=20
> It is tricky to see, but the get at the start of vfio_del_group_dev() is
> actually pairing with the put hidden inside vfio_device_put() a few lines
> below.

I feel that the put inside vfio_device_put was meant to pair with the get i=
n=20
vfio_group_create_device before this patch is applied. Because vfio_device_
put may drop the last reference to the group, vfio_del_group_dev then=20
issues its own get to hold the reference until the put at the end of the fu=
nc.=20

Nevertheless this patch does make the flow much cleaner:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

>=20
> A later patch merges vfio_group_create_device() into vfio_add_group_dev()
> which makes the ownership and error flow on the create side easier to
> follow.
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 38779e6fd80cb4..15d8e678e5563a 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -546,14 +546,12 @@ struct vfio_device
> *vfio_group_create_device(struct vfio_group *group,
>=20
>  	kref_init(&device->kref);
>  	device->dev =3D dev;
> +	/* Our reference on group is moved to the device */
>  	device->group =3D group;
>  	device->ops =3D ops;
>  	device->device_data =3D device_data;
>  	dev_set_drvdata(dev, device);
>=20
> -	/* No need to get group_lock, caller has group reference */
> -	vfio_group_get(group);
> -
>  	mutex_lock(&group->device_lock);
>  	list_add(&device->group_next, &group->device_list);
>  	group->dev_counter++;
> @@ -585,13 +583,11 @@ void vfio_device_put(struct vfio_device *device)
>  {
>  	struct vfio_group *group =3D device->group;
>  	kref_put_mutex(&device->kref, vfio_device_release, &group-
> >device_lock);
> -	vfio_group_put(group);
>  }
>  EXPORT_SYMBOL_GPL(vfio_device_put);
>=20
>  static void vfio_device_get(struct vfio_device *device)
>  {
> -	vfio_group_get(device->group);
>  	kref_get(&device->kref);
>  }
>=20
> @@ -841,14 +837,6 @@ int vfio_add_group_dev(struct device *dev,
>  		vfio_group_put(group);
>  		return PTR_ERR(device);
>  	}
> -
> -	/*
> -	 * Drop all but the vfio_device reference.  The vfio_device holds
> -	 * a reference to the vfio_group, which holds a reference to the
> -	 * iommu_group.
> -	 */
> -	vfio_group_put(group);
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(vfio_add_group_dev);
> @@ -928,12 +916,6 @@ void *vfio_del_group_dev(struct device *dev)
>  	unsigned int i =3D 0;
>  	bool interrupted =3D false;
>=20
> -	/*
> -	 * The group exists so long as we have a device reference.  Get
> -	 * a group reference and use it to scan for the device going away.
> -	 */
> -	vfio_group_get(group);
> -
>  	/*
>  	 * When the device is removed from the group, the group suddenly
>  	 * becomes non-viable; the device has a driver (until the unbind
> @@ -1008,6 +990,7 @@ void *vfio_del_group_dev(struct device *dev)
>  	if (list_empty(&group->device_list))
>  		wait_event(group->container_q, !group->container);
>=20
> +	/* Matches the get in vfio_group_create_device() */

There is no get there now.

>  	vfio_group_put(group);
>=20
>  	return device_data;
> --
> 2.30.2

