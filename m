Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704E25B3DA6
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 19:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIIRIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 13:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiIIRIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 13:08:42 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D605167C7
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 10:08:39 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 65so2273594pfx.0
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 10:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Kof9aPY5yigPY3DCgD1OndAAoW+AwfLSgN8DavIgLv4=;
        b=rk0ScoEROFaCl0/7J8OOifdqDTeJxLR+4IKp70wZTPlLVO+eP0Tp5hNrOLnuFTYrXr
         jOgsa9AqnfdGQ7seeyqBUK9/h4cN8ADg30XhcpXfyYwYGVMe5waRZoS8vbNmSVwEUppV
         BomgzVtVcq76yUAkXzQmeYATtMIPd6lZl/+bgVj2l4papq0Iq5+YEQTtnE/v3kbOePHC
         BA7ZWcmW5AAWGAQ00YlCA/feAkfgJWgE24IV9i62u32R+EyICI0gM5CitzYg8zxWxQtx
         o5XjXkk7JFzXdlBEgaYrGXNlovc+LvXtLJFOur1yRJiVCa81cSklVR0ppin5IUK79PiL
         NRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Kof9aPY5yigPY3DCgD1OndAAoW+AwfLSgN8DavIgLv4=;
        b=Nw+e2SfcezkD5B6TrvLfuyVtVznoMeGkCXbGnTFhu9CaKj3j9vYLIfFE421a/44IHI
         Tx69F+sMcLuwsUQculyofwOgY9F68SJjF67daGjjXC9pcxCmeyTqkt5aIyM1PGZYj0Jp
         2QZty8JVnylPK/eHqNhKy4pba9KkCnrdBfMR041aQBGc9ANkMiKVjPPppR0N0HkMVMwY
         7+APbE+1Vrbalk2uPOHSqRM4p7iCr7Rnkpv827T4ZqSy1Vh5kh5W4H27ZkXPdhbArCtd
         +HcSMzpN1BcgRO6nyPM9SI9T33VjqZnLQ5Me934vB6foCyYNErSmxIYVEjXnnKZAXQFm
         q87g==
X-Gm-Message-State: ACgBeo3LiyMIXUD4xCw310kpiCvUkO/7g8TAAsNIFMTXNOYNTF88UgBb
        44OJzI6qRudDwnpLUXUHIeyj+Q==
X-Google-Smtp-Source: AA6agR7mv9XyCVEaoah8tk+lRLpVb8G2V39pwZbxRl4oteVZd/l0voAebO1HY6hx3HsF6WZi3sa5Qg==
X-Received: by 2002:a65:6e4a:0:b0:438:874c:53fd with SMTP id be10-20020a656e4a000000b00438874c53fdmr3814771pgb.355.1662743318692;
        Fri, 09 Sep 2022 10:08:38 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id a30-20020a631a5e000000b0042b2311f749sm747604pgm.19.2022.09.09.10.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 10:08:37 -0700 (PDT)
Date:   Fri, 9 Sep 2022 10:08:32 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v5 1/3] KVM: selftests: implement random number
 generation for guest code
Message-ID: <YxtzEJ9HMLPqMqN4@google.com>
References: <20220909124300.3409187-1-coltonlewis@google.com>
 <20220909124300.3409187-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909124300.3409187-2-coltonlewis@google.com>
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

On Fri, Sep 09, 2022 at 12:42:58PM +0000, Colton Lewis wrote:
> Implement random number generation for guest code to randomize parts
> of the test, making it less predictable and a more accurate reflection
> of reality.
> 
> Create a -r argument to specify a random seed. If no argument is
> provided, the seed defaults to the current Unix timestamp. The random
> seed is set with perf_test_set_random_seed() and must be set before
> guest_code runs to apply.
> 
> The random number generator chosen is the Park-Miller Linear
> Congruential Generator, a fancy name for a basic and well-understood
> random number generator entirely sufficient for this purpose. Each
> vCPU calculates its own seed by adding its index to the seed provided.

Great commit message!

> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c    | 12 ++++++++++--
>  tools/testing/selftests/kvm/include/perf_test_util.h |  2 ++
>  tools/testing/selftests/kvm/include/test_util.h      |  2 ++
>  tools/testing/selftests/kvm/lib/perf_test_util.c     | 11 ++++++++++-
>  tools/testing/selftests/kvm/lib/test_util.c          |  9 +++++++++
>  5 files changed, 33 insertions(+), 3 deletions(-)
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

It's a bad code smell that the random seed gets default initialized to
time(NULL) twice (here and in perf_test_create_vm()).

I also still think it would be better if the default random seed was
consistent across runs. Most use-cases of dirty_log_perf_test is for A/B
testing, so consistency is key. For example, running dirty_log_perf_test
at every commit to find regressions, or running dirty_log_perf_test to
study the performance effects of some change. In other words, I think
most use-cases will want a consistent seed across runs, so the default
behavior should match that. Otherwise I forsee myself (and automated
tools) having to pass in -r to every test runs to get consistent,
comparable, behavior.

What do you think about killing 2 birds with one stone here and make the
default random_seed 0. That requires no initialization and ensures
consistent random behavior across runs.

And then optionally... I would even recommend dropping the -r parameter
until someone wants to run dirty_log_perf_test with different seeds.
That would simplify the code even more. I have a feeling there won't be
much interest in different seeds since, at the end of the day, it will
always be the same rough distribution of accesses. More interesting than
different seeds will be adding support for different types of access
patterns.
