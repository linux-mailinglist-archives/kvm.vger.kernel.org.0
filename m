Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC605F7F4F
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 22:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJGUz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 16:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJGUz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 16:55:26 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC2C9AFF0
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 13:55:25 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id e11-20020a17090a77cb00b00205edbfd646so8273239pjs.1
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 13:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IPg5P7HLRMMbm2Y/Tg5s98dpgkRv4yM8aWofNR2gKyw=;
        b=CINQo9uPjK/INvoKpCt+KSWcu0072NvLKxsAdAzbu5680orgpdofqYa1FXTvel0L86
         ip7GA0msq9wYPScXV3dTpMlRs6ZbRpQiQ39MefB+TnFWTtftqS/smvwnQi55gv5aX0Se
         V30e3YgvcUg9Wk3dZqVG7+5Dy61DIw2RiULlLw2o8jp4pNKT1h6Ad+zdvqMvsFiloUxF
         XHaiT+LQdti0nMZlEq8/M4GCLGvQ9GurGHR47lYziCn47Ks46yT0ZE8MEoP/Abhp7Pn7
         yyk8nvCLVFFiURss0AE0El3wItnoATKkb9Um3AnkeNRNMLzLK2x2buTbBzlQpLma4/Vf
         Kxhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IPg5P7HLRMMbm2Y/Tg5s98dpgkRv4yM8aWofNR2gKyw=;
        b=0PgqCfaXWVKgPZzxnrNVGFnkGNuawHUAhojdYy+mMNKkmbuJMqjNhU4X8fkKYIxv/4
         BLzKlDp+O9vxR9riKNjhsxgtQVT/aHwVv5rJYr6NcBz7N9TC37jnzLZ8N835ZMFaPJOQ
         zFn6i7O3IIGZtQAxX6vEwW+9wKYoAk16ZO2BY/VE7LjhGwF8z/QoVl4jATLi27DFqenI
         RF6RNrt9XetwRem46BRzgd18LSqGowHdBjIRlk2kQNlvc59NRqgtc6YffMhnlp/9q2sk
         HBfHpAYSu14f4wAgH2wjv2TzlKJAnkZs1mWva5ePQU+wbc5uR2bA9S570fBg+OgeEZo3
         Exnw==
X-Gm-Message-State: ACrzQf0Tg/YSPJ0BFyFHJhk1ejUd7Kzo+q4hdvi6KBuFtTfvb5qxJOP2
        IgpSpwzFJ7rKC7x4K3jLyvWqczkfEDNriA==
X-Google-Smtp-Source: AMsMyM57qEyLtUqqIo4srR8+1MGnGuq4mqUZAYhpoVbQJkqRxaF6rjlsEIaLUNoQlpeA4FZRQAuWGg==
X-Received: by 2002:a17:902:f689:b0:179:fdac:c4e2 with SMTP id l9-20020a170902f68900b00179fdacc4e2mr6876893plg.119.1665176124922;
        Fri, 07 Oct 2022 13:55:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 142-20020a621794000000b005623f96c24bsm2075825pfx.89.2022.10.07.13.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 13:55:24 -0700 (PDT)
Date:   Fri, 7 Oct 2022 20:55:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v6 2/3] KVM: selftests: randomize which pages are written
 vs read
Message-ID: <Y0CSOKOq0T48e0yr@google.com>
References: <20220912195849.3989707-1-coltonlewis@google.com>
 <20220912195849.3989707-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912195849.3989707-3-coltonlewis@google.com>
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

On Mon, Sep 12, 2022, Colton Lewis wrote:
> @@ -393,7 +403,7 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:or:s:x:")) != -1) {
> +	while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {

This string is getting quite annoying to maintain, e.g. all of these patches
conflict with recent upstream changes, and IIRC will conflict again with Vipin's
changes.  AFAICT, the string passed to getopt() doesn't need to be constant, i.e.
can be built programmatically.  Not in this series, but as future cleanup we should
at least consider a way to make this slightly less painful to maintain.

>  		switch (opt) {
>  		case 'g':
>  			dirty_log_manual_caps = 0;
> @@ -413,10 +423,11 @@ int main(int argc, char *argv[])
>  		case 'b':
>  			guest_percpu_mem_size = parse_size(optarg);
>  			break;
> -		case 'f':
> -			p.wr_fract = atoi(optarg);
> -			TEST_ASSERT(p.wr_fract >= 1,
> -				    "Write fraction cannot be less than one");
> +		case 'w':
> +			p.write_percent = atoi(optarg);
> +			TEST_ASSERT(p.write_percent >= 0
> +				    && p.write_percent <= 100,

&&, ||, etc... go on the previous line.  But in this case, I'd say don't wrap at all,
it's only a few chars over the soft limit.

			TEST_ASSERT(p.write_percent >= 0 && p.write_percent <= 100,

or

			TEST_ASSERT(p.write_percent >= 0 &&
				    p.write_percent <= 100,

And after Vipin's cleanup lands[*], this can be:

			p.write_percent = atoi_positive(optarg);

			TEST_ASSERT(p.write_percent <= 100,

[*] https://lore.kernel.org/all/CAHVum0cD5R9ej09VNvkkqcQsz7PGrxnMqi1E4kqLv+1d63Rg6A@mail.gmail.com

> +				    "Write percentage must be between 0 and 100");
>  			break;
>  		case 'v':
>  			nr_vcpus = atoi(optarg);
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index f18530984b42..f93f2ea7c6a3 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -35,7 +35,7 @@ struct perf_test_args {
>  	uint64_t size;
>  	uint64_t guest_page_size;
>  	uint32_t random_seed;
> -	int wr_fract;
> +	uint32_t write_percent;
>  
>  	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
>  	bool nested;
> @@ -51,7 +51,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>  				   bool partition_vcpu_memory_access);
>  void perf_test_destroy_vm(struct kvm_vm *vm);
>  
> -void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
> +void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
>  void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
>  
>  void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index b1e731de0966..9effd229b75d 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -60,7 +60,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
>  			uint64_t addr = gva + (i * pta->guest_page_size);
>  			guest_random(&rand);
>  
> -			if (i % pta->wr_fract == 0)
> +			if (rand % 100 < pta->write_percent)

Aha!  Random bools with a percentage is exactly the type of thing the common RNG
helpers can and should provide.  E.g. this should look something like:

			if (random_bool(rng, pta->write_percent))

As a bonus, if someone wants to implement a more sophisticated percentage system,
then all users of random_bool() will benefit, again without needing to update
users.
