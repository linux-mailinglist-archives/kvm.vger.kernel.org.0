Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB7B664594
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 17:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbjAJQGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 11:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbjAJQFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 11:05:30 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF685C4A;
        Tue, 10 Jan 2023 08:05:28 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1D7DD1EC05F1;
        Tue, 10 Jan 2023 17:05:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673366727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=KoTc3COLjlM3JIN7L4+YuzmHqsIzPz2//77xFuiUH5g=;
        b=n25yncwbwSkh0JTwEymRYcujCpeAOpfD17Ih889ja8Ov/esVqiwFuK4iS7bvZGpaFuqKDS
        d1oOM6I3Xmd4gQdViKM2Tobq+XtW3v6DuD/uDQRIwBlmbhNtEAOZ8MhbAQca7rBBu595uv
        rS86SbyOR4y/LEYvaH3rwz7nwTvJnfI=
Date:   Tue, 10 Jan 2023 17:05:21 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel v2 1/3] x86/amd: Cache values in percpu variables
Message-ID: <Y72MwWB+Nsphjqs8@zn.tnic>
References: <20221209043804.942352-1-aik@amd.com>
 <20221209043804.942352-2-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221209043804.942352-2-aik@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 03:38:02PM +1100, Alexey Kardashevskiy wrote:

Make that Subject:

"x86/amd: Cache debug register values in percpu variables"

to make it less generic and more specific as to what you're doing.

> Reading DR[0-3]_ADDR_MASK MSRs takes about 250 cycles which is going to
> be noticeable with the AMD KVM SEV-ES DebugSwap feature enabled.
> KVM is going to store host's DR[0-3] and DR[0-3]_ADDR_MASK before
> switching to a guest; the hardware is going to swap these on VMRUN
> and VMEXIT.
> 
> Store MSR values passsed to set_dr_addr_mask() in percpu values

s/values/variables/

Unknown word [passsed] in commit message.

Use a spellchecker pls.

> (when changed) and return them via new amd_get_dr_addr_mask().
> The gain here is about 10x.

10x when reading percpu vars vs MSR reads?

Oh well.

> As amd_set_dr_addr_mask() uses the array too, change the @dr type to
> unsigned to avoid checking for <0.

I feel ya but that function will warn once, return 0 when the @dr number is
outta bounds and that 0 will still get used as an address mask.

I think you really wanna return negative on error and the caller should not
continue in that case.

> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index c75d75b9f11a..9ac5a19f89b9 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -1158,24 +1158,41 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
>  	return false;
>  }
>  
> -void set_dr_addr_mask(unsigned long mask, int dr)
> +DEFINE_PER_CPU_READ_MOSTLY(unsigned long[4], amd_dr_addr_mask);

static

> +
> +static unsigned int amd_msr_dr_addr_masks[] = {
> +	MSR_F16H_DR0_ADDR_MASK,
> +	MSR_F16H_DR1_ADDR_MASK - 1 + 1,

- 1 + 1 ?

Why?

Because of the DR0 and then DR1 being in a different MSR range?

Who cares, make it simple:

	MSR_F16H_DR0_ADDR_MASK,
	MSR_F16H_DR1_ADDR_MASK,
	MSR_F16H_DR1_ADDR_MASK + 1,
	MSR_F16H_DR1_ADDR_MASK + 2

and add a comment if you want to denote the non-contiguous range but meh.

> +	MSR_F16H_DR1_ADDR_MASK - 1 + 2,
> +	MSR_F16H_DR1_ADDR_MASK - 1 + 3
> +};
> +
> +void set_dr_addr_mask(unsigned long mask, unsigned int dr)
>  {
> -	if (!boot_cpu_has(X86_FEATURE_BPEXT))
> +	if (!cpu_feature_enabled(X86_FEATURE_BPEXT))
>  		return;
>  
> -	switch (dr) {
> -	case 0:
> -		wrmsr(MSR_F16H_DR0_ADDR_MASK, mask, 0);
> -		break;
> -	case 1:
> -	case 2:
> -	case 3:
> -		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
> -		break;
> -	default:
> -		break;
> -	}
> +	if (WARN_ON_ONCE(dr >= ARRAY_SIZE(amd_msr_dr_addr_masks)))
> +		return;
> +
> +	if (per_cpu(amd_dr_addr_mask, smp_processor_id())[dr] == mask)

Do that at function entry:

	int cpu = smp_processor_id();

and use cpu here.

> +		return;
> +
> +	wrmsr(amd_msr_dr_addr_masks[dr], mask, 0);
> +	per_cpu(amd_dr_addr_mask, smp_processor_id())[dr] = mask;
> +}

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
