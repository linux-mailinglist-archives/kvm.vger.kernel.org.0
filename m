Return-Path: <kvm+bounces-67939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 21029D197B3
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 15:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EABB3306B776
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 14:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41F72BE644;
	Tue, 13 Jan 2026 14:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B+wyn6gB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815C42BE034
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 14:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768314611; cv=pass; b=QFnWWASYaAFAXoZI5CbODyjhn3lE0U9/fb5KIsTHhmm/QtpV8EEYzFRhvazvxywFJcY9QJ7EXB+yG/dgn8q9t4oQ7AMpuILPzjP0UAxg10w3/1vc7BXsurMjUetuB0kqW8IItZVOGZORixtr1TsZFJmeCWceA0Fi+CmZJfCEsDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768314611; c=relaxed/simple;
	bh=G5FodbqLvXK9tpyH66xlaj/l47vKj19iBm8mD+95DeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tbz66KWCsjwCKC9NS5ZrJ2/Nkc4smgyrHvg+bWRGst+Zt8EJaZ0wQPQAmejQDsQEn3tCsGBAeXPbcWbW3N22ROOnH8hyzMscDljFM/NXd3tta28r9FsyGqoABsknuXl632+Je7TTzlKJOuV97pQOLbCWwel3uYvM1PRhKTtD/IQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B+wyn6gB; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ee243b98caso450601cf.1
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 06:30:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768314607; cv=none;
        d=google.com; s=arc-20240605;
        b=HRTmcpNfjOt5wqlFl3gQB4xlp6Ts9czdWgMASZ+FyLFCKJpTaUvXgYaiy6PoUWlJsY
         pWtdGHT++8jTCn8tXTOoGDnlnRGjmLJuIdlwOvsJE8TfSRpV3bHvHkej9mlfrU1Mq8bD
         rqF3har1v6TufVZa2mIZ4YJiyn2J5xZYcU8Z6a84QJw4puRDnX5dI1VI4wDfuIptvfPD
         gIRuQFRN5qXDpblGwXubOagUpm8Qpg/4R01/LDmoUbpfS4DbIA/IbQATYV5y/RJ4lOYF
         NnqRVvEexnqN+tXjD4br+xjY/7r6oh3NntMEpz6anFv9idUERJTSHqOSOffzleghuU2w
         C0rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=b091E81/2unB3PJIE3JLMImmryguifLfk5JsrT4l5/A=;
        fh=wIM4K+p1gsLhBxbZ7HTmH1jnEANq9EfbFqLcri1N6HA=;
        b=Ac2XB477D8J8kI8J8/M1LLmqMTeX0zAEOKYN87C3i2qaLJZbaB9iFRM2uX8D0DuhGR
         Co8umgQGPDUzgSesGza3nJvg6ybYweGgedgmfzMSZPoZbvbfDM7F2zudbj66+WagqiQ5
         ITlytkj0PSh65I1TwIyJra62yxyNh1/FbDnfZjEREf0jVq9xBGsdeikY/kZ93DeNdU6k
         uI71INdm+W2KCCOB1V99hAIneCBKa8RYsQTxsqd36Ow+wslr9z0yjoICum88GK8KpE5/
         JZuezNBkOLfgEDVHYiZWPwQo7gR12Lfma4yThT+JZW4tUQMKchE/dP4k4M9clnesWrIb
         fFiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768314607; x=1768919407; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b091E81/2unB3PJIE3JLMImmryguifLfk5JsrT4l5/A=;
        b=B+wyn6gBeRVxtZ/U6WcHc9YOm2TCL+0bcnT/ZIa0YIUM6Ce/cG4R0gIuofmBsVwzfq
         mjKU5Vk3WK7lFJlUQ6pJJATqiXTeienDpdkviDulL25OjuyFu9WhpJw/ynaE11ekXc1y
         oYefzbYHfpwoP82mOQ/pmDHtwqZ8CgRmYeQeSUOimfOWQ+iV21cHE9iSXmckvv6Hf5Y0
         l23XQ+uQidUY3cfGHQGe68NE2QFAuT5GQXxrrmKMig5gTJeoivKRSkaYMyIJDbEvR8Cd
         gtC+2Qt2PoaJjwDY/oq0n+lgC/BlsEc+WfHq82GYlo+FPRXNSNdR/EaIIpBklTmeBiUR
         DSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768314607; x=1768919407;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b091E81/2unB3PJIE3JLMImmryguifLfk5JsrT4l5/A=;
        b=cO56l/Jzi0Rh8B//7hQ7ddDHdvb0Aq3x55EmDdiv2aC8s4Gg96vAlRoZO1TYO7vpy6
         pkeUM6uLVeDBXQnJMW5HsWNdMJKse3wIkp6DKRe6r4TBIJeeI33+Cs07N2W++a/pFmLi
         xJnl135T50dgreMkeb2HBaMZzhfkYpFMQW5uRt6i3mYDVDbcyA/djIbYZCT4PPAbXUH9
         dP+RwygGLTUf8Wc7ap4tdIcyp7WYJhKS3AnbozebaUw2kdERGsjHj2JlS5k698LIuY0e
         h4en6DUVfqbuqU9b6JSWJZGiFgpRWI/pKPlyX2I5uTjJ6yI5MnvUBS6GAXNN4wIPNW7M
         hZQA==
