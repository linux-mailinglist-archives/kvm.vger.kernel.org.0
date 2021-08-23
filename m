Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3934F3F4D38
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 17:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhHWPSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 11:18:49 -0400
Received: from mail-dm6nam11on2042.outbound.protection.outlook.com ([40.107.223.42]:39905
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231156AbhHWPSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 11:18:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktx5v9pCniLmx+n0KVt3/rWcJY2gqBJgOwCWoEyN8yD0zg8IY70TfloWRi5olQ5CLfC56JFaEDbNHFrO3Ur5zosqj+pQAx8FRlL8QuqFbHwADOY2bo/matnYRgMrt7dqKp6v8xsty/5dthKPRFr4H0mzZf9Awb8o3I7zsDtWvzPdSinS0Dki46qCZq32n3IlegO26hIuGTHmSoBbCrVWp556R1rxPJfe2jSWPHXaeySH/8a6mPem6mK1nwjiQcPdjiVcOjZABZOrIBNd1eRPq8setPXQHA58xaLJmYnqOhJSdn0nXIlKctE6WxXBvVLovVWfkBWvMwBLC9EIgaHNiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jC6RdIuZesuBF2DAMEyXKkHxQUECylm5zxxJnOr6dds=;
 b=CAgFEUtSeSyL9RKrHrqYsPiyy42zQ6MJE1z/z+MXvl71kgA7yVaQpVTuRXTTqN6yUPBJj8oOjaZZRwcDM1Wyr34CrjM5/QrJw7rYoq325CTipJXzZdAIJZY861wWYY6BW2Bopsrso9DOhiOtfSj1wTq2PpfvNxNuXGm3WgohoNSnFjDr8fnFevC3Tml4FTNmmncrF0fPiWZ5TMXCfj8jNEpg9xFHrL5fMDT3PvTGMzHVc4eEGXDM/FCNTMfssoJATMqzwNOaaWg3nqLz/rOr+wXRpuZOXQhRt7iJoqnb9l8BO2N/9MJitQbHQqaRogMpzsbuUWnde4vsSi/m0gW1bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jC6RdIuZesuBF2DAMEyXKkHxQUECylm5zxxJnOr6dds=;
 b=pq0hGKNrc1PV8afJRaY7WE624/+6p4wj/SYbSg2I8hcfUyzRFirq8V7gELzSRYfdlD9m693wxAaL03MuCx5rDY0+RFwKwNY2X9UuDH0XFkW9Nl4J4lamcXfv0b6RF3FP7ztSY1R8jUK4PU5Y3TIVtI0DZn7RgY/OnIZyyA3dJ+k=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM6PR12MB4299.namprd12.prod.outlook.com (2603:10b6:5:223::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Mon, 23 Aug
 2021 15:18:04 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 15:18:03 +0000
Date:   Mon, 23 Aug 2021 10:15:49 -0500
From:   Wei Huang <wei.huang2@amd.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH v3 0/3] SVM 5-level page table support
Message-ID: <20210823151549.rkkrktvtpu6yapmd@weiserver.amd.com>
References: <20210818165549.3771014-1-wei.huang2@amd.com>
 <46a54a13-b934-263a-9539-6c922ceb70d3@redhat.com>
 <c10faf24c11fc86074945ca535572a8c5926dcf9.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c10faf24c11fc86074945ca535572a8c5926dcf9.camel@redhat.com>
X-ClientProxiedBy: SN6PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:805:66::21) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
Importance: high
X-Priority: 1
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SN6PR08CA0008.namprd08.prod.outlook.com (2603:10b6:805:66::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 15:18:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d06bec8-c758-49c6-018c-08d966493353
X-MS-TrafficTypeDiagnostic: DM6PR12MB4299:
X-Microsoft-Antispam-PRVS: <DM6PR12MB42997C8A5E12766977EF42C2CFC49@DM6PR12MB4299.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: euPvQ99uXidqkUYi+S6Iu52qg16hPolj3te0+JndVkwQk1Wb6fUaHqouMVDjlqfAHwpJHzBYcpinKNojBxYFZfP3cU7Kr8HIdJARJLExeVf6BUTyCT9dMhtXELPsjry9w5d2N5Vm7lEN2W79kjQDq/bWOLW89obP+1FMyW6ne3LJHw2ju2NuGyBp9+DjwbQTOUOi4J/RHR6Tz3A5a3CiK61Jjr+5To9zUCAE2RGgFXCPEcoKAyioWAJJpx978COzKG4Svb5OexRfp4b2WxwgbPIDGtiJwfi3AfN9JrMEDqwjwOwsg+JnwHrDFER81CbrGbnpK5SH3Bl9XyXWdKlCsI1nBVK/lsX9BHFJFhvLCLSbMr06fBsg/JoKxnxI/pHBMvUFQvIQeGrdU3lRRNc5cjj98VRRDMXjONRf9/+2Ut9ma2GbrknoDNzKOOvYkk2Kz8SSfAPOqjZ+tg3WqyDDYMPbA6Vuvbn6WqmwrqG4DqcVyjWX9BXhppxcI9d+WXXYf8PpAFRJT33qHEeRk9Wyorh9NFE7w04jimC3iTHrgvrqsaDDe6N38ogBf42c7bxODocFnCXjMsXUPTEQ26I0fjBmdNTc7kH8/jFvAnzIFdZIxSXawHMp+u2doxcK4sgjwnlHSZbYhusor1rbENjr1Nd3VNYpJmWTVMcYCwX/WpnvgO9gireQvnltCDZcyFYqBgNZhlnehUBgNzV0N+bxfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(66476007)(8676002)(66946007)(66556008)(6666004)(38100700002)(38350700002)(26005)(53546011)(5660300002)(186003)(6486002)(8936002)(956004)(52116002)(4326008)(6496006)(478600001)(86362001)(83380400001)(6916009)(316002)(7416002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0g8YR24PG49uwKT+/wGKKYEFu49FAVcZPMMzfyPEkiEmOo0NpoPkDMIFeCuD?=
 =?us-ascii?Q?+GB0GEsWbVFMJbDGIyNOhp7raVvT4hmCx/ZPRMdln2bKwduvc0HvqqOZ3XxJ?=
 =?us-ascii?Q?WeX9ch/1ZvovFsrL908OMuVmWT5Q1w1kHbzkMC7ED9f7xIpIN/srSUE1RWfV?=
 =?us-ascii?Q?e3ZdcSXcnD73dfAm4elFOBZP6/WXHN2BbCUPFTA045vevFmBB/OXqf9ZyIJ/?=
 =?us-ascii?Q?FHG+VK5NiNdCU1gYbWfW74eNqFKkiMJOVHOwzgmm4/U/BFa07FMJyvGbZoCF?=
 =?us-ascii?Q?QFH70SomSGbNuEmpUkE3GjZWoeFY1BNh7hkzH1XJrc83EPekmwoskN96czRf?=
 =?us-ascii?Q?gt7EyRVoNTGnqKPgGgakq7O+jdYif4QdV3hVtowpxlhaSzUGLmoBd9U1Sf41?=
 =?us-ascii?Q?kB7xX8iLOXBC+6CgjTMqT8HgslkSAMbCt5h1CDY6e79qDKXlCbOdQM/mRPeT?=
 =?us-ascii?Q?criv2kcFvptzKJpx+G1E6pTMs4HgrCCyXg0Egasddeo3+AmClgFIEhqPWU0Z?=
 =?us-ascii?Q?bXfUSwLvxx3ppUYmFy9a21YdhFSLjKuFhYzmURF1wQyzons8nqs8Mk6GJ5mI?=
 =?us-ascii?Q?Q6+JDJLa7Vt61xh7en56Tvy26DWGy6JcBThzB9rhm4EmOjNG6uA1g7keNQFr?=
 =?us-ascii?Q?F47E9zlt8of1O489/LkJaSEgB6QANRaKwkgIMGjbnKcJRC3RR22NwRuNExVe?=
 =?us-ascii?Q?hSWFf8Qnr1tCguiASROzXTfU4RKwj1wiaZStuUlkw3iH6smYnVBOVTNoBD9Q?=
 =?us-ascii?Q?Hqc5GCswJ8j7nhKUpXZi79loEGWG3SSGV6K+0+KERF5HAisF4uU0BCShYgKN?=
 =?us-ascii?Q?CtBeVkXiFaH481sqy0AKso345Gv5lAhE1egTz1Ma1vkWIi3SBEIS88A93//P?=
 =?us-ascii?Q?RWzOBNcpFXReIrzRi3VfABVTV+abDhx0yzYPvoDLQROoKdBkLmXDH2fNzl59?=
 =?us-ascii?Q?q8ZT1qqKNatjmQ1Jkt8dDgv+iMbJGw2tIvT9Oy032zQ566419wnIDYCqICqo?=
 =?us-ascii?Q?gUTlS6ZvnpTIJ/SDr0ItqyctHfcAFPSb258yJ15Tplwv4WM0GMmZbbvVAvku?=
 =?us-ascii?Q?J9Dgj0Es/NPRb4vEVpf26KN6v2X9lu3KkVqtzqug/+3r+3RgNIlkx5EZ00bE?=
 =?us-ascii?Q?Wj8UH3SwrrOJKgANzCuuOGEMhyxuP9vX1oslQjd8+LeosLGl5Gh/FFrgGlzS?=
 =?us-ascii?Q?h2ffR77CFsAVkyLzDn3DbSv2Aou558PGwSCYo36mN7Tvf5H2+Eo8+YZOosIO?=
 =?us-ascii?Q?5lAgO4izNWHfGUerJkt2mEfsC1bZcOUA1Cx9y9YcbAIUQH4iGE2K84s2oNd9?=
 =?us-ascii?Q?1LNyJhNw//TtdFtoYe6E5kCe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d06bec8-c758-49c6-018c-08d966493353
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 15:18:03.1588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uqTnjtn3rs8vskMLQ2zT+G1/Ie4fokz6unAvvVt3dir1/Z3i59SHOrvlI3aFLt/B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4299
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/23 12:20, Maxim Levitsky wrote:
> On Thu, 2021-08-19 at 18:43 +0200, Paolo Bonzini wrote:
> > On 18/08/21 18:55, Wei Huang wrote:
> > > This patch set adds 5-level page table support for AMD SVM. When the
> > > 5-level page table is enabled on host OS, the nested page table for guest
> > > VMs will use the same format as host OS (i.e. 5-level NPT). These patches
> > > were tested with various combination of different settings and test cases
> > > (nested/regular VMs, AMD64/i686 kernels, kvm-unit-tests, etc.)
> > > 
> > > v2->v3:
> > >   * Change the way of building root_hpa by following the existing flow (Sean)
> > > 
> > > v1->v2:
> > >   * Remove v1's arch-specific get_tdp_level() and add a new parameter,
> > >     tdp_forced_root_level, to allow forced TDP level (Sean)
> > >   * Add additional comment on tdp_root table chaining trick and change the
> > >     PML root table allocation code (Sean)
> > >   * Revise Patch 1's commit msg (Sean and Jim)
> > > 
> > > Thanks,
> > > -Wei
> > > 
> > > Wei Huang (3):
> > >    KVM: x86: Allow CPU to force vendor-specific TDP level
> > >    KVM: x86: Handle the case of 5-level shadow page table
> > >    KVM: SVM: Add 5-level page table support for SVM
> > > 
> > >   arch/x86/include/asm/kvm_host.h |  6 ++--
> > >   arch/x86/kvm/mmu/mmu.c          | 56 ++++++++++++++++++++++-----------
> > >   arch/x86/kvm/svm/svm.c          | 13 ++++----
> > >   arch/x86/kvm/vmx/vmx.c          |  3 +-
> > >   4 files changed, 49 insertions(+), 29 deletions(-)
> > > 
> > 
> > Queued, thanks, with NULL initializations according to Tom's review.
> > 
> > Paolo
> > 
> 
> Hi,
> Yesterday while testing my SMM patches, I noticed a minor issue: 
> It seems that this patchset breaks my 32 bit nested VM testcase with NPT=0.
>

Could you elaborate the detailed setup? NPT=0 for KVM running on L1?
Which VM is 32bit - L1 or L2?

Thanks,
-Wei

> This hack makes it work again for me (I don't yet use TDP mmu).
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index caa3f9aee7d1..c25e0d40a620 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3562,7 +3562,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>             mmu->shadow_root_level < PT64_ROOT_4LEVEL)
>                 return 0;
>  
> -       if (mmu->pae_root && mmu->pml4_root && mmu->pml5_root)
> +       if (mmu->pae_root && mmu->pml4_root)
>                 return 0;
>  
>         /*
> 
> 
> 
> Best regards,
> 	Maxim Levitsky
>
