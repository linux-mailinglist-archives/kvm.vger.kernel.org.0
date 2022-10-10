Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE30D5FA8A6
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 01:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiJJXeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 19:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJJXea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 19:34:30 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317BB6C131
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 16:34:29 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id c17-20020a4aa4d1000000b0047653e7c5f3so8994246oom.1
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 16:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lOqAyZOzBF3eXYVU4FMMb7A7+c/j/UW4I1s6np091/Q=;
        b=lIQ1ypsXpIZqSHGMy/ktHI9iS4dNHT3I0eAf2ZuZIm1TBMGW0O1bD4//4N+qIrVrKc
         kLp1ChUSjr9p6ERtwVqMBi+ESc4GLyY2/9f4vGPWAXn0Y3U+83LU3Up0s6Y+DNHoT4eE
         BHvzqd2e9EsPW6XiW6pUEmGbQ2xn4AbP08zfxUmzGTOalCbJaPQqoAfpOdcA9hBZR8B0
         pM6lAk3qNoe2/Q3+NlEdpzNs5ze9i8FpkdS2aLHDWktpTjIVv6kCwGF+Q9pVPE3oyYXI
         w8HmbJNW4EV48XXFEW8w1GWBUxd4sRCh+Ao6OBkmD2yKdIdIZH26+rwVlE4hmSdfGSqn
         Hj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lOqAyZOzBF3eXYVU4FMMb7A7+c/j/UW4I1s6np091/Q=;
        b=z8iu5v2CuZkpL7riQUqzVSjDDDfs5xw9TyZoW05D8yuXZ5B1pH2jZK7Fa0Z+J1BWw+
         8SLh2ac3tLvUFX9QYpKdP1SRHr4Z/lV1ttGeo79KAmC/bMcAS4ERbJv6axxgF4AE+xEQ
         J0M948pNcB9pRE/Y7Oy08CYmIK3HWOTQGXrDVYj8vuamR7V6eYUocWJmUJJVRprYRHyf
         3pjCQxQ+czIepSj0GcklHc+35NbAjN4fWpNIKIoyQ7jTaz2BCOoC+stJoXNF9PPP5Luk
         OBIgnQBz4++voH+RK5KKK+DZODLY/d3DFxdbEIs0a2xmoMRGG0o5EtdmOxpt7OeYQwNF
         PLng==
X-Gm-Message-State: ACrzQf2AzDkFKJwCd8jyvWiWhnYbXAPBe741OT6wYRmRmkmOuMOLo1Ow
        krk5X5zRE1hJLg0PJT3uU27dsGY00FiWakTk3zcTxw==
X-Google-Smtp-Source: AMsMyM4rueZTsZa6zpbPCdyfaSvGeWyYXX5FHdK95zC3hGJfhOBTk9n+iNP9/quQLfLyRj+lUWupakkrITo/8UcTeG8=
X-Received: by 2002:a9d:6296:0:b0:656:761:28bc with SMTP id
 x22-20020a9d6296000000b00656076128bcmr9199412otk.14.1665444868239; Mon, 10
 Oct 2022 16:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220928235351.1668844-1-jmattson@google.com> <20220928235351.1668844-2-jmattson@google.com>
 <CALMp9eRRgw=SBMTY=LtBG6zPRt4Swk_0kW4NdeTS=zVeV+UbQg@mail.gmail.com> <Yz90B/mdrOLO2nyl@google.com>
