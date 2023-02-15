Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C0D698806
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 23:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjBOWnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 17:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjBOWnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 17:43:12 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AED23DAA
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 14:43:10 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a9-20020a25af09000000b0083fa6f15c2fso48127ybh.16
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 14:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cVqwUoC4GP/fOMjS8mr++nAU4yxunp7mbNFnyq/qIn8=;
        b=iIQH/g0b9xgWNpEM6kDdNbbbMfOVqoYx/50hTtksPVkvnVRWPK7N0Y54z76+I3ZgJN
         kCEvQctXT2mnhEECw8xbCZHPuyFDILI8siKAD74DW7FkmmhXgCU9ADG3TTWw6xkYE77A
         goF2OUeCaEETnV9f8G/epYW/sBvbXrfkwq7b13CrKfaoWmfbcZx/rVxZ2V8JqAf/2H0Y
         9fuZgtNgbEckfnHGaNJuKsaYxxjiY5ZFG+xelAc07oClxPO6YMZ3Ks7ni6geqCByrjST
         Av1+wyqR+tCscDA8kq7Cn8kBMjAp70iHz8UwRi/FwQmpvnko1remy0ZXg5KhpDd3Q5TM
         zsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cVqwUoC4GP/fOMjS8mr++nAU4yxunp7mbNFnyq/qIn8=;
        b=Xeo/+5dHs5FJCi0wC9bcglcw2Cmz70sLorAyTAFqPwjRjsw4iRJ0CTGlQol/poH50g
         vZzQrFXNMsCtccnVBtphFYncQIlMfT3nRWOn9NBY+Aka+MsZ0prtThItkN7NaiSc2ti8
         iU7VjojP6f3Ltsqwn3oHzxTPqOD8Lv5A4FFKZTTJS3T4TGrxUDg55zZs4xpleXrwieIU
         Ph7GWvUqXygbginKZsDNBUvXO0reLO7Y+rG007vUzy2RZyNP5A0dkJtOa523IUQ5/NfN
         1s47j2VHmAXwwbFn+XNYeX17fSTWe0RaeVti4evgi69pETRfPb/6EceVAC1bI1BUmdPw
         6+hw==
X-Gm-Message-State: AO0yUKWGIIcXD1wmRgjrHfcaqQDh1fcGL7ouyg0Xq4foDx5KAoPWLqUo
        j892+F0+zNPfKwcY7EuprRurVV7U8Zc=
X-Google-Smtp-Source: AK7set83BDwMNOrgS6ktEvYsmjAck1AxlN4mXYwbgpbE0KOH/4yoO6GQe2EpHX2G0ere3dR6hGktDR/8Jpk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae5f:0:b0:52f:daf9:66af with SMTP id
 g31-20020a81ae5f000000b0052fdaf966afmr5ywk.6.1676500989866; Wed, 15 Feb 2023
 14:43:09 -0800 (PST)
Date:   Wed, 15 Feb 2023 14:43:08 -0800
In-Reply-To: <2b5994e2-15ba-dd57-285c-fb33827a5275@amd.com>
Mime-Version: 1.0
References: <20221129193717.513824-1-mlevitsk@redhat.com> <20221129193717.513824-8-mlevitsk@redhat.com>
 <Y9mWFlGdzoa8ZDW7@google.com> <a59505b3-5405-0409-bbf1-34466932c2c1@amd.com>
 <Y+PIdJZtCsGH2Sw3@google.com> <2b5994e2-15ba-dd57-285c-fb33827a5275@amd.com>
Message-ID: <Y+1f/En6rvqoe6st@google.com>
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection interface
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023, Santosh Shukla wrote:
> On 2/8/2023 9:36 PM, Sean Christopherson wrote:
> > On Wed, Feb 08, 2023, Santosh Shukla wrote:
> >> On 2/1/2023 3:58 AM, Sean Christopherson wrote:
> >>> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> >>>> @@ -5191,9 +5191,12 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
> >>>>  
> >>>>  	vcpu->arch.nmi_injected = events->nmi.injected;
> >>>>  	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
> >>>> -		vcpu->arch.nmi_pending = events->nmi.pending;
> >>>> +		atomic_add(events->nmi.pending, &vcpu->arch.nmi_queued);
> >>>> +
> >>>>  	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
> >>>>  
> >>>> +	process_nmi(vcpu);
> >>>
> >>> Argh, having two process_nmi() calls is ugly (not blaming your code, it's KVM's
> >>> ABI that's ugly).  E.g. if we collapse this down, it becomes:
> >>>
> >>> 	process_nmi(vcpu);
> >>>
> >>> 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
> >>> 		<blah blah blah>
> >>> 	}
> >>> 	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
> >>>
> >>> 	process_nmi(vcpu);
> >>>
> >>> And the second mess is that V_NMI needs to be cleared.
> >>>
> >>
> >> Can you please elaborate on "V_NMI cleared" scenario? Are you mentioning
> >> about V_NMI_MASK or svm->nmi_masked?
> > 
> > V_NMI_MASK.  KVM needs to purge any pending virtual NMIs when userspace sets
> > vCPU event state and KVM_VCPUEVENT_VALID_NMI_PENDING is set.
> > 
> 
> As per the APM: V_NMI_MASK is managed by the processor

Heh, we're running afoul over KVM's bad terminology conflicting with the APM's
terminology.  By V_NMI_MASK, I meant "KVM's V_NMI_MASK", a.k.a. the flag that says
whether or there's a pending NMI.


However...

> "
> V_NMI_MASK: Indicates whether virtual NMIs are masked. The processor will set V_NMI_MASK
> once it takes the virtual NMI. V_NMI_MASK is cleared when the guest successfully completes an
> IRET instruction or #VMEXIT occurs while delivering the virtual NMI
> "
>
> In my initial implementation I had changed V_NMI_MASK for the SMM scenario [1],
> This is also not required as HW will save the V_NMI/V_NMI_MASK on 
> SMM entry and restore them on RSM.
> 
> That said the svm_{get,set}_nmi_mask will look something like:
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a9e9bfbffd72..08911a33cf1e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3635,13 +3635,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> 
>  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
>  {
> -       return to_svm(vcpu)->nmi_masked;
> +       struct vcpu_svm *svm = to_svm(vcpu);
> +
> +       if (is_vnmi_enabled(svm))
> +               return svm->vmcb->control.int_ctl & V_NMI_MASK;
> +       else
> +               return svm->nmi_masked;
>  }
> 
>  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> 
> +       if (is_vnmi_enabled(svm))
> +               return;
> +
>         if (masked) {
>                 svm->nmi_masked = true;
>                 svm_set_iret_intercept(svm);
> 
> is there any inputs on above approach?

What happens if software clears the "NMIs are blocked" flag?  If KVM can't clear
the flag, then we've got problems.  E.g. if KVM emulates IRET or SMI+RSM.  And I
I believe there are use cases that use KVM to snapshot and reload vCPU state,
e.g. record+replay?, in which case KVM_SET_VCPU_EVENTS needs to be able to adjust
NMI blocking too.

> On top of the above, I am including your suggested change as below...
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0855599df65..437a6cea3bc7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5201,9 +5201,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
> 
>         vcpu->arch.nmi_injected = events->nmi.injected;
>         if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
> -               vcpu->arch.nmi_pending = events->nmi.pending;
> -               if (vcpu->arch.nmi_pending)
> -                       kvm_make_request(KVM_REQ_NMI, vcpu);
> +               vcpu->arch.nmi_pending = 0;
> +               atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
> +               kvm_make_request(KVM_REQ_NMI, vcpu);
>         }
>         static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
> 
> does that make sense?

Yep!
