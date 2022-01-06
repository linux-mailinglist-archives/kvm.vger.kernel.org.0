Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88BA485DE2
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 02:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344123AbiAFBNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 20:13:13 -0500
Received: from mail-mw2nam12on2040.outbound.protection.outlook.com ([40.107.244.40]:7712
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240018AbiAFBNM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 20:13:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJFZfTw/SCHxQBqDTzgkSDGBuYovT3TzX2B+VVSH8b3NosL3dNAGS90vB2iInDB21lcX9i1QQWfsb+oyYuWB1FXarPXDibauXkYLPBuzaF7xbno/EDre0a0rz5VGSXK9BkzECFql7+8mJBVWlW4NbPCd2b5Idz0jW2JIL9IaT8DN0DNXp/gBWpFLvWEOBCzEfgLCcwWmF7QhnrNN1wNzw6fG7BPli3Cy4br+JO9UV+42gkWdjXgDUU+Db7eyKNqUu5c4RF+Q5meFXUDUYJBuZmBNSsVh9nAkfcqbcEizE90HT7XtbftCBDi0DZ0E/9BlYwXQTbF82lijX+Bx9gVULw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a1hGmtzGHCweRuM4G52Hc4cbaeCCPQXBlW2++REx3bI=;
 b=eSZBwuHWCh/psTuSjJkDkBdGjiWC0DOTadFZMK2He7OKUpdNVH7+JOSRaFtZn7F0SPf+7cSDIMM1wu1vJrWTDTijTftCZ86BUuQnzLAXInuv+VXKcDGO4x4BQw4bg+PhYonOUGhX/NAmoAdE2MG6jRdxyrS7f5PAj7G/1rV9V8MIBhoc4r1dLQchQCAtKI5g9hGgxMoa/LrgSLy2rKb0194728mqTwqck+wMHwFUlSCcV4lWLWcXKpVNcJvP1iYQZW2O4TM9UwD50epUsfP5afW+EvvBJr2J6m1J4RFqGdWDKtCpLsrk0wV1c7bji7GsNP/FjWmsNtkddNHkyWEVCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1hGmtzGHCweRuM4G52Hc4cbaeCCPQXBlW2++REx3bI=;
 b=nJxuEurMmnJ7iHaQAccbHWfp8kWlGLzMBWeh5iOeXSiEtJZzThn2bF2Nx49aKds7LTO8dHlrvCFUR/LRzO7J8zRM2SuE3XkpwTlJYB7XKUKlW0cgUoHDyP0zWEfI1qc+e8xpupy4ZpnDpuOP98K2VzV0iqEqfGbfsm2o8Eg7NEZVww/A2AZH9qo7Dz6Ir64TLePGioxhzrEkNFdAEJ5Y7LD3/3gVOCNaDMX5tywZeDR5trNLGXYN2Wogs8XCUydnb6M45fij18iuQQWSkDHH0rscGrNAnG4XtLTJh48hxJuNKn8C5CrQ0vgpxJpbpiSFBYde7FHqLdOued0PDbIMRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5112.namprd12.prod.outlook.com (2603:10b6:208:316::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 01:13:10 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 01:13:10 +0000
Date:   Wed, 5 Jan 2022 21:13:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 00/16] padata, vfio, sched: Multithreaded VFIO page pinning
Message-ID: <20220106011306.GY2328285@nvidia.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
X-ClientProxiedBy: BYAPR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 165cf670-d155-41e6-5d11-08d9d0b1b3ed
X-MS-TrafficTypeDiagnostic: BL1PR12MB5112:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5112DD58B9402732EB10540FC24C9@BL1PR12MB5112.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eoB2Sn+RuHqLF6sH8b/oHpIoxiDT3bt5gR6tnsFa3sMEJ/wPMPGutIrfqpPdEH9cqcMRSxskAo9IWLfrfcHXL+mJ37yhEYatFKoypRubqGbe5lM7ZQzuzFGxmn1X5hIi7UqqGG72UBkcUMBdie2Q7kPvqajjUK6Emwd8gA/dkSRkQZgpJrCExnY/rXCiN/oipTGGLjx37VOKBVfRNH+kNcmLxI5b3l3/T5cU5xmDQRpD+4gIrqH9eV3ETsr7s5O0u+a/h0Mm8NITHeLIzr+/AGkSJtqidocZgZ6jIDbr55ZscVdyDW+Dqik5SGKgKJb/tFvZdgxhQyiqCGisYOtmpoUNdqE4JQz6Tlw0S5bv9GurZJk9b5Srh2epjH17RIvcmi3ykncyDhmEUO2Ou1YmMgZ46UkL1qRVJI5ALeTnFehSQ9uVbAejcKC3R8yUEfACxb33isSCPAaFQ1K7Q2iIc1BjPKR3S08LcRo3ZMxq+lOsQ63XYC0pKRRciyvXrMghUBmwydSCEIcg9ZwirKNwwdtT2rEvKT/BBKB8E8eZgxCgvuOz0wlN9+uh52s0Prb9BBGX/KvONkJTIQDmjYjfgiU1XtoOqBC7M4DTTdFJaxeCDDMpFhL9ajdF+nHui2Ge2EgGrk52TtH7YrVumtgb6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(5660300002)(83380400001)(6512007)(6666004)(316002)(7416002)(6486002)(38100700002)(186003)(26005)(2616005)(66476007)(66946007)(8676002)(2906002)(66556008)(54906003)(8936002)(6916009)(86362001)(36756003)(1076003)(6506007)(33656002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZDcnHsmHgHq+Hc/qn10+mbO24IwQfBNZUskMgqQTygJA/e7uar6UeMGsYtgi?=
 =?us-ascii?Q?R2pGJxIILMYg9FMdprv7dfJbmxsn93sE2TMzp5L0DC3x7Ncie0pFL4q2CzPT?=
 =?us-ascii?Q?H3ctfzorSshxa7+vk7SE6sUZ8RSs/sc6sG+wUTbG9eGu5a9KUS/5hfJTNxkM?=
 =?us-ascii?Q?Oq0N4pjqAspZlRperVbo0ZCzrJyjnxNblVuIoRlo35RRoWvcO+AT4cvqSMrY?=
 =?us-ascii?Q?DcgcP1YI8Dcd8tjyDparYnfc4muhHYNMFJi6dOhgFxgMbREgzDmuOV8OZtUg?=
 =?us-ascii?Q?2kNjeWToBlsZHUNMssF55HpE+rd2EdMnP5+ZjtsL2BYwuFVfMWO6GdnZD7hH?=
 =?us-ascii?Q?043OuiBzUcEI3ced13f1/tjbb7kEQwx/VFd3DpBGi9WESf/wSSbgnO9IMwl2?=
 =?us-ascii?Q?Wll2FHQk/wmVf6O3cst7GAnW3AORCuef0P972K4ZFYzWGIjJiCOa4iINbsmB?=
 =?us-ascii?Q?/dtn9acNEFwi7I1c8pID5euaSKZDcNXTQ5MhspDcZynIH61VkzeZ4H6O7cV0?=
 =?us-ascii?Q?jO+pg0ZHmf6uhcCHH3d2Q/zFUrpSzEDIF0WlfyEI/7KRuA6UtriemFgWOXTk?=
 =?us-ascii?Q?Z84Voo7/lOGwA4cvX+ma/k8v09SSL+t+ofW6xocgPnrbKj8w6vtm8IQtdaHs?=
 =?us-ascii?Q?7m8Cogg9anQalOd+NC3vwtI6ItTx5xefUI9nBTYzrzf8JbzISURXoYnnlIeK?=
 =?us-ascii?Q?5pHosGIZCpETo7UeaUHhI33NQd8f4Q+YpjmWce015brXEl0ptmhfP5OgiJzw?=
 =?us-ascii?Q?YQpeEdcD6poxYdju3bS5e/cpdFedipOIP9cHwpDaV7pFkDvxr4Di2fnWXMed?=
 =?us-ascii?Q?D62lDt2vWqHRd+NsAlrCKbG7kiYsWPtVrFG9m1pFxEs4ZsyYTZfcuSKkTIJ4?=
 =?us-ascii?Q?Lg1bc7mNxwoxwI7hg4m5sIvov/sfjjgmckcKnLaZ3wP0dSBkvgFwDCIKCAZW?=
 =?us-ascii?Q?rpVf9tsgcYkygSp6hHhLPyYI9gAKiurRnp+fORF8nhTpHsEHI1pwukV9+0l4?=
 =?us-ascii?Q?B7NmIt9x1cCnBEmY2LbgepNYyETz69a+QDg+AmU112BTNVnQlx6byyLpgHVV?=
 =?us-ascii?Q?TXe6aMIig4pZlAOJ+TaYOEculQuPMiwcsW2CjBFSdUQAtMn2Rbc3If4KtmSt?=
 =?us-ascii?Q?gJL4apzMKEgQmdTHv/bysmbgoT7St9u+3n+/hepgaAMbShvoEh95W1F4GLG4?=
 =?us-ascii?Q?epUQdZxt+20Ft+CS2dm0VRfrYSsAnXk9UI1ihydVayws3AEIsMiGwoLs80Li?=
 =?us-ascii?Q?JnH7Rdz18RNtMfPCl3akoOZDHIHoJtpjkOJrF1QMNxZ8kYM0dXMjKWaYny/l?=
 =?us-ascii?Q?kDTQFNCJhB6Phe1jAuZbT6vZEwYe2DMYvsvT1yn2ehUVuGasRc3wkdXMZKy6?=
 =?us-ascii?Q?oAYELdS67T3axAXA9ZtSk2/JqwUBwyjWBqDdMWnqU4a0Vk7rjXl1heGEMryF?=
 =?us-ascii?Q?sNbx0YAr4MiDEAVQyeD5Z6COl17kYD8ZINC61p37YPp0EZ+k0+hsxnOvlshC?=
 =?us-ascii?Q?39uY7QzPN4F41IfVrLcLbngcV5iuwwRnbQ5szkdkkJKiHJGGN2YwL3VTX5T+?=
 =?us-ascii?Q?aKUbusMDCaQpccWr0Vo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 165cf670-d155-41e6-5d11-08d9d0b1b3ed
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 01:13:09.8444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mBtLx4WkiEhTk5QaW1Nw0p+e0i2NbNYaBO2C3kd/T4VBKPWaHVPRhWlLQEPnNhgP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022 at 07:46:40PM -0500, Daniel Jordan wrote:

> Get ready to parallelize.  In particular, pinning can fail, so make jobs
> undo-able.
> 
>      5  vfio/type1: Pass mm to vfio_pin_pages_remote()
>      6  vfio/type1: Refactor dma map removal
>      7  vfio/type1: Parallelize vfio_pin_map_dma()
>      8  vfio/type1: Cache locked_vm to ease mmap_lock contention

In some ways this kind of seems like overkill, why not just have
userspace break the guest VA into chunks and call map in parallel?
Similar to how it already does the prealloc in parallel?

This is a simpler kernel job of optimizing locking to allow
concurrency.

It is also not good that this inserts arbitary cuts in the IOVA
address space, that will cause iommu_map() to be called with smaller
npages, and could result in a long term inefficiency in the iommu.

I don't know how the kernel can combat this without prior knowledge of
the likely physical memory layout (eg is the VM using 1G huge pages or
something)..

Personally I'd rather see the results from Matthew's work to allow GUP
to work on folios efficiently before reaching to this extreme.

The results you got of only 1.2x improvement don't seem so
compelling. Based on the unpin work I fully expect that folio
optimized GUP will do much better than that with single threaded..

Jason
