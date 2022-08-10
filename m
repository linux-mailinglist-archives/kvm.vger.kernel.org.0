Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACBE58F4CB
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 01:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiHJXSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 19:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbiHJXSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 19:18:17 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50D37B797
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 16:18:16 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r22so13259042pgm.5
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 16:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ExD1AQEKImr/W1KSPX+/SYbfdI2/G6Up+T5Di6ExCEg=;
        b=aSMdMK+UmPw/BoBnwNJ0UqcErNyzfk+8xjhuLgZMJdsgjWqyoXLWHoywOxr9yfTWTG
         8IT3A5V2SBlaVSNYQAE87+t0JBJbHTbaqbF5CiZkBf+WIC4XBMbP5Ngz1z8SBqEPO5Dc
         +uKdYDXAnl8tn184bndMVj9utomU9sGlkDFKyeqkNB6asScE2wrkpL0rUch6haoQZK0Z
         hwltBt1AgendlQyhvZ8OkDJtabLGsBIESZ/cZydAQ15T1q7GMXhaf2rLwj5ThoS6u8iB
         SKmelcV3RmZbXLtZvoKt55jxCoGHuHWUTaK/n8rXltcPptc+6gh1btDZERCRCjmOIbNj
         0qzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ExD1AQEKImr/W1KSPX+/SYbfdI2/G6Up+T5Di6ExCEg=;
        b=ZdPchsKnfCWG8aQstAsUrcgIeUV8MNvZ+0FlHLOcKuz/WAdHOMB1wZReQLTmYt6XwC
         PCYCsBuTcS9OygMODITffCt/80SVd8R+qAart4EZ9JMKmYomUl8dakOHFXfgWTrtQhCo
         g7Rf1fgZ3f5YHEJQzW9aSWI3I0ShJA4wZzM1ubvWpV+ENamfu6e26BDsZdJGmBqJEuxb
         q9lHknhfz4Sw7/21/EXHQ5Us4DAJ5Nt7+PEjdJisc2Yc20AAOgON2dNnQuj9A1A9GSG2
         vNCMR8rt8XARGLTcFnRa9ynkEUAyDP5ZmWoYiPrTsS1QrTZvuoLhfnNEf3/puQwYMdVX
         e+6A==
X-Gm-Message-State: ACgBeo01IccBDq5B1Y0CvQAKBd2JvQlx+cgZjbE+0zhT1lR1NkHdB04j
        RI1YxyDhroZud8UE6Z7KmnBSqRbIed8JjA==
X-Google-Smtp-Source: AA6agR6WP/+ohXvWQo5DWhlt6VXOFid+6qmv8iH0JnqRKgvdzBD1eeo35wfKtOCz8ZwEc5w0G0mtKg==
X-Received: by 2002:a63:ec15:0:b0:41c:2669:1e54 with SMTP id j21-20020a63ec15000000b0041c26691e54mr25059083pgh.253.1660173496086;
        Wed, 10 Aug 2022 16:18:16 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id l17-20020a170902f69100b0016a091eb88esm13590285plg.126.2022.08.10.16.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 16:18:15 -0700 (PDT)
Date:   Wed, 10 Aug 2022 16:18:10 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH 1/3] KVM: selftests: Add random table to randomize memory
 access
Message-ID: <YvQ8sr3UbMW5rhgE@google.com>
References: <20220810175830.2175089-1-coltonlewis@google.com>
 <20220810175830.2175089-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810175830.2175089-2-coltonlewis@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 05:58:28PM +0000, Colton Lewis wrote:
> Linear access through all pages does not seem to replicate performance

State what the patch does first, then the background/motivation.

> problems with realistic dirty logging workloads. Make the test more
> sophisticated through random access. Each vcpu has its own sequence of
> random numbers that are refilled after every iteration. Having the
> main thread fill the table for every vcpu is less efficient than
> having each vcpu generate its own numbers, but this ensures threading
> nondeterminism won't destroy reproducibility with a given random seed.

