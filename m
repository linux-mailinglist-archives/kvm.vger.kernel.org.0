Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3DE56C33C
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbiGHXEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 19:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237520AbiGHXEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 19:04:14 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D273139F
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 16:04:13 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id o13so16954vsn.4
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 16:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fmbyHH+uaaf4PYgNAAvPhBsKLgcv7KBCVLIB8moDOnc=;
        b=ow8tZcCIFqJ/sbss3pnexex/9tbTMWYJtYo2+PPY5JmeMo+fbCL6clLQ5SUQOHT7lR
         +V9JMIa/zGJlDcz4sxUDOIhQ3pbyhJBrBP8KrLDM7iIpgB6Hw10hvS56z07TYd71xtbj
         WiLR4bdFzU2kGgvsOdQ87DsW9ZuhrC2PYDd09KSrT9TdBPUV1HeaW6+++rbwT7ARL9DT
         ZMYXRLBN5v0ATN0eMVGUdsXhO9RiDO4vmjSGNwD2WcqGNGnZ3DyRD/DkcwRCAkXv98CA
         Rx7+uyuzV/+ZOHvQfwRu9Ob1t4/ganFwit0NVmjA1PQKfykIJOZn5zUHjx8dgosaLLLc
         +yWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fmbyHH+uaaf4PYgNAAvPhBsKLgcv7KBCVLIB8moDOnc=;
        b=ogikB3KQsVtheBCQ/S3yd7XhuoYyiGmfWw3pTePxLtru+Ih+tQTzAyih9kOZMaN5Bt
         rrIzAPjlDe1N+huA00QRS/yx4sdB+dSa1X+xwD/pktmLRD7hfa6qN74L+eIsi9Wwpfgp
         RAO9wqDQPqTRXR9iO/RtHpHrYL/clNqSyxVrcX/9VlDVcHOfSgXJrVXaA3ehRuBBBfdk
         SGHfx8YXuFZ7K2rDl8PMy5Wv2+dWb5exW/TDja3+7ns3GMJi0qTSdcCbeI/JFBFMK1X0
         5IkpSZCxoF2/7ZpHflVY7H5KhuCjwc+jFPvaufs/mok81Ummh4DyFiWe87ma9pm9K6D5
         X79w==
X-Gm-Message-State: AJIora/v+zfLdCpYGki/5TV9SSlYeUKRx7LKo8+ahsJn55LnW8wzVRGZ
        K/HIyARH+o7MF/QVlxXkg0vnT+dK+iR8ClHt/yeO9A==
X-Google-Smtp-Source: AGRyM1tVOuLFpQdcMS9R3QNxMS8qL41pbX8NfOtsi479WHEb/YvXkQZIjnDxNp4LH2C43RprM+7+OtGtN648GAosnRM=
X-Received: by 2002:a67:d71e:0:b0:357:3543:be5b with SMTP id
 p30-20020a67d71e000000b003573543be5bmr2692860vsj.13.1657321452555; Fri, 08
 Jul 2022 16:04:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220706145957.32156-1-juew@google.com> <Ysi1/pldBpdtUt8y@google.com>
In-Reply-To: <Ysi1/pldBpdtUt8y@google.com>
From:   Jue Wang <juew@google.com>
Date:   Fri, 8 Jul 2022 16:04:01 -0700
Message-ID: <CAPcxDJ7AH_ko9A=PH=19yOE8=7=CzHQ5tSrN-O9yCUppuBEznQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: Initialize nr_lvt_entries to a proper
 default value
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Siddh Raman Pant <code@siddh.me>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Sean.

+cc another email to stay in the loop.

On Fri, Jul 8, 2022 at 3:56 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jul 06, 2022, Jue Wang wrote:
> > Set the default value of nr_lvt_entries to KVM_APIC_MAX_NR_LVT_ENTRIES-1
> > to address the cases when KVM_X86_SETUP_MCE is not called.
> >
> > Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
> > Signed-off-by: Jue Wang <juew@google.com>
> > ---
> >  arch/x86/kvm/lapic.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 8537b66cc646..257366b8e3ae 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2524,6 +2524,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
> >
> >       vcpu->arch.apic = apic;
> >
> > +     apic->nr_lvt_entries = KVM_APIC_MAX_NR_LVT_ENTRIES - 1;
>
> This works, but I don't love the subtle math nor the reliance on mcg_cap.MCG_CMCI_P
> being clear by default.  I'll properly post the below patch next week (compile tested
> only at this point).
>
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 8 Jul 2022 15:38:51 -0700
> Subject: [PATCH] KVM: x86: Initialize number of APIC LVT entries during APIC
>  creation
>
> Initialize the number of LVT entries during APIC creation, else the field
> will be incorrectly left '0' if userspace never invokes KVM_X86_SETUP_MCE.
>
> Add and use a helper to calculate the number of entries even though
> MCG_CMCI_P is not set by default in vcpu->arch.mcg_cap.  Relying on that
> to always be true is unnecessarily risky, and subtle/confusing as well.
>
> Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
> Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Jue Wang <juew@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 6ff17d5a2ae3..1540d01ecb67 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -405,6 +405,11 @@ static inline bool kvm_lapic_lvt_supported(struct kvm_lapic *apic, int lvt_index
>         return apic->nr_lvt_entries > lvt_index;
>  }
>
> +static inline int kvm_apic_calc_nr_lvt_entries(struct kvm_vcpu *vcpu)
> +{
> +       return KVM_APIC_MAX_NR_LVT_ENTRIES - !(vcpu->arch.mcg_cap & MCG_CMCI_P);
> +}
> +
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -2561,6 +2566,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>         }
>         apic->vcpu = vcpu;
>
> +       apic->nr_lvt_entries = kvm_apic_calc_nr_lvt_entries(vcpu);
> +
>         hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
>                      HRTIMER_MODE_ABS_HARD);
>         apic->lapic_timer.timer.function = apic_timer_fn;
>
> base-commit: 4a627b0b162b9495f3646caa6edb0e0f97d8f2de
> --
>
