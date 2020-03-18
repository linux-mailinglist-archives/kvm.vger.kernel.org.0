Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72FB3189C9B
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 14:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgCRNKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 09:10:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:51486 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726752AbgCRNKc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 09:10:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584537031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YTP6NJ/eZGjDQD+xHsT5FRgRv5zsxvBZeqCBZ8utkRg=;
        b=WtYSehUdy5On885NCst/TSXlx2uU3bN4w7nu33kJroVXH1yuEgFvgf4XmV72o+lFKn5WxN
        MfsJUFS6daaRaqZrxzJq9gu1IDu+K+bICCQbuuGblNbMgJLNrg8Da7VHnNUmw3RBb0vzRT
        0F3Swk7NFHIa5YPy5D+Wzx5mUQe/1/s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-5a85kGjbM62HQQVjTPeUvg-1; Wed, 18 Mar 2020 09:10:29 -0400
X-MC-Unique: 5a85kGjbM62HQQVjTPeUvg-1
Received: by mail-wm1-f69.google.com with SMTP id f185so1022162wmf.8
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 06:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YTP6NJ/eZGjDQD+xHsT5FRgRv5zsxvBZeqCBZ8utkRg=;
        b=UDIHhkzWngk6aFtSkFQ6wNlSVDm346dPpm/oYFAeKvcGH2Ogkh53Co2SEEQ5IUnTJA
         w5IEWHHV6trLqejuXvovQYMugbZi/7uwcX16ua96texcyySFSGqp7syo9Be+sWYVSs22
         jooAKD1Q+DKDPZVtTGkMQTAvYRr/sa9R+xe9+UI0PQzuuaSKsE+hyBSDQsi6KJmP7/OW
         4nq26PWYdNCyyYN1DwK8bM2/IZV3n8r/pZMjd0sQMP4dU5ogOvWfOxFRPEFtENjh9jWg
         Glmau7iP4RbtaaK0t7+/SvJE0LQVr5b1MILagrLHXk5/I7DPI79QjFg0DY0yGxx3iDut
         Pgow==
X-Gm-Message-State: ANhLgQ29VRq8F94ujGsw822D3gfh33NtJhGFUf0jTuNXZ66pUB2uY/s8
        T3z1XR8eCANKrvymmV62havxEbedkCHj0jLtEu+xG6WjJryrGhVGdovGDmwjz3A8ajfaislncwe
        of3ESIxG7C+Tw
X-Received: by 2002:adf:a18b:: with SMTP id u11mr5827901wru.390.1584537028221;
        Wed, 18 Mar 2020 06:10:28 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu2tBanuwFGxf92btlttJnKg6Flayt7yBGDuIFLD+DFUe5WDxb07IOeMEPfiXpNGtkxQtBa4w==
X-Received: by 2002:adf:a18b:: with SMTP id u11mr5827860wru.390.1584537027773;
        Wed, 18 Mar 2020 06:10:27 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id d18sm9344511wrq.22.2020.03.18.06.10.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 06:10:26 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] KVM: selftests: Rework timespec functions and
 usage
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
References: <20200316173703.12785-1-drjones@redhat.com>
 <20200316173703.12785-3-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4e2efaa3-f2cb-8210-d486-b1250e3be27a@redhat.com>
Date:   Wed, 18 Mar 2020 14:10:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200316173703.12785-3-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/03/20 18:37, Andrew Jones wrote:
> The steal_time test's timespec stop condition was wrong and should have
> used the timespec functions instead to avoid being wrong, but
> timespec_diff had a strange interface. Rework all the timespec API and
> its use.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Queued this one, I have already pushed the test to kvm/next so the
"fixup!" commit cannot be squashed.  But I don't really mind the code as
it looks in kvm/next.

Paolo

