Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478836B6D2F
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 02:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCMBtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 21:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjCMBtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 21:49:45 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9463F149B9;
        Sun, 12 Mar 2023 18:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678672183; x=1710208183;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dWN07o7QLiyTEekmu4iqiMVHY/c8oT60w0Ne109L1Y0=;
  b=a6rTcYx3cpvhyXt2ZOT5c1aDZyDdOy0O6bE/oyzuxGV38H+KSC226SIW
   /eJ0y4ErjUvQ5CaHWM3b9SR6xfByA+GnqyVxbkFfTlRfjaabAI3ZN/0GY
   o7g+pCx3mpSU6pypXZYLW/6lB+Sx2ULkym8g6Sr8qhAgoJKiyWgBeAx6A
   oDvhLBOpiO3xjR3XKFq30+D7inIFBjvpbHGUaRWjKGF2vR0SF0lvebqRz
   Y5RrvIIulhlsrXHfkQNUtOQlRpTpZWFb/jU95s2vYwwtKzNU0YsAmIQKl
   D7tT/GCIk+lXMNlvuxGUA8N5MK4lBgUmANKXLrOJwboxMHuD+0Mu2Exq+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="320892929"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="320892929"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 18:49:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="767529789"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="767529789"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Mar 2023 18:49:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 18:49:41 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 18:49:41 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 12 Mar 2023 18:49:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlDCWA6dYOXI0XPjGEl4dqiHGfKwcilE6KvqlFeZD4NhltVbixulBX5V/WAQb6xChxh6D0xO0FCZpabB3soCfI8PdvTIEPdvBzyh9SX+d8VvHEbi69cK+QlF9Yrf1DBuR9OciiQqMORuca4DvVwYSCHXH8/6Px//rMF+iKZB83pLojzF3MHbPuu0qut5e08skO3C+K4yqie/qeHmhIxFA9yI+tLNqy0HiVwUruWSNmFK44THzQr3A0DBBGzyXK3Ykk7q/vipHHZ87HA+Lyiqh/ducAtnGx/rUW9xCEPZuOt/fY3PS/Vv7EuiulbKKJ0J/898pPEAjXz8GLnGMHBzIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=geHA11xPfOZK9XoNmWfaFLsNGgqND5x3JppzMeWSgc0=;
 b=dUDrPT9ixB/DqmQ/pFIdZEmOtS2ylCKRHF/DHn1a8eKt/u1F39+d6z/xYF9l4Oz3CeqE5OQF4fdTRyNUf1VEp5ErorSNxyho1fgSOE88HkSU+fLHNJbTb9Cy3WvR3COVwXc7uleJaIrnJXBisxp20uGvpfGO7Df6ijGYwXTG3HNoOy7kNiU4SuVLJdh5QEbPtIE/16ZitwTTwpWq1oEEvf++Y7Lb3T9lYmr7nDLj9Q99RB4o1SKjYz7KfeWECJJz1DQ/iRrXld0VDUSPKH1/OvwXkqaTowmRgneTySYQNBXa9wInCqBNWJhduz5Xpyx4TN9vQsP9PavppEJZb7G1iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6124.namprd11.prod.outlook.com (2603:10b6:208:3ec::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Mon, 13 Mar
 2023 01:49:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 01:49:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v1 5/5] vfio: Check the presence for iommufd callbacks in
 __vfio_register_dev()
Thread-Topic: [PATCH v1 5/5] vfio: Check the presence for iommufd callbacks in
 __vfio_register_dev()
Thread-Index: AQHZUb/ZJ6hrFx1b1EiVQiMXNtKcfq7zR4xAgADHT4CAA+ml0A==
Date:   Mon, 13 Mar 2023 01:49:39 +0000
Message-ID: <BN9PR11MB5276D91FC606ED84D9686CB78CB99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-6-yi.l.liu@intel.com>
 <BN9PR11MB5276BA4E1FF1345433FB8D338CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZAs419G/RNoEgPxq@nvidia.com>
