Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791CF5E537A
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 21:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiIUTCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 15:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiIUTCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 15:02:18 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31E89DFA1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 12:02:16 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d82so6860591pfd.10
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 12:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=A7qJ7loq8NakX1yXI2Uuk1qgGF4MGPJUoCt7Oy1BvQs=;
        b=aRfNkY8+WQWJTMoZzWBk2IENPLbxiRij3ZHbjXFjFTRw0xcQS8dGXxWj/pht0cB7nl
         G5MS8pyKsSERHVHBPh4i/ZIX2CY4UlKAcWckwscCz+wCVZNFqemagJ9R56g/I2rf4/L9
         ELrgqt+fm9F3I4SjwFhaEK8yKSG5Mot7/YwzXYD2kb7dvZ8rh7pL2JGllcPoDVpBBymV
         0mOwEqIuspht12j5IDmEPwX0jgFXrVaBQ4WBxgquDfNF9Yq69PqWJc5XjTb4FaBjTnwm
         IKlbWFeL389A37OhxdwaTlfWwYl5k1q9gqzVvisQSjfxkaS5epQf3vNa3abtCyJIP937
         xWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=A7qJ7loq8NakX1yXI2Uuk1qgGF4MGPJUoCt7Oy1BvQs=;
        b=twot25ba+P6Hz73UM9VZu0/1iq8FaeUdNc5Lt8Z9N1s9wikyMYUUPWY4NyNfK867+n
         7lpzRR4tv00p6ynYNhhU185xk2xtNliYw8VGGKS9sT09dZr6zGREQKmEthfwiG/rm4ja
         IPcuj/5kkuupoqzMhRF8BnQqfpYLevV4LogPKfcsnOR96WDP04TO3SZBH8QfXnI3ZCNH
         p4gNTBG2lLfGn4ypt2S46o2IiA87tlnBxC/uwMgvhETziRy3b/Zqtvzplo5KlVD2mkZv
         9lRVyiH4NyMfw6JsXC4V+DyoXEpI1iMWeEpRoT5L1AWId/+my53dViDdENS6tp81OeO4
         G7kg==
X-Gm-Message-State: ACrzQf07AZCC1gUbmrpTYfKBPfAj+4x4P/+nZumltDzc4amb5MhEY2H9
        yFvZTPGwak42Qex7lUeFhp5V0w==
X-Google-Smtp-Source: AMsMyM4yMkGi15k/8sXc49YJwzzUZ4BLLinUs243eWnivvLQ0tU9aE8i3afQSxp4M9YapzsLSE9cJw==
X-Received: by 2002:a63:ed4d:0:b0:438:8ba7:e598 with SMTP id m13-20020a63ed4d000000b004388ba7e598mr25374446pgk.226.1663786936212;
        Wed, 21 Sep 2022 12:02:16 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id f11-20020a170902684b00b0016ee3d7220esm2436037pln.24.2022.09.21.12.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 12:02:15 -0700 (PDT)
Date:   Wed, 21 Sep 2022 12:02:11 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] KVM: selftests: Run dirty_log_perf_test on
 specific cpus
Message-ID: <Yytfs1+IbsFs6Yea@google.com>
References: <20220826184500.1940077-1-vipinsh@google.com>
 <20220826184500.1940077-5-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826184500.1940077-5-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022 at 11:45:00AM -0700, Vipin Sharma wrote:
