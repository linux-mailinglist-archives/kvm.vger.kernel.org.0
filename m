Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BDA5B0B34
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 19:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiIGRLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 13:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiIGRLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 13:11:08 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20952BD295;
        Wed,  7 Sep 2022 10:10:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cF4+k6T7lpApf/P8e7zRfUCogRWZtH0Xzx+JtdXF75a8gn3GiVqxjVUzLrY0CbzsHzVhlNJN4Ug1dNrKy9vVk9H2R4+JCOv3AxLBf5YNTTHnrXg3gkbodewhvC2b1+O3jl0kyOFu+Lg3R7hQLn1KEWvNfaPMt6r55E9diq4knyQ6J/KinnOIlOL9/10Ns4T+Pl4MboZj39i7ueIU/eGkFJdSDjcagc5O7xLjmkcfE1VnMCAvOpeP6g4gzwkUiFpWCP+GhXmOTN95Ql+9qYFF3p4v3PGW2tOJSBPA7Q0m/Erw3wNFyRnI7w9nQZNKX73kE+vg4fjDNYMfhmP2FFYstQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s1SYnrrJbkzDkuhn8nt5eiUOc/1JRhHQ03IUxnAF/xQ=;
 b=WY7AujCWdiyhpSjg6Iwi3kzbKTCCOLAcdu0LgFV247VvnvjLLuIDVu1uyUUIndts1qTxHclWB7RBkT+3jHvZ5zNKH3dW9oO7H3sYGHB341ljXw2c6xMgnFY9OzgRkP8wT/7XuO2JlrAtFFUXIbBF/DAlkX4uxCQG2BxbIO64zU+dHMyn0V3ZR0zY+nZMDKXLHsaPMJypFD3LuO+RyeOtsRTyewLK8aNhBwnD/t9jc+AgThp54X4YEXlMEYJr3lra06Qd5bzVCzTpaJwwc6Va+d4r7z0cTH3r1IxcKjPlXBczuUD8Ul6xeJngKRsUF/Rj2hRMB3ukeh9qs31exRUgBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1SYnrrJbkzDkuhn8nt5eiUOc/1JRhHQ03IUxnAF/xQ=;
 b=SK5jLzXUg3r3BSred0N36jFSP5hcdH7bg4uh12GGOQ10D3VjcQcF+0XGus7+003o/Mw60iXbXVcbTqChe20kh/fXG01rh6lfKWoQKAMbpLp0HzN1df0qvrn4f01Pz9b0URIMhX/X5xEM2HlxmgEFsAp9xAdZRgd241d8ei5x20zzj1t2AqgIwlPlS8K4+H0fGnwrBXKY3LKA5IA/Ubw0Xl2lDMGwUNyyK6pGNgd2Hw/3bBxkc9SukS4MTTQ84LQu6zcMsW66z2QXNfcaGpdTZozIevPMunjg8/N2xuHPIRC2gBIS3REO+pUVX73v9O0+8tzA4oc71NgVUx+hvy/32Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL3PR12MB6570.namprd12.prod.outlook.com (2603:10b6:208:38d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Wed, 7 Sep
 2022 17:10:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 17:10:34 +0000
Date:   Wed, 7 Sep 2022 14:10:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
        robin.murphy@arm.com, alex.williamson@redhat.com,
        suravee.suthikulpanit@amd.com, marcan@marcan.st,
        sven@svenpeter.dev, alyssa@rosenzweig.io, robdclark@gmail.com,
        dwmw2@infradead.org, baolu.lu@linux.intel.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        orsonzhai@gmail.com, baolin.wang@linux.alibaba.com,
        zhang.lyra@gmail.com, thierry.reding@gmail.com, vdumpa@nvidia.com,
        jonathanh@nvidia.com, jean-philippe@linaro.org, cohuck@redhat.com,
        tglx@linutronix.de, shameerali.kolothum.thodi@huawei.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        yangyingliang@huawei.com, jon@solid-run.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        kevin.tian@intel.com
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <YxjQiVnpU0dr7SHC@nvidia.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com>
 <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
 <YxilZbRL0WBR97oi@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxilZbRL0WBR97oi@8bytes.org>
X-ClientProxiedBy: MN2PR17CA0024.namprd17.prod.outlook.com
 (2603:10b6:208:15e::37) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b563c3d-5c00-4930-5db8-08da90f3e08a
X-MS-TrafficTypeDiagnostic: BL3PR12MB6570:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +SoC2RNech7I4eFFPSN0aqBGTHpgf7qy/8X3zKVQSw28zTuAdg4Opqp6Ms/tJnLJP2AUpIzRzHvxdpSY6lTpxLIWpvzxU+L2QqghRsm1zb7nG5A7ui59sPxNrXT60//vSWB30XfZGaDziNMCEsicqAFjrYyQisO8ArRVoSdxen+hgHH6wjVBouWgpBhILkA2tcZkedUOu8eySYvS65pqLJISSh2uuXYbIaG4bvFUzo8cMOjUw3EmD1mxUT/74b8BzLrVr8r6eWjyKp6GfcsTI0FT8Mi9nKcUZqIVM/7XWXX3h3WClFg2lLEvXv7Zr26mMv3AIP4SDjNkmbA00s5dl74Cp0RJTbgTCRhMkRqt7RlxHQ5WuIEx1LzxQmCujktHhfX0IRUtBoiDCUk/tXThaF0mYvKNrgrF/qNtGFYCBpp8EVRA5+BtIP3QCK+8XMDxD/UzaA4psQJVuoCdVERHxuUyCPYDL8e8LURw8imizPGVdvJQqVduJAji5RgirfgfOjIsgIr49oNQZq5FMiMTun7tDASwNvsgP41V/t8UdZC4KPLY8/biZsWsiw47Yv2M0N+mLEYMUHAb/MiprYivJcKLDneBKp66O7BgLAEqgyInz03MsYaTDWj9/tAxFQnL43RnGgcFluKisiSR7YN07SKVfTXTHQn4gQws+x2T+Mtt3Cn96U37vrKlMQmHLumvWGwldWku9ZYAhDjZ01iVRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(38100700002)(316002)(8676002)(66946007)(4326008)(66556008)(66476007)(2906002)(6916009)(8936002)(5660300002)(7416002)(6512007)(26005)(2616005)(7406005)(186003)(478600001)(86362001)(41300700001)(6486002)(36756003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GISa8QQVLcnFvSXsC6xJCxGNdzNMO6tNaFJFx9jVziOFp4WXZxJD7dy20nkD?=
 =?us-ascii?Q?Ide33D9rsnTcOX8B+bLe2Rua1Fl0y574UYL0TK2GJKChRS+grwDBHgBVPw4g?=
 =?us-ascii?Q?nFPtejZk4bsP7iwoWh2/kzlg8tUBcaSBeu6ygEunT9OUwtELHodyuuGebL3Z?=
 =?us-ascii?Q?BB0kkNjQBFI5hWHqELdL9wV70IiO+N1ee1B0lEEs6/G63qiytD7CKoewdGsO?=
 =?us-ascii?Q?kh7vCDiyayJ/svb87lr53Hko9COdAGePMDT64RoEHZgwMt5oznUeibtN3UvS?=
 =?us-ascii?Q?wdmmGR/m069RtbjeD2P9UpQTFMZ0wI1ERRwEWHXcU63dhlpVgX1jKklRAQ68?=
 =?us-ascii?Q?LYWGSpAch3ZhYE/a46c530NBTGqtrj/kJXejwUIp4K6llhOvcolCgznyN8sK?=
 =?us-ascii?Q?cdlOkxHT90KXhtUYIHRH27BwxJdUCRT9xEztNi8rXUgefJ3eiW+uBrdcBfOW?=
 =?us-ascii?Q?w1E/YOK8OxoIMW+kE8t8ogbBBgNggkPWA4tU6XDtSgvmQ3WFCbWAZEE07CML?=
 =?us-ascii?Q?8gCHf1g6gQH9jr5xLdub89zNIjhOCRRs2RMNiye8lcCN17Az+HlXtjKRaR5X?=
 =?us-ascii?Q?SzRJW8dfrPaA865SSktg16RIMgtihNIZOfMDc5rKBS+vUa5oyDqIfbTWFP69?=
 =?us-ascii?Q?siMc81VTjRiPLdZI6eFdTecvMimY1V4DFkUrezr6qukp/3p4EIaZOL2uVQKn?=
 =?us-ascii?Q?+ZiQMMwmARX2wpUPRQeH0xknPOi2ZSFjtrnGR5EqQ9elFrUYxBzOIpH/HT8V?=
 =?us-ascii?Q?dSD24fChSYMJpACONuCDdnGhakDPIU3h1xNjsgpPCHSY9wvY2w3zEqs+SDQ7?=
 =?us-ascii?Q?rTcuQw0abP7ybBmcgQUPFp1rzH5QmZeq7y04SzRMu32kvILir2lgMhS4bhlT?=
 =?us-ascii?Q?0f9l6kjY+ZnFgJphkp+1BBtitHNXmajNfI8XLDArBuRAVZT9LgwSGGi8+vIE?=
 =?us-ascii?Q?tgJKeH1J4BuwBu2EJ+5Z9ek8f6nkKgyRSMx0XPssYqdca6+HLYTPC+KNWo4x?=
 =?us-ascii?Q?w7n/iMX22s7gD/Pj/uWao7Ucjhi52yiMju7EH66uW5f/5LaWgDxQQDzQLkYo?=
 =?us-ascii?Q?upR3ePo0aJs/XBJ9un8k+3qONtGoqeoAoiuC0XVyIFpBtpO9P2UWVwyUJjni?=
 =?us-ascii?Q?jsjNyjAbYONES4n62RYAomtJz6tpkOkOeSssT3R1bbjKElHvoaicl3YDLLTU?=
 =?us-ascii?Q?hzi/GV+DccRpkQVaFh1Ad5Qkl4i1aKrztd7zkf9HwOrtO+U0gW80x6RoGePY?=
 =?us-ascii?Q?oQz2kHQA4r40U4hby8yAfkEHpHUXHjAGZ97hf6gpu9p5CyO2izY94KXOHAXV?=
 =?us-ascii?Q?XhCtmg9kxU8krsiMycowBhNSEzmuuK96svANtSMwD96TAZcN13qe01MBVXFM?=
 =?us-ascii?Q?mErU6tG/prVFi8y81byaHiauoJ52l9Cxzk8mS+H8K2n+7aEABLZZJRh6ssOi?=
 =?us-ascii?Q?nu7gjM7GVBk4VcTgb5hbHR+XbypVZeXLaUv3VHIT0hOBNaIX7Kt5ZAJWVT3i?=
 =?us-ascii?Q?3+oMGSQ72WapG/uFmNNh7o1qQ+cPHdiizJNfe1Abnw+BhPlx+GSr9YkOrD9s?=
 =?us-ascii?Q?VdxlPS9ERenOoilOV8DRyMNxqE4Hq3UBzKSh2nUN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b563c3d-5c00-4930-5db8-08da90f3e08a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 17:10:34.6838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJKV1jDxlRDHZ5Z/Yc37+izWK97nNcxnPLc2DIUylaDisbQzVR0u62DIlQTZnGOj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6570
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 04:06:29PM +0200, Joerg Roedel wrote:
> On Wed, Sep 07, 2022 at 10:47:39AM -0300, Jason Gunthorpe wrote:
> > Would you be happier if we wrote it like
> > 
> >  #define IOMMU_EINCOMPATIBLE_DEVICE xx
> > 
> > Which tells "which of the function parameters is actually invalid" ?
> 
> Having done some Rust hacking in the last months, I have to say I like
> to concept of error handling with Result<> there. Ideally we have a way
> to emulate that in our C code without having to change all callers.

Sure, rust has all sorts of nice things. But the kernel doesn't follow
rust idioms, and I don't think this is a great place to start
experimenting with them.

The unix/linux idiom is return an errno, and define what the errnos
mean for your function. We have a long history of creatively applying
the existing errnos, and sometimes we create new ones.

We rarely return an errno and an additional error code because it
doesn't fit the overall model, I can't return something like that
through a system call, for instance.

> What I am proposing is a way this could be emulated here, but I am open
> to other suggestions. Still better than re-using random error codes for
> special purposes.

I think, in context of Linux as a project, it very much is worse to
make up some rust-inspired error handing and discard the typical
design patterns.

Linux works because, for the most part, people follow similar design
sensibilities throughout the tree.

It has been 3 months since EMEDIUMTYPE was first proposed and 6
iterations of the series, don't you think it is a bit late in the game
to try to experiment with rust error handling idioms?

So, again, would you be happy with a simple 

 #define IOMMU_EINCOMPATIBLE_DEVICE xx

to make it less "re-using random error codes"?

Thanks,
Jason
