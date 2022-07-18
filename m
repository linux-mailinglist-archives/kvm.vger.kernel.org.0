Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A3957831F
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 15:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbiGRNFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 09:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235275AbiGRNFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 09:05:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44F0B27B05
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 06:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658149533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TT6pUBRi6JqyBvxc8wKLIkreog5y7xrjcrt1g51AiQA=;
        b=FlouCJ6KGSVAuJIIW14jWmvtY81TWPb4BgkoFTiK/6rjvwAffripxg3/T50ZoPhZdfxmIs
        Xf5RhAVyVUn1Z8QbBX9HOSdhRsb9PRMOzUIBXLqu9tqYPVXAdpSLajlZ0wzTHgvOuP8KeL
        iesVFIFHMBCXqHSSRXdEARx1/43ShsI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-Kg6gf-mCOzyidQ-YCJ15Mw-1; Mon, 18 Jul 2022 09:05:32 -0400
X-MC-Unique: Kg6gf-mCOzyidQ-YCJ15Mw-1
Received: by mail-qk1-f199.google.com with SMTP id de4-20020a05620a370400b006a9711bd9f8so9273977qkb.9
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 06:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=TT6pUBRi6JqyBvxc8wKLIkreog5y7xrjcrt1g51AiQA=;
        b=xWCTP/AJ5ihkTsq1CsB3SemlzJ0sbMnHWZl3F/rUkqBVstbocgLg/fpjF6Igjq5c2N
         kQJULH8otAfvNOMiFjcmWw9V2/SNKwPMCIJWNhOUljG/+wxuWiUhIn8Fa6KwnJKX9fqW
         oUrE2siA+lbC+21tIFZdN+w8WlBrM5pxKFNigFf34OhtPhufIt/0cDmlhbL+mCHM8x9Z
         TnZwNWNb8xdaIpZ89Tvd1ZLK0QVygcPmDjztBmFtQzMqQtPT25Au110rJ1DbLXx2khRd
         JGEJVZn76QwY/xhJAvn7+aODP8MhX8QaXGLMBPSD0F0c7RRdgWfMJhhhXnYNl2PMP1Rx
         63iA==
X-Gm-Message-State: AJIora8/3u5cw+lHS0eFRGQ6mIzVFaEFDWWryyDjZp7QXWQ1UeTGqowz
        tno2U/uiOVWayqT/fFpsCDvy5f1FiIfdet9zOGZjIE9HW8jJ8Ct/dbEN5CSSMCzxz1HWUbzpWGf
        S9g3ELjN3IsGy
X-Received: by 2002:a0c:df0c:0:b0:472:fbf6:7ab4 with SMTP id g12-20020a0cdf0c000000b00472fbf67ab4mr20418083qvl.30.1658149531410;
        Mon, 18 Jul 2022 06:05:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vG2Trc9NCaNNRnQ7OpQQmQNw/vRZ0z52+FvP6VWZpg+aQtqTyQlo14tvlKJJtzNIn0a7VyMQ==
X-Received: by 2002:a0c:df0c:0:b0:472:fbf6:7ab4 with SMTP id g12-20020a0cdf0c000000b00472fbf67ab4mr20418052qvl.30.1658149531078;
        Mon, 18 Jul 2022 06:05:31 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id v2-20020a05620a440200b006b5da3c8d81sm6715817qkp.73.2022.07.18.06.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 06:05:30 -0700 (PDT)
Message-ID: <332546d06ea1f93f57cc9052f848517a20a5cbf6.camel@redhat.com>
Subject: Re: [PATCH v2 22/24] KVM: x86: Rename inject_pending_events() to
 kvm_check_and_inject_events()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Mon, 18 Jul 2022 16:05:27 +0300
In-Reply-To: <20220715204226.3655170-23-seanjc@google.com>
References: <20220715204226.3655170-1-seanjc@google.com>
         <20220715204226.3655170-23-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-15 at 20:42 +0000, Sean Christopherson wrote:
