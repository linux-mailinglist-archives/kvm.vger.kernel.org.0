Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FEA6734B5
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 10:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjASJpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 04:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjASJpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 04:45:41 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBD06DB07
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 01:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674121526; x=1705657526;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R6xhQZYnd8LT/MzmsuUaiDBWKRm3zOs7JuNpqFVAjfc=;
  b=aBUZVudSPB9aUvzqKi1PCYgNQWqZv4IdrTOER2dAeOMFlkzKgMZbzSzj
   qOmMBrsVPOS6oza1Ib+P0IUze0jxC+L9yE2kH1/8CLUsWBJvXvKgzfO61
   kRJ11WOo0DfcECXlulbZwYgSIZHuuequxwuGeVftjrJDWsZ70KzGKCuuD
   pV5KxDXqc1y/KwVxOGtjBr008Ic3PYe2L4sLeiP5OqX3GzgFdE+Kbnxrf
   dNJc/mcwXNpwXwfC0U75pE5YkRoT3Iko+Vbqa2pBGaFIXDK01ioGYBOJv
   tD5JlmH+qIDS1aUPi9YNnyB6Bfek3x29YGryUjzSFkkJCNmTG9FIMcF9p
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="322928764"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="322928764"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 01:45:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="988923695"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="988923695"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 19 Jan 2023 01:45:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 01:45:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 01:45:24 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 01:45:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3olz7QZ84c7aiaQMYUWy6/qQ1L5JOhMeQDnCchiMr9dMkUo0MpG1WG40Yf/Eykjq87QztwV9CbDNwXhd4M65yaavcEl+Umt7qHGJel9TaNElPkIB0E8qY3kETTME9fqZNLup+96OFELO2UEl6n8+wHuzbRSFV22mB2SPmVdO9EjiDLzV/EWq5+Azo3GSRHu/QkIU0hDKM/CdUn0xb35yUKyX50hruVY59iBMqJ84SpzDxrX7k41qk36WzOifSvJtdU5/A43QCOW4cTQXV3SYkNyuuUf0uRJKFf7nyHwZhJ1bNZ0PcZjl7gEHekKoLGENY8VmWGyhyj61/PkZmXmVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edO6t564bXQEEzDnhaEKDqiuan6Cuib/kA6qq3Wmy+k=;
 b=HW1+PVRo5nAAhAD95Dq/FM9jaMWzoQPEVLLm8kCyHUYhsYdfzzJl/j34fKdfRELqtbCzgbTH6ILQh7XrPXdMexDhFqmdb9yJBOUVilQRNIh6Z5lPcqlIfvCUF8Pc+DH7pBc2qpL7pJ7QB0cdGm0vuio+i6L5rhGz7YiU0s4si9lQmDNqTb3QMdyK6X5cGFxDOlUhsFUyhgKMCatI87QKHzXaaCw2YQTUxQGS0bfqZwgUMY4Bh+em9dfCBi3vSUs42sfikZpkv3fCCpIk5DBWyw4TDy93fBxGnHQbMA21UzujiIoSJxNQdIwjfaiJXjgbbXySeshjtyYiyBybgBKSIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5315.namprd11.prod.outlook.com (2603:10b6:610:be::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 09:45:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6002.025; Thu, 19 Jan 2023
 09:45:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 09/13] vfio: Add infrastructure for bind_iommufd and
 attach
Thread-Topic: [PATCH 09/13] vfio: Add infrastructure for bind_iommufd and
 attach
