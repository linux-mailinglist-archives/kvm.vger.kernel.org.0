Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA516B5A70
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 11:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCKKY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Mar 2023 05:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCKKYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Mar 2023 05:24:25 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FB4117206;
        Sat, 11 Mar 2023 02:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678530264; x=1710066264;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TvXo6cd0Rvpi3s3jy/MJqm+Fup7rhSgBclVEBlxum78=;
  b=cNXLd93a5EmX6sO7MxRTyoUBighiJgfQ+KUtZNCCn92MqpM6Lqhh1KAq
   NaLV+UMNlyfVVmya5cY9HIIeuL/z58SDKnjLhiJWJ6WcdQh4gq6XOzJh4
   lqNDpQ5sz5rrQ2DOgEwJFwnrVMr2/F+afB9PmGS7QEl2ESOfkofupN18h
   OVqqy6LG2BWzl3UAAQzMqomO4cH6LxHVz/I4inPo0ueZXW9PU0jj0fhoJ
   ODmZIGi7rWLIe9uHLuzELQxPow2odtTA3LGd1mkclXEc3PKtP1pAIqGGB
   dMhY/mqp6wSJxezouuqtvs2W72p0wS6Qt6Npp+aGJm2UIrDKlgMJzQys1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="320743985"
X-IronPort-AV: E=Sophos;i="5.98,252,1673942400"; 
   d="scan'208";a="320743985"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2023 02:24:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="678120326"
X-IronPort-AV: E=Sophos;i="5.98,252,1673942400"; 
   d="scan'208";a="678120326"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 11 Mar 2023 02:24:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 11 Mar 2023 02:24:22 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sat, 11 Mar 2023 02:24:22 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sat, 11 Mar 2023 02:24:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxgpaG03K3J/vPb3bgSSQ8wTqdBUHfaG+z4BRJapSZcJ+0v0IZRTQrtI+NSVnJSTx7kZCjW7Rcs7ew0zy4wvIVfhUUG0hDMjCduDYFWyEt5jqK2hptHLlorIMIqXgN3QJAOlVpZoZeY8wlZlypJ2ViSIzK+FIwrw3608qXtqv6Ups1P3p1/dl9dZYIi+JIih0KQyzUKkm6tj+rtGS9Q9XoszY5D1tTYsZ0WcxPly0flY+kUbb/Xscf8dkfHhfifPI7uF3i2jIXJAldBHznIeOoAvd462AxMu+yE8zSya1H1RDVzriKRdg6sI+Ya2R651p7IBhDKEUpsAfk3LMt1Srg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6f+8LeU60QKU91CJmDgoF3I7Doal17WUdm5b0bfpxFg=;
 b=ePnFJcqckEWlMGENtDFKzMHGgof4gICb1pDic39t27m2CYUlFtXpFRSsYd5H/+O1GxieHO5rUo8y1hQC73/+kE1lKBTT6lkCX7n6OTZmLCOYQEukKY1FSABoopkxUyklFzD96GgzeADt+wXpphSAPYcjnA/foGwuwnCr95Czf/pDwztA9VKwIqNomxhU6qsCIkXBQWbLolRgVnEFzLwLmVsuO2EpJwYl5htGt2+rEj2luafK/OKVI+FGlECnI8SY4TeT8FP/Q9mTahLULvxIugCj6jyX80nn/IzLJQAehdKf1t2jt6zr8uw5q0moFK+KmB9DDoeMcaJ/FFQ6iubiUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB5898.namprd11.prod.outlook.com (2603:10b6:806:229::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Sat, 11 Mar
 2023 10:24:20 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.019; Sat, 11 Mar 2023
 10:24:20 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v6 13/24] vfio/iommufd: Split the compat_ioas attach out
 from vfio_iommufd_bind()
Thread-Topic: [PATCH v6 13/24] vfio/iommufd: Split the compat_ioas attach out
 from vfio_iommufd_bind()
Thread-Index: AQHZUcIKwrJK9uulkk+0mMZZcJqffq7zq2QAgAAAf2CAAbGUQA==
Date:   Sat, 11 Mar 2023 10:24:20 +0000
Message-ID: <DS0PR11MB752958F38FC08C15E3E25C1AC3BB9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-14-yi.l.liu@intel.com>
 <BN9PR11MB5276CF102D9EBB7B447C58FD8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529BF46B3A81438DE7A11D2C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529BF46B3A81438DE7A11D2C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB5898:EE_
