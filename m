Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA245AA6A7
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 05:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiIBDwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 23:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbiIBDwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 23:52:14 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD636B2DB5
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 20:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662090732; x=1693626732;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=EjUw/PagJ8yGAYL3fQJuhwBZD4Ov6E5Nw8oKRQ4qcYc=;
  b=K8x2WAAIxEq9Jpj88LLSwsi4z6GZXk7FNtMk2kdq0T4ZARxtUQjDz65L
   2RE8iJtp2tI4cHeuVzJCKfBU3L3NOR0aSQmoBLDAWyi0e2vZKOZlrwhsz
   dtFQbTIgkG+h/PbHwMIXsgv7wxOFSYu1NAI0wcXU6c1tu7r+zivNlax/f
   0LCaTpgYps38IqiKdsZKaCUf71a7qABsjkklvad+Gb/iHkHwIsZ9JrwO6
   gd9EBGsjb3zghuUcFa4YDYRSywe8zCTL4qbfId/2XQ0WBBfs8HJ5j5yOc
   1gfX+du+A7RiiCv0D/kn5KvLJAqR+1QS5BAhL01WDJnQGHDK9rANSAkuH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="322042300"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="322042300"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 20:52:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="788518018"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 01 Sep 2022 20:52:12 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 20:52:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 20:52:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 20:52:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnPI3U05xOdv7Updq0Gq19iXV99caPA6bJV8Kk8pFchLKeryrJrYoH1YuO96NKPwwEtbnUytVPqbpKEqBlacwlAA0HjOFJBFFqxgr8WgIg4Rk5WePn6y0rvVRYWz4MZwIr15HEqr8Pf3xkc/VZRCwlk/RvjHi2EFqmnTNmDPaLiay4ieMtKed1MNXMTPl5yXueAkKo6u2DjF1MZ4vNtaNmJEPvmv2v6E0nJaS13cbui3MFVhSs10yv9gt9z9LWKFOJ69jwxCB1YoncLcqUX0C2e6FgB3w7U27ssvoYim69DE3GbrMdYOF7jCQ38VPNyk+Pn/3kc1rJmMOLs6N/dBgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjUw/PagJ8yGAYL3fQJuhwBZD4Ov6E5Nw8oKRQ4qcYc=;
 b=Z9Naja0dQHFPffZpGBs+iZweqRKw3CxuC+/cxQZHeIW85oEvHFbSDXBv4QetP9KslyjR+zbEuhKAuN8MuRi5IPWQV1MWBqyxcFCWwP/bXhtFBAqfa7EUL5qdHW1E0gcZYTgwZ752b8l+q17TmRrJz60uq/8FH9aEGerX6H3Z2nDj9l/3JFXRWWn8UCIAwcsK94MSPCpeErLX8hbfVwRNzGWkwaZ7SMju0vTMmyLpf1aLx/VS2gv0bzqk9NyKyDS+ivXN+t0iDdz+AFfe/UNTA6GorWwVBoJtxgS4cvgs6voEoQ4x4Wkn6EudeKXF07fU4hLxR57RGat2hZq5zPAXyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6036.namprd11.prod.outlook.com (2603:10b6:208:377::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 03:52:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.014; Fri, 2 Sep 2022
 03:52:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 7/8] vfio: Split the register_device ops call into
 functions
Thread-Topic: [PATCH 7/8] vfio: Split the register_device ops call into
 functions
