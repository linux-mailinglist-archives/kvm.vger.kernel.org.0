Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130EA618A95
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 22:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiKCVbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 17:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKCVbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 17:31:09 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE1C1EEFE
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 14:31:04 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gw22so2875066pjb.3
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 14:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KI1Y+2tP/j6SujB0aEtA4H4UDqLF3RlhCIAg1pigSpw=;
        b=m8JvWagGTRZ1Vt3/qiGgf4FF9wVfkMULGHs1hFV9aYb4vuz8hdQkTntbxTwELlEWYH
         oEdBCBoYJuBiYDGXl3YwG4e9EsNVUXj/UtOfWBEuHLwDEC3fSBvfZIC5wRjOxkEygatE
         nw7JreYzY98XlzIIle1/oVtE4f6iuhwmKWT7ltoeYdM25lMRj24OuBWjLgemn0PREJd6
         3ty8dGTZSmCeSWuJmoZXzm00qnLV22IkTx3/BE9K4XtBK86mjVkkpbJX6nBHwkQ0ro/a
         OFsWxOgSA2wZo4FXF8zhenypGpicC/ku0XT1+GBJ4w/ne0VdTMVDkCtISOz358KrNNdu
         +jJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KI1Y+2tP/j6SujB0aEtA4H4UDqLF3RlhCIAg1pigSpw=;
        b=BiVrObxv7vMZAy1qx5SXjvujSWKQwp78kWBk0uWnwuDscIGxwYDFj/9QkE92sOq9pG
         FID279at6GLv5S1Bh1JF2oUs9FxD5IjKKBxjxBIXIi62VbJNuwVU0XFFsU2kbZx85a4w
         21VdStlmt+Hn7V/fZjUE0aM/mAGmDQlFPMXCCTabmYZSfcTxakSrFDdP6PRTwGHSEl6f
         FHvazIwYz4ZgjplmJW2Be7A14mdWvTZQ8zamV9/HbfTJFpKdeMm6/Itdih/bNom7s5/r
         LWA27LWzsmH112ZkcJcXpP1Aeq2xWJNR6Nbn6JazZQ1IZ9CZic2Df/2P+FGkf5AiOR4p
         OiHw==
X-Gm-Message-State: ACrzQf3XkXaHTseadxIpCCYVN6bc5IQQ4nA0cjRazqtJPBW6ASGWLMfS
        KVl0ced3o3Zcq/bBNRfobTcJnQ==
X-Google-Smtp-Source: AMsMyM7Kr/xQufDZGMLCDfYTs6EhMBUzjWRZjFoidzA/f+UEmqhcu8KzIwmYKKOFfOcBpb+kp7D2dg==
X-Received: by 2002:a17:902:9308:b0:187:971:a8bf with SMTP id bc8-20020a170902930800b001870971a8bfmr29896763plb.161.1667511064171;
        Thu, 03 Nov 2022 14:31:04 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id g29-20020aa79f1d000000b0056bc67f9da8sm1227200pfr.63.2022.11.03.14.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 14:31:03 -0700 (PDT)
Date:   Thu, 3 Nov 2022 14:31:00 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 07/14] KVM: arm64: Tear down unlinked stage-2 subtree
 after break-before-make
Message-ID: <Y2QzFHTDa2aJbRNf@google.com>
References: <20221103091140.1040433-1-oliver.upton@linux.dev>
 <20221103091140.1040433-8-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103091140.1040433-8-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022 at 09:11:33AM +0000, Oliver Upton wrote:
