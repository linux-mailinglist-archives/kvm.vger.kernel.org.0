Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17097804FD
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 05:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357801AbjHRD4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 23:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357824AbjHRD4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 23:56:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725D43A80;
        Thu, 17 Aug 2023 20:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692330976; x=1723866976;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XzzTJiYRT1PDHtctpm2bpL3Ld3b91mmv0eFdiext6lA=;
  b=CH5Y63obGrJ01NN6Tb3IKczZKkiNjZ9RPHA64BTJucPlHP8Vs0FZocAN
   Ha+K6uRKiJyCbjCT+5thWwPi9u/FXgBI6wE3XBfXJZ3N+j7LgrWQxYYb0
   iegnW1GCeJ9o/Tveljfr9w2eJWRy6p72J8Nqg0iEudlhQbFCQfL64iKrb
   iNPqqNT5ViLpmzBe5wmGjk6hLocXCYknfEXEDdR48IZbRMO2ywCTSaCgP
   Z7oebWKoD/kQ+Pql6+cdH9Ehcj9a32LIixUKbh40WVC7wY5fUjmAZTzGj
   JWFGcsoD7ziCfXzCV63u30IHWz6l4l0B36D0luCAJlcQEuaQn4BeCa3wd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="403982943"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="403982943"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 20:56:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="858521915"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="858521915"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 17 Aug 2023 20:56:15 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 17 Aug 2023 20:56:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 17 Aug 2023 20:56:15 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 17 Aug 2023 20:56:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDTn/w55HPFSayxVZjhTdbFvDRtF0bClecdbo3dCO4483cIIZ4P5T973Bv2/GD6m2dPWHijKZumgU89l1/RfFLq1QTOlf+3JNO6pGDASGNTTgHBrYg88WvVDBBDTIRJgKzDw4hekjGENhuu4HMY55Uzv+KPoJJQJSAIECQ7t5nnR7jZEpaWbNel047oEhhaUspw4rvC3OkYOfvxdUI7aKolsIHhnnVQ0A2sl680XaqQHaHyavObyxckSOxmWi4sa2xMnxg+MO6xOE4cxi6YE2QD45fAR+pVQTsgzJWBklytRLjxx/xMSfVVKjrqCxK0srxSDy95LQqY1rmOt12blbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QF/pJa/JklrS2oVphYVsGGwULv5BhlW4GP/So9HD20=;
 b=UNiN2dxGqZxMpSqBdqkWJqW+Mh47v1qauwchSzK3BzYtnOn672V64NYcBSzNIfJ/u/vB0XSoYI0tqeA0dOARepD8EUJoFTD/w1qhmW0QRVJP9/gtJojtheMjkRr9tBgLs1NGOuWGQ7KpB5m8kENt9sXqTYMn/JsT4rxRmLpr+mCWw09RHKo7darVuDZYwDd8g8kIKC1a+aHjA3N8+G94+GBEWil3bQBuJCU//43Pn/Mf/bWQBw18Rs1+2uM6o8YMn3/85eNDjAdrzkw1rvHKpnbTqDYMWIUr5t8jGqA7LEY6UtZWqTZdppgWCs55MTX/KAXJi5RZGb/ESlj7WyX1Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7713.namprd11.prod.outlook.com (2603:10b6:a03:4f6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.29; Fri, 18 Aug
 2023 03:56:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6678.031; Fri, 18 Aug 2023
 03:56:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] iommu: Make single-device group for PASID explicit
Thread-Topic: [PATCH v2 1/3] iommu: Make single-device group for PASID
 explicit
Thread-Index: AQHZzk2NHVN7+Xla/Uen90/PQyM06K/vcbqg
Date:   Fri, 18 Aug 2023 03:56:12 +0000
Message-ID: <BN9PR11MB5276E3C3D99C2DFA963805C98C1BA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230814011759.102089-1-baolu.lu@linux.intel.com>
 <20230814011759.102089-2-baolu.lu@linux.intel.com>