> Rename inject_pending_events() to kvm_check_and_inject_events() in order
> to capture the fact that it handles more than just pending events, and to
> (mostly) align with kvm_check_nested_events(), which omits the "inject"
> for brevity.
> 
> Add a comment above kvm_check_and_inject_events() to provide a high-level
> synopsis, and to document a virtualization hole (KVM erratum if you will)
> that exists due to KVM not strictly tracking instruction boundaries with
> respect to coincident instruction restarts and asynchronous events.
> 
> No functional change inteded.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/nested.c |  2 +-
>  arch/x86/kvm/svm/svm.c    |  2 +-
>  arch/x86/kvm/x86.c        | 46 ++++++++++++++++++++++++++++++++++++---
>  3 files changed, 45 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 0a8ee5f28319..028e180a74b6 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1310,7 +1310,7 @@ static void nested_svm_inject_exception_vmexit(struct kvm_vcpu *vcpu)
>                 else
>                         vmcb->control.exit_info_2 = vcpu->arch.cr2;
>         } else if (ex->vector == DB_VECTOR) {
> -               /* See inject_pending_event.  */
> +               /* See kvm_check_and_inject_events().  */
>                 kvm_deliver_exception_payload(vcpu, ex);
>  
>                 if (vcpu->arch.dr7 & DR7_GD) {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a336517b563e..95bdf127d531 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3518,7 +3518,7 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
>  
>         /* Note, this is called iff the local APIC is in-kernel. */
>         if (!READ_ONCE(vcpu->arch.apic->apicv_active)) {
> -               /* Process the interrupt via inject_pending_event */
> +               /* Process the interrupt via kvm_check_and_inject_events(). */
>                 kvm_make_request(KVM_REQ_EVENT, vcpu);
>                 kvm_vcpu_kick(vcpu);
>                 return;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b924afb76b72..69b9725beff3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9691,7 +9691,47 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>         static_call(kvm_x86_inject_exception)(vcpu);
>  }
>  
> -static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
> +/*
> + * Check for any event (interrupt or exception) that is ready to be injected,
> + * and if there is at least one event, inject the event with the highest
> + * priority.  This handles both "pending" events, i.e. events that have never
> + * been injected into the guest, and "injected" events, i.e. events that were
> + * injected as part of a previous VM-Enter, but weren't successfully delivered
> + * and need to be re-injected.
> + *
> + * Note, this is not guaranteed to be invoked on a guest instruction boundary,
> + * i.e. doesn't guarantee that there's an event window in the guest.  KVM must
> + * be able to inject exceptions in the "middle" of an instruction, and so must
> + * also be able to re-inject NMIs and IRQs in the middle of an instruction.
> + * I.e. for exceptions and re-injected events, NOT invoking this on instruction
> + * boundaries is necessary and correct.
> + *
> + * For simplicity, KVM uses a single path to inject all events (except events
> + * that are injected directly from L1 to L2) and doesn't explicitly track
> + * instruction boundaries for asynchronous events.  However, because VM-Exits
> + * that can occur during instruction execution typically result in KVM skipping
> + * the instruction or injecting an exception, e.g. instruction and exception
> + * intercepts, and because pending exceptions have higher priority than pending
> + * interrupts, KVM still honors instruction boundaries in most scenarios.
> + *
> + * But, if a VM-Exit occurs during instruction execution, and KVM does NOT skip
> + * the instruction or inject an exception, then KVM can incorrecty inject a new
> + * asynchrounous event if the event became pending after the CPU fetched the
> + * instruction (in the guest).  E.g. if a page fault (#PF, #NPF, EPT violation)
> + * occurs and is resolved by KVM, a coincident NMI, SMI, IRQ, etc... can be
> + * injected on the restarted instruction instead of being deferred until the
> + * instruction completes.
> + *
> + * In practice, this virtualization hole is unlikely to be observed by the
> + * guest, and even less likely to cause functional problems.  To detect the
> + * hole, the guest would have to trigger an event on a side effect of an early
> + * phase of instruction execution, e.g. on the instruction fetch from memory.
> + * And for it to be a functional problem, the guest would need to depend on the
> + * ordering between that side effect, the instruction completing, _and_ the
> + * delivery of the asynchronous event.
> + */
> +static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
> +                                      bool *req_immediate_exit)
>  {
>         bool can_inject;
>         int r;
> @@ -10170,7 +10210,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>          * When APICv gets disabled, we may still have injected interrupts
>          * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
>          * still active when the interrupt got accepted. Make sure
> -        * inject_pending_event() is called to check for that.
> +        * kvm_check_and_inject_events() is called to check for that.
>          */
>         if (!apic->apicv_active)
>                 kvm_make_request(KVM_REQ_EVENT, vcpu);
> @@ -10467,7 +10507,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>                         goto out;
>                 }
>  
> -               r = inject_pending_event(vcpu, &req_immediate_exit);
> +               r = kvm_check_and_inject_events(vcpu, &req_immediate_exit);
>                 if (r < 0) {
>                         r = 0;
>                         goto out;


Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

