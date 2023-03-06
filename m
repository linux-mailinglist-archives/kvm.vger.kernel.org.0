Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC83D6ABFC6
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 13:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCFMng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 07:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjCFMnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 07:43:35 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE2D6EBA
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 04:43:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hldnNSyKIvO8L4Jg6qMH5n4eX3sDT6ISkgk/Lref0NhJFUvf6PRzAiTGeFfoDO/Q4tnkZO7IEwsBYkXGNnJTCscPKUJ2p7wbsUwuNZbwFSfOADEuilEwgx454HX4HGHnTr0EWlpFTApNhfOf5sRvFGk2NmUtt7LNUoxF5KdPd8tfLpaBVws/JtAWAkKsUGsiEBQ/7ETQCraqSwwpaV7n4LBs0HW/awxYc2V/hoemJibM94sSjBBdmlU1yFgwpl1/9dLmYAk5NMA6hjzxwvuWKN8JA7fz+C1ydXgN2gGodyKqNrp8s1WiCag15+JQw9mQxSEbZ94+G/Cmjsl9+F/eDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QhEix4hLsUkxNeTs1aW43EjTdwBtTDMBrupuLoGDONs=;
 b=kp6qVULSnbEjjlB0t1Hy0t0WbXGkDpCiLc+oAcFJm3XytDHs5DmGMPFejmbaKdUhfNawv2ykCoXDWefo8yaSdcDukV5efDyNQGZjQiSNFaX4hQaEEGhv1qcRNYanhAZEC1aMqc+HuJAR7G7SWV/yIoKvm+CcIQsUgm2H62KVCbfzNbt8IfeAFMW+xVF1E919mJKWL/nMOMMTwkt3m5w5Zoej/qFae/SDOKCxnV2DfXu2oJ2VWZMaVBc4G5r1EMQMmYob7e5mubXvG6srA2ka070Ejc784mAQBYxj1PRwFCamBuJ6klJlPpzOKDw6RDmtg2P6nn5nz4vUYPfC1qcAFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhEix4hLsUkxNeTs1aW43EjTdwBtTDMBrupuLoGDONs=;
 b=ZVp78E8wbIWeVBtWb1SuS71IYd+I/2zrHYkCr4xrhfqrvtkxJ//Q2gevMFOsSmeb+RN7OEAu0nIHqTt0bycM4BkK3BT+vBPkijFbgcazc+Fq11Ruer3+W29o18ADhga5O10RXDfAnITHiVz0aiPQ8Bp3B1kHcdb6JZ2oIoSjgmcQ0ahx9z1eTWrHdRoBk2/0ViQi3hgbFOg7xP1oLuvsCUVbAGKQto7zr2CBZrb7E8MEGFLYkh8ttGLdY88tAql8bVRSY1XwaP7Go53YEKBGy0XX1pNRcoYB+8H9khxCX2EXDXklEDBQkRl3VUBrUrONWXkfOgseXxRJhnDQHmGpZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5247.namprd12.prod.outlook.com (2603:10b6:5:39b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 12:43:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6156.027; Mon, 6 Mar 2023
 12:43:31 +0000
Date:   Mon, 6 Mar 2023 08:43:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Timothy Pearson <tpearson@raptorengineering.com>,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/5] powerpc/iommu: Add iommu_ops to report capabilities
 and
Message-ID: <ZAXf8XrQwnhGaMk1@nvidia.com>
References: <41528182.16281476.1677879021033.JavaMail.zimbra@raptorengineeringinc.com>
 <c40ec6aa-1e89-866f-14ee-dd5b067ce001@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c40ec6aa-1e89-866f-14ee-dd5b067ce001@amd.com>
