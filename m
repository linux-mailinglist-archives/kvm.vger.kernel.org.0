Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C291E74D3DB
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 12:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjGJKu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 06:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjGJKuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 06:50:25 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A994D2;
        Mon, 10 Jul 2023 03:50:24 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-3a3efebcc24so2213454b6e.1;
        Mon, 10 Jul 2023 03:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688986223; x=1691578223;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8QS0QHZRgc0yC1/wavz49ZTrauQCkwXgMIynLbUS5Pg=;
        b=jsxoJ/6AfM2z2Jbi7Qxnqr48oyHIlZ9VjUHuHNIV+7TcbyKQXms47bWClT+4DXMXs0
         ir25EdDrrhrUXpNf8Ri9ekQsCOGVT06Yry7jHX9JxLUC3Y0ApM/RZKNf8U21Pi4cJLGr
         7PKMP622+mGSa+zBYOGSGBZ2qvGiIy7bQm9w/MUvlVy32Gr5GuUOyOFxxKIRp1angeP1
         JO1jPyNsfkMy0RjnV3bN2B10nR20vRHcM7ZfeMT+twuaqBRWpwCRR8MF6PB8aM/LOiPM
         J72R+WjWSUztBZpwAWveQ7iLcJGpApDh8z8JFL4aGqVoywVoNIQ1Ku6Ftgf4lnDaI4Na
         45PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688986223; x=1691578223;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8QS0QHZRgc0yC1/wavz49ZTrauQCkwXgMIynLbUS5Pg=;
        b=UPM/W/wYNpGV7vX96L/Wb8LTBdqDbaE2KzpH1+kBxnPMsVsfvfmtu7m22+QkiRFR4c
         gvotcyn3qLT2ilATkiDcLWMSPAS5mk/f/EiDdiB0MSWN59Bxu1PgBP0Vt7RDIbrnDixI
         bmJc2s16uaraJp9g8Y+vV9tvRo9R1o70thrdL7GoJlB39HAxSfv4V+zoMOtM10QEhMO+
         s2m1qlCWZTDVQNDbbMHUYEd2qNDZ8ylJVKG7/n6ayYe7fxqoknCEcZ+mSrUaiEIgVsHE
         5/5UYeGS2LU+vnrl/S6SZFU17iDiRn6ppDeZGjXXCT+llrdMeoqPMXfQd9tP2RTyploF
         LY4w==
X-Gm-Message-State: ABy/qLblgVthjL7+wpdMqa/XkcWPuvv6cHB/NdpodoiICGxW/ddW1atO
        nv7Rg117EqwvhDIt1xj+4KI=
X-Google-Smtp-Source: APBJJlFqnB63ihfW/DUgKSDNLUVzZfipGKab2dVzGYJcz8uy6FOtbPAf7l733Fivfw47cV4QHQHDKw==
X-Received: by 2002:a05:6358:2905:b0:134:ec26:b53 with SMTP id y5-20020a056358290500b00134ec260b53mr10481644rwb.16.1688986223148;
        Mon, 10 Jul 2023 03:50:23 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r23-20020a62e417000000b006661562429fsm7079151pfh.97.2023.07.10.03.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jul 2023 03:50:22 -0700 (PDT)
Message-ID: <6def6249-bd36-875c-6faf-e4685b8c3fde@gmail.com>
Date:   Mon, 10 Jul 2023 18:50:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH 1/4] KVM: x86/pmu: Use enums instead of hardcoded magic
 for arch event indices
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230607010206.1425277-1-seanjc@google.com>
 <20230607010206.1425277-2-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230607010206.1425277-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/6/2023 9:02 am, Sean Christopherson wrote:
> Add "enum intel_pmu_architectural_events" to replace the magic numbers for
> the (pseudo-)architectural events, and to give a meaningful name to each
> event so that new readers don't need psychic powers to understand what the
> code is doing.
> 
> Cc: Aaron Lewis <aaronlewis@google.com>
> Cc: Like Xu <like.xu.linux@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Like Xu <likexu@tencent.com>
// I should have done it. Thanks.

> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 55 ++++++++++++++++++++++++++++--------
>   1 file changed, 43 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 84be32d9f365..0050d71c9c01 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -22,23 +22,51 @@
>   
>   #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
>   
> +enum intel_pmu_architectural_events {
> +	/*
> +	 * The order of the architectural events matters as support for each
> +	 * event is enumerated via CPUID using the index of the event.
> +	 */
> +	INTEL_ARCH_CPU_CYCLES,
> +	INTEL_ARCH_INSTRUCTIONS_RETIRED,
> +	INTEL_ARCH_REFERENCE_CYCLES,
> +	INTEL_ARCH_LLC_REFERENCES,
> +	INTEL_ARCH_LLC_MISSES,
> +	INTEL_ARCH_BRANCHES_RETIRED,
> +	INTEL_ARCH_BRANCHES_MISPREDICTED,
> +
> +	NR_REAL_INTEL_ARCH_EVENTS,
> +
> +	/*
> +	 * Pseudo-architectural event used to implement IA32_FIXED_CTR2, a.k.a.
> +	 * TSC reference cycles.  The architectural reference cycles event may
> +	 * or may not actually use the TSC as the reference, e.g. might use the
> +	 * core crystal clock or the bus clock (yeah, "architectural").
> +	 */
> +	PSEUDO_ARCH_REFERENCE_CYCLES = NR_REAL_INTEL_ARCH_EVENTS,
> +	NR_INTEL_ARCH_EVENTS,
> +};
> +
>   static struct {
>   	u8 eventsel;
>   	u8 unit_mask;
>   } const intel_arch_events[] = {
> -	[0] = { 0x3c, 0x00 },
> -	[1] = { 0xc0, 0x00 },
> -	[2] = { 0x3c, 0x01 },
> -	[3] = { 0x2e, 0x4f },
> -	[4] = { 0x2e, 0x41 },
> -	[5] = { 0xc4, 0x00 },
> -	[6] = { 0xc5, 0x00 },
> -	/* The above index must match CPUID 0x0A.EBX bit vector */
> -	[7] = { 0x00, 0x03 },
> +	[INTEL_ARCH_CPU_CYCLES]			= { 0x3c, 0x00 },
> +	[INTEL_ARCH_INSTRUCTIONS_RETIRED]	= { 0xc0, 0x00 },
> +	[INTEL_ARCH_REFERENCE_CYCLES]		= { 0x3c, 0x01 },
> +	[INTEL_ARCH_LLC_REFERENCES]		= { 0x2e, 0x4f },
> +	[INTEL_ARCH_LLC_MISSES]			= { 0x2e, 0x41 },
> +	[INTEL_ARCH_BRANCHES_RETIRED]		= { 0xc4, 0x00 },
> +	[INTEL_ARCH_BRANCHES_MISPREDICTED]	= { 0xc5, 0x00 },
> +	[PSEUDO_ARCH_REFERENCE_CYCLES]		= { 0x00, 0x03 },
>   };
>   
>   /* mapping between fixed pmc index and intel_arch_events array */
> -static int fixed_pmc_events[] = {1, 0, 7};
> +static int fixed_pmc_events[] = {
> +	[0] = INTEL_ARCH_INSTRUCTIONS_RETIRED,
> +	[1] = INTEL_ARCH_CPU_CYCLES,
> +	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
> +};
>   
>   static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>   {
> @@ -92,13 +120,16 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
>   	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>   	int i;
>   
> -	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++) {
> +	BUILD_BUG_ON(ARRAY_SIZE(intel_arch_events) != NR_INTEL_ARCH_EVENTS);
> +
> +	for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++) {
>   		if (intel_arch_events[i].eventsel != event_select ||
>   		    intel_arch_events[i].unit_mask != unit_mask)
>   			continue;
>   
>   		/* disable event that reported as not present by cpuid */
> -		if ((i < 7) && !(pmu->available_event_types & (1 << i)))
> +		if ((i < PSEUDO_ARCH_REFERENCE_CYCLES) &&
> +		    !(pmu->available_event_types & (1 << i)))

CHECK: Unnecessary parentheses around 'i < PSEUDO_ARCH_REFERENCE_CYCLES'
#164: FILE: arch/x86/kvm/vmx/pmu_intel.c:131:
+		if ((i < PSEUDO_ARCH_REFERENCE_CYCLES) &&
+		    !(pmu->available_event_types & (1 << i)))

>   			return false;
>   
>   		break;
