Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572483BD8D3
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhGFOt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:49:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232017AbhGFOtZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:49:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lWtqXPxiZdBelo0k7U0AxewqoYZr1YwsdE2r7zVkq6s=;
        b=OHxB5hhjiy4IkGmquLzMFSHTVXRkAHKIW1ULsmN56wc7tDIwgt+9FJ1G5Ib+8qI32+73uY
        1xAKO5c7cySOkWI+AP4s70W26j0cf4h/AY/O5fgVqJslSpSoU82A2eV0+OgqXrwR/FkPGp
        3gVteKnqNkluPWdEj48FRe6UXmIj7MQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-aNtNEoOUOBSx-5jz87UHNQ-1; Tue, 06 Jul 2021 10:46:44 -0400
X-MC-Unique: aNtNEoOUOBSx-5jz87UHNQ-1
Received: by mail-wr1-f71.google.com with SMTP id l12-20020a5d410c0000b029012b4f055c9bso7011473wrp.4
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lWtqXPxiZdBelo0k7U0AxewqoYZr1YwsdE2r7zVkq6s=;
        b=omE4xA+XteWK5tICC++iKbHKeBrwsiHuWMQCl8W2fMbWknHICJ/h5Us8mUQWIeQYtj
         ac2JHVCBDWTtOVeQxFc3OcbqtLXor/BnzR/uGB5FvGyGONVXzXRnAdtQH476cx5n76QS
         CrX+YGQ044v+XeTnhchYqy6N1mbDEHvc9eFzmeM47AW5PP8na/dc51q8YNDU9hlI2OTd
         D9vsjwmjd6D/lfnFEIERAltWdGWGYI6PiD6qSUvhopPUVAgYCAe8UpGoqcvqdrY+Rl8d
         aN+YdItzDfRSMrslsToHliDVLmgXf5UDAa6FnRrJmnrEaCNu/YfvBccUohRFjAmUgZIn
         4Cfw==
X-Gm-Message-State: AOAM531qnmU7Z4Fh4sDhaqsRCFnJmgrrMd0DKmmyqXvESZNCFAYMgaE9
        7cNsAKeOt+ickWz0N9fjQSYr9bRFe6eC43AgRLj8ryDXjZc1vvXTCZcvAP9kjZY4+mwbKAvDKfU
        ZSUGFtLzxnpES
X-Received: by 2002:adf:fd86:: with SMTP id d6mr22274813wrr.84.1625582803870;
        Tue, 06 Jul 2021 07:46:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyd52lQL+6ccoKNuRlEwY7DSiVSmUGs1Mj1QXO68jchzK65nR2PZk6JenmER6LagaRSwBqsEg==
X-Received: by 2002:adf:fd86:: with SMTP id d6mr22274788wrr.84.1625582803708;
        Tue, 06 Jul 2021 07:46:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l10sm16351567wrt.49.2021.07.06.07.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:46:42 -0700 (PDT)
