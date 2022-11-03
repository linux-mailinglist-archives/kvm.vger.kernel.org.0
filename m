Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B4D618466
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 17:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiKCQ2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 12:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiKCQ2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 12:28:06 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2F81AD81
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 09:27:49 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id k7so2419136pll.6
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 09:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XI7xJ9FcCd2sQsuSADvkPYfyoArXXY1JDVSYnlVZfN8=;
        b=rpWKQRdSZ9L+x3GavaYovrFG3UnR7hpVV0B9TyvYtUyVFmkM4pQdpdMFZK+VjWQHlW
         pnoAjrmORii8Cz+pCzO4G2IMYucL1Bd3WrtDey4e28v3N94gyAafsQTmOw3Ws0sa3XLn
         ktrGhBw7RZ+j13g7/SxnBPMjaUghY7V+23DUCyKd1JCDehcmY+TbJvs8tufx4454XHeP
         BpRdVMv9NXF9L5uIwbGrtBkdzEw0v4jYm15LGF+b+VSrcRmVUtSliQS2HCPCGbbaad6d
         bnHUYYoPNa7tfGFYPAEMeL/g6Ap/eEkY7l/U2xQQ6jm5GYkwxw63IhhonEAkZOFCED+i
         cgeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XI7xJ9FcCd2sQsuSADvkPYfyoArXXY1JDVSYnlVZfN8=;
        b=MW8dj3JNcdnkzDO1BCDiaT0uFcYoiOlKJHAvSSSvVUTJIhmF1JxLRtGQpmgHbV7hZX
         8Jxw5vOi9Yu/CPO2+xnuQJr3hdPactWJV4432tXSgzqk4M1S6Hs5PUvO+9vnjhlwqNWa
         tZibHOdCnSvbGR9WcFjmTxymgIeY2jVw1SLVReVo64/yPq3xJtmge+tIkRr1M+504m1t
         QKlHGmRnSbprWMSvGDw1WuTvDA6L7WGmRHn3/lFWDJECuzZ5FHcXTAyF1r0BnLsnzAn/
         qAxyFCAsJvvZm7DDi5ork5zKpqzzlAWbkPzjAs+LedxzpqYvOJAevDL+t8Mf611WR1ro
         uprQ==
X-Gm-Message-State: ACrzQf1dCOVqI+RvFGDlNXsOm4bREQDz/YK/gGBglgDPKGfHjVV6H+6v
        9YiCi6IxL6afLQimP603qcpNhg==
X-Google-Smtp-Source: AMsMyM4G/fGvseZHrq7leZ/A31NUu3xgVzOmWQ9VLhzWNmC7nD5nlxPht7zgjWSjdyqmVnAAXeHEOg==
X-Received: by 2002:a17:90a:4e85:b0:213:13f2:162b with SMTP id o5-20020a17090a4e8500b0021313f2162bmr32303176pjh.228.1667492868488;
        Thu, 03 Nov 2022 09:27:48 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id bb16-20020a17090b009000b00212d4cbcbfdsm188724pjb.22.2022.11.03.09.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 09:27:48 -0700 (PDT)
Date:   Thu, 3 Nov 2022 09:27:44 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v9 2/4] KVM: selftests: create -r argument to specify
 random seed
Message-ID: <Y2PsAAmRX78Dky2l@google.com>
References: <20221102160007.1279193-1-coltonlewis@google.com>
 <20221102160007.1279193-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102160007.1279193-3-coltonlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022 at 04:00:05PM +0000, Colton Lewis wrote:
> Create a -r argument to specify a random seed. If no argument is
> provided, the seed defaults to 1. The random seed is set with
> perf_test_set_random_seed() and must be set before guest_code runs to
> apply.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c    | 12 ++++++++++--
>  tools/testing/selftests/kvm/include/perf_test_util.h |  2 ++
>  tools/testing/selftests/kvm/lib/perf_test_util.c     |  6 ++++++
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index f99e39a672d3..c97a5e455699 100644
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
> @@ -225,6 +226,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  				 p->slots, p->backing_src,
>  				 p->partition_vcpu_memory_access);
>  
> +	/* If no argument provided, random seed will be 1. */
> +	pr_info("Random seed: %u\n", p->random_seed);
> +	perf_test_set_random_seed(vm, p->random_seed ? p->random_seed : 1);

If the user passes `-r 0` or does not pass `-r` at all, this will print
"Random seed: 0" and then proceed to use 1 as the random seed, which
seems unnecessarily misleading.

If you want the default random seed to be 1, you can initialize
p.random_seed to 1 before argument parsing (where all the other
test_params are default initialized), then the value you print here will
be accurate and you don't need the comment or ternary operator.

>  	perf_test_set_wr_fract(vm, p->wr_fract);
>  
>  	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
> @@ -352,7 +356,7 @@ static void help(char *name)
>  {
>  	puts("");
>  	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
> -	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
> +	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
>  	       "[-x memslots]\n", name);
>  	puts("");
>  	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
> @@ -380,6 +384,7 @@ static void help(char *name)
>  	printf(" -v: specify the number of vCPUs to run.\n");
>  	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>  	       "     them into a separate region of memory for each vCPU.\n");
> +	printf(" -r: specify the starting random seed.\n");
>  	backing_src_help("-s");
>  	printf(" -x: Split the memory region into this number of memslots.\n"
>  	       "     (default: 1)\n");
> @@ -406,7 +411,7 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
>  		switch (opt) {
>  		case 'e':
>  			/* 'e' is for evil. */
> @@ -442,6 +447,9 @@ int main(int argc, char *argv[])
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
> 2.38.1.273.g43a17bfeac-goog
> 