Make it clear what this patch does specifically. e.g. "Make the test
more sophisticated through random access" is a bit misleading since all
this patch does is create a table of random numbers.

> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 13 ++++-
>  .../selftests/kvm/include/perf_test_util.h    |  4 ++
>  .../selftests/kvm/lib/perf_test_util.c        | 47 +++++++++++++++++++
>  3 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index f99e39a672d3..80a1cbe7fbb0 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -132,6 +132,7 @@ struct test_params {
>  	bool partition_vcpu_memory_access;
>  	enum vm_mem_backing_src_type backing_src;
>  	int slots;
> +	uint32_t random_seed;
>  };
>  
>  static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
> @@ -243,6 +244,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	/* Start the iterations */
>  	iteration = 0;
>  	host_quit = false;
> +	srandom(p->random_seed);
> +	pr_info("Random seed: %d\n", p->random_seed);
> +	alloc_random_table(nr_vcpus, guest_percpu_mem_size >> vm->page_shift);
> +	fill_random_table(nr_vcpus, guest_percpu_mem_size >> vm->page_shift);

Drive the allocate and filling of the random table in perf_test_util.c
as part of VM setup, and also move random_seed to perf_test_args.

This will reduce the amount of code needed in the test to use
perf_test_util with random accesses.  dirty_log_perf_test is the only
test using random accesses right now, but I could see us wanting to use
it in demand_paging_test and access_tracking_perf_test in the near
future.

You can still have the test refresh the random table every iteration by
exporting e.g. perf_test_refresh_random_table() for use by tests.

