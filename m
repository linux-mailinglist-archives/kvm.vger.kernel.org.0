Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921482D9B40
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 16:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406508AbgLNPi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 10:38:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408168AbgLNPf0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 10:35:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607960038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+PRiDgQULRi0yq6DjpeidJviTPzLRdIf0NEV0CGlxx4=;
        b=BXOoSOMvKQRHEPl4QW71IPefXfxQX6RfjnhVLogBlx48U/WLS13a2kDxMeBqAEEYtjrgph
        MBWYzUFazJgubUxn0aYm1IdnMurtqnGdTn7zbtjeCESHFFS9XBZMAVoZSszoxgmrF7zJWU
        NFvFV0DNGzhF82CIrUpyfxfcJ+OcfMo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-OmRWNGx-NQm2W1q2gUHodw-1; Mon, 14 Dec 2020 10:33:55 -0500
X-MC-Unique: OmRWNGx-NQm2W1q2gUHodw-1
Received: by mail-ed1-f72.google.com with SMTP id bo22so8426311edb.15
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 07:33:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+PRiDgQULRi0yq6DjpeidJviTPzLRdIf0NEV0CGlxx4=;
        b=cTGaVn+KEwjjx5QdgeE//w4cy6l9Bo2lqDIdvnpzYjHI0Xz47FCJFBj6BMem3CMGm2
         J3GfiSB44dTuZNtbcle4M1DX2t/NNt0w9EzOuvhLA6BAcdRBOENiZn86RYs1HRTPQYVX
         rkv7ymLIQMCzwwRpApLZWTI+YfqRTw98tyuE8YDXHb100ja8XtgFDAt6IOjFLiOc+R9f
         MRVpCDPQQl73gBWNMeBUnKwT5CqAxNe157bVAF7a+nxrthB0AMqmONKHuU2a0lnF2s5O
         ef/ngoZC0xVP8dgVpKAhq75CUbhTlQxGUQi7L7RvVNJMXP9c/36Lq4nOkpYeWcLsG6Ie
         ZvuQ==
X-Gm-Message-State: AOAM530JrmWUM+zyN5nScqpBlgmpvVStqpuQNQiwglKmnlY/EAGU1Q8p
        bLLFjY5K0uSC1U8BuBUKW54FgYmnYc8RD9ob5oaVIIQSgQ/GplKay4NaUMbie2IDJXfqW0kcR5D
        3OyOf80l8EToF
X-Received: by 2002:a17:906:ce3c:: with SMTP id sd28mr22787418ejb.485.1607960028874;
        Mon, 14 Dec 2020 07:33:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy1XRhfOIcU3cutCLJJY4tOucC1Mb7zMFBkGD99zp+c++arxGGFE8VDh5rRqdlANcQAaDZwlA==
X-Received: by 2002:a17:906:ce3c:: with SMTP id sd28mr22786860ejb.485.1607960021472;
        Mon, 14 Dec 2020 07:33:41 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j5sm15718173edl.42.2020.12.14.07.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 07:33:39 -0800 (PST)
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <eb73a31713e8ddc324b61c4d4425f27cbf5eae50.1607620209.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 07/34] KVM: SVM: Add required changes to support
 intercepts under SEV-ES
Message-ID: <68d996e8-8f08-559c-c626-53f1daaff187@redhat.com>
Date:   Mon, 14 Dec 2020 16:33:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <eb73a31713e8ddc324b61c4d4425f27cbf5eae50.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/20 18:09, Tom Lendacky wrote:
> @@ -2797,7 +2838,27 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   
>   static int wrmsr_interception(struct vcpu_svm *svm)
>   {
> -	return kvm_emulate_wrmsr(&svm->vcpu);
> +	u32 ecx;
> +	u64 data;
> +
> +	if (!sev_es_guest(svm->vcpu.kvm))
> +		return kvm_emulate_wrmsr(&svm->vcpu);
> +
> +	ecx = kvm_rcx_read(&svm->vcpu);
> +	data = kvm_read_edx_eax(&svm->vcpu);
> +	if (kvm_set_msr(&svm->vcpu, ecx, data)) {
> +		trace_kvm_msr_write_ex(ecx, data);
> +		ghcb_set_sw_exit_info_1(svm->ghcb, 1);
> +		ghcb_set_sw_exit_info_2(svm->ghcb,
> +					X86_TRAP_GP |
> +					SVM_EVTINJ_TYPE_EXEPT |
> +					SVM_EVTINJ_VALID);
> +		return 1;
> +	}
> +
> +	trace_kvm_msr_write(ecx, data);
> +
> +	return kvm_skip_emulated_instruction(&svm->vcpu);
>   }
>   
>   static int msr_interception(struct vcpu_svm *svm)

This code duplication is ugly, and does not work with userspace MSR 
filters too.

