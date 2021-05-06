Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B213375CE9
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 23:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhEFVgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 17:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhEFVgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 17:36:50 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864E3C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 14:35:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ge1so4038868pjb.2
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 14:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vGt5fq/VbIvKdhwcKa6L6+aszV+sn4e2pns0C3/0YNo=;
        b=JLQGatvVwavMSrgviIjN2ntbVpm4c4jygPwYaUqYpihmwazl0EQieEpUKgTaAtIXtU
         vYTpEpWo9EOnOKCgRy5vjzD3aVB8w7dus8nGidaOlFqXbll78ltea0+EVW2iMAhj+/al
         fr97C7Pppi+FcTvNPrCUsbdh0mSuB1Cb9bz2O18aC5MllyIxvSW7vOwvi/aD8WGLkCuU
         fJkOFSJxJRY7C5DV6mQs/HF1VXdPLo19Qhy5+LaGQvXtRn4tYtdv2IuUWrGFBGR41lr8
         KhppeO+WlYfcOSfwWL4eLW0RWXfLU7G3RrDMsIKqA7SCDYHxDir/48yOVXXusQ4g0xBz
         LMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vGt5fq/VbIvKdhwcKa6L6+aszV+sn4e2pns0C3/0YNo=;
        b=qjym0NPJ8P1JV0/HifiFX3V+KpIACIi99V0kAIw4HWb3nxaYYQCFN30uI6WnjTyomO
         jv+ItjuHVdb2tmqJuBYzradPJ/+hqO4V92Azh+3l66yZheqPRtP4VDCMVFygiLZaQ/0V
         nGKYUolkyhgVk0fXwJDe9hULiTk2EzS2ag/IbxoOtWLqEz+wjYoLfDrsSbKTI1fiWy2H
         YwzjPvdkARA5JzNlvSsj4LC7m4w5b29s9T8aZdtvPBS5zmv35HyrUX51Bpsl0ZS0PW85
         SlIchbec8QgEwkj9uEvy4ZHZvB/qwhEubluJdfokQeD3J9CGz8QJzcXLBXttuN7EzWsZ
         3H9g==
X-Gm-Message-State: AOAM532AXKlf+3k0v1vKjqTBbc8LPq+b9myngQKddidhps4plhSgvfnp
        5+XFrNmCZSCFNQlRnBhWR3WEVw==
X-Google-Smtp-Source: ABdhPJxnC8LYIlNvIA+dwrytdxlQN0rSyMfVzHhxHGjt3ps11KC7nls5ppclMW0tuQWVYJpFfzaYBw==
X-Received: by 2002:a17:903:3091:b029:ee:ef64:c389 with SMTP id u17-20020a1709033091b02900eeef64c389mr6727995plc.74.1620336950933;
        Thu, 06 May 2021 14:35:50 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id j10sm2955789pfn.207.2021.05.06.14.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 14:35:50 -0700 (PDT)
Date:   Thu, 6 May 2021 21:35:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 2/2 V2] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <YJRhMrxTrSDClwbQ@google.com>
References: <20210506185732.609010123@redhat.com>
 <20210506190419.481236922@redhat.com>
 <20210506192125.GA350334@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506192125.GA350334@fuller.cnet>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021, Marcelo Tosatti wrote:
> Index: kvm/arch/x86/kvm/vmx/posted_intr.c
> ===================================================================
> --- kvm.orig/arch/x86/kvm/vmx/posted_intr.c
> +++ kvm/arch/x86/kvm/vmx/posted_intr.c
> @@ -114,7 +114,7 @@ static void __pi_post_block(struct kvm_v
>  	} while (cmpxchg64(&pi_desc->control, old.control,
>  			   new.control) != old.control);
>  
> -	if (!WARN_ON_ONCE(vcpu->pre_pcpu == -1)) {
> +	if (vcpu->pre_pcpu != -1) {
>  		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
>  		list_del(&vcpu->blocked_vcpu_list);
>  		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> @@ -135,20 +135,13 @@ static void __pi_post_block(struct kvm_v
>   *   this case, return 1, otherwise, return 0.
>   *
>   */
> -int pi_pre_block(struct kvm_vcpu *vcpu)
> +static int __pi_pre_block(struct kvm_vcpu *vcpu)
>  {
>  	unsigned int dest;
>  	struct pi_desc old, new;
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  
> -	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
> -		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
> -		!kvm_vcpu_apicv_active(vcpu))
> -		return 0;
> -
> -	WARN_ON(irqs_disabled());
> -	local_irq_disable();
> -	if (!WARN_ON_ONCE(vcpu->pre_pcpu != -1)) {
> +	if (vcpu->pre_pcpu == -1) {
>  		vcpu->pre_pcpu = vcpu->cpu;
>  		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
>  		list_add_tail(&vcpu->blocked_vcpu_list,
> @@ -188,12 +181,33 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  	if (pi_test_on(pi_desc) == 1)
>  		__pi_post_block(vcpu);
>  
> +	return (vcpu->pre_pcpu == -1);

Nothing checks the return of __pi_pre_block(), this can be dropped and the
helper can be a void return.

> +}
> +
> +int pi_pre_block(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	vmx->in_blocked_section = true;
> +
> +	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
> +		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
> +		!kvm_vcpu_apicv_active(vcpu))

Opportunistically fix the indentation?

> +		return 0;
> +
> +	WARN_ON(irqs_disabled());
> +	local_irq_disable();
> +	__pi_pre_block(vcpu);
>  	local_irq_enable();
> +
>  	return (vcpu->pre_pcpu == -1);
>  }
>  
>  void pi_post_block(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	vmx->in_blocked_section = false;
>  	if (vcpu->pre_pcpu == -1)
>  		return;
>  
> @@ -236,6 +250,52 @@ bool pi_has_pending_interrupt(struct kvm
>  		(pi_test_sn(pi_desc) && !pi_is_pir_empty(pi_desc));
>  }
>  
> +static void pi_update_wakeup_vector(void *data)
> +{
> +	struct vcpu_vmx *vmx;
> +	struct kvm_vcpu *vcpu = data;
> +
> +	vmx = to_vmx(vcpu);
> +
> +	/* race with pi_post_block ? */
> +	if (vcpu->pre_pcpu != -1)

This seems wrong.  The funky code in __pi_pre_block() regarding pre_cpu muddies
the waters, but I don't think it's safe to call __pi_pre_block() from a pCPU
other than the pCPU that is associated with the vCPU.

If the vCPU is migrated after vmx_pi_start_assignment() grabs vcpu->cpu but
before the IPI arrives (to run pi_update_wakeup_vector()), then it's possible
that a different pCPU could be running __pi_pre_block() concurrently with this
code.  If that happens, both pcPUs could see "vcpu->pre_cpu == -1" and corrupt
the list due to a double list_add_tail.

The existing code is unnecessarily confusing, but unless I'm missing something,
it's guaranteed to call pi_pre_block() from the pCPU that is associated with the
pCPU, i.e. arguably it could/should use this_cpu_ptr().  Because the existing
code grabs vcpu->cpu with IRQs disabled and is called only from KVM_RUN,
vcpu->cpu is guaranteed to match the current pCPU since vcpu->cpu will be set to
the current pCPU when the vCPU is scheduled in.

Assuming my analysis is correct (definitely not guaranteed), I'm struggling to
come up with an elegant solution.  But, do we need an elegant solution?  E.g.
can the start_assignment() hook simply kick all vCPUs with APICv active?

> +		return;
> +
> +	if (!vmx->in_blocked_section)
> +		return;
> +
> +	__pi_pre_block(vcpu);
> +}
> +
> +void vmx_pi_start_assignment(struct kvm *kvm, int device_count)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	if (!irq_remapping_cap(IRQ_POSTING_CAP))
> +		return;
> +
> +	/* only care about first device assignment */
> +	if (device_count != 1)
> +		return;
> +
> +	/* Update wakeup vector and add vcpu to blocked_vcpu_list */
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		struct vcpu_vmx *vmx = to_vmx(vcpu);
> +		int pcpu;
> +
> +		if (!kvm_vcpu_apicv_active(vcpu))
> +			continue;
> +
> +		preempt_disable();

Any reason not to do "cpu = get_cpu()"?  Might make sense to do that outside of
the for-loop, too.

> +		pcpu = vcpu->cpu;
> +		if (vmx->in_blocked_section && vcpu->pre_pcpu == -1 &&
> +		    pcpu != -1 && pcpu != smp_processor_id())
> +			smp_call_function_single(pcpu, pi_update_wakeup_vector,
> +						 vcpu, 1);
> +		preempt_enable();
> +	}
> +}