Thread-Index: AQHYvNVTia8ESzd9JUCe8r5Xtt0FHa3LhOFg
Date:   Fri, 2 Sep 2022 03:52:09 +0000
Message-ID: <BN9PR11MB52762B5DF515264A95E8C1638C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <7-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <7-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d8b449f-dfef-49f9-0f5e-08da8c968317
x-ms-traffictypediagnostic: MN0PR11MB6036:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G09mhrkyvop6JFbcVcM+Haok35xP540VQ5q55SHe1Ch/4S43iNn2JJd3pn3iLLJhcrn8xc6aBjiV8o2GwEF70J0ttfA7aM7YczRD3qe64J+2upehEpQ7IOS2Lr3cDrIgt+frF2W113hnuxRdAUrwFS3MqBr7YUlf+OCo+pM0ObE42yfo01nCqpDhnYL7t5skImxlJLqrbf8hRy4ioF/9Y8fYjdHXjSUs2Bs9vg4wtjrh4DwAt5dk697F1z/Uq59DcmoGEY077zvAJAzGQj4EQete+IHVGPpZXIERLVJfshqt/8FI4munZRT8Dl61pcgwv9aE47XyeyUhEPTe5uJ44c3Cv7YL7f7BEJbDvb8oiLKXLY0e2QnlsLEFl6F1X9LRxW8s8olI5g7IunTZWu1xn6nAB+ezWJtiGeaqtWRO6rtbKOxgezb35+Bt4cra2MIek+/rSUBPILspnBS3MpZ6S2iCLz7G+MP4jh8EYWrE1XmQb36NJjnBkIEk0jR6phh2HGvMpDMicLt+fC1NSpRWZ6Ru4IbjkUAARCjI9ZHmc55Vw+4C1bMn39V0tzXhM7LXOjU5tV3wgVGrAyHIfvDLjhu9qmNafpd7HbjfbiBNzGRam9i5VCcV1bVzmSRqJwqq1f4HIesB6jJc/xXTKWvtFGLqw4W5MrPBjuZz30BfH9MRg8pNAfVIulCnOhlGdh5AbJ9ukPkHgpe1WbFY4HiSD25+2MP8BWe3Qn8ladQ9E7l2wOHAxzf6qnS7niKVktbMg1x82KhhG/5jottfwJmRuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(346002)(376002)(396003)(136003)(82960400001)(478600001)(9686003)(316002)(8936002)(5660300002)(66556008)(76116006)(186003)(66446008)(64756008)(558084003)(66476007)(66946007)(6506007)(33656002)(55016003)(41300700001)(7696005)(86362001)(122000001)(2906002)(8676002)(71200400001)(38100700002)(52536014)(38070700005)(110136005)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xddaqp32C7ozu8e5vrQcyZCq0YtNWKzExAPLK78xdUl6ptE0oU7y1u1UMzfK?=
 =?us-ascii?Q?Jzyduf+1Pi6D2a0LmmocaM/NRdc472SeXOjoi8aIJRJ7HqXGeUmKaftMeu52?=
 =?us-ascii?Q?wYqbPmDjXV3J03KLLPXjYf3gRyFABDJXEqyvAvsxUNVzkKgot34Cs+WAJK0R?=
 =?us-ascii?Q?fiBBkn2Rnu9DGQ1ZjDfWaMfVKI9h3So8z04Bu5++nbzyz7XBFRkotXK7h+U+?=
 =?us-ascii?Q?oTDxU8A4/ev2bbK9pqxShXk8SeXePaSpGjgfqP4yOZJTl4RiF7Vb1Nk/svcf?=
 =?us-ascii?Q?u1rcOxUX3bdx0XbRl/32UiUMWhcOE8R1Hrxbf5hi+KlYELPaRc39LV/duj0U?=
 =?us-ascii?Q?pQ5QqRZwslMdozzQuoHKBzCn9vDspV/Tj4Jh0w79wuWvtLz81WvxpS56slDM?=
 =?us-ascii?Q?fBFGpeJoDEQVmqv0QjRlk36P5590HvKALaCgWBsIlGxzXCWUMPhXeOxzJ0+1?=
 =?us-ascii?Q?letx3MbrwtOsCzk5EciDwWYhr6qPhimS833dnfCc6/4Au1LUDrXU/2DKCh+3?=
 =?us-ascii?Q?kwTZyyVLOXYgWz16b6dmI+0E35Yh7JHl4Pjx5fEWdCOMCDdQAoAkiMpWYVgj?=
 =?us-ascii?Q?B6u8hnFI1OLlZSgfVccH16o8SLu32CCX0zVmxSjfrMGxRXxrUIIFe3oZFP+Z?=
 =?us-ascii?Q?VdmTWwxZO5eH8dtcbz0yY3Xac8Z1204N9K4tMYxXPathZFTvo15Dq7Pt6VPK?=
 =?us-ascii?Q?niMSaVmSKS42cM6RLDzOjpmPvc4qbXSHMPQdUxT97UpS+LYJBrvoZCmxIahB?=
 =?us-ascii?Q?3QCyNIycYnjObJIoNPsWljWQ48xPhW+qbm0hb0rFNIS6GZn4u5PvhHYKGzex?=
 =?us-ascii?Q?4Cc8Ng/E1jJqk8chXjTXf4xxphfCg2ng4q1+Mr3lq7RW88nj+tjqsbAD7Y/1?=
 =?us-ascii?Q?UN6pJCOC+96QhG28CELg+rTMTAPAYocR4DBxLsVQuKAGPP9Yx4RgN3iiXbBM?=
 =?us-ascii?Q?DJ33gFpEmxpO0Oou3hYSU5oJGwHUL4rP4bUTIOz0MJPAmVCxrfK4DZJfiCE9?=
 =?us-ascii?Q?K0+BucR9UmmKYO54zXKh5nwzc0fHtnZY7vJUGmnD62dFkme97ZpkQOWy7rnb?=
 =?us-ascii?Q?OH5BZb/qy3+jRDyZSK3dyyC3rSy2Aq3b4fhnVG1HvJXnAFzMyDuGIr7GuFS/?=
 =?us-ascii?Q?QjK3/kjxiswcYWIUkezr+QKEpjm3lSHWDQWMPKbUJs21jUSUFwKc3lZl4Ur+?=
 =?us-ascii?Q?zNS44Y/LqIvAesAK6kpJRiG+htbdngk0KoCBl+ufz9MA2wXJaec21V/FzX16?=
 =?us-ascii?Q?gCrKDB/IFIfzYHSbRuHPXnIdprKNe9gTehw9wgfIG7MT4ow5rNgaNTZ7rYhI?=
 =?us-ascii?Q?ZPRT7mRotnLplTZcgkUNOPLYsf8J7Qe7AGZj7vsWo5U6IfkZ1q1Q1apJ5Vxf?=
 =?us-ascii?Q?fy9BSGBpKx9fqfnuoaelQx/jVdUA/mBXj7b/EAnkICK8/gba2BfywDliUbt8?=
 =?us-ascii?Q?Z6TH/lsNgqml/2pc347sG4bx8+M+Ye/kDLEK5pX/xvRLov5wrlLl3x3XASMC?=
 =?us-ascii?Q?jYs3BCJO/M75o/O/C4s4ysyMzjJJ3X2t31cUJrfHM0rF8YXYXjqrb31iJihI?=
 =?us-ascii?Q?z5L/g8AHD0+I8RZsfsdBBExpKCe/0uBvjzdfFYfL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8b449f-dfef-49f9-0f5e-08da8c968317
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 03:52:09.8345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NVlOdgaZB1NXfZGWQ3B/lnXOwZcX3Y3lbkfbK27hHWqflyojyDTFb1Us2fAFuuTjNThfPiTKJwEZQwHLvcMFpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6036
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 31, 2022 9:02 AM
>=20
> This is a container item.
>=20
> A following patch will move the vfio_container functions to their own .c
> file.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
