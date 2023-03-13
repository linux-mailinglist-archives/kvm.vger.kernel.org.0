Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D6A6B6D4A
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 03:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCMCGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 22:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCMCGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 22:06:52 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029502B63B;
        Sun, 12 Mar 2023 19:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678673211; x=1710209211;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QBFH/+ouivVyBTIapHMCn+4pRDBSRtmOw71huXdip9Y=;
  b=HXKotTlu/Vci8pdIN1ytjIbKwNGBMxGLW1KE6uMXjK2F9n0b1k1XSJGc
   hcXA5K47RaKHxr4o3dOg3Lo0Xb1Kg5tOqFiydAtCUgA92QddmEoGSc80H
   tR+ei5sy56wlXgo1m7AiaZcmeeUWww+m1ZJX1rH+dIIwUni4PYUf787h3
   mDbNEc1kl8MxfgFf0cLgau0TZB/Qddh06TUl74b5I/C87UTBVTCdAlSyn
   M/xGXwxVGJosgEF/kx20Uc+daZET7lrlXvum3Hc6NTM6koDz/mMPcztQ2
   tv3BbhR3BokkdUtukxkCnNrNGwYk8aM7eCiV3jluWYPhZmr2RwB1kooZK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316693053"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316693053"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 19:06:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="678514740"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="678514740"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2023 19:06:47 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 19:06:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 19:06:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 12 Mar 2023 19:06:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YP/IP5diN3KX285uFswRpjuoIf6TyUHDSRHgmuKJmmcQC3ZZ6Q0kAb2u2pH1s6+NdSayNObXSfKJAQo9V/IcgnHHwgkjrFsIXRF9KOydHPxnofOf45T4w3zSLiTWtFCtc01a816Lukh28giSYqK0xG1mVVqAUmlvS7WWtlIVNEnMvyhnwzv7+6JuC11OZ9Ps3Tbi9xkv7WIUBXqCAV+m2CJTa3GCW2xcVai+bmHTZdnfdnm9cI2R0MsD2QWD/UW8ZriFY4rzQE4CJjd8PJNqAOljRy0QPmD8NYBVx00tIMe7iBer/dQam2O7t1iL4yRxr7vt8I8/0dHwhCIG0KaeLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0SH0iLHPED5VxCwaO7ObX2JG+CidPw61MO5sBRr0/g=;
 b=B7yKV0egh8ApInIzGITB2sQJUAkAvWveYeA4ttDugodkJ8bcvt62fmjS+zGZ/XNllFB3/2lWIMQX9onA7l5R1W561MnVGz2F97iASitv8pMmHzDfSXvosWoYWUn17lJlmghU+L2LgLAjEtOQZ3I8fR9o+G2dtoE2gPrL7tkdoDGViPkOiCRbErgjE9qBcZzsK4+BwLlYf4tfheltelqjWwWbsYDjQfON8IAl+OppoCe5z9ELwk/w99stqDWDGH7QZ0lsaNnWDwnH+h3kqKLjg6srh7fDzHlRMsURYkXhfcnjzyaH7f4mIlwFAnRxCG+9QQmES0vgvM+ui08o1SazeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4759.namprd11.prod.outlook.com (2603:10b6:208:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 02:06:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 02:06:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
Thread-Index: AQHZUcIKnlfid+m1xk2WV9/gWjjIRK7zp/CggAAHawCAAbRpAIACmVog
Date:   Mon, 13 Mar 2023 02:06:39 +0000
Message-ID: <BN9PR11MB527690E711606D3DE26EEDBA8CB99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-14-yi.l.liu@intel.com>
 <BN9PR11MB5276CF102D9EBB7B447C58FD8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529BF46B3A81438DE7A11D2C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB752958F38FC08C15E3E25C1AC3BB9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB752958F38FC08C15E3E25C1AC3BB9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4759:EE_
x-ms-office365-filtering-correlation-id: 4e7f4567-dd12-4230-f43f-08db2367957a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PJAc4CyowLKM/U6ZDY5uGh2/jQY5J5CTawwcNUGs6nLiHIWFlWproQ42ILQUG9jtTZWmTx5jPo+WVoMoqW7+yoDD8hvMcH1pKlN0Z+xqc1qmO8RmU603PeoCVzsJhTFDcaa+pQlK6afezJz4k7ZynXzaLwqmOTiDsdZgZ/cciTc5fo+Q8v3HOJvj0tFZsiTcM9KBqnA70q0A5NyzSafE7e3WgR8tAqLB0CtjWiAEv6SUUTJRgaIJFgBfUX5+w57ZZPMR5TJiZ7sQWTOdyiusX3QHJOBlr9iY+ekPK4LcDJwkX4s9IfYPXMr199zmEm5krdOhIllNFtWVFdI7ufHtBzJ02qT2LLKn45OHlg/+8wl7zM4B4OhSYQXBuDF2fXzTv9QsbFgFG4/wCxHrF68kSrlgEql7TbZ0g2msdgSqiYU5jctVK3czmL1DXRrZbuivt0KQn7xjiJI7inbYLoTuIktCewpdqGgmhxodiUmG4THZeTUzdyjgHwsFUAQXzs1RFHPYlcSQiRaNN0MSZiE7YtOy+dHzCTEoBNr25bzFZd9ydlWiNXaD0dnLG2+RPZCXO827eGgYoJ0PuxjiihU0PEGCdA5ldQhTR1xWx/Fs6nW3UyeuLZXsDGp4M2CHTEgVQE/bxYeb9AlvC+x6EV6EUU2ex9a3IhHYFC4tzuo6qGTMxn/BBqL4qw768bWtRMA/cEzza+HiFrcJDS8pruULtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199018)(66899018)(2906002)(82960400001)(7696005)(26005)(6506007)(9686003)(5660300002)(55016003)(33656002)(52536014)(8936002)(186003)(71200400001)(8676002)(86362001)(41300700001)(38070700005)(4326008)(7416002)(66446008)(66556008)(76116006)(64756008)(66946007)(66476007)(478600001)(122000001)(110136005)(38100700002)(316002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZPHuODUvl2guqntagDFAAa52TOS4tkSElY8MxBJ4HVzHIoD7h8kHqu2mzJHM?=
 =?us-ascii?Q?TIPfrxHW38HMmRymm6LX17uiSPWfyFF3nIWYcdsQklWaEE4I2rHqHQpH8wC9?=
 =?us-ascii?Q?mcxX3mFG7yyG3UkLRew+1PolXdXnDWltRZJDFAxz2LDuzoR3KJAvq43MA1TT?=
 =?us-ascii?Q?W3NBFGvfdrXSWeXy9wkJ7f/xQKpoFu6ijRlKayDi72gOzIhu1yWO7kPd1QdT?=
 =?us-ascii?Q?M4xWGmq4QcQA2sTV8cuVqLWSOSr9VwSJYmPupJust64JZykkzKnZr2g3U114?=
 =?us-ascii?Q?vQ3rVv5JKOEVFyMyxfi9/c+3WgT57cauRT0lPltmOnUy8f5fDV0VPn7t2Aaf?=
 =?us-ascii?Q?0z1lfEkvQb4mR6DORZ1OcvpbvdLuwFuh3TRbdimyIkDoEoz/iH/yXhPu9KHm?=
 =?us-ascii?Q?vu/1ESgtKDtzjy4unOu8+HYtiGmgprKXgZnm/nru92Em1awurp5nKxphBZ0f?=
 =?us-ascii?Q?p/hIjfTuS2Bw3iIRoRgFPr5Up9QkEW7jsYF0YbTK7/Dh2Mr71dyX7097OBkx?=
 =?us-ascii?Q?1MgYBF/osVJQrKT4eVHV7PMbjBSzVEL6pln6Fpv2knCBgEBAJja96g1fcPh+?=
 =?us-ascii?Q?LqNd9WRYN4ZaH0VNUloY/Wed/R+SMvZ+pifEuZ3OFrLuRYKLNMVheBBM3RLl?=
 =?us-ascii?Q?KNk5BxMaXZ0mz0Svw3UzzvRyO0/m5dIJfNN1s+WEQBU2TMq8Ppj9QBcNCUpR?=
 =?us-ascii?Q?JTGPkj40ED5VD3B7OYCeKnBtyBFc0Ns5y2kHAmY5VnizfUCNZYkkBUxfpbQA?=
 =?us-ascii?Q?mfXJFWNiCJb7h9S8HF3NJVOD4tGFHXQqOjTcy3rSnmWzMHUQvs8pdpimZ6iI?=
 =?us-ascii?Q?g46vtk/X0iZXpwF1eYc35EPpwbYSdvRHyqWdRRr8ZXcV2aMsKNZz48nbuGvX?=
 =?us-ascii?Q?yte8hBMWSbwwpxtysJyfOaGT0UR07hJZj2No292MA/G2ujacrQK4HXA6UEF+?=
 =?us-ascii?Q?/9fOltU9ifO221xvFSCat0a1Wcz2/MbFKugdc6vLIWlNlapLlIsTqQLJRfiX?=
 =?us-ascii?Q?0ktMK7SAs3MEpZ/2IYl6eZ9G8aC/hXxOjY/I3iaKKFvbX5pZpmGNuYAhQmZK?=
 =?us-ascii?Q?dCtlgU7tbJIO0vxFb+aMEj607Ra6MUqyVCvkbkICsv+tMBUnzQrd0QAFyK/I?=
 =?us-ascii?Q?76/A0bIJJQY/meuFSeTxnHDQ+D+lfskGm6voxgpLpp46T3BS4xb6+I7jgG3V?=
 =?us-ascii?Q?+9LyFWW41INWumxas/QGe55hJCGCDRlBO0H+YycLMoYQOmw7s4V06TEGa5oK?=
 =?us-ascii?Q?ICUFHO6R8WuExKSP7+8dCeznnSSnDROuCW+RFFeaYuhJSxPAxEGiLvxOLYpP?=
 =?us-ascii?Q?4V+PRaIgnt/VD4AD0J9vS0XPMk20i54PQYivBORVmLiQd0BnyOBu4XtYik+K?=
 =?us-ascii?Q?gj6qOaADV1DfCgkRrGez8DOm5jZDgekD3582A2ZKTFWYIPJXhk3NbrxNgv7q?=
 =?us-ascii?Q?x541CkQ5DfokdiNVCSbuy99wEQ+wdsfvfYYUvcOLhqWfAsSoGT6voHOEPkba?=
 =?us-ascii?Q?L3lj4KZFdoFJORnJa1MINEUDTf93M6Ris3CzV+m4aL0Y/bBIMdtipvXsDjzH?=
 =?us-ascii?Q?ue5qQlYXXasnml+5Lu2VGVbC2yS3KdsfrZEndw2y?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e7f4567-dd12-4230-f43f-08db2367957a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 02:06:39.9055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HXj5gRzRwQksGVAXokwsnVellcXrvZ6PGQxVWZyAzdAMPLv8HvwZ+sUAFxOVD7rarPERcmPK5FJXzxxm/Z5lrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4759
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Saturday, March 11, 2023 6:24 PM
> > > >
> > > > -	ret =3D vdev->ops->bind_iommufd(vdev, ictx, &device_id);
> > > > -	if (ret)
> > > > -		return ret;
> > > > +	/* The legacy path has no way to return the device id */
> > > > +	return vdev->ops->bind_iommufd(vdev, ictx, &device_id);
> > > > +}
> > > >
> > > > -	ret =3D iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
> > > > -	if (ret)
> > > > -		goto err_unbind;
> > > > -	ret =3D vdev->ops->attach_ioas(vdev, &ioas_id);
> > > > -	if (ret)
> > > > -		goto err_unbind;
> > >
> > > after noiommu check and attach_ioas are moved out then this
> > > entire function can be removed now. Just call the ops in
> > > vfio_device_first_open().
> >
> > Yes. and also no vfio_iommufd_unbind().
>=20
> Seems still necessary to have this wrapper. .bind_iommufd callback would
> be NULL if CONFIG_IOMMUFD=3D=3Dn. If we call ops->bind_iommufd directly
> in vfio_device_first_open() of vfio_main.c, it may trigger kernel panic
> for NULL pointer dereference if there is wrong code that passes valid
> iommufd pointer.. Ideally, if CONFIG_IOMMUFD=3D=3Dn, vfio_device_first_op=
en
> should not receive valid iommufd pointer hence won't call ops-
> >bind_iommufd
> at all. So it deserves a panic. However, if we have a wrapper for it, suc=
h code
> may just fail with -EOPNOTSUPPT.
>=20

ok, let's keep this wrapper then. I didn't realize it's NULL if
CONFIG_IOMMUFD=3D=3Dn.
