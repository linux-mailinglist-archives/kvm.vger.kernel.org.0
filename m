Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1F128193F
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388288AbgJBR3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388247AbgJBR3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:29:05 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF52CC0613E3
        for <kvm@vger.kernel.org>; Fri,  2 Oct 2020 10:29:05 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id a2so2095960otr.11
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 10:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RQsg6ahWktyPvURwiyd1VgLtMh0Q43RTGiqOocC5R54=;
        b=UO94HG6O0IX1kgvtQIyBLRmnKZ0ICSk8JVo/6rlaOMXI6yCPT+tEy43d5N5dN6RMUu
         qHNIfX1buI6VYT5mzWWRXhrkrkj7bUZ+hUM/ua2NafAM7SWj08OhoQ7wQ1ueK+5IqAkM
         sNCGxBatn9yvcPEuKxA+Pve+PTi6Vi1mFZnkwiSQYNmHbrRQ13vF8YFoSA0/Lgfpwmu1
         zhVXPYiIUavX0O2QT2OgjblVpc713KBNN8kE+LdGbzN5mox0j1JgvbsndHaXkEfDAVVr
         1I0Lcf8nmC2FfQBXdeV5JJ9t2sxYmmh/36bupWw2UhNHB3RgKF2i6VIxidXMdLy8dBEh
         hrCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RQsg6ahWktyPvURwiyd1VgLtMh0Q43RTGiqOocC5R54=;
        b=Dn0JsnX/wGrlxvwgQlJZKBIkf37OYuu2BDpkuKgtbTG+Xj6uqE4PLpR4vYPfqDA+nv
         Jqa4bvwAVjxEO0XKrmC1aKKzfA6VowM8yfx093/6UAr1TZ5a60EoEX6u4OoGFwt6+qUe
         vLhFRxuVRaGGZnxKGkCKS6H1nHEV09h3K3Pr5Cwjk/JIfbA8DgIieSdotdwg84WqM1H4
         y2gTJAgcBlgU1CfVo79MwrIszo72vnLh7zzXf1vSmeKvMPKyeDwqRqGD5qzJP+MOdJ80
         m/oas1MsRlcQC4+XDOopsKpHFzHKRSkzFpU0NDJAgGZvW8DD2ITjXqvVxz1r58gyAuPF
         l8fA==
X-Gm-Message-State: AOAM530AvsqUx8HF+wdUOboJHTAKh14kpcxZF183Hay6bUkbQamxSRhI
        7eTMA9ozW3HpDrscNcKP5jvHK8YBTlLquqVfLBcFDA==
X-Google-Smtp-Source: ABdhPJxL6pus8jowMU3LdrwfzIwO1FYffuY4IL2IunOFog16IDAVC1S+1qq0Dsb/eucmve/Nj9gINZs8R32PMNR28rI=
X-Received: by 2002:a05:6830:2104:: with SMTP id i4mr2576095otc.266.1601659744837;
 Fri, 02 Oct 2020 10:29:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200903141122.72908-1-mgamal@redhat.com> <1f42d8f084083cdf6933977eafbb31741080f7eb.camel@redhat.com>
 <e1dee0fd2b4be9d8ea183d3cf6d601cf9566fde9.camel@redhat.com>
 <ebcd39a5-364f-c4ac-f8c7-41057a3d84be@redhat.com> <2063b592f82f680edf61dad575f7c092d11d8ba3.camel@redhat.com>
 <c385b225-77fb-cf2a-fba3-c70a9b6d541d@redhat.com>
In-Reply-To: <c385b225-77fb-cf2a-fba3-c70a9b6d541d@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 2 Oct 2020 22:58:53 +0530
Message-ID: <CA+G9fYvm1Ux7XmmXgpPHmLJ4WbRoPowbEfbub1HC2G4E-1r-1g@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address space
 support user-configurable
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Qian Cai <cai@redhat.com>, Mohammed Gamal <mgamal@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Thanks for the patch.

