Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF84F71F103
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 19:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbjFARnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 13:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjFARnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 13:43:17 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09F313D
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 10:43:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56938733c13so7057717b3.1
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 10:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685641394; x=1688233394;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3kf6qWJSR+JlJKMZ4UHuaNcsIzc9PLZB5GQhvTfY1Uo=;
        b=OqaBDt7o0vHh+H+knA/tgj+dv/2tIqUMuTpoEMHfupZhnFwaA6icz8KOZiS0eM7hz5
         /bDjb6hIO8ZwgniTFTjkJTIV9ziKyy9AHqdsAoKi05YyJ6+kjcZmSU6Ey9wjviZ1Z473
         o+bgDA3VvD3tP5nUHsu5Prd7PSpr1fSyVYK3bdIR/4XqSUhruocfBGfY/1r6tjeB2gdD
         62ZuYOwvx0RJwEOysOc1C3QTHQlmMqfAXihrW0mVx/PVD2kwaYdCezwayra8AO3JkmtH
         xhSefSrCGYOS7IIKSqIKTrBSWC5PFJh7aUFP2sP2G86s9SIc1PXM/twAo6E6PWtbniJN
         spzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685641394; x=1688233394;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3kf6qWJSR+JlJKMZ4UHuaNcsIzc9PLZB5GQhvTfY1Uo=;
        b=HpSYUCKT/BEd4ROLpxxFCUaKG2TyiYvQZLfviP3tBaN7k8li4gxl5JZMiczOcXxfBg
         ANRQScDejiCMXWzDuwVdB3H8bVzI+OqIuBBmMsDh95CvU0bgs5q3Oop47yHrUjqzz9tV
         kCfubJHnTmPLhm5MABDEK1/M93UVfSWMMOXd6ZDbsEUGwuZAdIe4IGtXJt0LIiRgMYWb
         Bmi4cYbqjNHGk2gxAorRnldti5+M6BUJ7OP4GxZ/pRNijnXHY3b5vL6AgLiwwSioIjap
         spiQ+oSE5TqaVIM9R7DS4LVXVEGBb7seJpdXXPdAh0PXuKaq2xCPVrVHVhN9DNg58zdU
         9qlg==
X-Gm-Message-State: AC+VfDxwuEU3jWZjr9PQph5/RZhUPxHG7U7750NxJkOuYlikQdz1hCyV
        iha65QQnuIhNJrfofw3SyjUNuHF9Q5w=
X-Google-Smtp-Source: ACHHUZ58XBTZ1awVt8U4pYu4n9n1oYjle6fM5IgxHETMULZoma9ZT72oSlsApkyBXlJ4M0qZ7jLZyENE4Zw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:32c2:0:b0:ba8:b828:c8ff with SMTP id
 y185-20020a2532c2000000b00ba8b828c8ffmr273879yby.10.1685641394225; Thu, 01
 Jun 2023 10:43:14 -0700 (PDT)
Date:   Thu, 1 Jun 2023 17:43:12 +0000
In-Reply-To: <658D3EF0-B2D3-4492-A2A1-FC84A58B201D@nutanix.com>
Mime-Version: 1.0
References: <20230531144128.73814-1-jon@nutanix.com> <9d37ab07-97c6-5245-6939-9c1090b4b3a9@redhat.com>
 <ECE9A3B4-2CF3-452A-838A-99BE075D5E68@nutanix.com> <3cb96907-0d58-ba60-ed0e-6c17c69bd0f8@redhat.com>
 <CALMp9eQNNCwUbPQGBfHzWnTAEJeRO-fjQAFxb9101SChe9F5rg@mail.gmail.com>
 <623EC08D-A755-4520-B9BF-42B0E72570C1@nutanix.com> <CALMp9eQ17+XRpxJjMnmvPnKOC1VP1P=mU-KykoOzYZsgtGN8sQ@mail.gmail.com>
 <658D3EF0-B2D3-4492-A2A1-FC84A58B201D@nutanix.com>
Message-ID: <ZHjYsKVBFLsOmHcF@google.com>
Subject: Re: [PATCH v4] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Jim Mattson <jmattson@google.com>,
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
Content-Type: text/plain; charset="utf-8"
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

