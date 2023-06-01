Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B26571F3C2
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 22:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbjFAUVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 16:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjFAUVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 16:21:36 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5226DE5A
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 13:21:01 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-33baee0235cso635ab.1
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 13:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685650851; x=1688242851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xum0GcyUd9qWvFCDIMC18p+LuMnWPPETh0hK8e/TkCs=;
        b=Ply/NqUPA0HhlSaFPwE+ywYXzkC9J+Em7quNKRPmPqu866A+kSTHZtnlltDkL4tVIb
         +nQVpIEYFutefzspS9QnCie8OwIMMTsb1zmZ6eT/hxStJpE/7bErUm50Cw/P7a2Z6wKu
         orDe4xsD1Pq0JJ+/kcFkT1TIs+dN0hQnY52eO2biuKqk6AhHcnYl/j0n9t/nlFyxBS5/
         QMJriyuydJY/p4hdCAGMFrC9SdtwWgnPgYvBVgh9YIOlgvElh8n+UhaGHqC1FelXyf/d
         E5IPex3laVr8goAF6G5+/8eNXO6ULWMwNGIrz+NR8mSKwWVTDhs6C8NjsP7ULBKnXK/L
         d+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685650851; x=1688242851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xum0GcyUd9qWvFCDIMC18p+LuMnWPPETh0hK8e/TkCs=;
        b=LLEms++VPnrrx6j1NlkojQblCkm1HAuoG9FdgiNjF0eEUfwF2m7JDOFAXfX+/f/JJw
         DRE4Xbmj4kuXigf+lfahFs8cflD+yiKsZ0oM3LPIqYeVBUDJ8eX7YgWKzLM3RJHU7qju
         YTWdbQooKKfiA4AnmC+bHgPxROQepcB6gFqkF4QWOjkqiqCpiq+DDb0BbZoPW6S9espY
         vW4UiPptpGAbcz++h+QeEtID3+VDP7+nZv+aAhwdef3+n4JS1KpXk4schbDX+PxXEJj/
         gUj8xy5sIPmhLLlZZBghQrUEYiGtexD6ajnoxQJ5CSLUQyBUnss/6zwdui1P27+I+TBq
         zw6Q==
X-Gm-Message-State: AC+VfDw/dM9arpG4ItGZvLTkuyulFKKmWmIElvZzfJHkLdmPbvSKVmVN
        nvB5baIIrS+A7DJ7qTIU1Tlbvld7hAsd5L6Lnd24Jw==
X-Google-Smtp-Source: ACHHUZ525ZKcFWL4Bnz5bbu58drZGcvE4r8CBignQDtYHtHDT2ZOnM41zOQnYf8Twyo+N4UYFsb6ANnMXOPZd2HwI/U=
X-Received: by 2002:a05:6e02:17c8:b0:338:9f6a:d548 with SMTP id
 z8-20020a056e0217c800b003389f6ad548mr50571ilu.22.1685650851463; Thu, 01 Jun
 2023 13:20:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230531144128.73814-1-jon@nutanix.com> <9d37ab07-97c6-5245-6939-9c1090b4b3a9@redhat.com>
 <ECE9A3B4-2CF3-452A-838A-99BE075D5E68@nutanix.com> <3cb96907-0d58-ba60-ed0e-6c17c69bd0f8@redhat.com>
 <CALMp9eQNNCwUbPQGBfHzWnTAEJeRO-fjQAFxb9101SChe9F5rg@mail.gmail.com>
 <623EC08D-A755-4520-B9BF-42B0E72570C1@nutanix.com> <CALMp9eQ17+XRpxJjMnmvPnKOC1VP1P=mU-KykoOzYZsgtGN8sQ@mail.gmail.com>
 <658D3EF0-B2D3-4492-A2A1-FC84A58B201D@nutanix.com> <ZHjYsKVBFLsOmHcF@google.com>
 <BF7121B7-B2AE-4391-9D1B-D944B5BC44D0@nutanix.com>