In-Reply-To: <ZAs419G/RNoEgPxq@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6124:EE_
x-ms-office365-filtering-correlation-id: 569a8fca-6def-4d07-1687-08db2365351b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pZbY7rte7sOMt1llHuBBn2loDIAjKeeCR1J8vNVH+Cmw9knuE/O1bqJK9ZBNT3sM3BHaB7JQLPSpNSvV58cipbxghdvQZOfsO2aBNuvUUplDGVpU0LocuA5DR01Cpi4Pnl8i7BfqP9Q2T1g9rkWH3SF+psahKnrTz71lS/0qcB6yLnQmHrgeGqsyJGvKQFUtYQVnlyjGXstbwT2aU2n8BOUAl2su/h73PmsyaPDpews/k0dySdah5BA4IK/2+vcF06RQDlApzdvJQvOHsU3D9bl9FdNLP4sSExwJOxaeJtOrCx/gn/hccRUD7XJdRS8dBj1F32cjkoa+q52M6AOoydolnElldFLvH0MVZiuw9Ye/1SaIxzZKDMuDhWIH3dWncUxO4WYNjKcKpC+Q4/AFNDwoLIeE5XnxT1rpnhP8BC0SJD9dOLhWoyrWJe/nJ2GM8rvXKmrOr99UszF4Hrgm1J+b+FTC7teGpkxHYeadoKdVnsmoOHJLd3Om6xkMrlaBg3Bb2Hq3HiyTMTh4pg0/6+NzHVLnolJU09Z9IGk9jfAj/HkaxRGv5LZdvOzkp829sn3WzJKqvXEbB9VQ99nqojXp2jbGOqdITEJ0l5fs/z0qIZ4BZKDpPN10H/PsZ40COTs6ii9aSpOS0KfhGNpqJh5uCwTqx0Rp6CQNeZlgi++czWcnQF/x2Paer0ePSqmF5gp6CxgOrrNmvy/QR1VORQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(136003)(376002)(451199018)(7416002)(5660300002)(76116006)(55016003)(33656002)(83380400001)(66946007)(7696005)(186003)(26005)(8676002)(71200400001)(9686003)(478600001)(52536014)(4326008)(6916009)(66476007)(6506007)(66556008)(8936002)(64756008)(66446008)(38070700005)(86362001)(54906003)(41300700001)(38100700002)(82960400001)(2906002)(122000001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LJ95r9n9dU8mGcfV2XszSfUxjMzepnJrFjlW6DhA2OutvlCG4bLfVkEXBZcu?=
 =?us-ascii?Q?JTQ+ivivg9MQs880ghfJBfMHJZC1CD9TZ1maqa/DfdQ62XHoAbiw/IgNnCJO?=
 =?us-ascii?Q?t+qVjO5FbNTYWuMeh5+l0Br3ByHT/x9hJX+qaHFVQlaSDSlyuhe1ZHPiHpyz?=
 =?us-ascii?Q?fpbWJHFOsRmWExCPhR3giyYTs0xjpNZzX1mOJLtgRxRX4qObr2rwpBxMVSUb?=
 =?us-ascii?Q?lagq/A06PFfAe7HgMaD9gXBmrGryp4G6ii1ztjRGhXyVqrg4x3iuK2pZckQw?=
 =?us-ascii?Q?zQXzh+ZVXmC+TqmJwUHa5kcXbOpnvMJWYpD0wpKESu7StbOX+4eS+rN/fMOb?=
 =?us-ascii?Q?Vh83CYyK123Y+TO2/Xoj2EnmJjb9NfVIxTnlFuBKuXkzs2cegjrsLFFWS0WZ?=
 =?us-ascii?Q?rpkBZVJl+Nr9Fr5IMKaPmtMGZ5jYcwA0l2TXuisw1U/N312KHq89fiZtU/zF?=
 =?us-ascii?Q?GBEn++5HaKC0GECXnT6Dj/5TfFsKWa+uzDtcoMXMSZ4AiSdUO/yPjqFj0bCd?=
 =?us-ascii?Q?bprkv44hpTxTMd98EdSE7WoiJsbYw1vwX3hGmnXQkTbfZ6ZyM0S3j/RKXFWK?=
 =?us-ascii?Q?nWf/Y938D3aFyrPBrO9mh8jl0f8wXxAYAjmrNkmJIVHNNdRbis9sqfEX9+uJ?=
 =?us-ascii?Q?8MPDMejQeSjA+eT1pDcNjSXLhaPUZ0wxYJesJZXbRga7lDnzK6QMDBtW6m/6?=
 =?us-ascii?Q?vkyS+vDy2gdN4EYCjZnchc08i36jEEK58S8EI9f3I3OKPnlYU96iL0rKUFSm?=
 =?us-ascii?Q?fiBMURd8ttZZ2+QWH4xjtxIVfxN9DdSaL8kE1+f1FJThnDo3+BcKX5a93ll5?=
 =?us-ascii?Q?sQ/UjAVVo5yKi949Ukr4d2/06+x0iFHW9lW8J7m4QHkKEDDrZojDTqOk0JaS?=
 =?us-ascii?Q?TQk1Px5G0GMT9YQB9ua8tvnGcE+unq8zdRl17/YGWAyqa5dPUHq7HPsrclm+?=
 =?us-ascii?Q?KOlvyFOFlKpre51MU36UUXCwjTWcbbAMHZLxWlRxWMPMxxEbAGKY7lAOln+H?=
 =?us-ascii?Q?oHyUvY11JjEtMFtuYKhC7T7L7PTsx0Yqt7L6LS1fvOwEzGVDYwcUHbMQyjEy?=
 =?us-ascii?Q?9kbukNnx0THfP/R+7NE+mOSDsoXX6v++WFPMivT+mTlgPTyVhvlIiUQGB5Uv?=
 =?us-ascii?Q?bNAtjO3ZRjRi4J0IIi/B9342qhC+Ghiw1lDmgO9jBOmpwoUdfTa2X2xa2lTk?=
 =?us-ascii?Q?JEDueUptd48+ib4YpNIDjeO8n4qNKoktpnOo01B58JYtBLYSsri2U0ymyvDM?=
 =?us-ascii?Q?/DD/zQIUfr3TI4HdhTYd3LVJbNIAl3jcf5CDa69AeMyHk1uxTrq7W+dp8/+C?=
 =?us-ascii?Q?i4LXalnu5l6FXQJnI+BL02H8J0G/bOezUW+hfr9df9zeeyxLzp38gKYem0vR?=
 =?us-ascii?Q?APx3wTo3GJMHW8X45eWcdgPJ8J6e8TiXaYv8TXuGvMxG21yqF6rqEL2d8VOf?=
 =?us-ascii?Q?VOQ6r6Vdv+YquKoG+1cq2FcEBujMjHbLW4w/IXsHTOGARrtq5AhRVbscZUMj?=
 =?us-ascii?Q?qGml+8Fxpq/gopKMSWPosy4GcGm5ep0BjNMwus+Eh6RfOH4P7x8pOxmc7CPR?=
 =?us-ascii?Q?r3GyXfl9Xx1JFF+AXyyFrHow6e7zEwkGevUECxzl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569a8fca-6def-4d07-1687-08db2365351b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 01:49:39.2069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TUj2EKYWtl3fGB+GGegEfFrOCpGKqNzy5BkVFFOol3chIx9iD3PNKZNWvY9PK7z3+ZVgaPH1M0Ae0iECQkZVgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6124
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, March 10, 2023 10:04 PM
>=20
> On Fri, Mar 10, 2023 at 02:15:32AM +0000, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Wednesday, March 8, 2023 9:14 PM
> > >
> > > After making the no-DMA drivers (samples/vfio-mdev) providing
> iommufd
> > > callbacks, __vfio_register_dev() should check the presence of the
> iommufd
> > > callbacks if CONFIG_IOMMUFD is enabled.
> > >
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/vfio_main.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > index 43bd6b76e2b6..89497c933490 100644
> > > --- a/drivers/vfio/vfio_main.c
> > > +++ b/drivers/vfio/vfio_main.c
> > > @@ -255,8 +255,9 @@ static int __vfio_register_dev(struct vfio_device
> > > *device,
> > >  {
> > >  	int ret;
> > >
> > > -	if (WARN_ON(device->ops->bind_iommufd &&
> > > -		    (!device->ops->unbind_iommufd ||
> > > +	if (WARN_ON(IS_ENABLED(CONFIG_IOMMUFD) &&
> > > +		    (!device->ops->bind_iommufd ||
> > > +		     !device->ops->unbind_iommufd ||
> > >  		     !device->ops->attach_ioas)))
> > >  		return -EINVAL;
> > >
> >
> > I don't think IS_ENABLED() check is necessary. those ops are
> > defined in the driver side w/o a conditional CONFIG_IOMMUFD.
> >
> > We should warn out lacking of those ops to the driver developer
> > as early as possible, instead of postponing it until someone
> > starts to build kernel with CONFIG_IOMMUFD.
>=20
> The ops are NULL if !CONFIG_IOMMUFD. The previous code was OK because
> it checked for non-null bind before demanding the others be non-null.
>=20

ah I didn't note they are NULL defined.
