Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDAA70D063
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 03:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjEWBU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 21:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjEWBU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 21:20:27 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5481C8E;
        Mon, 22 May 2023 18:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684804826; x=1716340826;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C9A08r9USte42gho+CPmKbxcBeiYEcwDNo0wAZ7OQfQ=;
  b=Pvag8eoaC9jY4kdnyfwK4I+BFUZzXF0UUp7i2Up+QJRA92Ix9ehp+lE2
   92SAZ981BEbODNsJh+A4SpHdBEG4vcAO+8k80Em5YyPFlsI072Y5objAt
   pqKb1OU4B3n90NOlDE9SulSheGxC0uHh9oqy+mcUHuU8gSpm6VFzkt4Ls
   DboUNu5j6aShrtKYgcJMiAK7cYdaatvD/yEcmT1HdFvaKhWXO0/vKO+NS
   eFtALQelioYBo5YEhEJSZ3rxt5zesFIURLGaXCs5dxmxiSyp/L8ROncIQ
   29jzWChNfdFV6Ys4sYs+5EAfcpoEkUuMDtZOhT/RwU51+jiIWDzbL4grH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="333455076"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="333455076"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 18:20:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="654161152"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="654161152"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 22 May 2023 18:20:25 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 18:20:25 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 18:20:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 18:20:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StRBUAhGRuCUCXzQ9gl7ZpNIIYAYcgyWAoop7UBdww5tWuPL8arHdpeND+fpL9UM7vkf8ZO2+MJyhLRGMDmTFbwTjmj4gvw/UGdv1QkRqdHq/h+qMIr6bjPkPelYZvScqV9xdMfhKsZdwy79KG0Iagh4V1s7UMo6iWBs1YHnTX7hQB3Owh44JnSdTyvOTKNguY6P0PQhLU+3y923CXPuWi+ltALQywEW82c65+wzxpZd4vkXcosUBCUC0sMeB2oWa4nigNikm5QWZDATDdxnzsgP3tqk2kfsQ8y9hj9wunr0S/eNXxDVW169pvFv50dWYykmsNJK5A5/VMY3vmIhrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUZZ16VJK4CY/0/vBqUEUfxN4rz/QV2isDTu22ZfgaM=;
 b=YFM7g+al57mU5TxdTWjT9c08uCsQSuvRUkZqnUp6ec+0uFDYi/XWDmnEpJ2i4uAZyHnbjARQgezKA7+SrSGL2WxFYtpZzRluRddlG9CzRfRgMefzxgjs5AD/CvS1etlAFjDQmqBAs1VNzrU+SaUGbAheK9SW4IsfKlsaan1Eg7ps9LiStAHVgDq6kFJb8KEWwvbMs2YlAKTNxUgHJSciNMJ9nDZ38iv5eFp2V4zJbiB7KfpgOjAA5UyVdWeNtWT5MRzs5Gct8rIawb8N8RWekkazh9YvCUPQMEuykZq9fUaX0kuiwRTwQ2kv3nS5U+TyEjuyfNQJ1pMDkyduj7SPBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB5921.namprd11.prod.outlook.com (2603:10b6:806:22a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 01:20:18 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 01:20:17 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v11 20/23] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v11 20/23] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Thread-Index: AQHZhZ7iKUbaAh4TKEGwflpEYDXvra9m6p0AgAAxWMA=
Date:   Tue, 23 May 2023 01:20:17 +0000
Message-ID: <DS0PR11MB7529096D1BE1D337BA50884BC3409@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-21-yi.l.liu@intel.com>
 <20230522161534.32f3bf8e.alex.williamson@redhat.com>
