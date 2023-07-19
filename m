Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB64759EE0
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 21:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjGSTlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 15:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjGSTlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 15:41:51 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF40199A
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 12:41:50 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5706641dda9so612787b3.3
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 12:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689795709; x=1692387709;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x0CVjOuwJCEU6INafeYJW4NN7Sz04k19DziuQ/frsrc=;
        b=qj6RNkQvx9b7ihLOFjXaxIJDfFaOk5oOFW55Bn7dQ8BAde01HPZ47q4Gp4GjFBfRnS
         UXvE+Jj3ZAZGauBvN6rBTxNWjNJ3r82WvhogDTokd8gYZEyUYpp9T2uNDfIS2U2uLcr4
         14com1XaWcy/uZ1GKkzKC7ewufFIZSGcZ1pEg6jn/L1a9jj0rg3ZUW8Ixjg3fpGOABJK
         qfw8JDgFyKgUCxxgJrHmion24bLWnGHZk0Uj6QbLgUutIpjleN3niU1GlAYGEQyoQJSD
         cEwZNdr0dopLkYGv+t09ohXkDWuAQKL99iZ00oC8VV5g8KmUfm6h/K3cvuJY5C8zI+8V
         xfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689795709; x=1692387709;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x0CVjOuwJCEU6INafeYJW4NN7Sz04k19DziuQ/frsrc=;
        b=SZQ/iEDbWGf0q6nM6AqMLvbZmfUPUBaioqg5OML7wu98VApe58igAf7vOq40CYHQ54
         sJiUIfMWujq2+COfJMjZK4rMvRJRDDOncdwsP1uU1pR5AvgDdk3/4BYgQnLyoKDcM1mB
         WWz59KQq8ixRTOlCX4scKQmcyaJW7pQj/o9GddFG2nq3X1uj4464Q61SXXEHyqDfXQSu
         oFBvrEENVrA7BkQ2HKBQCKV5eNfUCRvpgVkAmY1lgESUP9PvKWzS8gvBGXdDnsrEzw6Q
         9i8OVbADnw1eGhyn2pyr9QT3lfwxrNBzo4gCKCDtwoPrD3/McRnEfwrwOV1staLD9UMT
         bWcQ==
X-Gm-Message-State: ABy/qLapmxLQzs4fuvfbPVFZtiL2cPffifJCDnO1/SsGzSMUDX8zgR+s
        HZ7SYOAjlqLAf4n3NTgfpC2fgsumYco=
X-Google-Smtp-Source: APBJJlFlTWBq1xUnrehbktU8BMZ3/Sc67KZ1X3VYSFrMj9t7RBT0ytEGf0/+DYMncBfcubUCwqIX4dNvD6s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad5a:0:b0:577:617b:f881 with SMTP id
 l26-20020a81ad5a000000b00577617bf881mr487ywk.8.1689795709610; Wed, 19 Jul
 2023 12:41:49 -0700 (PDT)
Date:   Wed, 19 Jul 2023 12:41:47 -0700
In-Reply-To: <e44a9a1a-0826-dfa7-4bd9-a11e5790d162@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com> <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com> <c438b5b1-b34d-3e77-d374-37053f4c14fa@intel.com>
 <ZJYF7haMNRCbtLIh@google.com> <e44a9a1a-0826-dfa7-4bd9-a11e5790d162@intel.com>
Message-ID: <ZLg8ezG/XrZH+KGD@google.com>
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com,
        Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 17, 2023, Weijiang Yang wrote:
>=20
> On 6/24/2023 4:51 AM, Sean Christopherson wrote:
> > > 1)Add Supervisor Shadow Stack=EF=BF=BD state support(i.e., XSS.bit12(=
CET_S)) into
> > > kernel so that host can support guest Supervisor Shadow Stack MSRs in=
 g/h FPU
> > > context switch.
> > If that's necessary for correct functionality, yes.

...

> the Pros:
> =EF=BF=BD- Super easy to implement for KVM.
> =EF=BF=BD- Automatically avoids saving and restoring this data when the v=
mexit
> =EF=BF=BD=EF=BF=BD is handled within KVM.
>=20
> the Cons:
> =EF=BF=BD- Unnecessarily restores XFEATURE_CET_KERNEL when switching to
> =EF=BF=BD=EF=BF=BD non-KVM task's userspace.
> =EF=BF=BD- Forces allocating space for this state on all tasks, whether o=
r not
> =EF=BF=BD=EF=BF=BD they use KVM, and with likely zero users today and the=
 near future.
