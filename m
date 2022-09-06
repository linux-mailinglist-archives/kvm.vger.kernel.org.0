Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5505AF434
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 21:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiIFTJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 15:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIFTI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 15:08:59 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECAB9351A
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 12:08:58 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so15936303pja.4
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 12:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=o9eMi1xEck6yoG/+kDujQyRLfYlS5H6rVeCnyf1UDR8=;
        b=NNAqZ4UCVLljZ3fWhwi3CYA9tIR+dDMFA5SjHOsY+xtAeoqvFXux1WYB8VqvtzX15u
         UkK2+/tXejm/ZJkuuQ5OffoGWTVkbn217lByGhHReNUOv6ofQuDpQ0KqLmpyvE608uwI
         jEJzBM0boNPDSDb7pVBbufvW3HV3ZO5fIilZ5IcwdCKGyd5MCVJlfFoB3CE2iRGtTkrC
         DC8s5NC1c0nrYnVbqY/E/rvmO9UWXNr9PYkxiqxU4IFVtmhG8FrfDPnvdyyxjlhgi3Ch
         pkdFcLrPqHKyY12e6AEtvqoBiebaKV+h6SLW5FmpW3TN9UNMB1F24f/LMIFxtr4ywomv
         gFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=o9eMi1xEck6yoG/+kDujQyRLfYlS5H6rVeCnyf1UDR8=;
        b=UZlZjEIAEzyTgePByTjrZv4RiuOeojyWzM31cCm+sl8QnF6tKXwgHcSqk5AaxiaD/x
         LmdR6y57mb9Ac52ioqd54aLq6bMB6ib1hf75XktgJhQRULk0LxWtHjrI2aIWhnUnXenb
         Y31tmEEPlyp84KOe3c7LNXXbv/AlCXIfpNIUeSIwe+u+KsjTWbdGAOFndYvZFZClhL52
         tL9eW2aCWtPc9X5tU72+t+ZaztZpwA2E5n+2L8hW9STZhvVBEyNxtqKlfO4gYrmdZrRS
         VaHX7TG9v2Sr1omP5LKnujFQ33gXSHOodt0+i7POdKa3IUGAWAHMrmuuFNt9VdocYqa9
         FQqA==
X-Gm-Message-State: ACgBeo2CQ8WTu6RjpJNF/MZElKTNyuDhayV0PHrmg+CBIC8VSwjcvhEC
        xvWGThEm9xwaHFd8n/McThSvUA==
X-Google-Smtp-Source: AA6agR5OdSt+WFxvOTp1zyI6e9f/uPZn9pS6egGm1oMX3OC7rAiYpFZVHSjDMoJQkbwufb9ercsQug==
X-Received: by 2002:a17:903:2301:b0:176:a571:9834 with SMTP id d1-20020a170903230100b00176a5719834mr12332920plh.135.1662491338097;
        Tue, 06 Sep 2022 12:08:58 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id h14-20020a17090adb8e00b001fd6066284dsm9324067pjv.6.2022.09.06.12.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 12:08:56 -0700 (PDT)
Date:   Tue, 6 Sep 2022 12:08:53 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, oupton@google.com
Subject: Re: [PATCH v3 3/3] KVM: selftests: Randomize page access order.
Message-ID: <YxeaxaxGS5dsp3hl@google.com>
References: <20220901195237.2152238-1-coltonlewis@google.com>
 <20220901195237.2152238-4-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901195237.2152238-4-coltonlewis@google.com>
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

On Thu, Sep 01, 2022 at 07:52:37PM +0000, Colton Lewis wrote:
> Create the ability to randomize page access order with the -a
> argument, including the possibility that the same pages may be hit
> multiple times during an iteration or not at all.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../testing/selftests/kvm/dirty_log_perf_test.c  | 12 ++++++++++--
>  .../selftests/kvm/include/perf_test_util.h       |  2 ++
>  tools/testing/selftests/kvm/lib/perf_test_util.c | 16 +++++++++++++++-
>  3 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index c9441f8354be..631b3883ed12 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -127,6 +127,7 @@ struct test_params {
>  	int slots;
>  	uint32_t write_percent;
>  	uint32_t random_seed;
> +	bool random_access;
>  };
>  
>  static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
> @@ -269,6 +270,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
>  		ts_diff.tv_sec, ts_diff.tv_nsec);
>  
> +	/* Set random access here, after population phase. */
> +	perf_test_set_random_access(vm, p->random_access);
> +
>  	while (iteration < p->iterations) {
>  		/*
>  		 * Incrementing the iteration number will start the vCPUs
> @@ -339,10 +343,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
> @@ -394,8 +399,11 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {
> +	while ((opt = getopt(argc, argv, "aghi:p:m:nb:v:or:s:x:w:")) != -1) {
>  		switch (opt) {
> +		case 'a':
> +			p.random_access = true;
> +			break;
>  		case 'g':
>  			dirty_log_manual_caps = 0;
>  			break;
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index 52c450eb6b9b..380c31375b60 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -39,6 +39,7 @@ struct perf_test_args {
>  
>  	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
>  	bool nested;
> +	bool random_access;
>  
>  	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
>  };
> @@ -53,6 +54,7 @@ void perf_test_destroy_vm(struct kvm_vm *vm);
>  
>  void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
>  void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
> +void perf_test_set_random_access(struct kvm_vm *vm, bool random_access);
>  
>  void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
>  void perf_test_join_vcpu_threads(int vcpus);
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index be6176faaf8e..c6123b75d5e3 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -53,6 +53,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
>  	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_id];
>  	uint64_t gva;
>  	uint64_t pages;
> +	uint64_t addr;
>  	int i;
>  	uint32_t rand = pta->random_seed + vcpu_id;
>  
> @@ -64,7 +65,14 @@ void perf_test_guest_code(uint32_t vcpu_id)
>  
>  	while (true) {
>  		for (i = 0; i < pages; i++) {
> -			uint64_t addr = gva + (i * pta->guest_page_size);
> +			rand = perf_test_random(rand);
> +
> +			if (pta->random_access)
> +				addr = gva +
> +					((rand % pages) * pta->guest_page_size);
> +			else
> +				addr = gva + (i * pta->guest_page_size);
> +
>  			rand = perf_test_random(rand);
>  
>  			if (rand % 100 < pta->write_percent)
> @@ -240,6 +248,12 @@ void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
>  	sync_global_to_guest(vm, perf_test_args);
>  }
>  
> +void perf_test_set_random_access(struct kvm_vm *vm, bool random_access)
> +{
> +	perf_test_args.random_access = random_access;
> +	sync_global_to_guest(vm, perf_test_args);
> +}

This can be merged onto the sync_global_to_guest() done for the seed.

> +
>  uint64_t __weak perf_test_nested_pages(int nr_vcpus)
>  {
>  	return 0;
> -- 
> 2.37.2.789.g6183377224-goog
> 
