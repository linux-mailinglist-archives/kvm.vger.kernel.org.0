Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4535D55A0C9
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 20:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiFXS2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 14:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFXS2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 14:28:39 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8FD33363;
        Fri, 24 Jun 2022 11:28:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=he6Hr1jZsQX0bBNyc4iaWBwvb/SkFqwNE5GvhGKZahVHlMv88moytSyo3gAlZvhhnpViRWqb8bdVIaR+Ak8lfBXZ7B6MMKXhyVj/dkt1lspj3lFEJwhzB2L5jNAYV1n9eBnPwiiyvdUi6r+CYWqtcyey8UqZEHjUnQSGopiB0RSvRdHETR4c4kso+9KdFxyBdsil0NuRPjsQbnfgx/MNUFgxZ8GQ8CSS50m25P7ZGZ1nh4AVBlmQDrj+7bOxtciwah6j0ojq82OJrbGgSyRwN9jruH3ELwR8jsnzHdhfkvHsYfxK/uxgDvWHZxtvdw4Nuek68ww7ZBvVg08d7Hnmsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCmAZAoYRU9oE9rjjWOkOBF2pX0UXoMJD5yD9j/l1KQ=;
 b=fzdYS7NU0BCyO3q83vwPRcVdrzz2h11/ezIkt94VB5joiGkLm+rR6RZ+jCUgyn2joL1N7jK7Zt8IjG9Z4kOCTLS/EBcIbQfMiSTMKjjaaU8KD3gwEuzUfTa/etT37CVxAGjlm3T75/ohlNkYn45rWWyk112sJMsC05YfjkdBfRbx2aSzLwZlPMjn1hxUW4kBjzT0JrGWzQP42ln8txSzrVnXdYl1SrU5Hxk8+0OpGNaUhzh2apoG51/DByhCOGujI/GBQrjARWgkRtFcApVMSC/oT0JGm9j9shaSHubTT1H3R1/+dH/pBif7rHNLehcK8g7gC0DSP0qKcfHbkjfIsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCmAZAoYRU9oE9rjjWOkOBF2pX0UXoMJD5yD9j/l1KQ=;
 b=ay8ozxEUwvep+vsAKx1KersnG/vl7OcVdHZPE+uCRVnx4oMnHd8jIm9Z9VbHCa3qpufp0ecGGi2VVDFDraH9byInwvX+cpE5GfeWDSAultlYm3bWymUZKQmsxXd4kfNXhgTALJK2jkWkXM9cFVu/5LgjYnnJ23KfaOgEcTnN6VoNCRmPMGMIMtLhvF+BBzoOwP4Od4fD6m/2sGfz2XetOC0vgU1q82SDMWCDbcI+9JsrQs0BTmAxixfwNZBZ1QUwIuPJ+hvwoE1chytb6Gz+QmU2szMKkFb+o56R7L6f2GG/KX87Jdv+TBWbc1cGOtBVfzbTsLuy3L/QXyalsyUvBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5047.namprd12.prod.outlook.com (2603:10b6:208:31a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 18:28:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 18:28:34 +0000
Date:   Fri, 24 Jun 2022 15:28:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     joro@8bytes.org, will@kernel.org, marcan@marcan.st,
        sven@svenpeter.dev, robin.murphy@arm.com, robdclark@gmail.com,
        baolu.lu@linux.intel.com, matthias.bgg@gmail.com,
        orsonzhai@gmail.com, baolin.wang7@gmail.com, zhang.lyra@gmail.com,
        jean-philippe@linaro.org, alex.williamson@redhat.com,
        kevin.tian@intel.com, suravee.suthikulpanit@amd.com,
        alyssa@rosenzweig.io, dwmw2@infradead.org, yong.wu@mediatek.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
        cohuck@redhat.com, thunder.leizhen@huawei.com, tglx@linutronix.de,
        chenxiang66@hisilicon.com, christophe.jaillet@wanadoo.fr,
        john.garry@huawei.com, yangyingliang@huawei.com,
        jordan@cosmicpenguin.net, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/5] vfio/iommu_type1: Remove the domain->ops
 comparison
