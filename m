Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18ADD6EB7F9
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 10:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjDVISm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 04:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjDVISk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 04:18:40 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B7390;
        Sat, 22 Apr 2023 01:18:38 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4edcc712d95so244414e87.1;
        Sat, 22 Apr 2023 01:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682151517; x=1684743517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+aQN9XLWKAMHX9ca92J9NiyyKoOt1W6QokC8Q6kDPfk=;
        b=P7Gbw1s9Wh1EXxMAi6t59x3ZCZ2nHdjVUVp1f41BUTulLfSnzO0/fqATuYv+etsK1s
         TjHBqVKnqQ7zIhYGofu6X/Xt252jK3Oy4Y3D2ObynuQKzZ0zXduTU5Csb3QNsgBqHudX
         b6BTxriXFuHmtZGvKa5NTE1YvmZtjAXinlGAJwb1CMQ3j5shcfRHb/C8UIhDn6rgKckz
         eEolHIdKfLQGLwRjueCqS869JF8W210Sfdjbtwx84GtpVklMR4L06oEuT9a+EfGlo48m
         sf4WhogmVy8Jui2tq30yfBBS60Cp0T2wV1EQ72NGjSIeq5sW9OliadYTVGsANY2D538t
         0oAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682151517; x=1684743517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+aQN9XLWKAMHX9ca92J9NiyyKoOt1W6QokC8Q6kDPfk=;
        b=RcdaNN9d/eQipzUySk/ZJSECUbRcY3wX9gJscCr2izL7oPEHD2k8C8GhNVI4awbNv3
         HZYAyX1WHHBC0C8bvo0/fZZevyDOynP3MnYhRVTlTQ6v6jSZDCbSzAe70cs0AZ/TN/Z5
         S/QOcz1DWchSkSO8Og4u/44B1BUgmDw+17tHBHgAN72NHo5MMteHVAh0OpFP3NpACYuk
         qn/ffLPcm+iEr5Cw+y67Sp0sotZeS5sKiGyIK0K72w0hpRAzwf3cX/0b5Qw9BleDxt1x
         kK6dF+7ujw/uWu2FQ4JuEouVDH0sBazck8h4rCLnPUOjwE53U17oDf+/uHsBbdHnh4yM
         A7gQ==
X-Gm-Message-State: AAQBX9e7OBFBFuJeQ6gKjQtEWfH6XtSE4+ZYQehR7QzGfQU0jTVX9YK2
        Y4TXa6ht4TyOc+dtCNvUATyN9C7fSlNLjA==
X-Google-Smtp-Source: AKy350Zh/uH9TucOCQHh9DcDzSaeyDg3am6FA2brVSGB9Khg4vT0C5HnvU3MbYWhninX88PXhGlNsQ==
X-Received: by 2002:a2e:9804:0:b0:2a9:f6f0:fc8c with SMTP id a4-20020a2e9804000000b002a9f6f0fc8cmr1660730ljj.3.1682151516726;
        Sat, 22 Apr 2023 01:18:36 -0700 (PDT)
Received: from localhost (88-113-32-99.elisa-laajakaista.fi. [88.113.32.99])
        by smtp.gmail.com with ESMTPSA id m15-20020a056512014f00b004e7fa99f2b5sm818818lfo.186.2023.04.22.01.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 01:18:36 -0700 (PDT)
Date:   Sat, 22 Apr 2023 11:18:34 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH v13 048/113] KVM: x86/mmu: Disallow dirty logging for
 x86 TDX
