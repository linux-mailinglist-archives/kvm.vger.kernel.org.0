Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085C259A7D5
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 23:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbiHSVin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 17:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbiHSVij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 17:38:39 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0407D56BBE
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 14:38:36 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id z187so5358876pfb.12
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 14:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=BfbwlzS5+6s0VqI+nXcKb/tVfJ+Onqz9AlRMcJukqeo=;
        b=Z3ALrhyRkLaUmF2vyenJS8yzBH8sEr2pqs5ERzcCXmKAyMe9RjX8pZW/6lu7HSINRK
         UMUUjubr2LW9P/xMv9ChAZ/m0xj/ptfgvHsiHRsdTs6dYwjRhaIyRcgYhOHB8Y0mT6du
         HjULyYldQZCwyyhH75TBfizAUJnsNb+VEJL9QMv9OdAIJIoARRvrmXcNWIKPbnluvaLW
         BTyXnfEKtrnalU9ZCRUvJ9LOJb+lDFql2Uff3/rWnN43OxgbsLJYxEmyuxYzHKplB6Yp
         8OXHGPjWHR06bBzaXjlzYQn/lBnwo04fh8ybneqWH/V0/y64hY6jVTJSngeeOggAthBL
         TOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=BfbwlzS5+6s0VqI+nXcKb/tVfJ+Onqz9AlRMcJukqeo=;
        b=2zbiXRHPGJmqT35ajQ76t/BpZjH4lMMvtQLOpIrXTc6roNumbWUZOuVxbqxNIIqHCj
         7tma5kLHvy7Ct7sixZPiv8AT6bH+cSHY6gFz49Ue9mRKz/D1HhUT9myVeBKZNT8679lW
         99rJkfGr6CxQ+64zBkjx2nTmvxjp4Pe6MDEoqwqxBkD+lY3ke2RhOyaWi2OAnqvvvwjp
         +aTRtnA+wPm6M7l3jrdRcyTktoDn/Xp7/5IGUr3SFwUhMECHjBngZFhYxcnDvH7coEVZ
         kqcsLGGRf3fr9p4vlOKc5b9QqfotvhemIdMsKn/Biny79DHXfXLII9kfW/xUcJyrbW8H
         6wnQ==
X-Gm-Message-State: ACgBeo2hFLk15SL+baG2y6A+PI1AiKs9wvG8mIUiqwB4M8c63aYczIgq
        3DzvI+ZzQDG6T1KJPrntEt7nTg==
X-Google-Smtp-Source: AA6agR5NjPAe3Ddvn/n5tVmakIaXaOtvFWbMcmHL33eJHYjJms2SDbdcQWR4i3YzNykXVkyczwNmvQ==
X-Received: by 2002:a05:6a00:16c1:b0:520:6ede:24fb with SMTP id l1-20020a056a0016c100b005206ede24fbmr9820852pfc.7.1660945116014;
        Fri, 19 Aug 2022 14:38:36 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id g7-20020aa79f07000000b0052dcbd87ae8sm3875595pfr.25.2022.08.19.14.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 14:38:34 -0700 (PDT)
Date:   Fri, 19 Aug 2022 14:38:29 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: selftests: Run dirty_log_perf_test on specific
 cpus
