Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6B76D672A
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbjDDPWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbjDDPWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:22:45 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DDF3A9F
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680621765; x=1712157765;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ubScbNfzDeI7knjYOwWuYNKV+BuML+lqUx8EXt6285c=;
  b=jt3+581KXi25AH0zTw+NC/1EqeXCD6jiqw7nOlzSMtYC9YTM0ipX77am
   VcUUTugYZO/N+w6G9AO8mxxA0iqO2Cntomcn0Nf0mjA4AcmxgdeHeHeeG
   SW2XAVmS0STzxGVPUxQefbPdHB3Y2DHhPur8z28++mSn9Rc31yCdeNHKd
   SGmbZbvghsBkhLi2GoI+k9quwKvgIUSUjrwD+ZtpKh0VPGUrAAWJdlS6z
   Ttj6UwM+sfkxwpybs35cmu9ONGUuSxCKEMmqwKpaWbC5/USYzPjVwm0p5
   5h+j3zAPteXRIw5HjZsYnNnq/pQK5NIFIJ+n2qBPbopQ0pqmcJ33oNSIj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="404979986"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="404979986"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 08:22:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="775676415"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="775676415"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Apr 2023 08:22:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 08:22:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 08:22:39 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 08:22:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMl2rv3cbxm6HTAddJRftj/P3y69/FbW1FJ/4QdjIEkFQJlkJ0pHk+uUE/WhFX5jKFr1nEwwk6PDmrFQTd8NPaqzSC9jKUxAH74mPFaIzuhEf97sWZy0lmqjGrK/p6/OvizX47tG+ENsd8kmujomt2JsYPsaLjTgFT1Yk6VkICpi5AHGpReHJIOvwYrulHxpHxP/9ObSz9/FjR4WkAfV1PM3fD401MwPTLuwnictJL1CTvifuWY6lHmdyVjOrsQgws1C/wYRbK1sZG6UZDksoAvUEqqRegEWoWasWzd+a/wtyoj9tDlmqJiu4256sTEnJPVtrVbqFu3jdAZ0G4rDkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubScbNfzDeI7knjYOwWuYNKV+BuML+lqUx8EXt6285c=;
 b=XE86eZICehaAShbZbp+cbOOII8WsCphPjcHKmEU6romKcIV5nHREdRbs90MFhFt+rKBXgwbOC6yKDCqTKZpDvgzM4xpGI0VucEOnnm+cJJiLbxCW8AZOfg029nx7RW28OXp54KiRaKjkx0XqfIuuOYICHUfl8olCAjz51wCEdJM4LSOvOcrQXQzpx3axeESX0RSf1jxz6+DPxPa99KSrLvfaHsV4vfWVGzyW9q1YjwxjM3KRhy9Amg7Il65LAlAQYvk1g1V6XNrbG2XHGH7qiZN+nHn6mQmM4VqDLcMxdq6lWCIJzhBIdGcjsosiHw9WfUHulBURSz0f1B4TPlqORg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB7246.namprd11.prod.outlook.com (2603:10b6:208:42e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Tue, 4 Apr
 2023 15:22:37 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 15:22:36 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [GIT PULL vfio] Please pull vfio/iommufd changes
Thread-Topic: [GIT PULL vfio] Please pull vfio/iommufd changes
Thread-Index: AQHZZkeeEOJji3SA0UuD+0P/ZgehG68bQlZw
Date:   Tue, 4 Apr 2023 15:22:36 +0000
Message-ID: <DS0PR11MB7529AF6600196E6C7D8D694FC3939@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <ZCr7v8pFz+3rMyAX@nvidia.com>
In-Reply-To: <ZCr7v8pFz+3rMyAX@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB7246:EE_
x-ms-office365-filtering-correlation-id: 71d7fef8-a713-4a08-ba10-08db35206bd6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /rP9z5DIClLDV+TiZmVkbwOzKOc/nrR/7W9awUpTZcGvZcUF8u3k7P6SW3cSrNM6uanmrhXXtxK09LKJugRbWCO4lB3FDf7jF0LHPCZcThzYItVIOOurA9F1dn0HRAQE2HxybG+/uQNp5suoSE0rSsom3rkpcq6lKIn0fMDybJw2W3lVY643dJDNhBYoCMhdJJ9SjRGHQTe3WsonRIew3vyoSnaO552hAYLFbnxtG5Vf6ipjYVV9/zS0VbkBm6wC9vF0SWlyjEvgTU5aCwdfeMnTzGJHwOejP9Qb9yP+64NnZmjUqjywkUmsI4ZVfUWZB3txoUv0hH3G1OITIDYwmbCieDomytb1osjp9jVqecJbu6PFoJ4cFX+ycVshEKgHXk9eh/6SW9aQpWE6kAAvP+89WN2RzsyVaaZQskT+zTvCNSOt+8nlXArWjoOJXjTumsPyUkJVLwTifFKImXonPd2/d138k2COs32nVmHoQUtnqz/uGYT3jFzUekJ8rEUwDgSDnPLmTZ4hVgN0nTHZ5n4be26ZdHxSO7+lrNObSOHbHiFsPzGaZAwRejKkHLIEnFEwerrBsnuBXlPQDJzCh3AMYJ6JSBJ29yo67D9Gvt7aSEvsB9v1J/GnRpE6tlSO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199021)(38070700005)(41300700001)(8936002)(52536014)(82960400001)(122000001)(110136005)(316002)(5660300002)(86362001)(38100700002)(4744005)(66946007)(8676002)(66476007)(66446008)(76116006)(64756008)(66556008)(478600001)(2906002)(26005)(33656002)(71200400001)(7696005)(966005)(186003)(55016003)(6506007)(9686003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G+K/2fF1ESP2drHun+0YqbjPkBWnBVFBF1unHE8Dpwu7LaSsk3PcZLD4gF8m?=
 =?us-ascii?Q?i4lIu0XDlfnPXAKDnAPKjPDnZHd9lnTMEqtNJK3ZDv9A75QvEdMhmZWQxdtk?=
 =?us-ascii?Q?etwQ/0S48L2nHrQ2QxPgHhIhyGbiEvKaHmg1i7/VtBllignNfBCseQTmZGo9?=
 =?us-ascii?Q?sODwOBlaokc6q2rBj54PIjwoRVmMiO1Y/tlrw7CX1eVdm0X7gVEebBFXQbRc?=
 =?us-ascii?Q?7uyyuT1xjJ0MApNA97eung7J5qnJV7+uTx36bexPRBToDyw8Ji9/ZrAXWLkl?=
 =?us-ascii?Q?yxOj6ZqszHByMRvpsEfRI5vlQKu4Fdj+bzhpjNre6etpaD8nWPaVNso+hNTO?=
 =?us-ascii?Q?Pqo2hZ3Sn0JQBj+oxQ5RADi7PkrEkZZk6UiV8JpQlBa233O84V8NzehGFTiN?=
 =?us-ascii?Q?4+g1KlYosE57dqzDkgGdoJSpvskA/6FvIZF2XT4xN1b2MzVmNJ8UObMIk9zp?=
 =?us-ascii?Q?iwItpsYtydFj1WdkmtrfFZcK2xPClDga+95A52xPnPrc4AHptDW+PaebM/WK?=
 =?us-ascii?Q?asBfb0ece5UaxSbmCOiE43XIybD2nBWwi8a4ZmDK2FcuR3N3B5oVoBkt+F+g?=
 =?us-ascii?Q?c8t1tjILBCCu2iIZI5WCZJ4Pi7DIKYPjLVfrWu7JfqEHDsr6js+QGFiNb+we?=
 =?us-ascii?Q?UxU0+j0GMXbi7tWB95gdlTPGnhp24hmsP8LcG/PXk6XLW313gy43H0GywnLK?=
 =?us-ascii?Q?FBfEGRmd/RiVqw1ZQUenvownXNHfOqs5CR5PoHxNcItS+o/BlZomQtNXTvdB?=
 =?us-ascii?Q?3LqkvYIgzHNFz94+Uob8QjvDL65Xo2wwnIXT4MkTUZ51WekCl3LZj2APE/7e?=
 =?us-ascii?Q?oBtX7PdfrsnGZWqjD+nhPXMpWNBZil7RUwDkvOxfcW7eMjIpXUK4SgeNACgX?=
 =?us-ascii?Q?0LJtgbnFaPf30/jQYSRmYbHPVs342Z4G3gsiTscIvcBd2GiXizkhBf9SmZHf?=
 =?us-ascii?Q?r0yyhCUWblfumJIjUhQFEVnBnIEN7UC88+6NyQBij4nY5gSpMzTqKCzbeGrY?=
 =?us-ascii?Q?qkKxuVx4M30q+CCPpWlOyZocAGiGrEKnWinp5SByN/pwjQ+jOSoqvlJfsK3v?=
 =?us-ascii?Q?uOON/gkX92YKoaRezcFoOXd866agJxlX5UfmuYlpxBW0kNp0B2hAGA2Pw+U0?=
 =?us-ascii?Q?qLjZvKoJHMATwJRTTH55IzorTMZF2gepskmhi257gimNvtz2ePairkUM1lfx?=
 =?us-ascii?Q?W//VPkH7YU/KzKVnPqeUrHwz2wzEBrCpHBQQJQDo1yU5a0E7O9VL4q0p5Yo6?=
 =?us-ascii?Q?/ORiUVKBCu0nDjomp2nKjC/VvyPUuK81CixTG2B4PjYnqf4nAsD/MZrY3env?=
 =?us-ascii?Q?ta0Fm3Yvtlya+QaT2nt3gvT1q9/N0qpAsfmvKWQw3ze3YNDlh9r+HSRkMzPM?=
 =?us-ascii?Q?/AhzwhUeom4BzpD4SWixMI5gV4uz7Dq1vlaMWOU6jh1V1/5CFuL01bEvzHh2?=
 =?us-ascii?Q?tWFv/xN0YMNp0GJrMhiPgp+U2o6qPOyDA9F39JJ/taCw+ywBhvmu1vj7lNrS?=
 =?us-ascii?Q?Zl7R5kqJMwkM/pZWkixHNyG2hbkGgzMvI5qL3YeUVLC1+Rnk6mLvnx6yt4nE?=
 =?us-ascii?Q?rzRyJICICsBjA2DtdkM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d7fef8-a713-4a08-ba10-08db35206bd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 15:22:36.6998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZC/f/aqfO5wI7ITOzgJqHgsCKgq8df5ZiDCqwoqzD0tIExn4M6avIFefHCfCvWUmiJK3Auc405RJMNwoBys6mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7246
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, April 4, 2023 12:16 AM
>=20
> Hi Alex,
>=20
> Here is the shared branch for the mdev changes
>=20
> Yi, you should base your series on this commit
> 7d12578c5d508050554bcd9ca3d2331914d86d71.

got it. I just got some comments from Eric. Below branch
is the latest.

https://github.com/yiliu1765/iommufd/tree/vfio_mdev_ops%2Bhot_reset%2Bcdev

Regards,
Yi Liu

