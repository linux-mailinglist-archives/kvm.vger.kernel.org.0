Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4EA6C6F7A
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 18:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjCWRkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 13:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjCWRkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 13:40:22 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C432B28D
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:07 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d2-20020a170902cec200b001a1e8390831so4348205plg.5
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679593207;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Np477Ao4rRuZImXXPqxkgyxkSQd5L1lbhYSSkdPGCdI=;
        b=GKD4obibyDD3/fv0RDwPmo3pJBMDj3PSuSyRJapfMKyFO80RwYOrnjlkBug8I7Es3V
         uKx03GLgefnEczR3LVxCyAbHu9pYs3vUSsj1CJzRqNYuiMaSBHAcYBy0jOUcob1UXBSN
         fLiK/8qE+fRufk6pv6HMwrEUHPwNGQhZXJVSbeDngWHUll0JmsHR0ukpcg82Z8jhcGW4
         lV/DXjCewwQEDMGqGhWXqRrd0qbJpWROdqeG1Oxbav0VbdqeFPohQUVDIKdL2ZKoWsTx
         QkYxzdILfN1oTmJ3xh9BVJb1hk/TKrL3FHXbxukQI7MwkH6Ec8K3dQAee3BqFcqIc3o/
         772Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679593207;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Np477Ao4rRuZImXXPqxkgyxkSQd5L1lbhYSSkdPGCdI=;
        b=k5VC/9tWdusr7/YGSOEHvpK2Z/l1Lf5OUf6Vmf/wb3b1+wVj09tNQAbAKncVXksCoz
         WP3Oi2s4ujMcCLxCTQzXOsFpqj2546uMZxjRQfTV6Ap8H1trtco8QP7DbKfVOoEhfhhX
         AD4lVWr/RHXTA94WBd1SF38l2eRItHR7Hm3k4IYF8/9b/IrmEj3tDLKi48AmAP78aDBW
         pzDEqMcV2bELcFSqIxIp3YK0VtRGUwRCQrZd3vrJC1BVjiUDbsAm8reRAFYtL6Dp/jg/
         v9IeABz5H4YyP/mj72wONzJw3jCnPCGAtYAKnj1mX+Z5jhqEnPSzo4yIIyTBB5juz829
         dzCw==
X-Gm-Message-State: AO0yUKWeZZjwGmKpU1LlgZzMDI+vbmyKSw+4udorAP8sHRFtLeWUOIlk
        37YrDylZ+dYRJPR5uLYqR3o8pLyZTxQ=
X-Google-Smtp-Source: AK7set8qJMTmGBDwWqJ7ltOeqiBujSKD6nuTZvLrWNu1/JqF+yBCNFuRWwwY7eNZHBZ9PgQPyM9t6zQxfxQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:4202:0:b0:4fb:be1a:2074 with SMTP id
 c2-20020a654202000000b004fbbe1a2074mr2205682pgq.12.1679593207078; Thu, 23 Mar
 2023 10:40:07 -0700 (PDT)
Date:   Thu, 23 Mar 2023 10:40:05 -0700
In-Reply-To: <20230203051459.1354589-1-aik@amd.com>
Mime-Version: 1.0
References: <3b3a9ebc-b02e-a365-7f68-3da9189d062a@amd.com> <20230203051459.1354589-1-aik@amd.com>
Message-ID: <ZByO9RP4IkEshOqJ@google.com>
Subject: Re: [PATCH kernel v4] KVM: SEV: Enable data breakpoints in SEV-ES
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 03, 2023, Alexey Kardashevskiy wrote:
> While at this, move set_/clr_dr_intercepts to .c and move #DB intercept
> next to DR7 intercept.

Please do non-trivial code movement in separate patches unless the function=
al change
is trivial.  Moving and changing at the same time makes the patch difficult=
 to review.

> @@ -52,9 +53,14 @@ module_param_named(sev, sev_enabled, bool, 0444);
>  /* enable/disable SEV-ES support */
>  static bool sev_es_enabled =3D true;
>  module_param_named(sev_es, sev_es_enabled, bool, 0444);
> +
> +/* enable/disable SEV-ES DebugSwap support */
> +static bool sev_es_debug_swap_enabled =3D true;
> +module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);

