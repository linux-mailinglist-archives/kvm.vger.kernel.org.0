Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7FE773EAE
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 18:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjHHQeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 12:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbjHHQdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 12:33:01 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C36973D1;
        Tue,  8 Aug 2023 08:52:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jptrouzj93ed3n5wfufohGg+go7ej9+ngJ+JJS8qbj5NRzNFgljV2W410DYNoZPk5KiVkDt+7lfldmrI4dWFwRA839rw0/oM9YzXya4jjDd99DNkxc+03qjYWdS4TYot2WnWAa+hEytWJc38GylQM0MLRxu6BAgdNyLWBrwtzoPccy9FmzYOoQ6ZZtLHpoQ5FExT4BZ8/XUGVmExI3hL+Fe1SAfNJ4K6Jnr6JwTOKiGyvMdwMHT/bjHOWDs9E0YsuGv1gcvnbKzVMtHTz/xZN7yH9pu1G0vzmdEZ6yU90Dzf9JSbUUfz9DylLRmcZWW7nA3NoMqLwq+SIPN8T8zhFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snMaixUv2z4TD3u6LNII7XzZ0cPDH0WjSn9gRHyAGm8=;
 b=dbwUGOPJy2uCjjkIEk3tP7P3gp53OV0obosUzw3fzm44SVgP13ghHHklT85L0YNpn3Hp4bfVflVBtwTR+1ZPoI2Nk/4ceIQr6mnxHKtdApIqrLhwtThwLWDUX9UItIJbT9xk9VdGM7vynp6Jrv/DmJe7ygMHIUW3Pi35c/NJWpddC/3xWS28S5el9WroT0LJhTAFiZQ6nOnOCjEU45z0MU/uxDCO5Pj+2c7OGeRB8VIuDv1PPIqbSzUGjljucGkrkZUuRCJorAU3J2x+LygP83YsRQ+y0k/WonNuMHfp0LJdPdXxGxfRN9RL3m9TXKMNuPV8GynS00jrPmr4vFEKYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snMaixUv2z4TD3u6LNII7XzZ0cPDH0WjSn9gRHyAGm8=;
 b=JBs14SAJwhwjlGxvzjXtDamZW9HOyA6dQRahDE6qsXxnTx4QKiShpVAqc2UJuJ3gd0PzCBFwxFQE+okHUy4vSJ4NvNkjwjro/cMezJhjwVLpCPKdcqr7StoofRzjz6RLU1jSE/km9DtUHSYeGDKaiUkZR7ckfHUc9PUYp/dmdKkfwyBjBSwztqNqmkEvzL57jeakSa0l8uyIiykyNqUcXmCG+kh5O2r5NfqUj4SFffd/3jCGjfuOBHUaJsDTm3JGoxHFONHjl9PkpIEkknSza2pBBqqYClqil53we9KV5gM+nOE1h6UAZDb7vFe2zKXxso6MirZzAIjxz0RPqzZxcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4148.namprd12.prod.outlook.com (2603:10b6:a03:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Tue, 8 Aug
 2023 12:32:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 12:32:34 +0000
Date:   Tue, 8 Aug 2023 09:32:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        mike.kravetz@oracle.com, apopple@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com
Subject: Re: [RFC PATCH 3/3] KVM: x86/mmu: skip zap maybe-dma-pinned pages
 for NUMA migration
Message-ID: <ZNI14eN4bFV5eO4W@nvidia.com>
References: <20230808071329.19995-1-yan.y.zhao@intel.com>
 <20230808071702.20269-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808071702.20269-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: MN2PR16CA0042.namprd16.prod.outlook.com
 (2603:10b6:208:234::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4148:EE_
X-MS-Office365-Filtering-Correlation-Id: c5bc475d-6451-4e44-0ba5-08db980b8a9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 72ih9eYC/OZEbzdNzjhyTowebubiFkPqshPrEgaQDgu1Jx2Q8lWowNshxMvRrZrGXAGVtTq12dr8casoTO5osjLImWfk7bT4oXRmYIqFUEAIlxAWavbeKsFPOjirF+0pglMD59yOgAHxS3ESKNEnMjIG55skcA3e9pw1gEjd9XXkn+NdVuonj7+07AF7yDhZZfqOq1mqaMw/IBq2b7wcIeJOe383gMD6zIpILI86nn3zTMi3mpX6GhzRDuAr+02hzmqYUbbe9FHeqhRjEHiBX8ZCVJd0Lh/D4HctVN5xgbKoS+0QTP2d2eMsTy03eeQC+jgrPsiMeR+DhgPt5EYZ2H9Tr6RHGAbziYA8K9fXGEEs/cVq2F1CYntuplXgi9lf3lRoSRaspjOjXM7ViST04rbI8N97gtxw9ej17ML+19E9tE+dl7lZEvqGgkN90X41837Sbolf/EWgVZn22TwRqzDbeZJJdUDSmnSRuPaFk7FZvLez6QRBsNYXY8gk+UMk/kpiSsSl6i9nj+FdIzv61PJ7MPQJiII3Q0YyLDCvXUBtQstz376PvGG0LQbEukv6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199021)(1800799003)(186006)(2616005)(86362001)(6486002)(478600001)(41300700001)(6512007)(26005)(6506007)(36756003)(316002)(7416002)(5660300002)(8936002)(8676002)(38100700002)(6916009)(2906002)(66476007)(66556008)(4326008)(66946007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j3fLE6ijYpzwL07UhP5BZThL+uhZqfBQUNbaK2/Ac2M2ehu5WuTEHcPWpPOu?=
 =?us-ascii?Q?w2kVohXu0RQ7+ywRJLFCd4bSYbU3YFABuZikh150TaAtaTK451d9jMxeOIwX?=
 =?us-ascii?Q?vO2rMrYhkLEteDTt8wF233/Kwa9LQjsT5KhRLcLg/UXsi8qDtWHK/xiOz3mb?=
 =?us-ascii?Q?5r+lRevFjyYQpFFYgbQtid2Yg1EQvUlTFC3AJFXMCwBEiF5ayGrZtS4Wf/WL?=
 =?us-ascii?Q?ZuohmkvDCmVKgqcrwEtuAlKAA4tcrSlP+uFak/icnpwlmYGfiZbaiBDp6BnP?=
 =?us-ascii?Q?nFt+JnNSiKbwRSAp74QtEGqhFcZuZE7McNh39QgqPzi8I1EJpfEVEkOChNZw?=
 =?us-ascii?Q?ntnYm/QJnZlEHmT7guvfj0eLg2EmNVbAvYIjP25GCwx2rHAGhwnwH/1fIeuG?=
 =?us-ascii?Q?pDLztVVt7t+AlE1QnxWMK8pYBly9ttcDyqayd5nUtfJq7DBk3pF8tn/CLH4V?=
 =?us-ascii?Q?fGYMukZxBIk8LEICEmbFxNzvkriCNaQuEta5KkREaGfJCqOrZg0v+3MWJLvL?=
 =?us-ascii?Q?JTl6N/KDJoyYVID5LpVG6KSLuKVZMlf7WcUMKM+VdHnzQK5k9kCcKA8omGHM?=
 =?us-ascii?Q?jNuyR7eFNr2JVSaS4amivQX5gUa8vgFqyUb6tqGtGHIf1yoWsxDn8DGuqH0a?=
 =?us-ascii?Q?LnIKCUEB/hKtCR0DdC6To0lmQowNraIyEs6AiO8mNiRjG4AyOQjAYHMYwzAu?=
 =?us-ascii?Q?U2AN+muxxqirmISWLUooneuGPCEa5Y9piQe2x78aJ9yX+oLUs+0yQqYn7Z4I?=
 =?us-ascii?Q?EQapblVo71hnHQgLLBrNbAHZ+ekZFHMDNPuRF1eIDiauXi26DkB0l4yuJkBv?=
 =?us-ascii?Q?SQ9IOZVX4r4Esjh26EYHSvNgbu4YPPCzY+rF1MtlswGzSraY52TP07k+tLgi?=
 =?us-ascii?Q?3G+OnEBtAwyQxTnAZfbYy46JCNvhtclqc96d+hmsxBv8f5IoVOm/VT7x05kH?=
 =?us-ascii?Q?EqWhLOzOBwnEHeKWCVhD+5BQza8rRV8ThCWde1nPiC+HHIVjVl4HXjeIGE78?=
 =?us-ascii?Q?6FMX6rtHZ42thfD8qHRpvIHIWEVzLQqv4UhMvjzjHaVXC7tv+N5to4JfM8+W?=
 =?us-ascii?Q?YKFjby8VrggJQ9MlsjKvKkQ1dS/NQ0hcP5/vSJOVjVf9dtFOVNhARZM55pxR?=
 =?us-ascii?Q?/Eu48xit1kqyLWctSclQm6YfhA8b7OabCF/LdhfMfgUaEuK5LOe+Z/U18gDJ?=
 =?us-ascii?Q?dQzvLZ0UtEC4JEmTIN7xXEMEqHGVk23Ues6d1Br8qxOpeHl4sL8akHC82jDO?=
 =?us-ascii?Q?MgrC2dTW1+ut2S6DYzbTaZVj7TV6ADwynvTta+q1JtTmUeJvcQk4pa/+/oCZ?=
 =?us-ascii?Q?080RjxkY5rvrZnoFQfyMmbAY3joZx4VNItCDjOn33iFH0LVV8CIO2imXylfe?=
 =?us-ascii?Q?AwVAAtm1D8CKwhnitsX3g8GyildRtDzlimxrK/WKkn64zYukvcClxx6HcDbI?=
 =?us-ascii?Q?LYdvZXlT39fkQyxHjbXUJUH2schQiTX2eR/3SQUW4WnrqqHQGXuVshePJ8kv?=
 =?us-ascii?Q?JBQdWjDJnr7bbCw4TZtdbsikJePNhoBJ146wj/8Qx7/lGGj+c4co9JmtVcy2?=
 =?us-ascii?Q?iqRg6LGp2sMXc+VBTwdhMfjISviQfTmXsOim97FN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5bc475d-6451-4e44-0ba5-08db980b8a9b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 12:32:34.2005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: imPGRz/JFiq4ptheOfz2p6yibOJhIyCCflHfy5QfBlmCZUxktVzbl/nnxRhWVQdg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 08, 2023 at 03:17:02PM +0800, Yan Zhao wrote:
> Skip zapping pages that're exclusive anonymas and maybe-dma-pinned in TDP
> MMU if it's for NUMA migration purpose to save unnecessary zaps and TLB
> shootdowns.
> 
> For NUMA balancing, change_pmd_range() will send .invalidate_range_start()
> and .invalidate_range_end() pair unconditionally before setting a huge PMD
> or PTE to be PROT_NONE.
> 
> No matter whether PROT_NONE is set under change_pmd_range(), NUMA migration
> will eventually reject migrating of exclusive anonymas and maybe_dma_pinned
> pages in later try_to_migrate_one() phase and restoring the affected huge
> PMD or PTE.
> 
> Therefore, if KVM can detect those kind of pages in the zap phase, zap and
> TLB shootdowns caused by this kind of protection can be avoided.
> 
> Corner cases like below are still fine.
> 1. Auto NUMA balancing selects a PMD range to set PROT_NONE in
>    change_pmd_range().
> 2. A page is maybe-dma-pinned at the time of sending
>    .invalidate_range_start() with event type MMU_NOTIFY_PROTECTION_VMA.
>     ==> so it's not zapped in KVM's secondary MMU.
> 3. The page is unpinned after sending .invalidate_range_start(), therefore
>    is not maybe-dma-pinned and set to PROT_NONE in primary MMU.
> 4. For some reason, page fault is triggered in primary MMU and the page
>    will be found to be suitable for NUMA migration.
> 5. try_to_migrate_one() will send .invalidate_range_start() notification
>    with event type MMU_NOTIFY_CLEAR to KVM, and ===>
>    KVM will zap the pages in secondary MMU.
> 6. The old page will be replaced by a new page in primary MMU.
> 
> If step 4 does not happen, though KVM will keep accessing a page that
> might not be on the best NUMA node, it can be fixed by a next round of
> step 1 in Auto NUMA balancing as change_pmd_range() will send mmu
> notification without checking PROT_NONE is set or not.
> 
> Currently in this patch, for NUMA migration protection purpose, only
> exclusive anonymous maybe-dma-pinned pages are skipped.
> Can later include other type of pages, e.g., is_zone_device_page() or
> PageKsm() if necessary.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  4 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c | 26 ++++++++++++++++++++++----
>  arch/x86/kvm/mmu/tdp_mmu.h |  4 ++--
>  include/linux/kvm_host.h   |  1 +
>  virt/kvm/kvm_main.c        |  5 +++++
>  5 files changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d72f2b20f430..9dccc25b1389 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6307,8 +6307,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>  
>  	if (tdp_mmu_enabled) {
>  		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> -			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
> -						      gfn_end, true, flush);
> +			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start, gfn_end,
> +						      true, flush, false);
>  	}
>  
>  	if (flush)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 6250bd3d20c1..17762b5a2b98 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -838,7 +838,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   * operation can cause a soft lockup.
>   */
>  static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> -			      gfn_t start, gfn_t end, bool can_yield, bool flush)
> +			      gfn_t start, gfn_t end, bool can_yield, bool flush,
> +			      bool skip_pinned)
>  {
>  	struct tdp_iter iter;
>  
> @@ -859,6 +860,21 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
>  
> +		if (skip_pinned) {
> +			kvm_pfn_t pfn = spte_to_pfn(iter.old_spte);
> +			struct page *page = kvm_pfn_to_refcounted_page(pfn);
> +			struct folio *folio;
> +
> +			if (!page)
> +				continue;
> +
> +			folio = page_folio(page);
> +
> +			if (folio_test_anon(folio) && PageAnonExclusive(&folio->page) &&
> +			    folio_maybe_dma_pinned(folio))
> +				continue;
> +		}
> +

I don't get it..

The last patch made it so that the NUMA balancing code doesn't change
page_maybe_dma_pinned() pages to PROT_NONE

So why doesn't KVM just check if the current and new SPTE are the same
and refrain from invalidating if nothing changed? Duplicating the
checks here seems very frail to me.

If you did that then you probably don't need to change the notifiers.

Jason
