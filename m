Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B900830C7BA
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbhBBR31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:29:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29260 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237532AbhBBR0B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:26:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612286676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0TUQT22ZC2nt5C6/vYK8TRYYduebyaAtrXwi+hOcJow=;
        b=dxYnXST0n6tDCLdafbcxQIfQm+g2vMqrTUIUeqabajFQzihtiU+ygaUurujlJiB3wi3Qtz
        59Q3Iy0CrVT8OQvM45fjstF1XnkxCkg5OBFTUR0CAYE+Eh3h6XLnirsVzrznlvbrUaZfim
        +BEO2Z7+Oa4HAY9qG4rs8d4srqGw1pc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-yoAIJCXdNtOnT-f88OLd5g-1; Tue, 02 Feb 2021 12:24:34 -0500
X-MC-Unique: yoAIJCXdNtOnT-f88OLd5g-1
Received: by mail-ed1-f71.google.com with SMTP id j12so9886247edq.10
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 09:24:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0TUQT22ZC2nt5C6/vYK8TRYYduebyaAtrXwi+hOcJow=;
        b=DRRuwA2fEzL8qTeFK+ZDUg+dsGCqehrISM4E+YlxAVE+s9MAHKvN4VE2/p0KjSHHT3
         A73upGvgnn0XeNA5Dz6XieRVhEmR20/bCq0BYHNpa4zJHliuIT5bD2KGPeI3qT/nq55e
         K2R9udSb4KeIJ2UpY+H7Tn7wzOmF0oygeb+IH4O0ZZFKxFIeKRVcDyCX7aBCJ3K+z42N
         SaXuWbyC5Q/fO5d4yF0iCmuVFHqa9ZF8/rASD6Fks0eeRwbqMBVHFkvsSfDj9Tc/fryu
         EnFylB9/syPOJgha6g6/Cr5Bt2KjMFmG+7LdBwiBASqGd+eJ9EPS1sNzaPLh0ZbxUfGY
         VSiw==
X-Gm-Message-State: AOAM533DehyenqbVNJ+KCrFFizRoVbc7yBX1EmbJazup3q69pFWMW5bM
        S+m+iAiTQ5XB4eM8uBY66zeOMmqIypVfKtxskLFMIaft3VhhRmeFl8zXmAAOtGfxr8fPjmgQ8fg
        cFYjtvTikBUb5O3c0sZvOZgcKwItBOXxrihGPimTO0NHm8yM9RudT4XmN0QsCSQIE
X-Received: by 2002:a17:906:f195:: with SMTP id gs21mr11533271ejb.225.1612286672233;
        Tue, 02 Feb 2021 09:24:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwjVVBKcbBzllt4Zcf/z8kxqEOclKt76Dc3cq8QK9c4JMRXZl5/+9Xo95IdhsOb+mdQGQYFFA==
X-Received: by 2002:a17:906:f195:: with SMTP id gs21mr11533245ejb.225.1612286671988;
        Tue, 02 Feb 2021 09:24:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f22sm9762527eje.34.2021.02.02.09.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 09:24:31 -0800 (PST)
Subject: Re: [PATCH 1/3] KVM: x86: move kvm_inject_gp up from kvm_set_xcr to
 callers
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210202165141.88275-1-pbonzini@redhat.com>
 <20210202165141.88275-2-pbonzini@redhat.com> <YBmJoehBMbgvuuyW@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <32428af8-85e7-8a4a-08ca-e1988a0775fd@redhat.com>
Date:   Tue, 2 Feb 2021 18:24:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBmJoehBMbgvuuyW@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 18:19, Sean Christopherson wrote:
> On Tue, Feb 02, 2021, Paolo Bonzini wrote:
>> Push the injection of #GP up to the callers, so that they can just use
>> kvm_complete_insn_gp.
> 
> The SVM and VMX code is identical, IMO we should push all the code to x86.c
> instead of shuffling it around.
> 
> I'd also like to change svm_exit_handlers to take @vcpu instead of @svm so that
> SVM can invoke common handlers directly.
> 
> If you agree, I'll send a proper series to do the above, plus whatever other
> cleanups I find, e.g. INVD, WBINVD, etc...

Yes, why not.  There's a lot of things that are only slightly different 
between VMX and SVM for no particular reason.

Paolo

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fa7b2df6422b..bf917efde35c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1530,7 +1530,7 @@ int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val);
>   unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
>   void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
>   void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l);
> -int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr);
> +int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);
> 
>   int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
>   int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 687876211ebe..842a74d88f1b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2334,14 +2334,7 @@ static int wbinvd_interception(struct vcpu_svm *svm)
> 
>   static int xsetbv_interception(struct vcpu_svm *svm)
>   {
> -       u64 new_bv = kvm_read_edx_eax(&svm->vcpu);
> -       u32 index = kvm_rcx_read(&svm->vcpu);
> -
> -       if (kvm_set_xcr(&svm->vcpu, index, new_bv) == 0) {
> -               return kvm_skip_emulated_instruction(&svm->vcpu);
> -       }
> -
> -       return 1;
> +       return kvm_emulate_xsetbv(&svm->vcpu);
>   }
> 
>   static int rdpru_interception(struct vcpu_svm *svm)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cf0c397dc3eb..474a169835de 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5218,16 +5218,6 @@ static int handle_wbinvd(struct kvm_vcpu *vcpu)
>          return kvm_emulate_wbinvd(vcpu);
>   }
> 
> -static int handle_xsetbv(struct kvm_vcpu *vcpu)
> -{
> -       u64 new_bv = kvm_read_edx_eax(vcpu);
> -       u32 index = kvm_rcx_read(vcpu);
> -
> -       if (kvm_set_xcr(vcpu, index, new_bv) == 0)
> -               return kvm_skip_emulated_instruction(vcpu);
> -       return 1;
> -}
> -
>   static int handle_apic_access(struct kvm_vcpu *vcpu)
>   {
>          if (likely(fasteoi)) {
> @@ -5689,7 +5679,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>          [EXIT_REASON_APIC_WRITE]              = handle_apic_write,
>          [EXIT_REASON_EOI_INDUCED]             = handle_apic_eoi_induced,
>          [EXIT_REASON_WBINVD]                  = handle_wbinvd,
> -       [EXIT_REASON_XSETBV]                  = handle_xsetbv,
> +       [EXIT_REASON_XSETBV]                  = kvm_emulate_xsetbv,
>          [EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
>          [EXIT_REASON_MCE_DURING_VMENTRY]      = handle_machine_check,
>          [EXIT_REASON_GDTR_IDTR]               = handle_desc,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 14fb8a138ec3..ef630f8d8bd2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -984,16 +984,17 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>          return 0;
>   }
> 
> -int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
> +int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
>   {
>          if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
> -           __kvm_set_xcr(vcpu, index, xcr)) {
> +           __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu))) {
>                  kvm_inject_gp(vcpu, 0);
>                  return 1;
>          }
> -       return 0;
> +
> +       return kvm_skip_emulated_instruction(vcpu);
>   }
> -EXPORT_SYMBOL_GPL(kvm_set_xcr);
> +EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
> 
>   bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>   {
> 
> 

