Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E368A699C96
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 19:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjBPSpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 13:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBPSpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 13:45:01 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E78650AE9
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:44:59 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id mg2so1940026qvb.9
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676573098;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jst1eroHBjIYT5ftKqNRgPwYlOrEbGcZ49gDFgkRgkY=;
        b=K+KYc6g+JVFfRY8F2QnmXioxJ8sgXR/PchYG4K2wxmSE1Fn31IRzLDIv2BLKC5dt9f
         lLuEZoc4/dJabibmcfFuWFomkef479qmB4fjw+GsqyyfejcYy4C0KA36mRLFgPkWg3mR
         YACzg1hQFPBR2Ux8oCr0jv5yylXvtJm+4/X9fFgK4P3DgD77qFkkwq+a/EBq1stA3791
         B0yfcGVnvgJtItQgIOxCjdvqf815pE7AGjeIuLJNp2gJgva7bK845aKsKRboFUW1S18B
         Q35VS7QnXSv4EVCEoFsfvtiMTqRFi+o+6rbqGz+llAAlyptHzmv26c9gbGdzfemjL0LY
         CjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676573098;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jst1eroHBjIYT5ftKqNRgPwYlOrEbGcZ49gDFgkRgkY=;
        b=4MbmBRz2Yr25VvDJYpMz2bp5g7f9k2/8bDMfaYOjSo4XIi9iqK3AQPZm9+8an016pQ
         VVZY33YaPjBuL231jx2/I8Xk/1kV5XNKbyLTbkqvKNiI3+9+Uj7M6p7roblJVo+oByJH
         8Jv0fQXWoTuD2vmwzUIlNZErmdRg2J0iy1yoydEd7HcxIcPf1Rqv6PU/MC9yOoTQ1O3s
         kexAOV/p5CANLzoVzhE0G9NbHgAsocGw6Pw1c3jup4Zk9cI5YCrKdDhPOwzhy3vJi1UW
         JIYifocU1LLcKE7qx4r7/jio2HdKl2D1eoWlaKrkbbwEn7biF7NI5Z69Y3lQXoLGHxEo
         0Ntg==
X-Gm-Message-State: AO0yUKXtJ70DjECDrynfaYhz7GaBf/w7m26nmeidtTPISueZXsFv0/x0
        71wOWUyDVrxG1iMjMQyT9LEHJskSl3gq/Wtq+6d2JQ==
X-Google-Smtp-Source: AK7set//YvqlaNZ1YOPWbH8oPCJeBDls16I0T5zMqjTeT54rnIlGu3EhPAE7hLQrViU9pUYY4hCO5wjpN6yfN/rAcqA=
X-Received: by 2002:a0c:e086:0:b0:56e:a207:142d with SMTP id
 l6-20020a0ce086000000b0056ea207142dmr584064qvk.6.1676573098061; Thu, 16 Feb
 2023 10:44:58 -0800 (PST)
MIME-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com> <20230215174046.2201432-3-ricarkol@google.com>
 <85bbfda3-405d-9bd5-d5fa-f2e14c3acad7@redhat.com>