> Add command line options, -c,  to run the vcpus and optionally the main
> process on the specific cpus on a host machine. This is useful as it
> provides a way to analyze performance based on the vcpus and dirty log
> worker locations, like on the different numa nodes or on the same numa
> nodes.
> 
> Link: https://lore.kernel.org/lkml/20220801151928.270380-1-vipinsh@google.com
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Suggested-by: David Matlack <dmatlack@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 23 ++++++-
>  .../selftests/kvm/include/perf_test_util.h    |  4 ++
>  .../selftests/kvm/lib/perf_test_util.c        | 62 ++++++++++++++++++-
>  3 files changed, 86 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 1346f6b5a9bd..9514b5f28b67 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -353,7 +353,7 @@ static void help(char *name)
>  	puts("");
>  	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
>  	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
> -	       "[-x memslots]\n", name);
> +	       "[-x memslots] [-c physical cpus to run test on]\n", name);
>  	puts("");
>  	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
>  	       TEST_HOST_LOOP_N);
> @@ -383,6 +383,18 @@ static void help(char *name)
>  	backing_src_help("-s");
>  	printf(" -x: Split the memory region into this number of memslots.\n"
>  	       "     (default: 1)\n");
> +	printf(" -c: Comma separated values of the physical CPUs, which will run\n"
> +	       "     the vCPUs, optionally, followed by the main application thread cpu.\n"
> +	       "     Number of values must be at least the number of vCPUs.\n"
> +	       "     The very next number is used to pin main application thread.\n\n"
> +	       "     Example: ./dirty_log_perf_test -v 3 -c 22,23,24,50\n"
> +	       "     This means that the vcpu 0 will run on the physical cpu 22,\n"
> +	       "     vcpu 1 on the physical cpu 23, vcpu 2 on the physical cpu 24\n"
> +	       "     and the main thread will run on cpu 50.\n\n"
> +	       "     Example: ./dirty_log_perf_test -v 3 -c 22,23,24\n"
> +	       "     Same as the previous example except now main application\n"
> +	       "     thread can run on any physical cpu\n\n"
> +	       "     (default: No cpu mapping)\n");
>  	puts("");
>  	exit(0);
>  }
> @@ -398,6 +410,7 @@ int main(int argc, char *argv[])
>  		.slots = 1,
>  	};
>  	int opt;
> +	const char *pcpu_list = NULL;
>  
>  	dirty_log_manual_caps =
>  		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> @@ -406,11 +419,14 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "b:ef:ghi:m:nop:s:v:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "b:c:ef:ghi:m:nop:s:v:x:")) != -1) {
>  		switch (opt) {
>  		case 'b':
>  			guest_percpu_mem_size = parse_size(optarg);
>  			break;
> +		case 'c':
> +			pcpu_list = optarg;
> +			break;
>  		case 'e':
>  			/* 'e' is for evil. */
>  			run_vcpus_while_disabling_dirty_logging = true;
> @@ -459,6 +475,9 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> +	if (pcpu_list)
> +		perf_test_setup_pinning(pcpu_list, nr_vcpus);
> +
>  	TEST_ASSERT(p.iterations >= 2, "The test should have at least two iterations");
>  
>  	pr_info("Test iterations: %"PRIu64"\n",	p.iterations);
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index eaa88df0555a..d02619f153a2 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -27,6 +27,8 @@ struct perf_test_vcpu_args {
>  	/* Only used by the host userspace part of the vCPU thread */
>  	struct kvm_vcpu *vcpu;
>  	int vcpu_idx;
> +	bool pin_pcpu;
> +	int pcpu;
>  };
>  
>  struct perf_test_args {
> @@ -60,4 +62,6 @@ void perf_test_guest_code(uint32_t vcpu_id);
>  uint64_t perf_test_nested_pages(int nr_vcpus);
>  void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);
>  
> +int perf_test_setup_pinning(const char *pcpus_string, int nr_vcpus);
> +
>  #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 9618b37c66f7..7a1e8223e7c7 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -2,7 +2,10 @@
>  /*
>   * Copyright (C) 2020, Google LLC.
>   */
> +#define _GNU_SOURCE
> +
>  #include <inttypes.h>
> +#include <sched.h>
>  
>  #include "kvm_util.h"
>  #include "perf_test_util.h"
> @@ -240,9 +243,26 @@ void __weak perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_v
>  	exit(KSFT_SKIP);
>  }
>  
> +static void pin_me_to_pcpu(int pcpu)
> +{
> +	cpu_set_t cpuset;
> +	int err;
> +
> +	CPU_ZERO(&cpuset);
> +	CPU_SET(pcpu, &cpuset);
> +	errno = 0;

No need to set errno explicitly here since sched_setaffinity() is
defined to set errno if it returns -1.

> +	err = sched_setaffinity(0, sizeof(cpu_set_t), &cpuset);
> +	TEST_ASSERT(err == 0, "sched_setaffinity errored out: %d\n", errno);

TEST_ASSERT() already prints errno. It would be more useful to print
@pcpu to help the user debug the failure.

Also, use "()" after function names.

> +}
> +
>  static void *vcpu_thread_main(void *data)
>  {
>  	struct vcpu_thread *vcpu = data;
> +	int idx = vcpu->vcpu_idx;
> +	struct perf_test_vcpu_args *vcpu_args = &perf_test_args.vcpu_args[idx];
> +
> +	if (vcpu_args->pin_pcpu)
> +		pin_me_to_pcpu(vcpu_args->pcpu);
>  
>  	WRITE_ONCE(vcpu->running, true);
>  
> @@ -255,7 +275,7 @@ static void *vcpu_thread_main(void *data)
>  	while (!READ_ONCE(all_vcpu_threads_running))
>  		;
>  
> -	vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_idx]);
> +	vcpu_thread_fn(vcpu_args);
>  
>  	return NULL;
>  }
> @@ -292,3 +312,43 @@ void perf_test_join_vcpu_threads(int nr_vcpus)
>  	for (i = 0; i < nr_vcpus; i++)
>  		pthread_join(vcpu_threads[i].thread, NULL);
>  }
> +
> +int perf_test_setup_pinning(const char *pcpus_string, int nr_vcpus)
> +{
> +	char delim[2] = ",";
> +	char *cpu, *cpu_list;
> +	int i = 0, pcpu_num;
> +
> +	cpu_list = strdup(pcpus_string);
> +	TEST_ASSERT(cpu_list, "strdup() allocation failed.\n");
> +
> +	cpu = strtok(cpu_list, delim);
> +
> +	// 1. Get all pcpus for vcpus
> +	while (cpu && i < nr_vcpus) {
> +		pcpu_num = atoi_paranoid(cpu);
> +		TEST_ASSERT(pcpu_num >= 0, "Invalid cpu number: %d\n", pcpu_num);
> +
> +		perf_test_args.vcpu_args[i].pin_pcpu = true;

Since pinning vCPU is all or nothing, this can be a single bool instead
of per-vCPUs.

        /* True if vCPUs are pinned to pCPUs. */
        perf_test_args.pin_vcpus

        /* The pCPU to which this vCPU is pinned. Only valid if pin_vcpus is true. */
        perf_test_args.vcpus_args[i].pcpu

> +		perf_test_args.vcpu_args[i++].pcpu = pcpu_num;
> +
> +		cpu = strtok(NULL, delim);
> +	}
> +
> +	TEST_ASSERT(i == nr_vcpus,
> +		    "Number of pcpus (%d) not sufficient for the number of vcpus (%d).",
> +		    i, nr_vcpus);
> +
> +	// 2. Check if main worker is provided
> +	if (cpu) {
> +		pcpu_num = atoi_paranoid(cpu);
> +		TEST_ASSERT(pcpu_num >= 0, "Invalid cpu number: %d\n", pcpu_num);

nite: Create a helper function for this since it's repeated twice.

> +
> +		pin_me_to_pcpu(pcpu_num);
> +
> +		cpu = strtok(NULL, delim);

Delete?

> +	}
> +
> +	free(cpu_list);
> +	return i;

The return value is unused. Drop it until we have a usecase for it.

> +}
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
