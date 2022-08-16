Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFEF595F3B
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 17:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbiHPPh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 11:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbiHPPhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 11:37:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9113F306
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 08:35:31 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pm17so10053218pjb.3
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 08:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=IMfgxaR3aIPhLUAX0j5T+D/oB82QAPyvY6Oa11PC6KI=;
        b=pftyEX3cEdK6hGGrEoVpQZ1IC+2Uu9Q3/0fhK7nrI94lX8rf+RiM3dErTgu9a0dhsw
         QF9ifBXW7YCDH9H+7GA7h0xuI4S3IDnDc0EZBvzIzQuVZb3UjtDK6DRw8SBeXE8KLfST
         +q/5wq5LiTeImc70ih8l414MPrTVtA97loUqSJjdQ7tIMN0WRSXB63L+h5eEpafhsrIT
         RWbGYmmAl7jaUPI6kICv7MfX2GpS37ctDg8/MqxUux8cbxLdnCg3QdvfDcLCCsa75xKs
         DS0IlQu+30VpbQHlBlRmEMf5jrrRB1bQ3JshebSKoIocxTiO5snulr4Vi0g1rhbRIuPB
         Zn5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=IMfgxaR3aIPhLUAX0j5T+D/oB82QAPyvY6Oa11PC6KI=;
        b=29U37gPevb/GjchEs+fZUZ/Yca9zQm3TLdTDkUyHxZBvo11t6ci1DI4xvWYy+8d7Nf
         GwT6ndzYrtnxmGnaZJjaltZyqSbZO8RGDupWwXHRGRxI6e6os4HIa66KFOJvM7DkEilH
         ap17EutHQmLmvoxxNwD9LV1PeU2pWw59hGFb4K4sXib/bZMp6963ftbseRgcbECMjLrq
         Deem49zwEzZ8VvZ1fouAKGSvwK3Tl56p+w8FGlD83JKEhvtf6NSF3rp+layRulKaMFoG
         uq+MmSVjuEK8wZJntf0+E56PKTd/KEc5s1TEMymkV5GIYs6grgMnvkHTHTwfX1nmCLVM
         XW8g==
X-Gm-Message-State: ACgBeo30Xte3JxdkV64klpAh/JQZcc6oKw8Izjm+Eks9hGr93rTVsYQh
        jH1be+3ntYuiNEZ2euYuAjORGA==
X-Google-Smtp-Source: AA6agR7CVQbEvb6O0TLi/Xd3wpoDyTZHB19s6hbbOTh/AgAbOWqP8s/m6yX3W+n+e+9mu1mFAcRuiw==
X-Received: by 2002:a17:902:b68e:b0:172:8674:c6c1 with SMTP id c14-20020a170902b68e00b001728674c6c1mr2584320pls.62.1660664130654;
        Tue, 16 Aug 2022 08:35:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x28-20020aa7941c000000b0052d63fb109asm8605166pfo.20.2022.08.16.08.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 08:35:30 -0700 (PDT)
Date:   Tue, 16 Aug 2022 15:35:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 053/103] KVM: TDX: TDP MMU TDX support
Message-ID: <Yvu5PsAndEbWKTHc@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <2b51971467ab7c8e60ea1e17ba09f607db444935.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b51971467ab7c8e60ea1e17ba09f607db444935.1659854790.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 07, 2022, isaku.yamahata@intel.com wrote:
> +static void tdx_unpin_pfn(struct kvm *kvm, kvm_pfn_t pfn)

Why does this helper exist?  KVM should not be pinning private pages, that should
be the purview of the private backing fd.

> +{
> +	struct page *page = pfn_to_page(pfn);
> +
> +	put_page(page);
> +	WARN_ON(!page_count(page) && to_kvm_tdx(kvm)->hkid > 0);

For all patches, please use the ONCE variant or KVM_BUG_ON() where appropriate.
An unlimited WARN/WARN_ON() is all but guaranteed to spam the kernel log and bring
the host to its knees if it fires.

> +}
> +
> +static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> +					enum pg_level level, kvm_pfn_t pfn)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	hpa_t hpa = pfn_to_hpa(pfn);
> +	gpa_t gpa = gfn_to_gpa(gfn);
> +	struct tdx_module_output out;
> +	u64 err;
> +
> +	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) ||
> +			 !kvm_pfn_to_refcounted_page(pfn)))