Subject: Re: [RFC PATCH v2 61/69] KVM: VMX: Move AR_BYTES encoder/decoder
 helpers to common.h
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <847069aafe640a360007a4c531930e34945e6417.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1da13c0d-6cd5-cb8c-5e25-a08d7f816901@redhat.com>
Date:   Tue, 6 Jul 2021 16:46:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <847069aafe640a360007a4c531930e34945e6417.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Move the AR_BYTES helpers to common.h so that future patches can reuse
> them to decode/encode AR for TDX.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/common.h | 41 ++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c    | 47 ++++-----------------------------------
>   2 files changed, 45 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index aa6a569b87d1..755aaec85199 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -4,6 +4,7 @@
>   
>   #include <linux/kvm_host.h>
>   
> +#include <asm/kvm.h>
>   #include <asm/traps.h>
>   #include <asm/vmx.h>
>   
> @@ -119,4 +120,44 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
>   	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>   }
>   
> +static inline u32 vmx_encode_ar_bytes(struct kvm_segment *var)
> +{
> +	u32 ar;
> +
> +	if (var->unusable || !var->present)
> +		ar = 1 << 16;
> +	else {
> +		ar = var->type & 15;
> +		ar |= (var->s & 1) << 4;
> +		ar |= (var->dpl & 3) << 5;
> +		ar |= (var->present & 1) << 7;
> +		ar |= (var->avl & 1) << 12;
> +		ar |= (var->l & 1) << 13;
> +		ar |= (var->db & 1) << 14;
> +		ar |= (var->g & 1) << 15;
> +	}
> +
> +	return ar;
> +}
> +
> +static inline void vmx_decode_ar_bytes(u32 ar, struct kvm_segment *var)
> +{
> +	var->unusable = (ar >> 16) & 1;
> +	var->type = ar & 15;
> +	var->s = (ar >> 4) & 1;
> +	var->dpl = (ar >> 5) & 3;
> +	/*
> +	 * Some userspaces do not preserve unusable property. Since usable
> +	 * segment has to be present according to VMX spec we can use present
> +	 * property to amend userspace bug by making unusable segment always
> +	 * nonpresent. vmx_encode_ar_bytes() already marks nonpresent
> +	 * segment as unusable.
> +	 */
> +	var->present = !var->unusable;
> +	var->avl = (ar >> 12) & 1;
> +	var->l = (ar >> 13) & 1;
> +	var->db = (ar >> 14) & 1;
> +	var->g = (ar >> 15) & 1;
> +}
> +
>   #endif /* __KVM_X86_VMX_COMMON_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3c3bfc80d2bb..40843ca2fb33 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -365,8 +365,6 @@ static const struct kernel_param_ops vmentry_l1d_flush_ops = {
>   };
>   module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
>   
> -static u32 vmx_segment_access_rights(struct kvm_segment *var);
> -
>   void vmx_vmexit(void);
>   
>   #define vmx_insn_failed(fmt...)		\
> @@ -2826,7 +2824,7 @@ static void fix_rmode_seg(int seg, struct kvm_segment *save)
>   	vmcs_write16(sf->selector, var.selector);
>   	vmcs_writel(sf->base, var.base);
>   	vmcs_write32(sf->limit, var.limit);
> -	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(&var));
> +	vmcs_write32(sf->ar_bytes, vmx_encode_ar_bytes(&var));
>   }
>   
>   static void enter_rmode(struct kvm_vcpu *vcpu)
> @@ -3217,7 +3215,6 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>   void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	u32 ar;
>   
>   	if (vmx->rmode.vm86_active && seg != VCPU_SREG_LDTR) {
>   		*var = vmx->rmode.segs[seg];
> @@ -3231,23 +3228,7 @@ void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
>   	var->base = vmx_read_guest_seg_base(vmx, seg);
>   	var->limit = vmx_read_guest_seg_limit(vmx, seg);
>   	var->selector = vmx_read_guest_seg_selector(vmx, seg);
> -	ar = vmx_read_guest_seg_ar(vmx, seg);
> -	var->unusable = (ar >> 16) & 1;
> -	var->type = ar & 15;
> -	var->s = (ar >> 4) & 1;
> -	var->dpl = (ar >> 5) & 3;
> -	/*
> -	 * Some userspaces do not preserve unusable property. Since usable
> -	 * segment has to be present according to VMX spec we can use present
> -	 * property to amend userspace bug by making unusable segment always
> -	 * nonpresent. vmx_segment_access_rights() already marks nonpresent
> -	 * segment as unusable.
> -	 */
> -	var->present = !var->unusable;
> -	var->avl = (ar >> 12) & 1;
> -	var->l = (ar >> 13) & 1;
> -	var->db = (ar >> 14) & 1;
> -	var->g = (ar >> 15) & 1;
> +	vmx_decode_ar_bytes(vmx_read_guest_seg_ar(vmx, seg), var);
>   }
>   
>   static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
> @@ -3273,26 +3254,6 @@ int vmx_get_cpl(struct kvm_vcpu *vcpu)
>   	}
>   }
>   
> -static u32 vmx_segment_access_rights(struct kvm_segment *var)
> -{
> -	u32 ar;
> -
> -	if (var->unusable || !var->present)
> -		ar = 1 << 16;
> -	else {
> -		ar = var->type & 15;
> -		ar |= (var->s & 1) << 4;
> -		ar |= (var->dpl & 3) << 5;
> -		ar |= (var->present & 1) << 7;
> -		ar |= (var->avl & 1) << 12;
> -		ar |= (var->l & 1) << 13;
> -		ar |= (var->db & 1) << 14;
> -		ar |= (var->g & 1) << 15;
> -	}
> -
> -	return ar;
> -}
> -
>   void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -3327,7 +3288,7 @@ void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
>   	if (is_unrestricted_guest(vcpu) && (seg != VCPU_SREG_LDTR))
>   		var->type |= 0x1; /* Accessed */
>   
> -	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(var));
> +	vmcs_write32(sf->ar_bytes, vmx_encode_ar_bytes(var));
>   
>   out:
>   	vmx->emulation_required = emulation_required(vcpu);
> @@ -3374,7 +3335,7 @@ static bool rmode_segment_valid(struct kvm_vcpu *vcpu, int seg)
>   	var.dpl = 0x3;
>   	if (seg == VCPU_SREG_CS)
>   		var.type = 0x3;
> -	ar = vmx_segment_access_rights(&var);
> +	ar = vmx_encode_ar_bytes(&var);
>   
>   	if (var.base != (var.selector << 4))
>   		return false;
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