> The break-before-make sequence is a bit annoying as it opens a window
> wherein memory is unmapped from the guest. KVM should replace the PTE
> as quickly as possible and avoid unnecessary work in between.
> 
> Presently, the stage-2 map walker tears down a removed table before
> installing a block mapping when coalescing a table into a block. As the
> removed table is no longer visible to hardware walkers after the
> DSB+TLBI, it is possible to move the remaining cleanup to happen after
> installing the new PTE.
> 
> Reshuffle the stage-2 map walker to install the new block entry in
> the pre-order callback. Unwire all of the teardown logic and replace
> it with a call to kvm_pgtable_stage2_free_removed() after fixing
> the PTE. The post-order visitor is now completely unnecessary, so drop
> it. Finally, touch up the comments to better represent the now
> simplified map walker.
> 
> Note that the call to tear down the unlinked stage-2 is indirected
> as a subsequent change will use an RCU callback to trigger tear down.
> RCU is not available to pKVM, so there is a need to use different
> implementations on pKVM and non-pKVM VMs.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h  |  3 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 ++
>  arch/arm64/kvm/hyp/pgtable.c          | 83 +++++++--------------------
>  arch/arm64/kvm/mmu.c                  |  8 +++
>  4 files changed, 38 insertions(+), 62 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index cbd2851eefc1..e70cf57b719e 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -92,6 +92,8 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
>   *				allocation is physically contiguous.
>   * @free_pages_exact:		Free an exact number of memory pages previously
>   *				allocated by zalloc_pages_exact.
> + * @free_removed_table:		Free a removed paging structure by unlinking and
> + *				dropping references.
>   * @get_page:			Increment the refcount on a page.
>   * @put_page:			Decrement the refcount on a page. When the
>   *				refcount reaches 0 the page is automatically
> @@ -110,6 +112,7 @@ struct kvm_pgtable_mm_ops {
>  	void*		(*zalloc_page)(void *arg);
>  	void*		(*zalloc_pages_exact)(size_t size);
>  	void		(*free_pages_exact)(void *addr, size_t size);
> +	void		(*free_removed_table)(void *addr, u32 level);
>  	void		(*get_page)(void *addr);
>  	void		(*put_page)(void *addr);
>  	int		(*page_count)(void *addr);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index d21d1b08a055..735769886b55 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -79,6 +79,11 @@ static void host_s2_put_page(void *addr)
>  	hyp_put_page(&host_s2_pool, addr);
>  }
>  
> +static void host_s2_free_removed_table(void *addr, u32 level)
> +{
> +	kvm_pgtable_stage2_free_removed(&host_kvm.mm_ops, addr, level);
> +}
> +
>  static int prepare_s2_pool(void *pgt_pool_base)
>  {
>  	unsigned long nr_pages, pfn;
> @@ -93,6 +98,7 @@ static int prepare_s2_pool(void *pgt_pool_base)
>  	host_kvm.mm_ops = (struct kvm_pgtable_mm_ops) {
>  		.zalloc_pages_exact = host_s2_zalloc_pages_exact,
>  		.zalloc_page = host_s2_zalloc_page,
> +		.free_removed_table = host_s2_free_removed_table,
>  		.phys_to_virt = hyp_phys_to_virt,
>  		.virt_to_phys = hyp_virt_to_phys,
>  		.page_count = hyp_page_count,
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 7511494537e5..de8a2e1c7435 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -750,13 +750,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>  				     struct stage2_map_data *data)
>  {
> -	if (data->anchor)
> -		return 0;
> +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +	kvm_pte_t *childp = kvm_pte_follow(ctx->old, mm_ops);
> +	int ret;
>  
>  	if (!stage2_leaf_mapping_allowed(ctx, data))
>  		return 0;
>  
> -	data->childp = kvm_pte_follow(ctx->old, ctx->mm_ops);
>  	kvm_clear_pte(ctx->ptep);
>  
>  	/*
> @@ -765,8 +765,13 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>  	 * individually.
>  	 */
>  	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> -	data->anchor = ctx->ptep;
> -	return 0;
> +
> +	ret = stage2_map_walker_try_leaf(ctx, data);
> +
> +	mm_ops->put_page(ctx->ptep);
> +	mm_ops->free_removed_table(childp, ctx->level + 1);

I think "level + 1" ends up using the wrong granule size.  For example, if we
were at level 1 where granule is 1G, we should be freeing everything between
addr and addr+1G. But, the "level + 1" ends up freeing only between addr and
addr+2M.

Specifically, IIUC, this should be like this:

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -858,7 +858,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
        if (ret)
                return ret;
 
-       mm_ops->free_removed_table(childp, ctx->level + 1);
+       mm_ops->free_removed_table(childp, ctx->level);
        return 0;
 }

@@ -1396,5 +1411,5 @@ void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pg
                .end    = kvm_granule_size(level),
        };
 
-       WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level));
+       WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level + 1));