x-ms-office365-filtering-correlation-id: ac8e5391-bda2-446f-dbaf-08db221ac6aa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ttcmsvvzelw/gEqujkMGMxdLy9hGbD9BWu5P+Mlq2/y+1Duvin9mmhmvkP1JsusWaQeElRH6tKm91HKcD+Z6Y2V8kO+pn4T2MlwH0ckYXkO31ZzWmYsWOU0d1fgJRf2es7lis5pWdQV0TzrOQqaEno7tN05BR4jtTGXBNcEsvIDel2apLkhV2Q7VuO/eazPr1r5RIXRhYSvTFTXGm9euQ0G9CQ+5HgrDguMh4J4DR4vtU4tYDm6eFRH5brviOOBTbw8+/fnXaPXBMJ8pLxraosDfvekvzaI1TscnN96woM7oh1S+KMpQMaKn7oHom4Epq5R3lzHkMTRs9XBzdMEn8tPnmAGGGj5cqJcl6iltVh/kvEGwjmcvWCK1VSZrKZkTE1eK+4trhjoPQ1VOIXXGk0EkFob3d7SjOC//TbASDTWvRHl+xMTnMU45+nBirExGkS50syRcUwQQ70rH5QNgZzcGTDQongOQvVUsOkemzaQ2+fwjbkSgJtH8ANqq6jGvjF9ci70v6I31QPvt+QmwMBw0Fz7EW4fuBeU7Y5+bu0lbk9myiYTiEj1QS0YcU+EW6hUpIrspR1lyygPGeRixAdnURHZFDprs3wuDyI8onTRRD5kN0H2IngoV32rvIehyPRFw+onCucLZCNw0yyONEHocRVuxKLujLrSOD4Y11Pba7s2qgTEHtAgsgx/yOK1enQTFCeVpzfheWTL46CRr5wGss8crK/JdVSxqUQgwHtRQA5jfu/+RXgq4CEe4XZMs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199018)(33656002)(54906003)(186003)(83380400001)(82960400001)(110136005)(55016003)(66556008)(5660300002)(26005)(7696005)(71200400001)(6506007)(66476007)(2906002)(86362001)(76116006)(8936002)(4326008)(41300700001)(7416002)(8676002)(52536014)(9686003)(66946007)(66446008)(64756008)(478600001)(38100700002)(38070700005)(316002)(122000001)(66899018)(13296009)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?d2lZ6YEEYqWhBJvRfzR+Bi9+VPLx4pJL2WvVo3gXvE9rCcKqcePxBe3XHZ92?=
 =?us-ascii?Q?7zc5gtiV1YmG6HB14qZ9u8VUQTYzibm1X0uSTlDj9PCb2n9ly5tqqNLx0m8G?=
 =?us-ascii?Q?25r5EGuoupm7dq8kr5YYL1/98xXZhFyri/mAKLjEIVlCvn0twKQLtXz8KfLv?=
 =?us-ascii?Q?zceNEmRbtNl3+5X9ZIfDoPWry4ox3nwSWNXIZFHWaEUz+t8tfGUskXkwofdM?=
 =?us-ascii?Q?02d6LoaNqccrvzqVj7jEaEXtHb7ifN0+y489c+jSfxOuvEhWt6RtS3/VANuy?=
 =?us-ascii?Q?HYO+J+HAs+CE4/OL2XshY3qkKZbvrwQz7LGmz4kPF0ljJ2G3DudDXjUC+Kz4?=
 =?us-ascii?Q?0FNjEC/ip2aUWVhWtfzRmLUEMDmTLRJ1E1jv0gNihlRSguZ1p9K+6W34ZTTW?=
 =?us-ascii?Q?9jJChq+eoAjNIhKerCCFN7ifkeh8XnkhijeUNfuVRkGK//aobbcTMEGygoMv?=
 =?us-ascii?Q?8M7iUCa92/US3ZMWc3QyvePXQ0kzna7XDkVMGpIykG0oYHR7KoMhkjsgxy1B?=
 =?us-ascii?Q?sz22Cg2ehuWrT6GMzvTSZ3ckXlkM8DKCCydkduT0bLymMTJR/FKInOdVrdxD?=
 =?us-ascii?Q?8jNuG5TRRIttUcug/y3BCl+/9x7yQeUhW84z450YUu8N7c/fUlNVhLGAnL0Z?=
 =?us-ascii?Q?CToMEbE45lGUcgTaHRI+8Degt0CBFg5JaaDse/kbj03sE3D1xJRZPneI38hM?=
 =?us-ascii?Q?U5KrgQe4S/bEbPDEt3HtLQm37e8B14FaAwppLtmQvWtLc554SWIieW6X8+hk?=
 =?us-ascii?Q?RFUYtzyRzMJcHKC/AhtHvc3ZoGF8X+4gOjnSfx9TQ1qQnRHptF5VMrKZCyLN?=
 =?us-ascii?Q?5LLkgQGfG8Q8+5xP60CBV1KYGxNhqfBwNfQiMJGD8XQd8jrJK1Vv4F9u2DA7?=
 =?us-ascii?Q?mTGfDHQNpNTmWzFbL1HYa8RcqRv6GNjtV5zu6D+iQKWuviUwKwoJkWrtnMnc?=
 =?us-ascii?Q?iLoxKCg1bIQVXEVa7+v6B25Al1BQe6gq3BMZxmKCfS1YGbrdKTQTK18ZnNvl?=
 =?us-ascii?Q?HP8pJG4ylO0BeJJDJ4VeWHBj0+hKPrtKpB+0tDyJRx5NIEcwf5Tp0ZRtD6g8?=
 =?us-ascii?Q?YIgTeHVOx46zvKYK/SIKrxIiiHlFjs2A5us2X9/Dwk29fok5YO1TeQn2lu3v?=
 =?us-ascii?Q?5Uj7qMyjdyERIlP8zDxYZQoolNc3IE8JCSWW7mrrmh8nHk84M9zBBz1Kbmi0?=
 =?us-ascii?Q?h99nSWIWPeGHM/tB/mcIFP7pOL0kqQgrcEt6cFwuNNB4ng0K0rZdKnKIYa/X?=
 =?us-ascii?Q?G2J72YbdCSbEsCJdFCbvW6sUyHY0eSrpEOw2g7zaKSrqUW5fDclohRbxXOwr?=
 =?us-ascii?Q?zgz/0QMX4hogYBpq1iROXNgJRq5e638ER3X0rx7nq8hRpgKQGldt277JcIwI?=
 =?us-ascii?Q?IL9OGQEq4B5fbOF9te1JIZuo97Ss/0OmA+teqGxaeQqTKKIjyEO2HRwfKgUr?=
 =?us-ascii?Q?064AYu3daN76+iaZlH/NHmGA19d3Xaa9k4pvGACdCj8tRTtQroq8c+jWRlRH?=
 =?us-ascii?Q?PY8f1AXTCX2bXidOAB5YkCizJ0rwv1G+3FTa0MxUD4MtfqN2QsMCKOhMebRQ?=
 =?us-ascii?Q?eOc2uSzooSF/9KVs4MtYBjKZKzjgYXR1YZGw+jcl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac8e5391-bda2-446f-dbaf-08db221ac6aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2023 10:24:20.0481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PKx7/3fxyWAD4Q6VPQnJWbZ6IRG0NW/Ymvi+UX1K0r8MAgwtTL/eAHGZwWBpCKb4iSNBWpzQimfuHC7iyUoo+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5898
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Keivn,

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, March 10, 2023 4:22 PM
>=20
> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Friday, March 10, 2023 4:08 PM
> >
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Wednesday, March 8, 2023 9:29 PM
> > >
> > > @@ -177,7 +177,7 @@ static int vfio_device_group_open(struct
> > > vfio_device_file *df)
> > >  	mutex_lock(&device->group->group_lock);
> > >  	if (!vfio_group_has_iommu(device->group)) {
> > >  		ret =3D -EINVAL;
> > > -		goto out_unlock;
> > > +		goto err_unlock;
> > >  	}
> >
> > My impression - out_xxx means go to do xxx while err_xxx means
> > go to do something for error xxx, though in many places the two
> > are mixed to both meaning 'do xxx'.
> >
> > either way I don't see a need of changing it.
>=20
> Ok. I'm fine with either way.
>=20
> > > -int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx
> > *ictx)
> > > +static int vfio_iommufd_device_probe_comapt_noiommu(struct
> > vfio_device
> > > *vdev,
> > > +						    struct iommufd_ctx *ictx)
> >
> > s/comapt/compat/
> >
> > btw it's clearer to move this check into vfio_device_group_open().
> >
> > if noiommu then pass NULL to vfio_device_open(), same as the cdev path.
>=20
> Right.
>=20
> > > +
> > > +int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx
> > *ictx)
> > > +{
> > >  	u32 device_id;
> > >  	int ret;
> > >
> > >  	lockdep_assert_held(&vdev->dev_set->lock);
> > >
> > >  	if (vfio_device_is_noiommu(vdev)) {
> > > -		if (!capable(CAP_SYS_RAWIO))
> > > -			return -EPERM;
> > > -
> > > -		/*
> > > -		 * Require no compat ioas to be assigned to proceed. The
> > > basic
> > > -		 * statement is that the user cannot have done something
> > > that
> > > -		 * implies they expected translation to exist
> > > -		 */
> > > -		if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
> > > -			return -EPERM;
> > > -		return 0;
> > > +		ret =3D vfio_iommufd_device_probe_comapt_noiommu(vdev,
> > > ictx);
> > > +		if (ret)
> > > +			return ret;
> > >  	}
> > >
> > >  	if (WARN_ON(!vdev->ops->bind_iommufd))
> > >  		return -ENODEV;
> > >
> > > -	ret =3D vdev->ops->bind_iommufd(vdev, ictx, &device_id);
> > > -	if (ret)
> > > -		return ret;
> > > +	/* The legacy path has no way to return the device id */
> > > +	return vdev->ops->bind_iommufd(vdev, ictx, &device_id);
> > > +}
> > >
> > > -	ret =3D iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
> > > -	if (ret)
> > > -		goto err_unbind;
> > > -	ret =3D vdev->ops->attach_ioas(vdev, &ioas_id);
> > > -	if (ret)
> > > -		goto err_unbind;
> >
> > after noiommu check and attach_ioas are moved out then this
> > entire function can be removed now. Just call the ops in
> > vfio_device_first_open().
>=20
> Yes. and also no vfio_iommufd_unbind().