Message-ID: <YwAC1f5wTYpTdeh+@google.com>
References: <20220819210737.763135-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819210737.763135-1-vipinsh@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022 at 02:07:37PM -0700, Vipin Sharma wrote:
> Add command line options to run the vcpus and the main process on the
> specific cpus on a host machine. This is useful as it provides
> options to analyze performance based on the vcpus and dirty log worker
> locations, like on the different numa nodes or on the same numa nodes.
> 
> Link: https://lore.kernel.org/lkml/20220801151928.270380-1-vipinsh@google.com
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Suggested-by: David Matlack <dmatlack@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 
> v2:
>  - Removed -d option.
>  - One cpu list passed as option, cpus for vcpus, followed by
>    application thread cpu.
>  - Added paranoid cousin of atoi().
> 
> v1: https://lore.kernel.org/lkml/20220817152956.4056410-1-vipinsh@google.com
> 
>  .../selftests/kvm/access_tracking_perf_test.c |  2 +-
>  .../selftests/kvm/demand_paging_test.c        |  2 +-
>  .../selftests/kvm/dirty_log_perf_test.c       | 89 +++++++++++++++++--
>  .../selftests/kvm/include/perf_test_util.h    |  3 +-
>  .../selftests/kvm/lib/perf_test_util.c        | 32 ++++++-
>  .../kvm/memslot_modification_stress_test.c    |  2 +-
>  6 files changed, 116 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> index 1c2749b1481a..9659462f4747 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -299,7 +299,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	vm = perf_test_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
>  				 params->backing_src, !overlap_memory_access);
>  
> -	perf_test_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
> +	perf_test_start_vcpu_threads(nr_vcpus, NULL, vcpu_thread_main);
>  
>  	pr_info("\n");
>  	access_memory(vm, nr_vcpus, ACCESS_WRITE, "Populating memory");
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 779ae54f89c4..b9848174d6e7 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -336,7 +336,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	pr_info("Finished creating vCPUs and starting uffd threads\n");
>  
>  	clock_gettime(CLOCK_MONOTONIC, &start);
> -	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
> +	perf_test_start_vcpu_threads(nr_vcpus, NULL, vcpu_worker);
>  	pr_info("Started all vCPUs\n");
>  
>  	perf_test_join_vcpu_threads(nr_vcpus);
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index f99e39a672d3..ace4ed954628 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -8,10 +8,12 @@
>   * Copyright (C) 2020, Google, Inc.
>   */
>  
> +#define _GNU_SOURCE
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <time.h>
>  #include <pthread.h>
> +#include <sched.h>
>  #include <linux/bitmap.h>
>  
>  #include "kvm_util.h"
> @@ -132,6 +134,7 @@ struct test_params {
>  	bool partition_vcpu_memory_access;
>  	enum vm_mem_backing_src_type backing_src;
>  	int slots;
> +	int *vcpu_to_lcpu;
>  };
>  
>  static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
> @@ -248,7 +251,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	for (i = 0; i < nr_vcpus; i++)
>  		vcpu_last_completed_iteration[i] = -1;
>  
> -	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
> +	perf_test_start_vcpu_threads(nr_vcpus, p->vcpu_to_lcpu, vcpu_worker);
>  
>  	/* Allow the vCPUs to populate memory */
>  	pr_debug("Starting iteration %d - Populating\n", iteration);
> @@ -348,12 +351,61 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	perf_test_destroy_vm(vm);
>  }
>  
> +static int atoi_paranoid(const char *num_str)
> +{
> +	int num;
> +	char *end_ptr;
> +
> +	errno = 0;
> +	num = (int)strtol(num_str, &end_ptr, 10);
> +	TEST_ASSERT(errno == 0, "Conversion error: %d\n", errno);
> +	TEST_ASSERT(num_str != end_ptr && *end_ptr == '\0',
> +		    "Invalid number string.\n");
> +
> +	return num;
> +}

Introduce atoi_paranoid() and upgrade existing atoi() users in a
separate commit. Also please put it in e.g. test_util.c so that it can
be used by other tests (and consider upgrading other tests to use it in
your commit).

