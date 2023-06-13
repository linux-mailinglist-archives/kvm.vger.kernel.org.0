Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B95872E5E7
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242506AbjFMOgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbjFMOgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:36:23 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0CFE54;
        Tue, 13 Jun 2023 07:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686666981; x=1718202981;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zX0p108VLH22TbI8XxiHVkJHN6VIdsEDWVq7Rxtg9e4=;
  b=meIS9u7IIlaQSz/PR6arrSVZopH4FR+/yXDnwoz3I2H2zb+4Ah683aK8
   RPQsByKfCjtkaxaJy1m4cXPBJqPd4xPDdhQ4YQEyGBp0PcCwJr6dVS8jW
   FW6xOnITAElYJNRFdV/tipJyDPqLkZJ/mjYYr45astYjMSobJu4Nu2+fw
   geyHoAHFAsNc2T9lzzO8NGIWQieq30wGCSYQYzOdIVnlTFylIqTt6zGWy
   C6GCxBg9ChLmzwO2rc/LYQd78+u+cpRTF0CLuu6WcGolC8kpnQngasJ4a
   O1P1gNc5Cluy4ddy2z75d45AaiVBPo/NWjmFldKkGuqo/ZueBIPYoiN5p
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="337988620"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="337988620"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 07:36:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="856117033"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="856117033"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jun 2023 07:36:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 07:36:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 07:36:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 07:36:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oeV6yVVRXjcvmTqeABxc7gIwDaXxUnZwFou4DDgSvBc9Uzqru6veqCmZhaJwhjGLWdtNM7wPkci+dwM8aZlTYd2srVyM6Bo0JxnDHGTjvbTQef//uhRIyvv7/FspqwlS8iCl7DYWE+BoAGMYtVmnUy2q9WFeoB85/p6EmdYYTsUIE6edNBxJPArT/aj+qBYjDlPg1ur/CyAEB1Uv6bUFnaYqsr0B/UrDbq5lxtSMtXgLvadXSVhLJB0O9qGSCEkJdNeMZfIKI2ofgP8zl6H9dxheAS6WNnrN6HbzSnnbdBvYyzlgb6fMvciUZvFKEaP/XDYuMNTUhN3PHC51NCZP3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rpFhXP17vJEc7dIp5JXi7qoEa3ePXkzPbganKPKfHOM=;
 b=G5Aq9CMRdMl6S+ef+yI6A1m4Zm0D8m6uWBRbafHk5Z3qBXLS+GBpZATXIKrf8GFdb83gS547qx9NyyFvXSIIywen1IG40PFzZbMFPflG+nfWs3qYhi+b+3x8G4XBjlSUDv/5wdzAm2q2+LhJd25B9Sm0X4mLsbfULqzn6070XARU7p0i+wr8gPP6KCxs8BRxsVd1rtjUT87vOON8acMc8Bmh6mXj4nBlhckQrVk+uD1mf4/eUknzN1a1Z+7z276jjDtuUtm1ocNnZHhYxGXLLD/v54rVG87r2VYKKx0Ol+9KqpYLVJpegiD9Nque/uxJgMGBaekXnvglworndvM1iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB5007.namprd11.prod.outlook.com (2603:10b6:a03:2d2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Tue, 13 Jun
 2023 14:36:14 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 14:36:14 +0000
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
Subject: RE: [PATCH v12 07/24] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH v12 07/24] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZlUwrPp8CB3o9OkmAJqWvehBIwq+Hxa4AgACAbJCAAJKtgIAABJBw
Date:   Tue, 13 Jun 2023 14:36:14 +0000
Message-ID: <DS0PR11MB7529B3DB059798EA474ACB3DC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-8-yi.l.liu@intel.com>
        <20230612155210.5fd3579f.alex.williamson@redhat.com>
        <DS0PR11MB75293327BDE6D268996FFFCCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613081647.740f5217.alex.williamson@redhat.com>
