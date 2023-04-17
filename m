Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183FE6E3F69
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 08:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjDQGJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 02:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjDQGJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 02:09:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A441E30D3
        for <kvm@vger.kernel.org>; Sun, 16 Apr 2023 23:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681711731;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7/GX76h4Kb0kaWGv3m6HKSx7P+gkzG44sMPzyc+rFsM=;
        b=Zgdz7ZbWTTGaSEcuxhaqGwRGpqcHGI9PdTibTG4weyZcRp5CPn91Ugd3P5U9+JlGBL32/3
        CaUq8GlHnX/7VzdKZJ+QHKqyjBfXB00ms5NWlpUT4KQn7NWH0l00U4dxteFsz4TWJ+ds/0
        oGtbVXMfVvBxTXgSbO738zPNseFOdnA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-Ly9QmHwqOVaCcW9eUcRuvA-1; Mon, 17 Apr 2023 02:08:48 -0400
X-MC-Unique: Ly9QmHwqOVaCcW9eUcRuvA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41078855300;
        Mon, 17 Apr 2023 06:08:47 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A4D8240CE2D4;
        Mon, 17 Apr 2023 06:08:35 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 01/12] KVM: arm64: Rename free_removed to free_unlinked
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Oliver Upton <oliver.upton@linux.dev>,
        Shaoqin Huang <shahuang@redhat.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-2-ricarkol@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <47421b51-82f7-2832-6e28-8d855e2813f3@redhat.com>
Date:   Mon, 17 Apr 2023 14:08:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-2-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/9/23 2:29 PM, Ricardo Koller wrote:
> Normalize on referring to tables outside of an active paging structure
> as 'unlinked'.
> 
> A subsequent change to KVM will add support for building page tables
> that are not part of an active paging structure. The existing
> 'removed_table' terminology is quite clunky when applied in this
> context.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h  |  8 ++++----
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +++---
>   arch/arm64/kvm/hyp/pgtable.c          |  6 +++---
>   arch/arm64/kvm/mmu.c                  | 10 +++++-----
>   4 files changed, 15 insertions(+), 15 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 4cd6762bda805..26a4293726c14 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -104,7 +104,7 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
>    *				allocation is physically contiguous.
>    * @free_pages_exact:		Free an exact number of memory pages previously
>    *				allocated by zalloc_pages_exact.
> - * @free_removed_table:		Free a removed paging structure by unlinking and
> + * @free_unlinked_table:	Free an unlinked paging structure by unlinking and
>    *				dropping references.
>    * @get_page:			Increment the refcount on a page.
>    * @put_page:			Decrement the refcount on a page. When the
> @@ -124,7 +124,7 @@ struct kvm_pgtable_mm_ops {
>   	void*		(*zalloc_page)(void *arg);
>   	void*		(*zalloc_pages_exact)(size_t size);
>   	void		(*free_pages_exact)(void *addr, size_t size);
> -	void		(*free_removed_table)(void *addr, u32 level);
> +	void		(*free_unlinked_table)(void *addr, u32 level);
>   	void		(*get_page)(void *addr);
>   	void		(*put_page)(void *addr);
>   	int		(*page_count)(void *addr);
> @@ -440,7 +440,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>   
>   /**
> - * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
> + * kvm_pgtable_stage2_free_unlinked() - Free an unlinked stage-2 paging structure.
>    * @mm_ops:	Memory management callbacks.
>    * @pgtable:	Unlinked stage-2 paging structure to be freed.
>    * @level:	Level of the stage-2 paging structure to be freed.
> @@ -448,7 +448,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>    * The page-table is assumed to be unreachable by any hardware walkers prior to
>    * freeing and therefore no TLB invalidation is performed.
>    */
> -void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> +void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
>   
>   /**
>    * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 552653fa18be3..b030170d803b6 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -91,9 +91,9 @@ static void host_s2_put_page(void *addr)
>   	hyp_put_page(&host_s2_pool, addr);
>   }
>   
> -static void host_s2_free_removed_table(void *addr, u32 level)
> +static void host_s2_free_unlinked_table(void *addr, u32 level)
>   {
> -	kvm_pgtable_stage2_free_removed(&host_mmu.mm_ops, addr, level);
> +	kvm_pgtable_stage2_free_unlinked(&host_mmu.mm_ops, addr, level);
>   }
>   
>   static int prepare_s2_pool(void *pgt_pool_base)
> @@ -110,7 +110,7 @@ static int prepare_s2_pool(void *pgt_pool_base)
>   	host_mmu.mm_ops = (struct kvm_pgtable_mm_ops) {
>   		.zalloc_pages_exact = host_s2_zalloc_pages_exact,
>   		.zalloc_page = host_s2_zalloc_page,
> -		.free_removed_table = host_s2_free_removed_table,
> +		.free_unlinked_table = host_s2_free_unlinked_table,
>   		.phys_to_virt = hyp_phys_to_virt,
>   		.virt_to_phys = hyp_virt_to_phys,
>   		.page_count = hyp_page_count,
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 3d61bd3e591d2..a3246d6cddec7 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -860,7 +860,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>   	if (ret)
>   		return ret;
>   
> -	mm_ops->free_removed_table(childp, ctx->level);
> +	mm_ops->free_unlinked_table(childp, ctx->level);
>   	return 0;
>   }
>   
> @@ -905,7 +905,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>    * The TABLE_PRE callback runs for table entries on the way down, looking
>    * for table entries which we could conceivably replace with a block entry
>    * for this mapping. If it finds one it replaces the entry and calls
> - * kvm_pgtable_mm_ops::free_removed_table() to tear down the detached table.
> + * kvm_pgtable_mm_ops::free_unlinked_table() to tear down the detached table.
>    *
>    * Otherwise, the LEAF callback performs the mapping at the existing leaves
>    * instead.
> @@ -1276,7 +1276,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>   	pgt->pgd = NULL;
>   }
>   
> -void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
> +void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
>   {
>   	kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
>   	struct kvm_pgtable_walker walker = {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7113587222ffe..efdaab3f154de 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -131,21 +131,21 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
>   
>   static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
>   
> -static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
> +static void stage2_free_unlinked_table_rcu_cb(struct rcu_head *head)
>   {
>   	struct page *page = container_of(head, struct page, rcu_head);
>   	void *pgtable = page_to_virt(page);
>   	u32 level = page_private(page);
>   
> -	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, pgtable, level);
> +	kvm_pgtable_stage2_free_unlinked(&kvm_s2_mm_ops, pgtable, level);
>   }
>   
> -static void stage2_free_removed_table(void *addr, u32 level)
> +static void stage2_free_unlinked_table(void *addr, u32 level)
>   {
>   	struct page *page = virt_to_page(addr);
>   
>   	set_page_private(page, (unsigned long)level);
> -	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
> +	call_rcu(&page->rcu_head, stage2_free_unlinked_table_rcu_cb);
>   }
>   
>   static void kvm_host_get_page(void *addr)
> @@ -682,7 +682,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>   	.zalloc_page		= stage2_memcache_zalloc_page,
>   	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
>   	.free_pages_exact	= kvm_s2_free_pages_exact,
> -	.free_removed_table	= stage2_free_removed_table,
> +	.free_unlinked_table	= stage2_free_unlinked_table,
>   	.get_page		= kvm_host_get_page,
>   	.put_page		= kvm_s2_put_page,
>   	.page_count		= kvm_host_page_count,
> 

