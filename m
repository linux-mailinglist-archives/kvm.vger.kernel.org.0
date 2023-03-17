Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F31C6BDDAC
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 01:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjCQAce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 20:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCQAcc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 20:32:32 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F693590
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 17:32:29 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id ay18so2177359pfb.2
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 17:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679013149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V9ZVpgZ9+kDd6RFhVv2i+UEEMEweNyLaevgC+90wVQ4=;
        b=OALmnmtRFgm7i6K5bhCikLhmRVrCwTMDGdcZHnbdh/pex4uLRd6YXtgsTQgLc11uUC
         XMChhuJ7AO4Wlvt9fDtqq1TY6mYihfyoUa6BYUxIeBJIIK+sDFNNkpvmOlM7/KipNTdi
         Na/NuzdO+LfUjPYRbv6mdxn7wG1gipO67XigpH7ceUq3eTDUVwgi5devghdMYgvTKQP8
         z0OG0gENyfebDLZmK1wh2C38OVsxHfMBgXDzwzyJAY4rcOAFnspqWwAQlYLwgMyXfPEa
         OM8UjlxT96SfMWtxX6KjCRwhBOi/V27gvcjfi6GWaj7Mi4qEXoDnkRIorN5smudYClon
         Y9sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679013149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V9ZVpgZ9+kDd6RFhVv2i+UEEMEweNyLaevgC+90wVQ4=;
        b=Nv6+b38Y2FFqYnSVDVt+iDK8iPHQXNpcmzc0Vz3BJDk2w5qHxE9DV/h/jiTSlMfWFq
         UXZ+BWGIosXOeAxwTodtMpT760r4xsOOk/QCz1cf2lipFOgI5V+naWL1bQmxVaflh3RT
         /9t++CRRL6EnO0BsVwJrAvO2W75hI5sfUHvaCrlDU7XgUgNh4U1WX3tj4jlPxOWS/PB2
         3TAslFxo0QhOX4tY37LcpoUVAIdrlQ3+EJ5SSCdQjrgS66SIrjRlCGZoWms7cWgCpp1c
         5vXzxHCX5s6Rha3MeX1YKSAVn53I+A+JL6RmxCWhHvAzkpUgRncFa1rNPkorLsM4tUtt
         W9iA==
X-Gm-Message-State: AO0yUKWAeL2D4Q6FiuglJG30zMuxqv2aLT4F6lhC7CdM5tzhfq4w1s/i
        JEA3bbOjsfACLJY5yyymcrTjshoUm28SIw==
X-Google-Smtp-Source: AK7set+TS9C1CTSeLC1/HK6r94SfoNtTsvzPDqEgcaRtiMU+gBvX3KF8xTfS8MX84lFnMHskQ9ilBg==
X-Received: by 2002:aa7:96e6:0:b0:5a8:d97d:c346 with SMTP id i6-20020aa796e6000000b005a8d97dc346mr4433250pfq.12.1679013148558;
        Thu, 16 Mar 2023 17:32:28 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id f23-20020aa782d7000000b0056283e2bdbdsm259994pfn.138.2023.03.16.17.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 17:32:27 -0700 (PDT)
Date:   Thu, 16 Mar 2023 17:32:26 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, jthoughton@google.com, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [WIP Patch v2 10/14] KVM: x86: Implement
 KVM_CAP_MEMORY_FAULT_NOWAIT
Message-ID: <20230317003226.GB408922@ls.amr.corp.intel.com>
References: <20230315021738.1151386-1-amoorthy@google.com>
 <20230315021738.1151386-11-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230315021738.1151386-11-amoorthy@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 02:17:34AM +0000,
Anish Moorthy <amoorthy@google.com> wrote:

> When a memslot has the KVM_MEM_MEMORY_FAULT_EXIT flag set, exit to
> userspace upon encountering a page fault for which the userspace
> page tables do not contain a present mapping.
> ---
>  arch/x86/kvm/mmu/mmu.c | 33 +++++++++++++++++++++++++--------
>  arch/x86/kvm/x86.c     |  1 +
>  2 files changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5e0140db384f6..68bc4ab2bd942 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3214,7 +3214,9 @@ static void kvm_send_hwpoison_signal(struct kvm_memory_slot *slot, gfn_t gfn)
>  	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva, PAGE_SHIFT, current);
>  }
>  
> -static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +static int kvm_handle_error_pfn(
> +	struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> +	bool faulted_on_absent_mapping)
>  {
>  	if (is_sigpending_pfn(fault->pfn)) {
>  		kvm_handle_signal_exit(vcpu);
> @@ -3234,7 +3236,11 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
>  		return RET_PF_RETRY;
>  	}
>  
> -	return -EFAULT;
> +	return kvm_memfault_exit_or_efault(
> +		vcpu, fault->gfn * PAGE_SIZE, PAGE_SIZE,
> +		faulted_on_absent_mapping
> +			? KVM_MEMFAULT_REASON_ABSENT_MAPPING
> +			: KVM_MEMFAULT_REASON_UNKNOWN);
>  }
>  
>  static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
> @@ -4209,7 +4215,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
>  }
>  
> -static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +static int __kvm_faultin_pfn(
> +	struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> +	bool fault_on_absent_mapping)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
>  	bool async;
> @@ -4242,9 +4250,15 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	}
>  
>  	async = false;
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> +
> +	fault->pfn = __gfn_to_pfn_memslot(
> +		slot, fault->gfn,
> +		fault_on_absent_mapping,
> +		false,
> +		fault_on_absent_mapping ? NULL : &async,
> +		fault->write, &fault->map_writable,
> +		&fault->hva);
> +
>  	if (!async)
>  		return RET_PF_CONTINUE; /* *pfn has correct page already */
>  
> @@ -4274,16 +4288,19 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  			   unsigned int access)
>  {
>  	int ret;
> +	bool fault_on_absent_mapping
> +		= likely(fault->slot) && kvm_slot_fault_on_absent_mapping(fault->slot);

nit: Instead of passing around the value, we can add a new member to
struct kvm_page_fault::fault_on_absent_mapping.

  fault->fault_on_absent_mapping = likely(fault->slot) && kvm_slot_fault_on_absent_mapping(fault->slot);

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