In-Reply-To: <20230613081647.740f5217.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ0PR11MB5007:EE_
x-ms-office365-filtering-correlation-id: 3c51bb5d-5460-4a05-7736-08db6c1b8a4a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DAtopXZvf3h3bBMsak/j7hOfl5b1Qt9D98QDG2LtSIl8xT72/YaKjgKxithEB42jmXi7wmfo+ah3odXM6bvaVPFvc6jOPVRiPd0Rg3MykYSO18CAo8pgRlHeynKkwr+FB6+a0yeT4OXFpir3S/tOLp+oEFSguz/UwVLhydgPG4dGzRnpvAPTeLlmufwSTj2GtMyLcBH/trq8AGMiLw/uP9Wm52oFRKYPwvXGAzhEKPEn19DfmcBaCrdCuugQ4SzLjE8cGAeiDjeH35lUOtgDFM4MEjkkg+Uz/hwlV5zDyB8CdHuptgAx2f9a+MzjVoDYVTySXMDOrPE7uxDWjMEmgZQBkRoKuyY6UVFv5kgzkLEg+zLV1FEDZ6v/wZZ07b/iKOTQqC2hPG2C0K+AZKxbENwQu9RTSLdtQycyCkddt0UoY2CeRGavKEMJCw6HND+8z5o4wl3Eat8XozPRqGhh36WmbgLfszGmEoVNzSEiPQxfIFSRAiloam0ynDFnfGEqUJ90ULsTgigOQ1rAgTpNxjn3fBvDEGX/C/tbpnLglW1vSc5sWYt8COW340j3ygZOympOEu1gmGfpLd23SOiH6x0C1g/ZxX60h5r4obx7oUEFdt4D4OnnSUlwlMeKA3gm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(376002)(366004)(396003)(451199021)(54906003)(5660300002)(8936002)(66946007)(66556008)(6916009)(4326008)(7416002)(8676002)(52536014)(41300700001)(316002)(186003)(66476007)(2906002)(66446008)(71200400001)(64756008)(478600001)(76116006)(7696005)(6506007)(26005)(33656002)(122000001)(55016003)(83380400001)(9686003)(82960400001)(86362001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2R+kQV50EgoehEgMfhXpuUHob1H8rEBaEheFd+XWMirBZOViaLzKDeGqgtw6?=
 =?us-ascii?Q?2xubk/x3xy0Bn1+rZn6w0/8IanG3UoPd3mtIwnwk8GuTycI4W39tbD0md9eG?=
 =?us-ascii?Q?l9pkpmSHqyd0Ls7Ks03jvqtxX/+MfBvliOwNb5IH1JBa6bbmVuL3rrt5LVAA?=
 =?us-ascii?Q?Qq2x7Wumd9dPQcA/hXyqpOd7Q/L5LSaw75clUOClOfgXM3LvjlNM0pf+mWuV?=
 =?us-ascii?Q?VPvi/5pr2CAYozDBjWn0tnZ8c5PjXNvOlwQtUYxx+bvc2SjbCr1cwy59a1l9?=
 =?us-ascii?Q?jBwVchIfDxW46zv53p+oyuh1k4IESon9ea44dEhidoK5VZt4z5hD9fDxqaOm?=
 =?us-ascii?Q?L/MYkaL4YsOlRr7G4rcJoxpBRqwH1+Dkr2YxI82mHdWMtRQ1gahWfRaMunRo?=
 =?us-ascii?Q?lvzh1BCtNQkuJaFRuP7Aqm9jZ+GQPo+0HY46A/CzAo6u4yyksgfuPZY/deGo?=
 =?us-ascii?Q?GbgcVqffesHU/JwukZUCk5laMY/aKC0zrJmnDtdqwcDNYoJTRiTf5Hk7HX+L?=
 =?us-ascii?Q?s67YFlQHBfvFn5c6RMzAOqw8fHk/+081nBWLVb+EIQpfIj190WOKAMSmEgcS?=
 =?us-ascii?Q?DyRB178Kbd2y1LNAu75GuO21cEGIAWjNaz7SwV5ydILOg2iMm2SmdsynAk5f?=
 =?us-ascii?Q?TSJMuq/2TpOKx1iWLLfJPBUK+7JJE5WMA3pzZ9KQ+KuoFSfSd9GZ3vwc1z9H?=
 =?us-ascii?Q?TbhVXJlZFhlOBmO/7F/AWVxwH5Uorl+r8SGMw/lwbz/pbGf7IXc68wB86dFY?=
 =?us-ascii?Q?6525paRTGzPZc6MqEEmFmtsK5S8jamzhaqr1xBMVX5qsSVpgn6N1s/F8ZWzP?=
 =?us-ascii?Q?FkOHhS3jWyegtanDG3zWLKYFkLVfu5ADSzyaG5YJ43OvFsyOsK1dyu68NmNd?=
 =?us-ascii?Q?uJOEGe9XHmXKduOISj/oD+rGZaOMZgXtTdOJB21W+cnJ/S4pUNi2yLew5kkS?=
 =?us-ascii?Q?Y03v+ZcwvMDKnCXiUKAP9PRn29nMy76B391gnHDHprWkrHDlDgdo0uoEmiIB?=
 =?us-ascii?Q?6AZjD4fzKWCP7v6P2LMACn6Uupp89+cZ5P6eScoMT61YpTjgO2W4WtK5hLL8?=
 =?us-ascii?Q?YXrnfkvhKG499ClUayI63ItMCIgDrYZ2/EApZNG7+BDZfOFTi1YEke0yPGF3?=
 =?us-ascii?Q?XDi1hHBV1n2XDiWOiDMR69aj3+N0lRPI/3Uo4qBZBpYmtnb8ORROtG4VM/bL?=
 =?us-ascii?Q?i4Vx4Z3zaR6k3WOXepEbhXQBk+ogdA9xDGmkoujAkntLZGnX0Im99GclfHr+?=
 =?us-ascii?Q?F19jMv+UcKHt/Ya+9G3qla80jT2jhQ4soN9GBEdY4lAw9Y4rX0mXT/2lbr//?=
 =?us-ascii?Q?4ptuWaFIVM1pVqf9eVMoHW86BTvio+daAhioIFzs9ISUfrSV1i6f75fxH6HP?=
 =?us-ascii?Q?AgQ+U30yGKbV/HaOv3cMOAzcovS2qFaFVf8YG8XacmtilW6we4IgLa1TeCa1?=
 =?us-ascii?Q?aYmnRLLooFhfHbZd6O3EmrJcFwKBM15Z7WhkgeP7U0KLoXXveZXtd6pdMAiW?=
 =?us-ascii?Q?Ft0ElnHl0RcAW3VI1M2fdJhKS6HTgYw6AifcBpqQXPG8ddXBdq4Vt42eMzBN?=
 =?us-ascii?Q?HAU2rPBr/vWhabb+/fToq/Qo4hoSn2CB3wd2Rjoe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c51bb5d-5460-4a05-7736-08db6c1b8a4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 14:36:14.2976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nlu+7g7iS636ZLmbjtZivvDEoy5GIj6ZhUUnNfSheIi09piPtdv0N4WG1m51AOlHiXyuhTo0rDNOl9YaXsJT3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5007
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, June 13, 2023 10:17 PM
>=20
> On Tue, 13 Jun 2023 05:46:32 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, June 13, 2023 5:52 AM
> > >
> > > On Fri,  2 Jun 2023 05:16:36 -0700
> > > Yi Liu <yi.l.liu@intel.com> wrote:
> > >
> > > > Allow the vfio_device file to be in a state where the device FD is
> > > > opened but the device cannot be used by userspace (i.e. its .open_d=
evice()
> > > > hasn't been called). This inbetween state is not used when the devi=
ce
> > > > FD is spawned from the group FD, however when we create the device =
FD
> > > > directly by opening a cdev it will be opened in the blocked state.
> > > >
> > > > The reason for the inbetween state is that userspace only gets a FD=
 but
> > > > doesn't gain access permission until binding the FD to an iommufd. =
So in
> > > > the blocked state, only the bind operation is allowed. Completing b=
ind
> > > > will allow user to further access the device.
> > > >
> > > > This is implemented by adding a flag in struct vfio_device_file to =
mark
> > > > the blocked state and using a simple smp_load_acquire() to obtain t=
he
> > > > flag value and serialize all the device setup with the thread acces=
sing
> > > > this device.
> > > >
> > > > Following this lockless scheme, it can safely handle the device FD
> > > > unbound->bound but it cannot handle bound->unbound. To allow this w=
e'd
> > > > need to add a lock on all the vfio ioctls which seems costly. So on=
ce
> > > > device FD is bound, it remains bound until the FD is closed.
> > > >
> > > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > > > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > > > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > > ---
> > > >  drivers/vfio/group.c     | 11 ++++++++++-
> > > >  drivers/vfio/vfio.h      |  1 +
> > > >  drivers/vfio/vfio_main.c | 16 ++++++++++++++++
> > > >  3 files changed, 27 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > > > index caf53716ddb2..088dd34c8931 100644
> > > > --- a/drivers/vfio/group.c
> > > > +++ b/drivers/vfio/group.c
> > > > @@ -194,9 +194,18 @@ static int vfio_df_group_open(struct vfio_devi=
ce_file *df)
> > > >  	df->iommufd =3D device->group->iommufd;
> > > >
> > > >  	ret =3D vfio_df_open(df);
> > > > -	if (ret)
> > > > +	if (ret) {
> > > >  		df->iommufd =3D NULL;
> > > > +		goto out_put_kvm;
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> > > > +	 * read/write/mmap and vfio_file_has_device_access()
> > > > +	 */
> > > > +	smp_store_release(&df->access_granted, true);
> > > >
> > > > +out_put_kvm:
> > > >  	if (device->open_count =3D=3D 0)
> > > >  		vfio_device_put_kvm(device);
> > > >
> > > > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > > > index f9eb52eb9ed7..fdf2fc73f880 100644
> > > > --- a/drivers/vfio/vfio.h
> > > > +++ b/drivers/vfio/vfio.h
> > > > @@ -18,6 +18,7 @@ struct vfio_container;
> > > >
> > > >  struct vfio_device_file {
> > > >  	struct vfio_device *device;
> > > > +	bool access_granted;
> > >
> > > Should we make this a more strongly defined data type and later move
> > > devid (u32) here to partially fill the hole created?
> >
> > Before your question, let me describe how I place the fields
> > of this structure to see if it is common practice. The first two
> > fields are static, so they are in the beginning. The access_granted
> > is lockless and other fields are protected by locks. So I tried to
> > put the lock and the fields it protects closely. So this is why I put
> > devid behind iommufd as both are protected by the same lock.
>=20
> I think the primary considerations are locality and compactness.  Hot
> paths data should be within the first cache line of the structure,
> related data should share a cache line, and we should use the space
> efficiently.  What you describe seems largely an aesthetic concern,
> which was not evident to me by the segmentation alone.

Sure.

>=20
> > struct vfio_device_file {
> >         struct vfio_device *device;
> >         struct vfio_group *group;
> >
> >         bool access_granted;
> >         spinlock_t kvm_ref_lock; /* protect kvm field */
> >         struct kvm *kvm;
> >         struct iommufd_ctx *iommufd; /* protected by struct vfio_device=
_set::lock */
> >         u32 devid; /* only valid when iommufd is valid */
> > };
> >
> > >
> > > I think this is being placed towards the front of the data structure
> > > for cache line locality given this is a hot path for file operations.
> > > But bool types have an implementation dependent size, making them
> > > difficult to pack.  Also there will be a tendency to want to make thi=
s
> > > a bit field, which is probably not compatible with the smp lockless
> > > operations being used here.  We might get in front of these issues if
> > > we just define it as a u8 now.  Thanks,
> >
> > Not quite get why bit field is going to be incompatible with smp
> > lockless operations. Could you elaborate a bit? And should I define
> > the access_granted as u8 or "u8:1"?
>=20
> Perhaps FUD on my part, but load-acquire type operations have specific
> semantics and it's not clear to me that they interest with compiler
> generated bit operations.  Thanks,

I see. How about below?=20

struct vfio_device_file {
        struct vfio_device *device;
        struct vfio_group *group;
        u8 access_granted;
        u32 devid; /* only valid when iommufd is valid */
        spinlock_t kvm_ref_lock; /* protect kvm field */
        struct kvm *kvm;
        struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set=
::lock */
};

Regards,
Yi Liu

> Alex
>=20
> > > >  	spinlock_t kvm_ref_lock; /* protect kvm field */
> > > >  	struct kvm *kvm;
> > > >  	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_s=
et::lock */
> > > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > > index a3c5817fc545..4c8b7713dc3d 100644
> > > > --- a/drivers/vfio/vfio_main.c
> > > > +++ b/drivers/vfio/vfio_main.c
> > > > @@ -1129,6 +1129,10 @@ static long vfio_device_fops_unl_ioctl(struc=
t file *filep,
> > > >  	struct vfio_device *device =3D df->device;
> > > >  	int ret;
> > > >
> > > > +	/* Paired with smp_store_release() following vfio_df_open() */
> > > > +	if (!smp_load_acquire(&df->access_granted))
> > > > +		return -EINVAL;
> > > > +
> > > >  	ret =3D vfio_device_pm_runtime_get(device);
> > > >  	if (ret)
> > > >  		return ret;
> > > > @@ -1156,6 +1160,10 @@ static ssize_t vfio_device_fops_read(struct =
file *filep,
> char
> > > __user *buf,
> > > >  	struct vfio_device_file *df =3D filep->private_data;
> > > >  	struct vfio_device *device =3D df->device;
> > > >
> > > > +	/* Paired with smp_store_release() following vfio_df_open() */
> > > > +	if (!smp_load_acquire(&df->access_granted))
> > > > +		return -EINVAL;
> > > > +
> > > >  	if (unlikely(!device->ops->read))
> > > >  		return -EINVAL;
> > > >
> > > > @@ -1169,6 +1177,10 @@ static ssize_t vfio_device_fops_write(struct=
 file *filep,
> > > >  	struct vfio_device_file *df =3D filep->private_data;
> > > >  	struct vfio_device *device =3D df->device;
> > > >
> > > > +	/* Paired with smp_store_release() following vfio_df_open() */
> > > > +	if (!smp_load_acquire(&df->access_granted))
> > > > +		return -EINVAL;
> > > > +
> > > >  	if (unlikely(!device->ops->write))
> > > >  		return -EINVAL;
> > > >
> > > > @@ -1180,6 +1192,10 @@ static int vfio_device_fops_mmap(struct file=
 *filep,
> struct
> > > vm_area_struct *vma)
> > > >  	struct vfio_device_file *df =3D filep->private_data;
> > > >  	struct vfio_device *device =3D df->device;
> > > >
> > > > +	/* Paired with smp_store_release() following vfio_df_open() */
> > > > +	if (!smp_load_acquire(&df->access_granted))
> > > > +		return -EINVAL;
> > > > +
> > > >  	if (unlikely(!device->ops->mmap))
> > > >  		return -EINVAL;
> > > >
> >