In-Reply-To: <BF7121B7-B2AE-4391-9D1B-D944B5BC44D0@nutanix.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 1 Jun 2023 13:20:40 -0700
Message-ID: <CALMp9eQ247GCxHnn3VwFatKEswWq9cMaoZCOivC-OQ_asvFHZQ@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
To:     Jon Kohler <jon@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Waiman Long <longman@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 1, 2023 at 12:28=E2=80=AFPM Jon Kohler <jon@nutanix.com> wrote:
>
>
>
> > On Jun 1, 2023, at 1:43 PM, Sean Christopherson <seanjc@google.com> wro=
te:
> >
> > On Wed, May 31, 2023, Jon Kohler wrote:
> >>
> >>> On May 31, 2023, at 2:30 PM, Jim Mattson <jmattson@google.com> wrote:
> >>>
> >>> On Wed, May 31, 2023 at 11:17=E2=80=AFAM Jon Kohler <jon@nutanix.com>=
 wrote:
> >>>> Yea, I thought about it. One one hand, simplicity is kingand on the =
other
> >>>> hand, not having to think about this again is nice too.
> >>>>
> >>>> The challenge in my mind is that on setups where this truly is stati=
c, we=E2=80=99d
> >>>> be taking some incremental amount of memory to keep the counter arou=
nd,
> >
> > Not really.  The vCPU structures are already order-2 allocations, incre=
asing the
> > size by 8-16 bytes doesn't affect the actual memory usage in practice. =
 Death by
> > a thousand cuts is a potential problem, but we're a ways away from cros=
sing back
> > over into order-3 allocations.
> >
> >>>> just to have the same outcome each time. Doesn=E2=80=99t feel right =
(to me) unless that is
> >>>> also used for =E2=80=9Cother=E2=80=9D stuff as some sort of general =
purpose/common counter.
> >
> > ...
> >
> >> Yes, there is places this could be stuffed I=E2=80=99m sure. Still fee=
ls a bit heavy
> >> handed for the same-outcome-every-time situations though.
> >
> > There's no guarantee the outcome will be the same.  You're assuming tha=
t (a) the
> > guest is eIBRS aware, (b) SPEC_CTRL doesn't get extended for future mit=
igations,
> > and (c) that if L1 is running VMs of its own, that L1 is advertising eI=
BRS to L2
> > and that the L2 kernel is also aware of eIBRS.
> >
> >>>> RE Cost: I can=E2=80=99t put my finger on it, but I swear that RDMSR=
 for *this*
> >>>> specific MSR is more expensive than any other RDMSR I=E2=80=99ve com=
e across
> >>>> for run-of-the-mill random MSRs. I flipped thru the SDM and the miti=
gations
> >>>> documentation, and it only ever mentions that there is a notable cos=
t to
> >>>> do WRMSR IA32_SPEC_CTRL, but nothing about the RDMSR side.
> >>>>
> >>>> If anyone happens to know from an Intel-internals perspective, I=E2=
=80=99d be quite
> >>>> interested to know why it just =E2=80=9Cfeels=E2=80=9D so darn costl=
y. i.e. is the proc also doing
> >>>> special things under the covers, similar to what the processor does =
on
> >>>> writes to this one?
> >>>
> >>> What do you mean by "feels"? Have you measured it?
> >>
> >> There are plenty of rdmsr=E2=80=99s scattered around the entry and exi=
t paths that get
> >> hit every time, but this is far and away always the most expensive one=
 when
> >> profiling with perf top. I haven=E2=80=99t measured it separately from=
 the existing code,
> >> But rather noted during profiling that it appears to be nastier than o=
thers.
> >>
> >> I=E2=80=99m more curious than anything else, but it doesn=E2=80=99t ma=
tter all that much going
> >> forward since this commit will nuke it from orbit for the run of the m=
ill
> >> eIBRS-only use cases.
> >
> > As above, you're making multiple assumptions that may or may not hold t=
rue.  I
> > agree with Jim, reacting to what the guest is actually doing is more ro=
bust than
> > assuming the guest will do XYZ based on the vCPU model or some other he=
uristic.
> >
> > The code isn't that complex, and KVM can even reuse the number of exits=
 snapshot
