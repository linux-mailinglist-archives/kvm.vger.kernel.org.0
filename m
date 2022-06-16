Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA2D54DAA0
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 08:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358853AbiFPG33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 02:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344922AbiFPG32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 02:29:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922C6562CE;
        Wed, 15 Jun 2022 23:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655360967; x=1686896967;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ALMW1HSohq9R+EcuJOlef90mw8xioYa4UMKGSXSLgXk=;
  b=UjEqghH7SOZiYSzKI0lxxZ+tViwl3knxauGh73LSZ8/nIo7YAOXg/wBG
   Kg516PTA/Xm5X6a0Y0QuJX13W8kijprUApukwuWm0hDqfTaTPxK92oVog
   Ldkbiuv/bvBQU7fWeywKHqWP4FIvFYyPsgUmsjvilblhJM58Q7HzWfGW5
   ZEEkp843FpUl5Y/T05gii0ys/osvdtSYhuztnyYr+8miInmUdsQHZN0AY
   p8uPSo8FdEs9wgcWnwxwpoLsMJ2UBXqivX4W3gCEuTH7WJV+63sX3smn4
   fqZVdtOKMqrB4vEQlrlQA6Rz5oYuKdRBpGz2mP5reTP157ly7tAF9MCJ+
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="267867470"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="267867470"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 23:29:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="762758131"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 15 Jun 2022 23:29:26 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 15 Jun 2022 23:29:25 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 15 Jun 2022 23:29:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 15 Jun 2022 23:29:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 15 Jun 2022 23:29:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzMzbRCda/FpvjEMylYTLmKFS/emrpRyARh/3IOLcaza1tMwG74oj/knFKoUqSrUzXQWHIpf+ecfIQliybsYZX1vx52niC3WuJWGUlCRm123jTdfHdgZzYUBah0o790EAM/QIvHxvQYYJLIRQUTZPmedqa6CN+EZXV4MUGPD78WfP1qUXByyXJtIV5Qz8YXMuX3pFhm3+VIwnlL+/G2/gm227HlNX9usWezJR16oeR2fS0Sac3+5TYe0Y/axYvaSI6lnKQ1k1PfTDKTZhakDjBlIDRyOAW8JXqp+PHnXLsslNMZU6Whx4zQZEatO1VLB5lYYDtePk3hfgh5yOUB2GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALMW1HSohq9R+EcuJOlef90mw8xioYa4UMKGSXSLgXk=;
 b=YyXflnohkAxMwSMkyOiApZV4lyZwN0mDbsd75MBCDrGB5H9VKdG5C7sWoFOCNrbSaCjhVVqlFAg5CshK+wVbMUSGNiNsOaDY6Q8ZHeipbjQmzEe36XBZfRTPYAbbfVO0XX8uIohjj/1CcoTQqqAgzAGwQhP8orK4qEpX+lOgECkEZRAZWh8jBOZjyoh8A9IX1oMojE/+PTswJQdQP4n7Ub8P1fMMIsvkVCMQpI/Z5duISfyDtnWpp4udD2mdHahPw+yrpf8q69SVE1yFTsdCBPHgcx66Mfmv/aCuvEvyS9T8XcTAsyqMZGgkwoTM+DvGxP1zqLZ6xO9+fa9NUoqF4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by BN6PR11MB1810.namprd11.prod.outlook.com (2603:10b6:404:fc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 06:29:23 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::4847:321e:a45e:2b69]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::4847:321e:a45e:2b69%6]) with mapi id 15.20.5332.022; Thu, 16 Jun 2022
 06:29:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "chenxiang66@hisilicon.com" <chenxiang66@hisilicon.com>,
        "saiprakash.ranjan@codeaurora.org" <saiprakash.ranjan@codeaurora.org>,
        "isaacm@codeaurora.org" <isaacm@codeaurora.org>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2 2/5] vfio/iommu_type1: Prefer to reuse domains vs match
 enforced cache coherency
Thread-Topic: [PATCH v2 2/5] vfio/iommu_type1: Prefer to reuse domains vs
 match enforced cache coherency
