Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B896BDE91
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 03:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjCQCXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 22:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCQCW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 22:22:58 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D003FB81;
        Thu, 16 Mar 2023 19:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679019777; x=1710555777;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hW/8vWOacqtEZlWvOS67NGwWsCqCPag6oelYthl0Mjk=;
  b=SKq8XX7t1PGwkauc2DDsVR8ZL7I6yNzrzHhrIWPEtgUBAOygGdCvSR5P
   06FIVgCly4Sb4dPlf6f7aLsvLsqFE9FBwShDKFYJ1Fy1rsM6pmbXgO7lZ
   3OdFPpfw6xr9ynO+BhxpAT1CQccV23WRjgeeDGnrFuXgCIWcy1Yu77kIJ
   nOVOKt6p3B2NWy7FAQ5Qcmvu6+1WQfWs5s1NRTDrSCQ/Rh7Bd0uGgcS18
   b9lPaLzKu3WeljhpOv1FTZ2LyTgWVoN5CJa7q2Jz3Pz9I5mPOcgx4ifns
   faBc2yTduGqz23ch6xST5RzzJwljWbMV8xh1WzhNoMnRoe94vdMFS3tvA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="400745054"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="400745054"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 19:22:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="657404841"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="657404841"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 16 Mar 2023 19:22:56 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 19:22:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 19:22:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 19:22:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6VGkrIfCPRE8PfFT4H7/wMjnMkkyp/5IIQkYx/QUWtIQC67ehRzTJaaP4fGKsUXmr/QL8bGbKBcwgkQnBVpuN4y7ez+q2secsPnq6V/trJ4BnzvlKkJo29dcVh82xhxoEt4U1BVFgf/Y3O9MeRdW0Wx56iiq7KJTtIEEJnUdQSbuaUr/8pBKyGDP02HqizkAU/dWB8WjbW1Fsp3cSkVeZ3EfK6kE7bXf37OPuEZOrLd33aQwIjl1mM+R/D8VKyQ9B+9rF3Jnkncs3lBQgcui0UzjMOMcqypBD8fTLnnAw3GHf+dYvevKC1DR6GpDq2ZRzpLFjf3uk4jP0ncdNpaGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dWdzDAzwCnoDGHuudBqcDZdivPOEtzaZRqnki7iekNU=;
 b=bxfprVgxvzHZZZb3zI8OgvQvOkivCgXz0vXPO7xcyiy5uuh4HWqBL2nDJ4Ks4/sUu4bWO1qWOHQgaBFWVFNzAGFe5elXvw+nKDKMPeYQFDbHdBkysDflwMDvKu6suN3MCBEfrbxzOGVFq6sGgptCLFsXXEwrtH6sdJT1sfr+0bI3rf3doGQWOJpFMgRIPxfrd/XKLrLS0f4Yv838hRCgQKpnYQERLaLQBE7sBnWthyVu8yTC1OZkNVM5pLvDtuxAuZ7SPWjboPuAYeTHMT5p4ZJ1DNvXx21fJPny9ybp3jfBtgXt0uaZBC/OlmxmoyGhK5p5Xn6QenXATz+eyOVDdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB6246.namprd11.prod.outlook.com (2603:10b6:8:99::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 02:22:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 02:22:50 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH v7 19/22] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v7 19/22] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZWAaxoSZ7N25IMEGeF4yhlb402K7+Pk6w
Date:   Fri, 17 Mar 2023 02:22:49 +0000
Message-ID: <BN9PR11MB5276A9C59EF561750F8152D58CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
 <20230316125534.17216-20-yi.l.liu@intel.com>
