Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8DC53EE29
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 20:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiFFSwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 14:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiFFSw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 14:52:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B9365F2;
        Mon,  6 Jun 2022 11:52:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+nXD877y8trzDj/wZ80xmkWiFN43CUKq59q2CImA4O0chlmecqOO+8WJkSfg73tapA/uswFYM5L0XSeFzVm6JC1P0m6RvU5Ws66IkcRTw8I7xsQyRaBdjqd0O4G3wDbOnhum9MMQFM8Cn0M9w9e+NPEXFv5/pqCHG4dCgFu7iNN9aFHniJgThHAvbAxDFaj1lTw90/81odfEv84qgdE+YUCl1B2bpOb1ZyiCPwI64mcZ/XCnGRszO8l8Y49+dTO5cPaJKDiEJdZ6XW0qH+UTvbHB1Z78cJtsIOlE9woaf8F/yeLa96aKiNof0FHyCzHbNFOq7bKRXFbTqjgWIdW+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FduFywhuUs5yqGEV3EwzpHx7mwMuXX7ysc9vvrVDvPE=;
 b=XzjhDO9dKz1sGVBIPKE306WMq0W8+oqz3SdA2qeAanmF0L6aol96LIj7VOQHReRHjP3aaRLeqUZ270DWJbgfnie4kwRwtTmzENoMLx3kkixjgZa0AQtrlySO/4CfH0Y4C0XSgZfjWwVm/5EDO7fKj1y1KbITSDlAsikhFDk/U1y7Ia3E+lDOu+VnS4fB7tCNLrkjmS1eemFWckw1wNd1wKCKuDVumVqI0YfzX+0FBOv+Zyr4Y6yTQ8PoLHbvIU4LwrJ9wpY+72iBfyaGu4KcqHf7p5F+zupqNzLgV033J9QatbbZCdSEcVyLVdmKlvj0++a8VUX6bgkFAU0LjllrgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FduFywhuUs5yqGEV3EwzpHx7mwMuXX7ysc9vvrVDvPE=;
 b=TYqR9g7miFqowT2Ri6y8PnD+Z8uLomtPTTjs22EI9DEfrnxDihQeO2Tm3Bump95l84exRsALdlSRWpQvJ4ZUvl50sO8S+N64h1lWN131B0lP/GwWOuAZWX+nknFc3DZWZKC1kVzzcOLTRx0kuYyZtjwzvY/iDhKI4BBAXlDf3PDkIiQHTUGAwfSgI8qAcyurOIo14qmYw2aCjIrVUJhdVDZc3qpKbRdppQSKtcueow5ArHf8+Uwk9lMp0hg9KzZaiYqrXaRX0fDgZ8k0W+wmLRC4X2HcS8cqeTMRGGFX49Qxsgh96CrKgPJAyTh14WAIGcOSunJXT3j/fk4Ss4zl8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1578.namprd12.prod.outlook.com (2603:10b6:4:e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Mon, 6 Jun 2022 18:52:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 18:52:26 +0000
Date:   Mon, 6 Jun 2022 15:52:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>, joro@8bytes.org,
        will@kernel.org, marcan@marcan.st, sven@svenpeter.dev,
        robdclark@gmail.com, m.szyprowski@samsung.com,
        krzysztof.kozlowski@linaro.org, baolu.lu@linux.intel.com,
        agross@kernel.org, bjorn.andersson@linaro.org,
        matthias.bgg@gmail.com, heiko@sntech.de, orsonzhai@gmail.com,
        baolin.wang7@gmail.com, zhang.lyra@gmail.com, wens@csie.org,
        jernej.skrabec@gmail.com, samuel@sholland.org,
        jean-philippe@linaro.org, alex.williamson@redhat.com,
        suravee.suthikulpanit@amd.com, alyssa@rosenzweig.io,
        alim.akhtar@samsung.com, dwmw2@infradead.org, yong.wu@mediatek.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
        cohuck@redhat.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/5] iommu: Ensure device has the same iommu_ops as the
 domain
Message-ID: <20220606185223.GE1343366@nvidia.com>
References: <20220606061927.26049-1-nicolinc@nvidia.com>
 <20220606061927.26049-3-nicolinc@nvidia.com>
 <1e0e5403-1e65-db9a-c8e7-34e316bfda8e@arm.com>
 <Yp4wiJZWxoCLY8tm@Asurada-Nvidia>
 <6575de6d-94ba-c427-5b1e-967750ddff23@arm.com>
 <Yp5HYe51LSQke/GY@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp5HYe51LSQke/GY@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:208:239::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35d9d53a-3b5e-479f-ca9f-08da47edb2a3
