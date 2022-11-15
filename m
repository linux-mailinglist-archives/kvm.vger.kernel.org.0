Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A41E62AF6A
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 00:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiKOX13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 18:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbiKOX1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 18:27:24 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ABA27930
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 15:27:23 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso661136pjc.2
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 15:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BcYVK3KaTBkQeFoNX2OW1U3l6SR7et/VkSr5AlqHjlI=;
        b=oK6Rm59tVlj0NeQ1/JwvaEVo1JJlAD+djNn86ZA3gUX6E9eOHMad9SuDyVcj+LGkY2
         7wKh7gW4tdgVVPAOECYKXu51+L3Kdd5m2HI4fXrhWbm17vJu35S0qbZ1jbRX9Obw9kNu
         TjkO7NFq6N4+PXdQHEIpoN2WThTOFPsuTBDpmajzjsepZbPDLYmNFFNDFn473Olg8Q/A
         esv9agR1jM6wwyASo++smnTUBR2kVRCwyWuX5pIyMQp58dTUsTup5XtJL0/lL/piCkd4
         bsrVTavN6wKhL563Wmd6MUO2jSucqj+LaHldnISnOw7ug9GN8Bz71M+KTGf2nzDLk7Yk
         dYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BcYVK3KaTBkQeFoNX2OW1U3l6SR7et/VkSr5AlqHjlI=;
        b=iAcNOiLvs3B6YKiWolhebJnwu6P49aBc9lsZuu0Q3RxKcI1yLPeibWAI/lpAXRtDqD
         a3cSVCdPBIMcc4YJdRGcjDmnILxvaC1UsWx4oU3O5KVLLQexYYGCdq+RMeUlhY6TEgUu
         zkbFpgpJEPZMm5DiRjlM51EsxCnBIObK04Rs02XbEp3o2TFEqdqes7qIucnfr1lC+rGm
         SYPHXr23fRAvAD82vbSsOTcEXZzvyeiZuIMvUTZKFSbCyvlnudW7csFyO3b2ZxldwPvF
         VXpJzr9S0bL8v98pCAPgzsL/sqPTK95I9iVKfpshO7ObUwda7RE1gk/OyKRVlT46o1dU
         irCQ==
X-Gm-Message-State: ANoB5plyAUhlABYr5uoj3jZ97YE1w9+Rc1WCcDdg2cdMRUor7M1owlH6
        q1RksBoifcjtk37rQN0UXAN9YA==
X-Google-Smtp-Source: AA0mqf4RsjoeOb2GmbtBKDdgQ+7Yeabu0A1nOuZNhHIDJBsr3S1XLcg3ufhWUez3zn07g0ISAHUOzw==
X-Received: by 2002:a17:902:6b8c:b0:188:6ccd:f2c5 with SMTP id p12-20020a1709026b8c00b001886ccdf2c5mr6278339plk.6.1668554843178;
        Tue, 15 Nov 2022 15:27:23 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id k13-20020a170902ce0d00b0017f5ad327casm10453887plg.103.2022.11.15.15.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 15:27:22 -0800 (PST)
