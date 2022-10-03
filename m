Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504A95F3646
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 21:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiJCT11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 15:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiJCT1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 15:27:25 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419381BE8F
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 12:27:25 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so16169520pjs.4
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 12:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=F2cahgI/n3fLml4dueM+3Y0xe7Zb8ZTFl3FrDMDHp7Q=;
        b=LBmpPQS7j5XLzNHS6AoTp34QLngGjJ4dyVuZnwD+exaK/zgq+w+g1lWqeybI11bR8T
         HEuEq8KUOZdH3IXrWSSqsIiDr6HlhMwvmezAu1engCCwcZpUOagRJWH7+hISI8zJDfdS
         fabYJb3JmUyc+pIH1vwAcz0D/u9subV3UdoqOfhJKyJ9su99l+bJkSOEIvOEPhWfwe3a
         N/OL/lvyS6N0xT9nssrug6k3JOHRzhMXhU+tjg/fTyGPNnqdAh9JEYlY8NCvr2eZ0IUK
         tSGVo0eoi4tsq9FOlfoEDpp9+kGkaXlonA0xWZyYsTwBhBC9/EQehYoljUUYl7W2eHx8
         b7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=F2cahgI/n3fLml4dueM+3Y0xe7Zb8ZTFl3FrDMDHp7Q=;
        b=cOc8eDXY9qxcX3xy5ihW4X4PXcCODfjAlT9YOA6YQm8OIW5sN1oo4BzsRS42+jPo4S
         xa0kk11GVVcukzvL7rjhx6fFUboFjryleKLJI8ZdTiisQCH/JiI6gmKgXtnrjX3AfIns
         h9QwAUjmr6xhSYeBJwkluM/jG6powjOhnNBZwtu75IRrV6LdHkeNo22zTYRvz4rqKo0d
         7IT1lvalV8IsIHAANBuW9GJau9s4v5Lbqp6STXBJfkSoac+5iWxBmJrdfQd3l4O7zyc9
         zIbS9fJeglbnYEzW2MGvsNaywHqGhI0JbPy8g6y2cSYl2IWFaf3zKXpdZHAd36wr2OXR
         QmTw==
X-Gm-Message-State: ACrzQf3+gnWZBVSPQSn1NUoV9HoIg5ewlytYMc2xeNIKpb5oI+AinLTl
        GtDSzVFqqW60wco85ByRhMI=
X-Google-Smtp-Source: AMsMyM6J6o2Y5Dq2pqfgRqIa8xkfh56/F7tHs0XqaYFPdUdp1bhILgO2gWJsEDIWDtYmBcrcNpPIkg==
X-Received: by 2002:a17:90b:4d8d:b0:20a:ad78:7826 with SMTP id oj13-20020a17090b4d8d00b0020aad787826mr5193527pjb.237.1664825244621;
        Mon, 03 Oct 2022 12:27:24 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id l18-20020a170903245200b00172f6726d8esm7625403pls.277.2022.10.03.12.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 12:27:23 -0700 (PDT)
Date:   Mon, 3 Oct 2022 12:27:22 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 07/10] KVM: x86/mmu: Initialize fault.{gfn,slot}
 earlier for direct MMUs
Message-ID: <20221003192722.GE2414580@ls.amr.corp.intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
 <20220921173546.2674386-8-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220921173546.2674386-8-dmatlack@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 10:35:43AM -0700,
David Matlack <dmatlack@google.com> wrote:

> Move the initialization of fault.{gfn,slot} earlier in the page fault
> handling code for fully direct MMUs. This will enable a future commit to
> split out TDP MMU page fault handling without needing to duplicate the
> initialization of these 2 fields.
> 
> Opportunistically take advantage of the fact that fault.gfn is
> initialized in kvm_tdp_page_fault() rather than recomputing it from
> fault->addr.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 5 +----
>  arch/x86/kvm/mmu/mmu_internal.h | 5 +++++
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e3b248385154..dc203973de83 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4241,9 +4241,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
>  	int r;
>  
> -	fault->gfn = fault->addr >> PAGE_SHIFT;
> -	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
> -
>  	if (page_fault_handle_page_track(vcpu, fault))
>  		return RET_PF_EMULATE;
>  
> @@ -4347,7 +4344,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	if (shadow_memtype_mask && kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
>  		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
>  			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
> -			gfn_t base = (fault->addr >> PAGE_SHIFT) & ~(page_num - 1);
> +			gfn_t base = fault->gfn & ~(page_num - 1);
>  
>  			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
>  				break;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 1c0a1e7c796d..1e91f24bd865 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -279,6 +279,11 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	};
>  	int r;
>  
> +	if (vcpu->arch.mmu->root_role.direct) {
> +		fault.gfn = fault.addr >> PAGE_SHIFT;
> +		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
> +	}
> +
>  	/*
>  	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
>  	 * guest perspective and have already been counted at the time of the
> -- 
> 2.37.3.998.g577e59143f-goog
> 

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
