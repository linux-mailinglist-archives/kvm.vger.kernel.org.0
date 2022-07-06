Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281E05687A4
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 14:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiGFMBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 08:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiGFMBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 08:01:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D443D29CA3
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 05:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657108874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5rxgRIlc26WNHWaoNLQ6Hnbum8yB1/XyJMF801iPWnQ=;
        b=GyYmM8TqeVZYmIkIZB8UwQvrOxCqCJ+SZRsABxp+BnjuTIBwBSS38u9qqMSPtTv3wCpWAh
        KFiPejO+/9zOMsE0Z8lPm3eiOVqAB4Hycq+2g4bgDv711p5NrCLXkPQnd0keKz6U/qjlvP
        Y+cQusBz1gGP0B0DA7VaUHKWIjP/w9I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-FdlyKLYoM-aF2LHuHQT2yg-1; Wed, 06 Jul 2022 08:01:09 -0400
X-MC-Unique: FdlyKLYoM-aF2LHuHQT2yg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32D833C10160;
        Wed,  6 Jul 2022 12:01:09 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C29CC2026D64;
        Wed,  6 Jul 2022 12:01:05 +0000 (UTC)
Message-ID: <4996a544a54f0bf7657981c2440b9ce8f0deaf3d.camel@redhat.com>
Subject: Re: [PATCH v2 11/21] KVM: x86: Rename kvm_x86_ops.queue_exception
 to inject_exception
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 15:01:04 +0300
In-Reply-To: <20220614204730.3359543-12-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-12-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Rename the kvm_x86_ops hook for exception injection to better reflect
> reality, and to align with pretty much every other related function name
> in KVM.

100% True.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 2 +-
>  arch/x86/include/asm/kvm_host.h    | 2 +-
>  arch/x86/kvm/svm/svm.c             | 4 ++--
>  arch/x86/kvm/vmx/vmx.c             | 4 ++--
>  arch/x86/kvm/x86.c                 | 2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 6f2f1affbb78..a42e2d9b04fe 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -67,7 +67,7 @@ KVM_X86_OP(get_interrupt_shadow)
>  KVM_X86_OP(patch_hypercall)
>  KVM_X86_OP(inject_irq)
>  KVM_X86_OP(inject_nmi)
> -KVM_X86_OP(queue_exception)
> +KVM_X86_OP(inject_exception)
>  KVM_X86_OP(cancel_injection)
>  KVM_X86_OP(interrupt_allowed)
>  KVM_X86_OP(nmi_allowed)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7e98b2876380..16a7f91cdf75 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1505,7 +1505,7 @@ struct kvm_x86_ops {
>  				unsigned char *hypercall_addr);
>  	void (*inject_irq)(struct kvm_vcpu *vcpu, bool reinjected);
>  	void (*inject_nmi)(struct kvm_vcpu *vcpu);
> -	void (*queue_exception)(struct kvm_vcpu *vcpu);
> +	void (*inject_exception)(struct kvm_vcpu *vcpu);
>  	void (*cancel_injection)(struct kvm_vcpu *vcpu);
>  	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
>  	int (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c6cca0ce127b..ca39f76ca44b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -430,7 +430,7 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -static void svm_queue_exception(struct kvm_vcpu *vcpu)
> +static void svm_inject_exception(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	unsigned nr = vcpu->arch.exception.nr;
> @@ -4761,7 +4761,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.patch_hypercall = svm_patch_hypercall,
>  	.inject_irq = svm_inject_irq,
>  	.inject_nmi = svm_inject_nmi,
> -	.queue_exception = svm_queue_exception,
> +	.inject_exception = svm_inject_exception,
>  	.cancel_injection = svm_cancel_injection,
>  	.interrupt_allowed = svm_interrupt_allowed,
>  	.nmi_allowed = svm_nmi_allowed,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ec98992024e2..26b863c78a9f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1610,7 +1610,7 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
>  		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
>  }
>  
> -static void vmx_queue_exception(struct kvm_vcpu *vcpu)
> +static void vmx_inject_exception(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned nr = vcpu->arch.exception.nr;
> @@ -7993,7 +7993,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.patch_hypercall = vmx_patch_hypercall,
>  	.inject_irq = vmx_inject_irq,
>  	.inject_nmi = vmx_inject_nmi,
> -	.queue_exception = vmx_queue_exception,
> +	.inject_exception = vmx_inject_exception,
>  	.cancel_injection = vmx_cancel_injection,
>  	.interrupt_allowed = vmx_interrupt_allowed,
>  	.nmi_allowed = vmx_nmi_allowed,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7c3ce601bdcc..b63421d511c5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9504,7 +9504,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  
>  	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
>  		vcpu->arch.exception.error_code = false;
> -	static_call(kvm_x86_queue_exception)(vcpu);
> +	static_call(kvm_x86_inject_exception)(vcpu);
>  }
>  
>  static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky <mlevitsk@redhat.com>