On Tue, 29 Sep 2020 at 20:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 29/09/20 15:39, Qian Cai wrote:
> > On Tue, 2020-09-29 at 14:26 +0200, Paolo Bonzini wrote:
> >> On 29/09/20 13:59, Qian Cai wrote:
> >>> WARN_ON_ONCE(!allow_smaller_maxphyaddr);
> >>>
> >>> I noticed the origin patch did not have this WARN_ON_ONCE(), but the
> >>> mainline
> >>> commit b96e6506c2ea ("KVM: x86: VMX: Make smaller physical guest address
> >>> space
> >>> support user-configurable") does have it for some reasons.
> >>
> >> Because that part of the code should not be reached.  The exception
> >> bitmap is set up with
> >>
> >>         if (!vmx_need_pf_intercept(vcpu))
> >>                 eb &= ~(1u << PF_VECTOR);
> >>
> >> where
> >>
> >> static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
> >> {
> >>         if (!enable_ept)
> >>                 return true;
> >>
> >>         return allow_smaller_maxphyaddr &&
> >>               cpuid_maxphyaddr(vcpu) < boot_cpu_data.x86_phys_bits;
> >> }
> >>
> >> We shouldn't get here if "enable_ept && !allow_smaller_maxphyaddr",
> >> which implies vmx_need_pf_intercept(vcpu) == false.  So the warning is
> >> genuine; I've sent a patch.
> >
> > Care to provide a link to the patch? Just curious.
> >
>
> Ok, I haven't sent it yet. :)  But here it is:
>
> commit 608e2791d7353e7d777bf32038ca3e7d548155a4 (HEAD -> kvm-master)
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Tue Sep 29 08:31:32 2020 -0400
>
>     KVM: VMX: update PFEC_MASK/PFEC_MATCH together with PF intercept
>
>     The PFEC_MASK and PFEC_MATCH fields in the VMCS reverse the meaning of
>     the #PF intercept bit in the exception bitmap when they do not match.
>     This means that, if PFEC_MASK and/or PFEC_MATCH are set, the
>     hypervisor can get a vmexit for #PF exceptions even when the
>     corresponding bit is clear in the exception bitmap.
>
>     This is unexpected and is promptly reported as a WARN_ON_ONCE.
>     To fix it, reset PFEC_MASK and PFEC_MATCH when the #PF intercept
>     is disabled (as is common with enable_ept && !allow_smaller_maxphyaddr).

I have tested this patch on an x86_64 machine and the reported issue is gone.

>
>     Reported-by: Qian Cai <cai@redhat.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>

>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f0384e93548a..f4e9c310032a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -794,6 +794,18 @@ void update_exception_bitmap(struct kvm_vcpu *vcpu)
>          */
>         if (is_guest_mode(vcpu))
>                 eb |= get_vmcs12(vcpu)->exception_bitmap;
> +        else {
> +               /*
> +                * If EPT is enabled, #PF is only trapped if MAXPHYADDR is mismatched
> +                * between guest and host.  In that case we only care about present
> +                * faults.  For vmcs02, however, PFEC_MASK and PFEC_MATCH are set in
> +                * prepare_vmcs02_rare.
> +                */
> +               bool selective_pf_trap = enable_ept && (eb & (1u << PF_VECTOR));
> +               int mask = selective_pf_trap ? PFERR_PRESENT_MASK : 0;
> +               vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, mask);
> +               vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, mask);
> +       }
>
>         vmcs_write32(EXCEPTION_BITMAP, eb);
>  }
> @@ -4355,16 +4367,6 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>                 vmx->pt_desc.guest.output_mask = 0x7F;
>                 vmcs_write64(GUEST_IA32_RTIT_CTL, 0);
>         }
> -
> -       /*
> -        * If EPT is enabled, #PF is only trapped if MAXPHYADDR is mismatched
> -        * between guest and host.  In that case we only care about present
> -        * faults.
> -        */
> -       if (enable_ept) {
> -               vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, PFERR_PRESENT_MASK);
> -               vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, PFERR_PRESENT_MASK);
> -       }
>  }
>
>  static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>

test log link
https://lkft.validation.linaro.org/scheduler/job/1813223

- Naresh