X-ClientProxiedBy: MN2PR17CA0020.namprd17.prod.outlook.com
 (2603:10b6:208:15e::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5247:EE_
X-MS-Office365-Filtering-Correlation-Id: e709d8e6-4fd8-4750-9914-08db1e406405
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2higPSZ9+8WZZUqHFx1QSI3DTEctRlfuwJvw/vwK+4lAD2mmSlQoKV/pfr7yXzNwtyoPsLeUbJhYVZcedGqSjBAKqv/T+fMzZMM7RNqKimTG8HXZ7wOnnlV1t/hYfesTg+P/xKc9NEEWQZdYuzxpzB1pMZPpemEMbEJEKe9yIqrXQRArlqMxEqWSfQafrUQq7f7G1a2b4TLSuMiGSaVbhkGEUd3dcUb4hWf6sf0dPmicEDS93WSewBszW4Y1j0QDbfHht1Ezky8+lufCGU/0HRTa0Bf6Dn3QJr1WpL+T8Ha5CWivMv6zpU0h5rpiH+0KfNUh/+uzfXjSw1ffJbUZX54gl2+JyEcUHIuUGX7UD8VnLkZlE0H8hwUj4i/EmKTaUs0S33GfpQg386vsLkHKKdTLkYPGyH8CB+SHnqirRRb9Arnk1pUPU8ihSsSng/JrDAw9x21cQ7C+ZoLZx1m13Fu53jrEgZWJybVLtezfUAVb8Yi8Kxc+ijTp5I14eMNZ2f9Sk7vf0dt8yNdME+XemhvkIb2etexgD8XnspiE+jMaFFJKKZdM3ckZzI132MF4tj4NlTVlndt53zn+HRpSII3lGYrbeVOTp4P50VP4CVVPJnqdCLBR/oX0oIna7dIJTalF2riGeq8VXIK7giNhlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199018)(83380400001)(36756003)(478600001)(54906003)(316002)(38100700002)(2616005)(6486002)(6506007)(6512007)(26005)(186003)(41300700001)(5660300002)(4744005)(66476007)(2906002)(66946007)(8936002)(8676002)(66556008)(6916009)(86362001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VOvdn343N6KRVPhMY1wHMGuRgqOncLttQxBqRZyF78xSDJmpwpRj56Ri6s7p?=
 =?us-ascii?Q?BSMWidfMo9AI2YFwpxtlQqMttn+RapmjM07Zs4Vm6y7ONEHj0lqzGcIHmaLt?=
 =?us-ascii?Q?1BcFdZhTz9vCYOk46N9AvpwbyK0l82Eqg1JvC1MNM/f+ZTAVv/pykO5w26h4?=
 =?us-ascii?Q?n2/w7g028a6RAAMcjG3GofFcyEa4KN9rRwdiL+GXwOdnS0DM+eOdU/rUl8uc?=
 =?us-ascii?Q?5r6R9Km03fxJsiq/VK4ysNdyuOjnzMf9Cw4VH4tx1vJLQWyUgGTdB7platlz?=
 =?us-ascii?Q?H7Ndu7iQE0gicHfEblJ3HhfFlIdjFbYPUwBQ03AuMZtvHF3Mud63xYPgxSK1?=
 =?us-ascii?Q?0w0KnJbnefKHxaYnxzATWFjYUsXtH8ZkFqX3cb5Jv3tJvAa1AjIHYM1fnLP7?=
 =?us-ascii?Q?zcJNaAvqpY2U44S9RV3W2U7USKE3ZxXhsfBHyYozcZER3lID20MXxxwftWvu?=
 =?us-ascii?Q?wFMZ7c2O4mDTGCyr8dU3z4uyn7jslaBHkzu0VovA1AiGF7ABZKZQ8Mt4Gyhb?=
 =?us-ascii?Q?IRv+mMjaKV/IZmiBcpGH1b4xwx1shK4eihtZYVj+MkfMhPB3LVsDvz9B0wFF?=
 =?us-ascii?Q?pWH0FWYslV9Fa4oNCIqt6utGr14JD3kKF+vvM+NCQxVLJKJz6/4/CCfbbJ9b?=
 =?us-ascii?Q?xryTzWrsMtZenQNLVyiBS4D1W7OTZw48/KuRBYxAOP+XmUIW6oabg1T1QK5V?=
 =?us-ascii?Q?LK4fn65AVHHrSCGwFnnbk/NwdCc9VgYKTWgjkG9bl/xqxB6wUhrf6Bsc3UVE?=
 =?us-ascii?Q?cowcdyR2Snkujssnkw8iXl+LQe/eT1Ct4k9azYjdFGPBbZSYWNPrEhLclIVW?=
 =?us-ascii?Q?RqQVaMsWkjSVvsI4XH7l9zxiLpJSvKGHSlu4VlpQmw2rNa2dm6x/8VLTkwMI?=
 =?us-ascii?Q?MmXTfzwO/Qb/Na38Ixm6jRTNtqdvEVBoQ7hcb0mXUFS76gQLn6uH98Nll9bo?=
 =?us-ascii?Q?2iivd1dq0AJK7mLeZh507rSrV4NCMjk2wsC2juf56DgSxgWe59JsSk+wvl+U?=
 =?us-ascii?Q?27HSJNQTvXVGAO47wiVwXEjoVM2laIZ94p9u3bPK+s917FKHwBbQ267puUQN?=
 =?us-ascii?Q?GRrHKKwyfxRoK5AAyx+0wp/A4IJJ7n1dh7dbfcAdOe/9PEzYAQ//+/BK4xzt?=
 =?us-ascii?Q?3PSKwsWxMOsWwPIr18sSlgKcemidccr3PDYCo6+MULxznjt8hBxxph5KMQyu?=
 =?us-ascii?Q?wgVtXPQGuX9rv3hwI/wJmU8+6C1bE+eTkGz+yDJQdhxEsD5vJ0bhBY2oFJd9?=
 =?us-ascii?Q?isy3LNrP2dJWTZssWPetGx22iAbVG/5o6TVD19VVpgAIKQQ2aRtS+Y7Gk07c?=
 =?us-ascii?Q?VPiaWvEzQGrVfSBIx01V/P0e5YdZqFc+p7PYepOu25RCGzWvXXzRz1V5STQo?=
 =?us-ascii?Q?kyPVzr5MhyKtBgR4oxAFGaT3LKIoZ3CJfOC2xX05L4zdJ7pmCIi7tXgVAi/n?=
 =?us-ascii?Q?s9fJ5ewn49raHVsAvVo/e3LPsNY79ofEI+OBf3YUv3YcbGeujdj8UvR5Lj33?=
 =?us-ascii?Q?hzqOFRO7ATAqY1mkXYAIcOkz27/8BPjLECQQgtuk3JLrKS4QdzAJQ3CtHxWM?=
 =?us-ascii?Q?IGsyjo8auUMFAZZNWmS33ZNYDkLO6SsuUHy6cAOt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e709d8e6-4fd8-4750-9914-08db1e406405
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 12:43:30.9135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7mlMoICjEy2S93TIWKOHdCmJLEe2MozjTddK+nOSmM/4Cqkfp8DfhWUQVb/QdSR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5247
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 09:44:00PM +1100, Alexey Kardashevskiy wrote:
> > +static const struct iommu_domain_ops spapr_tce_blocking_domain_ops = {
> > +	.attach_dev = spapr_tce_blocking_iommu_attach_dev,
> > +	.detach_dev = spapr_tce_blocking_iommu_detach_dev,
> 
> 
> This .detach_dev() is gone now, the upstream has it removed. I am not quite
> sure now what should be calling release_ownership(). Probably
> spapr_tce_iommu_ops is going to need default_domain_ops, which attach_dev()
> will call release_ownership().

set_platform_dma_ops is what you want here

Jason
