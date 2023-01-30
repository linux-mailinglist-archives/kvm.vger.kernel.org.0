Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8680E680B3B
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 11:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbjA3Ks2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 05:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235747AbjA3Ks1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 05:48:27 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F7D2B0B5
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 02:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675075706; x=1706611706;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M/l3Iwjooq+B2o+VZTHDL2BFXGTtdAly8Ba69MoD7Tc=;
  b=h4IPIDwwU0xqLIPyy3VxzsDT1/88xMMyUNjbGlUWJ33vpb/OglvwWdBq
   ko7Kx2RvdVduafi766yS2+vkBgxtr1KyYlPM4ekPZ1gkaOLTdG0k0UoHF
   4gZtVCygc/7cad1kPev2zfv3p024vCLiojqXgq8rM8Fg+apPY2kPINkrf
   dcgS1uHlE8IlWWuAoK9LYeAjMnM5aRWqiIdrHw41eotEiPOhLuXlRCU5r
   wDrCgW/Fn+T/Ojk8v1HtLhCLs/yKFRoaWZWHUw8/4Npt4sR3k0pZq8m6B
   NnZD2HVWI4F7XUzkhs6M2qhiYALRaDLQT0u6CSklehuswWZ1G6iChtkpF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="307872996"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="307872996"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 02:48:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="837930199"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="837930199"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 30 Jan 2023 02:48:25 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 02:48:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 02:48:25 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 02:48:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gsXa3HCwSVb6ZnQqbeYtDwbQNOqPLfc7FcP37gEni1vZo4nRkoKF+uOwcuE+G1/q8/+cFkD6yz6f4cSrXFN5HxojxUpZNOuUivQ44pVwZe1dqxSh938VD+H1sn+4rcZVgH1slkq9ocKp/J7ZVTveaMN4s7/eoqPiFUZNW68FN3tp64Rd6TQIKJLivg2N0QazV03n/0vl8IFSeZBIydQFRjUFWBmy/GQJAq+iQe8x8XH3DbljPMOljkrlcpDfaAn6c6P01OyfgU8xoHk5pDD96CRX9ge8Ce2Cu+p64m71WNLDtj5nYhk8ZkUzi1On1g+ecQb4QpetMN+fM9XiqIa4Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OD1GmjFEiJi2pge9a0mX1Xi67LaGhcNu+QNXqjizNGE=;
 b=ELY9NNcWjUzZ0bMJQYiYCdLgPcvirpqHSwPABBKm/dzt08IQxgLtr4zgcX7M/dpr1ljNQUuF8IloFwoVW9tReVH4DqjtYtYsTwncgH3jaA1ztqKPb59HAVMskKXJ7gFfWN4Vnrgrh5HjtUPdm21frZdcVzZ3pdt0KbQk+3B2zmywkdcZIfdVXAXtWLft616mqv+BZidusLeQ4icW96Zwmu+fHJirZl6yU6jJzhG9ijXHinSptg3ae9hFnfv1YB36Ktqr5QlWTnEQEoYVVGTVpdO1QBnqoinRLD/LAnNurUFDcskIld5Uke0MJvC4aHR48GtJIz+vg+B3we44S9Kt8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB7037.namprd11.prod.outlook.com (2603:10b6:806:2ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 10:48:23 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 10:48:23 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 08/13] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH 08/13] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZKnqYE1wy2qbufkqZv2YFZFXODK6mOYQAgBCgedA=
Date:   Mon, 30 Jan 2023 10:48:22 +0000
Message-ID: <DS0PR11MB7529CDE496E9455B9D9495A1C3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
        <20230117134942.101112-9-yi.l.liu@intel.com>
 <20230119134726.5e381c10.alex.williamson@redhat.com>
