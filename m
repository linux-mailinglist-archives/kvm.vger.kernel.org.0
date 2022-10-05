Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53885F5CE8
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 00:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiJEWsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 18:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJEWsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 18:48:39 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D805140B
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 15:48:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t10-20020a17090a4e4a00b0020af4bcae10so2660268pjl.3
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 15:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=twbNYJqchKMNgXbwxJCoJk1EnyAPAy/qSqHKgoEI97s=;
        b=TP38Oqf0whNTium2uBFJwdVRJbJO4Nsk4mu7QE2uIKP1eLDqA4GAzvUAHleRnDip1L
         OscJhEpxV5lkockl3VcQCJsGX+s2ecahwrZxYsz+UUviazaBWGlUB4oDku1Qhq9m8JPM
         XOJXMDfVH92aQWaETZIhikpNS5eHaMGuUSCD9H3Z9/QiqcFR5zosG/9dMmatXmvijJkz
         zHhNlpVnufWhRCFgGZ1qgXFo6bH5p+QKHST+OxnsQPgOsT3Tt/POvd+CFRGdj0888AAe
         DMgiG5OY7/AV9Ne1LeEwk8BcwUqJqFcgTWLvOJYT6AhHArmQF+LSTQ1pE1vuioe4ImOc
         jbWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twbNYJqchKMNgXbwxJCoJk1EnyAPAy/qSqHKgoEI97s=;
        b=p5nMId52CwANKtW8xAE4Oglac93OxanQOkN4YSwL/bOWHL4vzHjclTQX9cIomAK8H9
         Kj10g3r3mXj4Aegn7CSL6B6Rl7lHBErBLWoKC5wAko5A3frrwnYvX0cwh+/ReBsWHTYw
         iXAI+D7nCNI6Ub5M62sfGLDqiOT5+ridkw4VsYD2cHeOKK+OKmaXQ/aMQhg6iYr1hgwA
         +wBmvmpbh+yRJkYSElgBuixDRC7LmJV2P6Yp6HTTsZVdFAB+KONIsOpVo+/+bqD53B4y
         b6pI00YhrPM4huiv1kGuUzlGcLKa/gx8GnxMCfA8+h6+Zw2BobLJ7rl+jYQwDDsoq5k2
         n2aQ==
X-Gm-Message-State: ACrzQf1X1O6T99Rt47TAQrrlICDQ7Cupn88yAkbUi+Ns2qXaOPxwhZCI
        aJZdl0cC9W/NxWg58RN4qu0/4g==
X-Google-Smtp-Source: AMsMyM77cRcph1rzldSpiXNSZedgsOFxiVnp73zo09dom9+ps+OvLz0tOqzAluTw4Tf6+DBjXrILhw==
X-Received: by 2002:a17:902:d2c3:b0:179:ff70:2a15 with SMTP id n3-20020a170902d2c300b00179ff702a15mr1622457plc.77.1665010118153;
        Wed, 05 Oct 2022 15:48:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f201-20020a6238d2000000b0052e987c64efsm9172774pfa.174.2022.10.05.15.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:48:37 -0700 (PDT)
Date:   Wed, 5 Oct 2022 22:48:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 13/13] x86/pmu: Update testcases to
 cover AMD PMU
Message-ID: <Yz4JwQcXIG+sQmp5@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-14-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819110939.78013-14-likexu@tencent.com>
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