In-Reply-To: <20230814011759.102089-2-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7713:EE_
x-ms-office365-filtering-correlation-id: c8e72413-5b09-4694-1600-08db9f9f1046
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E1SUm+0DgVcnd2tppP5VvAvEwZSVYa8H+yQc81GhcHyfeaSAMN9HDAmUvHQw4Xo/QIgU3ghCF/3KVZzOZqs1oZ317M57vCtIIHRdVzaC/WBitq5vKVTEwtJzoDsm15JXzq9UV1S7sNewS8ekp7QRxk/f3pVw8NJiHc85B9itRrRBWk9FU2T90fGk7MQ12X+Inzsyw4pdJetBdNHQ/bdcr4My2oTUUzTO5hwtvD2G2cJwYZgYlZhkbnrvj55/sUblX0svQ70A1e5D19bsRpu3obyGbp9vkfpHMY02ooDYu6yMsskny/ySMIRwKEqp08ya8QKhzlknb483/88oHU4o7nK1ckI3o0I+lIPWJy+HDZjklRvo5tyDb3jS0Mt53sUGWsILdgsI0DPkx35EuOGLBsaoQP+FZs6BQKx7GFljIrmdPFQRL9zjarX1Ui8uH2IGykMcIaPDv0ITe/A8zDspfKCKkq1CBzatUxIp8APSNjTqh22MeCLOGzyriG+ylj5bwRwAid4jtLgc1Ia52yKqABVqap8ckmsCYeCb+skxpaMaEZ2+UI45mqg2Sc7a5nUivPQKVIqH2fOq5Ly4HKWBkYS6IkpvI/Qd5UcomLZBInr6VFmyeTGzZ6jtm/uHRgOc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(346002)(39860400002)(396003)(186009)(451199024)(1800799009)(2906002)(83380400001)(26005)(86362001)(7416002)(478600001)(6506007)(7696005)(71200400001)(33656002)(9686003)(55016003)(5660300002)(52536014)(41300700001)(66446008)(122000001)(54906003)(66476007)(64756008)(76116006)(66946007)(66556008)(316002)(110136005)(4326008)(8936002)(8676002)(82960400001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?v7eJP9mA3U4TD8+bdzXTGVNhwyWFsJaTvTDf6WJUzPbcQmm3zgerC9P7MoKK?=
 =?us-ascii?Q?UQdt3GdD3Tnpe64TBj+ygydXVkP+ISbM+F6bnK9blMhIBlF92ox27sM1mvV/?=
 =?us-ascii?Q?Qd8B4NYtDioSSPvEclJePbZ82UqDw7j8kz2jDlUfCF11dx5a25vU9EWX2ESo?=
 =?us-ascii?Q?Dv3bOAl6S3HikJ036JVt5Ub7cPQzUpHXsgzYEnxAWqrGj5oJ0xRGyCHTkI1D?=
 =?us-ascii?Q?BJ3bNhM6F1/DyzjGcsmoFch3MnjAVvh0QgciXrAeYfwVm6Orth1jtUJrAdrh?=
 =?us-ascii?Q?3Da1JVzLZG1qmzLkA9B2QndSvzGp7v0HOUjiDaA1r9FP9eLwta6YLBCpEoKs?=
 =?us-ascii?Q?p4d6ArHknOa02w8RbDdDp8P5Fr9Tk/IAiEFiJJgmZgK7Zw+mYttJKqfgozgt?=
 =?us-ascii?Q?sdNprqe7jDa6W1TtUsthyCipefEfTmTGnu78kYFWRAKCr2Jk1dkwc0NULKIz?=
 =?us-ascii?Q?j2pmoXAfg6WtC7myYG+bgf3h7tdL7jGrBhGPzmcfKcPEjtiPw0K09I86wzL/?=
 =?us-ascii?Q?0KbaORbDNONrC6iBwM0zb6u59SW/+p11GFuB6b9eZpv4XexqTH5320tgEeAq?=
 =?us-ascii?Q?4xHMm7OV/tX4+p52kWW2Q1h+stkIvzg9HkoHNvj9yQ2XEPY1hTd+UFVjk2lq?=
 =?us-ascii?Q?bzxqwif0z/mHRSs9G7D+K+jvQiyJELgBAj7U2TlVQcT0iY1GJYcNPbAhagxZ?=
 =?us-ascii?Q?Xrecd+3mrDLPCu1DIjquvBuCKENM8J5yMTIjVqkr02EEKLdi9UENzrXsRh91?=
 =?us-ascii?Q?mpgH7sBlN5ZeYuC1BNCZIOZQJTPW/IFF85ybr6/OSurd6AwsIqSaONXiUQu3?=
 =?us-ascii?Q?WBpVNm6kKqXLjSA6fWSdkuF3PL9D6W8Deyaq7/wB+sWnzWkFmDGchsuXjDpg?=
 =?us-ascii?Q?CWDvcaZ+/Fxuq7deT3Bf2bFiapvMU9jcUZnXwmIq94PsqLmLm7+Af1uQClg2?=
 =?us-ascii?Q?pEwEU4S0W3XP4f2/b6V00C15pZkLofubwGlSXrk3pXMpi5N/l1X6ZEj5225F?=
 =?us-ascii?Q?qILjHYvKdIrGRA4+9ZIbQVMqRIsgq/fWx6y2bZ/KU/brlcD1V55Q84zUY+DU?=
 =?us-ascii?Q?NFSM16NESsm3EKFFlBqnGVWOXgrnLwAjqotsYiZp8JZiqqGqkXtH8UHncQyZ?=
 =?us-ascii?Q?rDcPdlaIQLKoHpLra8ojZqsD8ukNLXlraj7OFoU6inmk2EIU2y5PZzvWuK6w?=
 =?us-ascii?Q?x9vihYFhOeGKeI3dSEnsTYLtNcfP5koCGv8cuhNftUrPV2StV6+7ge20DDlR?=
 =?us-ascii?Q?SW3yWj2xSKMC1VEZku3EBATPkckH8aLH4KRYwE9pMCs/XcrJNZFcI5xTQUj1?=
 =?us-ascii?Q?3mQcMIkAcdnmNxbUN0mFgrKh0+28F0sLkeNesZQop9ocFsebGUpritFMFrvS?=
 =?us-ascii?Q?+RmxdlX0GodwS53TsXeHpc7jvZMM8w08BlRg/wWcaFSPggUAAE4yvkLoD4xu?=
 =?us-ascii?Q?n36N9YW/0qRrMOmNRPXN9uy3SorOrn4E7jXgEF1z2rpHEPNdIl2Ctg6ayr2W?=
 =?us-ascii?Q?Yc5ZcrjeyL/irHKl+rI20J+yI3X027hFMLYLUTir1wI/T+9seIM46X4EPFId?=
 =?us-ascii?Q?yySIZcJ0RDmWyTCs8zs+cFKdQN8FnCXzjrw2W32N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e72413-5b09-4694-1600-08db9f9f1046
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2023 03:56:12.4386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H94hAur8a+jzjEaoojRWalMLE//CbZWMjJEFs9eGmGWs1hreLtKeg4Oh5AN9LOCbyYVEz9GVuQJVB0KrrxoJ1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7713
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Monday, August 14, 2023 9:18 AM
>=20
> The PASID interfaces have always supported only single-device groups.
> This was first introduced in commit 26b25a2b98e45 ("iommu: Bind process
> address spaces to devices"), and has been kept consistent in subsequent
> commits.
>=20
> However, the core code doesn't explicitly check for this requirement
> after commit 201007ef707a8 ("PCI: Enable PASID only when ACS RR & UF
> enabled on upstream path"), which made this requirement implicit.
>=20
> Restore the check to make it explicit that the PASID interfaces only
> support devices belonging to single-device groups.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/iommu.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 71b9c41f2a9e..f1eba60e573f 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -3408,6 +3408,11 @@ int iommu_attach_device_pasid(struct
> iommu_domain *domain,
>  		return -ENODEV;
>=20
>  	mutex_lock(&group->mutex);
> +	if (list_count_nodes(&group->devices) !=3D 1) {
> +		ret =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +

I wonder whether we should also block adding new device to this
group once the single-device has pasid enabled. Otherwise the
check alone at attach time doesn't mean this group won't be
expanded to have multiple devices later.=20