Message-ID: <20220624182833.GW4147@nvidia.com>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
 <20220623200029.26007-4-nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623200029.26007-4-nicolinc@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0267.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffa60662-7f2b-41fe-54e1-08da560f58eb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5047:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lSuDgryPVziDCLdeYRfbowvxofwBsNzyB9IbZ8xVrS5grrr74QQzQqe64pstjwSrI/f+Tm66nGJV8m0R8UjAk9U8X8h7qptHBamicUQ/cOfHc0Zj3Nkil5nz6sOrhdU9+0N5F5tPCVWVaPBHU7NLgXlo/ULH0PyyaCKCkLjLdNEdsV+JeDQ9lKF6mt8wJGn9+OCrXcVctvUQ1VVkd8K7luyl5IK0i1739C6uYf4OJy5UyvtjzAGBwnnvNBe9MPxFI5hqC5v8R7FPK/nKagPJ3Hw6xvC81SuVWosH2Fc5ay1pmornvqCZH4xhASWjdXqpE0F7MzKns4x1l4j44mHhtKgU7sWiUSjxzmj0AmIpeelhSqh265NAeH3AGv2S3uiasIZXYCQ8caE561f7k9wrqR0xzbuhy2lOTHU3VyGYTGFZZzcNmtSM/TlFez575Igdrc0oc+8M9QZ0iF5vMzFBxdZUZHyxP9dAJbt74EPJ4sKocwyM4s518ULXsIyagH/IDAk5iIP1hO97eEQdVAEW4JCGOxZMbM/NW6YtFNf/v6r8x47tmPiUWFbJaixaiaul+Lmtse/Gy6Gma8sSI4VqRpYT+AmlFYYdFsvG5v69aO2KxRRIcjRfo2G6h0CquqVJ3fXFSFCgylNzKaPJiG6t62+ImUWdJQInHBb20hD0JlD5jC2t9utTKhmz9JpVli91YpH8J+n8Zb7MMVL4HjPgT8bkbUx31cg85UTjILDxYsHTVPEIrDzUyvE3ND/FpFJx7dw/56YLvkqU9Riweq2ESQ26c7c33IqA0ivD0PYbztaDOUoTgRvvRUe79BEiqbJKaG76Ompw8EqjE1SogMc8wR8N6crP6jJ4f9B2Semw2FA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(6506007)(7406005)(6486002)(478600001)(966005)(26005)(2616005)(33656002)(8936002)(7416002)(41300700001)(4744005)(2906002)(36756003)(5660300002)(4326008)(66946007)(8676002)(6862004)(316002)(66476007)(66556008)(6636002)(37006003)(186003)(1076003)(86362001)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+nfaNgwDfdIN3qgQNSDFJS5f4iGVWBoGOYeOssLSyQvPBdhVAywMuPveYum5?=
 =?us-ascii?Q?efR9AmkeSJ7H0sdANCga+lXwmJ59NUsXVLiK7SF3x/GFNCpJtDLE0XbExwVx?=
 =?us-ascii?Q?g1ubuX4U/HHy8pkkW/n4E1EEXZKwzzOFvy/CeeeLRZYoPnfXDSO87NB8YSer?=
 =?us-ascii?Q?FvWXeJK27L//Uq+PTtAkn0iTO0zF2uTEvERwBZvvDiLsYMhtQFzVFK+bZ/cL?=
 =?us-ascii?Q?1MSYaXJ9pR7b8jqls5M8qW4o9aWq7AdpmDuIACr7AaRwBkNxgrdI9+qZuKHw?=
 =?us-ascii?Q?uWDSoMHN761J/7Wjr/F224WQwSmN7o0AP6+NCtRJQzaq7muMTDugSEAUMaN5?=
 =?us-ascii?Q?Ci8d64tQsMZO9C86HJ34XeNuA+Qd2EokQj18Wnh/4y9VUHruuK8TRth0SkPS?=
 =?us-ascii?Q?j3ljhI5EoFgMUuNfwXT+x9CWorlisps+uvNwfTFFis4DA65xnvY0QdikFELb?=
 =?us-ascii?Q?gAqiuXAA3CVn7GJ8ZNU3kHFQCr5vv0p3KcXLWiFHBHHfq3S/br2dT5Vo9n2w?=
 =?us-ascii?Q?7ITztfWgYNhEOBV90m8KuN3bDvhjwIrxVX2QrTQFFzQ2gSMiF9jCdKlzgp5G?=
 =?us-ascii?Q?I0wS//0eyjpZlW7V2tx53msF7L39imxR8CmOWVLazXMeY2FQaZuHm3juhqm0?=
 =?us-ascii?Q?IwqLxT6GvFpEHUL2vNVbjCGXMgX0WDtF8X9gerSap/BZcMXDaMMzGZgucZxl?=
 =?us-ascii?Q?DfqupfFFmRT/0R3JLaAXVP6+zM8XOBm0Yegbt/UjB77I7GfLwchkXXiaJ/Qr?=
 =?us-ascii?Q?x1lyhZjjB1hewqtKc9oc9jisIa90Lz/Dxw5oW0NW12Isz50mAjMaWC62P+uD?=
 =?us-ascii?Q?kp9hA33Q9FZ/+aqhUPH6FVYQfzviTEIStHwYUP3Sw0SNp9fxt3sqmBvTwxT1?=
 =?us-ascii?Q?7oSh6IbTzO4oNT4vvQiZGN/k51thUlPF2vLC2ktbxPD+5gWf+kOEAPlSbRbz?=
 =?us-ascii?Q?9hstLx30QvD38cE5xwMnJlLyP0otn2ohObDpl52XhSMeceLldfgA9TyBFAB5?=
 =?us-ascii?Q?imhz/PS3F5W4q8TnBEfXv2u7Cf3yOKmD++LYWXw9HYrFb0bxS2Ej+Wcz39mp?=
 =?us-ascii?Q?VEqp3ANSk+UqjKMyVtlUN81l+ooPPloaimj7kwNs70w36EOrhrgpL8NDNu8O?=
 =?us-ascii?Q?ug0zL4g3pFWNR3Z2eibySUJJKNFTwlPTsNCArw8Z7jB+UKOrsKX9cAFhZP2H?=
 =?us-ascii?Q?OthC3Kwwtnr4zgwsUS+Y1T+KJGvf8PKXKGtKSr+9EdFpzOFj140ZZxDyYdc0?=
 =?us-ascii?Q?1zrUkN/MbWx9OB47QNmPDpXI8cFV1N8yMDrfhBmit/HA9qNwZ6Ha4KZLVpqN?=
 =?us-ascii?Q?gdAq7zF7FwbpdWjD3GOmFVN79QkadhTRbYuQ5KlnHbIBrh3hBKpjQ39mbZZ2?=
 =?us-ascii?Q?ksutSKr5CKt7AzmyiTc41V0P8Ft471nO0W5D6qY9RKyXniSj4EpYjpWNNCaH?=
 =?us-ascii?Q?Ud+DOQGJU7BMJPeD4Lyp+bIyrVcFCwOtMr0sa80qE1jHCen4gZaewHLW75aE?=
 =?us-ascii?Q?rDSg4CGihyIpK+8EuL/eqx8CacStRtlLgBhPL1BDuWHJ+05wx9PsWtUSCVs3?=
 =?us-ascii?Q?17pa5RFV8DPYOSCR7pmdpkP22TUzci4FUiqx2aTC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffa60662-7f2b-41fe-54e1-08da560f58eb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 18:28:34.5786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S4AngFHDJCZ6fQku18kZCub3Vfx1W6XDjWVJuRErhsyovk/e2is91jJXx0nRA44Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5047
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022 at 01:00:27PM -0700, Nicolin Chen wrote:
> The domain->ops validation was added, as a precaution, for mixed-driver
> systems.
> 
> Per Robin's remarks,
> * While bus_set_iommu() still exists, the core code prevents multiple
>   drivers from registering, so we can't really run into a situation of
>   having a mixed-driver system:
>   https://lore.kernel.org/kvm/6e1280c5-4b22-ebb3-3912-6c72bc169982@arm.com/
> 
> * And there's plenty more significant problems than this to fix; in future
>   when many can be permitted, we will rely on the IOMMU core code to check
>   the domain->ops:
>   https://lore.kernel.org/kvm/6575de6d-94ba-c427-5b1e-967750ddff23@arm.com/
> 
> So remove the check in VFIO for simplicity.

As discussed we can't remove this check, multiple iommus on different
busses are allowed today and VFIO does not restrict its attempts to
attach a pre-existing domain to a single group or bus.

Please go back to the original version with the ops check in the core
code.

Jason
