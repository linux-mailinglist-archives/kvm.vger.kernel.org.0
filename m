Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41FC2FDAE3
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 21:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732352AbhATUbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 15:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388665AbhATUay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 15:30:54 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76405C061575
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 12:30:14 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id f63so7426666pfa.13
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 12:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gr515p7whZ5sUsBYIJNDK/8ZzsxitGG6Eq0FfYKpj40=;
        b=Y7pAD06fRL9InUV2wYLEj9LoZOZnJjNiwmSwUP/FAy5/BCMpNNXtM3wXv0lXu1RlMh
         KpXF9FIMZ2uqmRIAOdVzYeeEApLXdGpiygfXYxYEkvAMxKYOmAyhtao55lkyrE29n0Cf
         rCzUln/y6IcPjaB9/B7oY+nJkPBXFzYheTK+lBErLAGhG2CwAJC+DQ4FixuiyVxE9CtR
         YVwsSnfv8LsvHu0xLT5P3Vt7gun4McqtYsrk0iKoAEyQIgwq5DUbKwovtpkB5fG+qtJr
         RaNBJh5RFYld9oj6M4c7elUGcCFfQgSZ5BzcuzWGsBOAEdEgwiMwcXJfkr/XOsx8LYCk
         9x7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gr515p7whZ5sUsBYIJNDK/8ZzsxitGG6Eq0FfYKpj40=;
        b=ZVQRMSt6R0/REGcchjorus0pIPKV2YA3XlCmg5ivn9V3FErxk4hkN/Wkvm3cMNYDyf
         SsyfKIopKwwJOgkvAgtu7ShMmJV9suup4lm8P97pIsYHkP45dy+wlMLM1AVbghnQKXfj
         xewRpf1wk3PvRBVDbVTv5DFqpl+aVlsavu0nMZPQQupIlC7+7o6lvNWVojBWnwIvfroB
         nqqk92s69iUqlT8DnzncZzp7gN32hk0racZRHHAVzwMysQRJ1xPqCSqO/fMiFfnzUb3h
         fj2aYFgYImdehwq4EZiW45UKXy5PY3x51ap+9ji2mGX3FKjnZYIXLvqyt3tLGubqcY+i
         cfnQ==
X-Gm-Message-State: AOAM532pfKH6Bo2NdIZEQxnqiNCo3oNzWAW6PDbZgAkGC4zP71XTIYgn
        7OEqpoCpWsITzVaVS27Pi//YzA==
X-Google-Smtp-Source: ABdhPJybjJhsxcagQOFPo/CRHj4yzT0w9X8ebHU0g5PuQ+CDZ52Ug5E3v+VmklqZJM2/+FGn9SHCAA==
X-Received: by 2002:a63:1152:: with SMTP id 18mr11168017pgr.268.1611174613803;
        Wed, 20 Jan 2021 12:30:13 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id r30sm3275012pfq.12.2021.01.20.12.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 12:30:13 -0800 (PST)
Date:   Wed, 20 Jan 2021 12:30:06 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 10/24] kvm: x86/mmu: Factor out handle disconnected pt
Message-ID: <YAiSzoLRybcaeZWa@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-11-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112181041.356734-11-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Spell out "page tables"?  Not short on chars.  The grammar is also a bit funky.

  KVM: x86/mmu: Factor out handling of disconnected page tables

On Tue, Jan 12, 2021, Ben Gardon wrote:
> Factor out the code to handle a disconnected subtree of the TDP paging
> structure from the code to handle the change to an individual SPTE.
> Future commits will build on this to allow asynchronous page freeing.
> 
> No functional change intended.
> 
> Reviewed-by: Peter Feiner <pfeiner@google.com>
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 75 +++++++++++++++++++++++---------------
>  1 file changed, 46 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 55df596696c7..e8f35cd46b4c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -234,6 +234,49 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>  	}
>  }
>  
> +/**
> + * handle_disconnected_tdp_mmu_page - handle a pt removed from the TDP structure

Maybe s/disconnected/removed?

I completely understand why you used "disconnected", and to a large extent I
agree it's a good descriptor, but all of the surrounding comments talk about the
page tables being "removed".  And for me, "disconnected" implies that that it
could be reconnected in the future, whereas "removed" is a more firm "this page,
in its current form, is gone for good".

> + *
> + * @kvm: kvm instance
> + * @pt: the page removed from the paging structure
> + *
> + * Given a page table that has been removed from the TDP paging structure,
> + * iterates through the page table to clear SPTEs and free child page tables.
> + */
> +static void handle_disconnected_tdp_mmu_page(struct kvm *kvm, u64 *pt)
> +{
> +	struct kvm_mmu_page *sp;
> +	gfn_t gfn;
> +	int level;
> +	u64 old_child_spte;
> +	int i;

Nit: use reverse fir tree?  I don't think KVM needs to be as strict as tip for
that rule/guideline, but I do think it's usually a net positive for readability.

> +	sp = sptep_to_sp(pt);
> +	gfn = sp->gfn;
> +	level = sp->role.level;

Initialize these from the get-go?  That would held the reader understand these
are local snapshots to shorten lines, as opposed to scratch variables.

	struct kvm_mmu_page *sp = sptep_to_sp(pt);
	int level = sp->role.level;
	gfn_t gfn = sp->gfn;
	u64 old_child_spte;
	int i;

> +
> +	trace_kvm_mmu_prepare_zap_page(sp);
> +
> +	list_del(&sp->link);
> +
> +	if (sp->lpage_disallowed)
> +		unaccount_huge_nx_page(kvm, sp);
> +
> +	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> +		old_child_spte = READ_ONCE(*(pt + i));
> +		WRITE_ONCE(*(pt + i), 0);
> +		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp),
> +			gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
> +			old_child_spte, 0, level - 1);
> +	}
> +
> +	kvm_flush_remote_tlbs_with_address(kvm, gfn,
> +					   KVM_PAGES_PER_HPAGE(level));
> +
> +	free_page((unsigned long)pt);
> +	kmem_cache_free(mmu_page_header_cache, sp);
> +}
