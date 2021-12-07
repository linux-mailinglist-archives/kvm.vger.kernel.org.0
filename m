Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6C746C0C7
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234767AbhLGQiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhLGQiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 11:38:19 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ACDC061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 08:34:48 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so3163253pjb.1
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 08:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+yUBqxu9B4OCb5TwZ4H4vttXKxpedHDjwAf994pwiwA=;
        b=SoF2kONijeu1/oY0BHxa4NB2dILfWoPAKiLOn8+Okg9XuAkFRjWDXk5jtApKt7hUN7
         +T5EuZ+l2+uF0az6+5WrZnrEXUM38CJ4U30lTslEHU/FS5cKX/U9MEOH6oW72fOtfPOt
         l3OJ/QGD+l2WZnAgsS+e2RiCwQR6JAiQwDQaYK10BMzPRW+c05AGKWbEZ+tyjtF/DEL+
         D8t2ILMmwOCAqHzoXcCF6ghzrBkV6niB8IV30d0WwykMWa+3xX6rZXHpszC7taEmrnjI
         vljzlF1RGjOXQSdIEJsYR8IfAJkKSOoPl4weAbKiXjsNGCpnjS2O3Rju7zVCXLAcMVeK
         W/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+yUBqxu9B4OCb5TwZ4H4vttXKxpedHDjwAf994pwiwA=;
        b=X2DQkuNC33gCzF2KqU7wPdjZHroKMJ8q0RApXl3UTCtmKRRc/ToUmFqtqFCudNonW7
         VJN4Y+RCmWhONAnXS+Uz6dIlZYgkUXw61BxG1cL+r98iC24wxzXQlDn3JvLjFf/GA2qV
         pTp6EmRsHko9YAyEwYv005yoBIS2kPXJWFxI377n6LVTqLlhOUn61OBJyQUGaTY3TALu
         bfNf5TsyhxQjBlGhKpgv8QXj2uAT6Tx12OjZHWW7Ur2ASg+IsNkVUIaRr7zksGErKv9g
         qKWieQuglajfWuSRyf9iOE4nnVn4BzD7s+aUNpQAdbGEvufZDxYAkXVZSZEbkOqVnx4y
         yh6Q==
X-Gm-Message-State: AOAM533R2YLs2fbRRzDNrEQEqoT5YncmCKDx3YgrNksDBGK7oIEOg3j4
        Lk8wZ99OmwfCwDdyU1/9KjuDww==
X-Google-Smtp-Source: ABdhPJyG4cYzUuiyRbDHCDGh5vaEieF+gNeJKctz5okJuJvgGTmNH4Mmzz/alr9l4aoIB5oHNuDG2A==
X-Received: by 2002:a17:90b:e83:: with SMTP id fv3mr67275pjb.115.1638894888012;
        Tue, 07 Dec 2021 08:34:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j22sm166712pfj.130.2021.12.07.08.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 08:34:46 -0800 (PST)
Date:   Tue, 7 Dec 2021 16:34:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Marc Orr <marcorr@google.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Always set kvm_run->if_flag
Message-ID: <Ya+NIxO5pIkB8057@google.com>
References: <20211207043100.3357474-1-marcorr@google.com>
 <c8889028-9c4e-cade-31b6-ea92a32e4f66@amd.com>
 <CAA03e5E7-ns7w9B9Tu7pSWzCo0Nh7Ba5jwQXcn_XYPf_reRq9Q@mail.gmail.com>
 <5e69c0ca-389c-3ace-7559-edd901a0ab3c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e69c0ca-389c-3ace-7559-edd901a0ab3c@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07, 2021, Tom Lendacky wrote:
> On 12/7/21 9:14 AM, Marc Orr wrote:
> > On Tue, Dec 7, 2021 at 6:43 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> > > > +static bool svm_get_if_flag(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +     struct vmcb *vmcb = to_svm(vcpu)->vmcb;
> > > > +
> > > > +     return !!(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK);
> > > 
> > > I'm not sure if this is always valid to use for non SEV-ES guests. Maybe
> > > the better thing would be:
> > > 
> > >          return sev_es_guest(vcpu->kvm) ? vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK
> > >                                         : kvm_get_rflags(vcpu) & X86_EFLAGS_IF;
> > > 
> > > (Since this function returns a bool, I don't think you need the !!)
> > 
> > I had the same reservations when writing the patch. (Why fix what's
> > not broken.) The reason I wrote the patch this way is based on what I
> > read in APM vol2: Appendix B Layout of VMCB: "GUEST_INTERRUPT_MASK -
> > Value of the RFLAGS.IF bit for the guest."
> 
> I just verified with the hardware team that this flag is indeed only set for
> a guest with protected state (SEV-ES / SEV-SNP). An update to the APM will
> be made.

svm_interrupt_blocked() should be modified to use the new svm_get_if_flag()
helper so that the SEV-{ES,SN} behavior is contained in a single location, e.g.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 208566f63bce..fef04e9fa9c9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3583,14 +3583,10 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
        if (!gif_set(svm))
                return true;

-       if (sev_es_guest(vcpu->kvm)) {
-               /*
-                * SEV-ES guests to not expose RFLAGS. Use the VMCB interrupt mask
-                * bit to determine the state of the IF flag.
-                */
-               if (!(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK))
+       if (!is_guest_mode(vcpu)) {
+               if (!svm_get_if_flag(vcpu))
                        return true;
-       } else if (is_guest_mode(vcpu)) {
+       } else {
                /* As long as interrupts are being delivered...  */
                if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
                    ? !(svm->vmcb01.ptr->save.rflags & X86_EFLAGS_IF)
@@ -3600,9 +3596,6 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
                /* ... vmexits aren't blocked by the interrupt shadow  */
                if (nested_exit_on_intr(svm))
                        return false;
-       } else {
-               if (!(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
-                       return true;
        }

        return (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK);