> > to periodically re-enable the intercept, e.g. to avoid unnecessary RDMS=
Rs if the
> > vCPU stops writing MSR_IA32_SPEC_CTRL for whatever reason.

Bonus! It's nice to be able to respond to a state change. For
instance, L1 might write IA32_SPEC_CTRL like crazy while running a
certain L2, and then it might go back to not writing it at all.

> > Needs actual testing and informed magic numbers, but I think this captu=
res the
> > gist of what Jim is suggesting.
> Thanks, Sean, Jim. I agree that having something robust and lightweight w=
ould be
> real nice here. Thanks, Sean for the suggested code. I=E2=80=99ll take th=
at, do some
> testing, and report back.
> >
> > ---
> > arch/x86/include/asm/kvm_host.h |  3 +++
> > arch/x86/kvm/svm/svm.c          | 22 ++++++++--------------
> > arch/x86/kvm/vmx/vmx.c          | 28 ++++++++++------------------
> > arch/x86/kvm/x86.h              | 24 ++++++++++++++++++++++++
> > 4 files changed, 45 insertions(+), 32 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index fb9d1f2d6136..3fdb6048cd58 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -966,6 +966,9 @@ struct kvm_vcpu_arch {
> >       /* Host CPU on which VM-entry was most recently attempted */
> >       int last_vmentry_cpu;
> >
> > +     u32 nr_quick_spec_ctrl_writes;
> > +     u64 spec_ctrl_nr_exits_snapshot;
> > +
> >       /* AMD MSRC001_0015 Hardware Configuration */
> >       u64 msr_hwcr;
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index ca32389f3c36..f749613204d3 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2959,21 +2959,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, s=
truct msr_data *msr)
> >                       svm->vmcb->save.spec_ctrl =3D data;
> >               else
> >                       svm->spec_ctrl =3D data;
> > -             if (!data)
> > -                     break;
> >
> > -             /*
> > -              * For non-nested:
> > -              * When it's written (to non-zero) for the first time, pa=
ss
> > -              * it through.
> > -              *
> > -              * For nested:
> > -              * The handling of the MSR bitmap for L2 guests is done i=
n
> > -              * nested_svm_vmrun_msrpm.
> > -              * We update the L1 MSR bit as well since it will end up
> > -              * touching the MSR anyway now.
> > -              */
> > -             set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL=
, 1, 1);
> > +             if (!msr->host_initiated &&
> > +                 kvm_account_msr_spec_ctrl_write(vcpu))
> > +                     set_msr_interception(vcpu, svm->msrpm, MSR_IA32_S=
PEC_CTRL, 1, 1);
> >               break;
> >       case MSR_AMD64_VIRT_SPEC_CTRL:
> >               if (!msr->host_initiated &&
> > @@ -4158,6 +4147,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct=
 kvm_vcpu *vcpu)
