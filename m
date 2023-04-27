Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6F66F00EA
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 08:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243036AbjD0Gjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 02:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbjD0Gjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 02:39:49 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792E2ED;
        Wed, 26 Apr 2023 23:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682577588; x=1714113588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SnatlnQswhlzgKSAXFq8/z2hM+SUtJitocnSVL2X6tM=;
  b=ej45xnWDMf6cAdjnw5/g5b35/cs4UYtKzZ4vg+BsvM4Pf7QzcpnSE6Wo
   0dQMZXfbs1J3Jg4pf2cH2FL7yLbpcQI4bt3DWqeWxrDadTgXb2nLKg7hp
   aDGWGMJ+QjdeO3D7I3bokPLWtP7N0sK4XD99i5of7RHhyHUq+Sd2V8t6Q
   bBuL5nW8ws0ZOAsid37X2AXvBzmLKaSkeVamVBLj7SIhPc8D0+TVu1AG1
   KjSvPK8ZAOMH54yOEzYw0mnPI2cfg7QdVi2wJ8T8Ff2aIlAMEjiWdeCEk
   +q4SQkmz6T8wxJe6anfuiYrDBP9KQWvwBcJDjWme5DYmmD7IMh290wcXt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="331595304"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="331595304"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 23:39:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="726911201"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="726911201"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 26 Apr 2023 23:39:45 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 23:39:45 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 23:39:45 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 23:39:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kEJ5ViBlcLDcWEF6FhIkA18vysXmn+7DPIuh05DAxRh4TCerzEOeyvBzFLGvZeqUJNIkOU/atMivkUns0VQNU41vh1+vdFSYwTCSibkZloJGB2LajLwTYw29xN1+ak9GN744jfJkMu+S1/e/MsofTFhLLQc1jJfU9N4E8FORm4Q6ml4t4hFpGqwY0JZZ3RnogSel/YwVfCLGNkyqfQvsmSljKXl0HJeamCIzHkTa2IVDdl7wF4JtQRnZ/XEW11PmA/NZjXkbMnP5S62N5zlJMttdu5VmerSryYjCt9XoXZfCIOXM1zt4ic68xF9LmdVJwWUKj+E03Mpt80P1QsYvbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SnatlnQswhlzgKSAXFq8/z2hM+SUtJitocnSVL2X6tM=;
 b=d66RAiZIZuF/YMHvDyuHq+hp9w3SR5izAv/aG8jQVi1sBz9y/JN8bAV86RrObK6MMLRzaq5Lo//YIIhZozvFdAXj6VkahM/C64YRRi5uz6zZB3h7Uf4icsLM4Zz9vnJV4j30Gb40aTViAqHYD+tjHSZ/AKqKL8q1h6WzZfg2ZpqofVRcohsfFImMDp0SxNJitu2oKCqwcyxnz3/VqcZRB3ZC63TBe7Er2dsRa1tWndHW3bIqMvbk8+4ywUQRnz6ota1r98iJDOt3h5eM/PeiUXOZ9PK1J1e10SsytFhSHlC4GAQQAQMDvOKGNFE9U7+Bhv+mlLDUEHLmeRpsCM51uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5615.namprd11.prod.outlook.com (2603:10b6:a03:305::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Thu, 27 Apr
 2023 06:39:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Thu, 27 Apr 2023
 06:39:43 +0000
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 4/9] vfio/pci: Move the existing hot reset logic to be
 a helper
Thread-Topic: [PATCH v4 4/9] vfio/pci: Move the existing hot reset logic to be
 a helper