> +
> +	return ret;
>  }
>  
>  static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> @@ -776,13 +781,6 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  	kvm_pte_t *childp;
>  	int ret;
>  
> -	if (data->anchor) {
> -		if (stage2_pte_is_counted(ctx->old))
> -			mm_ops->put_page(ctx->ptep);
> -
> -		return 0;
> -	}
> -
>  	ret = stage2_map_walker_try_leaf(ctx, data);
>  	if (ret != -E2BIG)
>  		return ret;
> @@ -811,49 +809,14 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  	return 0;
>  }
>  
> -static int stage2_map_walk_table_post(const struct kvm_pgtable_visit_ctx *ctx,
> -				      struct stage2_map_data *data)
> -{
> -	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> -	kvm_pte_t *childp;
> -	int ret = 0;
> -
> -	if (!data->anchor)
> -		return 0;
> -
> -	if (data->anchor == ctx->ptep) {
> -		childp = data->childp;
> -		data->anchor = NULL;
> -		data->childp = NULL;
> -		ret = stage2_map_walk_leaf(ctx, data);
> -	} else {
> -		childp = kvm_pte_follow(ctx->old, mm_ops);
> -	}
> -
> -	mm_ops->put_page(childp);
> -	mm_ops->put_page(ctx->ptep);
> -
> -	return ret;
> -}
> -
>  /*
> - * This is a little fiddly, as we use all three of the walk flags. The idea
> - * is that the TABLE_PRE callback runs for table entries on the way down,
> - * looking for table entries which we could conceivably replace with a
> - * block entry for this mapping. If it finds one, then it sets the 'anchor'
> - * field in 'struct stage2_map_data' to point at the table entry, before
> - * clearing the entry to zero and descending into the now detached table.
> - *
> - * The behaviour of the LEAF callback then depends on whether or not the
> - * anchor has been set. If not, then we're not using a block mapping higher
> - * up the table and we perform the mapping at the existing leaves instead.
> - * If, on the other hand, the anchor _is_ set, then we drop references to
> - * all valid leaves so that the pages beneath the anchor can be freed.
> + * The TABLE_PRE callback runs for table entries on the way down, looking
> + * for table entries which we could conceivably replace with a block entry
> + * for this mapping. If it finds one it replaces the entry and calls
> + * kvm_pgtable_mm_ops::free_removed_table() to tear down the detached table.
>   *
> - * Finally, the TABLE_POST callback does nothing if the anchor has not
> - * been set, but otherwise frees the page-table pages while walking back up
> - * the page-table, installing the block entry when it revisits the anchor
> - * pointer and clearing the anchor to NULL.
> + * Otherwise, the LEAF callback performs the mapping at the existing leaves
> + * instead.
>   */
>  static int stage2_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  			     enum kvm_pgtable_walk_flags visit)
> @@ -865,11 +828,9 @@ static int stage2_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  		return stage2_map_walk_table_pre(ctx, data);
>  	case KVM_PGTABLE_WALK_LEAF:
>  		return stage2_map_walk_leaf(ctx, data);
> -	case KVM_PGTABLE_WALK_TABLE_POST:
> -		return stage2_map_walk_table_post(ctx, data);
> +	default:
> +		return -EINVAL;
>  	}
> -
> -	return -EINVAL;
>  }
>  
>  int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> @@ -886,8 +847,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	struct kvm_pgtable_walker walker = {
>  		.cb		= stage2_map_walker,
>  		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
> -				  KVM_PGTABLE_WALK_LEAF |
> -				  KVM_PGTABLE_WALK_TABLE_POST,
> +				  KVM_PGTABLE_WALK_LEAF,
>  		.arg		= &map_data,
>  	};
>  
> @@ -917,8 +877,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	struct kvm_pgtable_walker walker = {
>  		.cb		= stage2_map_walker,
>  		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
> -				  KVM_PGTABLE_WALK_LEAF |
> -				  KVM_PGTABLE_WALK_TABLE_POST,
> +				  KVM_PGTABLE_WALK_LEAF,
>  		.arg		= &map_data,
>  	};
>  
> @@ -1207,7 +1166,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>  
>  void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
>  {
> -	kvm_pte_t *ptep = (kvm_pte_t *)pgtable;
> +	kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= stage2_free_walker,
>  		.flags	= KVM_PGTABLE_WALK_LEAF |
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 5e197ae190ef..73ae908eb5d9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -128,6 +128,13 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
>  	free_pages_exact(virt, size);
>  }
>  
> +static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
> +
> +static void stage2_free_removed_table(void *addr, u32 level)
> +{
> +	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, addr, level);
> +}
> +
>  static void kvm_host_get_page(void *addr)
>  {
>  	get_page(virt_to_page(addr));
> @@ -662,6 +669,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>  	.zalloc_page		= stage2_memcache_zalloc_page,
>  	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
>  	.free_pages_exact	= kvm_s2_free_pages_exact,
> +	.free_removed_table	= stage2_free_removed_table,
>  	.get_page		= kvm_host_get_page,
>  	.put_page		= kvm_s2_put_page,
>  	.page_count		= kvm_host_page_count,
> -- 
> 2.38.1.431.g37b22c650d-goog
> 
> 