On Fri, Aug 19, 2022, Like Xu wrote:
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 0324220..10bca27 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -793,6 +793,9 @@ static inline void flush_tlb(void)
>  
>  static inline u8 pmu_version(void)
>  {
> +	if (!is_intel())
> +		return 0;
> +
>  	return cpuid(10).a & 0xff;
>  }
>  
> @@ -806,19 +809,39 @@ static inline bool this_cpu_has_perf_global_ctrl(void)
>  	return pmu_version() > 1;
>  }
>  
> +#define AMD64_NUM_COUNTERS                             4
> +#define AMD64_NUM_COUNTERS_CORE                                6
> +
> +static inline bool has_amd_perfctr_core(void)
> +{
> +	return cpuid(0x80000001).c & BIT_ULL(23);

Add an X86_FEATURE_*, maybe X86_FEATURE_AMD_PERF_EXTENSIONS?

> +}
> +
>  static inline u8 pmu_nr_gp_counters(void)
>  {
> -	return (cpuid(10).a >> 8) & 0xff;
> +	if (is_intel()) {

No curly braces.

> +		return (cpuid(10).a >> 8) & 0xff;
> +	} else if (!has_amd_perfctr_core()) {

Drop the "else", the above "if" is terminal.

> +		return AMD64_NUM_COUNTERS;
> +	}
> +
> +	return AMD64_NUM_COUNTERS_CORE;
>  }
>  
>  static inline u8 pmu_gp_counter_width(void)
>  {
> -	return (cpuid(10).a >> 16) & 0xff;
> +	if (is_intel())
> +		return (cpuid(10).a >> 16) & 0xff;
> +	else
> +		return 48;

Please add a #define for this magic number.

>  }
>  
>  static inline u8 pmu_gp_counter_mask_length(void)
>  {
> -	return (cpuid(10).a >> 24) & 0xff;
> +	if (is_intel())
> +		return (cpuid(10).a >> 24) & 0xff;
> +	else
> +		return pmu_nr_gp_counters();
>  }
>  
>  static inline u8 pmu_nr_fixed_counters(void)
> @@ -843,6 +866,9 @@ static inline u8 pmu_fixed_counter_width(void)
>  
>  static inline bool pmu_gp_counter_is_available(int i)
>  {
> +	if (!is_intel())
> +		return i < pmu_nr_gp_counters();
> +
>  	/* CPUID.0xA.EBX bit is '1 if they counter is NOT available. */
>  	return !(cpuid(10).b & BIT(i));
>  }
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 0706cb1..b6ab10c 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -62,6 +62,11 @@ struct pmu_event {
>  	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
>  	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
>  	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
> +}, amd_gp_events[] = {
> +	{"core cycles", 0x0076, 1*N, 50*N},
> +	{"instructions", 0x00c0, 10*N, 10.2*N},
> +	{"branches", 0x00c2, 1*N, 1.1*N},
> +	{"branch misses", 0x00c3, 0, 0.1*N},
>  };
>  
>  #define PMU_CAP_FW_WRITES	(1ULL << 13)
> @@ -105,14 +110,24 @@ static bool check_irq(void)
>  
>  static bool is_gp(pmu_counter_t *evt)
>  {
> +	if (!is_intel())
> +		return true;
> +
>  	return evt->ctr < MSR_CORE_PERF_FIXED_CTR0 ||
>  		evt->ctr >= MSR_IA32_PMC0;
>  }
>  
>  static int event_to_global_idx(pmu_counter_t *cnt)
>  {
> -	return cnt->ctr - (is_gp(cnt) ? gp_counter_base :
> -		(MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
> +	if (is_intel())
> +		return cnt->ctr - (is_gp(cnt) ? gp_counter_base :
> +			(MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
> +
> +	if (gp_counter_base == MSR_F15H_PERF_CTR0) {

Unnecessary curly braces.

> +		return (cnt->ctr - gp_counter_base) / 2;
> +	} else {
> +		return cnt->ctr - gp_counter_base;
> +	}
>  }
>  
>  static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
> @@ -736,5 +783,11 @@ int main(int ac, char **av)
>  		report_prefix_pop();
>  	}
>  
> +	if (!is_intel()) {
> +		report_prefix_push("K7");
> +		amd_switch_to_non_perfctr_core();
> +		check_counters();

"K7" prefix needs to be popped.

> +	}
> +
>  	return report_summary();
>  }
> -- 
> 2.37.2
> 