>  
>  	clock_gettime(CLOCK_MONOTONIC, &start);
>  	for (i = 0; i < nr_vcpus; i++)
> @@ -270,6 +275,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		ts_diff.tv_sec, ts_diff.tv_nsec);
>  
>  	while (iteration < p->iterations) {
> +		fill_random_table(nr_vcpus, guest_percpu_mem_size >> vm->page_shift);

I wonder if it would be better to use the same random access pattern
across iterations. One of the reasons to have multiple iterations is to
see how the guest performance changes as the memory moves through
different phases of dirty tracking. e.g. KVM might be splitting huge
pages during the first iteration but not the second. If the access
pattern is also changing across iterations that could make it harder to
identify performance changes due to KVM.

>  		/*
>  		 * Incrementing the iteration number will start the vCPUs
>  		 * dirtying memory again.
> @@ -380,6 +386,7 @@ static void help(char *name)
>  	printf(" -v: specify the number of vCPUs to run.\n");
>  	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>  	       "     them into a separate region of memory for each vCPU.\n");
> +	printf(" -r: specify the starting random seed.\n");
>  	backing_src_help("-s");
>  	printf(" -x: Split the memory region into this number of memslots.\n"
>  	       "     (default: 1)\n");
> @@ -396,6 +403,7 @@ int main(int argc, char *argv[])
>  		.partition_vcpu_memory_access = true,
>  		.backing_src = DEFAULT_VM_MEM_SRC,
>  		.slots = 1,
> +		.random_seed = time(NULL),

Perhaps the default seed should be a hard-coded value so that users
running the test with default arguments get deterministic results across
runs.

>  	};
>  	int opt;
>  
> @@ -406,7 +414,7 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
>  		switch (opt) {
>  		case 'e':
>  			/* 'e' is for evil. */
> @@ -442,6 +450,9 @@ int main(int argc, char *argv[])
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
> index eaa88df0555a..597875d0c3db 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -44,6 +44,10 @@ struct perf_test_args {
>  };
>  
>  extern struct perf_test_args perf_test_args;
> +extern uint32_t **random_table;

Adding random_table to perf_test_util.h is unnecessary in this commit
(it's only used in perf_test_util.c).

> +
> +void alloc_random_table(uint32_t nr_vcpus, uint32_t nr_randoms);
> +void fill_random_table(uint32_t nr_vcpus, uint32_t nr_randoms);

Use perf_test_ prefixes for symbols visible outside of perf_test_util.c.

e.g.

  perf_test_random_table
  perf_test_alloc_random_table()
  perf_test_fill_random_table()

>  
>  struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  				   uint64_t vcpu_memory_bytes, int slots,
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 9618b37c66f7..b04e8d2c0f37 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -9,6 +9,10 @@
>  #include "processor.h"
>  
>  struct perf_test_args perf_test_args;
> +/* This pointer points to guest memory and must be converted with
> + * addr_gva2hva to be accessed from the host.
> + */
> +uint32_t **random_table;

Use vm_vaddr_t for variables that contain guest virtual addresses
(exception within guest_code(), of course).

>  
>  /*
>   * Guest virtual memory offset of the testing memory slot.
> @@ -70,6 +74,49 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  	}
>  }
>  
> +void alloc_random_table(uint32_t nr_vcpus, uint32_t nr_randoms)
> +{
> +	struct perf_test_args *pta = &perf_test_args;
> +	uint32_t **host_random_table;
> +
> +	random_table = (uint32_t **)vm_vaddr_alloc(
> +		pta->vm,
> +		nr_vcpus * sizeof(uint32_t *),
> +		(vm_vaddr_t)0);

I notice vm_vaddr_alloc_pages() and vcpu_alloc_cpuid() use
KVM_UTIL_MIN_VADDR for the min. Should we use that here too?

If so, this is a good opporunity to rename vm_vaddr_alloc() to
__vm_vaddr_alloc() and introduce:

vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz)
{
        return __vm_vaddr_alloc(vm, sz, KVM_UTIL_MIN_VADDR);
}

> +	host_random_table = addr_gva2hva(pta->vm, (vm_vaddr_t)random_table);
> +	pr_debug("Random start addr: %p %p.\n", random_table, host_random_table);
> +
> +	for (uint32_t i = 0; i < nr_vcpus; i++) {
> +		host_random_table[i] = (uint32_t *)vm_vaddr_alloc(

The per-vCPU random table should go in perf_test_vcpu_args along with
all the other per-vCPU information that is set up by the test and
consumed by the guest code.

This will reduce some of the complexity here because you won't need to
allocate the top-level array of pointers.

> +			pta->vm,
> +			nr_randoms * sizeof(uint32_t),
> +			(vm_vaddr_t)0);
> +		pr_debug("Random row addr: %p %p.\n",
> +			 host_random_table[i],
> +			 addr_gva2hva(pta->vm, (vm_vaddr_t)host_random_table[i]));

Logging the host virtual addresses of the random table would probably
not be valuable. But logging the guest virtual address would probably be
more useful. The guest virtual address space management it pretty
ad-hoc.

> +	}
> +}
> +
> +void fill_random_table(uint32_t nr_vcpus, uint32_t nr_randoms)
> +{
> +	struct perf_test_args *pta = &perf_test_args;
> +	uint32_t **host_random_table = addr_gva2hva(pta->vm, (vm_vaddr_t)random_table);
> +	uint32_t *host_row;
> +
> +	pr_debug("Random start addr: %p %p.\n", random_table, host_random_table);
> +
> +	for (uint32_t i = 0; i < nr_vcpus; i++) {
> +		host_row = addr_gva2hva(pta->vm, (vm_vaddr_t)host_random_table[i]);
> +		pr_debug("Random row addr: %p %p.\n", host_random_table[i], host_row);
> +
> +		for (uint32_t j = 0; j < nr_randoms; j++)
> +			host_row[j] = random();
> +
> +		pr_debug("New randoms row %d: %d, %d, %d...\n",
> +			 i, host_row[0], host_row[1], host_row[2]);
> +	}
> +}
> +
>  void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
>  			   struct kvm_vcpu *vcpus[],
>  			   uint64_t vcpu_memory_bytes,
> -- 
> 2.37.1.559.g78731f0fdb-goog
> 