In-Reply-To: <Yz90B/mdrOLO2nyl@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 10 Oct 2022 16:34:17 -0700
Message-ID: <CALMp9eROYwaB45YmH7NDukzzNvoJH3MAR9WvU2CkPen1eCwggA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Execute IBPB on emulated VM-exit when guest
 has IBRS
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 6, 2022 at 5:35 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Oct 06, 2022, Jim Mattson wrote:
> > On Wed, Sep 28, 2022 at 4:53 PM Jim Mattson <jmattson@google.com> wrote:
> > >
> > > According to Intel's document on Indirect Branch Restricted
> > > Speculation, "Enabling IBRS does not prevent software from controlling
> > > the predicted targets of indirect branches of unrelated software
> > > executed later at the same predictor mode (for example, between two
> > > different user applications, or two different virtual machines). Such
> > > isolation can be ensured through use of the Indirect Branch Predictor
> > > Barrier (IBPB) command." This applies to both basic and enhanced IBRS.
> > >
> > > Since L1 and L2 VMs share hardware predictor modes (guest-user and
> > > guest-kernel), hardware IBRS is not sufficient to virtualize
> > > IBRS. (The way that basic IBRS is implemented on pre-eIBRS parts,
> > > hardware IBRS is actually sufficient in practice, even though it isn't
> > > sufficient architecturally.)
> > >
> > > For virtual CPUs that support IBRS, add an indirect branch prediction
> > > barrier on emulated VM-exit, to ensure that the predicted targets of
> > > indirect branches executed in L1 cannot be controlled by software that
> > > was executed in L2.
> > >
> > > Since we typically don't intercept guest writes to IA32_SPEC_CTRL,
> > > perform the IBPB at emulated VM-exit regardless of the current
> > > IA32_SPEC_CTRL.IBRS value, even though the IBPB could technically be
> > > deferred until L1 sets IA32_SPEC_CTRL.IBRS, if IA32_SPEC_CTRL.IBRS is
> > > clear at emulated VM-exit.
> > >
> > > This is CVE-2022-2196.
> > >
> > > Fixes: 5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02")
> > > Cc: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
>
> Code looks good, just some whining about the comments.
>
> > > ---
> > >  arch/x86/kvm/vmx/nested.c | 8 ++++++++
> > >  arch/x86/kvm/vmx/vmx.c    | 8 +++++---
> > >  2 files changed, 13 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index ddd4367d4826..87993951fe47 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -4604,6 +4604,14 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
> > >
> > >         vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> > >
> > > +       /*
> > > +        * For virtual IBRS,
>
> The "virtual" part confused me (even more so than usual for all this mitigation
> stuff).  At first I thought "virtual" was referring to some specialized hardware.
>
> > we have to flush the indirect branch
>
> Avoid pronouns please.
>
> > > +        * predictors, since L1 and L2 share hardware predictor
> > > +        * modes.
>
> Wrap at 80 chars, this easily fits on two lines.  Though I'd prefer to make this
> comment much longer, I have a terrible time keeping track of this stuff (obviously).
>
> Is this accurate?
>
>         /*
>          * If IBRS is advertised to the guest, KVM must flush the indirect

Advertising is done on a per-vCPU basis, so "advertised to the vCPU"?

>          * branch predictors when transitioning from L2 to L1, as L1 expects
>          * hardware (KVM in this case) to provide separate predictor modes.
>          * Bare metal isolates VMX root (host) from VMX non-root (guest), but
>          * doesn't isolate different VMs, i.e. in this case, doesn't provide

"different VMCSs"?

>          * separate modes for L2 vs L1.
>          */
>
> > > +        */
> > > +       if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> > > +               indirect_branch_prediction_barrier();
> > > +
> > >         /* Update any VMCS fields that might have changed while L2 ran */
> > >         vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> > >         vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index ffe552a82044..bf8b5c9c56ae 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -1347,9 +1347,11 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
> > >                 vmcs_load(vmx->loaded_vmcs->vmcs);
> > >
> > >                 /*
> > > -                * No indirect branch prediction barrier needed when switching
> > > -                * the active VMCS within a guest, e.g. on nested VM-Enter.
> > > -                * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
> > > +                * No indirect branch prediction barrier needed when
> > > +                * switching the active VMCS within a guest, except
>
> Wrap at 80.
>
> > > +                * for virtual IBRS. To minimize the number of IBPBs
>
> Same nit on "virtual IBRS".
>
> > > +                * executed, the one to support virtual IBRS is
> > > +                * handled specially in nested_vmx_vmexit().
>
> "nested VM-Exit" instead of nested_vmx_vmexit() to avoid rename hell, though that
> one is unlikely to get renamed.
>
> This work?
>
>                 /*
>                  * No indirect branch prediction barrier needed when switching
>                  * the active VMCS within a guest, except if IBRS is advertised

"within a vCPU"?

>                  * to the guest.  To minimize the number of IBPBs executed, KVM
>                  * performs IBPB on nested VM-Exit (a single nested transition
>                  * may switch the active VMCS multiple times).
>                  */
>

Should I send v2, or can this all be handled when applying?
