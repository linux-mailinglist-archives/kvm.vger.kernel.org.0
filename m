Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38489718AF4
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 22:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjEaUSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 16:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjEaUSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 16:18:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF812136
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 13:18:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8337a5861so498433276.0
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 13:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685564316; x=1688156316;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j5CyWTyXiTfBViz6Sxmw35acpjPcVQ4sSxA5nz2qzkI=;
        b=SEXNJgwV5AiJNIWuh6lBiAmkE3bbsj5MxzsZAn+uYlfZWd+MhGl+kUnQj4F/tjnR+E
         VbaQ0gNSGssZoTxaLJ/diKcpfpZAJzn/rlADk5OVxNwgcvQivpw4n19DrHl8uU9kBNMI
         yifWIJFy4c05UPBT9oyREY0jbxBla+4I5u/v8RhpQAXNLvpuSBvEdAQmIrx55XsOxqOh
         n1cdBZcNOEsdmxIDOafumO1brg7hIFGY6tYALMPs3ngJNYNHUbTAEy1R+dvK1kM7/+5H
         wutxNj2EZx7+rErSdhYAzgo+Y/leNUgVYGNd+kSSI84XhFf2QeW/H0cQFpDzXgE/Pg4U
         XP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685564316; x=1688156316;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j5CyWTyXiTfBViz6Sxmw35acpjPcVQ4sSxA5nz2qzkI=;
        b=GTtDipvXtQIgxcqdjYt9xhoK6G7BDei5S2PafBFILwMGc9g3ma7rhqyBZ929G3ZRov
         puMxCPMiBCf4VBwPBmFvimHPkdYknb70Fb6z9N44liepBQ/mjBeLHz4YB+3iC5pkkNRj
         fMd+Pnn2hMSxsNMnVy9a8mydEjpYxNuL/8ZfB7Bxeqx/2Ip2EkF/baOFjjKI6vDN6w5W
         S8G4u8lvoPCC+ArFIR+0NJJHtVbxAvLY3K3Yx0rw0lLbODA89XBlSAkeGsIa+Q/KNV1d
         nU8NQv5GBCRcHHaBrdty7OmLwbc9eREaMSlJDfrt1dirM9vNsQ/DUzW6inzRcSCcIxJF
         uxQg==
X-Gm-Message-State: AC+VfDwKDOFTBWCM02cRBv05r8BAfD8DBEuBxyxiTo5ahD1D4X7hJi8y
        1QgujBNREoBNCWn+3+iFXJBQg2CPWZc=
X-Google-Smtp-Source: ACHHUZ45I9uA8dYRlS7sdsD4AC1X9R0cpZ8hPCWp1InPW1kv/LWxrQezg2ZD1CsX0Jmb0fTO/coj8PfeXUM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dc10:0:b0:bac:b91c:511b with SMTP id
 y16-20020a25dc10000000b00bacb91c511bmr8792287ybe.2.1685564315865; Wed, 31 May
 2023 13:18:35 -0700 (PDT)
Date:   Wed, 31 May 2023 20:18:34 +0000
In-Reply-To: <E17EFDD7-C54A-4532-B1D3-D567557FC54B@nutanix.com>
Mime-Version: 1.0
References: <20230530200152.18961-1-jon@nutanix.com> <2a6502e3-ba87-0355-af09-825e8467b81f@intel.com>
 <F4AFC5EE-9967-4117-BA85-ED82C106575C@nutanix.com> <ZHd2P6D142rCByrm@google.com>
 <E17EFDD7-C54A-4532-B1D3-D567557FC54B@nutanix.com>
Message-ID: <ZHermsSGQBcDD07R@google.com>
Subject: Re: [PATCH] x86/fpu/xstate: clear XSAVE features if DISABLED_MASK set
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Kyle Huey <me@kylehuey.com>,
        "neelnatu@google.com" <neelnatu@google.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023, Jon Kohler wrote:
>=20
> > On May 31, 2023, at 12:30 PM, Sean Christopherson <seanjc@google.com> w=
rote:
> > Caveat #1: cpu_feature_enabled() has a flaw that's relevant to this cod=
e: in the
> > unlikely scenario that the compiler doesn't resolve "cid" to a compile-=
time
> > constant value, cpu_feature_enabled() won't query DISABLED_MASK_BIT_SET=
().  I don't
> > see any other use of cpu_feature_enabled() without a hardcoded X86_FEAT=
URE_*, and
> > the below compiles with my config, so I think/hope we can just require =
a compile-time
> > constant when using cpu_feature_enabled().
> >=20
>=20
> Yea I think that should work. I=E2=80=99ll club that into v2 of this patc=
h.

