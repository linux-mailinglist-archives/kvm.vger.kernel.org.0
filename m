Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601E16372C7
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 08:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiKXHMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 02:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiKXHM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 02:12:26 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911AFCFEBA
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 23:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669274227; x=1700810227;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lkm7+0QOhXmJus9Ihk8H+QDV9nxMwwrWDW6ONNG5b6Q=;
  b=jNv/QijfVC5/lxweaVP1Mq7cKAiSpYBRCa7SUhddz3DjV0LvWcfE9SZ9
   5F7UT0GP838pmNDEiBA5OrePrVpenNGCahvFzseGWqWXQow+pOyUG42jY
   bN/vm3aneBPXsG6u773hKPb/9dGRZDAo1ciCFlBqqafxeSxjLt/KQhHxk
   KOpTR+MEKgY8ky5byUxLl30Zc/Sz00GOhWBvig26m42apHn18U7EOQtxs
   mEmvjKdas4kxvCMtfYzIHEhh1HlChZj6KXbL6eaHuGrR8yTlZxwt8gUmk
   CPx4oWHSpn9WXpA8op1tuMV9pMe2CxV2xBSIgYYkCxSkHuxp+3lDncf0u
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315383415"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="315383415"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 23:07:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="784524861"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="784524861"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 23 Nov 2022 23:07:04 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 23:07:03 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 23:07:03 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 23:07:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUFfhMh88dBTxH1/a5YPAxYWYdXroULa7TI2CuyzgbCvz5DoQBCZhTLJFHjD8WdWqOZMe20TuADUzfdpt5EIJ/L7NiYtjNLBrcaBSxqWofI6j88fJDSffHnwNQeEJAerj/2UE96knC/KHWDIX2EhQNB1ekosKP1xqAVCtmUqm9OTPSiwyMpSIb2LPreTWu7zHxuA9Ct/8YoA0iP9KkuJF69/77lHQdJtSTpPAT6w2ubu5sEEB8dnQ1rkeExtKiHC07us5ia2JWPQzQpOOsQ+i00yNm1yosSS9dpfk56ExfFU6xDusMnKTKS3kl22Q+LOtZ5gTs+X0+UateeRn4LpEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GDLL3d7qvLOHer6fmSGt2bliW8fYJfXikq7W/4OdY6I=;
 b=TK4l+8AYWqZd3sPjoUymzUzwqoz8HxDKRqRAyjGzekMU9GVVopqanjtc0pYdHt1zVVA2P0Imcl5XxnnRtwEB2GMDXsW/2qI5E8ZwkNNLUA19AiZziIKQCiuIXdpUjTCV4bVTfj3v+OWp47NUaN7a2/zYMLetmF66A0deV3SAnp1V6YRE+w68qO+GZQOHqmtjy/oSxntRmG5hwItvu/dvmKQ7ozcsNcoa8zHlKBmB49YVYVPcHcSVxTHkXkgTJvJFhC7AztBWwS9tA1rfbWjwSrKbV5v6iOhSFnSZ4NCzAm91v0uGyJqQOnwzZ6VlVol2k9kkB11CeBV88dLewQCFfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA3PR11MB7464.namprd11.prod.outlook.com (2603:10b6:806:31b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 07:07:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%8]) with mapi id 15.20.5857.018; Thu, 24 Nov 2022
 07:07:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: RE: [iommufd 1/2] i915/gvt: Move kvmgt_protect_table_init() and
 gvt_cache_init() into init
Thread-Topic: [iommufd 1/2] i915/gvt: Move kvmgt_protect_table_init() and
 gvt_cache_init() into init