Thread-Index: AQHZeE8Gq8c2d4d7/0mM6xGsyyGVJ68+tWNg
Date:   Thu, 27 Apr 2023 06:39:42 +0000
Message-ID: <BN9PR11MB527640502C89C4B41C2BB6AD8C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-5-yi.l.liu@intel.com>
In-Reply-To: <20230426145419.450922-5-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5615:EE_
x-ms-office365-filtering-correlation-id: 2492bc36-e625-4495-de74-08db46ea2f07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9SQk8K9tlbcEulSCLRlaAPUpPnEGq/UIvBeId3R+/BmK8g+7DfAleQjnpTScoHIygpaDqaO9J4g4U1vgP6l2VkuBi7xWppp++Mhyz2Ye/B/DFBoKAidsNMWC9NI9EpKxPLl5dbhYHqUMp7S5TJda8CHMLAtku6ez4TwI5Ji6pCccOKZB3ThDn+iLsWzJP4IeFJcO/c+qIBHqRKT4K3nzEjeoRMKLBZ5v8uUblSeovFyL5aB+vne8pPQqFrhIjCfj+Eja/pMW39cMln5cYcXrDyvvQWcGzqnGQEtd5sNlqhQPdRjAJuz8TcR0Iq/JoV960Ha6J/8wrkVbYhb/Pi0Zh9I2woOA1MFM7K+7f09h+hROxV+SzWDWyhztWPAV5azB0qmPEPwYT2m0OT0OwuXiU47ZgTOfLB2IOYqWA/2AkBov5yju3D2MBpIn70PcVGso7coWAPk8lQwIqtT9LoD7RT9+MU5QXYLGgg26fHbDJIAE2L3vr3hy3NjvUZ+2xEOVQVZDTwwGb9P3L9Crh7eSJgBg1vil6WiA0XZ4bGvK2EPSpTy9RbAezdfNfhXfG8ZKhqXXlm6srxqPiZSYedmNCaIP2hka5yrIk17qVGX9x6c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(82960400001)(71200400001)(478600001)(54906003)(7696005)(110136005)(186003)(38100700002)(66946007)(76116006)(66556008)(66476007)(316002)(4326008)(66446008)(64756008)(41300700001)(6506007)(26005)(9686003)(86362001)(8676002)(8936002)(33656002)(122000001)(7416002)(38070700005)(55016003)(2906002)(4744005)(5660300002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gqL6U1BFxZkUW09auevw+i0i6tj7VTwgGnvl+iJLQfuCjhG9W9O4TwbRtuVj?=
 =?us-ascii?Q?tsaNBBpAeDnqX0JpMxwYnssaMXr+bLlS/qvadJVRBXpdpeWkZyk8CIGstrj6?=
 =?us-ascii?Q?BM7P8KHuS5q1dbJajRZ5lcKf5KIGgi8tQ4syMV/V4sgzyt/+P9LeLkKPlFzh?=
 =?us-ascii?Q?CMOxWHEJqrRqZms1uwYksDN6iYbenS1LI1Bj2emCkWIZ5mmXGXrOAegO+VgS?=
 =?us-ascii?Q?d8Tk+hkeH7gg/jhUkHXIKrziz9h6N1Tpy6Bmkbn0e+t/87V5jBhSXJLezHdY?=
 =?us-ascii?Q?4aukzT04eoilRcNjNQlmU0oA3bMJEyQaipLmyEih+bdQllnTob9jDtqB36iU?=
 =?us-ascii?Q?vrkJlXCNlIyE/5EJGvjH73LuL3N/IWnet9kFEURnBxJ2kHe8UYotqIzqWrDC?=
 =?us-ascii?Q?4fuM/ozCXEqs97Pr69kwTmPsRXBct1nuWqaVf++3mX6ZLSWMFzF2dSa9LtRC?=
 =?us-ascii?Q?38y8bjYBSMYo1vWgHYqKJiwKPf7/jwOjnDpr3QzltFsvSwQedQ4l6GRykXs9?=
 =?us-ascii?Q?Ayi6ss1hKCJhq4lrHljna00tIg2pj4xeFtTPeTIWN9rCKq52kX7eH6vT64X5?=
 =?us-ascii?Q?DrJv2FonuXqn7YGfxGc1F6/qdcdy1JSih1Ha43A9T6tHMp04gXsftlmF8Bab?=
 =?us-ascii?Q?Kw9x1LiXKnmCsnDHVqE00j50hRD/4Kn+E8ZyAlJ9oReIJCVaq+gL5hWi9otj?=
 =?us-ascii?Q?9KXurBueT9Q68OrTjRp/Syk6GG3akihwjw0SbR8NXK4jK3NYmf8nZGoX7xyX?=
 =?us-ascii?Q?H46hRlBKHdb4SNmF6soR7HzGfWDEnM+JcvKpAB+3rlVbXzE+3gxvxpWLO97s?=
 =?us-ascii?Q?3d9vfVCB4RZnh0yYWle1X0RtZNSdIMv4As0+KqwCnU9qQ/t6XrefVCDdrSGQ?=
 =?us-ascii?Q?Cn1Z5NJW2ql7PDMdV/fd0Qrs112wYADJ7hnApFqlqc/bMJWOj+pE7zuTpE4Y?=
 =?us-ascii?Q?MJi8I3rqn5hEizH3lt1Fw1tgQ9Vup9WPcJH6QbHLo9a6DedRUNk8tEkw8NXl?=
 =?us-ascii?Q?9s0TyieekroAjK/wpH+MJrZVZV02nKQ+BY7HfzYUreaJScJhbXdptkXmCHxl?=
 =?us-ascii?Q?M4oABwgxD7SEI11hdC5d0OWGqcWhdzWXzpSJuWKRGwer5qL7jvomgcYty5D/?=
 =?us-ascii?Q?zrr1DMoyHXYRi+ofmmxt1iSw4bEUgrvIFZnDQmMjil+ObT/mj9BpSxoPcDuA?=
 =?us-ascii?Q?3S5RNwPqteWwwCn/rwYxPLMAUBzeR3OnNH51Ulus+arHaFtPs6oaaaMSac8y?=
 =?us-ascii?Q?Sl/Mf6eL8vekD89QzYigEYplVaDl2r5qpZuTErdzG3oOvW7WgkPyW0pRpi7s?=
 =?us-ascii?Q?gIXXIcHhWizu0cKEc0pd511JH0f3jguwW7jDVHI8TtrXOR/+aUqgLWhPJZPP?=
 =?us-ascii?Q?rh8tOCv9B5f6eHJtTVAYVlubiy/2dW8pAghf0eNGt1sU0tnnUKY81Eavt3QZ?=
 =?us-ascii?Q?1PD2RWtG7wTKqjNljPSlTTD+V+iE6sEo5DDueGogGklHbgIeKT3bqQhULgT/?=
 =?us-ascii?Q?how7rJ4RB2j54COEaOKV1MQ7iv3DFUGpoqf2NIkaxJy4OcAXebewHOvhMJtx?=
 =?us-ascii?Q?Hx36iaWXV3zo5r4VKZSkixZFZo2A8oL9jVVn3kDH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2492bc36-e625-4495-de74-08db46ea2f07
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 06:39:42.8211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HYXdbNkmWjp5tClNZdfScvdP6Vz6nhrQTgLNVxhU2Aw8F+S5ghF0bbbu0nhqxYmgi52uV2ZOFOMmFhBGHbkThA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5615
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, April 26, 2023 10:54 PM
>=20
> This prepares to add another method for hot reset. The major hot reset lo=
gic
> are moved to vfio_pci_ioctl_pci_hot_reset_groups().
>=20
> No functional change is intended.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
