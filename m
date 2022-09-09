Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9607B5B3CDA
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 18:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiIIQWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 12:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIIQWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 12:22:09 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E866E133A3C
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 09:22:07 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id e5so2132645pfl.2
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 09:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=iWmTwRJOKC3XXcacFoEJGY8KM0GTuaI2LGPGP882Hok=;
        b=nwsD0KmuLV6L0qXsxcPWX8342KPXPUNmrR3rQIPTKldpu+ig/5HUiD3P0SYMYSbEtL
         mmEueIAYXIlR1nFcryDpMqhX3+Se5pkBfaMR8EmHPVD6gUXDGTiVTP6xOcmK8dKFSGqR
         ySnxVlWu4ACWNBbuT7FDwPhvH4Wy5GusBKnkeWXuMB8NYK7MeQAGANc8jSoKzcBlqoAZ
         6fdzOuhwElKCxqPaim/CDwMPjAbYYQVUM3wsSfRQSqFe6f6u1Dt4NaEimEhfC7nAJCRD
         UiwMm31+cYTAs0agk1KtzVm/wqHEoxSJ41hwBPHwFwT0QqcLJ1pUtYrrXoQm4X0plaGP
         Wu1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=iWmTwRJOKC3XXcacFoEJGY8KM0GTuaI2LGPGP882Hok=;
        b=mPoG2fKH34xeMuCOcV2E6UzojVIvqIabJrJ7aj0MfGj/PHqdyXtQIIIUjqKQ/QAOHJ
         Nf3KXoam9wwFM0s4qKCFzFxh8En6f9lAm4+AvEyLqK+QJA3EqFwL5vPGI/qttEkKTJpT
         X23nmL+jsfYQaEv7f1hI5Fgl1U+nh91yvE3x0cZ9UtrEbFg7BnP2nhcTSItg5SkYWX/d
         oD0urxOa52n8jBR/AXqul1Vy3eqAuPTT0zdMxlN+dw+VAkdy18gQG8ki+ThJ2ohDv3ZM
         S8BvZkct9ekcK5qfQFlEzIU54k5ojIUXttWmUTsyb3MLo+4hGWxxA586sP3mAT0wtcTn
         V0lg==
X-Gm-Message-State: ACgBeo3EU65cWZ+RaxYmwzupX6iFyGHkjg4X/DT0Wy6gAkJSLZhSWO1K
        ql8E1oD5fsCFAbeAV+rK+50maw==
X-Google-Smtp-Source: AA6agR7jZm17XMqXY45aVbS3RyODMIu7nrZNutKEAlM+hzhENgz9/EdoyaZ2dbbHnKRFf7e3sDFgLQ==
X-Received: by 2002:a05:6a00:10c7:b0:4fe:5d:75c8 with SMTP id d7-20020a056a0010c700b004fe005d75c8mr15281766pfu.6.1662740527090;
        Fri, 09 Sep 2022 09:22:07 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id u7-20020a170902e80700b0016c09a0ef87sm412550plg.255.2022.09.09.09.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 09:22:05 -0700 (PDT)
Date:   Fri, 9 Sep 2022 09:22:01 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, oupton@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v5 1/3] KVM: selftests: implement random number
 generation for guest code
Message-ID: <YxtoKYH7r6kB4l4K@google.com>
References: <20220909124300.3409187-1-coltonlewis@google.com>
 <20220909124300.3409187-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909124300.3409187-2-coltonlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 12:42:58PM +0000, Colton Lewis wrote:
