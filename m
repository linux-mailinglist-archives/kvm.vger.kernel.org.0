Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606CE5AF407
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 21:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiIFTBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 15:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiIFTBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 15:01:38 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B691A1B7BF
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 12:01:36 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 65so2070482pfx.0
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 12:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ENLhkCUYah4TwDbLAQlD9v9RdmmV54PceFLSiA4FhvA=;
        b=CgIgWPFRUy4AUJ4Ddb92ijX8b4iAHchh1BpXpDjCCLqoNcPjZ29kHPMCyc72P4q95Z
         7Qxh6pFaNemwGoCUapq3r9CXJIxS91z/RJ/pbUV5sQjZSCEbrVDGtcCwvyL4Nj/XeJFm
         j5nONgCk98lCaRVuh2l47xqRbaxouLi8fRtzDSAEeuCt5pjbyf4E8qmVRmi1bvouamWv
         H5ahg8T+QO+LV0Jv9aNrNf0jXDNrG2oGXrmBiwtAsYtz4wnUaHhu4MDD1BQk+bJaEo+o
         N0xcNhnSc6TMvWquWEeVRLFJXYapk1r9QTytw8CPdfskTrQJdwOgI1Wrmr1vzx97ZnRP
         pDMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ENLhkCUYah4TwDbLAQlD9v9RdmmV54PceFLSiA4FhvA=;
        b=xWHgH0O1F3z/fPATLRtx5quPi25ZiPw8sGGtLJaPtnj9dKFH6Q7o4UMCkDXamwcGEZ
         OMEq/jGBbHQwYOg1Zz3K5aIwyENALCoT0x+hEyHSxk3dBVUkT2qaUZuOp4dSLM7Nt9pD
         UClM8BJVg9runXnd3fQST/e32Q+2vu1eaOwG/eLd4OgdAvlEJIRaWe5pbJPPQbCrhE9m
         dIrYSk7bH8cvI2oAbWjSMbvAfuGonfosXZeRUJHolNMr9ljPiWVX29hpX6//4ZCc9N7i
         Ce+gVPHyLDsqJEcOQymj/cIiwBQGDAayCM4L579tMhvIoq/cAJKQOY9/e/SzRcOLl/z9
         kjbA==
X-Gm-Message-State: ACgBeo01WkaBUL+ldgQX1bZWkBkmca+b5DLGlUvWHgGth7gsLrvD0V4t
        b6/JsL6m4GXitCLq1sQ2o35NSw==
X-Google-Smtp-Source: AA6agR7pcbkjHPVnzhn0Bd5vpUkzmrzWasWffWNw/3V8NG7uXi8Jp0QVGakNWudfzUkjVNrT9PxDGw==
X-Received: by 2002:a63:90c1:0:b0:434:cb6a:8a33 with SMTP id a184-20020a6390c1000000b00434cb6a8a33mr55591pge.528.1662490895949;
        Tue, 06 Sep 2022 12:01:35 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id b3-20020a170902650300b0016f1319d2a7sm1907904plk.297.2022.09.06.12.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 12:01:35 -0700 (PDT)
Date:   Tue, 6 Sep 2022 12:01:31 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, oupton@google.com
Subject: Re: [PATCH v3 1/3] KVM: selftests: Implement random number
 generation for guest code.
Message-ID: <YxeZCwxmS5z5Msjy@google.com>
References: <20220901195237.2152238-1-coltonlewis@google.com>
 <20220901195237.2152238-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901195237.2152238-2-coltonlewis@google.com>
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

On Thu, Sep 01, 2022 at 07:52:35PM +0000, Colton Lewis wrote:
> Implement random number generation for guest code to randomize parts
> of the test, making it less predictable and a more accurate reflection
> of reality.
> 
> Create a -r argument to specify a random seed. If no argument is
> provided, the seed defaults to the current Unix timestamp.
> 
> The random number generator chosen is the Park-Miller Linear
> Congruential Generator, a fancy name for a basic and well-understood
> random number generator entirely sufficient for this purpose. Each
> vCPU calculates its own seed by adding its index to the seed provided.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c        | 12 ++++++++++--
>  .../selftests/kvm/include/perf_test_util.h     |  2 ++
>  .../testing/selftests/kvm/lib/perf_test_util.c | 18 +++++++++++++++++-
>  3 files changed, 29 insertions(+), 3 deletions(-)
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
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index f989ff91f022..1292ed7d1193 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -36,6 +36,13 @@ static void (*vcpu_thread_fn)(struct perf_test_vcpu_args *);
>  /* Set to true once all vCPU threads are up and running. */
>  static bool all_vcpu_threads_running;
>  
> +
> +/* Park-Miller LCG using standard constants */
> +static uint32_t perf_test_random(uint32_t seed)
> +{
> +	return (uint64_t)seed * 48271 % ((uint32_t)(1 << 31) - 1);
> +}

Nit: I would prefer moving this to include/kvm_test_util.h, maybe
something like: get_next_random(seed). There could be other users of
this.

> +
>  /*
>   * Continuously write to the first 8 bytes of each page in the
>   * specified region.
> @@ -47,6 +54,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
>  	uint64_t gva;
>  	uint64_t pages;
>  	int i;
> +	uint32_t rand = pta->random_seed + vcpu_id;
>  
>  	/* Make sure vCPU args data structure is not corrupt. */
>  	GUEST_ASSERT(vcpu_args->vcpu_id == vcpu_id);
> @@ -56,6 +64,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
>  
>  	while (true) {
>  		for (i = 0; i < pages; i++) {
> +			rand = perf_test_random(rand);
>  			uint64_t addr = gva + (i * pta->guest_page_size);
>  
>  			if (i % pta->wr_fract == 0)
> @@ -115,8 +124,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
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
> @@ -224,6 +234,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
>  	sync_global_to_guest(vm, perf_test_args);
>  }
>  
> +void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
> +{
> +	perf_test_args.random_seed = random_seed;
> +	sync_global_to_guest(vm, perf_test_args);
> +}
> +
>  uint64_t __weak perf_test_nested_pages(int nr_vcpus)
>  {
>  	return 0;
> -- 
> 2.37.2.789.g6183377224-goog
> 