> =EF=BF=BD- Complicates the FPU optimization thinking by including things =
that
> =EF=BF=BD=EF=BF=BD can have no affect on userspace in the FPU
>=20
> Given above reasons, I implemented guest CET supervisor states management
> in KVM instead of adding a kernel patch for it.
>=20
> Below are 3 KVM patches to support it:
>=20
> Patch 1: Save/reload guest CET supervisor states when necessary:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> commit 16147ede75dee29583b7d42a6621d10d55b63595
> Author: Yang Weijiang <weijiang.yang@intel.com>
> Date:=EF=BF=BD=EF=BF=BD Tue Jul 11 02:26:17 2023 -0400
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD KVM:x86: Make guest supervisor states as non-=
XSAVE managed
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD Save and reload guest CET supervisor states, =
i.e.,PL{0,1,2}_SSP,
> =EF=BF=BD=EF=BF=BD=EF=BF=BD when vCPU context is being swapped before and=
 after userspace
> =EF=BF=BD=EF=BF=BD=EF=BF=BD <->kernel entry, also do the same operation w=
hen vCPU is sched-in
> =EF=BF=BD=EF=BF=BD=EF=BF=BD or sched-out.

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e2c549f147a5..7d9cfb7e2fe8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11212,6 +11212,31 @@ static void kvm_put_guest_fpu(struct kvm_vcpu
> *vcpu)
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD trace_kvm=
_fpu(0);
> =EF=BF=BD}
>=20
> +static void kvm_save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
> +{
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD preempt_disable()=
;
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD if (unlikely(gues=
t_can_use(vcpu, X86_FEATURE_SHSTK))) {
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD rdmsrl(MSR_IA32_PL0_=
SSP, vcpu->arch.cet_s_ssp[0]);
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD rdmsrl(MSR_IA32_PL1_=
SSP, vcpu->arch.cet_s_ssp[1]);
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD rdmsrl(MSR_IA32_PL2_=
SSP, vcpu->arch.cet_s_ssp[2]);
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD wrmsrl(MSR_IA32_PL0_=
SSP, 0);
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD wrmsrl(MSR_IA32_PL1_=
SSP, 0);
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD wrmsrl(MSR_IA32_PL2_=
SSP, 0);
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD }
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD preempt_enable();
> +}
> +
> +static void kvm_reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
> +{
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD preempt_disable()=
;
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD if (unlikely(gues=
t_can_use(vcpu, X86_FEATURE_SHSTK))) {
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD wrmsrl(MSR_IA32_PL0_=
SSP, vcpu->arch.cet_s_ssp[0]);
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD wrmsrl(MSR_IA32_PL1_=
SSP, vcpu->arch.cet_s_ssp[1]);
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD wrmsrl(MSR_IA32_PL2_=
SSP, vcpu->arch.cet_s_ssp[2]);
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD }
> +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD preempt_enable();
> +}

My understanding is that PL[0-2]_SSP are used only on transitions to the
corresponding privilege level from a *different* privilege level.  That mea=
ns
KVM should be able to utilize the user_return_msr framework to load the hos=
t
values.  Though if Linux ever supports SSS, I'm guessing the core kernel wi=
ll
have some sort of mechanism to defer loading MSR_IA32_PL0_SSP until an exit=
 to
userspace, e.g. to avoid having to write PL0_SSP, which will presumably be
per-task, on every context switch.

But note my original wording: **If that's necessary**

If nothing in the host ever consumes those MSRs, i.e. if SSS is NOT enabled=
 in
IA32_S_CET, then running host stuff with guest values should be ok.  KVM on=
ly
needs to guarantee that it doesn't leak values between guests.  But that sh=
ould
Just Work, e.g. KVM should load the new vCPU's values if SHSTK is exposed t=
o the
guest, and intercept (to inject #GP) if SHSTK is not exposed to the guest.

And regardless of what the mechanism ends up managing SSP MSRs, it should o=
nly
ever touch PL0_SSP, because Linux never runs anything at CPL1 or CPL2, i.e.=
 will
never consume PL{1,2}_SSP.

Am I missing something?
