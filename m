Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481A6788182
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 10:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243326AbjHYID1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 04:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243371AbjHYIDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 04:03:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342491FEF;
        Fri, 25 Aug 2023 01:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692950598; x=1724486598;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5RGmZPlu1kvFTqyRilV/7fBBHobbYjrpym84DLYd0FE=;
  b=S/+nc+uLRKA1X+MK697Z9RA/+HN8D3AWpmGrSJHuxmMxNyAUF4uhoCWz
   creWS6IRvCN8e0aQSDipIEOF508OgYhjJytdRzCk13GLM/vZqT86w4SGd
   XbjT7d5/0ZDTGGKV0JJ04V84qkTtSzvDx3vC7LwPtqks4b8gV0HS0wE6f
   o8slsoh2xTirHgOZxEow9lLVWlEOrdm5f5wr1pnTvQYsaLKpIf68c3wi2
   IFjbOkXWWw9fr7p/ewXdhGGpz9h+zLbGpNhTgZ158it6o0LOkOGC9rY3p
   Gsha4zMPGl/55iUVz+mIanlbVH/fesANBxW+gmav7bQrKjWV7FzfCNj+g
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="354188550"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="354188550"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 01:03:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="984021241"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="984021241"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 25 Aug 2023 01:03:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 01:03:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 25 Aug 2023 01:03:14 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 25 Aug 2023 01:03:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtRp/5QlM47p3qnJA2jmO8lo4QVT6tJCfYG78SB6lTEqIAc65m7rVvJ0OK+LtVPgAGWI00Zf+PHC8YXIerXlp2yY9qRTVWSH6xiGV+5eFsqO7IEcNB9VzixPXCSPJIw2ZjadtJTCs8eGjC2k3O66/C+8BrqDoKrKOgqYuIDlU4qDOCf/T2UMi8oRtXtc9XZkKBZ84clS8PjeLEyydEW1BKbWcD1OkD8tme4Wcc3eIMC8wc5W09uF4OrzDrmb1YFD7yz1TOilGp2K8c5Cd3IZLVhEFbCvVAwv/njiSDlcc9xcIl9NfqLeYuZVsd7PKX3eO3XPvpMA7gk/I3KaA8cbkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOKjjfOkLnSLJhaFsMGQ/neNWRXss6k6xlQM8pXkVqM=;
 b=guNNg2Oyuj/NzJn8d/BgM80n7QQEngUVfXaf3Ny7XXyH6F48g64/zNPvN391hddSLGuFBUJusNURHZetq61hmpAOa3Dr/yhL0PNIUi2BfVy6Gq20fbS9RDuJsQwVvr7ofpI3NSvhqEBiHeU+esRTssFWPhPIBhxxKmuWTGNjjp99xJsFk1IzFUv4ppX332LOy6PJogYNf1ESjoIeC+xF6zKpPCyFqDHSgLFmfL9HktSeg3/PfOWr5TO6QDgCuILa4FT/vFl0D4Lx7lYXgwbRTusu3l94v4og6oYj9Jo58lpxjmntLCQ2qas51smDMm1Bd9uyoKz+4qm8j+6EhXCqVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB6037.namprd11.prod.outlook.com (2603:10b6:8:74::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6699.27; Fri, 25 Aug 2023 08:03:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 08:03:11 +0000
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
Subject: RE: [PATCH v4 07/10] iommu: Merge iommu_fault_event and iopf_fault
Thread-Topic: [PATCH v4 07/10] iommu: Merge iommu_fault_event and iopf_fault
Thread-Index: AQHZ1vywN5WR0Q7gIEmdloJ1HEFD3a/6prsA
Date:   Fri, 25 Aug 2023 08:03:11 +0000
Message-ID: <BN9PR11MB5276E342E0E774CABA484B258CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-8-baolu.lu@linux.intel.com>
In-Reply-To: <20230825023026.132919-8-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB6037:EE_
x-ms-office365-filtering-correlation-id: 6f4c2c54-4b8e-417b-9854-08dba541b9da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ww+lsYVKKEvCEYpjs10o58mf4Ob5/dYjAhrpfKZo/tFIhFnIf0O8njaVmZTkI70Mir8ptwza1sNa5DWDFWzY1FZH0wjZDSc9ZlzfKdY4qQ7AeLhcT1WywH6U+3ppMCmZCjU4xxFUibMJI0g3yaVi527UDUwMSLEuWssXyXNBMiRU7Z8/pKXPgPNkhunNXjyBWW+UFrHIO3oYyx0rdonihkOTZn3SalIMUK/MztBFjzYfKWvV7zhMxA4qFNKqXlMWXhKlRHeaKjkk/WdUhkWfak8QcmBBfjuqK6tUPRzwrUYyN9lO2XtNzCr4DgmVGko4yVhnMlwL2O9HjO1Wi3ZgIm3XTzY4w34rNKkKTL97TD0vak6HZP2bfR9w26OAacs2UPVN0BH5X6cJAbJMVZqaZ946reTE5y2xDMRrHgfPvJSfovx1uOO0zMbTihmdnuLiWT2HCIPUYDBmfXpLS5akbPVfgYIrkUFeyJu35WQrpfbVzVMwZpxq2AW0EbQ/N1A3mJHBC91Bw5Rm9CWz3TJugXXAhFZtsSUh4EcPZ37+9tlTWLK3Rp2hs6+qUrw2ZuZIAu6qlEiVnBc97/lhPSEp+9KFaVypMI13bOJSaJuFcfMznmI2a53Y7a7k0uYxhjrc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(396003)(136003)(366004)(186009)(1800799009)(451199024)(52536014)(5660300002)(4326008)(8676002)(8936002)(4744005)(83380400001)(7416002)(33656002)(55016003)(26005)(71200400001)(38100700002)(38070700005)(82960400001)(122000001)(76116006)(66556008)(66476007)(64756008)(54906003)(7696005)(66446008)(66946007)(316002)(110136005)(478600001)(41300700001)(9686003)(2906002)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kD2Z8LqYrCeVqqH+HXHDNULavviJOeucQqMqh2ThAlwsEd/0MmF2lKuwb/pG?=
 =?us-ascii?Q?XdVTirA4aaoq4ZiafWrXxdoVVoUFbekjrTnAANevhfbG0CSJ407KwNmbAF+5?=
 =?us-ascii?Q?8expu9g9+sb7VynbcBOBMkkBSDYgE96mTD5BnoljdLtEion8VhLaPMYHdD5Q?=
 =?us-ascii?Q?S6ZRuZERS0kefr5PtVWvDqMrhptXkfa39kNzpb/hhHPDqMUel25ylO7wN8ZL?=
 =?us-ascii?Q?2OMJO8Vdj16j+PzjwldjuiN5cOfL32t+XgTyueOnXGNKC4eOB4aAsLUTQBST?=
 =?us-ascii?Q?c8GoyXIlxelWOJYzWOekhJJ1AwZx4oqWZIOv5hDAcunubOTgbFB7tpK7NhsI?=
 =?us-ascii?Q?0eTUSXV5q9dLWchCIJGEu1YpYNF96eii6KwqoEbenRnhFOGRpxrc7hRutjTc?=
 =?us-ascii?Q?jhzgZEXFwqjJOwJ8shjcp0Yd4c3OenyNN1y+7t4bhqqRH2pt1irOvTg12l59?=
 =?us-ascii?Q?sCKytgv7CGW88noRgrRrcgE/nlcgQN3jnEPX7NeIeUObKXmUmuVDTmIE3KlG?=
 =?us-ascii?Q?fyr5C9kTae+mMaQrcrouOZUmODJkxRY1zvj/6C2XBSJHRtSUS7gMpfohAh7F?=
 =?us-ascii?Q?GQx3jbtgq05sVcrtzts1aOCk7hLfoXfPMBapp0JfcXihzXAqOPGC2H9gsLQn?=
 =?us-ascii?Q?nJbzr7Qo2Q3fs65W9X5mkLWb0rEV/8qN/dXYR0dG+/7P10jlwyQSiOam6NHL?=
 =?us-ascii?Q?tJwe3jglemRhMyKgux00CGMlXayMzqH0znN5AAAGPphH7PialnlQg8Ouk9lf?=
 =?us-ascii?Q?i5574oLugQVwyW0ekWEppNkrQc3qVOirJaXUcV3kuSWuX46xqkpmNZRU+KLC?=
 =?us-ascii?Q?oIpn9HY1KghEMTZndQl6KMCLeiUKnPfoIL+3LdXQjKojz7BtTjDOzzug8Bco?=
 =?us-ascii?Q?psrZtE4ONY29OFXFhQIy4I9lkp1nPryvYJhb+wKO7g+W8N0ipLNyADo56AYv?=
 =?us-ascii?Q?j21e0q2TBM5/le7nLrH1UIq1JywTY1kwp5d6HHnikziLjFyJ0IvMwAGgpx7v?=
 =?us-ascii?Q?qYeRy2RfsulBwX5eMMwcsIl7BwLYZy+9X3bjRDwyjpKt0o5kqIlWhpYjBb0a?=
 =?us-ascii?Q?08MsorVi9LYIqaoybWZAVd0AooZjQAnnrubbqlr5SaLYzcnsVXz/PM1nArgK?=
 =?us-ascii?Q?lEpzF4qkBNmR5Kt9YKhYc75dmYc6gZGGq18KzJf5pPdoSjnbpOsTyVxxO79/?=
 =?us-ascii?Q?XpzYK8h6wwIHRr38Xkyz2r5buyPg6hud8rlxml+LCPq4sUEMiEFFfCWfKouY?=
 =?us-ascii?Q?Kxb9/Y2Y1MZb2pIhx3vE4hcss8gEyQ0jFKMiwEJXUhqOIcx2DP4IKEwq5McH?=
 =?us-ascii?Q?khHvYIdJDCc8LTRqf1DM4kfy9MKt50YUnZbbxMF+z4O3fLMEyYor6gO9sOiI?=
 =?us-ascii?Q?Jgc7FSghprj4/V95R4UrMJt+OMwsek+gCkBz5ZlZlRGaxZ4Bj8Z2xP7ntBeA?=
 =?us-ascii?Q?4dvqEOKiQJB/1HHdY4QsxZW2q/5D0sGh+5H/QYchrPvzB7KveTqL61CCa8Kk?=
 =?us-ascii?Q?lUeoqbc62nQE6lJf/AxtJupnEzq1wE3L5YoaOEWCaHDOzkWR9niWKKbl/2ly?=
 =?us-ascii?Q?yfT5/IxtfsmwqhibweHkPnNc7a/k5LBSq8xuklPj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4c2c54-4b8e-417b-9854-08dba541b9da
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2023 08:03:11.2501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1NvHWBCiwqseh1tDtKCnj0xtuT2KQkqkkplUGYjDbxC9xI2G1abXq8sylCO9DCliu/RL8OcyQhBpZ8VUnyVZrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6037
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Friday, August 25, 2023 10:30 AM
>=20
> -/**
> - * struct iommu_fault_event - Generic fault event
> - *
> - * Can represent recoverable faults such as a page requests or
> - * unrecoverable faults such as DMA or IRQ remapping faults.
> - *
> - * @fault: fault descriptor
> - * @list: pending fault event list, used for tracking responses
> - */
> -struct iommu_fault_event {
> -	struct iommu_fault fault;
> -	struct list_head list;
> -};
> -

iommu_fault_event is more forward-looking if unrecoverable fault
will be supported in future. From this angle it might make more
sense to keep it to replace iopf_fault.