Thread-Index: AQHZKnqY+3Kf4+g2gkqUPxLv4GjGsK6lf3Uw
Date:   Thu, 19 Jan 2023 09:45:21 +0000
Message-ID: <BN9PR11MB52764F98E64DE3BB8305F7248CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-10-yi.l.liu@intel.com>
In-Reply-To: <20230117134942.101112-10-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB5315:EE_
x-ms-office365-filtering-correlation-id: 742a68cc-c7a1-42d6-beb9-08dafa01e1bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: alINJEWR58qN3OrqxCNqd74wd6R5Am5APYscSEHWWb01nlBe1bL/BGiEXAj4NjHtL9q8MWsMGVQsDyGNcZE1tYSVFCoLqwEWijjAeFPBXOJS8m2GYfnvFEoZWRlgSRqAQElbvUlDRyer9aK003b3f/lCsjTdo6UW3aD6b4YGwtxAT7WrIR/z2W2Wpp+lv6OA8a5hLeMqWbCSm4Vj9cTJRIBoEOLx2UFYB0OO3krjVipSOEp9Qf5UF00gZ+6IbHZbpD5Nrbpyz6uip4Joo3skZLSK2Jv/ZzhE2alDqo/bE1OtigKnno3kBl0mbv6Ac/GXC9fXvlNetT0fj7vUvbMbtxECk3d6aOJCVgl1TDze7usElpJM++Q3djFTOsNOXMYSlkzFw48kYwJSJRaotnvTogK/ldimOmiJ7QBkIcy1sD3iPXEpUhk+qW20HvQRy4C3z8glIsciN2KhFctK6zxcHZxsA+pXHhPvcKjIUxXN1YiBBTJmkWSVXzA/owS6q0AZLHG36ZQylsbLK9Lt6zR23G2ZvJuB6UZZ2S9PEFry6rHupo3YZH3PJU8iJGAxnYPGlg6E7eLAqpfu9LHyoxlG1pwsaauyKwnEoiMTHeV44Rqz3G8h2EXXdwJCLUeF8xBFmzV6y6GyMyEyr4wB7rBSUXEadcqCiavf9UzOMFOOKx93+xwyTrXUIJI46bmuDzly
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(6506007)(9686003)(26005)(186003)(478600001)(110136005)(54906003)(66476007)(66556008)(4326008)(8676002)(76116006)(66946007)(66446008)(64756008)(83380400001)(316002)(41300700001)(5660300002)(7416002)(52536014)(8936002)(2906002)(38100700002)(122000001)(7696005)(38070700005)(55016003)(86362001)(82960400001)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uilwgNhrhYFrmsHyPYdz7zkWMmp+QB/Amq4Tu3oiYpysK5k1Wmq+wcgNSID+?=
 =?us-ascii?Q?XHuaWWUsF3VLDetQTcH8nuZUz3IKLCY9L77FbPULrjzPCBHpXMhrfJJuSa6z?=
 =?us-ascii?Q?5Iqk/n/a8J26FyTecIv/dXDbfW7yuSu6h+PFb9c14K4mqFL8C6c25kjB0fOR?=
 =?us-ascii?Q?8iQnK3RPY7iStKBF1UznqTlaOkTeoJwAaJb2ymk6HvpCj3U+83BjBzu+439H?=
 =?us-ascii?Q?FAP3pMTemLq327n13aDbZzT1KPCJJE/LW/Qym+aixTUgqQpYzM7qq60ADntW?=
 =?us-ascii?Q?EbljDiCIeWuHYPcDGM9qVUGDPCl78uyHUPlJTb4kfCGsS++02Y4YRw6PxQK3?=
 =?us-ascii?Q?fAMjoNetqfHuRLLszBPZvbBl1orrVjvlTEM8I363GlfepBtIpjYd98mNo86N?=
 =?us-ascii?Q?Z0phaPPqVqd5qtNOpDCYCi55wlxN6XJX5Ej8qfvaaq7XDCeXwQtyjHtdw5O8?=
 =?us-ascii?Q?OSkTtDge3try1vDa6o7ZVrzs+ISHuBVvpkvFfHI6zS6u8O78/t4a0sjlgLN6?=
 =?us-ascii?Q?drWsTDd4uPm5pHAlHk+pBc16Z9MImQ9SDYIUvdOANU6OIln7+rkcdlYiauIc?=
 =?us-ascii?Q?0t8Q7m5f4GlGRVE7+F63wK9/nkv0jrZalmOmmapm/TUDyfFmNhaXGboMWN4m?=
 =?us-ascii?Q?HI5tIuCmMu5Uhr143nWje1zICotvIQqtlWAtzusst3TJJimavyOQ+sUSsUF1?=
 =?us-ascii?Q?ZHzDzcmppQvk2q5PF8QW7AZanovHC9YKz+yXRbeaE7PCUkTnafKxKcSbYO8m?=
 =?us-ascii?Q?t9JF/0oJF8nUMpEAQE8EqtYsZAjd6bkJq9ns/FPnaTV6Q0kIOoJTemgibZKr?=
 =?us-ascii?Q?tDpL6kAQ7Fsc7OtgDuHJtWoF6+4BJCgAOIbKW16rYhH1xzdjQqEQXEZ2i5wQ?=
 =?us-ascii?Q?+kY/iEYOffQZL5u0VHbhyhS2BBMxT0Uy1G2yRyYsrgraP3JTYqY6oe7CEexg?=
 =?us-ascii?Q?00/GRUKTSmyFJZtXCmkc7+3Y1+inVwqig9dDfj6gYappbkbJ4L6JO+2p1bFO?=
 =?us-ascii?Q?qv6kpWYo4ituBPmlkVdZjB6qFP+OWCoFWpIBJS1PVYhvU0k/Nx0La/gHvoFQ?=
 =?us-ascii?Q?/SnQjMcmMwOATiMR25YYiEJzIaLV5f2plmVBrQGXY3o0QAnVa9/KtrlZmbRG?=
 =?us-ascii?Q?QMfk0XZ7Mcg7iQcrNYBNQnH9yk9fClwzFKgdOw8ZIDiBUdmO+L+ZJD7FfDZ0?=
 =?us-ascii?Q?rrFYQzqM5UB+dofk1f5maJDh1zJ8qPIKsHifa/z2u5H3JzXX6TTQ0sHXmrR0?=
 =?us-ascii?Q?Y2eU6W0i8r+/8hcOQ84teKKrTeiVCsHMSDS2zUkFcoj5yOITj8cgf8iORtcG?=
 =?us-ascii?Q?+TIyw3Re5ZNkMYIbRqHqEZk/dpF6TbdcrCoF2sfupuy9R4H4MhUfk2ydLFrR?=
 =?us-ascii?Q?op2L4FZRDRfnFwT7LN++l7aeoeuU1qyKvalTse/1kNtvG43WOAneVPHNd1MY?=
 =?us-ascii?Q?E68pgXFqjeQ+eZFnc8nAgPueqxUiAi9kOSEIZVs8pJ8qXwin0CRrFCDORa0S?=
 =?us-ascii?Q?ecnqy750AKnHZvVQu09r8Hmkdqdev7UJgMf3yajy3DZ73Za6p+G+oZzca8dy?=
 =?us-ascii?Q?/6O7F4GUs5vMJV9tXKoYosC4oWpNa3FiD9h9VUgr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 742a68cc-c7a1-42d6-beb9-08dafa01e1bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 09:45:21.4941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +HK73fzbqiC/0hvYZ9iBaZRnS0GXqlIMmkx7Td08HIBVL6p8VsYdIRe2E4E5u0tUQLS1r6reM1qJld82JfL8OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5315
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, January 17, 2023 9:50 PM
>  static int vfio_device_group_open(struct vfio_device_file *df)
>  {
>  	struct vfio_device *device =3D df->device;
> +	u32 ioas_id;
> +	u32 *pt_id =3D NULL;
>  	int ret;
>=20
>  	mutex_lock(&device->group->group_lock);
> @@ -165,6 +167,14 @@ static int vfio_device_group_open(struct
> vfio_device_file *df)
>  		goto err_unlock_group;
>  	}
>=20
> +	if (device->group->iommufd) {
> +		ret =3D iommufd_vfio_compat_ioas_id(device->group-
> >iommufd,
> +						  &ioas_id);
> +		if (ret)
> +			goto err_unlock_group;
> +		pt_id =3D &ioas_id;
> +	}
> +
>  	mutex_lock(&device->dev_set->lock);
>  	/*
>  	 * Here we pass the KVM pointer with the group under the lock.  If
> the
> @@ -174,7 +184,7 @@ static int vfio_device_group_open(struct
> vfio_device_file *df)
>  	df->kvm =3D device->group->kvm;
>  	df->iommufd =3D device->group->iommufd;
>=20
> -	ret =3D vfio_device_open(df);
> +	ret =3D vfio_device_open(df, NULL, pt_id);

having both ioas_id and pt_id in one function is a bit confusing.

Does it read better with below?

if (device->group->iommufd)
	ret =3D vfio_device_open(df, NULL, &ioas_id);
else
	ret =3D vfio_device_open(df, NULL, NULL);

> +/* @pt_id =3D=3D NULL implies detach */
> +int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
> +{
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	return vdev->ops->attach_ioas(vdev, pt_id);
> +}

what benefit does this one-line wrapper give actually?

especially pt_id=3D=3DNULL is checked in the callback instead of in this
wrapper.

