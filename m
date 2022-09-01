Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8F15A9E63
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 19:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbiIARpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 13:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiIARpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 13:45:03 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7245C340
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 10:44:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id n65-20020a17090a5ac700b001fbb4fad865so3416960pji.1
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 10:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=+/BCAIqtV+vwVZj2X7fGlHMc4J8edyLbzuoLd9z7kHY=;
        b=HEp1m2oQCqt0fvoDyhrBnaZ5QPKGmC5Wx4PffhWlY7ZX8wtHF5PqMH271ZItmextUQ
         oD1US8YYezQhz3jNz7CxxLwVBTOXwleKtoNeHGkMWv2afC6JoUSQjkJjsz+mXhMxdgpg
         oskpusmu26pPgjdGNwcktErr1Mxb2Rw8kanSHOGpSGWJGbVdciOAIO/DEc/q1oUpLEzn
         gDJeMeSklQ900X+Ci8t8ugaYBxVIXZXz5anNhts5ikgyqRQ3dyZwdTsEsIwJpRHtJEKS
         sO6pizZYaANEEkZyAboSAQDMh8I/diT8qarWKkMHTn++bKuiLqcpfHzpBAGLzTfUoxT9
         vRhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+/BCAIqtV+vwVZj2X7fGlHMc4J8edyLbzuoLd9z7kHY=;
        b=NqYbdx16a1bie4OGmPSvFvmnJNq+QodN6C+bLi+Emvc8O7gyTpz7H9BMYL2ZftvI5f
         +z4UVbd8SrTPR6srAwgrIo6hPbAU0q/GtPShfL0KBituezBRvYILb6nNAOjbbM4yjq2A
         /RpzU4E5+HSRBmYqm1D5K3H6zK5Xp2lLe/vEhvvtRotQtiPji6IqQYv6QDbucWr6tR5M
         Qs89zCln8sXTMo/LGJQo2zOhCz+L2vuOMRJ1DkNC8qtRgwUWlEzHKPMSSJb9/yEKh4Jo
         xZvA7ZMO/vvCnm8M+qPj4t5OoG1ont7wQyQ/yShRpbLzq2WnBpJlUoaxGdBRWfVaHIW6
         gUTA==
X-Gm-Message-State: ACgBeo3SrvIMDMMLfiNZK3ZwSfEWsc1CjjCDwWS+xG7ka/Gg7TExSXWM
        JF7DViEdqRDSly4Xo88lHjEjyQ==
X-Google-Smtp-Source: AA6agR6e0Bo46n+mGFtxOjZBJW15uwE0+IQNS2TFmEpIKn2Rd9exOYQ1paysAQnDhSIRgCqarL+Y6g==
X-Received: by 2002:a17:902:d885:b0:172:868f:188c with SMTP id b5-20020a170902d88500b00172868f188cmr31319346plz.78.1662054239672;
        Thu, 01 Sep 2022 10:43:59 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id l22-20020a17090af8d600b001f1acb6c3ebsm3598515pjd.34.2022.09.01.10.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 10:43:57 -0700 (PDT)
Date:   Thu, 1 Sep 2022 10:43:51 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, oupton@google.com
Subject: Re: [PATCH v2 3/3] KVM: selftests: Randomize page access order.
Message-ID: <YxDvVyFpMC9U3O25@google.com>
References: <20220817214146.3285106-1-coltonlewis@google.com>
 <20220817214146.3285106-4-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817214146.3285106-4-coltonlewis@google.com>
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

Hey Colton,

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

I think addr and write_percent need two different random numbers.
Otherwise, you will end up with a situation where all addresses where
(rnd_arr[i] % 100 < pta->write_percent) will get a write (always).
Something like this:

	012345678    <= address
	wwwrrrwww
	837561249    <= access order

I think the best way to fix this is to abstract the random number
reading into something like get_next_rand(), and use it twice per
iteration.

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

Thanks,
Ricardo
