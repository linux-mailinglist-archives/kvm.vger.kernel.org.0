Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038F65A3198
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 23:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiHZV67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 17:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiHZV64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 17:58:56 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4477DCAC95
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 14:58:55 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 202so2515137pgc.8
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 14:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=9rkJMStJWhNWNhJEr2RQPbBEJUS9veT3TvFoUer5NDw=;
        b=JQlkkLsV1BHcdfyZ7yXLodRsDkibQY0K1tGFHBoEgvw/e/+oAmtHhofTgYKMp2uCID
         pQb6pyG1+7TbhuTWp862d0XqCOEqlZNPJALvbA2QOFxSN7SyJVNbMpbMLUK6qAMwC909
         BBPrrEZoX4grg90Tvb5gEdhaPT/WIo40XHXa6CHpeNnyLCo7wXnCFEc34dQRWbPVJNha
         89zSyYyiPvGB6U7NiEvtvBfb0Co7NjzjEMYGL1/yQK2AFhucgqsQ+4bcoeJiNH4FrDZg
         jfJ/zxONt4OKdnH9Ms0dMe77cRd7V4aXombaiFGcfQ7qwyOIvrPpHDhAk4A+Amnnt0y8
         DNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=9rkJMStJWhNWNhJEr2RQPbBEJUS9veT3TvFoUer5NDw=;
        b=zFutAtxl23LwbUyzfTdMTmgXpBGFxbPIaNwksOQIJbBbpSo8jmcvt7gnJ3SrKLHUC/
         bErOUwVQovlMAhQDtdZ2roPgoQ5zQ13YK45ghuvp8WIMPYFKsZSTyc2itZ5e+gcQf25E
         k47IZhoHY41oOvlsSxngbQcs9UDdoGCxW7/nDehfu+7FVmLtIdsMD8am4v9kxIo8ZBTa
         VeFowYkew5+UpJDfTYLjrAvYRRV896NipfexKM/5ua8KcIiL+PVHcMuMe6GccEitHFUB
         OYUY/60DrSEKFVdsAbsYypClKAknubhKBZM1iNtBUngBUwB6EIcGqvwqCkLLH45nlKIw
         ZBGQ==
X-Gm-Message-State: ACgBeo2+jQZKuU7MDJlOcniK8zeHcAqkY9akjnAavpOxT2jHNbDFx20d
        7uBn5ixYqWBadlARVu+8z8F41RJNPeer6A==
X-Google-Smtp-Source: AA6agR6S5mnFft9x6xoQ5W+GDKhEdbB048LlUhG4egdpcuRdC7QtTrSxIitvYJFx9DJhyqLRCkMcfQ==
X-Received: by 2002:a05:6a00:21c8:b0:52e:3404:eba5 with SMTP id t8-20020a056a0021c800b0052e3404eba5mr5858671pfj.67.1661551134414;
        Fri, 26 Aug 2022 14:58:54 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id u7-20020a170902714700b0016f85feae65sm2115678plm.87.2022.08.26.14.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 14:58:53 -0700 (PDT)
Date:   Fri, 26 Aug 2022 14:58:48 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v2 1/3] KVM: selftests: Create source of randomness for
 guest code.
Message-ID: <YwlCGAD2S0aK7/vo@google.com>
References: <20220817214146.3285106-1-coltonlewis@google.com>
 <20220817214146.3285106-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817214146.3285106-2-coltonlewis@google.com>
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

On Wed, Aug 17, 2022 at 09:41:44PM +0000, Colton Lewis wrote:
> Create for each vcpu an array of random numbers to be used as a source
> of randomness when executing guest code. Randomness should be useful
> for approaching more realistic conditions in dirty_log_perf_test.
> 
> Create a -r argument to specify a random seed. If no argument
> is provided, the seed defaults to the current Unix timestamp.
> 
> The random arrays are allocated and filled as part of VM creation. The
> additional memory used is one 32-bit number per guest VM page to
> ensure one number for each iteration of the inner loop of guest_code.

nit: I find it helpful to put this in more practical terms as well. e.g.

  The random arrays are allocated and filled as part of VM creation. The
  additional memory used is one 32-bit number per guest VM page (so
  1MiB of additional memory when using the default 1GiB per-vCPU region
  size) to ensure one number for each iteration of the inner loop of
  guest_code.

Speaking of, this commit always allocates the random arrays, even if
they are not used. I think that's probably fine but it deserves to be
called out in the commit description with an explanation of why it is
the way it is.

> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 11 ++++-
>  .../selftests/kvm/include/perf_test_util.h    |  3 ++
>  .../selftests/kvm/lib/perf_test_util.c        | 45 ++++++++++++++++++-
>  3 files changed, 55 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index f99e39a672d3..362b946019e9 100644
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
> @@ -225,6 +226,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  				 p->slots, p->backing_src,
>  				 p->partition_vcpu_memory_access);
>  
> +	perf_test_set_random_seed(vm, p->random_seed);
>  	perf_test_set_wr_fract(vm, p->wr_fract);
>  
>  	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
> @@ -352,7 +354,7 @@ static void help(char *name)
>  {
>  	puts("");
>  	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
> -	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
> +	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
>  	       "[-x memslots]\n", name);
>  	puts("");
>  	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
> @@ -380,6 +382,7 @@ static void help(char *name)
>  	printf(" -v: specify the number of vCPUs to run.\n");
>  	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>  	       "     them into a separate region of memory for each vCPU.\n");
> +	printf(" -r: specify the starting random seed.\n");
>  	backing_src_help("-s");
>  	printf(" -x: Split the memory region into this number of memslots.\n"
>  	       "     (default: 1)\n");
> @@ -396,6 +399,7 @@ int main(int argc, char *argv[])
>  		.partition_vcpu_memory_access = true,
>  		.backing_src = DEFAULT_VM_MEM_SRC,
>  		.slots = 1,
> +		.random_seed = time(NULL),
>  	};
>  	int opt;
>  
> @@ -406,7 +410,7 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
>  		switch (opt) {
>  		case 'e':
>  			/* 'e' is for evil. */
> @@ -442,6 +446,9 @@ int main(int argc, char *argv[])
>  		case 'o':
>  			p.partition_vcpu_memory_access = false;
>  			break;
> +		case 'r':
> +			p.random_seed = atoi(optarg);

Putting the random seed in test_params seems unnecessary. This flag
could just set perf_test_args.randome_seed directly. Doing this would
avoid the need for duplicating the time(NULL) initialization, and allow
you to drop perf_test_set_random_seed().

> +			break;
>  		case 's':
>  			p.backing_src = parse_backing_src_type(optarg);
>  			break;
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index eaa88df0555a..9517956424fc 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -23,6 +23,7 @@ struct perf_test_vcpu_args {
>  	uint64_t gpa;
>  	uint64_t gva;
>  	uint64_t pages;
> +	vm_vaddr_t random_array;
>  
>  	/* Only used by the host userspace part of the vCPU thread */
>  	struct kvm_vcpu *vcpu;
> @@ -35,6 +36,7 @@ struct perf_test_args {
>  	uint64_t gpa;
>  	uint64_t size;
>  	uint64_t guest_page_size;
> +	uint32_t random_seed;
>  	int wr_fract;
>  
>  	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
> @@ -52,6 +54,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  void perf_test_destroy_vm(struct kvm_vm *vm);
>  
>  void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
> +void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
>  
>  void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
>  void perf_test_join_vcpu_threads(int vcpus);
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 9618b37c66f7..8d85923acb4e 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -70,6 +70,35 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  	}
>  }
>  
> +void perf_test_alloc_random_arrays(uint32_t nr_vcpus, uint32_t nr_randoms)
> +{
> +	struct perf_test_args *pta = &perf_test_args;
> +
> +	for (uint32_t i = 0; i < nr_vcpus; i++) {
> +		pta->vcpu_args[i].random_array = vm_vaddr_alloc(
> +			pta->vm,
> +			nr_randoms * sizeof(uint32_t),
> +			KVM_UTIL_MIN_VADDR);

> +		pr_debug("Random row %d vaddr: %p.\n", i, (void *)pta->vcpu_args[i].random_array);
> +	}
> +}
> +
> +void perf_test_fill_random_arrays(uint32_t nr_vcpus, uint32_t nr_randoms)
> +{
> +	struct perf_test_args *pta = &perf_test_args;
> +	uint32_t *host_row;

"host_row" is a confusing variable name here since you are no longer
operating on a 2D array. Each vCPU has it's own array.

> +
> +	for (uint32_t i = 0; i < nr_vcpus; i++) {
> +		host_row = addr_gva2hva(pta->vm, pta->vcpu_args[i].random_array);
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
> @@ -120,8 +149,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  
>  	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>  
> -	/* By default vCPUs will write to memory. */
> -	pta->wr_fract = 1;
> +	/* Set perf_test_args defaults. */
> +	pta->wr_fract = 100;
> +	pta->random_seed = time(NULL);

Won't this override write the random_seed provided by the test?

>  
>  	/*
>  	 * Snapshot the non-huge page size.  This is used by the guest code to
> @@ -211,6 +241,11 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  
>  	ucall_init(vm, NULL);
>  
> +	srandom(perf_test_args.random_seed);
> +	pr_info("Random seed: %d\n", perf_test_args.random_seed);
> +	perf_test_alloc_random_arrays(nr_vcpus, vcpu_memory_bytes >> vm->page_shift);
> +	perf_test_fill_random_arrays(nr_vcpus, vcpu_memory_bytes >> vm->page_shift);

I think this is broken if !partition_vcpu_memory_access. nr_randoms
(per-vCPU) should be `nr_vcpus * vcpu_memory_bytes >> vm->page_shift`.

Speaking of, this should probably just be done in
perf_test_setup_vcpus(). That way you can just use vcpu_args->pages for
nr_randoms, and you don't have to add another for-each-vcpu loop.

> +
>  	/* Export the shared variables to the guest. */
>  	sync_global_to_guest(vm, perf_test_args);
>  
> @@ -229,6 +264,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
>  	sync_global_to_guest(vm, perf_test_args);
>  }
>  
> +void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
> +{
> +	perf_test_args.random_seed = random_seed;
> +	sync_global_to_guest(vm, perf_test_args);

sync_global_to_guest() is unnecessary here since the guest does not need
to access perf_test_args.random_seed (and I can't imagine it ever will).

That being said, I think you can drop this function (see earlier
comment).

> +}
> +
>  uint64_t __weak perf_test_nested_pages(int nr_vcpus)
>  {
>  	return 0;
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