Needs to be 0444, otherwise userspace can turn on the knob after KVM is loa=
ded,
which would allow enabling the feature on unsupported platforms, amongst ma=
ny
other problems.

>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 60c7c880266b..f8e222bee22a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -671,6 +671,65 @@ static int svm_cpu_init(int cpu)
> =20
>  }
> =20
> +static void set_dr_intercepts(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb =3D svm->vmcb01.ptr;
> +	bool intercept;
> +
> +	if (!sev_es_guest(svm->vcpu.kvm)) {
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
> +	}
> +
> +	if (sev_es_guest(svm->vcpu.kvm)) {
> +		struct sev_es_save_area *save =3D svm->sev_es.vmsa;
> +
> +		intercept =3D !(save->sev_features & SVM_SEV_FEAT_DEBUG_SWAP);

Blech, the VMCB vs. SEV and SEV-ES code is a mess.  E.g. init_vmcb() does

	/*
	 * Guest access to VMware backdoor ports could legitimately
	 * trigger #GP because of TSS I/O permission bitmap.
	 * We intercept those #GP and allow access to them anyway
	 * as VMware does.  Don't intercept #GP for SEV guests as KVM can't
	 * decrypt guest memory to decode the faulting instruction.
	 */
	if (enable_vmware_backdoor && !sev_guest(vcpu->kvm))
		set_exception_intercept(svm, GP_VECTOR);

but then sev_es_init_vmcb() also does:

	/* No support for enable_vmware_backdoor */
	clr_exception_intercept(svm, GP_VECTOR);

DR interception is a similar trainwreck.  svm_sync_dirty_debug_regs() bails=
 if
guest_state_protected is true, i.e. is a nop for SEV-ES guests, but only af=
ter
the vCPU has done LAUNCH_UPDATE_VMSA.  IIUC, that's nonsensical because eve=
n before
guest state is encrypted, #DB will be reflected as #VC into the guest.  And=
, again
IIUC, except for DR7, DRs are never intercepted for SEV-ES guests and so tr=
ying
to debug from the host is futile as the guest can clobber DRs at any time.

Similarly, flowing into dr_interception() on an SEV-ES VMGEXITis just dumb.=
  KVM
_knows_ it can't give the guest control of DR7, but it mucks with the inter=
cepts
anyways.  That the GHCB spec even allows SVM_EXIT_{READ,WRITE}_DR7 is just =
asinine,
but that's a moot point.  Anyways, the GHCB spec's "suggestion" effectively=
 says
KVM's responsibility is purely to make a read of DR7 return the last writte=
n value.
And of course KVM's disaster of a flow doesn't even do that unless the host=
 is
debugging the guest.

  Currently, hardware debug traps aren=E2=80=99t supported for an SEV-ES gu=
est. The hypervisor
  must set the intercept for both read and write of the debug control regis=
ter (DR7).
  With the intercepts in place, the #VC handler will be invoked when the gu=
est accesses
  DR7. For a write to DR7, the #VC handler should perform Standard VMGExit =
processing.
  The #VC handler must not update the actual DR7 register, but rather it sh=
ould cache
  the DR7 value being written.

I bring this up because of the subtle dependency that checking SVM_SEV_FEAT=
_DEBUG_SWAP
creates: set_dr_intercepts() needs to be called after sev_init_vmcb().  I b=
elieve
this approach also fails to handle intrahost migration; at the very least, =
what
exactly will happen when sev_migrate_from() invokes sev_init_vmcb() is uncl=
ear.
And I really don't want to pile even more gunk on top of the existing mess.

So, can you (and by "you" I really mean "the folks at AMD working on SEV st=
uff")
start with the below diff (not intended to be a single patch), disallow
kvm_arch_vcpu_ioctl_set_guest_debug() entirely for SEV-ES guests (will like=
ly
take some back and forth to figure out how we want to do this), and then fi=
ll
in the blanks?  I.e. get KVM to a state where all the intercept shenanigans=
 for
SEV and SEV-ES are reasonably contained in sev.c, and then enable the debug=
_swap
stuff on top?

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c25aeb550cd9..ff7a4d68731c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2968,8 +2968,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
        svm_set_intercept(svm, TRAP_CR4_WRITE);
        svm_set_intercept(svm, TRAP_CR8_WRITE);
=20
-       /* No support for enable_vmware_backdoor */
-       clr_exception_intercept(svm, GP_VECTOR);
+       <debug register stuff goes here>
=20
        /* Can't intercept XSETBV, HV can't modify XCR0 directly */
        svm_clr_intercept(svm, INTERCEPT_XSETBV);
@@ -2996,6 +2995,12 @@ void sev_init_vmcb(struct vcpu_svm *svm)
        svm->vmcb->control.nested_ctl |=3D SVM_NESTED_CTL_SEV_ENABLE;
        clr_exception_intercept(svm, UD_VECTOR);
=20
+       /*
+        * Don't intercept #GP for SEV guests, e.g. for the VMware backdoor=
, as
+        * KVM can't decrypt guest memory to decode the faulting instructio=
n.
+        */
+       clr_exception_intercept(svm, GP_VECTOR);
+
        if (sev_es_guest(svm->vcpu.kvm))
                sev_es_init_vmcb(svm);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e0ec95f1f068..89753d7fd821 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1209,10 +1209,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
         * Guest access to VMware backdoor ports could legitimately
         * trigger #GP because of TSS I/O permission bitmap.
         * We intercept those #GP and allow access to them anyway
-        * as VMware does.  Don't intercept #GP for SEV guests as KVM can't
-        * decrypt guest memory to decode the faulting instruction.
+        * as VMware does.
         */
-       if (enable_vmware_backdoor && !sev_guest(vcpu->kvm))
+       if (enable_vmware_backdoor)
                set_exception_intercept(svm, GP_VECTOR);
=20
        svm_set_intercept(svm, INTERCEPT_INTR);
@@ -1950,7 +1949,7 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu=
 *vcpu)
 {
        struct vcpu_svm *svm =3D to_svm(vcpu);
=20
-       if (vcpu->arch.guest_state_protected)
+       if (WARN_ON_ONCE(sev_es_guest(vcpu->kvm)))
                return;
=20
        get_debugreg(vcpu->arch.db[0], 0);
@@ -2681,7 +2680,7 @@ static int dr_interception(struct kvm_vcpu *vcpu)
        unsigned long val;
        int err =3D 0;
=20
-       if (vcpu->guest_debug =3D=3D 0) {
+       if (vcpu->guest_debug =3D=3D 0 && !sev_es_guest(vcpu->kvm)) {
                /*
                 * No more DR vmexits; force a reload of the debug register=
s
                 * and reenter on this instruction.  The next vmexit will
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f44751dd8d5d..7c99a7d55476 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -409,23 +409,25 @@ static inline void set_dr_intercepts(struct vcpu_svm =
*svm)
 {
        struct vmcb *vmcb =3D svm->vmcb01.ptr;
=20
-       if (!sev_es_guest(svm->vcpu.kvm)) {
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
+       if (sev_es_guest(svm->vcpu.kvm)) {
+               WARN_ON_ONCE(svm->vcpu.arch.last_vmentry_cpu !=3D -1);
+               return;
        }
=20
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
=20
@@ -436,13 +438,13 @@ static inline void clr_dr_intercepts(struct vcpu_svm =
*svm)
 {
        struct vmcb *vmcb =3D svm->vmcb01.ptr;
=20
+       if (WARN_ON_ONCE(sev_es_guest(svm->vcpu.kvm)))
+               return;
+
        vmcb->control.intercepts[INTERCEPT_DR] =3D 0;
=20
-       /* DR7 access must remain intercepted for an SEV-ES guest */
-       if (sev_es_guest(svm->vcpu.kvm)) {
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
-       }
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
=20
        recalc_intercepts(svm);
 }