> +
> +static int parse_cpu_list(const char *arg, int *lcpu_list, int list_size)
> +{
> +	char delim[2] = ",";
> +	char *cpu, *cpu_list;
> +	int i = 0, cpu_num;
> +
> +	cpu_list = strdup(arg);
> +	TEST_ASSERT(cpu_list, "strdup() allocation failed.\n");
> +
> +	cpu = strtok(cpu_list, delim);
> +	while (cpu) {
> +		TEST_ASSERT(i != list_size,
> +			    "Too many cpus, max supported: %d\n", list_size);
> +
> +		cpu_num = atoi_paranoid(cpu);
> +		TEST_ASSERT(cpu_num >= 0, "Invalid cpu number: %d\n", cpu_num);
> +		lcpu_list[i++] = cpu_num;
> +		cpu = strtok(NULL, delim);
> +	}
> +	free(cpu_list);
> +
> +	return i;
> +}
> +
> +static void assign_dirty_log_perf_test_cpu(int cpu)
> +{
> +	cpu_set_t cpuset;
> +	int err;
> +
> +	CPU_ZERO(&cpuset);
> +	CPU_SET(cpu, &cpuset);
> +	err = sched_setaffinity(0, sizeof(cpu_set_t), &cpuset);
> +	TEST_ASSERT(err == 0, "Error in setting dirty log perf test cpu\n");
> +}
> +
>  static void help(char *name)
>  {
>  	puts("");
>  	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
>  	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
> -	       "[-x memslots]\n", name);
> +	       "[-x memslots] [-c logical cpus to run test on]\n", name);
>  	puts("");
>  	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
>  	       TEST_HOST_LOOP_N);
> @@ -383,6 +435,14 @@ static void help(char *name)
>  	backing_src_help("-s");
>  	printf(" -x: Split the memory region into this number of memslots.\n"
>  	       "     (default: 1)\n");
> +	printf(" -c: Comma separated values of the logical CPUs, which will run\n"
> +	       "     the vCPUs, followed by the main application thread cpu.\n"
> +	       "     Number of values must be equal to the number of vCPUs + 1.\n\n"
> +	       "     Example: ./dirty_log_perf_test -v 3 -c 22,23,24,50\n"
> +	       "     This means that the vcpu 0 will run on the logical cpu 22,\n"
> +	       "     vcpu 1 on the logical cpu 23, vcpu 2 on the logical cpu 24\n"
> +	       "     and the main thread will run on cpu 50.\n"
> +	       "     (default: No cpu mapping)\n");
>  	puts("");
>  	exit(0);
>  }
> @@ -390,14 +450,18 @@ static void help(char *name)
>  int main(int argc, char *argv[])
>  {
>  	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
> +	int lcpu_list[KVM_MAX_VCPUS + 1];
> +
>  	struct test_params p = {
>  		.iterations = TEST_HOST_LOOP_N,
>  		.wr_fract = 1,
>  		.partition_vcpu_memory_access = true,
>  		.backing_src = DEFAULT_VM_MEM_SRC,
>  		.slots = 1,
> +		.vcpu_to_lcpu = NULL,
>  	};
>  	int opt;
> +	int nr_lcpus = -1;
>  
>  	dirty_log_manual_caps =
>  		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> @@ -406,8 +470,11 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "c:eghi:p:m:nb:f:v:os:x:")) != -1) {
>  		switch (opt) {
> +		case 'c':
> +			nr_lcpus = parse_cpu_list(optarg, lcpu_list, KVM_MAX_VCPUS + 1);

I think we should move all the logic to pin threads to perf_test_util.c.
The only thing dirty_log_perf_test.c should do is pass optarg into
perf_test_util.c. This will make it trivial for any other test based on
pef_test_util.c to also use pinning.

e.g. All a test needs to do to use pinning is add a flag to the optlist
and add a case statement like:

        case 'c':
                perf_test_setup_pinning(optarg);
                break;

perf_test_setup_pinning() would:
 - Parse the list and populate perf_test_vcpu_args with each vCPU's
   assigned pCPU.
 - Pin the current thread to it's assigned pCPU if one is provided.

Validating that the number of pCPUs == number of vCPUs is a little
tricky. But that could be done as part of
perf_test_start_vcpu_threads(). Alternatively, you could set up pinning
after getting the number of vCPUs. e.g.

        const char *cpu_list = NULL;

        ...

        while ((opt = getopt(...)) != -1) {
                switch (opt) {
                case 'c':
                        cpu_list = optarg;  // is grabbing optarg here safe?
                        break;
                }
                ...
        }

        if (cpu_list)
                perf_test_setup_pinning(cpu_list, nr_vcpus);

> +			break;
>  		case 'e':
>  			/* 'e' is for evil. */
>  			run_vcpus_while_disabling_dirty_logging = true;
> @@ -415,7 +482,7 @@ int main(int argc, char *argv[])
>  			dirty_log_manual_caps = 0;
>  			break;
>  		case 'i':
> -			p.iterations = atoi(optarg);
> +			p.iterations = atoi_paranoid(optarg);
>  			break;
>  		case 'p':
>  			p.phys_offset = strtoull(optarg, NULL, 0);
> @@ -430,12 +497,12 @@ int main(int argc, char *argv[])
>  			guest_percpu_mem_size = parse_size(optarg);
>  			break;
>  		case 'f':
> -			p.wr_fract = atoi(optarg);
> +			p.wr_fract = atoi_paranoid(optarg);
>  			TEST_ASSERT(p.wr_fract >= 1,
>  				    "Write fraction cannot be less than one");
>  			break;
>  		case 'v':
> -			nr_vcpus = atoi(optarg);
> +			nr_vcpus = atoi_paranoid(optarg);
>  			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
>  				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
>  			break;
> @@ -446,7 +513,7 @@ int main(int argc, char *argv[])
>  			p.backing_src = parse_backing_src_type(optarg);
>  			break;
>  		case 'x':
> -			p.slots = atoi(optarg);
> +			p.slots = atoi_paranoid(optarg);
>  			break;
>  		case 'h':
>  		default:
> @@ -455,6 +522,14 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> +	if (nr_lcpus != -1) {
> +		TEST_ASSERT(nr_lcpus == nr_vcpus + 1,
> +			    "Number of logical cpus (%d) is not equal to the number of vcpus + 1 (%d).",
> +			    nr_lcpus, nr_vcpus);
> +		assign_dirty_log_perf_test_cpu(lcpu_list[nr_vcpus]);
> +		p.vcpu_to_lcpu = lcpu_list;
> +	}
> +
>  	TEST_ASSERT(p.iterations >= 2, "The test should have at least two iterations");
>  
>  	pr_info("Test iterations: %"PRIu64"\n",	p.iterations);
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index eaa88df0555a..bd6c566cfc92 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -53,7 +53,8 @@ void perf_test_destroy_vm(struct kvm_vm *vm);
>  
>  void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
>  
> -void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
> +void perf_test_start_vcpu_threads(int vcpus, int *vcpus_to_lcpu,
> +				  void (*vcpu_fn)(struct perf_test_vcpu_args *));
>  void perf_test_join_vcpu_threads(int vcpus);
>  void perf_test_guest_code(uint32_t vcpu_id);
>  
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 9618b37c66f7..771fbdf3d2c2 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -2,11 +2,14 @@
>  /*
>   * Copyright (C) 2020, Google LLC.
>   */
> +#define _GNU_SOURCE
>  #include <inttypes.h>
>  
>  #include "kvm_util.h"
>  #include "perf_test_util.h"
>  #include "processor.h"
> +#include <pthread.h>
> +#include <sched.h>
>  
>  struct perf_test_args perf_test_args;
>  
> @@ -260,10 +263,15 @@ static void *vcpu_thread_main(void *data)
>  	return NULL;
>  }
>  
> -void perf_test_start_vcpu_threads(int nr_vcpus,
> +void perf_test_start_vcpu_threads(int nr_vcpus, int *vcpu_to_lcpu,
>  				  void (*vcpu_fn)(struct perf_test_vcpu_args *))
>  {
> -	int i;
> +	int i, err = 0;
> +	pthread_attr_t attr;
> +	cpu_set_t cpuset;
> +
> +	pthread_attr_init(&attr);
> +	CPU_ZERO(&cpuset);
>  
>  	vcpu_thread_fn = vcpu_fn;
>  	WRITE_ONCE(all_vcpu_threads_running, false);
> @@ -274,7 +282,24 @@ void perf_test_start_vcpu_threads(int nr_vcpus,
>  		vcpu->vcpu_idx = i;
>  		WRITE_ONCE(vcpu->running, false);
>  
> -		pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
> +		if (vcpu_to_lcpu) {
> +			CPU_SET(vcpu_to_lcpu[i], &cpuset);
> +
> +			err = pthread_attr_setaffinity_np(&attr,
> +							  sizeof(cpu_set_t),
> +							  &cpuset);
> +			TEST_ASSERT(err == 0,
> +				    "vCPU %d could not be mapped to logical cpu %d, error returned: %d\n",
> +				    i, vcpu_to_lcpu[i], err);
> +
> +			CPU_CLR(vcpu_to_lcpu[i], &cpuset);
> +		}
> +
> +		err = pthread_create(&vcpu->thread, &attr, vcpu_thread_main,
> +				     vcpu);
> +		TEST_ASSERT(err == 0,
> +			    "error in creating vcpu %d thread, error returned: %d\n",
> +			    i, err);
>  	}
>  
>  	for (i = 0; i < nr_vcpus; i++) {
> @@ -283,6 +308,7 @@ void perf_test_start_vcpu_threads(int nr_vcpus,
>  	}
>  
>  	WRITE_ONCE(all_vcpu_threads_running, true);
> +	pthread_attr_destroy(&attr);
>  }
>  
>  void perf_test_join_vcpu_threads(int nr_vcpus)
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index 6ee7e1dde404..246f8cc7bb2b 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -103,7 +103,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  	pr_info("Finished creating vCPUs\n");
>  
> -	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
> +	perf_test_start_vcpu_threads(nr_vcpus, NULL, vcpu_worker);
>  
>  	pr_info("Started all vCPUs\n");
>  
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