X-MS-TrafficTypeDiagnostic: DM5PR12MB1578:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1578F1F33068614AB5D0AD76C2A29@DM5PR12MB1578.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HVCnKVXg4p4RaFAae0Ld/F8K7CN6MVCkgVOq/Mpb8VwRc2grRT+vDf3yFL9gPwEb3Hghckm4zaON+Z3lkp6B+i0U8VMnSfQDJzJc0vCZ7OCkWv5DjFXDa7E6ZerX0gZV/qbkXmVjrSPc7b25hxdMdqIKkKuJuHSbhJ1BpMCWmdK1nURsSmg1D6BZXa+fiU/3U8xwk5CXs7CnOo9Fg+cd8FUgE9ryTn9QRmU2ZKIGqx6klvcD63zLTuk5ZSW8DJnbMOpzr4qkCAt9+V7b0flARSlqSy87sOGFk2rx2IPcv/OhjvsC8qOhzXXAvPs9/DdXILNjo24p1TIntoxQv7/MrnSrhsIxKM5fmT58bd3gtY5eN80uRgn/2uGocNpoyVzTRb3U2jqOtMEBKrKsPqnERoE/FD1xgXN7Y5vEtf8W/Zp07xasqFE5PBxibtNs78SHV7MH+S00SgohfGm2tM7qrS4wJX+WHRFgaV8YIHepd08HQgZvwBIo32lJ4rYjkckr08Dw52jD3NTAuZFv9sa40XV3qOscfOWlpkfb3CL/mfP82nAuJCeHxBKMyzv7QlGWDcJwLWOTBmwhmR9KUeKvgzpFnN8hBLWvpFPd8A258zzbfLSxlcizGM8opLs4bXsOSJr9/dHciZRIHv9r2V15mQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(7416002)(86362001)(8936002)(7406005)(38100700002)(6486002)(5660300002)(508600001)(6636002)(37006003)(83380400001)(36756003)(186003)(6666004)(316002)(6862004)(4326008)(2616005)(1076003)(26005)(6506007)(6512007)(66556008)(66946007)(33656002)(66476007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2SkzZKWdWb7/u+m5pHC8O7Zv/dLRkYPcSkPZp/7CAC+pDSPf9DlrOcWwWYJZ?=
 =?us-ascii?Q?q17AzsEjqVe9OdHrSWG4dRdmY0ArTfobPX+j4BfHwSw8DiV3zZcvH38KUjGA?=
 =?us-ascii?Q?R4+3+0oZ7O3EbdnR1KANYCOXG6MbwRWuOXxDySR+nt4Jzu4GNDRbjLfU/opd?=
 =?us-ascii?Q?sS4wR5MjTdHKl3pvFQ2HAi4PXtUerrIkpUvHWERgAVNkV4wrhwRiFziFqkG/?=
 =?us-ascii?Q?VjwnJbURLWg+kIPUVQ1qpfaaWD+VHeCBiN1TjxOo6DtEYV2h/Ihf5kKcNeyC?=
 =?us-ascii?Q?KU4Y4NpicsDnFppz75i50UU1yYnTTP23aCzqUmGRLWF6GEy0RE3RS3nUIkoL?=
 =?us-ascii?Q?Dp0FfXrOfKEgQpWXC8Q15fSsHO014+DXiDByvM1y5YoJ7LCtGZMeeb4sgYx/?=
 =?us-ascii?Q?aPOawKIAOfLW8W1jaJcWB+oxaGaeE6N8mYmYIZrHmNiJQKf3OLnGKMRJxE3m?=
 =?us-ascii?Q?BefCCUYlT654431xYUUNTxmZO01glnKFdhCRc00/Kf6nNks0yyPrS46rim3Z?=
 =?us-ascii?Q?MTde6hFlVgNgej113BysmKyUvLbya6ozD/Ex8hRRvy3sgeT309ZAUB4elRsI?=
 =?us-ascii?Q?pS1R9hqrnpIFvlksFCr2fo9fd1O/4sk7TNP6q6t1X+CjFcjA1n/sQHwknowA?=
 =?us-ascii?Q?QMfyN6B2B8gt1UI1+IHzJpBzQ7R1ZRok4fkyIoWDvSP2mm+HrpYQ8eW3uwCW?=
 =?us-ascii?Q?b7YcomSuuRGHYXjEMQLYJA5/vcuD33XF6kA8LtJPjbtLnyH26K8Bc7QrkUrv?=
 =?us-ascii?Q?Hpy3lhh0MnmDyrYh9WXkgsExRtYL/enerTfo1zeOEIjnoteRLQOcHWFDdyZi?=
 =?us-ascii?Q?Dv39/BOlQ8AYdd8ju54KX6Ys2uZHzOzzaAueK3cFoEv3yRTsx4NbRAOob5kT?=
 =?us-ascii?Q?qzerMcEdc3ekJUFkUJQMamxX1QAQPlnq+SOfoX/P4P3DZ+dIcpILxs7QVugi?=
 =?us-ascii?Q?nKRwWYmOPGXJxqS0b44OegEZ+r8Ohq2MMoRp9bZxHo2mN8eWJ8MYQmWTib65?=
 =?us-ascii?Q?kJNLGAQ8rXHquX077OUO4M1cgCMTzKIHyPf0oXgfi88iDq+LCczha0ejkIRz?=
 =?us-ascii?Q?Q7+O1+Uog8+esk/U5g4vIMW0SxozyTqSBDByiKdZ4uCREDNWXY844EESuTY2?=
 =?us-ascii?Q?KTABT6FKUGWdyETD0VspJJELkiqBC4hkR7C63oGNwjY3o0QkF8B+BorGYbXf?=
 =?us-ascii?Q?YOEkUvYyferJNlO/bhPsLx76n5i2IfRS+kyCfeoLSMQlGJfo6IL/ioa5G6vV?=
 =?us-ascii?Q?5/ZE/tsk4TCtN3gK3qddncJuRDxn6j37tHNgC1W2SE7n97oYBXDKEXNn1wHF?=
 =?us-ascii?Q?VgtOY62Y7ZFV2UzLEpoNoEIrCMc+7Ihq/xLmgEKnjO2ssMgdkSvcGVb3wCTR?=
 =?us-ascii?Q?FAxdIQ6UEd5GYne6OT9VEWXEc1l2uGHaAHwSbkiLZykB+oDf9X9tGY5r01Ol?=
 =?us-ascii?Q?RVJN3RCWFq82F3UXOaz8GtG9KibhiEh1hudSK1DLA+wzN35hGdy7cT+fBJRZ?=
 =?us-ascii?Q?s/ia/1VDv2hzsJop1SwNonk3AtpzSCAJsX2ZJkK8agGLiaAXT3EYEqbAZY6G?=
 =?us-ascii?Q?ebWU+B3b9xHEnYHINSmBpkS5btmmwrNsPwN5HVQkIV0Uuul2gYKF136CwN1p?=
 =?us-ascii?Q?+le7wm+vGELOF69eobbjtunDOuw5bxoI0/9VDjakpapb8lBsEGYKE5e4poTH?=
 =?us-ascii?Q?ionUJJoZ4wYK9WHf/tkEMa8nuHv7ZAx74qpsuK0dmstsVFmljZai1q3CFbrU?=
 =?us-ascii?Q?3zcfmEdtdA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d9d53a-3b5e-479f-ca9f-08da47edb2a3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 18:52:25.9058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: amnaE0XtLXCDaJs3g+XSDYgj0lxKhl3JIHtgNybJ9wFZBMNde1oLixFOy5D26hNS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1578
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 06, 2022 at 11:28:49AM -0700, Nicolin Chen wrote:

> > Well, as before I'd prefer to make the code match the commit message -
> > if I really need to spell it out, see below - since I can't imagine that
> > we should ever have need to identify a set of iommu_domain_ops in
> > isolation, therefore I think it's considerably clearer to use the
> > iommu_domain itself. However, either way we really don't need this yet,
> > so we may as well just go ahead and remove the redundant test from VFIO
> > anyway, and I can add some form of this patch to my dev branch for now.
> 
> I see. The version below is much cleaner. Yet, it'd become having a
> common pointer per iommu_domain vs. one pointer per driver. Jason
> pointed it out to me earlier that by doing so memory waste would be
> unnecessary on platforms that have considerable numbers of masters.

I had ment using struct iommu_domain when there is a simple solution
to use rodata doesn't seem ideal.

I don't quite understand the reluctance to make small changes to
drivers, it was the same logic with the default_domain_ops thing too.

> Since we know that it'd be safe to exclude this single change from
> this series, I can drop it in next version, if you don't like the
> change.

But this is fine too, that really is half the point of this series..

Jason