Message-ID: <20230422111834.00003689@gmail.com>
In-Reply-To: <23cc6df6ec2ca776c3efe148e70ba290aa3de319.1678643052.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <23cc6df6ec2ca776c3efe148e70ba290aa3de319.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 12 Mar 2023 10:56:12 -0700
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX doesn't support dirty logging.  Report dirty logging isn't supported so
> that device model, for example qemu, can properly handle it.  Silently
> ignore on dirty logging on private GFNs of TDX.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  3 +++
>  arch/x86/kvm/mmu/tdp_mmu.c | 36 +++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.c         |  8 ++++++++
>  include/linux/kvm_host.h   |  1 +
>  virt/kvm/kvm_main.c        | 10 +++++++++-
>  5 files changed, 56 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3d68da838f94..1f250fa8ce36 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6706,6 +6706,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  	for_each_rmap_spte(rmap_head, &iter, sptep) {
>  		sp = sptep_to_sp(sptep);
>  
> +		/* Private page dirty logging is not supported yet. */
> +		KVM_BUG_ON(is_private_sptep(sptep), kvm);
> +
>  		/*
>  		 * We cannot do huge page mapping for indirect shadow pages,
>  		 * which are found on the last rmap (level = 1) when not using
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index a3402b33fa5d..58a236a69ec7 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1474,9 +1474,27 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>  	 * into this helper allow blocking; it'd be dead, wasteful code.
>  	 */
>  	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
> +		gfn_t start;
> +		gfn_t end;
> +
> +		/*
> +		 * For now, operation on private GPA, e.g. dirty page logging,
> +		 * isn't supported yet.
> +		 */
> +		if (is_private_sp(root))
> +			continue;
> +
>  		rcu_read_lock();
>  
> -		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
> +		/*
> +		 * For TDX shared mapping, set GFN shared bit to the range,
> +		 * so the handler() doesn't need to set it, to avoid duplicated
> +		 * code in multiple handler()s.
> +		 */
> +		start = kvm_gfn_to_shared(kvm, range->start);
> +		end = kvm_gfn_to_shared(kvm, range->end);
> +
> +		tdp_root_for_each_leaf_pte(iter, root, start, end)
>  			ret |= handler(kvm, &iter, range);
>  
>  		rcu_read_unlock();
> @@ -1959,6 +1977,13 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>  	struct kvm_mmu_page *root;
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
> +	/*
> +	 * First TDX generation doesn't support clearing dirty bit,
> +	 * since there's no secure EPT API to support it.  For now silently
> +	 * ignore KVM_CLEAR_DIRTY_LOG.
> +	 */
> +	if (!kvm_arch_dirty_log_supported(kvm))
> +		return;
>  	for_each_tdp_mmu_root(kvm, root, slot->as_id)
>  		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
>  }
> @@ -2078,6 +2103,15 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>  	bool spte_set = false;
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	/*
> +	 * First TDX generation doesn't support write protecting private
> +	 * mappings, silently ignore the request.  KVM_GET_DIRTY_LOG etc
> +	 * can reach here, no warning.
> +	 */
> +	if (!kvm_arch_dirty_log_supported(kvm))
> +		return false;
> +
>  	for_each_tdp_mmu_root(kvm, root, slot->as_id)
>  		spte_set |= write_protect_gfn(kvm, root, gfn, min_level);
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a0960b468c74..6d7ca694e1c9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12589,6 +12589,9 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  	u32 new_flags = new ? new->flags : 0;
>  	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
>  
> +	if (!kvm_arch_dirty_log_supported(kvm) && log_dirty_pages)
> +		return;
> +
>  	/*
>  	 * Update CPU dirty logging if dirty logging is being toggled.  This
>  	 * applies to all operations.
> @@ -13561,6 +13564,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  }
>  EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>  
> +bool kvm_arch_dirty_log_supported(struct kvm *kvm)
> +{
> +	return kvm->arch.vm_type != KVM_X86_PROTECTED_VM;
> +}
> +

Maybe introduce a new x86 ops for SNP/TDX to check this separately as SNP
might still support it? With the current approach, I think both SNP/TDX
will be affected. So does the later patch about page-tracking. 

Michael, can you confirm this?

>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 5a144497c930..3cd537f4b38b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1495,6 +1495,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
>  int kvm_arch_post_init_vm(struct kvm *kvm);
>  void kvm_arch_pre_destroy_vm(struct kvm *kvm);
>  int kvm_arch_create_vm_debugfs(struct kvm *kvm);
> +bool kvm_arch_dirty_log_supported(struct kvm *kvm);
>  
>  #ifndef __KVM_HAVE_ARCH_VM_ALLOC
>  /*
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 42f01d0d6a49..e9f8225f3406 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1700,10 +1700,18 @@ static void kvm_replace_memslot(struct kvm *kvm,
>  	}
>  }
>  
> +bool __weak kvm_arch_dirty_log_supported(struct kvm *kvm)
> +{
> +	return true;
> +}
> +
>  static int check_memory_region_flags(struct kvm *kvm,
>  				     const struct kvm_userspace_memory_region2 *mem)
>  {
> -	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
> +	u32 valid_flags = 0;
> +
> +	if (kvm_arch_dirty_log_supported(kvm))
> +		valid_flags |= KVM_MEM_LOG_DIRTY_PAGES;
>  
>  	if (kvm_arch_has_private_mem(kvm))
>  		valid_flags |= KVM_MEM_PRIVATE;

