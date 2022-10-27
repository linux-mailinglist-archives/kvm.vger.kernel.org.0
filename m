Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C0E610542
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbiJ0WAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiJ0WAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:00:47 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6E496386
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:00:46 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so2814718pji.0
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MXffiWnH99SMFrqiFAZSNGNJ0zOyntO6kbisZPweKSs=;
        b=UsZVywI3MpcUOplhRY4ydzQmEYAovc/eD+UQmsU2vFrAG99yGETWH/jkapynqA6+4l
         VlUptj+dUPMHnPoHU+BPAWOgAOforxnFaD04N1GSgUYL1f/AKn72DQdBrXzhL1mp8vYa
         or990m4JIbF2cWfd66D9jcY+jMbgKIxLOjSbRuEz5FoA8sH1M3jcy//juufdfp+OJM7u
         FTmZEK8MXK7UzUrm0OLBTlScU8AleiRi+ix9iTkmaGGRRFlWazFm5nM9KI12K9NfbIcN
         Jl+XbE3v5px2YszRQf47mKo0rXzUWx3wrS+K09rrPzCDXjEH3/Ej7muCiQkbWsaesZYq
         pm6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MXffiWnH99SMFrqiFAZSNGNJ0zOyntO6kbisZPweKSs=;
        b=8ANAOB25S2mG1dXzQAAailzsmDoFq44foi8SOJLzDOMLTdHBaPvznUkYoy5f4qzn+b
         jUkY3TVBW1AYYVvrCn0vjsFrkSdC3t0TaVTlaMWW1QMr9HFc//Lg9r+hUNuA7IY5llWB
         1eBHSWO73D+0iSMTt8+08p71BxFNUjQFH2TL3nGNUz6GSoa76GQbkEWshlD7gD1K9JP/
         kBNp6SD4unb6dqFU0NOyCR1HBqCdYIKs+G6UeyObazL/qqD9+IV9BVQb0HH/sexax1xE
         3uzttKXx+VkpkHfywFqkJJnoMK6G0cspNTu9BIqB0O9mSxRL6a+TyVQVpIDG/tK1ohqP
         GmEQ==
X-Gm-Message-State: ACrzQf0QlU7ZIZqueHD1iVT14X+aG1T3tP6nzu07TkDEnTXdYZpyA8CL
        jaYUtfw6ECGCMp0ENu2D5/eV7iLS2QOwmQ==
X-Google-Smtp-Source: AMsMyM5oxVkyZXuonvNaewoIn+fdo3U9uB+ALSHa7emyB4FWjcZTegyGYjd0ZWm3kDoKVc9SG2jnZg==
X-Received: by 2002:a17:90b:4a84:b0:20d:8953:5ab0 with SMTP id lp4-20020a17090b4a8400b0020d89535ab0mr12704552pjb.48.1666908046168;
        Thu, 27 Oct 2022 15:00:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m15-20020a17090a158f00b00212d4c50647sm3041584pja.36.2022.10.27.15.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 15:00:45 -0700 (PDT)
Date:   Thu, 27 Oct 2022 22:00:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v6 7/7] selftests: kvm/x86: Test masked events
Message-ID: <Y1r/irLSRTZPq7nE@google.com>
References: <20221021205105.1621014-1-aaronlewis@google.com>
 <20221021205105.1621014-8-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021205105.1621014-8-aaronlewis@google.com>
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

On Fri, Oct 21, 2022, Aaron Lewis wrote:
> ---
>  .../kvm/x86_64/pmu_event_filter_test.c        | 344 +++++++++++++++++-
>  1 file changed, 342 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 0750e2fa7a38..926c449aac78 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -442,6 +442,337 @@ static bool use_amd_pmu(void)
>  		 is_zen3(entry->eax));
>  }
>  
> +/*
> + * "MEM_INST_RETIRED.ALL_LOADS", "MEM_INST_RETIRED.ALL_STORES", and
> + * "MEM_INST_RETIRED.ANY" from https://perfmon-events.intel.com/
> + * supported on Intel Xeon processors:
> + *  - Sapphire Rapids, Ice Lake, Cascade Lake, Skylake.
> + */
> +#define MEM_INST_RETIRED		0xD0
> +#define MEM_INST_RETIRED_LOAD		EVENT(MEM_INST_RETIRED, 0x81)
> +#define MEM_INST_RETIRED_STORE		EVENT(MEM_INST_RETIRED, 0x82)
> +#define MEM_INST_RETIRED_LOAD_STORE	EVENT(MEM_INST_RETIRED, 0x83)
> +
> +static bool supports_event_mem_inst_retired(void)
> +{
> +	uint32_t eax, ebx, ecx, edx;
> +
> +	cpuid(1, &eax, &ebx, &ecx, &edx);
> +	if (x86_family(eax) == 0x6) {
> +		switch (x86_model(eax)) {
> +		/* Sapphire Rapids */
> +		case 0x8F:

I'm not sure which is worse, open coding, or turbostat's rather insane include
shenanigans.

  tools/power/x86/turbostat/Makefile:override CFLAGS +=   -DINTEL_FAMILY_HEADER='"../../../../arch/x86/include/asm/intel-family.h"'
  tools/power/x86/turbostat/turbostat.c:#include INTEL_FAMILY_HEADER

As a follow-up, can you look into copying arch/x86/include/asm/intel-family.h
into tools/arch/x86/include/asm/ and using the #defines here?

> +		/* Ice Lake */
> +		case 0x6A:
> +		/* Skylake */
> +		/* Cascade Lake */
> +		case 0x55:
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +static int num_gp_counters(void)
> +{
> +	const struct kvm_cpuid_entry2 *entry;
> +
> +	entry = kvm_get_supported_cpuid_entry(0xa);
> +	union cpuid10_eax eax = { .full = entry->eax };
> +
> +	return eax.split.num_counters;

Rock-Paper-Scissors, loser has to handle the merge conflict? :-)

https://lore.kernel.org/all/20221006005125.680782-10-seanjc@google.com

> +static uint64_t masked_events_guest_test(uint32_t msr_base)
> +{
> +	uint64_t ld0, ld1, st0, st1, ls0, ls1;
> +	struct perf_counter c;
> +	int val;

A comment here to call out that the counts don't need to be exact would be helpful,
i.e. that the goal is purely to ensure a non-zero count when the event is allowed.
My initial reaction was that this code would be fragile, e.g. if the compiler
throws in extra loads/stores, but the count is a pure pass/fail (which is a very
good thing).

> +	ld0 = rdmsr(msr_base + 0);
> +	st0 = rdmsr(msr_base + 1);
> +	ls0 = rdmsr(msr_base + 2);
> +
> +	__asm__ __volatile__("movl $0, %[v];"
> +			     "movl %[v], %%eax;"
> +			     "incl %[v];"
> +			     : [v]"+m"(val) :: "eax");
> +
> +	ld1 = rdmsr(msr_base + 0);
> +	st1 = rdmsr(msr_base + 1);
> +	ls1 = rdmsr(msr_base + 2);
> +
> +	c.loads = ld1 - ld0;
> +	c.stores = st1 - st0;
> +	c.loads_stores = ls1 - ls0;
> +
> +	return c.raw;

