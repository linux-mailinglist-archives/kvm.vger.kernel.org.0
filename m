Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71875670B17
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 23:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjAQWCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 17:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjAQWA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 17:00:28 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7884ABE6
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:45:05 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id a14-20020a17090a70ce00b00229a2f73c56so67561pjm.3
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oWKAPx0Pojcsg+fK1nAbVjmM94b5PDw5fwkVwu0Em3I=;
        b=hx4XaEC7ewSxO6NSCQSemOZrqGPFrRekc6QcTvrp5uzd2sSGCr++fpgMqkpc0dqDhZ
         Ew9HHubd6+OtdqEFHBiBjHDNBdf3PvNedhfwQyHEQhm0gdcsq27Cf72lPuXXvUWbqDa6
         2VAQSK8+tfpgNQ3b3pDChP94k8oz25X7ZFnwF34glw3MtAkdi/H/t9LrkVkuiwtMVrqY
         mlICZKHXR5yOP/q9I5c7ffDYT+y4JeeZ0eXoMzyTBCytWIWjn6NeuG6ZTZHUmAfdr3ye
         TJQcUfC3rPRINXe9SdGUAEC0B06c359JWsBQDwPrCtMeolqZXeOeAoxVPQLOqYXxyHtB
         j4ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWKAPx0Pojcsg+fK1nAbVjmM94b5PDw5fwkVwu0Em3I=;
        b=iGXqhK6aoDeLED/CySU4PIaQDVCEX603GtYBJPeG6Dg3vLJ2Q5L6W2qkbIQn9uirqQ
         Ks1q50HqHeP9Ngi8ijJtz+wZ6GpjN/AaIpJy0/R9RGepLHk94cnzrf+MeQJAN9iaCqEZ
         x9N7z38YrY9IQ6FiXdRd80YWwHFcYbK+LVgab646CUGNlyPYCIrmMcoJD/Xi8a8q+67U
         dgYDYnpy4xfMOiPF1QQSe12men4xgzkjCQrC680Cplx6l+HO3qKk5mKNXtvEQtnL94Od
         uQNmxty+uczPokOmp8f3i6Balj6yrDDksrtF6L4/mE2sluGmeJosoxqeaPOw951ojGyC
         gfZw==
X-Gm-Message-State: AFqh2koJ2yOUn1fx25e55IFEvr36MWyZnrZLA1cutvL8WHY0kqjtmA3Y
        ETN/7Etp6V8WG1JwAd5VtFIhug==
X-Google-Smtp-Source: AMrXdXt9ekLKfksbPLcfJZP4INwbWBVTiqegUNi6R0Q0OMy5BzbUynccucW8Dp4LRpo5sBLj4T30vQ==
X-Received: by 2002:a05:6a20:93a4:b0:b8:e33c:f160 with SMTP id x36-20020a056a2093a400b000b8e33cf160mr220914pzh.0.1673988304593;
        Tue, 17 Jan 2023 12:45:04 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090332c900b00189988a1a9esm21642236plr.135.2023.01.17.12.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 12:45:04 -0800 (PST)
Date:   Tue, 17 Jan 2023 12:45:00 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, bgardon@google.com,
        oupton@google.com
Subject: Re: [PATCH 3/3] KVM: selftests: Print summary stats of memory
 latency distribution
Message-ID: <Y8cIzKf52fzf0/d4@google.com>
References: <20221115173258.2530923-1-coltonlewis@google.com>
 <20221115173258.2530923-4-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115173258.2530923-4-coltonlewis@google.com>
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