I recommend doing it as a separate patch, hardening cpu_feature_enabled() s=
houldn't
have a dependency on tweaking the xfeatures mask.  I tested this with an al=
lyesconfig
if you want to throw it in as a prep patch.

---
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 31 May 2023 09:41:12 -0700
Subject: [PATCH] x86/cpufeature: Require compile-time constant in
 cpu_feature_enabled()

Assert that the to-be-checked bit passed to cpu_feature_enabled() is a
compile-time constant instead of applying the DISABLED_MASK_BIT_SET()
logic if and only if the bit is a constant.  Conditioning the check on
the bit being constant instead of requiring the bit to be constant could
result in compiler specific kernel behavior, e.g. running on hardware that
supports a disabled feature would return %false if the compiler resolved
the bit to a constant, but %true if not.

All current usage of cpu_feature_enabled() specifies a hardcoded
X86_FEATURE_* flag, so this *should* be a glorified nop.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/cpufeature.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufe=
ature.h
index ce0c8f7d3218..886200fbf8d9 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -141,8 +141,11 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
  * supporting a possible guest feature where host support for it
  * is not relevant.
  */
-#define cpu_feature_enabled(bit)	\
-	(__builtin_constant_p(bit) && DISABLED_MASK_BIT_SET(bit) ? 0 : static_cpu=
_has(bit))
+#define cpu_feature_enabled(bit) 				\
+({								\
+	BUILD_BUG_ON(!__builtin_constant_p(bit));		\
+	DISABLED_MASK_BIT_SET(bit) ? 0 : static_cpu_has(bit);	\
+})
=20
 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
=20

base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f
--=20

> > I'm totally ok gating xfeature bits on cpu_feature_enabled(), but there=
 should be
> > a prep patch for KVM to clear features bits in kvm_cpu_caps if the corr=
esponding
> > XCR0/XSS bit is not set in the host.  If KVM ever wants to expose an xs=
tate feature
> > (other than MPX) that's disabled in the host, then we can revisit
> > fpu__init_system_xstate().  But we need to ensure the "failure" mode is=
 that
> > KVM doesn't advertise the feature, as opposed to advertising a feature =
without
> > without context switching its data.
>=20
>=20
> Looking into this, trying to understand the comment about a feature being=
 used
> without context switching its data.=20
>=20
> In __kvm_x86_vendor_init() we=E2=80=99re already populating host_xcr0 usi=
ng the=20
> XCR_XFEATURE_ENABLED_MASK, which should be populated on boot
> by fpu__init_cpu_xstate(), which happens almost immediately after the cod=
e that I
> modified in this commit.=20
>=20
> That then flows into guest_supported_xcr0 (as well as user_xfeatures).=20
> guest_supported_xcr0 is then plumbed into __kvm_set_xcr, which specifical=
ly says
> that we=E2=80=99re using that to prevent the guest from setting bits that=
 we won=E2=80=99t save in the
> first place.
>=20
>     /*
>      * Do not allow the guest to set bits that we do not support
>      * saving.  However, xcr0 bit 0 is always set, even if the
>      * emulated CPU does not support XSAVE (see kvm_vcpu_reset()).
>      */
>     valid_bits =3D vcpu->arch.guest_supported_xcr0 | XFEATURE_MASK_FP;
>=20
> Wouldn=E2=80=99t this mean that the *guest* xstate initialization would n=
ot see a given
> feature too and take care of the problem naturally?
>=20
> Or are you saying you=E2=80=99d want an even more detailed clearing?

The CPUID bits that enumerate support for a feature are independent from th=
e CPUID
bits that enumerate what XCR0 bits are supported, i.e. what features can be=
 saved
and restored via XSAVE/XRSTOR.

KVM does mostly account for host XCR0, but in a very ad hoc way.  E.g. MPX =
is
handled by manually checking host XCR0.

	if (kvm_mpx_supported())
		kvm_cpu_cap_check_and_set(X86_FEATURE_MPX);

PKU manually checks too, but indirectly by looking at whether or not the ke=
rnel
has enabled CR4.OSPKE.

	if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
		kvm_cpu_cap_clear(X86_FEATURE_PKU);

But unless I'm missing something, the various AVX and AMX bits rely solely =
on
boot_cpu_data, i.e. would break if someone added CONFIG_X86_AVX or CONFIG_X=
86_AMX.