X-Forwarded-Encrypted: i=1; AJvYcCX3rPxPFVMEHf2JF3hF3owklpDgGG5q7/AoB88kEOjtos46PhMiuLbybMnpmr/vNtHv7+c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhoEuwRpBwPSqFkgHnBj0pYe0iTnsy8n87aa08BOcEK5Hhgeky
	cGT6n3y8vv4U0zzSG+ExdIPGTE9XnD5qJNjJOUcPEr6i7jSZaUAbt/zU7k4evDcjJZJjdWm5qUV
	DyoDqBLQsmkiZnZPx04Uo0tnlef3TC6FPgywjcizB
X-Gm-Gg: AY/fxX4sn4IF5sOjecLjfqIuFZZMqJKahk8V2ndDOWzsOgX9Yn3go2MY6OQpknmFGMP
	5HKwfxs2IpjCNMSmQZuTAchgctJ4F02i/r8LHwctBgXbIH8EklJQtgteBR9Rl2ih+Pyk1Kjy28t
	s4DBMuQixwg7UwuQtNM+FfkBrUm/uLeVcAWsY/R3AbRgTa2AJW4+shchAQW4vJNdyqzB43ZROKB
	VPU/Z6UIF8VmXwsGrREPkXgmcKoDyHq526M5flVRRG7a5sTIeH29X16fOxl3Epm0xcGpFrytexg
	xeokEqFlzE7ao7TdtjeiKz2Raw==
X-Received: by 2002:ac8:5ad4:0:b0:4f1:83e4:73be with SMTP id
 d75a77b69052e-5013b23e77amr10218591cf.15.1768314606872; Tue, 13 Jan 2026
 06:30:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-24-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-24-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 13 Jan 2026 14:29:30 +0000