Thread-Index: AQHY/0JMhkbhTD2JSU2Keq3HK6Y9aa5No5aQ
Date:   Thu, 24 Nov 2022 07:07:01 +0000
Message-ID: <BN9PR11MB5276413337536E76B2B0DA0E8C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-2-yi.l.liu@intel.com>
In-Reply-To: <20221123134832.429589-2-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA3PR11MB7464:EE_
x-ms-office365-filtering-correlation-id: e0a1dee5-aba7-433b-612c-08dacdea7c16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: huo6Ux3F0L6qGOZucSKgd4+oFNI3ETW5VrhhPF2Qo1/AZrqOaaww3AWFTu4rGhiv4ft3lTGxmmCRHBEZf4srzZ0lVTxK3l4cfaFYy4ATtMuGM8d0htPDns63Hf70HdgLgLqQIb5fvcAgjIl25tRo1hjVtOGHrD7Zgxx5f7xqjMawUPD0nxbvEdpmsWG3Js3gfDgY2ys52otZDSwBJNot7RNX03Xxvxcn5FhDknhn5iEyD6WE9EDCC/em3hjupSMsA4Vv3noiJkmPNEx50cUIakqPi475FjZL0Xa1c0vk7ZQqedAI+Nqp3xGLRqk2YzTT/zdzPfyYz++3IhbXXVt40AVOSxicmsB1ykkWsAljd94CcZmhQNQZeETJ8ztfEqbYeD2DGn6mAaCcqu4SUsW8pfBeF/d+RceVB/nJbALlyFVvJLLwtEn79hh6v33hZIocVk3khRNkFuUg6SGvevYsIdlHtBZXtcJu0whZuSIXaHJJIpKYzujZbLrXLLaGG8Y8vCX25SQxj7NUgK+PdjsVb+diZi5+xGMIQIfFSUwC0xos/6VcQWBZsNkNDm1MK5uMn1PNJP3u2gafMzmag3ho3nckApyssCWXomDLIwFF5nt2K38kGWZ3qwfQ8idwEQlaG6qHe3wLCaWS633Cyg4NFrgBD+qpWBHqsi2bHeJYUiOQrSV1AZmsYTygoFskvf/lyPwmWMRQA03tQLTMIwJqcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199015)(55016003)(2906002)(186003)(38070700005)(478600001)(76116006)(33656002)(66556008)(6506007)(66946007)(66476007)(26005)(5660300002)(38100700002)(316002)(8676002)(66446008)(9686003)(4326008)(8936002)(64756008)(122000001)(41300700001)(52536014)(83380400001)(7696005)(86362001)(82960400001)(54906003)(110136005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3Cvwqxbdmh0xn8h5SW+yOC6wTLHNY1H51sIAsc3+LQFIwXLPPwtoW1S/B5/v?=
 =?us-ascii?Q?f24wRbD1nRMxuei4hlwiZ9i57ueogzcxdCIBDbihKdVe1slDs1XecsbEIord?=
 =?us-ascii?Q?RD11HMyLt4Mg7fIMAyb4wZGD2hESlNhC38m25flKcG7kcvshb0Kz9guXK4Do?=
 =?us-ascii?Q?0ipCoFCOhkFVQ4Oa+aPgNFT2M7kpBu8uxQWznclgkxI1foz6LTcOOG1AI15E?=
 =?us-ascii?Q?RgbP9/CMG9qFDl+MtE8qdnUd68Rql1GnOujSFmAbUbmMLPPc0mGeOCBBnyVi?=
 =?us-ascii?Q?xrSHOHNaVE44Go3vnKzFeEjpDqKImc0wQ41HHLET1GysSWyT/Qb8QJXogRul?=
 =?us-ascii?Q?msAwFMQLyWpm/0iRlqyo8YD9M0sIX53laSdkDYM8jfRCY8VnyrjsH7tStEyI?=
 =?us-ascii?Q?UdyXW0MIV6Ur0ynOwJcXruyAOClaFc5eTCfKKviEnm5FFlu7aDGnlyzd3rv/?=
 =?us-ascii?Q?cfDMFBe99+g3OK0ww52CjxgJjQxE75TUc/0tvvpYK2kXdJfAgd2OWwwpJ2i6?=
 =?us-ascii?Q?rQM6qCppecdh9mcrW68aisSTJ1YQrQ8lrLXd+r5stwkAVp2EhJcrIl8VceC0?=
 =?us-ascii?Q?RFB4t0ADMvbVXvzwcHl0lFp/4pJZKvtKEBy0qjz6GlVX0tF9BsFSGda1UJpN?=
 =?us-ascii?Q?z6c/A/BS1AOvHilaHpINQaJRKPe9nhGpnECeMKF/ZKGVq+ipFEeYYfg+nZ+D?=
 =?us-ascii?Q?5tJW7ObokEBN7J57TcjOYrWMTZ+CgHNAuV7H1luqVpi0sdIoXpzh/WlrI2Hp?=
 =?us-ascii?Q?cP+aVzsBm7pkMXxC0Ztcd4mxmOTdYgsyEZLWt2hU65GbaoXap70nFMWe3zpm?=
 =?us-ascii?Q?xIq21UR08yHzhvI4ozvrY4aoa9252DE6lvve9M4njezlGnVDmyWeIJryMWsT?=
 =?us-ascii?Q?xHHfjXnEN1BNeR4MRWPeKlBti7j8U/w4vVodz30SzBncdTiG8FaM54L1L3BC?=
 =?us-ascii?Q?FTOAJpGyKuMv4h3fei6iyMASOMMdEImY6z3svki7vWh0V3EFq8lVCBfI11Ep?=
 =?us-ascii?Q?s+EbQ69E+QIk/Da5TtNgMbBAgajGUHrXBroY+xAMLM2Q3NaAcAr+plBYiqJ8?=
 =?us-ascii?Q?zkSr8ygkpoNE99VT4g9brbHd89OFvb4XD/IbHNCOlMSO9MSluNV3Y+w2jj0o?=
 =?us-ascii?Q?KzOKHfrAl6823Vw0Kc4g5Z2Xxda8gJTes7ACIgeTi80YPlcgu4D56iLLDJA4?=
 =?us-ascii?Q?IIjeGMMC5EyNHVPswWVU8pehOU/VvnIWMMEWieM7r8QOw+0aMHrdSNMJQjhK?=
 =?us-ascii?Q?RwzCehrxcmdEPFJA0olrTkP3AKoUr7vG5D3hvlLIuTVzf7sMyWAhsHsZ/kXq?=
 =?us-ascii?Q?sleRTbLfGElp3IbN301m46ZozQsM8sL50WsLErp6KMCh2BYS0CKhkLIjnGyi?=
 =?us-ascii?Q?Z62x77dK2oVC9L13Am2f4nkUCwAJxMdlQnYGjYeIM9fjueLvmvJFySNT3xu/?=
 =?us-ascii?Q?4JUDRQUG+STDMNJNsYZs+vq7r/Ny/Llykf8fuM0ZrES2RSbHzstIIMDSAQ4f?=
 =?us-ascii?Q?PJ0mXAwWY4ijHS/2u8Vq8SemPIBXCiepXhIXoo97zZ6mEpcRehMPzPvCzheb?=
 =?us-ascii?Q?ocu7iNLDx1RvzrebS1ePTHYrJPgiJFUzskQQL3y0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a1dee5-aba7-433b-612c-08dacdea7c16
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 07:07:01.3604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IfYWxuP4F8ArQGto47z2YKM249hoog6mMxIuffOrzTo40MfEB7yDNF+QnRXFuTR6n3G7aKGt4mOXfju+aXT57g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7464
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

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, November 23, 2022 9:49 PM
>=20
> vfio_iommufd_bind() creates an access which has an unmap callback, which
> can be called immediately. So dma_unmap() callback should tolerate the
> unmaps that come before the emulated device is opened.

this should first talk about how it works today and then why iommufd change=
s
it.

>=20
> To achieve above, move the protect_table_init and gvt_cache_init into the
> init op which is supposed to be triggered prior to the open_device() op.

what about below?
--
vfio container registers .dma_unmap() callback after the device is opened.
So it's fine for mdev drivers to initialize internal mapping cache in
.open_device(). See vfio_device_container_register().

Now with iommufd an access ops with an unmap callback is registered
when the device is bound to iommufd which is before .open_device()
is called. This implies gvt's .dma_unmap() could be called before its
internal mapping cache is initialized.

The fix is moving gvt mapping cache initialization to vGPU creation.
While at it also move ptable initialization together.

>=20
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Zhi Wang <zhi.a.wang@intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/gvt.h   | 2 ++
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 7 ++-----
>  drivers/gpu/drm/i915/gvt/vgpu.c  | 2 ++
>  3 files changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gv=
t.h
> index dbf8d7470b2c..a3a7e16078ba 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -754,6 +754,8 @@ void intel_gvt_debugfs_remove_vgpu(struct
> intel_vgpu *vgpu);
>  void intel_gvt_debugfs_init(struct intel_gvt *gvt);
>  void intel_gvt_debugfs_clean(struct intel_gvt *gvt);
>=20
> +void gvt_cache_init(struct intel_vgpu *vgpu);
> +void kvmgt_protect_table_init(struct intel_vgpu *info);
>  int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn);
>  int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn);
>  int intel_gvt_dma_pin_guest_page(struct intel_vgpu *vgpu, dma_addr_t
> dma_addr);
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 579b230a0f58..cb21b1ba4162 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -322,7 +322,7 @@ static void gvt_cache_destroy(struct intel_vgpu *vgpu=
)
>  	}
>  }
>=20
> -static void gvt_cache_init(struct intel_vgpu *vgpu)
> +void gvt_cache_init(struct intel_vgpu *vgpu)

