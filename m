Return-Path: <kvm+bounces-1594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62B887E9B51
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 12:41:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C39C51F20FC4
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 11:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B431CFB5;
	Mon, 13 Nov 2023 11:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jSjzEU14"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEF21CF8B
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 11:41:33 +0000 (UTC)
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC54ED5A;
	Mon, 13 Nov 2023 03:41:31 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-1cc9b626a96so30066675ad.2;
        Mon, 13 Nov 2023 03:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699875691; x=1700480491; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RJOcKxY/4jYpsu60Q3/R+mkLUxZoZ7D2Hako2MnFh7w=;
        b=jSjzEU14qFTTXUboD1d0skJGRqvSJ7eShTifRYDZezyfTbBWLVQXcfzuTw3sMPOhb7
         I8bx2Y3pK1EYdQH8r5xh5WYpXtYzSAXjHhDm55D8qepXHwW9p3ibO43Fse5+dUPa7beN
         yaIl9mPUx+zFLH+AeaT6b+vKyMQYC27CYT1sW2qWSxC1xikhBvnC0XdBivIx6pK04bW0
         x/omr6zCK9Ou0bvLbz7fovooR56AEZdqOfpYlfA1ZSQr4gJOgH04+3VeuA/fAMS5S7kg
         BwShkQtAD/c7sqT7wNNK/tnH8D4TLfN9WPiyyq+1LUN8FL7wJEkCBnWfSzoAA6lEfs7R
         +I3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699875691; x=1700480491;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RJOcKxY/4jYpsu60Q3/R+mkLUxZoZ7D2Hako2MnFh7w=;
        b=dtprEX3cbgtH5ChJzGY6t7dCQICBQOWw+O6e7m1uZa54rSXC1D+IDmUeVNrn+9Pm6F
         8Oa2l/sxrgRThYuS7obpzNEQWP3ejhfJJtlJc8j5O4G8Y7hQAhuZTeNGLZrX6aZRie2Z
         BXDiEUcBzLp7EfloUUD2L6wIjEJfcL5sgNcp5QBA5cZvAEAJh0uCgLfjzx3qfuEPqy41
         IdbCKagYtY3XICrg4CtzjZFszyPC5jc3l1wQBITjId3sej3DpcdmQTxA1FmjCACOHFA4
         I9jOqh59Wb+ZBrY/ezNrTYdImQGvUq/YOsjnfWqac73p9jg011g6BobPAp2SEKND/BAh
         DbRQ==
X-Gm-Message-State: AOJu0YyheYtt+TWsyHKHFDDRQlYh53fHPJsIl3OFgyHM4a+/SVfCMSHU
	SIIOp5jNPZM62NCFIUmmlB4=
X-Google-Smtp-Source: AGHT+IGoa8qHU9EF/m+wMhM9JFnrTBMYngc4+JF0jPTxqHMKayFtFAPR77swRAnFUWWuDfTK35t6jA==
X-Received: by 2002:a17:902:da91:b0:1ca:7086:f009 with SMTP id j17-20020a170902da9100b001ca7086f009mr5728902plx.61.1699875690986;
        Mon, 13 Nov 2023 03:41:30 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ji17-20020a170903325100b001c9c97beb9csm3896209plb.71.2023.11.13.03.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Nov 2023 03:41:30 -0800 (PST)
Message-ID: <feb599ea-89e6-1dd9-ba71-3c3d1e027e06@gmail.com>
Date: Mon, 13 Nov 2023 19:41:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH v8 26/26] KVM: selftests: Extend PMU counters test to
 validate RDPMC after WRMSR
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi
 <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>,
 Jinrong Liang <ljr.kernel@gmail.com>, Jinrong Liang <cloudliang@tencent.com>
References: <20231110021306.1269082-1-seanjc@google.com>
 <20231110021306.1269082-27-seanjc@google.com>
From: Jinrong Liang <ljr.kernel@gmail.com>
In-Reply-To: <20231110021306.1269082-27-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2023/11/10 10:13, Sean Christopherson 写道:
> Extend the read/write PMU counters subtest to verify that RDPMC also reads
> back the written value.  Opportunsitically verify that attempting to use
> the "fast" mode of RDPMC fails, as the "fast" flag is only supported by
> non-architectural PMUs, which KVM doesn't virtualize.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../selftests/kvm/x86_64/pmu_counters_test.c  | 31 +++++++++++++++++++
>   1 file changed, 31 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index cb808ac827ba..248ebe8c0577 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -328,6 +328,7 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
>   static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
>   				 uint8_t nr_counters, uint32_t or_mask)
>   {
> +	const bool pmu_has_fast_mode = !guest_get_pmu_version();
>   	uint8_t i;
>   
>   	for (i = 0; i < nr_possible_counters; i++) {
> @@ -352,6 +353,7 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
>   		const uint64_t expected_val = expect_success ? test_val : 0;
>   		const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
>   				       msr != MSR_P6_PERFCTR1;
> +		uint32_t rdpmc_idx;
>   		uint8_t vector;
>   		uint64_t val;
>   
> @@ -365,6 +367,35 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
>   		if (!expect_gp)
>   			GUEST_ASSERT_PMC_VALUE(RDMSR, msr, val, expected_val);
>   
> +		rdpmc_idx = i;
> +		if (base_msr == MSR_CORE_PERF_FIXED_CTR0)
> +			rdpmc_idx |= INTEL_RDPMC_FIXED;
> +
> +		/* Redo the read tests with RDPMC, and with forced emulation. */
> +		vector = rdpmc_safe(rdpmc_idx, &val);
> +		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
> +		if (expect_success)
> +			GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
> +
> +		vector = rdpmc_safe_fep(rdpmc_idx, &val);
> +		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
> +		if (expect_success)
> +			GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
> +
> +		/*
> +		 * KVM doesn't support non-architectural PMUs, i.e. it should
> +		 * impossible to have fast mode RDPMC.  Verify that attempting
> +		 * to use fast RDPMC always #GPs.
> +		 */
> +		GUEST_ASSERT(!expect_success || !pmu_has_fast_mode);
> +		rdpmc_idx |= INTEL_RDPMC_FAST;
> +
> +		vector = rdpmc_safe(rdpmc_idx, &val);
> +		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, true, vector);
> +
> +		vector = rdpmc_safe_fep(rdpmc_idx, &val);
> +		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, true, vector);
> +
>   		vector = wrmsr_safe(msr, 0);
>   		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
>   	}
> 

This test case failed on my Intel machine.

Error message：
Testing arch events, PMU version 0, perf_caps = 0
Testing GP counters, PMU version 0, perf_caps = 0
==== Test Assertion Failure ====
   lib/x86_64/processor.c:1100: Unhandled exception in guest
   pid=464480 tid=464480 errno=4 - Interrupted system call
      1	0x00000000004120e1: assert_on_unhandled_exception 于 
processor.c:1146
      2	0x00000000004062d9: _vcpu_run 于 kvm_util.c:1634
      3	0x00000000004062fa: vcpu_run 于 kvm_util.c:1645
      4	0x0000000000403697: run_vcpu 于 pmu_counters_test.c:56
      5	0x00000000004026fc: test_gp_counters 于 pmu_counters_test.c:434
      6	(已内连入)test_intel_counters 于 pmu_counters_test.c:580
      7	(已内连入)main 于 pmu_counters_test.c:604
      8	0x00007f7a2f03ad84: ?? ??:0
      9	0x00000000004028bd: _start 于 ??:?
   Unhandled exception '0x6' at guest RIP '0x402bab'