On Wed, May 31, 2023, Jon Kohler wrote:
>=20
> > On May 31, 2023, at 2:30 PM, Jim Mattson <jmattson@google.com> wrote:
> >=20
> > On Wed, May 31, 2023 at 11:17=E2=80=AFAM Jon Kohler <jon@nutanix.com> w=
rote:
> >> Yea, I thought about it. One one hand, simplicity is kingand on the ot=
her
> >> hand, not having to think about this again is nice too.
> >>=20
> >> The challenge in my mind is that on setups where this truly is static,=
 we=E2=80=99d
> >> be taking some incremental amount of memory to keep the counter around=
,

Not really.  The vCPU structures are already order-2 allocations, increasin=
g the
size by 8-16 bytes doesn't affect the actual memory usage in practice.  Dea=
th by
a thousand cuts is a potential problem, but we're a ways away from crossing=
 back
over into order-3 allocations.

> >> just to have the same outcome each time. Doesn=E2=80=99t feel right (t=
o me) unless that is
> >> also used for =E2=80=9Cother=E2=80=9D stuff as some sort of general pu=
rpose/common counter.

...

> Yes, there is places this could be stuffed I=E2=80=99m sure. Still feels =
a bit heavy
> handed for the same-outcome-every-time situations though.

There's no guarantee the outcome will be the same.  You're assuming that (a=
) the
guest is eIBRS aware, (b) SPEC_CTRL doesn't get extended for future mitigat=
ions,
and (c) that if L1 is running VMs of its own, that L1 is advertising eIBRS =
to L2
and that the L2 kernel is also aware of eIBRS.

> >> RE Cost: I can=E2=80=99t put my finger on it, but I swear that RDMSR f=
or *this*
> >> specific MSR is more expensive than any other RDMSR I=E2=80=99ve come =
across
> >> for run-of-the-mill random MSRs. I flipped thru the SDM and the mitiga=
tions
> >> documentation, and it only ever mentions that there is a notable cost =
to
> >> do WRMSR IA32_SPEC_CTRL, but nothing about the RDMSR side.
> >>=20
> >> If anyone happens to know from an Intel-internals perspective, I=E2=80=
=99d be quite
> >> interested to know why it just =E2=80=9Cfeels=E2=80=9D so darn costly.=
 i.e. is the proc also doing
> >> special things under the covers, similar to what the processor does on
> >> writes to this one?
> >=20
> > What do you mean by "feels"? Have you measured it?
>=20
> There are plenty of rdmsr=E2=80=99s scattered around the entry and exit p=
aths that get
> hit every time, but this is far and away always the most expensive one wh=
en
> profiling with perf top. I haven=E2=80=99t measured it separately from th=
e existing code,
> But rather noted during profiling that it appears to be nastier than othe=
rs.=20
>=20
> I=E2=80=99m more curious than anything else, but it doesn=E2=80=99t matte=
r all that much going
> forward since this commit will nuke it from orbit for the run of the mill=
=20
> eIBRS-only use cases.

As above, you're making multiple assumptions that may or may not hold true.=
  I
agree with Jim, reacting to what the guest is actually doing is more robust=
 than
assuming the guest will do XYZ based on the vCPU model or some other heuris=
tic.

The code isn't that complex, and KVM can even reuse the number of exits sna=
pshot
to periodically re-enable the intercept, e.g. to avoid unnecessary RDMSRs i=
f the
vCPU stops writing MSR_IA32_SPEC_CTRL for whatever reason.

Needs actual testing and informed magic numbers, but I think this captures =
the
gist of what Jim is suggesting.

---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/svm/svm.c          | 22 ++++++++--------------
 arch/x86/kvm/vmx/vmx.c          | 28 ++++++++++------------------
 arch/x86/kvm/x86.h              | 24 ++++++++++++++++++++++++
 4 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index fb9d1f2d6136..3fdb6048cd58 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -966,6 +966,9 @@ struct kvm_vcpu_arch {
 	/* Host CPU on which VM-entry was most recently attempted */
 	int last_vmentry_cpu;
=20
+	u32 nr_quick_spec_ctrl_writes;
+	u64 spec_ctrl_nr_exits_snapshot;
+
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
=20
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca32389f3c36..f749613204d3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2959,21 +2959,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struc=
t msr_data *msr)
 			svm->vmcb->save.spec_ctrl =3D data;
 		else
 			svm->spec_ctrl =3D data;
