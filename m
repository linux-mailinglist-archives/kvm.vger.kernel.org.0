Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C9A5721ED
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 19:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbiGLRrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 13:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiGLRra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 13:47:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59390CDA3A
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 10:47:30 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x18-20020a17090a8a9200b001ef83b332f5so12407102pjn.0
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 10:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vnLWugqT2WHcHohfZhQKwdF8mQ4D+tXT4Z3OUSfp03I=;
        b=oAxU2KxSABdX4FMmCfT7eX+lNGHUAwAfiYHF9X/7ytl07WtI/VW5DTEVHm8DiLqXTw
         Odh4QTl75I3gZgwY9e/x24VdGLGHIB0coqey+IpHPiot6fqj0338KjgFexewFLPgeDey
         /7I96VUgOZwHv9JI/G0MLdFasd/1gWmvgvGELFG49qVgnVILGrzRAE3wLskPIM3Ccf8q
         JuLg42mDXip+zuNe1btN9YPlCNuUw2eup1ahR1gAdu2Fjdvpo6GHQUfnKjyAiEh/HhQO
         I2etyCNf622ZmtmOihiUHy0Fte2588N70tv0BgRoR7YFTo1JAr0RZLrZUUgtTAyINNCs
         yhtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vnLWugqT2WHcHohfZhQKwdF8mQ4D+tXT4Z3OUSfp03I=;
        b=hanrhfqsSCVqjjTkSjvZ5oVsWlZy/pCIzdONpJsucmAMFeI4NCdUJIaHpnCQEskOjm
         MkggPBDMVjAe/p7YFr+gMtqpH08bFnNOgfRARxhNK37Fo9Qdy9icpqM1Lr5I7y8sLchc
         JtoCfFkYc2jYGCaW7N/v5aigGRsV3HB9q5avwGngVu9VWoG66Tsov0SEY9xBnzmZAiLz
         k3EfEqqayQX7NY9diOqi+5RXg0pzZJIwwovhfRwxX9TT57zNL2bOVIgPcYIW7lFnm6uF
         zPHdKyYzjCuvtdxM2BCvyqyBUqO4ZnJ96VzRJGrw9FVRR8Sr/Elspl/DCn3XZ4h+8wSf
         +2aA==
X-Gm-Message-State: AJIora8xMHCkODlBymlAwbG5Vo7hoqQmfWPL4+o20JBJIaQ23aaRJo1U
        VlOpgewc4njuXKQ+qAGAsBMu/Q==
X-Google-Smtp-Source: AGRyM1sWix0aZK1rEKMCXbkzZBgOu6dq8fBKnl2PS5qBjSdeqkG1YqH81DKdTShQszge3nSgtRCJSQ==
X-Received: by 2002:a17:90b:1b51:b0:1f0:3350:6854 with SMTP id nv17-20020a17090b1b5100b001f033506854mr5784891pjb.52.1657648049745;
        Tue, 12 Jul 2022 10:47:29 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id l21-20020a17090af8d500b001ef7fd7954esm9296883pjd.20.2022.07.12.10.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 10:47:29 -0700 (PDT)
Date:   Tue, 12 Jul 2022 17:47:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com
Subject: Re: [PATCH] KVM, x86/mmu: Fix the comment around
 kvm_tdp_mmu_zap_leafs()
Message-ID: <Ys2zrXTDiWkeIwGm@google.com>
References: <20220712030835.286052-1-kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712030835.286052-1-kai.huang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022, Kai Huang wrote:
> Now kvm_tdp_mmu_zap_leafs() only zaps leaf SPTEs but not any non-root
> pages within that GFN range anymore, so the comment isn't right.
> 
> Fixes: f47e5bbbc92f ("KVM: x86/mmu: Zap only TDP MMU leafs in zap range and mmu_notifier unmap")
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f3a430d64975..7692e6273462 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -969,10 +969,9 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>  }
>  
>  /*
> - * Tears down the mappings for the range of gfns, [start, end), and frees the
> - * non-root pages mapping GFNs strictly within that range. Returns true if
> - * SPTEs have been cleared and a TLB flush is needed before releasing the
> - * MMU lock.
> + * Zap leafs SPTEs for the range of gfns, [start, end) for all roots. Returns
> + * true if SPTEs have been cleared and a TLB flush is needed before releasing
> + * the MMU lock.

What about shifting the comment from tdp_mmu_zap_leafs() instead of duplicating it?
tdp_mmu_zap_leafs() is static and kvm_tdp_mmu_zap_leafs() is the sole caller.  And
opportunistically tweak the blurb about SPTEs being cleared to (a) say "zapped"
instead of "cleared" because "cleared" will be wrong if/when KVM sets SUPPRESS_VE,
and (b) to clarify that a flush is needed if and only if a SPTE has been zapped
since MMU lock was last acquired.

E.g.

/*
 * If can_yield is true, will release the MMU lock and reschedule if the
 * scheduler needs the CPU or there is contention on the MMU lock. If this
 * function cannot yield, it will not release the MMU lock or reschedule and
 * the caller must ensure it does not supply too large a GFN range, or the
 * operation can cause a soft lockup.
 */
static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
			      gfn_t start, gfn_t end, bool can_yield, bool flush)

/*
 * Zap leafs SPTEs for the range of gfns, [start, end), for all roots.  Returns
 * true if a TLB flush is needed before releasing the MMU lock, i.e. if one or
 * more SPTEs were zapped since the MMU lock was last acquired.
 */
bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
			   bool can_yield, bool flush)
