Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86FD75B3DE8
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 19:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiIIR0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 13:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIIR0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 13:26:17 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8925F2945
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 10:26:16 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d82so2268098pfd.10
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 10:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=DhTVXsHRZviz9xamn50cC+rfIM+CdbIkeCR1jggoiPM=;
        b=i2uiePlUXXaXDk8ObdGuk26Hywsh7OPNqA9bGXLkzJmhgonmOWHSU/MFVcup/ATIls
         cW+KMKGLmROTvOMSPKJXR58tX1Dr30HsHsSwnzIXU5Gf9P2jiAjU3wgFmNZkAMqljm1p
         AusCPhAlDU10nXtZH270XoLxPz98rQgfvMxmvGgfPDxYQ9u2IOmLeysxkI+ptU1qYd9+
         X8YPA+hoaJVql1mJYx+zvFYbIjPwxgOA+Lsm30RA8KH7qM1GBiy1eGKIgjHeLqt6/UgE
         pHBTYnxN28gMEDOg6hWbxbk7jfIsJEmN1z7Wuo91z+JKGrpoB/iRW9y7LYBrLhXZE+jv
         f6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=DhTVXsHRZviz9xamn50cC+rfIM+CdbIkeCR1jggoiPM=;
        b=eiK11JQrwmZlCdmVx/8PAXDYuU16CiHNYKX3H8wR8tKhAUPhtZCUBSEzcxR6I0vb9M
         wfTCAY2cmtFRtUzqC1urQDSS9TzO5VjAqHTxDoASbBOMaFNupcWHCzlCUh5zOXAILe1x
         +gq4dionk8EqJk5rCCBqTmo0xLpYW6ljAB3P9OUN3eVEBf5jYQD22he8hRW/05xiri1F
         68KwbMJDIpvWFkWvmUWpUm3IB0qPIRfWE9CTy8+tqhOKl589wZfngLbK9mxPAHh4XBLD
         rM0DBmOi+F4pUzpCiPKH9nNlnULmxKMRPYI4GDElv1AX23OK+jdTBPJvQrWW5Lbpw85i
         lf8w==
X-Gm-Message-State: ACgBeo3PHrBHaFYiEPXDbHwJPkRovLDTx+sUSSfI1+88ub+XqN9gS9B5
        4yj7joqHPT6J83gD+DZTiRzjhw==
X-Google-Smtp-Source: AA6agR4S/n+rX7b+lDqThE5MVLrIoSHXydI4A2+r8rt6BK/lHSXbMmUr67zbwzHeUa9njK+9DJHFFw==
X-Received: by 2002:a62:b519:0:b0:537:9723:5cf2 with SMTP id y25-20020a62b519000000b0053797235cf2mr15416245pfe.15.1662744376085;
        Fri, 09 Sep 2022 10:26:16 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090341c600b00176ba091cd3sm720589ple.196.2022.09.09.10.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 10:26:15 -0700 (PDT)
Date:   Fri, 9 Sep 2022 10:26:10 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v5 3/3] KVM: selftests: randomize page access order
Message-ID: <Yxt3MtaqpM52wQvB@google.com>
References: <20220909124300.3409187-1-coltonlewis@google.com>
 <20220909124300.3409187-4-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909124300.3409187-4-coltonlewis@google.com>
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

On Fri, Sep 09, 2022 at 12:43:00PM +0000, Colton Lewis wrote:
> Create the ability to randomize page access order with the -a
> argument, including the possibility that the same pages may be hit
> multiple times during an iteration or not at all.
> 
> Population sets random access to false.

Please make sure to also explain the why in addition to the what.

> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c | 11 +++++++++--
>  .../selftests/kvm/include/perf_test_util.h        |  2 ++
>  tools/testing/selftests/kvm/lib/perf_test_util.c  | 15 ++++++++++++++-
>  3 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index c2ad299b3760..3639d5f95033 100644
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
> @@ -248,6 +249,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		vcpu_last_completed_iteration[vcpu_id] = -1;
>  
>  	perf_test_set_write_percent(vm, 100);
> +	perf_test_set_random_access(vm, false);
>  	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
>  
>  	/* Allow the vCPUs to populate memory */
> @@ -270,6 +272,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		ts_diff.tv_sec, ts_diff.tv_nsec);
>  
>  	perf_test_set_write_percent(vm, p->write_percent);
> +	perf_test_set_random_access(vm, p->random_access);
>  
>  	while (iteration < p->iterations) {
>  		/*
> @@ -341,10 +344,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
> @@ -396,8 +400,11 @@ int main(int argc, char *argv[])
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
> index f93f2ea7c6a3..d9664a31e01c 100644
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
> index 12a3597be1f9..ce657fa92f05 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -46,6 +46,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
>  	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_id];
>  	uint64_t gva;
>  	uint64_t pages;
> +	uint64_t addr;
>  	int i;
>  	uint32_t rand = pta->random_seed + vcpu_id;
>  
> @@ -57,7 +58,13 @@ void perf_test_guest_code(uint32_t vcpu_id)
>  
>  	while (true) {
>  		for (i = 0; i < pages; i++) {
> -			uint64_t addr = gva + (i * pta->guest_page_size);
> +			guest_random(&rand);
> +
> +			if (pta->random_access)
> +				addr = gva + ((rand % pages) * pta->guest_page_size);
> +			else
> +				addr = gva + (i * pta->guest_page_size);
> +
>  			guest_random(&rand);

Is it on purpose use a separate random number for access offset and
read/write?

>  
>  			if (rand % 100 < pta->write_percent)
> @@ -233,6 +240,12 @@ void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
>  	sync_global_to_guest(vm, perf_test_args.random_seed);
>  }
>  
> +void perf_test_set_random_access(struct kvm_vm *vm, bool random_access)
> +{
> +	perf_test_args.random_access = random_access;
> +	sync_global_to_guest(vm, perf_test_args.random_access);
> +}
> +
>  uint64_t __weak perf_test_nested_pages(int nr_vcpus)
>  {
>  	return 0;
> -- 
> 2.37.2.789.g6183377224-goog
> 
