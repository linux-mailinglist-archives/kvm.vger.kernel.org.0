Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3B924BAC2
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 14:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbgHTMQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 08:16:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52540 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728004AbgHTJ4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 05:56:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597917398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBZ9tzVG8IQYeA14qViPmIhF5BRH6qjqiVI94E69QaM=;
        b=XoKg5CBA/5EFLEu4kejb+QGdLV3NCx0wM1sGmH32SZAeI5jUmrJOy9yIRMzBdyCU0PRu4K
        Caqa9xevJAW9YN9uqi525v0rBnWgzL3WjDyT7zXK+XZUfXUa2Y3qqXT6dW6YDuejpRnGQ6
        69GGHPAd0izl5a13FQ5gRtqAprlossY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522--CaGHKzKNwO_bx9mDXXaWA-1; Thu, 20 Aug 2020 05:56:36 -0400
X-MC-Unique: -CaGHKzKNwO_bx9mDXXaWA-1
Received: by mail-wm1-f70.google.com with SMTP id k204so775626wmb.3
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 02:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BBZ9tzVG8IQYeA14qViPmIhF5BRH6qjqiVI94E69QaM=;
        b=jg0dVOD/Ht8tHh2uA5ylVH0o9wRBd1GWz6ANFQfYFVFm9u5hUj57YaXCh06CzB5Gpx
         uFFxLp3OnNrHrwetwqTonTp82vRcfsG4HcDdao6dDKqQ3kt5yw4gT0fW+Zae+VL4Jlq8
         IT68I9Z7bmMpaPgWIhNCd+JdK5kpWcQi136VsxAseYNYfsjUsJEH7TsuLCFV40aeaqiZ
         EmJihbwqdMvKEbQJkAgrtuMzWayd0LObbE7vPgxQDWbrO/R2fvEYpRRi4TEfR3UHN3PU
         knndu+oNcit42IMK5hQVBOQXBStTGaEGfnr4+yNhtyqYBl9lxarjkmVWP5UIxBUjulQu
         ZV+A==
X-Gm-Message-State: AOAM530b2X9Ry8VRzfOGwm3R6LaosPBc9zx/aJ3ctlH8y+lYBDEYKHFo
        Yc9dDpDj8UJl6gY+//ly2BLVD+yWrjmJONyY1+Zc8C/Cfsse7ch/bp3meGw/Q7ZPj3g4R4W3qN0
        CsjS2JAekU+j8
X-Received: by 2002:adf:b18d:: with SMTP id q13mr2390348wra.256.1597917395661;
        Thu, 20 Aug 2020 02:56:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrfr+Qru5BiCr9hmj1YTIj41N0i8y3XjstZXt12asbQQWLh4g4cNP2GQ/YcdxlhzPJglbGfw==
X-Received: by 2002:adf:b18d:: with SMTP id q13mr2390326wra.256.1597917395332;
        Thu, 20 Aug 2020 02:56:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cc0:4e4e:f1a9:1745? ([2001:b07:6468:f312:1cc0:4e4e:f1a9:1745])
        by smtp.gmail.com with ESMTPSA id l11sm3087714wme.11.2020.08.20.02.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 02:56:34 -0700 (PDT)
Subject: Re: [PATCH 2/8] KVM: nSVM: rename nested 'vmcb' to vmcb_gpa in few
 places
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
 <20200820091327.197807-3-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f6bf9494-f337-2e53-6e6c-e0b8a847ec8d@redhat.com>
Date:   Thu, 20 Aug 2020 11:56:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200820091327.197807-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/08/20 11:13, Maxim Levitsky wrote:
> No functional changes.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 10 +++++-----
>  arch/x86/kvm/svm/svm.c    | 13 +++++++------
>  arch/x86/kvm/svm/svm.h    |  2 +-
>  3 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index fb68467e6049..d9755eab2199 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -431,7 +431,7 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>  {
>  	int ret;
>  
> -	svm->nested.vmcb = vmcb_gpa;
> +	svm->nested.vmcb_gpa = vmcb_gpa;
>  	load_nested_vmcb_control(svm, &nested_vmcb->control);
>  	nested_prepare_vmcb_save(svm, nested_vmcb);
>  	nested_prepare_vmcb_control(svm);
> @@ -568,7 +568,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	struct vmcb *vmcb = svm->vmcb;
>  	struct kvm_host_map map;
>  
> -	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb), &map);
> +	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb_gpa), &map);
>  	if (rc) {
>  		if (rc == -EINVAL)
>  			kvm_inject_gp(&svm->vcpu, 0);
> @@ -579,7 +579,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  
>  	/* Exit Guest-Mode */
>  	leave_guest_mode(&svm->vcpu);
> -	svm->nested.vmcb = 0;
> +	svm->nested.vmcb_gpa = 0;
>  	WARN_ON_ONCE(svm->nested.nested_run_pending);
>  
>  	/* in case we halted in L2 */
> @@ -1018,7 +1018,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
>  
>  	/* First fill in the header and copy it out.  */
>  	if (is_guest_mode(vcpu)) {
> -		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb;
> +		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb_gpa;
>  		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
>  		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
>  
> @@ -1128,7 +1128,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
>  	hsave->save = save;
>  
> -	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
> +	svm->nested.vmcb_gpa = kvm_state->hdr.svm.vmcb_pa;
>  	load_nested_vmcb_control(svm, &ctl);
>  	nested_prepare_vmcb_control(svm);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 562a79e3e63a..4338d2a2596e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1102,7 +1102,7 @@ static void init_vmcb(struct vcpu_svm *svm)
>  	}
>  	svm->asid_generation = 0;
>  
> -	svm->nested.vmcb = 0;
> +	svm->nested.vmcb_gpa = 0;
>  	svm->vcpu.arch.hflags = 0;
>  
>  	if (!kvm_pause_in_guest(svm->vcpu.kvm)) {
> @@ -3884,7 +3884,7 @@ static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>  		/* FED8h - SVM Guest */
>  		put_smstate(u64, smstate, 0x7ed8, 1);
>  		/* FEE0h - SVM Guest VMCB Physical Address */
> -		put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb);
> +		put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb_gpa);
>  
>  		svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
>  		svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
> @@ -3903,17 +3903,18 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  	struct vmcb *nested_vmcb;
>  	struct kvm_host_map map;
>  	u64 guest;
> -	u64 vmcb;
> +	u64 vmcb_gpa;
>  	int ret = 0;
>  
>  	guest = GET_SMSTATE(u64, smstate, 0x7ed8);
> -	vmcb = GET_SMSTATE(u64, smstate, 0x7ee0);
> +	vmcb_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
>  
>  	if (guest) {
> -		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb), &map) == -EINVAL)
> +		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map) == -EINVAL)
>  			return 1;
> +
>  		nested_vmcb = map.hva;
> -		ret = enter_svm_guest_mode(svm, vmcb, nested_vmcb);
> +		ret = enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb);
>  		kvm_vcpu_unmap(&svm->vcpu, &map, true);
>  	}
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index a798e1731709..03f2f082ef10 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -85,7 +85,7 @@ struct svm_nested_state {
>  	struct vmcb *hsave;
>  	u64 hsave_msr;
>  	u64 vm_cr_msr;
> -	u64 vmcb;
> +	u64 vmcb_gpa;
>  	u32 host_intercept_exceptions;
>  
>  	/* These are the merged vectors */
> 

Please use vmcb12_gpa, and svm->nested.vmcb12 for the VMCB in patch 6.

(You probably also what to have local variables named vmcb12 in patch 6
to avoid too-long lines).

Paolo

