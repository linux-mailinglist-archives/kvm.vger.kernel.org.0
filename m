Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDF05232EE
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 14:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242426AbiEKMTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 08:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242165AbiEKMTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 08:19:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18A1D67D0D
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 05:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652271538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qo0Tuocvu0rAXiJY7/7YeZeIw3FCBGuUkjFz35/a6LU=;
        b=aAcGIOp1U/tWAWCamWG9yuO5b4D8nfF2IgOak0jgXzjBvgYoDFUCvXlCC+Hbjyips2hT3P
        Qt8tBoTgkVreHv7P2tO1fiYR3askm0nIoQo8+jo7bNGEgd1D3z1cqzmIDTe459GW3aRzSF
        dUFu1+hUiksECUoWe35LqbTT+xfMW+w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-PkIhWHOFMeK95q2IfJGijQ-1; Wed, 11 May 2022 08:18:57 -0400
X-MC-Unique: PkIhWHOFMeK95q2IfJGijQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71CC4811E84;
        Wed, 11 May 2022 12:18:56 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DDFE4087D63;
        Wed, 11 May 2022 12:18:53 +0000 (UTC)
Message-ID: <79223471c31303020cf7766aeb4c5caf48ffab93.camel@redhat.com>
Subject: Re: [PATCH v3 34/34] KVM: x86: Rename 'enable_direct_tlbflush' to
 'enable_l2_tlb_flush'
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 15:18:53 +0300
In-Reply-To: <20220414132013.1588929-35-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-35-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:20 +0200, Vitaly Kuznetsov wrote:
> To make terminology between Hyper-V-on-KVM and KVM-on-Hyper-V consistent,
> rename 'enable_direct_tlbflush' to 'enable_l2_tlb_flush'. The change
> eliminates the use of confusing 'direct' and adds the missing underscore.
> 
> No functional change.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 2 +-
>  arch/x86/include/asm/kvm_host.h    | 2 +-
>  arch/x86/kvm/svm/svm_onhyperv.c    | 2 +-
>  arch/x86/kvm/svm/svm_onhyperv.h    | 6 +++---
>  arch/x86/kvm/vmx/vmx.c             | 6 +++---
>  arch/x86/kvm/x86.c                 | 6 +++---
>  6 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 96e4e9842dfc..1e13612a6446 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -121,7 +121,7 @@ KVM_X86_OP_OPTIONAL(vm_move_enc_context_from)
>  KVM_X86_OP(get_msr_feature)
>  KVM_X86_OP(can_emulate_instruction)
>  KVM_X86_OP(apic_init_signal_blocked)
> -KVM_X86_OP_OPTIONAL(enable_direct_tlbflush)
> +KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
>  KVM_X86_OP_OPTIONAL(migrate_timers)
>  KVM_X86_OP(msr_filter_changed)
>  KVM_X86_OP(complete_emulated_msr)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 168600490bd1..f4fd6da1f565 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1526,7 +1526,7 @@ struct kvm_x86_ops {
>  					void *insn, int insn_len);
>  
>  	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
> -	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> +	int (*enable_l2_tlb_flush)(struct kvm_vcpu *vcpu);
>  
>  	void (*migrate_timers)(struct kvm_vcpu *vcpu);
>  	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
> index 8cdc62c74a96..69a7014d1cef 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.c
> +++ b/arch/x86/kvm/svm/svm_onhyperv.c
> @@ -14,7 +14,7 @@
>  #include "kvm_onhyperv.h"
>  #include "svm_onhyperv.h"
>  
> -int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
> +int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
>  {
>  	struct hv_enlightenments *hve;
>  	struct hv_partition_assist_pg **p_hv_pa_pg =
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
> index e2fc59380465..d6ec4aeebedb 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -13,7 +13,7 @@
>  
>  static struct kvm_x86_ops svm_x86_ops;
>  
> -int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
> +int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
>  
>  static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>  {
> @@ -51,8 +51,8 @@ static inline void svm_hv_hardware_setup(void)
>  
>  			vp_ap->nested_control.features.directhypercall = 1;
>  		}
> -		svm_x86_ops.enable_direct_tlbflush =
> -				svm_hv_enable_direct_tlbflush;
> +		svm_x86_ops.enable_l2_tlb_flush =
> +				svm_hv_enable_l2_tlb_flush;
>  	}
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a81e44852f54..2b3c73b49dcb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -461,7 +461,7 @@ static unsigned long host_idt_base;
>  static bool __read_mostly enlightened_vmcs = true;
>  module_param(enlightened_vmcs, bool, 0444);
>  
> -static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
> +static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
>  {
>  	struct hv_enlightened_vmcs *evmcs;
>  	struct hv_partition_assist_pg **p_hv_pa_pg =
> @@ -8151,8 +8151,8 @@ static int __init vmx_init(void)
>  		}
>  
>  		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
> -			vmx_x86_ops.enable_direct_tlbflush
> -				= hv_enable_direct_tlbflush;
> +			vmx_x86_ops.enable_l2_tlb_flush
> +				= hv_enable_l2_tlb_flush;
>  
>  	} else {
>  		enlightened_vmcs = false;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d3839e648ab3..d620c56bc526 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4365,7 +4365,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  			kvm_x86_ops.nested_ops->get_state(NULL, NULL, 0) : 0;
>  		break;
>  	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
> -		r = kvm_x86_ops.enable_direct_tlbflush != NULL;
> +		r = kvm_x86_ops.enable_l2_tlb_flush != NULL;
>  		break;
>  	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
>  		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
> @@ -5275,10 +5275,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  		}
>  		return r;
>  	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
> -		if (!kvm_x86_ops.enable_direct_tlbflush)
> +		if (!kvm_x86_ops.enable_l2_tlb_flush)
>  			return -ENOTTY;
>  
> -		return static_call(kvm_x86_enable_direct_tlbflush)(vcpu);
> +		return static_call(kvm_x86_enable_l2_tlb_flush)(vcpu);
>  
>  	case KVM_CAP_HYPERV_ENFORCE_CPUID:
>  		return kvm_hv_set_enforce_cpuid(vcpu, cap->args[0]);

Nitpick: You may want to put that patch at the start of the series, since it doesn't depend on it.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky


