Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D0858F4EA
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 01:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbiHJXdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 19:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiHJXdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 19:33:51 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7002184EEA
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 16:33:50 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id t22so16231810pjy.1
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 16:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=k5s6kLr9BjRGw2K775MBEjnMd/QwQNtQ/TX5UjErDkQ=;
        b=rt8xPAtFbh0tAbhfZ7vv+XaBnLWOGI5+o9zjz5GXXSID4adfvbJi0d05x4L2GP09ex
         guNR08lHt8PjGRE0ijLs9sYifxupHilw/SKdQzKw4XQ6gtPyaDpyCvbkuCGjy/bOYkAu
         XL4AWHpP9diqhaQJ9SGdDqXEPIS+FixTeSuryW5/eRoUSI06mMHtmACDkd8CLpxHwzj9
         GTuGkmL85LPxuQs19bd28yy7j0ylAFNyVY3Q4WyRGdwO7DILYujhDv58FMLdVBQOWwDA
         15/Zx8ULYwlDa4VLyXE9qyBIm56G4yeAv+hwPAzAxx4K9o8QxQ74cGZViJ7896cLwSRJ
         BX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=k5s6kLr9BjRGw2K775MBEjnMd/QwQNtQ/TX5UjErDkQ=;
        b=1YnXjvB/nDLQ+qz1l1rtp0ZI/UC+LSxVuXKjorWNFvm2VSC3BFuo4Mz3g4IpGzSe8B
         ySe6Us+cbiF0SH6yahin9CbxWMFqFxAGg2V2pgMUKkYLc3L1K9obiVhPRy6qWGl56yGM
         f/Sfxvy9mE0fUk2Cb4KucNqdFFGqE6LjyYtntk87BYjRCSJLOuThQrxTwQ8/YMBeA0Cm
         TPgOB91ZrDukNDku6P5mJpp+iILklcgc0JGk3W9gQUOM+2dUMNljegWwCXfwv9aSrvjP
         Q/gcUQpsyRrsygaJfa7TH85fQSiyDp08NM6QgKXyHVlUayntjkPhu/YkgzKj3d9Yc7wo
         /umw==
X-Gm-Message-State: ACgBeo30MqevynRv21t5Qp492DuxngdYTzeC26bu8M2YKOT3yRHU5nwN
        oefsFcw+8Iok08h3oj+k0NylUw==
X-Google-Smtp-Source: AA6agR7+AigVcim7b/kB+NY8DTt5pMNTMcDZXxn7m7VDwN4CCFE6u+b3424Q69Z0aIkUbttMn5+4Zw==
X-Received: by 2002:a17:902:ab0f:b0:16d:b340:bf8f with SMTP id ik15-20020a170902ab0f00b0016db340bf8fmr29867133plb.140.1660174429764;
        Wed, 10 Aug 2022 16:33:49 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id x129-20020a623187000000b0052e82671a57sm2588212pfx.73.2022.08.10.16.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 16:33:48 -0700 (PDT)
Date:   Wed, 10 Aug 2022 16:33:44 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH 2/3] KVM: selftests: Randomize which pages are written vs
 read
Message-ID: <YvRAWKGXbPzool6j@google.com>
References: <20220810175830.2175089-1-coltonlewis@google.com>
 <20220810175830.2175089-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810175830.2175089-3-coltonlewis@google.com>
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

On Wed, Aug 10, 2022 at 05:58:29PM +0000, Colton Lewis wrote:
> Randomize which pages are written vs read by using the random number

Same thing here about stating what the patch does first.

> table for each page modulo 100. This changes how the -w argument

s/-f/-w/

Although I would love it if you renamed -f to -w in the code instead.

> works. It is now a percentage from 0 to 100 inclusive that represents
> what percentage of accesses are writes. It keeps the same default of
> 100 percent writes.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c | 12 +++++++-----

access_tracking_perf_test.c also uses wr_fract and will need to be
updated.

>  tools/testing/selftests/kvm/lib/perf_test_util.c  |  4 ++--
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 80a1cbe7fbb0..dcc5d44fc757 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -381,8 +381,8 @@ static void help(char *name)
>  	       "     (default: 1G)\n");
>  	printf(" -f: specify the fraction of pages which should be written to\n"

s/fraction/percentage/

>  	       "     as opposed to simply read, in the form\n"
> -	       "     1/<fraction of pages to write>.\n"
> -	       "     (default: 1 i.e. all pages are written to.)\n");
> +	       "     [0-100]%% of pages to write.\n"
> +	       "     (default: 100 i.e. all pages are written to.)\n");

Mention that the implementation is probabilistic.

>  	printf(" -v: specify the number of vCPUs to run.\n");
>  	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>  	       "     them into a separate region of memory for each vCPU.\n");
> @@ -399,7 +399,7 @@ int main(int argc, char *argv[])
>  	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
>  	struct test_params p = {
>  		.iterations = TEST_HOST_LOOP_N,
> -		.wr_fract = 1,
> +		.wr_fract = 100,

Please rename wr_fract to e.g. write_percent to reflect the new
semantics. Same goes for perf_test_set_wr_fract(),
perf_test_args.wr_fract, etc.

>  		.partition_vcpu_memory_access = true,
>  		.backing_src = DEFAULT_VM_MEM_SRC,
>  		.slots = 1,
> @@ -439,8 +439,10 @@ int main(int argc, char *argv[])
>  			break;
>  		case 'f':
>  			p.wr_fract = atoi(optarg);
> -			TEST_ASSERT(p.wr_fract >= 1,
> -				    "Write fraction cannot be less than one");
> +			TEST_ASSERT(p.wr_fract >= 0,
> +				    "Write fraction cannot be less than 0");
> +			TEST_ASSERT(p.wr_fract <= 100,
> +				    "Write fraction cannot be greater than 100");

nit: This could be combined into a single assert pretty easily.

>  			break;
>  		case 'v':
>  			nr_vcpus = atoi(optarg);
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index b04e8d2c0f37..3c7b93349fef 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -64,7 +64,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  		for (i = 0; i < pages; i++) {
>  			uint64_t addr = gva + (i * pta->guest_page_size);
>  
> -			if (i % pta->wr_fract == 0)
> +			if (random_table[vcpu_idx][i] % 100 < pta->wr_fract)
>  				*(uint64_t *)addr = 0x0123456789ABCDEF;
>  			else
>  				READ_ONCE(*(uint64_t *)addr);
> @@ -168,7 +168,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>  
>  	/* By default vCPUs will write to memory. */
> -	pta->wr_fract = 1;
> +	pta->wr_fract = 100;
>  
>  	/*
>  	 * Snapshot the non-huge page size.  This is used by the guest code to
> -- 
> 2.37.1.559.g78731f0fdb-goog
> 
