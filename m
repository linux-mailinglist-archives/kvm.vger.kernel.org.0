Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7CE5A31FF
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 00:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345343AbiHZWWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 18:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345364AbiHZWWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 18:22:00 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D529613D54
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 15:20:28 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g189so2595340pgc.0
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 15:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=eIVctWzrdKiWQXaMMc+IstZeUYp8//EMELD6bvxM7tw=;
        b=m1ZV1HCAaf19iPeSgEzCQjyYIVGPnzU8kgx/8hr52Q/cYDzv6i7yZoGzCRZc1YLjE3
         WuDqHUxn466XLVr6k7fBEaSqZl4iA5op1Uc5KROU8Cnyj/QJ9FZRDsSDhzwrgm1fK0gL
         26qfAfZ03p61XsOFrvqMURsuLp2hnkPXjAF3ofxhR7VN+DRpvXeMHosj9N1idd4W46nR
         AbCnAwzmmz4GjPrZgBEUPklU0GRBc8W9EAId8QEXOTl2kkUIExku9TvxuzoLQXAQsPNF
         IIgzkRLOZ7ZxLp6uk5X+qKqludMFaE8GKDt6NI7ORxNmR7RxYUBfdAjD+pNMxVnokcb0
         ZsRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=eIVctWzrdKiWQXaMMc+IstZeUYp8//EMELD6bvxM7tw=;
        b=WJek4Gx1wUlPH1Fzt4ZVSSSbUUIZbAEmJI4NzdqAGEpDxKIIdwDzsau1yDpL7KdWHk
         tO0DWGRJw7Jkn9P8wOBOU9QbX4a6LP/dnvW7CLwQxZTUfLeBDPcOYXx22n1i8CaEu6GR
         KLgxry+zh/sq0tpDnx9NzeA124ek1nrENEI2cDaFSM1Z2nN2c7ZIUz8ZBNQjdJOFIR2D
         Kxu+zBjROTErXwfdS4TfZxgG1B0+QSsu32LVmKHNyeHEMyX4FIEoOVSQk05WCy5R8cV2
         QTRKIOvN9unWgMMUKeUSfHIn+R5YnsWgU16jAHeUNvzQVZGGV+jVIAUmoBjpWH1Jjeil
         mbhA==
X-Gm-Message-State: ACgBeo273ChZGTA5gMZtOEutf2Inj++GWzdg2rKkGHcXC7pT/9Z+CN69
        gAM0Vns0K2niSMx8NS6LbNvEow==
X-Google-Smtp-Source: AA6agR7/1pEGt4pm/xP6vNTMO7RvdMiJZylHmAShhDNvKry0AYj6+OVTBKfcM+TZrzXzRduemHEqpg==
X-Received: by 2002:a05:6a00:1312:b0:536:fefd:e64a with SMTP id j18-20020a056a00131200b00536fefde64amr5738192pfu.26.1661552428180;
        Fri, 26 Aug 2022 15:20:28 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id f60-20020a17090a704200b001f319e9b9e5sm2163640pjk.16.2022.08.26.15.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 15:20:27 -0700 (PDT)
Date:   Fri, 26 Aug 2022 15:20:22 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v2 3/3] KVM: selftests: Randomize page access order.
Message-ID: <YwlHJnZORkp2XRmJ@google.com>
References: <20220817214146.3285106-1-coltonlewis@google.com>
 <20220817214146.3285106-4-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817214146.3285106-4-coltonlewis@google.com>
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

On Wed, Aug 17, 2022 at 09:41:46PM +0000, Colton Lewis wrote:
> Create the ability to randomize page access order with the -a
> argument, including the possibility that the same pages may be hit
> multiple times during an iteration or not at all.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c   | 10 +++++++++-
>  .../testing/selftests/kvm/include/perf_test_util.h  |  2 ++
>  tools/testing/selftests/kvm/lib/perf_test_util.c    | 13 ++++++++++++-
>  3 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 9226eeea79bc..af9754bda0a4 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -133,6 +133,7 @@ struct test_params {
>  	int slots;
>  	uint32_t write_percent;
>  	uint32_t random_seed;
> +	bool random_access;
>  };
>  
>  static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
> @@ -271,6 +272,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
>  		ts_diff.tv_sec, ts_diff.tv_nsec);
>  
> +	/* Set random access here, after population phase. */
> +	perf_test_set_random_access(vm, p->random_access);

Optional suggestion: We don't have any use-case for disabling random
access, so perhaps this would be simpler as:

  if (p->random_access)
          perf_test_enable_random_access(vm);

And then:

  void perf_test_enable_random_access(struct kvm_vm *vm)
  {
          perf_test_args.random_access = true;
          sync_global_to_guest(vm, perf_test_args);
  }

> +
>  	while (iteration < p->iterations) {
>  		/*
>  		 * Incrementing the iteration number will start the vCPUs
> @@ -353,10 +357,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  static void help(char *name)
>  {
>  	puts("");
> -	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
> +	printf("usage: %s [-h] [-a] [-i iterations] [-p offset] [-g] "
>  	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
>  	       "[-x memslots] [-w percentage]\n", name);
>  	puts("");
> +	printf(" -a: access memory randomly rather than in order.\n");
>  	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
>  	       TEST_HOST_LOOP_N);
>  	printf(" -g: Do not enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2. This\n"
> @@ -413,6 +418,9 @@ int main(int argc, char *argv[])
>  
>  	while ((opt = getopt(argc, argv, "eghi:p:m:nb:v:or:s:x:w:")) != -1) {
>  		switch (opt) {
> +		case 'a':
> +			p.random_access = true;
> +			break;
>  		case 'e':
>  			/* 'e' is for evil. */
>  			run_vcpus_while_disabling_dirty_logging = true;
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index 8da4a839c585..237899f3f4fe 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -41,6 +41,7 @@ struct perf_test_args {
>  
>  	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
>  	bool nested;
> +	bool random_access;
>  
>  	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
>  };
> @@ -55,6 +56,7 @@ void perf_test_destroy_vm(struct kvm_vm *vm);
>  
>  void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
>  void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
> +void perf_test_set_random_access(struct kvm_vm *vm, bool random_access);
>  
>  void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
>  void perf_test_join_vcpu_threads(int vcpus);
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 1a6b69713337..84e442a028c0 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -48,6 +48,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
>  	uint64_t gva;
>  	uint64_t pages;
> +	uint64_t addr;
>  	uint32_t *rnd_arr = (uint32_t *)vcpu_args->random_array;
>  	int i;
>  
> @@ -59,7 +60,11 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  
>  	while (true) {
>  		for (i = 0; i < pages; i++) {
> -			uint64_t addr = gva + (i * pta->guest_page_size);
> +			if (pta->random_access)
> +				addr = gva +
> +					((rnd_arr[i] % pages) * pta->guest_page_size);
> +			else
> +				addr = gva + (i * pta->guest_page_size);
>  
>  			if (rnd_arr[i] % 100 < pta->write_percent)
>  				*(uint64_t *)addr = 0x0123456789ABCDEF;
> @@ -271,6 +276,12 @@ void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
>  	sync_global_to_guest(vm, perf_test_args);
>  }
>  
> +void perf_test_set_random_access(struct kvm_vm *vm, bool random_access)
> +{
> +	perf_test_args.random_access = random_access;
> +	sync_global_to_guest(vm, perf_test_args);
> +}
> +
>  uint64_t __weak perf_test_nested_pages(int nr_vcpus)
>  {
>  	return 0;
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