> ---
>  .../selftests/kvm/demand_paging_test.c        | 37 ++++++++-----------
>  .../testing/selftests/kvm/include/test_util.h |  3 +-
>  tools/testing/selftests/kvm/lib/test_util.c   | 37 ++++++++-----------
>  tools/testing/selftests/kvm/steal_time.c      |  2 +-
>  4 files changed, 35 insertions(+), 44 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index d82f7bc060c3..360cd3ea4cd6 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -117,8 +117,7 @@ static void *vcpu_worker(void *data)
>  	struct kvm_vm *vm = args->vm;
>  	int vcpu_id = args->vcpu_id;
>  	struct kvm_run *run;
> -	struct timespec start;
> -	struct timespec end;
> +	struct timespec start, end, ts_diff;
>  
>  	vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
>  	run = vcpu_state(vm, vcpu_id);
> @@ -135,9 +134,9 @@ static void *vcpu_worker(void *data)
>  	}
>  
>  	clock_gettime(CLOCK_MONOTONIC, &end);
> -	PER_VCPU_DEBUG("vCPU %d execution time: %lld.%.9lds\n", vcpu_id,
> -		       (long long)(timespec_diff(start, end).tv_sec),
> -		       timespec_diff(start, end).tv_nsec);
> +	ts_diff = timespec_sub(end, start);
> +	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_id,
> +		       ts_diff.tv_sec, ts_diff.tv_nsec);
>  
>  	return NULL;
>  }
> @@ -201,8 +200,8 @@ static int handle_uffd_page_request(int uffd, uint64_t addr)
>  
>  	clock_gettime(CLOCK_MONOTONIC, &end);
>  
> -	PER_PAGE_DEBUG("UFFDIO_COPY %d \t%lld ns\n", tid,
> -		       (long long)timespec_to_ns(timespec_diff(start, end)));
> +	PER_PAGE_DEBUG("UFFDIO_COPY %d \t%ld ns\n", tid,
> +		       timespec_to_ns(timespec_sub(end, start)));
>  	PER_PAGE_DEBUG("Paged in %ld bytes at 0x%lx from thread %d\n",
>  		       host_page_size, addr, tid);
>  
> @@ -224,8 +223,7 @@ static void *uffd_handler_thread_fn(void *arg)
>  	int pipefd = uffd_args->pipefd;
>  	useconds_t delay = uffd_args->delay;
>  	int64_t pages = 0;
> -	struct timespec start;
> -	struct timespec end;
> +	struct timespec start, end, ts_diff;
>  
>  	clock_gettime(CLOCK_MONOTONIC, &start);
>  	while (!quit_uffd_thread) {
> @@ -295,11 +293,10 @@ static void *uffd_handler_thread_fn(void *arg)
>  	}
>  
>  	clock_gettime(CLOCK_MONOTONIC, &end);
> -	PER_VCPU_DEBUG("userfaulted %ld pages over %lld.%.9lds. (%f/sec)\n",
> -		       pages, (long long)(timespec_diff(start, end).tv_sec),
> -		       timespec_diff(start, end).tv_nsec, pages /
> -		       ((double)timespec_diff(start, end).tv_sec +
> -			(double)timespec_diff(start, end).tv_nsec / 100000000.0));
> +	ts_diff = timespec_sub(end, start);
> +	PER_VCPU_DEBUG("userfaulted %ld pages over %ld.%.9lds. (%f/sec)\n",
> +		       pages, ts_diff.tv_sec, ts_diff.tv_nsec,
> +		       pages / ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
>  
>  	return NULL;
>  }
> @@ -360,13 +357,12 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
>  	pthread_t *vcpu_threads;
>  	pthread_t *uffd_handler_threads = NULL;
>  	struct uffd_handler_args *uffd_args = NULL;
> +	struct timespec start, end, ts_diff;
>  	int *pipefds = NULL;
>  	struct kvm_vm *vm;
>  	uint64_t guest_num_pages;
>  	int vcpu_id;
>  	int r;
> -	struct timespec start;
> -	struct timespec end;
>  
>  	vm = create_vm(mode, vcpus, vcpu_memory_bytes);
>  
> @@ -514,12 +510,11 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
>  		}
>  	}
>  
> -	pr_info("Total guest execution time: %lld.%.9lds\n",
> -		(long long)(timespec_diff(start, end).tv_sec),
> -		timespec_diff(start, end).tv_nsec);
> +	ts_diff = timespec_sub(end, start);
> +	pr_info("Total guest execution time: %ld.%.9lds\n",
> +		ts_diff.tv_sec, ts_diff.tv_nsec);
>  	pr_info("Overall demand paging rate: %f pgs/sec\n",
> -		guest_num_pages / ((double)timespec_diff(start, end).tv_sec +
> -		(double)timespec_diff(start, end).tv_nsec / 100000000.0));
> +		guest_num_pages / ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
>  
>  	ucall_uninit(vm);
>  	kvm_vm_free(vm);
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index f588ad1403f1..5eb01bf51b86 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -61,7 +61,8 @@ void test_assert(bool exp, const char *exp_str,
>  size_t parse_size(const char *size);
>  
>  int64_t timespec_to_ns(struct timespec ts);
> -struct timespec timespec_diff(struct timespec start, struct timespec end);
>  struct timespec timespec_add_ns(struct timespec ts, int64_t ns);
> +struct timespec timespec_add(struct timespec ts1, struct timespec ts2);
> +struct timespec timespec_sub(struct timespec ts1, struct timespec ts2);
>  
>  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index ee12c4b9ae05..689e97c27ee2 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -56,36 +56,31 @@ int64_t timespec_to_ns(struct timespec ts)
>  	return (int64_t)ts.tv_nsec + 1000000000LL * (int64_t)ts.tv_sec;
>  }
>  
> -struct timespec timespec_diff(struct timespec start, struct timespec end)
> -{
> -	struct timespec temp;
> -
> -	if ((end.tv_nsec - start.tv_nsec) < 0) {
> -		temp.tv_sec = end.tv_sec - start.tv_sec - 1;
> -		temp.tv_nsec = 1000000000LL + end.tv_nsec - start.tv_nsec;
> -	} else {
> -		temp.tv_sec = end.tv_sec - start.tv_sec;
> -		temp.tv_nsec = end.tv_nsec - start.tv_nsec;
> -	}
> -
> -	return temp;
> -}
> -
>  struct timespec timespec_add_ns(struct timespec ts, int64_t ns)
>  {
>  	struct timespec res;
>  
> -	res.tv_sec = ts.tv_sec;
>  	res.tv_nsec = ts.tv_nsec + ns;
> -
> -	if (res.tv_nsec > 1000000000UL) {
> -		res.tv_sec += 1;
> -		res.tv_nsec -= 1000000000UL;
> -	}
> +	res.tv_sec = ts.tv_sec + res.tv_nsec / 1000000000LL;
> +	res.tv_nsec %= 1000000000LL;
>  
>  	return res;
>  }
>  
> +struct timespec timespec_add(struct timespec ts1, struct timespec ts2)
> +{
> +	int64_t ns1 = timespec_to_ns(ts1);
> +	int64_t ns2 = timespec_to_ns(ts2);
> +	return timespec_add_ns((struct timespec){0}, ns1 + ns2);
> +}
> +
> +struct timespec timespec_sub(struct timespec ts1, struct timespec ts2)
> +{
> +	int64_t ns1 = timespec_to_ns(ts1);
> +	int64_t ns2 = timespec_to_ns(ts2);
> +	return timespec_add_ns((struct timespec){0}, ns1 - ns2);
> +}
> +
>  void print_skip(const char *fmt, ...)
>  {
>  	va_list ap;
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index 21990d653099..86f30eda0ae7 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -242,7 +242,7 @@ static void *do_steal_time(void *arg)
>  
>  	while (1) {
>  		clock_gettime(CLOCK_MONOTONIC, &ts);
> -		if (ts.tv_sec > stop.tv_sec || ts.tv_nsec >= stop.tv_nsec)
> +		if (timespec_to_ns(timespec_sub(ts, stop)) >= 0)
>  			break;
>  	}
>  
> 