Seems still necessary to have this wrapper. .bind_iommufd callback would
be NULL if CONFIG_IOMMUFD=3D=3Dn. If we call ops->bind_iommufd directly
in vfio_device_first_open() of vfio_main.c, it may trigger kernel panic
for NULL pointer dereference if there is wrong code that passes valid
iommufd pointer.. Ideally, if CONFIG_IOMMUFD=3D=3Dn, vfio_device_first_open
should not receive valid iommufd pointer hence won't call ops->bind_iommufd
at all. So it deserves a panic. However, if we have a wrapper for it, such =
code
may just fail with -EOPNOTSUPPT.

> >
> > > +int vfio_iommufd_attach_compat_ioas(struct vfio_device *vdev,
> > > +				    struct iommufd_ctx *ictx)
> > > +{
> > > +	u32 ioas_id;
> > > +	int ret;
> > > +
> > > +	lockdep_assert_held(&vdev->dev_set->lock);
> > >
> > >  	/*
> > > -	 * The legacy path has no way to return the device id or the select=
ed
> > > -	 * pt_id
> > > +	 * If the driver doesn't provide this op then it means the device d=
oes
> > > +	 * not do DMA at all. So nothing to do.
> > >  	 */
> > > -	return 0;
> > > +	if (WARN_ON(!vdev->ops->bind_iommufd))
> > > +		return -ENODEV;
> > >
> > > -err_unbind:
> > > -	if (vdev->ops->unbind_iommufd)
> > > -		vdev->ops->unbind_iommufd(vdev);
> > > -	return ret;
> > > +	if (vfio_device_is_noiommu(vdev)) {
> > > +		if
> > > (WARN_ON(vfio_iommufd_device_probe_comapt_noiommu(vdev,
> ictx)))
> > > +			return -EINVAL;
> > > +		return 0;
> > > +	}
> >
> > no need. let's directly call following from vfio_device_group_open().
> > In that case no need to do noiommu check twice in one function.
>=20
> Ok. maybe still have vfio_iommufd_attach_compat_ioas() but
> only call it if it's not noiommu mode. vfio_device_group_open()
> can call probe_noiommu() first and has a bool to mark noiommu.
> Jason had a remark that it's better to keep the
> iommufd_vfio_compat_ioas_get_id() in iommufd.c

Same with .bind_iommufd(). If we move the compat ioas attach
code to group.c, it may encounter kernel panic if there is wrong
code that passes valid iommufd pointer.

> >
> > > +
> > > +	ret =3D iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	/* The legacy path has no way to return the selected pt_id */
> > > +	return vdev->ops->attach_ioas(vdev, &ioas_id);
> > >  }
> > >

Regards,
Yi Liu
