Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8246A5181
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 03:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjB1C5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 21:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjB1C5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 21:57:48 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39D52200C;
        Mon, 27 Feb 2023 18:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677553067; x=1709089067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cgNaW5cusvzupPRtI9IsfDNnb4sE6VxHY3uZq4sM8Lo=;
  b=dmrjGWqzpRYKxdQskFnKu0F5XoAZhIgNo/OEF7FUP0ZjnwVLhwTokNqF
   uwIJUDFY7GXg+2MQmxDldkig7aYqn0mHQYScgEBOBIlVLmQBdfP7X8kCd
   qyUaOcuHC+F2dpYzO93tWNndDqUVM+SYXawO5Svcx+Cb+PiLXUQ7K3Vyz
   N8FTvbQ90VixfrKLsmAldRZshWanSarOAifxLVEH6PwWBJbSNHAOHZw1O
   PK8y1IGjaiJpewT6UcYZdfyxhHuOPe+6G1ghGLbQl5Z4cI4edjqrRxEDy
   t2+yFOx2+nAu+wftqP3dacXibA+wH2W17zHNxVlvhG5laHEB+rxG3GP+T
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="322280275"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="322280275"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 18:57:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="673967377"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="673967377"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 27 Feb 2023 18:57:45 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 18:57:45 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 18:57:45 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 18:57:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nREh5J39F4WBuBI5nE4VqatJtuxd+a0OrvQ4rAJgkfYDcFid2rKRX0WuO5f7AlyHgmoGPrMuqeoGg1phUcVYQiA1RFkT8yUjJxd7ReMAO7qLNZcV/L38g+K/fqwv+tWo2vCQDjfWvti150HsTm034Pl51Lt6l1bJXIz2GqQo02u6PcZECM+wtfUlFGAt+Sf28bXVGtuOs3NF2FTkZfV0AM7bkf4wxyoA8395r51Uh6vh16ctR5JbENDYQ6LtX+n74oCvw4hPE19+zlA9XF3iQRJ83j6ofyatZweIYTrI4q+T43GcJWicwXW0Ic0el3CQpAkXEYnoq6wBSS/8ivHqMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8hOo4cTa25jlsmRBytfD9tVxz61w/cvON84XOxa/RA=;
 b=eHKcgQebHbyerS/GKb35VnSoxvr4ZitIAWb+vc402eWoVB0n25pE52hHCaduPS7fMprkJGOyI4BzIOqbu1wbzrhlPFPhBkEAiVcgfuLW9PBz2YeLJ9csN+UcLdfZrmwujC6E5TrBBp7zvM5UuWHVnYpsAf4a6xQLGHO/+iWv66FVfPQr4o55fU1XarRCTxRuHfQ4xZezoKhPjvKtwutDZbOm9t3h7etDe6vTo+9K7/UZzVnUB8DYBMZVujj0+bEQ/RaIScKSlpLsCdnYl7bdpZ9uRqFSqeC4bfHmsJHO6+BdA7QAn57UnMSymFW9ktdzF/VhoaJyb0cuOJ76P/bnNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BN9PR11MB5401.namprd11.prod.outlook.com (2603:10b6:408:11a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Tue, 28 Feb
 2023 02:57:43 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 02:57:42 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [PATCH v5 11/19] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Topic: [PATCH v5 11/19] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Index: AQHZSpxLjytyosfJo0anYKoP/iDXH67jIeSAgACICkA=
Date:   Tue, 28 Feb 2023 02:57:42 +0000
Message-ID: <DS0PR11MB7529DC05F80083E426CC6443C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-12-yi.l.liu@intel.com> <Y/z6GwZPfh2nFjpn@nvidia.com>
In-Reply-To: <Y/z6GwZPfh2nFjpn@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BN9PR11MB5401:EE_
x-ms-office365-filtering-correlation-id: a58dbf4a-e46e-4fe2-3647-08db19378fa6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3cfgmoXkRjiRwfwHVXs8ADmHF+ptL7ChW+jzMTptYSzdS2WixQjDdwdu44MufKQxRRl4RhTYnx2xX5POqswISZfbQb2mG+6kUyjWonuTqtO6RhA7ZwFuiHIKV2C/xXbMaZNsYozorifYyNriesy8/rCM8BQMQ2oHMbD4/MYeNAURUhMEMQ9FxZGsUMPs81Xhx/lhTgy/T6eFF90ubuoJ0CkMFVnmmmmXpiHHNjq2dXhwxYmWyr9HW+hdDqsr9bSTLpV+Mo92eFNnMb4yG+qtFFtAqHvzQfJt+IlELnE8IarQQ7iQq1ewzTK/qS4QmSkJJwJoAPLMyPAGwVYOd9EPIxQzc2xcRC5kZEytI0+Qtmp/yy/OpfsCmq6uEwUyD9Wn2lSDFHH68JZq24ZiV0F5Ta9itbJA5hBxrdci7WnPF0npuqm1WiXulsP67auc8l6oggvagZr6ODJ9LgmMeiJeBbDNYoLe3b14uvpqe69P0SMvFs7xL3dfkN/2l9XCYLDA4HgUhj1gRRRLMAuy8bd2TiqxzxQmeiTfOL2SRxZuMqZ+FdV9WHB0zh4u0JpCqq8G+zsHKkyIwnUIjs6P29l+145DRM8jbUYKXdbyaenvwZcNvwySD+c5uBA6HpHUndUN6ET7/5rcBWIlrJevuA1E4EA4feb1JsViC6W8yFKRdgALq6VB/fTguC9roUa6egv1IscgAg8c20pKMDwYKn9M+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(346002)(396003)(136003)(39860400002)(451199018)(33656002)(5660300002)(7416002)(8936002)(86362001)(55016003)(52536014)(38070700005)(83380400001)(478600001)(7696005)(9686003)(186003)(66476007)(6506007)(26005)(66556008)(76116006)(71200400001)(66946007)(6916009)(4326008)(54906003)(38100700002)(64756008)(66446008)(8676002)(41300700001)(122000001)(82960400001)(316002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?alY3uImt/ZyHysZxm83i4Ic5TSKj06HeeBSi7176pM0wuDr5bxgBoV3Pbtv8?=
 =?us-ascii?Q?fhEHChK9ry5QlPXYQ4yvyH/GJcwiRrUsNTFp5bRPCgFOOnLb1GGC/x+NY4T+?=
 =?us-ascii?Q?SPfBPIH68/T7lTl6Q4ST/W6WiTAx1/JJjdMgGil99peGdg5K14rc/t8UWMGj?=
 =?us-ascii?Q?Wj/eXfDglD1Wq7N6BM3c/KGC8W7hg788sthOu4cRJlOfXoOxQvR7u3y098H2?=
 =?us-ascii?Q?YmD/Z/8eUD/dqJoyJrBOWCHeOMmJO7/RHAMG6xbZLQhHJADdcjdeg+VAiewa?=
 =?us-ascii?Q?TNcnXTr31OI3oao62EQhpFRxkIKKCZs91PJm74MSmFW8DJM6Tidea510/DRY?=
 =?us-ascii?Q?ms0Fmsk9pQXpyLzIcMgBUrK7Ji1kOuCZ2HrhTUzKTtmBIMwih6GzBsExZPok?=
 =?us-ascii?Q?Q1E4goK2qihuoTaxGGq5L29oHfRk+mrKpr0D14vZw17Uo440zlQ2yNQpEHxC?=
 =?us-ascii?Q?n3fLdMM+YqjRZHC6P4Y66/+DsxVvK66wLKPzg6dbKhBCgTDV8KihNtINxj0A?=
 =?us-ascii?Q?0SiMXhy6c8gB0UcJjqezayfNfHH2pffT3zepJcUcnPNalj7oANebiuqcDBP2?=
 =?us-ascii?Q?9KKbdjl9+DRbNhXIydnZ5i8DpS6JvSmbNBCvVxfsjQzAIM62BEyt4SqvfcTA?=
 =?us-ascii?Q?yfjFFFHumtKtF/buSSoLdvYKQSBMiXfsjmvnvef44byWDDfWdBRO+96h20IH?=
 =?us-ascii?Q?5GOh30PMt/jf6ngCN4qPcILrFznFTc09buUtbgd1FRPgZcaLBA8PQ4cp54OS?=
 =?us-ascii?Q?c8EP2FpUxOjUda+99W5yKUQkoTEL1LR1sjZy4qkWbkByiRFMqTx1rn35k267?=
 =?us-ascii?Q?Xz9VluARo2eyFH459DB8we7sqNJgsdtbJzpzfJMxJciQHEJJgLgvN9KVbVo5?=
 =?us-ascii?Q?HJPPxd4moqwyUYD8p0fy/AgogXgxAHkGdwr0/iLzorQDc0tr7jlYgtV9xpE0?=
 =?us-ascii?Q?01oIsiXvuFI//tVpLI39wRMUhekR1Ms9mpFs3kkpxX7r9O/jYJGnTBYcX/cX?=
 =?us-ascii?Q?IYgBKT3UJMeWQAYCKM4bOzWfZc+opT/TSGa64ENdmIUJZYwW0ahY1pqQU81q?=
 =?us-ascii?Q?Rf+1H8ioYp+XbSJkICVNMEftIW/e86ZOJtGUOTHIMN8aEzwxr3hICMFbet+E?=
 =?us-ascii?Q?cP2l8RcmQeEEdCm43Df2HNFZFJ7PtnPawccrd9Sl+vkA68W/tnRNFOqO7nNm?=
 =?us-ascii?Q?yUMM9cERRnhLwZk/oxVqekTfhbD/alyDNECIZGdiKpZn0YSiltseVwEA2QAW?=
 =?us-ascii?Q?GhVcFnorxYG+ImDlDnQSKTYoJ6ES9ffYIDeUSPNuMZewzPBtXYaq0wa6N3mm?=
 =?us-ascii?Q?dy5OkAf5q9TQWcDYNIM8YDze7WbW+dKzVZ0OEEgjt5E1duelBYTkIw9ObnuB?=
 =?us-ascii?Q?9g5316ZB68n000NWpusPrlE4wp22l0bDm3yts7KOUVz+PqN1y+g1JGIHcyAW?=
 =?us-ascii?Q?Sw3psvle8qZV4FEJYqAsfZdRDtx9w2QjyYj8j25F4ZAQuK4V8g+zXSs55V3S?=
 =?us-ascii?Q?/UUAu5pBIWIeMn3xljB2FooFDK3/EjCRLDXK781hzJ5wl9qM1bUij9wR2+1p?=
 =?us-ascii?Q?SpO3yUTRjMFIE1B9Yc4NONgcczfcTRan0ueAxmAm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a58dbf4a-e46e-4fe2-3647-08db19378fa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 02:57:42.6674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fP6NKv/1zm8J/1I/PA+N1i2YUk9WGFKvmHtTtjtlk8axVAbu58MsiS3AMXLsjNStNW5zB+v1PNxETZKHoi0hZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5401
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 2:45 AM
>=20
> On Mon, Feb 27, 2023 at 03:11:27AM -0800, Yi Liu wrote:
> > diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-
> mc/vfio_fsl_mc.c
> > index c89a047a4cd8..d540cf683d93 100644
> > --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> > +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> > @@ -594,6 +594,7 @@ static const struct vfio_device_ops
> vfio_fsl_mc_ops =3D {
> >  	.bind_iommufd	=3D vfio_iommufd_physical_bind,
> >  	.unbind_iommufd	=3D vfio_iommufd_physical_unbind,
> >  	.attach_ioas	=3D vfio_iommufd_physical_attach_ioas,
> > +	.detach_ioas	=3D vfio_iommufd_physical_detach_ioas,
> >  };
> >
> >  static struct fsl_mc_driver vfio_fsl_mc_driver =3D {
> > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > index beef6ca21107..bfaa9876499b 100644
> > --- a/drivers/vfio/iommufd.c
> > +++ b/drivers/vfio/iommufd.c
> > @@ -88,6 +88,14 @@ int vfio_iommufd_physical_attach_ioas(struct
> vfio_device *vdev, u32 *pt_id)
> >  {
> >  	int rc;
> >
> > +	lockdep_assert_held(&vdev->dev_set->lock);
> > +
> > +	if (!vdev->iommufd_device)
> > +		return -EINVAL;
>=20
> This should be a WARN_ON. The vdev->iommufd_ctx should be NULL if it
> hasn't been bound, and it can't be bound unless the
> iommufd_device/attach was created.

sure. But it is a user-triggerable warn. If userspace triggers it on
purpose, will it be a bad thing for kernel? Maybe use dev_warn_ratelimited(=
)?

> > @@ -96,6 +104,18 @@ int vfio_iommufd_physical_attach_ioas(struct
> vfio_device *vdev, u32 *pt_id)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_iommufd_physical_attach_ioas);
> >
> > +void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev)
> > +{
> > +	lockdep_assert_held(&vdev->dev_set->lock);
> > +
> > +	if (!vdev->iommufd_device || !vdev->iommufd_attached)
> > +		return;
>=20
> Same

Sure. Will apply same warn when above comment is aligned.

Regards,
Yi Liu