I'm terribly confused.  The cover letter says:

  - fd-based private page v7 is integrated. This is mostly same to Chao's patches.

which I interpreted as meaning this series relies on UPM.  But if that's the case,
why is KVM manually requiring private memory to be backed by "struct page" and then
manually pinning pages?

> +		return;
> +
> +	/* TODO: handle large pages. */
> +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> +		return;
> +
> +	/* To prevent page migration, do nothing on mmu notifier. */
> +	get_page(pfn_to_page(pfn));

Again, what's going on here?

> +
> +	if (likely(is_td_finalized(kvm_tdx))) {
> +		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, hpa, &out);
> +		if (KVM_BUG_ON(err, kvm)) {
> +			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
> +			put_page(pfn_to_page(pfn));
> +		}
> +		return;

This return is pointless.

> +	}
> +}
> +
> +static void tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> +				      enum pg_level level, kvm_pfn_t pfn)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +
> +	spin_lock(&kvm_tdx->seamcall_lock);
> +	__tdx_sept_set_private_spte(kvm, gfn, level, pfn);
> +	spin_unlock(&kvm_tdx->seamcall_lock);
> +}
> +
> +static void tdx_sept_drop_private_spte(

Please fix this style for all patches.  And not just in function prototypes, but
also in function calls and probably several other places as well.  The _strongly_
preferred style is:

static void tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
				       enum pg_level level, kvm_pfn_t pfn)

> +	struct kvm *kvm, gfn_t gfn, enum pg_level level, kvm_pfn_t pfn)
> +{
> +	int tdx_level = pg_level_to_tdx_sept_level(level);
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	gpa_t gpa = gfn_to_gpa(gfn);
> +	hpa_t hpa = pfn_to_hpa(pfn);
> +	hpa_t hpa_with_hkid;
> +	struct tdx_module_output out;
> +	u64 err = 0;
> +
> +	/* TODO: handle large pages. */
> +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> +		return;
> +
> +	spin_lock(&kvm_tdx->seamcall_lock);

Taking a spinlock completely defeats the purpose of taking mmu_lock for read.  This
is definitely not an acceptable approach long term, and even for initial upstreaming
I'm hesitant to punt on adding proper retry logic.

> +	if (is_hkid_assigned(kvm_tdx)) {
> +		err = tdh_mem_page_remove(kvm_tdx->tdr.pa, gpa, tdx_level, &out);
> +		if (KVM_BUG_ON(err, kvm)) {
> +			pr_tdx_error(TDH_MEM_PAGE_REMOVE, err, &out);
> +			goto unlock;
> +		}
> +
> +		hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
> +		err = tdh_phymem_page_wbinvd(hpa_with_hkid);
> +		if (WARN_ON_ONCE(err)) {

Why is the above a KVM_BUG_ON() but this one is not?

> +			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> +			goto unlock;
> +		}
> +	} else
> +		/*
> +		 * The HKID assigned to this TD was already freed and cache
> +		 * was already flushed. We don't have to flush again.
> +		 */
> +		err = tdx_reclaim_page((unsigned long)__va(hpa), hpa, false, 0);
> +
> +unlock:
> +	spin_unlock(&kvm_tdx->seamcall_lock);
> +
> +	if (!err)
> +		tdx_unpin_pfn(kvm, pfn);
> +}
> +

...

> +static void tdx_handle_changed_private_spte(
> +	struct kvm *kvm, const struct kvm_spte_change *change)

I haven't look at this in detail, and probably won't for a few weeks, but my initial
reaction is that I really, really don't like funnelling both insertion and deletion
into a single helper.  E.g. it should be trivial to pass the source_pa for PAGE.ADD
via kvm_page_fault instead of shoving it into the struct kvm_tdx (or struct vcpu_tdx).
But smushing the two things together makes that painfully difficult.