On Tue, Nov 15, 2022 at 05:32:58PM +0000, Colton Lewis wrote:
> Print summary stats of the memory latency distribution in
> nanoseconds. For every iteration, this prints the minimum, the
> maximum, and the 50th, 90th, and 99th percentiles.
> 
> Stats are calculated by sorting the samples taken from all vcpus and
> picking from the index corresponding with each percentile.
> 
> The conversion to nanoseconds needs the frequency of the Intel
> timestamp counter, which is estimated by reading the counter before
> and after sleeping for 1 second. This is not a pretty trick, but it
> also exists in vmx_nested_tsc_scaling_test.c
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       |  2 +
>  .../selftests/kvm/include/perf_test_util.h    |  2 +
>  .../selftests/kvm/lib/perf_test_util.c        | 62 +++++++++++++++++++
>  3 files changed, 66 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 202f38a72851..2bc066bba460 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -274,6 +274,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	ts_diff = timespec_elapsed(start);
>  	pr_info("Populate memory time: %ld.%.9lds\n",
>  		ts_diff.tv_sec, ts_diff.tv_nsec);
> +	perf_test_print_percentiles(vm, nr_vcpus);
>  
>  	/* Enable dirty logging */
>  	clock_gettime(CLOCK_MONOTONIC, &start);
> @@ -304,6 +305,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		vcpu_dirty_total = timespec_add(vcpu_dirty_total, ts_diff);
>  		pr_info("Iteration %d dirty memory time: %ld.%.9lds\n",
>  			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
> +		perf_test_print_percentiles(vm, nr_vcpus);
>  
>  		clock_gettime(CLOCK_MONOTONIC, &start);
>  		get_dirty_log(vm, bitmaps, p->slots);
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index 3d0b75ea866a..ca378c262f12 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -47,6 +47,8 @@ struct perf_test_args {
>  
>  extern struct perf_test_args perf_test_args;
>  
> +void perf_test_print_percentiles(struct kvm_vm *vm, int nr_vcpus);
> +
>  struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  				   uint64_t vcpu_memory_bytes, int slots,
>  				   enum vm_mem_backing_src_type backing_src,
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 0311da76bae0..927d22421f7c 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -115,6 +115,68 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  	}
>  }
>  
> +#if defined(__x86_64__)
> +/* This could be determined with the right sequence of cpuid
> + * instructions, but that's oddly complicated.
> + */
> +static uint64_t perf_test_intel_timer_frequency(void)
> +{
> +	uint64_t count_before;
> +	uint64_t count_after;
> +	uint64_t measured_freq;
> +	uint64_t adjusted_freq;
> +
> +	count_before = perf_test_timer_read();
> +	sleep(1);
> +	count_after = perf_test_timer_read();
> +
> +	/* Using 1 second implies our units are in Hz already. */
> +	measured_freq = count_after - count_before;
> +	/* Truncate to the nearest MHz. Clock frequencies are round numbers. */
> +	adjusted_freq = measured_freq / 1000000 * 1000000;
> +
> +	return adjusted_freq;
> +}
> +#endif
> +
> +static double perf_test_cycles_to_ns(double cycles)
> +{
> +#if defined(__aarch64__)
> +	return cycles * (1e9 / timer_get_cntfrq());
> +#elif defined(__x86_64__)
> +	static uint64_t timer_frequency;
> +
> +	if (timer_frequency == 0)
> +		timer_frequency = perf_test_intel_timer_frequency();
> +
> +	return cycles * (1e9 / timer_frequency);
> +#else
> +#warn __func__ " is not implemented for this architecture, will return 0"
> +	return 0.0;
> +#endif
> +}
> +
> +/* compare function for qsort */
> +static int perf_test_qcmp(const void *a, const void *b)
> +{
> +	return *(int *)a - *(int *)b;
> +}
> +
> +void perf_test_print_percentiles(struct kvm_vm *vm, int nr_vcpus)
> +{
> +	uint64_t n_samples = nr_vcpus * SAMPLES_PER_VCPU;
> +
> +	sync_global_from_guest(vm, latency_samples);
> +	qsort(latency_samples, n_samples, sizeof(uint64_t), &perf_test_qcmp);
> +
> +	pr_info("Latency distribution (ns) = min:%6.0lf, 50th:%6.0lf, 90th:%6.0lf, 99th:%6.0lf, max:%6.0lf\n",
> +		perf_test_cycles_to_ns((double)latency_samples[0]),
> +		perf_test_cycles_to_ns((double)latency_samples[n_samples / 2]),
> +		perf_test_cycles_to_ns((double)latency_samples[n_samples * 9 / 10]),
> +		perf_test_cycles_to_ns((double)latency_samples[n_samples * 99 / 100]),
> +		perf_test_cycles_to_ns((double)latency_samples[n_samples - 1]));
> +}

Latency distribution (ns) = min:   732, 50th:   792, 90th:   901, 99th:
                                ^^^
nit: would prefer to avoid the spaces 

> +
>  void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
>  			   struct kvm_vcpu *vcpus[],
>  			   uint64_t vcpu_memory_bytes,
> -- 
> 2.38.1.431.g37b22c650d-goog
> 
