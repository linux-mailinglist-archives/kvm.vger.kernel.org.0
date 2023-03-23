Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFF56C7313
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjCWW20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCWW2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:28:24 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6D020561
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:28:22 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so3376392pjp.1
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679610501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LhVyeu4gjZ1l2xd/DlkD/uaQ5Cthgsf/bh6Nj9UFQ/Y=;
        b=XPyFiK6vF875qGz7HLGj4KDDAg6Cz5oPb1YpOly/pU3QuX0+va0918fStssh8nYVx7
         rbl48LiZGckKfmeL9P5wCZrKm65iKPVy+hI7Pe2IuV8aB93cZnftFEJ4bQkE1zuMQlUP
         rb+ikD228MkcBPtVkPq2qIIUSu3EN8neoguG7GG5x1/dGHSlK8POr/EzKjNelhL9qucq
         9V+pF/wtf9U3wqpLyrdPM7uvmJw9IPYGhDNEjS9kEgCiJC8AofViHqQzkoTfJGzgHiJ7
         n7IOPoBRoAalokUYzL6bU7nmk0xMmLAJQVDlvXH+kGs00SrEKAljEpg2I7i3m7WpwDhH
         xAog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679610501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LhVyeu4gjZ1l2xd/DlkD/uaQ5Cthgsf/bh6Nj9UFQ/Y=;
        b=sfFZ4wxYocyOQI2elp1KclCR4oBaMyvDgFknRvCHRXLjBW7wQ48OFYgILMbCDOft/0
         sxejr/Dkaut9Bxdr6y0tt9olBvjgtwFAqx9yUdBT73jcvlPEB1pjV5HePYshDaU5aQTv
         pxfezuo3S/AzxjIOQLowFXMhYR6pHfx+q6VAoQwerxamPYmDxDtifN+0DDPtcHJKZMWJ
         F2vvndw+v33wkoFcCgSIQfyXiOl4dnNrCR4R88LyBMS9q2gLGwqfaXjku7N6c76xEZzZ
         0m5i1CJl44vvm1z2+o4r0WXSxoRyPCIe+V71yLdKsMvM+3OiMNxfBR3rVmnVl6I7Bi6C
         IbjQ==
X-Gm-Message-State: AAQBX9dRUa2KkIcJpgfIhtBF+U5xrdnl/pumhE1K8R0NgUF1k22+aT5V
        nHm1DdqIZCNq3oTu8VEDJvZrOQ==
X-Google-Smtp-Source: AKy350bFcfcguGqIMfMrx4rzKZu3QwL4KdjmRWj7wFUzBtYdVwMvlc8b0SoYk9T99q8JDK8lpIHQww==
X-Received: by 2002:a17:90b:4a8b:b0:237:99b9:c415 with SMTP id lp11-20020a17090b4a8b00b0023799b9c415mr394373pjb.38.1679610501451;
        Thu, 23 Mar 2023 15:28:21 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id d2-20020a17090a6f0200b0023440af7aafsm1763775pjk.9.2023.03.23.15.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 15:28:20 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:28:16 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 14/18] KVM: mmu: Initialize
 kvm_mmu_memory_cache.gfp_zero to __GFP_ZERO by default
Message-ID: <ZBzSgI2mkpl3QTNt@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
 <20230306224127.1689967-15-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306224127.1689967-15-vipinsh@google.com>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 02:41:23PM -0800, Vipin Sharma wrote:
> Set __GFP_ZERO to gfp_zero in default initizliation of struct
> kvm_mmu_memory_cache{}
> 
> All of the users of default initialization code of struct
> kvm_mmu_memory_cache{} explicitly sets gfp_zero to __GFP_ZERO. This can
> be moved to common initialization logic.

If that were true we could get rid of gfp_zero entirely and hard-code
__GFP_ZERO in the memory allocator! mmu_shadowed_info_cache is the one
that does not set __GFP_ZERO.

> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/arm64/kvm/arm.c      | 1 -
>  arch/arm64/kvm/mmu.c      | 1 -
>  arch/riscv/kvm/mmu.c      | 1 -
>  arch/riscv/kvm/vcpu.c     | 1 -
>  arch/x86/kvm/mmu/mmu.c    | 6 ------
>  include/linux/kvm_types.h | 4 +++-
>  6 files changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 2b3d88e4ace8..b4243978d962 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -331,7 +331,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
>  
>  	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
> -	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>  
>  	/*
>  	 * Default value for the FP state, will be overloaded at load
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8a56f071ca66..133eba96c41f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -904,7 +904,6 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  	if (is_protected_kvm_enabled())
>  		return -EPERM;
>  
> -	cache.gfp_zero = __GFP_ZERO;
>  	size += offset_in_page(guest_ipa);
>  	guest_ipa &= PAGE_MASK;
>  
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index bdd8c17958dd..62550fd91c70 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -353,7 +353,6 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
>  	phys_addr_t addr, end;
>  	KVM_MMU_MEMORY_CACHE(pcache);
>  
> -	pcache.gfp_zero = __GFP_ZERO;
>  	if (in_atomic)
>  		pcache.gfp_custom = GFP_ATOMIC | __GFP_ACCOUNT;
>  
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index bc743e9122d1..f5a96ed1e426 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -164,7 +164,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	/* Mark this VCPU never ran */
>  	vcpu->arch.ran_atleast_once = false;
>  	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
> -	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>  	bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
>  
>  	/* Setup ISA features available to VCPU */
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b706087ef74e..d96afc849ee8 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5963,14 +5963,11 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  
>  	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_pte_list_desc_cache);
>  	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> -	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
>  
>  	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_header_cache);
>  	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> -	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>  
>  	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadow_page_cache);
> -	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
>  	mutex_init(&vcpu->arch.mmu_shadow_page_cache_lock);
>  
>  	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_shadowed_info_cache);
> @@ -6138,14 +6135,11 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  
>  	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache);
>  	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
> -	kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
>  
>  	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache);
> -	kvm->arch.split_shadow_page_cache.gfp_zero = __GFP_ZERO;
>  
>  	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache);
>  	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
> -	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
>  
>  	return 0;
>  }
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 192516eeccac..5da7953532ce 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -99,7 +99,9 @@ struct kvm_mmu_memory_cache {
>  	void **objects;
>  };
>  
> -#define KVM_MMU_MEMORY_CACHE_INIT() { }
> +#define KVM_MMU_MEMORY_CACHE_INIT() {	\
> +	.gfp_zero = __GFP_ZERO,		\
> +}
>  
>  #define KVM_MMU_MEMORY_CACHE(_name) \
>  		struct kvm_mmu_memory_cache _name = KVM_MMU_MEMORY_CACHE_INIT()
> -- 
> 2.40.0.rc0.216.gc4246ad0f0-goog
> 
