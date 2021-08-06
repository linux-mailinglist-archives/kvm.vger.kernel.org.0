Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98153E2A29
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 13:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243199AbhHFLzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 07:55:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242112AbhHFLzi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 07:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628250922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fGP+iAQII8G+ePBxYojxs1WSJIdl5lO8QCH2wLgz9wM=;
        b=IDIn6lRiH7Fmuq2wYEU8IYaPelp62A0CYf7Ceu2HFohDA+sfZSUx1yuQghM8GWpYOp4j5h
        jx7GiBPq/G3QNxq5XHywuzMS+oRIQYkzqzLJWvRJt4Xf0bhO18uIrNvihcVWxglo3R/ljx
        zznf/V0UcgYn3/O1IdKPQOUHLiR3sg4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-8xiplRHDPAiMQDUF5MTu9A-1; Fri, 06 Aug 2021 07:55:21 -0400
X-MC-Unique: 8xiplRHDPAiMQDUF5MTu9A-1
Received: by mail-ed1-f72.google.com with SMTP id u25-20020aa7d8990000b02903bb6a903d90so4791262edq.17
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 04:55:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fGP+iAQII8G+ePBxYojxs1WSJIdl5lO8QCH2wLgz9wM=;
        b=evSbIBQaE7ml1Tdi1ik7u7z6cFFgcXfukyC4nc7r1AUrVw8/BoZs04O4CKKZ0lJ7ZM
         xjdJaiRO98/YSqlBGTEPpaxIfXTBiaW3C4maLVDM9tCNWwYoVh2S2ZZsnYRdhZ+qpw5n
         Keszl/5nLrbNB70KM5IifDwm8rIcef9nNZ9q4Fh4FGO8IYsK/rzZJrM9S1dk5vS/N7xw
         LMDvk34dC0tBkYqW9DXo4zYShdmxZ492gSGy3WFiyfViNNYFSFbNhRIbUopLzFwP2BH1
         6qccQ/rqpZvgkRJrPcvzwF3vYbsF4erY4RV4HDFzwWSmIWDTfJu4LDJ2QWV4Sc3zwJYx
         dEDw==
X-Gm-Message-State: AOAM531v3u+/R31Dx4XcQcQKzwDOL12V3aJeJZp6o353l+VyndfeG6a6
        OHx1HItvMHkZjdoZ/RefCOi0MLsEDXEjTniDRqpyk3wXGpY1y73xceKfEpCcCFXjhDe3jFiwhqE
        HiHps7gVaW86c
X-Received: by 2002:a05:6402:1778:: with SMTP id da24mr12423048edb.385.1628250919947;
        Fri, 06 Aug 2021 04:55:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzB/ZqZO7t+qc2RmLxIRI6i/Bp965JpQjO+LxL+lYgAb3h2LGsNutKGwkusFQv3LrZme6pOuw==
X-Received: by 2002:a05:6402:1778:: with SMTP id da24mr12423031edb.385.1628250919748;
        Fri, 06 Aug 2021 04:55:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d16sm894378edu.8.2021.08.06.04.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 04:55:19 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Move vcpu_args_set into perf_test_util
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210805172821.2622793-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc4bac54-9e3c-822c-2ba5-f4380486c0e3@redhat.com>
Date:   Fri, 6 Aug 2021 13:55:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210805172821.2622793-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/21 19:28, David Matlack wrote:
> perf_test_util is used to set up KVM selftests where vCPUs touch a
> region of memory. The guest code is implemented in perf_test_util.c (not
> the calling selftests). The guest code requires a 1 parameter, the
> vcpuid, which has to be set by calling vcpu_args_set(vm, vcpu_id, 1,
> vcpu_id).
> 
> Today all of the selftests that use perf_test_util are making this call.
> Instead, perf_test_util should just do it. This will save some code but
> more importantly prevents mistakes since totally non-obvious that this
> needs to be called and failing to do so results in vCPUs not accessing
> the right regions of memory.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Queued, thanks.

Paolo

> ---
>   tools/testing/selftests/kvm/access_tracking_perf_test.c        | 2 --
>   tools/testing/selftests/kvm/demand_paging_test.c               | 1 -
>   tools/testing/selftests/kvm/dirty_log_perf_test.c              | 1 -
>   tools/testing/selftests/kvm/lib/perf_test_util.c               | 2 ++
>   tools/testing/selftests/kvm/memslot_modification_stress_test.c | 1 -
>   5 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> index e2baa187a21e..72714573ba4f 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -222,8 +222,6 @@ static void *vcpu_thread_main(void *arg)
>   	int vcpu_id = vcpu_args->vcpu_id;
>   	int current_iteration = -1;
>   
> -	vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
> -
>   	while (spin_wait_for_next_iteration(&current_iteration)) {
>   		switch (READ_ONCE(iteration_work)) {
>   		case ITERATION_ACCESS_MEMORY:
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index b74704305835..950f2eb634e6 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -52,7 +52,6 @@ static void *vcpu_worker(void *data)
>   	struct timespec start;
>   	struct timespec ts_diff;
>   
> -	vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
>   	run = vcpu_state(vm, vcpu_id);
>   
>   	clock_gettime(CLOCK_MONOTONIC, &start);
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 80cbd3a748c0..ef45a133560f 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -44,7 +44,6 @@ static void *vcpu_worker(void *data)
>   	struct perf_test_vcpu_args *vcpu_args = (struct perf_test_vcpu_args *)data;
>   	int vcpu_id = vcpu_args->vcpu_id;
>   
> -	vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
>   	run = vcpu_state(vm, vcpu_id);
>   
>   	while (!READ_ONCE(host_quit)) {
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index b488f4aefea8..f6aa81af3e6f 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -140,6 +140,8 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
>   			vcpu_gpa = guest_test_phys_mem;
>   		}
>   
> +		vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
> +
>   		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
>   			 vcpu_id, vcpu_gpa, vcpu_gpa +
>   			 (vcpu_args->pages * perf_test_args.guest_page_size));
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index 98351ba0933c..b6f7cc298e4d 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -45,7 +45,6 @@ static void *vcpu_worker(void *data)
>   	struct kvm_vm *vm = perf_test_args.vm;
>   	struct kvm_run *run;
>   
> -	vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
>   	run = vcpu_state(vm, vcpu_id);
>   
>   	/* Let the guest access its memory until a stop signal is received */
> 