Thread-Index: AQHYgRSE5M8ZUAHYLkSGjazAVidGPK1RkoLA
Date:   Thu, 16 Jun 2022 06:29:22 +0000
Message-ID: <BL1PR11MB52718BE8A6D1BC328CE4CF5D8CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-3-nicolinc@nvidia.com>
In-Reply-To: <20220616000304.23890-3-nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ec2f908-9caf-47ef-e70d-08da4f618d62
x-ms-traffictypediagnostic: BN6PR11MB1810:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1810CAF1C088231E0AFE127F8CAC9@BN6PR11MB1810.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YIDsecM2cHpdAPhHvnaLAUyBe8m3arQdamiF+Eerv2BNZi7X0E58llsgKr9EroHUikS/u0/2YC0sbZqDFdYAC75ivmXuS8EAxuSNeqWnvAwqVviq5l+5oZ+NQ9L3Xzq7fB5ygqipoUDbJt7b5YeKuE/t6J7aVmGXh90Q/2oT2XgdhTDd6ZLPwBcs2DNNjmMEeNZQNroH4OR2fTTGGX0ws27E0Xp8UzFQQqwyl1eSc+M3Iu9poVDhY16pgS3JLxsd9an5+ozUSFitjBketmdxIb9tspavtncZgX29DZmJW2LFqAU88Lw2lJOOaMTLqFQJihqW1E1gSoYQ+BUso4mFgXcqovesn72pKqkH/IPrOfDBVUgVewwVZCwYvT6z7Mn0QTBeYh8SqGY0E9LnSCZLtgHTPj765O/2CMwbL5xsxngmu9lIYfeYYSDe5Mw2tue0t8AcxlAtFab7F362EU+e670jw5vuD1BvPuZDL6XX++iB67KAEwCEqwQwAO4AD34TBTqQLREoZmyXeiSQqz8pyd/SJsyhg3aPWCl78t9hNE8Wf8UAsE/Ja5oJMnDPGF0qOOEg0ZrDPeY5e+RjzN80/qUjA1RfbWh3zq9pJ8ysyLB12MtN5LmHAUTIoVtu7pT9dRCh40gPnE8+tnYrmqvmHWoyWebR+5SYJ9jAjhp3AiyRDrtkSVeA+0e9yM6aNIJAF1MdL/SMs7vrdZo41rgKm0lnCsINucxNaRyI3S2Wn7A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(71200400001)(508600001)(8936002)(52536014)(55016003)(316002)(33656002)(110136005)(54906003)(83380400001)(82960400001)(8676002)(122000001)(38070700005)(921005)(186003)(86362001)(76116006)(7406005)(7416002)(66946007)(7696005)(5660300002)(6506007)(66446008)(66476007)(66556008)(38100700002)(64756008)(4326008)(2906002)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3DVTwIkI/UPgq7NAMbF++9SbPdguki3ZZXLDToiKAfIsUPv+Y9ZW+77wxAFX?=
 =?us-ascii?Q?G/S0Tj6iAgRLjCKXS+TV88CkPW3ZRKHkh7PkbF0GZBD/io5Pg4nkp57xZKN5?=
 =?us-ascii?Q?Per1vPJOXVtBJl4JYvKgSgNWFw4LjgVImpJYk6BqkWys+bWGT3bEox5nuGXr?=
 =?us-ascii?Q?xU1mrc1f0wnTIOORjBRhFghDpJY+dj0b4aqO+yLm48Th8XuMSxma12AtFBJ8?=
 =?us-ascii?Q?MGh8es9tourucy52FhfG3osq1FN19jnsxWu5C5nrO+asxBcZyompsJJYN1af?=
 =?us-ascii?Q?d9Ip11O1FjLmVivifjIRw9pZNJfAAb16NEwzuOWtam8lgrN31a+kC2vz9qiT?=
 =?us-ascii?Q?OmTHvYHYVMkwVMmiU+wgP0m/uHajmJsiFbaoh6pjUJRHJcXFjSVV+PDBVeuU?=
 =?us-ascii?Q?+7T1B+i5S9PPIbAfGV+IZJo/WU0s37WxwA2z+KXFwg0t/1eUpGDtRPAb6NNv?=
 =?us-ascii?Q?tyLQViO62vxiI+WVxWOtI71SAN62CCCxSFrFndRDKFfE/p7TMk6XMJ4Cqy+i?=
 =?us-ascii?Q?RBIh+evIeDKEe4C0kgLqFe1mohZ/Bj0MqvoensRBvNNSllRjwIYaQCOQvhO3?=
 =?us-ascii?Q?y1VtMDrYlSI7lZVU9hXG09FO2pTc6BbMUfJvW37h7JKz4sFxdloKMYzV0pZX?=
 =?us-ascii?Q?BKaQ+BVmkePmmGz4YsmJdLiMtp25A7+iwqEhzSuPCtbMLaGQwhpNAlriCJ9x?=
 =?us-ascii?Q?4+zLGOHGB73ULgOJWC59aOBkZ18QRJKcPGyQN/3ruJ1yu0XT/Bcpm2UKW5Q2?=
 =?us-ascii?Q?5mzSvfoFcqfZMCikhrMldflKjfGF0ohwAFLZjc8SPQxHb/A+UAYd4lfG08LY?=
 =?us-ascii?Q?lrL6ExHoqVgWHzA8x3smEbXco95jTQTFTa2UeootV4MPzYiFE4Pln5nk4eUk?=
 =?us-ascii?Q?69Voh2f5F48NBfDQUzd0Cr3gKEDJ1tWvybVNpdub1MB8bBEcdD9NVWdUVjUJ?=
 =?us-ascii?Q?rQHWpAy2gOO4rX4oeEy3LnZ1VWZfkL4ssUs16su/CSbZZJCo68JwYbfAK08G?=
 =?us-ascii?Q?NRYEOUrsJnvCBXPb2SFsyWHI4y9KKVnG9b5v2Z4T9dnSWfZuoIM11feIcGr9?=
 =?us-ascii?Q?xpBKXLXpleS7MmDD/tQBBjOFGnZBLxIdGVWg37JHR84kfsYzGIQszhr9kJxf?=
 =?us-ascii?Q?wpYG3ft0fmScJj40KMppYpRyC27nBNE5qR8Exkr8sS4UZhoWX/4XRCMGOxnj?=
 =?us-ascii?Q?3pcU+lqYqc5SJkuGU1RkS1hvHuKmP9DvdaGBSoKDzs0v9cB2zDzQzEqUhvDg?=
 =?us-ascii?Q?a8Lc/JXesnBGa1+o1sQlrmp08RlA9Wj2kJVSjOQpK7da9eI2J96+aYCa/KXU?=
 =?us-ascii?Q?ixZHSzoQCFyIflExqdQpEZIzj8Akf7V0OoUDUT0hm/npYwreOKSq1z7rSeaq?=
 =?us-ascii?Q?Dq3H6/v0XYNBLTBsK87Nx/90D4hr2xvX+mQlRd0K59EM2fqLMvDkmiimNX3F?=
 =?us-ascii?Q?n7PXayG+687VFQcXvRIB15/95aCaAZSs1dxHoA+8nCBGjTKaLwMSZeiLsPwH?=
 =?us-ascii?Q?jSC3J8kNECLnoH+r2Gy/U2FsbUAYeywCluitsx6/JbILSOtf0wHARqseBEoD?=
 =?us-ascii?Q?B+8M1aXgu3N+OJiEjm5ikgHrGTauuwVTooYs4nv2P1VsMmm35r05xX6sCBuz?=
 =?us-ascii?Q?UXf06vQKPOky+0oE/xg2MqevJR9Bbb2ieTL+Uh3Tna70vlNqNW7+9SNzij9C?=
 =?us-ascii?Q?vpC4IQSMUdjvrAFe1m1EqjU7gQ8wfe7M2stZUqzLUjdexRtAoTSsx3zJoXht?=
 =?us-ascii?Q?xTc9kCgs6g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec2f908-9caf-47ef-e70d-08da4f618d62
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2022 06:29:22.8212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DCjTkRW9tbVEylX6fTgfphPaFxzmD3pYPQjfOX9WepWzMemBatgaw2j6gjUIfDzPNm0ZorwAeJQP+aFSamxaUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1810
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Thursday, June 16, 2022 8:03 AM
>=20
> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> The KVM mechanism for controlling wbinvd is based on OR of the coherency
> property of all devices attached to a guest, no matter those devices are
> attached to a single domain or multiple domains.
>=20
> So, there is no value in trying to push a device that could do enforced
> cache coherency to a dedicated domain vs re-using an existing domain
> which is non-coherent since KVM won't be able to take advantage of it.
> This just wastes domain memory.
>=20
> Simplify this code and eliminate the test. This removes the only logic
> that needed to have a dummy domain attached prior to searching for a
> matching domain and simplifies the next patches.
>=20
> It's unclear whether we want to further optimize the Intel driver to
> update the domain coherency after a device is detached from it, at
> least not before KVM can be verified to handle such dynamics in related
> emulation paths (wbinvd, vcpu load, write_cr0, ept, etc.). In reality
> we don't see an usage requiring such optimization as the only device
> which imposes such non-coherency is Intel GPU which even doesn't
> support hotplug/hot remove.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