In-Reply-To: <20230522161534.32f3bf8e.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB5921:EE_
x-ms-office365-filtering-correlation-id: b7c243a4-e2eb-4415-a2df-08db5b2bde1e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zr2ixRd7reb8iv7WRr9GhZyAq3TTx834DKHQWBOa/7sM1OmrGHbAtztnb0NRBdGslvYnDWh0nIGqM0Zg5IgTOYka0rVtViI7owo6hPn1ZLfAGx+H6fY70YJiIPjF5qhTafYfubaanKlQse6DzVeqmChQlKpGcSbNDE7ZaMvTXCz89LSkS4Bb2iUaRR5YZrhj+aIUAPEvX9HcdnsP98zGpIaXh2K+iXu9qge6MzhpaZykPRhRi1MWMPzu/FA1y8vyw7dhAcf7c+brQq9iK5sBfkMmCStJuuYhzaUnqXSyq0NnW7Q4kDRLe2Dy/9OHwYR/ZD0BKZVDEdupSaSiz7olitnQRdSI0tBXrnzTHmZgGf4jBo/Dnqsrq5Yr8ji3dZJv84Dmpy3MJPP5QmHP1lR9QKdIazghudTbMklc+KGmFd3U5WxbQk0UAMZOKFiy1SiOgoLXFrHiA8heMkMw258/MFQfezqkYDfl50I5BtAdJJiY8FInpSm+KP7kTR7Kw3mYKdp2EXE8kqt8QBwOhQ4l/ZhH/k6zkm3DQmXGuO4Dtr0aIbNFb/F8IoukjE0+RNPIG6YEfY1ONbGhCKpI9JxB5GOqdbZx87h38hN3NJYKkpqPhCZm+IURKwjYZOLa2fdUnjkL8Gyc+yT+ibbZmxxr+ZR8XW/lEG1MbgovFJagG7k377agoenlvX+Bw8QUPLlE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(376002)(136003)(366004)(451199021)(2906002)(66899021)(7416002)(52536014)(5660300002)(38100700002)(82960400001)(122000001)(8676002)(8936002)(33656002)(6916009)(4326008)(41300700001)(316002)(66556008)(66946007)(66446008)(38070700005)(76116006)(64756008)(66476007)(54906003)(86362001)(83380400001)(186003)(71200400001)(478600001)(55016003)(9686003)(6506007)(7696005)(26005)(966005)(13296009)(83133001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YFi74MJG0AM1nvT+uo71csMu9PZqrDFSXkXjkCuYM9FXZZDFrIgelZdTk71a?=
 =?us-ascii?Q?qVkvkbXDjGa0I3ZM9NUeWwzH4IgXLYBtDcdP4kds3K48GAaZPvX/I+jLtMoT?=
 =?us-ascii?Q?R6N4XNKWPYyW6ivhmlCa/h985SZogSTeR4vC1UEKQ0YIG/O1dbMR193kCo/9?=
 =?us-ascii?Q?b2sKeBrm6a3ayXl/cjQZSdwYD7LmaDb/l9GXPPK2tmorV4kD4BW8cOuO0XtT?=
 =?us-ascii?Q?3+qajIeeyGQx77zhnY6Lbvp0IHqbCvDPJu4c+Q4jwTXLMeGj+XxKzoHQaSjg?=
 =?us-ascii?Q?gBGoXLai/+SPHTO9HlX9KkrP6onapdsBis1YJD8BWxi6TB5OI31VHs3Mw31L?=
 =?us-ascii?Q?nackBfXOrA5KAUaMI5W4kXT2VdZR/M0sel9NgXkrzClYcKAD9ILy1y9aTyX7?=
 =?us-ascii?Q?eT75xUyo81vrUvQcbbXaAk5KZy3TVYBf/CmHLVFUTVn2HAAZ7/tiDYuH2TJR?=
 =?us-ascii?Q?cxUM+xkb6+u2JAm9/UDXtr8+BnhcrmD7Ua0mTxph4bSM8YhElowcxlmaQEUJ?=
 =?us-ascii?Q?TsxgU8AyFUbNsioV3TJAoL/Xb2NO48P3klMkl7mDxT3pjY3AOJixRK0MfNPr?=
 =?us-ascii?Q?yW4TWhvRlA8sEkRt53JwR846bj/2CnKtSeJpiJzcQjjeqNvKAzULLIlgFQ3a?=
 =?us-ascii?Q?+0cybk6d49lXvy7I8eqWtfy95RGvvXPhs/48Tbgj/8Y/Xj7Z7o8ci0WX/Yay?=
 =?us-ascii?Q?KvqUNwR/4MSlIV3snZtBW+Hgt6mhPWoemysjaAeHC+DeLncBiiVNX21sNd9y?=
 =?us-ascii?Q?sP6W1F3MgWhCgAx7X+9qMcKy9zHnKXjVui5+dfB3RzVdITC4WYTomD6c8TR/?=
 =?us-ascii?Q?tqxnfhiAqjrOSeAuKoRYKQGzcDyA0x6fnBUtOUEfX3D1A3XNXje0h7ps3sDs?=
 =?us-ascii?Q?enWfmdjaX0wdReuDCitmW/ZQmMClPWICac19/m3stzHTNetzRSWBfVQfeUNL?=
 =?us-ascii?Q?UBZBHnJbQy0vxB1ERCgdMl1phfmEat/UnUMtNJAxE0vyI5yfw20keCV8Xuuo?=
 =?us-ascii?Q?ATsz1ook8FmPSddMnKJmfIF3RZOff0dRF+f7CuWEJQmwSVKZrf3JWFtRQr3J?=
 =?us-ascii?Q?d/Kye6d480j2l3n5SEY8/QfyGMviJrGBkfPXBUWugUG7HLQEbHCqdqPZSwI3?=
 =?us-ascii?Q?YRQ0EZ32Up+nJrHWQikmHuLO/4DarVlEeRl7ZSP2SgRsH5tHsZHuqvZtZJbL?=
 =?us-ascii?Q?2StMchHh6mMpFBpcXU1BT0fDphSnY7wWDJZt468/2K/QoxMVzPvLPbCvYjau?=
 =?us-ascii?Q?m7AvkUegx5fRkshKERLSk+lHtyAqURKJhWFdPBxKSEu0Lo1NQUKuyix8INOD?=
 =?us-ascii?Q?XZZqSVempLhWbR3INchKOlj1WTBf8nEME4McZfIf1+OevlFI3+7Ln5kDVcfg?=
 =?us-ascii?Q?BzGOU3OZW1v9E9flA8pz9E1GrHClQgTyGGZ3OH/t5E4QDurybjzpq5Xj0GBH?=
 =?us-ascii?Q?6OJhyLUp0kA3a1czPbWdawhcvJm8dP3fLzVllClsnE6j+mojirV3KE4eJQmm?=
 =?us-ascii?Q?j2Gbrirg+tNC7r6dkv41iaKbikWkEvab1t8RchkxTw+tuLBTM7ZSf2vb550a?=
 =?us-ascii?Q?NZGuYm0fRFsAzOdikv7t9u5KEeKQLXTmjvz1X5qe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c243a4-e2eb-4415-a2df-08db5b2bde1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 01:20:17.0801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3vVL+Aoyap5KYEIAYZ2vQXNLvoVbnIAd+P6qraglUa3+GTMEIdwEbX/f00DZkg7SZp2xOVHihv2QdlTqQQP6iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5921
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, May 23, 2023 6:16 AM
>=20
> On Sat, 13 May 2023 06:28:24 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This adds ioctl for userspace to attach device cdev fd to and detach
> > from IOAS/hw_pagetable managed by iommufd.
> >
> >     VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach vfio device to IOAS, hw_paget=
able
> > 				   managed by iommufd. Attach can be
> > 				   undo by VFIO_DEVICE_DETACH_IOMMUFD_PT
> > 				   or device fd close.
> >     VFIO_DEVICE_DETACH_IOMMUFD_PT: detach vfio device from the current =
attached
> > 				   IOAS or hw_pagetable managed by iommufd.
> >
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/device_cdev.c | 66 ++++++++++++++++++++++++++++++++++++++
> >  drivers/vfio/iommufd.c     | 18 +++++++++++
> >  drivers/vfio/vfio.h        | 18 +++++++++++
> >  drivers/vfio/vfio_main.c   |  8 +++++
> >  include/uapi/linux/vfio.h  | 52 ++++++++++++++++++++++++++++++
> >  5 files changed, 162 insertions(+)
> >
> > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > index 291cc678a18b..3f14edb80a93 100644
> > --- a/drivers/vfio/device_cdev.c
> > +++ b/drivers/vfio/device_cdev.c
> > @@ -174,6 +174,72 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_de=
vice_file
> *df,
> >  	return ret;
> >  }
> >
> > +int vfio_ioctl_device_attach(struct vfio_device_file *df,
> > +			     struct vfio_device_attach_iommufd_pt __user *arg)
> > +{
> > +	struct vfio_device *device =3D df->device;
> > +	struct vfio_device_attach_iommufd_pt attach;
> > +	unsigned long minsz;
> > +	int ret;
> > +
> > +	minsz =3D offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
> > +
> > +	if (copy_from_user(&attach, arg, minsz))
> > +		return -EFAULT;
> > +
> > +	if (attach.argsz < minsz || attach.flags)
> > +		return -EINVAL;
> > +
> > +	/* ATTACH only allowed for cdev fds */
> > +	if (df->group)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&device->dev_set->lock);
> > +	ret =3D vfio_iommufd_attach(device, &attach.pt_id);
> > +	if (ret)
> > +		goto out_unlock;
> > +
> > +	ret =3D copy_to_user(&arg->pt_id, &attach.pt_id,
> > +			   sizeof(attach.pt_id)) ? -EFAULT : 0;
> > +	if (ret)
> > +		goto out_detach;
> > +	mutex_unlock(&device->dev_set->lock);
> > +
> > +	return 0;
> > +
> > +out_detach:
> > +	vfio_iommufd_detach(device);
> > +out_unlock:
> > +	mutex_unlock(&device->dev_set->lock);
> > +	return ret;
> > +}
> > +
> > +int vfio_ioctl_device_detach(struct vfio_device_file *df,
> > +			     struct vfio_device_detach_iommufd_pt __user *arg)
> > +{
> > +	struct vfio_device *device =3D df->device;
> > +	struct vfio_device_detach_iommufd_pt detach;
> > +	unsigned long minsz;
> > +
> > +	minsz =3D offsetofend(struct vfio_device_detach_iommufd_pt, flags);
> > +
> > +	if (copy_from_user(&detach, arg, minsz))
> > +		return -EFAULT;
> > +
> > +	if (detach.argsz < minsz || detach.flags)
> > +		return -EINVAL;
> > +
> > +	/* DETACH only allowed for cdev fds */
> > +	if (df->group)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&device->dev_set->lock);
> > +	vfio_iommufd_detach(device);
> > +	mutex_unlock(&device->dev_set->lock);
> > +
> > +	return 0;
> > +}
> > +
> >  static char *vfio_device_devnode(const struct device *dev, umode_t *mo=
de)
> >  {
> >  	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > index 83575b65ea01..799ea322a7d4 100644
> > --- a/drivers/vfio/iommufd.c
> > +++ b/drivers/vfio/iommufd.c
> > @@ -112,6 +112,24 @@ void vfio_iommufd_unbind(struct vfio_device_file *=
df)
> >  		vdev->ops->unbind_iommufd(vdev);
> >  }
> >
> > +int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
> > +{
> > +	lockdep_assert_held(&vdev->dev_set->lock);
> > +
> > +	if (vfio_device_is_noiommu(vdev))
> > +		return 0;
>=20
> Isn't this an invalid operation for a noiommu cdev, ie. -EINVAL?  We
> return success and copy back the provided pt_id, why would a user not
> consider it a bug that they can't use whatever value was there with
> iommufd?

Yes, this is the question I asked in [1]. At that time, it appears to me
that better to allow it [2]. Maybe it's more suitable to ask it here.

[1] https://lore.kernel.org/kvm/c203f11f-4d9f-cf43-03ab-e41a858bdd92@intel.=
com/
[2] https://lore.kernel.org/kvm/ZFFUyhqID+LtUB%2FD@nvidia.com/

> > +
> > +	return vdev->ops->attach_ioas(vdev, pt_id);
> > +}
> > +
> > +void vfio_iommufd_detach(struct vfio_device *vdev)
> > +{
> > +	lockdep_assert_held(&vdev->dev_set->lock);
> > +
> > +	if (!vfio_device_is_noiommu(vdev))
> > +		vdev->ops->detach_ioas(vdev);
> > +}
> > +
> >  struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vde=
v)
> >  {
> >  	if (vdev->iommufd_device)
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 8b359a7794be..50553f67600f 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -241,6 +241,8 @@ int vfio_iommufd_bind(struct vfio_device_file *df);
> >  void vfio_iommufd_unbind(struct vfio_device_file *df);
> >  int vfio_iommufd_compat_attach_ioas(struct vfio_device *device,
> >  				    struct iommufd_ctx *ictx);
> > +int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id);
> > +void vfio_iommufd_detach(struct vfio_device *vdev);
> >  #else
> >  static inline int
> >  vfio_iommufd_compat_probe_noiommu(struct vfio_device *device,
> > @@ -282,6 +284,10 @@ int vfio_device_fops_cdev_open(struct inode *inode=
, struct
> file *filep);
> >  void vfio_device_cdev_close(struct vfio_device_file *df);
> >  long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> >  				    struct vfio_device_bind_iommufd __user *arg);
> > +int vfio_ioctl_device_attach(struct vfio_device_file *df,
> > +			     struct vfio_device_attach_iommufd_pt __user *arg);
> > +int vfio_ioctl_device_detach(struct vfio_device_file *df,
> > +			     struct vfio_device_detach_iommufd_pt __user *arg);
> >  int vfio_cdev_init(struct class *device_class);
> >  void vfio_cdev_cleanup(void);
> >  #else
> > @@ -315,6 +321,18 @@ static inline long vfio_device_ioctl_bind_iommufd(=
struct
> vfio_device_file *df,
> >  	return -EOPNOTSUPP;
> >  }
> >
> > +static inline int vfio_ioctl_device_attach(struct vfio_device_file *df=
,
> > +					   struct vfio_device_attach_iommufd_pt __user
> *arg)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> > +static inline int vfio_ioctl_device_detach(struct vfio_device_file *df=
,
> > +					   struct vfio_device_detach_iommufd_pt
> __user *arg)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> >  static inline int vfio_cdev_init(struct class *device_class)
> >  {
> >  	return 0;
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index c9fa39ac4b02..8c3f26b4929b 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -1165,6 +1165,14 @@ static long vfio_device_fops_unl_ioctl(struct fi=
le *filep,
> >  		ret =3D vfio_ioctl_device_feature(device, (void __user *)arg);
> >  		break;
> >
> > +	case VFIO_DEVICE_ATTACH_IOMMUFD_PT:
> > +		ret =3D vfio_ioctl_device_attach(df, (void __user *)arg);
> > +		break;
> > +
> > +	case VFIO_DEVICE_DETACH_IOMMUFD_PT:
> > +		ret =3D vfio_ioctl_device_detach(df, (void __user *)arg);
> > +		break;
> > +
> >  	default:
> >  		if (unlikely(!device->ops->ioctl))
> >  			ret =3D -EINVAL;
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 07c917de31e9..770f5f949929 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -222,6 +222,58 @@ struct vfio_device_bind_iommufd {
> >
> >  #define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 19)
> >
> > +/*
> > + * VFIO_DEVICE_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 20,
> > + *					struct vfio_device_attach_iommufd_pt)
> > + *
> > + * Attach a vfio device to an iommufd address space specified by IOAS
> > + * id or hw_pagetable (hwpt) id.
> > + *
> > + * Available only after a device has been bound to iommufd via
> > + * VFIO_DEVICE_BIND_IOMMUFD
> > + *
> > + * Undo by VFIO_DEVICE_DETACH_IOMMUFD_PT or device fd close.
> > + *
> > + * @argsz:	User filled size of this data.
> > + * @flags:	Must be 0.
> > + * @pt_id:	Input the target id which can represent an ioas or a hwpt
> > + *		allocated via iommufd subsystem.
> > + *		Output the input ioas id or the attached hwpt id which could
> > + *		be the specified hwpt itself or a hwpt automatically created
> > + *		for the specified ioas by kernel during the attachment.
> > + *
> > + * Return: 0 on success, -errno on failure.
> > + */
> > +struct vfio_device_attach_iommufd_pt {
> > +	__u32	argsz;
> > +	__u32	flags;
> > +	__u32	pt_id;
> > +};
> > +
> > +#define VFIO_DEVICE_ATTACH_IOMMUFD_PT		_IO(VFIO_TYPE,
> VFIO_BASE + 20)
> > +
> > +/*
> > + * VFIO_DEVICE_DETACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 21,
> > + *					struct vfio_device_detach_iommufd_pt)
> > + *
> > + * Detach a vfio device from the iommufd address space it has been
> > + * attached to. After it, device should be in a blocking DMA state.
> > + *
> > + * Available only after a device has been bound to iommufd via
> > + * VFIO_DEVICE_BIND_IOMMUFD.
>=20
> These "[a]vailable only after" comments are meaningless, if the user
> has the file descriptor the ioctl is available.  We can say that ATTACH
> should be used after BIND to associate the device with an address space
> within the bound iommufd and DETACH removes that association, but the
> user is welcome to call everything in the wrong order and we need to be
> prepared for that anyway.  Thanks,

Oh, yes. it's available as long as FD is got. But it is expected to fail if
the order is not met. This should be what the comment really wants
to deliver. Will have a look at other ioctls as well.

Regards,
Yi Liu

>=20
> Alex
>=20
> > + *
> > + * @argsz:	User filled size of this data.
> > + * @flags:	Must be 0.
> > + *
> > + * Return: 0 on success, -errno on failure.
> > + */
> > +struct vfio_device_detach_iommufd_pt {
> > +	__u32	argsz;
> > +	__u32	flags;
> > +};
> > +
> > +#define VFIO_DEVICE_DETACH_IOMMUFD_PT		_IO(VFIO_TYPE,
> VFIO_BASE + 21)
> > +
> >  /**
> >   * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
> >   *						struct vfio_device_info)