> >
> >       svm_complete_interrupts(vcpu);
> >
> > +     if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
> > +         !spec_ctrl_intercepted &&
> > +         kvm_account_msr_spec_ctrl_passthrough(vcpu))
> > +             set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL=
, 0, 0);
> > +
> >       if (is_guest_mode(vcpu))
> >               return EXIT_FASTPATH_NONE;
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 44fb619803b8..4f4a2c3507bc 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2260,24 +2260,11 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, s=
truct msr_data *msr_info)
> >                       return 1;
> >
> >               vmx->spec_ctrl =3D data;
> > -             if (!data)
> > -                     break;
> >
> > -             /*
> > -              * For non-nested:
> > -              * When it's written (to non-zero) for the first time, pa=
ss
> > -              * it through.
> > -              *
> > -              * For nested:
> > -              * The handling of the MSR bitmap for L2 guests is done i=
n
> > -              * nested_vmx_prepare_msr_bitmap. We should not touch the
> > -              * vmcs02.msr_bitmap here since it gets completely overwr=
itten
> > -              * in the merging. We update the vmcs01 here for L1 as we=
ll
> > -              * since it will end up touching the MSR anyway now.
> > -              */
> > -             vmx_disable_intercept_for_msr(vcpu,
> > -                                           MSR_IA32_SPEC_CTRL,
> > -                                           MSR_TYPE_RW);
> > +             if (msr_info->host_initiated &&
> > +                 kvm_account_msr_spec_ctrl_write(vcpu))
> > +                     vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SPEC=
_CTRL,
> > +                                                   MSR_TYPE_RW);
> >               break;
> >       case MSR_IA32_TSX_CTRL:
> >               if (!msr_info->host_initiated &&
> > @@ -7192,6 +7179,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kv=
m_vcpu *vcpu,
> > static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > {
> >       struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> > +     unsigned int run_flags =3D __vmx_vcpu_run_flags(vmx);
> >       unsigned long cr3, cr4;
> >
> >       /* Record the guest's net vcpu time for enforced NMI injections. =
*/
> > @@ -7280,7 +7268,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *v=
cpu)
> >       kvm_wait_lapic_expire(vcpu);
> >
> >       /* The actual VMENTER/EXIT is in the .noinstr.text section. */
> > -     vmx_vcpu_enter_exit(vcpu, __vmx_vcpu_run_flags(vmx));
> > +     vmx_vcpu_enter_exit(vcpu, run_flags);
> >
> >       /* All fields are clean at this point */
> >       if (kvm_is_using_evmcs()) {
> > @@ -7346,6 +7334,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *=
vcpu)
> >       vmx_recover_nmi_blocking(vmx);
> >       vmx_complete_interrupts(vmx);
> >
> > +     if ((run_flags & VMX_RUN_SAVE_SPEC_CTRL) &&
> > +         kvm_account_msr_spec_ctrl_passthrough(vcpu))
> > +             vmx_enable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MS=
R_TYPE_RW);
> > +
> >       if (is_guest_mode(vcpu))
> >               return EXIT_FASTPATH_NONE;
> >
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index c544602d07a3..454bcbf5b543 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -492,7 +492,31 @@ static inline void kvm_machine_check(void)
> >
> > void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
> > void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
> > +
> > int kvm_spec_ctrl_test_value(u64 value);
> > +
> > +static inline bool kvm_account_msr_spec_ctrl_write(struct kvm_vcpu *vc=
pu)
> > +{
> > +     if ((vcpu->stat.exits - vcpu->arch.spec_ctrl_nr_exits_snapshot) <=
 20)

I think you mean 200 here. If it's bad to have more than 1
WRMSR(IA32_SPEC_CTRL) VM-exit in 20 VM-exits, then more than 10 such
VM-exits in 200 VM-exits represents sustained badness.

(Although, as Sean noted, these numbers are just placeholders.)

> > +             vcpu->arch.nr_quick_spec_ctrl_writes++;
> > +     else
> > +             vcpu->arch.nr_quick_spec_ctrl_writes =3D 0;
> > +
> > +     vcpu->arch.spec_ctrl_nr_exits_snapshot =3D vcpu->stat.exits;
> > +
> > +     return vcpu->arch.nr_quick_spec_ctrl_writes >=3D 10;
> > +}
> > +
> > +static inline bool kvm_account_msr_spec_ctrl_passthrough(struct kvm_vc=
pu *vcpu)
> > +{
> > +     if ((vcpu->stat.exits - vcpu->arch.spec_ctrl_nr_exits_snapshot) <=
 100000)
> > +             return false;
> > +
> > +     vcpu->arch.spec_ctrl_nr_exits_snapshot =3D vcpu->stat.exits;
> > +     vcpu->arch.nr_quick_spec_ctrl_writes =3D 0;
> > +     return true;
> > +}
> > +
> > bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
> > int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
> >                             struct x86_exception *e);
> >
> > base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f
> > --
>