In-Reply-To: <20230119134726.5e381c10.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB7037:EE_
x-ms-office365-filtering-correlation-id: 0137960a-c125-486e-cd40-08db02af8203
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IisvmUavt9esjTlWv1oBvOfrdfSf+7wBNVClGey2M5+FNEQ20HeWqCjoe3H2vzxufXAzr5+XWamdM+rOKGAL9yNPRpgiLQPpKopfM5fNh1koDquYFdOdWjF/ut0PoqSvRJIfYm/yJBO9HiMjgU2EU8k+y0chVC/M6eNInjms9hrx/D5eSGqoDfAjiOPNqjRkToX9LQ9oVUeI6TnuLgxq3BGdgSa+FX6OGKTTI+MccrbWDV/Ep/Y5Eeb+dIuVD82TMyqPeTijogj9iwnXEZ/h9YqjxvOndWZdKa0fPma0enT67hguvEUgvKqxZ+s/SmRQ8LMlWUwws1zhLbC9qC208Q0PMzQREHfH/2W5nbl6+jsYkqLNshwWhmhX2P3sXnNvzbxlzUELoibbeKCichcDTy92ftJYGWwOBvCCPuOzmA1JJA7OknceYnUNWN2+nqNFtrf1c5yudEqsSsulsdLqp7byRqIH2ONvvRoT0w0Avq1Psg8c9FL6+yp8tNUdm7iGpxSq5Wvz+t0z6B9mFlgkZ90MjHHctC50U6eod/7fdMBJ2ptrDFOL7Iuh8RJjDhdLRldxdtllgptJe/f5f5Q2eD2rFovm1bI2EeqnSsrqaCeIrVgTwjXIO1xOjP6KEhm0qtQfkYKev0U0LhGNig7XpRlAF7Jg2yGsWHHKe1SVoMNOOLwufeaUyJSchSYgHqF0bf4lO74+S1/8EkHJCzLJx5kyRJFBdRXHLn6gob76dy4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199018)(186003)(6506007)(478600001)(26005)(9686003)(8676002)(7696005)(66446008)(76116006)(4326008)(6916009)(64756008)(66476007)(66556008)(82960400001)(66946007)(122000001)(83380400001)(41300700001)(8936002)(52536014)(86362001)(38100700002)(71200400001)(33656002)(2906002)(5660300002)(316002)(54906003)(38070700005)(7416002)(55016003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CxXKRAKSebFvjt+Eig0HVNRG01twPTbE+H/MhQo1HsSLPEemKqgW45iWj6Zx?=
 =?us-ascii?Q?6SR6fl4Gb72tK8Eypr4W8hPVQ+yzeaWHpIsnF08PCp2vQxSozP2oQl6ZeiD8?=
 =?us-ascii?Q?W8YMnD0Ll9jT5NSH+6WtnpODDHGdNZn4u9+UiKc4DqYpoO5e1xemRv2+c2lM?=
 =?us-ascii?Q?E2RMA0KigXKtBioP2/XdwVmzCdQv7UG6eOm/z1Wh9H4ErjsiGg1/hjeTUbNR?=
 =?us-ascii?Q?mib/5NP7v/NvrTinj2FIjfmtBji5Aa74Wk1fIlltoR8vPc6TqQUtxKZ739dS?=
 =?us-ascii?Q?GsxkPIoPmWvzvJSLGMitqfdonjT+AvxOC66jrVnutqF7Gb3FCmZjuOP1lKWa?=
 =?us-ascii?Q?s3dXtGHPwGJbm4w0ag7/ltGCFuZloRXVqUXB4Ol8EiVoe2RjUo3c3ZNJcX13?=
 =?us-ascii?Q?SHbp5vbNi82K0syHL3pYko+aIB2OC+bxEZQfZ6bJH+kpGMZUz0Vz/ATFBHf4?=
 =?us-ascii?Q?WVgP8zm3+RHr6YLlcbXJQtPHweqcqujH5mEz2c/G0tURbClAQet1cMEMATe0?=
 =?us-ascii?Q?AvgrEe3yUnVvzO8pHxPUXKp+1fIoMHhAYXKAe/idZ3yIH81J1e6LsidqFirQ?=
 =?us-ascii?Q?ZyLhXoZDEVf4D6amAWWxKLDFPwLLee9xOvYssp9Xs1cy9e38VjNFY6TUWML4?=
 =?us-ascii?Q?S9f7xFnuVzJ/ijc9mRNTtHLDbJuauoiWhv9O579LvbE/Ss9kYt5w7nl93Yll?=
 =?us-ascii?Q?BTRPLXZxpI5IZ7sn7Os0M61zZMtOxDNCEsizcqlbVo/nrYjzHdJxhxFk6U8j?=
 =?us-ascii?Q?Fr6JJ7D7f4ekqPD4grxgO0P6jN+Bf5x5IATtxS2iz1ifznVqVVyf32ARKYT+?=
 =?us-ascii?Q?n8mYSWUpUMF6PIask67vnfo/iTj1iEiCZNeOV3aAMr58pGZEGEv4yat/aN1K?=
 =?us-ascii?Q?krCLKFVaxGdIfb4HTBgVe9twDsV8vYkV3oc/CeyjRUO+zT0cKmbIgM2/qwgK?=
 =?us-ascii?Q?iKSdBoKpEoVFq0V8lQy4ycyXFS/tCWEBlpq5E8gYl1kPmXHpmUzhr3daUzM3?=
 =?us-ascii?Q?xUC80rsvqYBJ2eD5T+mkzX4acwfSJ+TTEuHKAdARM8B9zK4j73iovq8Y4GFc?=
 =?us-ascii?Q?BcmjTrcEafk08VmD/PYKv+1iobTlCx5Ls2ac62wNyAIjPyGrOmG0xOPVVYFp?=
 =?us-ascii?Q?ccGO6BQz9gZZhQ6BxABQrSOXKvIBKGHwqY9MN41eGKG2EmzZ9+N3pvFXLjPT?=
 =?us-ascii?Q?lWBYV+RMw0/7GFEnYjLQM86IVcPU0olrC7l5xElCxm6LyA0KRICVpj3mtCn5?=
 =?us-ascii?Q?84bo2MI9FRKtzcqYYhAeafKyjKyy546d2CFZ5gv3ZFF7Nh+/NhpczIFJ3zPk?=
 =?us-ascii?Q?4O6jQLUvFLBRGKA12e9ydp567/+kueQOwRPwsCZGmPON0S+b7thrEijU8RpS?=
 =?us-ascii?Q?ruE6zhH2ZCJzyarvna3pQCZmySoje9wrzdqsZs6bOQwkgsYDxLvh7axLv/lD?=
 =?us-ascii?Q?UVnzaiKWA//dj/P4eBuEqYh5FcGX1w4TX6iNEA2nva8Em4kJJUj/22S458kh?=
 =?us-ascii?Q?h0E2FRq4qebsCqufTSGeoSJB9+oo080P29lMPQaTz+sLcGne4gChd0ZYm7H2?=
 =?us-ascii?Q?azruO5CbTqsgWr0rLnO29aRGadjcVivfDudmZMjM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0137960a-c125-486e-cd40-08db02af8203
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 10:48:22.6584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uByDpoFWHquEEnZbVDw7IlYwxm+CD9J2OhAZw6+SjHohgTIf9d+D4mrVDwL7TjsWxSTFRNLRbqJSXTggWus+7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7037
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, January 20, 2023 4:47 AM
>=20
> On Tue, 17 Jan 2023 05:49:37 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > Allow the vfio_device file to be in a state where the device FD is
> > opened but the device cannot be used by userspace (i.e.
> its .open_device()
> > hasn't been called). This inbetween state is not used when the device
> > FD is spawned from the group FD, however when we create the device FD
> > directly by opening a cdev it will be opened in the blocked state.
> >
> > In the blocked state, currently only the bind operation is allowed,
> > other device accesses are not allowed. Completing bind will allow user
> > to further access the device.
> >
> > This is implemented by adding a flag in struct vfio_device_file to mark
> > the blocked state and using a simple smp_load_acquire() to obtain the
> > flag value and serialize all the device setup with the thread accessing
> > this device.
> >
> > Due to this scheme it is not possible to unbind the FD, once it is boun=
d,
> > it remains bound until the FD is closed.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio.h      |  1 +
> >  drivers/vfio/vfio_main.c | 29 +++++++++++++++++++++++++++++
> >  2 files changed, 30 insertions(+)
> >
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 3d8ba165146c..c69a9902ea84 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -20,6 +20,7 @@ struct vfio_device_file {
> >  	struct vfio_device *device;
> >  	struct kvm *kvm;
> >  	struct iommufd_ctx *iommufd;
> > +	bool access_granted;
> >  };
> >
> >  void vfio_device_put_registration(struct vfio_device *device);
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index 3df71bd9cd1e..d442ebaa4b21 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -430,6 +430,11 @@ int vfio_device_open(struct vfio_device_file *df)
> >  		}
> >  	}
> >
> > +	/*
> > +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> > +	 * read/write/mmap
> > +	 */
> > +	smp_store_release(&df->access_granted, true);
>=20
> Why is this happening outside of the first-open branch?  Thanks,

The reason is the group path allows multiple device fds. But only
the first device fd open instance will trigger the first-open branch. But
all the device fd open instances need to set the access_granted
flag. Surely for the cdev path, this can be moved to the first-open
branch as cdev path only allows one device fd open.

Regards,
Yi Liu
