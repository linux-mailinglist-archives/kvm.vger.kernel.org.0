Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BB95F3649
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 21:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiJCT3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 15:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiJCT3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 15:29:10 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD313DBEF
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 12:29:09 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 129so10493960pgc.5
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 12:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=IGgQ/gr8aZKuri0FeN0QUKn/dJ59lfhnh9ukMb+lmOE=;
        b=VEP65KIonLoR0/PdQMYoqo8gzbHT1wHmJWJyhtk3BWXvGPjd0kmA7S1v31UOeqpb5I
         7jI7wNLaiZyh95BLKkMtFByyOVmMTq7zZxiuBRfBqzdaATWlWYAth7/ZnueKfVXYvZe5
         YneM42XwEbcUaX/LJx11VDWrw1Xqag1bGO2vlQnUoybifkxmMt/kylVz6OhkePkN6sD4
         uWuCq9GHApORbzN3Ebryk3viBoEl1gw2POjM6BLPaGzpjbKSV/fkpqBxUnrlxVORhfdW
         cuR8s/YDLxsHy7hgIcPbFXms7U4jao1CGFoCkUaVjut2E2RtgOJbIxnhT8mjGifdX0uU
         Uzmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=IGgQ/gr8aZKuri0FeN0QUKn/dJ59lfhnh9ukMb+lmOE=;
        b=K8Xn3CEJcKQbEMgrnoxzXlZ8h9xB1U0KNIR+bOLHEIJMptm+D9d3pS7ciJDUgcEpJQ
         02jR8sPmezBNR80NTvvhDSbON/V7Pe1OvcjdVxY+KwqJvJ3S5WdaW6Q8dUvVuRM9BZjc
         +SWfFq3Df2sj57IqFupOYmtenxP/GyI980eD/Jam9fYJ3YhG1j0cxpDkR9PwsqacbNHk
         qO2GEOW8Jg0ge6vM6UOPlQOTA5r/iYjbgLiBiJ8RGsOoEn0N1og8tppw7XLYUFMDB/Yu
         q1Y1SoaHWvWH/FENjLyI9rWuLFJuxKRRWJEy7lQDHqtapHGhnP6GTsbbLujs0i1cGO9R
         i37Q==
X-Gm-Message-State: ACrzQf020RtY1yERIdiZODIYFjvYaYSnw6ONiBk5J+upMZ29n1A1HT20
        gZv07VY5aqEaMk2KXI1RecA=
X-Google-Smtp-Source: AMsMyM6+/DBUNrxGhbOyl2/vLog9QeW1eirBmRw3A6qwYFDZT3htPq8QYuBBOTZi/wMKxUBMHw20sQ==
X-Received: by 2002:a05:6a00:124e:b0:561:b241:f47f with SMTP id u14-20020a056a00124e00b00561b241f47fmr2084629pfi.72.1664825348484;
        Mon, 03 Oct 2022 12:29:08 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090341cc00b0017c3776634dsm7384776ple.32.2022.10.03.12.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 12:29:08 -0700 (PDT)
Date:   Mon, 3 Oct 2022 12:29:07 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 10/10] KVM: x86/mmu: Rename __direct_map() to
 direct_map()
Message-ID: <20221003192907.GH2414580@ls.amr.corp.intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
 <20220921173546.2674386-11-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220921173546.2674386-11-dmatlack@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 10:35:46AM -0700,
David Matlack <dmatlack@google.com> wrote:

> Rename __direct_map() to direct_map() since the leading underscores are
> unnecessary. This also makes the page fault handler names more
> consistent: kvm_tdp_mmu_page_fault() calls kvm_tdp_mmu_map() and
> direct_page_fault() calls direct_map().
> 
> Opportunistically make some trivial cleanups to comments that had to be
> modified anyway since they mentioned __direct_map(). Specifically, use
> "()" when referring to functions, and include kvm_tdp_mmu_map() among
> the various callers of disallowed_hugepage_adjust().
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 14 +++++++-------
>  arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4ad70fa371df..a0b4bc3c9202 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3079,11 +3079,11 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  	    is_shadow_present_pte(spte) &&
>  	    !is_large_pte(spte)) {
>  		/*
> -		 * A small SPTE exists for this pfn, but FNAME(fetch)
> -		 * and __direct_map would like to create a large PTE
> -		 * instead: just force them to go down another level,
> -		 * patching back for them into pfn the next 9 bits of
> -		 * the address.
> +		 * A small SPTE exists for this pfn, but FNAME(fetch),
> +		 * direct_map(), or kvm_tdp_mmu_map() would like to create a
> +		 * large PTE instead: just force them to go down another level,
> +		 * patching back for them into pfn the next 9 bits of the
> +		 * address.
>  		 */
>  		u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
>  				KVM_PAGES_PER_HPAGE(cur_level - 1);
> @@ -3092,7 +3092,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  	}
>  }
>  
> -static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_shadow_walk_iterator it;
>  	struct kvm_mmu_page *sp;
> @@ -4265,7 +4265,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	if (r)
>  		goto out_unlock;
>  
> -	r = __direct_map(vcpu, fault);
> +	r = direct_map(vcpu, fault);
>  
>  out_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 1e91f24bd865..b8c116ec1a89 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -198,7 +198,7 @@ struct kvm_page_fault {
>  
>  	/*
>  	 * Maximum page size that can be created for this fault; input to
> -	 * FNAME(fetch), __direct_map and kvm_tdp_mmu_map.
> +	 * FNAME(fetch), direct_map() and kvm_tdp_mmu_map().
>  	 */
>  	u8 max_level;
>  
> -- 
> 2.37.3.998.g577e59143f-goog
> 

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