In-Reply-To: <85bbfda3-405d-9bd5-d5fa-f2e14c3acad7@redhat.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Thu, 16 Feb 2023 10:44:47 -0800
Message-ID: <CAOHnOrw06=823f6tszN2YyRnrBCchwXmqvneqY=tH2D-DSca4g@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] KVM: arm64: Rename free_unlinked to free_removed
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 7:13 PM Shaoqin Huang <shahuang@redhat.com> wrote:
>
> Hi Ricardo,
>
> On 2/16/23 01:40, Ricardo Koller wrote:
> > Make it clearer that the "free_removed" functions refer to tables that
> > have never been part of the paging structure: they are "unlinked".
> >
> > No functional change intended.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h  |  8 ++++----
> >   arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +++---
> >   arch/arm64/kvm/hyp/pgtable.c          |  6 +++---
> >   arch/arm64/kvm/mmu.c                  | 10 +++++-----
> >   4 files changed, 15 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 3339192a97a9..7c45082e6c23 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -99,7 +99,7 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
> >    *                          allocation is physically contiguous.
> >    * @free_pages_exact:               Free an exact number of memory pages previously
> >    *                          allocated by zalloc_pages_exact.
> > - * @free_removed_table:              Free a removed paging structure by unlinking and
> > + * @free_unlinked_table:     Free an unlinked paging structure by unlinking and
> >    *                          dropping references.
> >    * @get_page:                       Increment the refcount on a page.
> >    * @put_page:                       Decrement the refcount on a page. When the
> > @@ -119,7 +119,7 @@ struct kvm_pgtable_mm_ops {
> >       void*           (*zalloc_page)(void *arg);
> >       void*           (*zalloc_pages_exact)(size_t size);
> >       void            (*free_pages_exact)(void *addr, size_t size);
> > -     void            (*free_removed_table)(void *addr, u32 level);
> > +     void            (*free_unlinked_table)(void *addr, u32 level);
> >       void            (*get_page)(void *addr);
> >       void            (*put_page)(void *addr);
> >       int             (*page_count)(void *addr);
> > @@ -450,7 +450,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >   void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >
> >   /**
> > - * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
> > + * kvm_pgtable_stage2_free_unlinked() - Free un unlinked stage-2 paging structure.
>
> Free an unlinked stage-2

ACK, will fix on v4.

>
> >    * @mm_ops: Memory management callbacks.
> >    * @pgtable:        Unlinked stage-2 paging structure to be freed.
> >    * @level:  Level of the stage-2 paging structure to be freed.
> > @@ -458,7 +458,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >    * The page-table is assumed to be unreachable by any hardware walkers prior to
> >    * freeing and therefore no TLB invalidation is performed.
> >    */
> > -void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> > +void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> >
> >   /**
> >    * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 552653fa18be..b030170d803b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -91,9 +91,9 @@ static void host_s2_put_page(void *addr)
> >       hyp_put_page(&host_s2_pool, addr);
> >   }
> >
> > -static void host_s2_free_removed_table(void *addr, u32 level)
> > +static void host_s2_free_unlinked_table(void *addr, u32 level)
> >   {
> > -     kvm_pgtable_stage2_free_removed(&host_mmu.mm_ops, addr, level);
> > +     kvm_pgtable_stage2_free_unlinked(&host_mmu.mm_ops, addr, level);
> >   }
> >
> >   static int prepare_s2_pool(void *pgt_pool_base)
> > @@ -110,7 +110,7 @@ static int prepare_s2_pool(void *pgt_pool_base)
> >       host_mmu.mm_ops = (struct kvm_pgtable_mm_ops) {
> >               .zalloc_pages_exact = host_s2_zalloc_pages_exact,
> >               .zalloc_page = host_s2_zalloc_page,
> > -             .free_removed_table = host_s2_free_removed_table,
> > +             .free_unlinked_table = host_s2_free_unlinked_table,
> >               .phys_to_virt = hyp_phys_to_virt,
> >               .virt_to_phys = hyp_virt_to_phys,
> >               .page_count = hyp_page_count,
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index e093e222daf3..0a5ef9288371 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -841,7 +841,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
> >       if (ret)
> >               return ret;
> >
> > -     mm_ops->free_removed_table(childp, ctx->level);
> > +     mm_ops->free_unlinked_table(childp, ctx->level);
> >       return 0;
> >   }
> >
> > @@ -886,7 +886,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >    * The TABLE_PRE callback runs for table entries on the way down, looking
> >    * for table entries which we could conceivably replace with a block entry
> >    * for this mapping. If it finds one it replaces the entry and calls
> > - * kvm_pgtable_mm_ops::free_removed_table() to tear down the detached table.
> > + * kvm_pgtable_mm_ops::free_unlinked_table() to tear down the detached table.
> >    *
> >    * Otherwise, the LEAF callback performs the mapping at the existing leaves
> >    * instead.
> > @@ -1250,7 +1250,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
> >       pgt->pgd = NULL;
> >   }
> >
> > -void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
> > +void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
> >   {
> >       kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
> >       struct kvm_pgtable_walker walker = {
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index a3ee3b605c9b..9bd3c2cfb476 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -130,21 +130,21 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
> >
> >   static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
> >
> > -static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
> > +static void stage2_free_unlinked_table_rcu_cb(struct rcu_head *head)
> >   {
> >       struct page *page = container_of(head, struct page, rcu_head);
> >       void *pgtable = page_to_virt(page);
> >       u32 level = page_private(page);
> >
> > -     kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, pgtable, level);
> > +     kvm_pgtable_stage2_free_unlinked(&kvm_s2_mm_ops, pgtable, level);
> >   }
> >
> > -static void stage2_free_removed_table(void *addr, u32 level)
> > +static void stage2_free_unlinked_table(void *addr, u32 level)
> >   {
> >       struct page *page = virt_to_page(addr);
> >
> >       set_page_private(page, (unsigned long)level);
> > -     call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
> > +     call_rcu(&page->rcu_head, stage2_free_unlinked_table_rcu_cb);
> >   }
> >
> >   static void kvm_host_get_page(void *addr)
> > @@ -681,7 +681,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
> >       .zalloc_page            = stage2_memcache_zalloc_page,
> >       .zalloc_pages_exact     = kvm_s2_zalloc_pages_exact,
> >       .free_pages_exact       = kvm_s2_free_pages_exact,
> > -     .free_removed_table     = stage2_free_removed_table,
> > +     .free_unlinked_table    = stage2_free_unlinked_table,
> >       .get_page               = kvm_host_get_page,
> >       .put_page               = kvm_s2_put_page,
> >       .page_count             = kvm_host_page_count,
>
> --
> Regards,
> Shaoqin
>