those are local functions. Just move to vgpu.c.

or you can remove the function wrap and directly put the internal lines
in intel_gvt_create_vgpu()

>  {
>  	vgpu->gfn_cache =3D RB_ROOT;
>  	vgpu->dma_addr_cache =3D RB_ROOT;
> @@ -330,7 +330,7 @@ static void gvt_cache_init(struct intel_vgpu *vgpu)
>  	mutex_init(&vgpu->cache_lock);
>  }
>=20
> -static void kvmgt_protect_table_init(struct intel_vgpu *info)
> +void kvmgt_protect_table_init(struct intel_vgpu *info)
>  {
>  	hash_init(info->ptable);
>  }
> @@ -671,9 +671,6 @@ static int intel_vgpu_open_device(struct vfio_device
> *vfio_dev)
>=20
>  	vgpu->attached =3D true;
>=20
> -	kvmgt_protect_table_init(vgpu);
> -	gvt_cache_init(vgpu);
> -
>  	vgpu->track_node.track_write =3D kvmgt_page_track_write;
>  	vgpu->track_node.track_flush_slot =3D kvmgt_page_track_flush_slot;
>  	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
> diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c
> b/drivers/gpu/drm/i915/gvt/vgpu.c
> index 56c71474008a..036e1a72a26b 100644
> --- a/drivers/gpu/drm/i915/gvt/vgpu.c
> +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
> @@ -382,6 +382,8 @@ int intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
>=20
>  	intel_gvt_update_reg_whitelist(vgpu);
>  	mutex_unlock(&gvt->lock);
> +	kvmgt_protect_table_init(vgpu);
> +	gvt_cache_init(vgpu);
>  	return 0;
>=20
>  out_clean_sched_policy:
> --
> 2.34.1

