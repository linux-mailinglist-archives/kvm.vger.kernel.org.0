Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DE8670B5F
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 23:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjAQWLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 17:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjAQWJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 17:09:08 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96E039CCD
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:32:48 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id a14-20020a17090a70ce00b00229a2f73c56so30333pjm.3
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7kEjJ8ZqAfsOboQ6KDI1b8xPGowgCfxQagGZBlsNI5E=;
        b=e2UvJdEajptymMgM7w0eQlJfGJbneyagv4l+2KYw81K07GkXrkGIBv8goSXwmEeJU7
         uVzNyyLwXqQxPKjGVELGs+w5Jc8W5qh66z0YdPpj0m3CxeUyQkrau8j8735o4qmEeWpb
         v8rLQCyIMGv63JUtYwYGYFqGpdweAjMNho7ZHinwbVkl1x9YvPPQA8HcSJcPBSlKPy3F
         T/9J+qkoOu0LC8byh3Wy5NMtDhr3gmENUh408/oEyDccCEnwR/tOINVWrnt13aXK6kGM
         YrTUofsLwlT7NvDG3cG4T90O8ZJVrdxi8xF1iVYlrsWzR/84NW/jWHvG63xcH3udXmtT
         PwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kEjJ8ZqAfsOboQ6KDI1b8xPGowgCfxQagGZBlsNI5E=;
        b=6ZJ0tj7upLnQludqpvB+Q6sJmHPLsdVTI9uu5F1ega0mr6INg3iu+X/AzGBrL3r9J1
         ALCCg8LTnhNSxfgORPNB0bzBhLA2IqLaqnBVfLm40rGTQWQeFtP3rV6ZafYA01hY0yZB
         IxC7q9EnQZ85YHVfqSoPgXoplBi0VENQ5NzuMwO9cLpXZR576ctQ0WbRp3lvJc2iZjXv
         Y3dwo0Tr/CT92aEz6xyJ0gCQ4FhJskYlYU2155cK8vqqcEuiPvR1Pm1PMiP8izKIrcz7
         wM9sT6WkYfNmHDNbjQbXjjGZjP0gXUtI/SV1fJC/ptWN40+6onH+TBfxdD8Jcm5wXm8k
         I9UA==
X-Gm-Message-State: AFqh2ko/IndH3mjNSgyxpLd9J+KR1yvzHaOkAWKbbTVK5o2LmU8nr4jT
        PT+iTnowKcy3XU43VcwrjYhIpg==
X-Google-Smtp-Source: AMrXdXsEYzttrXzTrt+ziSm6HNvMnNLwhDwHEoiv5JxlmvtFmkMF3PK/ctgnOvruwK/bGf2dyXvNMQ==
X-Received: by 2002:a05:6a20:7d8d:b0:b8:c859:7fc4 with SMTP id v13-20020a056a207d8d00b000b8c8597fc4mr432684pzj.1.1673987567964;
        Tue, 17 Jan 2023 12:32:47 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id n6-20020a634d46000000b004351358f056sm17522922pgl.85.2023.01.17.12.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 12:32:47 -0800 (PST)
Date:   Tue, 17 Jan 2023 12:32:43 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, bgardon@google.com,
        oupton@google.com
Subject: Re: [PATCH 1/3] KVM: selftests: Allocate additional space for
 latency samples
Message-ID: <Y8cF65zpxOlYkAUl@google.com>
References: <20221115173258.2530923-1-coltonlewis@google.com>
 <20221115173258.2530923-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115173258.2530923-2-coltonlewis@google.com>
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

Hi Colton,

On Tue, Nov 15, 2022 at 05:32:56PM +0000, Colton Lewis wrote:
> Allocate additional space for latency samples. This has been separated
> out to call attention to the additional VM memory allocation. The test
> runs out of physical pages without the additional allocation. The 100
> multiple for pages was determined by trial and error. A more
> well-reasoned calculation would be preferable.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/lib/perf_test_util.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 137be359b09e..a48904b64e19 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -38,6 +38,12 @@ static bool all_vcpu_threads_running;
>  
>  static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>  
> +#define SAMPLES_PER_VCPU 1000
> +#define SAMPLE_CAPACITY (SAMPLES_PER_VCPU * KVM_MAX_VCPUS)
> +
> +/* Store all samples in a flat array so they can be easily sorted later. */
> +uint64_t latency_samples[SAMPLE_CAPACITY];
> +
>  /*
>   * Continuously write to the first 8 bytes of each page in the
>   * specified region.
> @@ -122,7 +128,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  {
>  	struct perf_test_args *pta = &perf_test_args;
>  	struct kvm_vm *vm;
> -	uint64_t guest_num_pages, slot0_pages = 0;
> +	uint64_t guest_num_pages, sample_pages, slot0_pages = 0;
>  	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
>  	uint64_t region_end_gfn;
>  	int i;
> @@ -161,7 +167,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
>  	 * The memory is also added to memslot 0, but that's a benign side
>  	 * effect as KVM allows aliasing HVAs in meslots.
>  	 */
> -	vm = __vm_create_with_vcpus(mode, nr_vcpus, slot0_pages + guest_num_pages,
> +	sample_pages = 100 * sizeof(latency_samples) / pta->guest_page_size;

I don't think there's any need to guess. The number of accesses is
vcpu_args->pages (one access per guest page). So all memory could be
allocated dynamically to hold "vcpu_args->pages * sample_sz".

> +	vm = __vm_create_with_vcpus(mode, nr_vcpus,
> +				    slot0_pages + guest_num_pages + sample_pages,
>  				    perf_test_guest_code, vcpus);
>  
>  	pta->vm = vm;
> -- 
> 2.38.1.431.g37b22c650d-goog
> 

Thanks,
Ricardo