But we can instead trap the completion of the MSR read/write to use 
ghcb_set_sw_exit_info_1 instead of kvm_inject_gp, with a callback like

static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
{
         if (!sev_es_guest(svm->vcpu.kvm) || !err)
                 return kvm_complete_insn_gp(&svm->vcpu, err);

         ghcb_set_sw_exit_info_1(svm->ghcb, 1);
         ghcb_set_sw_exit_info_2(svm->ghcb,
                                 X86_TRAP_GP |
                                 SVM_EVTINJ_TYPE_EXEPT |
                                 SVM_EVTINJ_VALID);
         return 1;
}


...
	.complete_emulated_msr = svm_complete_emulated_msr,

> @@ -2827,7 +2888,14 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
>   static int pause_interception(struct vcpu_svm *svm)
>   {
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	bool in_kernel = (svm_get_cpl(vcpu) == 0);
> +	bool in_kernel;
> +
> +	/*
> +	 * CPL is not made available for an SEV-ES guest, so just set in_kernel
> +	 * to true.
> +	 */
> +	in_kernel = (sev_es_guest(svm->vcpu.kvm)) ? true
> +						  : (svm_get_cpl(vcpu) == 0);
>   
>   	if (!kvm_pause_in_guest(vcpu->kvm))
>   		grow_ple_window(vcpu);

See below.

> @@ -3273,6 +3351,13 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   	struct vmcb *vmcb = svm->vmcb;
>   
> +	/*
> +	 * SEV-ES guests to not expose RFLAGS. Use the VMCB interrupt mask
> +	 * bit to determine the state of the IF flag.
> +	 */
> +	if (sev_es_guest(svm->vcpu.kvm))
> +		return !(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK);

This seems wrong, you have to take into account 
SVM_INTERRUPT_SHADOW_MASK as well.  Also, even though GIF is not really 
used by SEV-ES guests, I think it's nicer to put this check afterwards.

That is:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4372e45c8f06..2dd9c9698480 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3247,7 +3247,14 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
  	if (!gif_set(svm))
  		return true;

-	if (is_guest_mode(vcpu)) {
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		/*
+		 * SEV-ES guests to not expose RFLAGS. Use the VMCB interrupt mask
+		 * bit to determine the state of the IF flag.
+		 */
+		if (!(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK))
+			return true;
+	} else if (is_guest_mode(vcpu)) {
  		/* As long as interrupts are being delivered...  */
  		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
  		    ? !(svm->nested.hsave->save.rflags & X86_EFLAGS_IF)



>   	if (!gif_set(svm))
>   		return true;
>   
> @@ -3458,6 +3543,12 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
>   		svm->vcpu.arch.nmi_injected = true;
>   		break;
>   	case SVM_EXITINTINFO_TYPE_EXEPT:
> +		/*
> +		 * Never re-inject a #VC exception.
> +		 */
> +		if (vector == X86_TRAP_VC)
> +			break;
> +
>   		/*
>   		 * In case of software exceptions, do not reinject the vector,
>   		 * but re-execute the instruction instead. Rewind RIP first
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a3fdc16cfd6f..b6809a2851d2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4018,7 +4018,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   {
>   	int idx;
>   
> -	if (vcpu->preempted)
> +	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
>   		vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);

This has to be true, otherwise no directed yield will be done at all:

	if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
	    !kvm_arch_vcpu_in_kernel(vcpu))
		continue;

Or more easily, just use in_kernel == false in pause_interception, like

+	/*
+	 * CPL is not made available for an SEV-ES guest, therefore
+	 * vcpu->arch.preempted_in_kernel can never be true.  Just
+	 * set in_kernel to false as well.
+	 */
+	in_kernel = !sev_es_guest(svm->vcpu.kvm) && svm_get_cpl(vcpu) == 0;

>   
>   	/*
> @@ -8161,7 +8161,9 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_run *kvm_run = vcpu->run;
>   
> -	kvm_run->if_flag = (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
> +	kvm_run->if_flag = (vcpu->arch.guest_state_protected)
> +		? kvm_arch_interrupt_allowed(vcpu)
> +		: (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;

Here indeed you only want the interrupt allowed bit, not the interrupt 
window.  But we can just be bold and always set it to true.

- for userspace irqchip, kvm_run->ready_for_interrupt_injection is set 
just below and it will always be false if kvm_arch_interrupt_allowed is 
false

- for in-kernel APIC, if_flag is documented to be invalid (though it 
actually is valid).  For split irqchip, they can just use 
kvm_run->ready_for_interrupt_injection; for entirely in-kernel interrupt 
handling, userspace does not need if_flag at all.

Paolo

>   	kvm_run->flags = is_smm(vcpu) ? KVM_RUN_X86_SMM : 0;
>   	kvm_run->cr8 = kvm_get_cr8(vcpu);
>   	kvm_run->apic_base = kvm_get_apic_base(vcpu);
> 


