Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53F26200CF
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 22:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiKGVQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 16:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbiKGVP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 16:15:26 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8842EF51
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 13:11:52 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 64so11563764pgc.5
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 13:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uQxDTNLotBeU5vzOFGDa7HGUR31Gv4MxI4cPw2VN0VA=;
        b=jOnf79RjMrKxTkpIMgF9QlhQDCkrvQc+/rIjVJX9j8t27DdQGo1oQ069HQC9CLFnCJ
         1gHiFboOJa6U9snTTXJK+kOMszDW3ai8vrUZ6HI5iP07Kz7HYhjbyZZWoV6Hn05JsOKj
         bU1ZxkgVV73cvRl7TC9aZtQ+UKvAFL10iOBIyLSJv6jhZIUwXv4plcymz6UPk6vqQfVQ
         PQCu5s8d8mkbHfKJrejJRbmOpDDZgDG22AoetQqnFluT0Yd4JvrObXzUE38FPa5ZMQlm
         FTYx7npnEv6iP40IjrXvfariJ1ueJvPF8G81ROOCZC+/BI2dGuwxglkCdnKihECgB+78
         Uw3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQxDTNLotBeU5vzOFGDa7HGUR31Gv4MxI4cPw2VN0VA=;
        b=7R0eiKz+BdrFNtkPajsQ4+ihol9rgxARjkWhf1t/ARGC6TtK2OjlV4WMe8KIc4i9IT
         aE0d7uBxR+tAGpxRdLPTKqitL74rd8MkFFGZ289XCqKRTTIyYs0GeiZzvOMzoMNcuDnw
         w+CRGBbMvBNnsIfB8LBG+rFh5wYXoYFMCl350UGjNz6Ioyj5pkv86PgOXC7J3pJild1J
         IEbFSbcLfxZbHufOt9r9T8231c/hzSFU0CbYl6CSMqOb9+tAOjsXM3iECl/EaOQHWJpp
         x1zRb2KSvXjjLg8iKCT8G6nfVNGrYcjY68E9XoxKI69ENDVRxyrcCZHbhjuYidP+Mty4
         CQvQ==
X-Gm-Message-State: ACrzQf2qJ+yduFRAWu5bF2DZc3tZ+ADwdi1Qp8NDVj1T6c3EpgsLBMB2
        r6lMh3U5XFIZcrWE3T6iz1ipUQ==
X-Google-Smtp-Source: AMsMyM5liJeJIPS4yBMVVLnIHlSsUkGUzNnvanHyNz2oWf/qJRJEz81J8s4pOxfh86gB5dt5ZqgR/g==
X-Received: by 2002:a63:a5f:0:b0:46e:c9cf:e702 with SMTP id z31-20020a630a5f000000b0046ec9cfe702mr45835080pgk.198.1667855512007;
        Mon, 07 Nov 2022 13:11:52 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id mm11-20020a17090b358b00b0020d24ea4400sm6586623pjb.38.2022.11.07.13.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 13:11:51 -0800 (PST)
Date:   Mon, 7 Nov 2022 13:11:47 -0800
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v10 2/4] KVM: selftests: create -r argument to specify
 random seed
Message-ID: <Y2l0kyyy1POrNS6u@google.com>
References: <20221107182208.479157-1-coltonlewis@google.com>
 <20221107182208.479157-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107182208.479157-3-coltonlewis@google.com>
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

On Mon, Nov 07, 2022 at 06:22:06PM +0000, Colton Lewis wrote:
> Create a -r argument to specify a random seed. If no argument is
> provided, the seed defaults to 1. The random seed is set with
> perf_test_set_random_seed() and must be set before guest_code runs to
> apply.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c  | 14 ++++++++++++--
>  .../testing/selftests/kvm/include/perf_test_util.h |  2 ++
>  tools/testing/selftests/kvm/lib/perf_test_util.c   |  6 ++++++
>  3 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index f99e39a672d3..f74a78138df3 100644
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
> @@ -225,6 +226,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  				 p->slots, p->backing_src,
>  				 p->partition_vcpu_memory_access);
>  
> +	pr_info("Random seed: %u\n", p->random_seed);
> +	perf_test_set_random_seed(vm, p->random_seed);
>  	perf_test_set_wr_fract(vm, p->wr_fract);
>  
>  	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
> @@ -352,7 +355,7 @@ static void help(char *name)
>  {
>  	puts("");
>  	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
> -	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
> +	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
>  	       "[-x memslots]\n", name);
>  	puts("");
>  	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
> @@ -380,6 +383,7 @@ static void help(char *name)
>  	printf(" -v: specify the number of vCPUs to run.\n");
>  	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>  	       "     them into a separate region of memory for each vCPU.\n");
> +	printf(" -r: specify the starting random seed.\n");
>  	backing_src_help("-s");
>  	printf(" -x: Split the memory region into this number of memslots.\n"
>  	       "     (default: 1)\n");
> @@ -396,6 +400,7 @@ int main(int argc, char *argv[])
>  		.partition_vcpu_memory_access = true,
>  		.backing_src = DEFAULT_VM_MEM_SRC,
>  		.slots = 1,
> +		.random_seed = 1,
>  	};
>  	int opt;
>  
> @@ -406,7 +411,7 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
>  		switch (opt) {
>  		case 'e':
>  			/* 'e' is for evil. */
> @@ -442,6 +447,11 @@ int main(int argc, char *argv[])
>  		case 'o':
>  			p.partition_vcpu_memory_access = false;
>  			break;
> +		case 'r':
> +			p.random_seed = atoi(optarg);
> +			TEST_ASSERT(p.random_seed > 0,
> +				    "Invalid random seed, must be greater than 0");
> +			break;
>  		case 's':
>  			p.backing_src = parse_backing_src_type(optarg);
>  			break;
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index eaa88df0555a..f1050fd42d10 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -35,6 +35,7 @@ struct perf_test_args {
>  	uint64_t gpa;
>  	uint64_t size;
>  	uint64_t guest_page_size;
> +	uint32_t random_seed;
>  	int wr_fract;
>  
>  	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
> @@ -52,6 +53,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  void perf_test_destroy_vm(struct kvm_vm *vm);
>  
>  void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
> +void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
>  
>  void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
>  void perf_test_join_vcpu_threads(int vcpus);
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 9618b37c66f7..0bb0659b9a0d 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -229,6 +229,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
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
> -- 
> 2.38.1.431.g37b22c650d-goog
> 