X-Gm-Features: AZwV_Qi1BQ7vCKiwPSasBf7ZnHIRAUGyzNDOshXruUEpESYhIak7mxGtl8xsYqo
Message-ID: <CA+EHjTyL5gFQ8osKHaXQHa6327-HBJ4wvn6G2isDY3og4tCBKw@mail.gmail.com>
Subject: Re: [PATCH v9 24/30] KVM: arm64: Handle SME exceptions
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Dec 2025 at 01:23, Mark Brown <broonie@kernel.org> wrote:
>
> The access control for SME follows the same structure as for the base FP
> and SVE extensions, with control being via CPACR_ELx.SMEN and CPTR_EL2.TSM
> mirroring the equivalent FPSIMD and SVE controls in those registers. Add
> handling for these controls and exceptions mirroring the existing handling
> for FPSIMD and SVE.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  arch/arm64/kvm/handle_exit.c            | 14 ++++++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 11 ++++++-----
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  4 +++-
>  arch/arm64/kvm/hyp/vhe/switch.c         | 17 ++++++++++++-----
>  4 files changed, 35 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index cc7d5d1709cb..1e54d5d722e4 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -237,6 +237,19 @@ static int handle_sve(struct kvm_vcpu *vcpu)
>         return 1;
>  }
>
> +/*
> + * Guest access to SME registers should be routed to this handler only
> + * when the system doesn't support SME.
> + */
> +static int handle_sme(struct kvm_vcpu *vcpu)
> +{
> +       if (guest_hyp_sme_traps_enabled(vcpu))
> +               return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +
> +       kvm_inject_undefined(vcpu);
> +       return 1;
> +}
> +
>  /*
>   * Two possibilities to handle a trapping ptrauth instruction:
>   *
> @@ -390,6 +403,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>         [ESR_ELx_EC_SVC64]      = handle_svc,
>         [ESR_ELx_EC_SYS64]      = kvm_handle_sys_reg,
>         [ESR_ELx_EC_SVE]        = handle_sve,
> +       [ESR_ELx_EC_SME]        = handle_sme,
>         [ESR_ELx_EC_ERET]       = kvm_handle_eret,
>         [ESR_ELx_EC_IABT_LOW]   = kvm_handle_guest_abort,
>         [ESR_ELx_EC_DABT_LOW]   = kvm_handle_guest_abort,
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 5bcc72ae48ff..ad88cc7bd5d3 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -69,11 +69,8 @@ static inline void __activate_cptr_traps_nvhe(struct kvm_vcpu *vcpu)
>  {
>         u64 val = CPTR_NVHE_EL2_RES1 | CPTR_EL2_TAM | CPTR_EL2_TTA;
>
> -       /*
> -        * Always trap SME since it's not supported in KVM.
> -        * TSM is RES1 if SME isn't implemented.
> -        */
> -       val |= CPTR_EL2_TSM;
> +       if (!vcpu_has_sme(vcpu) || !guest_owns_fp_regs())
> +               val |= CPTR_EL2_TSM;
>
>         if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
>                 val |= CPTR_EL2_TZ;
> @@ -101,6 +98,8 @@ static inline void __activate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
>                 val |= CPACR_EL1_FPEN;
>                 if (vcpu_has_sve(vcpu))
>                         val |= CPACR_EL1_ZEN;
> +               if (vcpu_has_sme(vcpu))
> +                       val |= CPACR_EL1_SMEN;
>         }
>
>         if (!vcpu_has_nv(vcpu))
> @@ -142,6 +141,8 @@ static inline void __activate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
>                 val &= ~CPACR_EL1_FPEN;
>         if (!(SYS_FIELD_GET(CPACR_EL1, ZEN, cptr) & BIT(0)))
>                 val &= ~CPACR_EL1_ZEN;
> +       if (!(SYS_FIELD_GET(CPACR_EL1, SMEN, cptr) & BIT(0)))
> +               val &= ~CPACR_EL1_SMEN;
>
>         if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
>                 val |= cptr & CPACR_EL1_E0POE;
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index d3b9ec8a7c28..b2cba7c92b0f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -181,6 +181,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
>         [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15_32,
>         [ESR_ELx_EC_SYS64]              = kvm_hyp_handle_sysreg,
>         [ESR_ELx_EC_SVE]                = kvm_hyp_handle_fpsimd,
> +       [ESR_ELx_EC_SME]                = kvm_hyp_handle_fpsimd,
>         [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
>         [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
>         [ESR_ELx_EC_DABT_LOW]           = kvm_hyp_handle_dabt_low,
> @@ -192,7 +193,8 @@ static const exit_handler_fn pvm_exit_handlers[] = {
>         [0 ... ESR_ELx_EC_MAX]          = NULL,
>         [ESR_ELx_EC_SYS64]              = kvm_handle_pvm_sys64,
>         [ESR_ELx_EC_SVE]                = kvm_handle_pvm_restricted,
> -       [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
> +       [ESR_ELx_EC_SME]                = kvm_handle_pvm_restricted,
> +       [ESR_ELx_EC_FP_ASIMD]           = kvm_handle_pvm_restricted,
>         [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
>         [ESR_ELx_EC_DABT_LOW]           = kvm_hyp_handle_dabt_low,
>         [ESR_ELx_EC_WATCHPT_LOW]        = kvm_hyp_handle_watchpt_low,
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 9984c492305a..8449004bc24e 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -458,22 +458,28 @@ static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
>         return true;
>  }
>
> -static bool kvm_hyp_handle_zcr_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static bool kvm_hyp_handle_vec_cr_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>         u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
>
>         if (!vcpu_has_nv(vcpu))
>                 return false;
>
> -       if (sysreg != SYS_ZCR_EL2)
> +       switch (sysreg) {
> +       case SYS_ZCR_EL2:
> +       case SYS_SMCR_EL2:
> +               break;
> +       default:
>                 return false;
> +       }
>
>         if (guest_owns_fp_regs())
>                 return false;
>
>         /*
> -        * ZCR_EL2 traps are handled in the slow path, with the expectation
> -        * that the guest's FP context has already been loaded onto the CPU.
> +        * ZCR_EL2 and SMCR_EL2 traps are handled in the slow path,
> +        * with the expectation that the guest's FP context has
> +        * already been loaded onto the CPU.
>          *
>          * Load the guest's FP context and unconditionally forward to the
>          * slow path for handling (i.e. return false).
> @@ -493,7 +499,7 @@ static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
>         if (kvm_hyp_handle_cpacr_el1(vcpu, exit_code))
>                 return true;
>
> -       if (kvm_hyp_handle_zcr_el2(vcpu, exit_code))
> +       if (kvm_hyp_handle_vec_cr_el2(vcpu, exit_code))
>                 return true;
>
>         return kvm_hyp_handle_sysreg(vcpu, exit_code);
> @@ -522,6 +528,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
>         [0 ... ESR_ELx_EC_MAX]          = NULL,
>         [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15_32,
>         [ESR_ELx_EC_SYS64]              = kvm_hyp_handle_sysreg_vhe,
> +       [ESR_ELx_EC_SME]                = kvm_hyp_handle_fpsimd,
>         [ESR_ELx_EC_SVE]                = kvm_hyp_handle_fpsimd,
>         [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
>         [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
>
> --
> 2.47.3
>