-		if (!data)
-			break;
=20
-		/*
-		 * For non-nested:
-		 * When it's written (to non-zero) for the first time, pass
-		 * it through.
-		 *
-		 * For nested:
-		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_svm_vmrun_msrpm.
-		 * We update the L1 MSR bit as well since it will end up
-		 * touching the MSR anyway now.
-		 */
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		if (!msr->host_initiated &&
+		    kvm_account_msr_spec_ctrl_write(vcpu))
+			set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
@@ -4158,6 +4147,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm=
_vcpu *vcpu)
=20
 	svm_complete_interrupts(vcpu);
=20
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
+	    !spec_ctrl_intercepted &&
+	    kvm_account_msr_spec_ctrl_passthrough(vcpu))
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 0, 0);
+
 	if (is_guest_mode(vcpu))
 		return EXIT_FASTPATH_NONE;
=20
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..4f4a2c3507bc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2260,24 +2260,11 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
 			return 1;
=20
 		vmx->spec_ctrl =3D data;
-		if (!data)
-			break;
=20
-		/*
-		 * For non-nested:
-		 * When it's written (to non-zero) for the first time, pass
-		 * it through.
-		 *
-		 * For nested:
-		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_prepare_msr_bitmap. We should not touch the
-		 * vmcs02.msr_bitmap here since it gets completely overwritten
-		 * in the merging. We update the vmcs01 here for L1 as well
-		 * since it will end up touching the MSR anyway now.
-		 */
-		vmx_disable_intercept_for_msr(vcpu,
-					      MSR_IA32_SPEC_CTRL,
-					      MSR_TYPE_RW);
+		if (msr_info->host_initiated &&
+		    kvm_account_msr_spec_ctrl_write(vcpu))
+			vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL,
+						      MSR_TYPE_RW);
 		break;
 	case MSR_IA32_TSX_CTRL:
 		if (!msr_info->host_initiated &&
@@ -7192,6 +7179,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vc=
pu *vcpu,
 static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
+	unsigned int run_flags =3D __vmx_vcpu_run_flags(vmx);
 	unsigned long cr3, cr4;
=20
 	/* Record the guest's net vcpu time for enforced NMI injections. */
@@ -7280,7 +7268,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	kvm_wait_lapic_expire(vcpu);
=20
 	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
-	vmx_vcpu_enter_exit(vcpu, __vmx_vcpu_run_flags(vmx));
+	vmx_vcpu_enter_exit(vcpu, run_flags);
=20
 	/* All fields are clean at this point */
 	if (kvm_is_using_evmcs()) {
@@ -7346,6 +7334,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu=
)
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
=20
+	if ((run_flags & VMX_RUN_SAVE_SPEC_CTRL) &&
+	    kvm_account_msr_spec_ctrl_passthrough(vcpu))
+		vmx_enable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
+
 	if (is_guest_mode(vcpu))
 		return EXIT_FASTPATH_NONE;
=20
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c544602d07a3..454bcbf5b543 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -492,7 +492,31 @@ static inline void kvm_machine_check(void)
=20
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
+
 int kvm_spec_ctrl_test_value(u64 value);
+
+static inline bool kvm_account_msr_spec_ctrl_write(struct kvm_vcpu *vcpu)
+{
+	if ((vcpu->stat.exits - vcpu->arch.spec_ctrl_nr_exits_snapshot) < 20)
+		vcpu->arch.nr_quick_spec_ctrl_writes++;
+	else
+		vcpu->arch.nr_quick_spec_ctrl_writes =3D 0;
+
+	vcpu->arch.spec_ctrl_nr_exits_snapshot =3D vcpu->stat.exits;
+
+	return vcpu->arch.nr_quick_spec_ctrl_writes >=3D 10;
+}
+
+static inline bool kvm_account_msr_spec_ctrl_passthrough(struct kvm_vcpu *=
vcpu)
+{
+	if ((vcpu->stat.exits - vcpu->arch.spec_ctrl_nr_exits_snapshot) < 100000)
+		return false;
+
+	vcpu->arch.spec_ctrl_nr_exits_snapshot =3D vcpu->stat.exits;
+	vcpu->arch.nr_quick_spec_ctrl_writes =3D 0;
+	return true;
+}
+
 bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);

base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f
--=20