> Implement random number generation for guest code to randomize parts
> of the test, making it less predictable and a more accurate reflection
> of reality.
> 
> Create a -r argument to specify a random seed. If no argument is
> provided, the seed defaults to the current Unix timestamp. The random
> seed is set with perf_test_set_random_seed() and must be set before
> guest_code runs to apply.
> 
> The random number generator chosen is the Park-Miller Linear
> Congruential Generator, a fancy name for a basic and well-understood
> random number generator entirely sufficient for this purpose. Each
> vCPU calculates its own seed by adding its index to the seed provided.
>

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c    | 12 ++++++++++--
>  tools/testing/selftests/kvm/include/perf_test_util.h |  2 ++
>  tools/testing/selftests/kvm/include/test_util.h      |  2 ++
>  tools/testing/selftests/kvm/lib/perf_test_util.c     | 11 ++++++++++-
>  tools/testing/selftests/kvm/lib/test_util.c          |  9 +++++++++
>  5 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index d60a34cdfaee..2f91acd94130 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -126,6 +126,7 @@ struct test_params {
>  	bool partition_vcpu_memory_access;
>  	enum vm_mem_backing_src_type backing_src;
>  	int slots;
> +	uint32_t random_seed;
>  };
>  
>  static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
> @@ -220,6 +221,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  				 p->slots, p->backing_src,
>  				 p->partition_vcpu_memory_access);
>  
> +	pr_info("Random seed: %u\n", p->random_seed);
> +	perf_test_set_random_seed(vm, p->random_seed);
>  	perf_test_set_wr_fract(vm, p->wr_fract);
>  
>  	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
> @@ -337,7 +340,7 @@ static void help(char *name)
>  {
>  	puts("");
>  	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
> -	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
> +	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
>  	       "[-x memslots]\n", name);
>  	puts("");
>  	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
> @@ -362,6 +365,7 @@ static void help(char *name)
>  	printf(" -v: specify the number of vCPUs to run.\n");
>  	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>  	       "     them into a separate region of memory for each vCPU.\n");
> +	printf(" -r: specify the starting random seed.\n");
>  	backing_src_help("-s");
>  	printf(" -x: Split the memory region into this number of memslots.\n"
>  	       "     (default: 1)\n");
> @@ -378,6 +382,7 @@ int main(int argc, char *argv[])
>  		.partition_vcpu_memory_access = true,
>  		.backing_src = DEFAULT_VM_MEM_SRC,
>  		.slots = 1,
> +		.random_seed = time(NULL),
>  	};
>  	int opt;
>  
> @@ -388,7 +393,7 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:os:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:or:s:x:")) != -1) {
>  		switch (opt) {
>  		case 'g':
>  			dirty_log_manual_caps = 0;
> @@ -421,6 +426,9 @@ int main(int argc, char *argv[])
>  		case 'o':
>  			p.partition_vcpu_memory_access = false;
>  			break;
> +		case 'r':
> +			p.random_seed = atoi(optarg);
> +			break;
>  		case 's':
>  			p.backing_src = parse_backing_src_type(optarg);
>  			break;
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index d822cb670f1c..f18530984b42 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -34,6 +34,7 @@ struct perf_test_args {
>  	uint64_t gpa;
>  	uint64_t size;
>  	uint64_t guest_page_size;
> +	uint32_t random_seed;
>  	int wr_fract;
>  
>  	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
> @@ -51,6 +52,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>  void perf_test_destroy_vm(struct kvm_vm *vm);
>  
>  void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
> +void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
>  
>  void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
>  void perf_test_join_vcpu_threads(int vcpus);
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index 99e0dcdc923f..2dd286bcf46f 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
>  	return (void *)align_up((unsigned long)x, size);
>  }
>  
> +void guest_random(uint32_t *seed);
> +
>  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index f989ff91f022..4d9c7d7693d9 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -47,6 +47,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
>  	uint64_t gva;
>  	uint64_t pages;
>  	int i;
> +	uint32_t rand = pta->random_seed + vcpu_id;
>  
>  	/* Make sure vCPU args data structure is not corrupt. */
>  	GUEST_ASSERT(vcpu_args->vcpu_id == vcpu_id);
> @@ -57,6 +58,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
>  	while (true) {
>  		for (i = 0; i < pages; i++) {
>  			uint64_t addr = gva + (i * pta->guest_page_size);
> +			guest_random(&rand);
>  
>  			if (i % pta->wr_fract == 0)
>  				*(uint64_t *)addr = 0x0123456789ABCDEF;
> @@ -115,8 +117,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>  
>  	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>  
> -	/* By default vCPUs will write to memory. */
> +	/* Set perf_test_args defaults. */
>  	pta->wr_fract = 1;
> +	pta->random_seed = time(NULL);
>  
>  	/*
>  	 * Snapshot the non-huge page size.  This is used by the guest code to
> @@ -224,6 +227,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
>  	sync_global_to_guest(vm, perf_test_args);
>  }
>  
> +void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
> +{
> +	perf_test_args.random_seed = random_seed;
> +	sync_global_to_guest(vm, perf_test_args.random_seed);
> +}
> +
>  uint64_t __weak perf_test_nested_pages(int nr_vcpus)
>  {
>  	return 0;
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 6d23878bbfe1..28c895743abe 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -17,6 +17,15 @@
>  
>  #include "test_util.h"
>  
> +/*
> + * Random number generator that is usable from guest code. This is the
> + * Park-Miller LCG using standard constants.
> + */
> +void guest_random(uint32_t *seed)
> +{
> +	*seed = (uint64_t)*seed * 48271 % ((uint32_t)(1 << 31) - 1);
> +}
> +
>  /*
>   * Parses "[0-9]+[kmgt]?".
>   */
> -- 
> 2.37.2.789.g6183377224-goog
> 
