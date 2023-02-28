Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F466A594C
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjB1Mnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjB1Mnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:43:37 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E419212AF;
        Tue, 28 Feb 2023 04:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677588213; x=1709124213;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CMn/fzGudvSDLCwXORlt0ealPzW6Vj4iJ5VfVsJJ+TQ=;
  b=FdBPUgC8uwZysJc2jNZ7K1HRRmkkRsY4GliTrbiUFPn8sYzRxohX2yFV
   5BqfNpS7dEow8rGbLbRCUApxkHNqkImamNsKfx+OrSqg/6QFNRPLud3i+
   PvtvHZSp6GeYj3u4/9tjecv9Thg+keAEN4kklFj5S/xCtFTK7Ensgy+DM
   3oZGELTLbCxWjlzA30oL7MAsQJwpCGrbXd1C9Z/5PaB5vt0r8TFy/xRZp
   Lez+wj+3QpufE2ZxsXHaHa1xbXznZMBBLF2zkMD6TWfh0kXSaz/7rNGKL
   84GTYj2mJpfD3E5GKuWhE43XOgeZqpJMTA0Df5OoYPOtIeaauXKNy9lMJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="322377645"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="322377645"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 04:43:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="651602294"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="651602294"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 28 Feb 2023 04:43:32 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 04:43:31 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 04:43:31 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 04:43:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+2WF2npJA+wWAAKpDMxEX0JaKo+qJLLBd+PWXv5XkbaqmLhn5MqNXAQeFw/aq6hF3P3zzjSrWu5EzyG9vl8y8/J7y3/oqDvZwjztnMCA3OLfDtAQzxLa5YumAMVaVBzz1d3RusZeSLHnxxAktzF+bhFDRNPv0VYRpKqNdJOx8+b9wwJltQ74MQskL6N+641AByWc0jK20p5cMwtf6U4lQyvQBem594fYqikvV6pVTvt5mcfrFJ2PXHi0j+hsxqIHLKDH5Bi85K3pgtpvk/1/sRg2054ATe2ylolpm7RF7vG9E/pgo0Y/ZUJzzdCbWOS3L2Y0WwicUanrtm9oKglwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rxh+Y4EwroZoQRvHkatILITDWxqxxofU/VYDXVtShZU=;
 b=Dt3V6pWkFa8sw3CgASQyXbzp0IfReITZb9z3iPNx70J58v8ANnbcvQdbLoiH695bKtSRGXtEIUz8fK5cTXezzgjrCQcjTUBj2mrNXdX8+2O6EvKz6NEtq5r23w0xJ9qPrkR/3cMaAWNdBuqD95SNEppgsdoox3rTsbq+cCy6lNzbdUde2d+CxVPLS869BCi6nQOfvvGl9FCgdKf5EVJcMh7LbTJUobWNwUYwdNLWj/LZZ2B9u5f+gckFLqG/Gtsn0vHD8CGS1W7Eoa0QTxdgufIlBGbBeZudvcHb9IokcxBsGz7RFUpD2cVHm9gw5FJ0bHN08xufIUm893b1O5dGfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB6360.namprd11.prod.outlook.com (2603:10b6:8:bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 12:43:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 12:43:29 +0000
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
Thread-Index: AQHZSpxLjytyosfJo0anYKoP/iDXH67jIeSAgACICkCAAKJvAIAAAEuQ
Date:   Tue, 28 Feb 2023 12:43:29 +0000
Message-ID: <DS0PR11MB7529D08BFF137C7023032F51C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-12-yi.l.liu@intel.com> <Y/z6GwZPfh2nFjpn@nvidia.com>
 <DS0PR11MB7529DC05F80083E426CC6443C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30fBnUA/PBJ1DR@nvidia.com>
In-Reply-To: <Y/30fBnUA/PBJ1DR@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB6360:EE_
x-ms-office365-filtering-correlation-id: 66281173-d4fa-4675-f125-08db198964d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MP292+jlRSdhg6jqCTqst4ohMy8JL+LfgZBY/UfL1s5muWF74WQ2NsrMStPOLjyMw6ZlABUGwlfrV1rvPEvubcQj6qvfMOyxs1t1Z2/CIof6FlZwOMRIlM8ffT/eVF12Jx6ZI9s2uwMCc5zaNNGaNc7/tmIVQDMSGzaQaF8vrc4yl+ICVAizMqiFyhtajCTdyKn7+gIvQoc8dFqf5vyXRmuE7fGtomA2+xq7pbsiKPO56r7XCmcRSukNFREjWups0R8nr4eI4YEJEy7/qDSWfX0Rd5kNlDx1bey7CKluYTLaAisq1Lu8OPKS9jHkmkssm0XilUyIGnhcGl55zLFFSwD+vovl1ajzALL1Jb3P5XaqxGRD07neLUhjrP6cTlOB5TwzXpd4Dm5l8XnMVtJ+TMTPRN4hUyf6GRgRrNRUGRLqXa5ZXR/ZvS6fbo/gbJNaaVA63qFTd8wadUfwWX7C8F+JGnhBlZ4qCIyVwtDCdny4/3cbt3vN2tweHbvg7tCuunndEyhbA76THhslexn3SdLfheYwVI+j31p0+HvBzpLB9IRUbPUu8y2vcL/pXKBdYG4a80TmsbBhOj8zOfqdzAPsNESWovzcxXPsRmLnmvB7W95qHrX+OvaG68ckSMOns4kqYVFjMN0l0iIZmtxXBQTnui1KebqRMMCIYq061fcM5anmcWH9iRAb9X7TRj+EftmN0GvhlCKAwGqactScbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199018)(82960400001)(38070700005)(71200400001)(9686003)(26005)(186003)(55016003)(6506007)(122000001)(38100700002)(83380400001)(86362001)(33656002)(2906002)(8936002)(7416002)(41300700001)(316002)(4326008)(6916009)(7696005)(66446008)(66476007)(64756008)(76116006)(5660300002)(52536014)(8676002)(66946007)(66556008)(54906003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4dE5vzGazIhRNqBYS75kPFH1F+4xaxJwB4DNcj7JIsCwMCtbSsGZ1Zw8CXPG?=
 =?us-ascii?Q?lBpLmQQsrxTBFlWEiWvbjWl+Ggd/r6T+en+apEaNLdwF8CJ48jcJHB8PXcct?=
 =?us-ascii?Q?m7KijHBv8/HtAIG3xfqNC5rny5eBqND9GT8OHNzey8UdIWS0ogNvVtnaMyeE?=
 =?us-ascii?Q?iqNbmGBph4ZO1nwG2W6dhc7GOsY6mB5rbV3YzgCJI1LJq4e6cxJVSlt21zx8?=
 =?us-ascii?Q?SMhvzdHIFAiJNC56jcD4phLViTYWDl0LqvwlmLmg9k/DC5DMOm6KMZ3duwIy?=
 =?us-ascii?Q?gZynmQ9Jb6hO6yHyBxsgh1dyXvl2X3Ay/z4uGnpkDCBSKnsCrOoO+zVEf9PT?=
 =?us-ascii?Q?XNssSSN3gwjZ3yn2t/AaUH9d7Md6aJpVUzdkxJPQtjJ0U7TWbx+h9n1+dQ3y?=
 =?us-ascii?Q?RTqOTx+RAb0ynEMjNiKLVw+bRV9c+h0mJVNCOo+Cq7zhNbd4aNT0QiwLfafL?=
 =?us-ascii?Q?w0VVU7pazvzfYaRAEws5LH/yffb5Qtic8XM9VPF+yA4GNhImoSdHCC0FW7F9?=
 =?us-ascii?Q?yC2JJHtanlAxTKBxpLANjvwTm7mOODHbcFRw9z77aHuTMp1srQiOXa9M1MMZ?=
 =?us-ascii?Q?8vUHUGty4FwtlyrytUBIbyHWGMaADmiCK4/pNtM4ZLFX8s7+ET7crJTsAEwZ?=
 =?us-ascii?Q?GKXROyeuGFmsQb43aHrq0Y3T1tvGyLuwKCwcmHU14sMZLUBpzjoeOu1u4kO1?=
 =?us-ascii?Q?AF2ogau1TGoZnP9KdBbVXQMzxNIJoDkN+UK1StKwmXtdvVFB3720/tkI+t7I?=
 =?us-ascii?Q?AaPl6aHmRQYlcX6KAH9P5R8pg/5aTL7bc8YyrRprEZZefU8fFrDszCB0TiWG?=
 =?us-ascii?Q?Y337eQ/ThRNdMP7Z4BxFBw7A5osCaMD5SnGtZVf4tGHloksdqxTYvHhM6ZsK?=
 =?us-ascii?Q?qIkNESMoHA3wqfa8+1iM/J+r0AGkmibY7vkrmq7z2DHkk1/36ltYPtFUKbhm?=
 =?us-ascii?Q?XXvd+G07w64H0T/3/1os4OOZqtYTLjnsix4E9J0F+E6e3wh14Kqhn8nNBumf?=
 =?us-ascii?Q?fSM45lYIJwQk54GPO/lovxsoU0ABhl4lPvId0ZspGSMhdUQIRCGwLxRod8Xh?=
 =?us-ascii?Q?r8XuOeF+81nPW1ytyJtWKPuJjtftUQPfxohGtasuSlYxGO5KLXPIQvagh4wL?=
 =?us-ascii?Q?Tw293/jOrpzOeiSnu5qcE7G8uvBa6F5U683DhwIdMLCEhVlVTH5kHGVohZfp?=
 =?us-ascii?Q?t3xsMcUWXCinXiMstzMDkHioeGMQlasiC/289i0BD4G20yOOUZ3coqZIvHRb?=
 =?us-ascii?Q?cEvsUPWo0pwCkIALTUjavLCvTBg2kT68VbpZ2iJMe66DjqeSBfRKEiKfu/Fk?=
 =?us-ascii?Q?9mC4eb7kNyqLuwz0pkkMNZKJg4WImdJWldueGO8w9f8E8r84Ma7etaKZrO4x?=
 =?us-ascii?Q?TMwoA+9W61OrmTQzlOMugMbeenr4ZCEMIWDGlg9Gx7D7BMmBGH+tSUm0uPcr?=
 =?us-ascii?Q?Lu/7Dsb/EyeLZ/LUg8eS82tTKJAHoPFQOU4niQ5jRTwWOzXOq3zhUtf+yrpv?=
 =?us-ascii?Q?fvYPt02PWmyrGbFnMknzZLrmkK9rgOgKxuB9ZZEQ9YYAyyazsKAfA+pQMPRX?=
 =?us-ascii?Q?BOujzjBEW55oVNTc8tDGV6AZLqI1WQU/RFssyZOB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66281173-d4fa-4675-f125-08db198964d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 12:43:29.5530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GIvvAdLPOlfm89U94iaBjZtErbAxuiJjuimLquLqJZrXkxJHzRcBsBFML5dxGyiqN02CBtY5g7uiyuvb4ZO1Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6360
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
> Sent: Tuesday, February 28, 2023 8:33 PM
>
> On Tue, Feb 28, 2023 at 02:57:42AM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, February 28, 2023 2:45 AM
> > >
> > > On Mon, Feb 27, 2023 at 03:11:27AM -0800, Yi Liu wrote:
> > > > diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-
> > > mc/vfio_fsl_mc.c
> > > > index c89a047a4cd8..d540cf683d93 100644
> > > > --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> > > > +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> > > > @@ -594,6 +594,7 @@ static const struct vfio_device_ops
> > > vfio_fsl_mc_ops =3D {
> > > >  	.bind_iommufd	=3D vfio_iommufd_physical_bind,
> > > >  	.unbind_iommufd	=3D vfio_iommufd_physical_unbind,
> > > >  	.attach_ioas	=3D vfio_iommufd_physical_attach_ioas,
> > > > +	.detach_ioas	=3D vfio_iommufd_physical_detach_ioas,
> > > >  };
> > > >
> > > >  static struct fsl_mc_driver vfio_fsl_mc_driver =3D {
> > > > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > > > index beef6ca21107..bfaa9876499b 100644
> > > > --- a/drivers/vfio/iommufd.c
> > > > +++ b/drivers/vfio/iommufd.c
> > > > @@ -88,6 +88,14 @@ int vfio_iommufd_physical_attach_ioas(struct
> > > vfio_device *vdev, u32 *pt_id)
> > > >  {
> > > >  	int rc;
> > > >
> > > > +	lockdep_assert_held(&vdev->dev_set->lock);
> > > > +
> > > > +	if (!vdev->iommufd_device)
> > > > +		return -EINVAL;
> > >
> > > This should be a WARN_ON. The vdev->iommufd_ctx should be NULL if it
> > > hasn't been bound, and it can't be bound unless the
> > > iommufd_device/attach was created.
> >
> > sure. But it is a user-triggerable warn. If userspace triggers it on
> > purpose, will it be a bad thing for kernel? Maybe use
> > dev_warn_ratelimited()?
>=20
> How can it be user triggerable? You shouldn't be able to reach this
> function until the device is bound because the ioctl should be after
> the is it bound check

Oh, yes. it is! ioctls are blocked until bound to iommufd.

Regards,
Yi Liu