Date:   Tue, 15 Nov 2022 15:27:18 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        ricarkol@gmail.com
Subject: Re: [RFC PATCH 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y3QgVqSUCm8kdbeN@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-5-ricarkol@google.com>
 <Y3KrHG4WMXMUquUy@google.com>
 <Y3QazjAUVE+T6rHh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3QazjAUVE+T6rHh@google.com>
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

On Tue, Nov 15, 2022 at 03:03:42PM -0800, Ricardo Koller wrote:
> On Mon, Nov 14, 2022 at 08:54:52PM +0000, Oliver Upton wrote:
> > Hi Ricardo,
> > 
> > On Sat, Nov 12, 2022 at 08:17:06AM +0000, Ricardo Koller wrote:
> > 
> > [...]
> > 
> > > +/**
> > > + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> > > + *				to PAGE_SIZE guest pages.
> > > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > > + * @addr:	Intermediate physical address from which to split.
> > > + * @size:	Size of the range.
> > > + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> > > + *		page-table pages.
> > > + *
> > > + * @addr and the end (@addr + @size) are effectively aligned down and up to
> > > + * the top level huge-page block size. This is an exampe using 1GB
> > > + * huge-pages and 4KB granules.
> > > + *
> > > + *                          [---input range---]
> > > + *                          :                 :
> > > + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> > > + *                          :                 :
> > > + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> > > + *                          :                 :
> > > + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> > > + *                          :                 :
> > > + *
> > > + * Return: 0 on success, negative error code on failure. Note that
> > > + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> > > + * blocks in the input range as allowed by the size of the memcache. It
> > > + * will fail it wasn't able to break any block.
> > > + */
> > > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> > > +
> > >  /**
> > >   * kvm_pgtable_walk() - Walk a page-table.
> > >   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > index d1f309128118..9c42eff6d42e 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -1267,6 +1267,80 @@ static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
> > >  	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
> > >  }
> > >  
> > > +struct stage2_split_data {
> > > +	struct kvm_s2_mmu		*mmu;
> > > +	void				*memcache;
> > > +	struct kvm_pgtable_mm_ops	*mm_ops;
> > 
> > You can also get at mm_ops through kvm_pgtable_visit_ctx
> > 
> > > +};
> > > +
> > > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > > +			       enum kvm_pgtable_walk_flags visit)
> > > +{
> > > +	struct stage2_split_data *data = ctx->arg;
> > > +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> > > +	kvm_pte_t pte = ctx->old, attr, new;
> > > +	enum kvm_pgtable_prot prot;
> > > +	void *mc = data->memcache;
> > > +	u32 level = ctx->level;
> > > +	u64 phys;
> > > +
> > > +	if (WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
> > > +		return -EINVAL;
> > > +
> > > +	/* Nothing to split at the last level */
> > > +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > > +		return 0;
> > > +
> > > +	/* We only split valid block mappings */
> > > +	if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
> > > +		return 0;
> > > +
> > > +	phys = kvm_pte_to_phys(pte);
> > > +	prot = kvm_pgtable_stage2_pte_prot(pte);
> > > +	stage2_set_prot_attr(data->mmu->pgt, prot, &attr);
> > > +
> > > +	/*
> > > +	 * Eager page splitting is best-effort, so we can ignore the error.
> > > +	 * The returned PTE (new) will be valid even if this call returns
> > > +	 * error: new will be a single (big) block PTE.  The only issue is
> > > +	 * that it will affect dirty logging performance, as the huge-pages
> > > +	 * will have to be split on fault, and so we WARN.
> > > +	 */
> > > +	WARN_ON(stage2_create_removed(&new, phys, level, attr, mc, mm_ops));
> > 
> > I don't believe we should warn in this case, at least not
> > unconditionally. ENOMEM is an expected outcome, for example.
> 
> Given that "eager page splitting" is best-effort, the error must be
> ignored somewhere: either here or by the caller (in mmu.c). It seems
> that ignoring the error here is not a very good idea.

Actually, ignoring the error here simplifies the error handling.
stage2_create_removed() is best-effort; here's an example.  If
stage2_create_removed() was called to split a 1G block PTE, and it
wasn't able to split all 2MB blocks, it would return ENOMEM and a valid
PTE pointing to a tree like this:

		[---------1GB-------------]
		:                         :
		[--2MB--][--2MB--][--2MB--]
		:       :
		[ ][ ][ ]

If we returned ENOMEM instead of ignoring the error, we would have to
clean all the intermediate state.  But stage2_create_removed() is
designed to always return a valid PTE, even if the tree is not fully
split (as above).  So, there's no really need to clean it: it's a valid
tree. Moreover, this valid tree would result in better dirty logging
performance as it already has some 2M blocks split into 4K pages.

> 
> > 
> > Additionally, I believe you'll want to bail out at this point to avoid
> > installing a potentially garbage PTE as well.
> 
> It should be fine as stage2_create_removed() is also best-effort. The
> returned PTE is valid even when it fails; it just returns a big block
> PTE.
> 
> > 
> > > +	stage2_put_pte(ctx, data->mmu, mm_ops);
> > 
> > Ah, I see why you've relaxed the WARN in patch 1 now.
> > 
> > I would recommend you follow the break-before-make pattern and use the
> > helpers here as well. stage2_try_break_pte() will demote the store to
> > WRITE_ONCE() if called from a non-shared context.
> > 
> 
> ACK, I can do that. The only reason why I didnt' is because I would have
> to handle the potential error from stage2_try_break_pte(). It would feel
> wrong not to, even if it's !shared. On the other hand, I would like to
> easily experiment with both the !shared and the shared approaches
> easily.
> 
> > Then the WARN will behave as expected in stage2_make_pte().
> > 
> > > +	/*
> > > +	 * Note, the contents of the page table are guaranteed to be made
> > > +	 * visible before the new PTE is assigned because
> > > +	 * stage2_make__pte() writes the PTE using smp_store_release().
> > 
> > typo: stage2_make_pte()
> > 
> > --
> > Thanks,
> > Oliver
