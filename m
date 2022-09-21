Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C287F5DDD51
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 20:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiIUSO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 14:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiIUSOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 14:14:24 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E8EA345E
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 11:14:22 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so15149796pjq.3
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 11:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=S9qLPgv0uRL2X2uHDQm0oOGqx0kgwQ0jRLHsZ/srV3c=;
        b=gl2gFxJOpRS/hDMoh2knnuk8VsKueQzGhdAJJYkwq57v6L+AAZJdTC12sqBYGFPSp4
         NaVRmaH8Eec8AD2ejlpceLn4FQ4t/KfVXqLoY25AGbcQ27k7gUomlkbYSLTHxO9QZiS0
         Yq4E3Avdaal7X5sXBiEghYHKN0azDxfKRdERJLPLUy6dm0JHUu9xiWrbiUWWj+ZCGDXi
         jqVUobOBj8eSwV+rbTwPnx87/e6UI1WTyzfUWQ1Fl5sNbWX1fj4kCO5l40+foIWvCyRj
         +xitDBFe4qsa1fDcwafxvMyx0niykQK9nZIFjenHD8Wurpm4S9k5y7N9MRyi1r0IVcmX
         NgGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=S9qLPgv0uRL2X2uHDQm0oOGqx0kgwQ0jRLHsZ/srV3c=;
        b=vJzZykqh8km2v3+IPxvKqHu9icyPYWzzaffAlVJ4nIt7PNOOz6Iy/UHz3fh8ZU/Vsy
         IFvpAl18AVsrC/n5pSBYahc2lVErfduBBm7Acb6BixOMYPPQLOgnRdW2auwMEjS0RUys
         NGIXjGO/hJpKdwzxXhzjYDf6FxoyAAahdfarcr6NfT51w8gIh6tawUk2t5lHiI4qlN2R
         EVvELVZ1iiTTfrMFvRCuwM+ZtQO2FmEWeWb94rjCo+7m4cAZJkQG1gu4XlxMK18VGKyE
         TZZeZLbAyX5HYvc4gI0mg+235c5Yka3QXn////lQlAmXI42XUiFaybzYCC2FZ8eWV6V+
         a7sg==
X-Gm-Message-State: ACrzQf1Ob7HZTqoD9+wzt/vtzfy8BMt8SBKH2t6bMkF39Z7vVgijgyop
        q1s9ihOncV1Cgksq0YjBtoK3YA==
X-Google-Smtp-Source: AMsMyM6rIK9JDHcw4njgGwhhAx3U7Kw34hDX+CW1QQ1vN/dt1hTUrHWkctkh85MOP1uB9kKhMCBEMA==
X-Received: by 2002:a17:90b:390e:b0:202:5d4e:c1f2 with SMTP id ob14-20020a17090b390e00b002025d4ec1f2mr10954926pjb.45.1663784061977;
        Wed, 21 Sep 2022 11:14:21 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902654400b001781a7c28bcsm2349904pln.237.2022.09.21.11.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 11:14:21 -0700 (PDT)
Date:   Wed, 21 Sep 2022 11:14:16 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] KVM: selftests: Add atoi_paranoid to catch errors
 missed by atoi
Message-ID: <YytUeOhWEBJF6MMz@google.com>
References: <20220826184500.1940077-1-vipinsh@google.com>
 <20220826184500.1940077-4-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826184500.1940077-4-vipinsh@google.com>
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

On Fri, Aug 26, 2022 at 11:44:59AM -0700, Vipin Sharma wrote:
> atoi() doesn't detect errors. There is no way to know that a 0 return
> is correct conversion or due to an error.
> 
> Introduce atoi_paranoid() to detect errors and provide correct
> conversion. Replace all atoi calls with atoi_paranoid.

Please use "()" after all function names.

> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Suggested-by: David Matlack <dmatlack@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/aarch64/arch_timer.c   |  8 ++++----
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c     |  6 +++---
>  .../selftests/kvm/access_tracking_perf_test.c      |  2 +-
>  tools/testing/selftests/kvm/demand_paging_test.c   |  2 +-
>  tools/testing/selftests/kvm/dirty_log_perf_test.c  |  8 ++++----
>  tools/testing/selftests/kvm/include/test_util.h    |  2 ++
>  tools/testing/selftests/kvm/kvm_page_table_test.c  |  2 +-
>  tools/testing/selftests/kvm/lib/test_util.c        | 14 ++++++++++++++
>  .../testing/selftests/kvm/max_guest_memory_test.c  |  6 +++---
>  .../kvm/memslot_modification_stress_test.c         |  4 ++--
>  tools/testing/selftests/kvm/memslot_perf_test.c    | 10 +++++-----
>  .../testing/selftests/kvm/set_memory_region_test.c |  2 +-
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c      |  4 ++--
>  13 files changed, 43 insertions(+), 27 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> index 574eb73f0e90..251e7ff04883 100644
> --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> @@ -414,7 +414,7 @@ static bool parse_args(int argc, char *argv[])
>  	while ((opt = getopt(argc, argv, "hn:i:p:m:")) != -1) {
>  		switch (opt) {
>  		case 'n':
> -			test_args.nr_vcpus = atoi(optarg);
> +			test_args.nr_vcpus = atoi_paranoid(optarg);
>  			if (test_args.nr_vcpus <= 0) {
>  				pr_info("Positive value needed for -n\n");
>  				goto err;
> @@ -425,21 +425,21 @@ static bool parse_args(int argc, char *argv[])
>  			}
>  			break;
>  		case 'i':
> -			test_args.nr_iter = atoi(optarg);
> +			test_args.nr_iter = atoi_paranoid(optarg);
>  			if (test_args.nr_iter <= 0) {
>  				pr_info("Positive value needed for -i\n");
>  				goto err;
>  			}
>  			break;
>  		case 'p':
> -			test_args.timer_period_ms = atoi(optarg);
> +			test_args.timer_period_ms = atoi_paranoid(optarg);
>  			if (test_args.timer_period_ms <= 0) {
>  				pr_info("Positive value needed for -p\n");
>  				goto err;
>  			}
>  			break;
>  		case 'm':
> -			test_args.migration_freq_ms = atoi(optarg);
> +			test_args.migration_freq_ms = atoi_paranoid(optarg);
>  			if (test_args.migration_freq_ms < 0) {
>  				pr_info("0 or positive value needed for -m\n");
>  				goto err;
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> index 17417220a083..ae90b718070a 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> @@ -824,16 +824,16 @@ int main(int argc, char **argv)
>  	while ((opt = getopt(argc, argv, "hn:e:l:")) != -1) {
>  		switch (opt) {
>  		case 'n':
> -			nr_irqs = atoi(optarg);
> +			nr_irqs = atoi_paranoid(optarg);
>  			if (nr_irqs > 1024 || nr_irqs % 32)
>  				help(argv[0]);
>  			break;
>  		case 'e':
> -			eoi_split = (bool)atoi(optarg);
> +			eoi_split = (bool)atoi_paranoid(optarg);
>  			default_args = false;
>  			break;
>  		case 'l':
> -			level_sensitive = (bool)atoi(optarg);
> +			level_sensitive = (bool)atoi_paranoid(optarg);
>  			default_args = false;
>  			break;
>  		case 'h':
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> index 1c2749b1481a..99b16302d94d 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -361,7 +361,7 @@ int main(int argc, char *argv[])
>  			params.vcpu_memory_bytes = parse_size(optarg);
>  			break;
>  		case 'v':
> -			params.nr_vcpus = atoi(optarg);
> +			params.nr_vcpus = atoi_paranoid(optarg);
>  			break;
>  		case 'o':
>  			overlap_memory_access = true;
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 779ae54f89c4..82597fb04146 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -427,7 +427,7 @@ int main(int argc, char *argv[])
>  			p.src_type = parse_backing_src_type(optarg);
>  			break;
>  		case 'v':
> -			nr_vcpus = atoi(optarg);
> +			nr_vcpus = atoi_paranoid(optarg);
>  			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
>  				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
>  			break;
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index acf8b80c91d1..1346f6b5a9bd 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -417,7 +417,7 @@ int main(int argc, char *argv[])
>  			dirty_log_manual_caps = 0;
>  			break;
>  		case 'f':
> -			p.wr_fract = atoi(optarg);
> +			p.wr_fract = atoi_paranoid(optarg);
>  			TEST_ASSERT(p.wr_fract >= 1,
>  				    "Write fraction cannot be less than one");
>  			break;
> @@ -428,7 +428,7 @@ int main(int argc, char *argv[])
>  			help(argv[0]);
>  			break;
>  		case 'i':
> -			p.iterations = atoi(optarg);
> +			p.iterations = atoi_paranoid(optarg);
>  			break;
>  		case 'm':
>  			guest_modes_cmdline(optarg);
> @@ -446,12 +446,12 @@ int main(int argc, char *argv[])
>  			p.backing_src = parse_backing_src_type(optarg);
>  			break;
>  		case 'v':
> -			nr_vcpus = atoi(optarg);
> +			nr_vcpus = atoi_paranoid(optarg);
>  			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
>  				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
>  			break;
>  		case 'x':
> -			p.slots = atoi(optarg);
> +			p.slots = atoi_paranoid(optarg);
>  			break;
>  		default:
>  			help(argv[0]);
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index 5c5a88180b6c..56776f431733 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -150,4 +150,6 @@ static inline void *align_ptr_up(void *x, size_t size)
>  	return (void *)align_up((unsigned long)x, size);
>  }
>  
> +int atoi_paranoid(const char *num_str);
> +
>  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
> index f42c6ac6d71d..ea7feb69bb88 100644
> --- a/tools/testing/selftests/kvm/kvm_page_table_test.c
> +++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
> @@ -461,7 +461,7 @@ int main(int argc, char *argv[])
>  			p.test_mem_size = parse_size(optarg);
>  			break;
>  		case 'v':
> -			nr_vcpus = atoi(optarg);
> +			nr_vcpus = atoi_paranoid(optarg);
>  			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
>  				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
>  			break;
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 6d23878bbfe1..1e560c30a696 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -334,3 +334,17 @@ long get_run_delay(void)
>  
>  	return val[1];
>  }
> +
> +int atoi_paranoid(const char *num_str)
> +{
> +	int num;
> +	char *end_ptr;
> +
> +	errno = 0;
> +	num = (int)strtol(num_str, &end_ptr, 10);
> +	TEST_ASSERT(errno == 0, "Conversion error: %d\n", errno);

"Conversion error: " is a bit vague. Also, TEST_ASSERT() already logs
errno and strerror(errno). It would probably be more useful here to log
the input string that caused the conversion error.

How about this?

        TEST_ASSERT(!errno, "strtol(\"%s\") failed", num_str);

> +	TEST_ASSERT(num_str != end_ptr && *end_ptr == '\0',
> +		    "Invalid number string.\n");

"Invalid number string." is also a bit vague. How about this?

        TEST_ASSERT(num_str != end_ptr && *end_ptr == '\0',
                    "strtol(\"%s\") failed to parse trailing characters \"%s\"",
                    num_str, end_ptr);

> +
> +	return num;
> +}
> diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
> index 9a6e4f3ad6b5..1595b73dc09a 100644
> --- a/tools/testing/selftests/kvm/max_guest_memory_test.c
> +++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
> @@ -193,15 +193,15 @@ int main(int argc, char *argv[])
>  	while ((opt = getopt(argc, argv, "c:h:m:s:H")) != -1) {
>  		switch (opt) {
>  		case 'c':
> -			nr_vcpus = atoi(optarg);
> +			nr_vcpus = atoi_paranoid(optarg);
>  			TEST_ASSERT(nr_vcpus > 0, "number of vcpus must be >0");
>  			break;
>  		case 'm':
> -			max_mem = atoi(optarg) * size_1gb;
> +			max_mem = atoi_paranoid(optarg) * size_1gb;
>  			TEST_ASSERT(max_mem > 0, "memory size must be >0");
>  			break;
>  		case 's':
> -			slot_size = atoi(optarg) * size_1gb;
> +			slot_size = atoi_paranoid(optarg) * size_1gb;
>  			TEST_ASSERT(slot_size > 0, "slot size must be >0");
>  			break;
>  		case 'H':
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index 6ee7e1dde404..865276993ffb 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -166,7 +166,7 @@ int main(int argc, char *argv[])
>  			guest_percpu_mem_size = parse_size(optarg);
>  			break;
>  		case 'v':
> -			nr_vcpus = atoi(optarg);
> +			nr_vcpus = atoi_paranoid(optarg);
>  			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
>  				    "Invalid number of vcpus, must be between 1 and %d",
>  				    max_vcpus);
> @@ -175,7 +175,7 @@ int main(int argc, char *argv[])
>  			p.partition_vcpu_memory_access = false;
>  			break;
>  		case 'i':
> -			p.nr_memslot_modifications = atoi(optarg);
> +			p.nr_memslot_modifications = atoi_paranoid(optarg);
>  			break;
>  		case 'h':
>  		default:
> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
> index 44995446d942..4bae9e3f5ca1 100644
> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
> @@ -885,21 +885,21 @@ static bool parse_args(int argc, char *argv[],
>  			map_unmap_verify = true;
>  			break;
>  		case 's':
> -			targs->nslots = atoi(optarg);
> +			targs->nslots = atoi_paranoid(optarg);
>  			if (targs->nslots <= 0 && targs->nslots != -1) {
>  				pr_info("Slot count cap has to be positive or -1 for no cap\n");
>  				return false;
>  			}
>  			break;
>  		case 'f':
> -			targs->tfirst = atoi(optarg);
> +			targs->tfirst = atoi_paranoid(optarg);
>  			if (targs->tfirst < 0) {
>  				pr_info("First test to run has to be non-negative\n");
>  				return false;
>  			}
>  			break;
>  		case 'e':
> -			targs->tlast = atoi(optarg);
> +			targs->tlast = atoi_paranoid(optarg);
>  			if (targs->tlast < 0 || targs->tlast >= NTESTS) {
>  				pr_info("Last test to run has to be non-negative and less than %zu\n",
>  					NTESTS);
> @@ -907,14 +907,14 @@ static bool parse_args(int argc, char *argv[],
>  			}
>  			break;
>  		case 'l':
> -			targs->seconds = atoi(optarg);
> +			targs->seconds = atoi_paranoid(optarg);
>  			if (targs->seconds < 0) {
>  				pr_info("Test length in seconds has to be non-negative\n");
>  				return false;
>  			}
>  			break;
>  		case 'r':
> -			targs->runs = atoi(optarg);
> +			targs->runs = atoi_paranoid(optarg);
>  			if (targs->runs <= 0) {
>  				pr_info("Runs per test has to be positive\n");
>  				return false;
> diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
> index 0d55f508d595..c366949c8362 100644
> --- a/tools/testing/selftests/kvm/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> @@ -407,7 +407,7 @@ int main(int argc, char *argv[])
>  
>  #ifdef __x86_64__
>  	if (argc > 1)
> -		loops = atoi(argv[1]);
> +		loops = atoi_paranoid(argv[1]);
>  	else
>  		loops = 10;
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> index cc6421716400..5e18d716782b 100644
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> @@ -233,10 +233,10 @@ int main(int argc, char **argv)
>  	while ((opt = getopt(argc, argv, "hp:t:r")) != -1) {
>  		switch (opt) {
>  		case 'p':
> -			reclaim_period_ms = atoi(optarg);
> +			reclaim_period_ms = atoi_paranoid(optarg);
>  			break;
>  		case 't':
> -			token = atoi(optarg);
> +			token = atoi_paranoid(optarg);
>  			break;
>  		case 'r':
>  			reboot_permissions = true;
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