In-Reply-To: <20230316125534.17216-20-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB6246:EE_
x-ms-office365-filtering-correlation-id: 208a988a-8374-4884-8b2c-08db268e8154
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r1sv2vUAU9TMhswErfqcfUj6EiYnRju8nG3AR92JVEdlKTU90vBziVXjlungdrQLeMbsCLzhcYMN8Sn//u90sKX+Lzbl6PT9jlwu+XzUVnD6kG9ywJAw5KWa0kHK2WP4T1KpOSgROyBADt0B54ZwKUy7GAQkSsdwFTcVu1KgU7Xuunb8Sl772gSEhASP66zbjuD9r1KxGeTE7i2R4/G7G1qzkdexJJD2nGmC6WPEjngUQ6QBbzMbXZS9J7Uhia43LY2WiumHSmBKuHJfHaplnLwmAIAbP65qdenKFJArXLmGj+VcoG2Qp0Q9JXr82CJ18rgNjNJtleQGzQNEc2H9+zqMNJ73XlVekbFX2DwtGlvGcGiaoW4trV86iNfKq/wlOytSpe+TQdYL0KSePSwVCjToDimlL4JxWbDn4DixCHpW9+KtNscBUB0s7lxLfdBJWutIAfNnQPTGApsX/VZP1f/oohiBsawkDdRPSD8hSpU20HnsMgO8QI/Sp4fI6dn0iOCK/fWXssou+30WrURPoLNTIs69t+OW7VysQdQHsW1ZJoFFA07hGXr9B+dRD0z7feZ+UlhSNLL1Gvhl7MB4C4mdjp/ZJ/CMbtcvKcQE8tLpq8Hu+k7JciwTLYE+s2W5dOfaQ/5Al3Kxz9pLk3FPYj6YWNT6gqr2ihQt+wUvXzr/Vxh/s0HJZL+NVkK82W4MYjGgRCMmFrM0eXGNqBI10w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199018)(7696005)(71200400001)(186003)(478600001)(54906003)(8676002)(64756008)(66476007)(66946007)(66556008)(66446008)(316002)(76116006)(6506007)(26005)(9686003)(110136005)(41300700001)(4326008)(52536014)(8936002)(7416002)(5660300002)(4744005)(122000001)(38100700002)(82960400001)(2906002)(55016003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lsjHVal6Q8FRtJR7VjpU1S4VRfnIlgRtMja4sr9KZah2GR16u1iR8AFyCXox?=
 =?us-ascii?Q?qRTG+A49qJHWKC6qivAJUW0m+6FI8ixzI6tWG1ReBK4bL9cJh9eyThhEsKys?=
 =?us-ascii?Q?RWcdgGURfbOyrXPb2LCdBeAXY3E3IEgA8vmmxrpSQD5CZXnklS2En2/qf4CJ?=
 =?us-ascii?Q?QeGVPP6fZhI7gPbDxCxs2JVwdQSPj9/edpS9YFsjJ44lEoSXkCdzNrsBQl4N?=
 =?us-ascii?Q?PS6gqC5O7eA9ZIK8Vh1iDJNEYdGfvcvewCfSLRC9llj9W7BWZEYIP4eYLgTS?=
 =?us-ascii?Q?JwZnMafaZsnJsmxzC6KloygOpP6mzZKkdBJeaRDYNthWo2mIMOhMk42Hyzz0?=
 =?us-ascii?Q?9FQiIEo2j0wk3hS5gkOfwIAx1SJdnGx1H8GgeHwVI8mYiE+59X69suuyq6q0?=
 =?us-ascii?Q?ljQfKgx3a2Vy+VXsySt1d1UU6LMJawY5lQhfnlfmGrkpZRrV92E+B+hJvCiw?=
 =?us-ascii?Q?sLMwvoLGbGNAt85GXmb+4eCmOcQGPO41WmzayneoADXBc+Bh/HbxwOb6zWSW?=
 =?us-ascii?Q?Kpy+uHuPHhp/GIu31oX8kLBV6r1qx2hNZjEVgdcyYIlQZX+VpEHjcW4gFUW9?=
 =?us-ascii?Q?yZJ19uLMCHWJCl3Cp3Yp3neg4xyi8d7mFONjJOjWqxcdv+hx3Rj5iSFqK7f7?=
 =?us-ascii?Q?V4E1E4c/YBln7nac/LwK35P6U7Je9asK1bbXeig+P8fQFQCRrX5PttNGdmH4?=
 =?us-ascii?Q?hWSWXrOqTl/SayShWcHI98Q4IDFtN+2EztZR5uBCKT7n4zbdwwi7D6YQisAG?=
 =?us-ascii?Q?PW/VLxLoXvLQMuzYnL6vqDup1tdwPDeV57b8XkVl5YNksyuv5JvzgyMeD+VE?=
 =?us-ascii?Q?qsGO61Q9SfuNhcw6LffNPqlrMFOpZpbpykRCYV1XRKjjyk6BxaoXYfavneLn?=
 =?us-ascii?Q?ZHTxZ022gWtmyT6RdFBurqLwNDLA7uSqWkvu74a80B4nhPPtL/NHLywefdko?=
 =?us-ascii?Q?G87YQFZgJK4Rg+jNVm6qfajc5O97ME+pUt8cMUTRD9WvMyeLiaBmDVe+ma0V?=
 =?us-ascii?Q?nNVOR2Cke4h6drbJE050yHaxUoeIaPC/WfF8dEi73tVwdIM/KEPfu1Y4JoMS?=
 =?us-ascii?Q?zwsd8kLMUvn8YWdmH3f3yNLjIcAtrUq5yQ1uy89wiAuO7iwqa5fXkcX+er7g?=
 =?us-ascii?Q?VgPyD7HMXxL+To3l1041FCVn2mvJ1cMoHyQUD3Z6Q8Bo+HfhpKixN6rTp7Kn?=
 =?us-ascii?Q?Wdq5RdC4R1u4ncAAsQeChtnRtUmo8gvkQvzdLuAjLE/dRMGQUlAZZNkQC+1Y?=
 =?us-ascii?Q?HzWSNYNcl9WU/zB0fn5AFKDedy096Qe3YdzmKnoVSbLEZVs2LQAH0eisnjyj?=
 =?us-ascii?Q?5ybx747/mEUzYrtsHaWQdj/yckp0Tb/mqOksEGPtl6KxGyYNbNG0fqZAXe6o?=
 =?us-ascii?Q?ir3UndsbZ9k/enmf15xJsdB8EC5B/q+o0h5jpo+arLuesuUmg8/ceog8bD6h?=
 =?us-ascii?Q?oOxpPPKVWi2pRi7z8V+ayWJOfM2RFIjegt5xuhFch8h6mlbUoTWXNRHdWsfN?=
 =?us-ascii?Q?PHLcS9exdnyviHmT9XOq/PbsLizxKHTWkCYoNbkzYuwS3lesRUPmeCJm/uAZ?=
 =?us-ascii?Q?+jMiYQXZyUSwibs+Dj0Ec4rIXOQn7CTk5f30MxP4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 208a988a-8374-4884-8b2c-08db268e8154
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 02:22:49.9445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L/yosb9Xn3r4xccujHgJqdCrjUNPDg4UnlXXP9fDgdKDNp6n76WiyFDex/HAiZpL+tfsiN36ADqm3KWL4g4/yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6246
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Yi Liu
> Sent: Thursday, March 16, 2023 8:56 PM
>=20
> +
> +static int vfio_device_cdev_enable_noiommu(struct vfio_device *device)
> +{
> +	if (!vfio_device_is_noiommu(device))
> +		return -EINVAL;
> +
> +	if (!capable(CAP_SYS_RAWIO))
> +		return -EPERM;
> +
> +	return 0;
> +}

it makes more sense to check CAP first.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
