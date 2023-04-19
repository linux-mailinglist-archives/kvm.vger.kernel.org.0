Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545786E7B06
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbjDSNhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbjDSNha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:37:30 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E57059F0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:36:53 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1a8097c1ccfso14689805ad.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681911413; x=1684503413;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iOX9IhenPqCIJQOLNcwKs+Lj53e3MnWmvQSEeYt/aVM=;
        b=eIw28Fwx3KFF/gqyxVXtFtBhs73dZDKFEY6zJ/fJvgwxgSZ+wJFbp0WwEI2ZHbkP3a
         ElDs0AVTJC3iAT7Y5pUuhIE1ezLSnOOS6baKV+mY+LoQysdawl7t2hkD/KVoO7xzEaCf
         kTiwlI+yuBs8jUwFyQf5gDb+TCy5I9CF2EDFD/EpC7a0w+pkQtt3DYDfdA9mPVNCcoIq
         FpWKSwGXej0XtISCC5vBgq0tWMz9zOYP6sjtka//t+ETIZUxLSr3zcVnqFuOv8VmvtiE
         LrsOWBVIbSmQIMJIFrVy6AlH39FvkBAV7twf6YsrNtyMAfyMHvkT7F4Ap0vhWeA5xsAr
         NktQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681911413; x=1684503413;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iOX9IhenPqCIJQOLNcwKs+Lj53e3MnWmvQSEeYt/aVM=;
        b=Ev5pXdBPNuZy31toCIvMNswMCMESmg/6h0db+PHUKJOfIiG3OjL9rfIg9+/wz7FRWP
         4Uaxl0tmIadhzr24IoV2uF3GjKDLIEyUKC67SYFT3LTN+XqAzxS9cPQ5uJtsPxU6/M73
         SWX4AaR9NYCo71hD0ZZ6M+8fy/MRxzVcdYAiJWkHwiSuhyUna09MDxlhfq2Uls1+UrD/
         ZS11hbAKcDfpRp8M9LtGvMEdJttJWomFXiVssFMYtq0V+28aqWbMSK/kjeiSiAzMs9+L
         02nKuuh93Jp2xHcw3kbh2vPnDc7hncVZQJgNoikIAvCoNI8xS8A0Ex2UBxe+6rskf7p5
         Ba9Q==
X-Gm-Message-State: AAQBX9cC61cz/31wwdJlZdOn4CHIV9dOzfrRFV6SkqvsIVoBMLdF5hVQ
        nhr4bG4Z/2jnV5tIwB0LcY0=
X-Google-Smtp-Source: AKy350alXc1ONRhUA7XIa28nLbvt2XJ7sqqCYuAOmq3t7gBkrrJYXz7/rkS9YfIcmDF6ZbQaMcb/Aw==
X-Received: by 2002:a17:903:22cc:b0:1a6:7570:5370 with SMTP id y12-20020a17090322cc00b001a675705370mr6297746plg.10.1681911412748;
        Wed, 19 Apr 2023 06:36:52 -0700 (PDT)
Received: from [172.27.232.10] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902bd4500b0019a8530c063sm11407873plx.102.2023.04.19.06.36.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 06:36:52 -0700 (PDT)
Message-ID: <a43e5deb-211a-c4c0-6b1d-7715c3665017@gmail.com>
Date:   Wed, 19 Apr 2023 21:36:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Hoo Robert <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 02/22] KVM: selftests: Use EPOLL in userfaultfd_util
 reader threads and signal errors via TEST_ASSERT
To:     Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com,
        maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-3-amoorthy@google.com>
Content-Language: en-US
In-Reply-To: <20230412213510.1220557-3-amoorthy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/13/2023 5:34 AM, Anish Moorthy wrote:
> With multiple reader threads POLLing a single UFFD, the test suffers
> from the thundering herd problem: performance degrades as the number of
> reader threads is increased. Solve this issue [1] by switching the
> the polling mechanism to EPOLL + EPOLLEXCLUSIVE.
> 
> Also, change the error-handling convention of uffd_handler_thread_fn.
> Instead of just printing errors and returning early from the polling
> loop, check for them via TEST_ASSERT. "return NULL" is reserved for a
> successful exit from uffd_handler_thread_fn, ie one triggered by a
> write to the exit pipe.
> 
> Performance samples generated by the command in [2] are given below.
> 
> Num Reader Threads, Paging Rate (POLL), Paging Rate (EPOLL)
> 1      249k      185k
> 2      201k      235k
> 4      186k      155k
> 16     150k      217k
> 32     89k       198k
> 
> [1] Single-vCPU performance does suffer somewhat.
> [2] ./demand_paging_test -u MINOR -s shmem -v 4 -o -r <num readers>
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> Acked-by: James Houghton <jthoughton@google.com>
> ---
>   .../selftests/kvm/demand_paging_test.c        |  1 -
>   .../selftests/kvm/lib/userfaultfd_util.c      | 74 +++++++++----------
>   2 files changed, 35 insertions(+), 40 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 6c2253f4a64ef..c729cee4c2055 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -13,7 +13,6 @@
>   #include <stdio.h>
>   #include <stdlib.h>
>   #include <time.h>
> -#include <poll.h>
>   #include <pthread.h>
>   #include <linux/userfaultfd.h>
>   #include <sys/syscall.h>
> diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> index 2723ee1e3e1b2..909ad69c1cb04 100644
> --- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> +++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> @@ -16,6 +16,7 @@
>   #include <poll.h>
>   #include <pthread.h>
>   #include <linux/userfaultfd.h>
> +#include <sys/epoll.h>
>   #include <sys/syscall.h>
>   
>   #include "kvm_util.h"
> @@ -32,60 +33,55 @@ static void *uffd_handler_thread_fn(void *arg)
>   	int64_t pages = 0;
>   	struct timespec start;
>   	struct timespec ts_diff;
> +	int epollfd;
> +	struct epoll_event evt;
> +
> +	epollfd = epoll_create(1);
> +	TEST_ASSERT(epollfd >= 0, "Failed to create epollfd.");
> +
> +	evt.events = EPOLLIN | EPOLLEXCLUSIVE;
> +	evt.data.u32 = 0;
> +	TEST_ASSERT(epoll_ctl(epollfd, EPOLL_CTL_ADD, uffd, &evt) == 0,
> +				"Failed to add uffd to epollfd");
> +
> +	evt.events = EPOLLIN;
> +	evt.data.u32 = 1;
> +	TEST_ASSERT(epoll_ctl(epollfd, EPOLL_CTL_ADD, reader_args->pipe, &evt) == 0,
> +				"Failed to add pipe to epollfd");
>   
>   	clock_gettime(CLOCK_MONOTONIC, &start);
>   	while (1) {
>   		struct uffd_msg msg;
> -		struct pollfd pollfd[2];
> -		char tmp_chr;
>   		int r;
>   
> -		pollfd[0].fd = uffd;
> -		pollfd[0].events = POLLIN;
> -		pollfd[1].fd = reader_args->pipe;
> -		pollfd[1].events = POLLIN;
> -
> -		r = poll(pollfd, 2, -1);
> -		switch (r) {
> -		case -1:
> -			pr_info("poll err");
> -			continue;
> -		case 0:
> -			continue;
> -		case 1:
> -			break;
> -		default:
> -			pr_info("Polling uffd returned %d", r);
> -			return NULL;
> -		}
> +		r = epoll_wait(epollfd, &evt, 1, -1);
> +		TEST_ASSERT(r == 1,
> +					"Unexpected number of events (%d) from epoll, errno = %d",
> +					r, errno);
>   
too much indentation, also seen elsewhere.

> -		if (pollfd[0].revents & POLLERR) {
> -			pr_info("uffd revents has POLLERR");
> -			return NULL;
> -		}
> +		if (evt.data.u32 == 1) {
> +			char tmp_chr;
>   
> -		if (pollfd[1].revents & POLLIN) {
> -			r = read(pollfd[1].fd, &tmp_chr, 1);
> +			TEST_ASSERT(!(evt.events & (EPOLLERR | EPOLLHUP)),
> +						"Reader thread received EPOLLERR or EPOLLHUP on pipe.");
> +			r = read(reader_args->pipe, &tmp_chr, 1);
>   			TEST_ASSERT(r == 1,
> -				    "Error reading pipefd in UFFD thread\n");
> +						"Error reading pipefd in uffd reader thread");
>   			return NULL;

How about goto
	ts_diff = timespec_elapsed(start);
Otherwise last stats won't get chances to be calc'ed.

>   		}
>   
> -		if (!(pollfd[0].revents & POLLIN))
> -			continue;
> +		TEST_ASSERT(!(evt.events & (EPOLLERR | EPOLLHUP)),
> +					"Reader thread received EPOLLERR or EPOLLHUP on uffd.");
>   
>   		r = read(uffd, &msg, sizeof(msg));
>   		if (r == -1) {
> -			if (errno == EAGAIN)
> -				continue;
> -			pr_info("Read of uffd got errno %d\n", errno);
> -			return NULL;
> +			TEST_ASSERT(errno == EAGAIN,
> +						"Error reading from UFFD: errno = %d", errno);
> +			continue;
>   		}
>   
> -		if (r != sizeof(msg)) {
> -			pr_info("Read on uffd returned unexpected size: %d bytes", r);
> -			return NULL;
> -		}
> +		TEST_ASSERT(r == sizeof(msg),
> +					"Read on uffd returned unexpected number of bytes (%d)", r);
>   
>   		if (!(msg.event & UFFD_EVENT_PAGEFAULT))
>   			continue;
> @@ -93,8 +89,8 @@ static void *uffd_handler_thread_fn(void *arg)
>   		if (reader_args->delay)
>   			usleep(reader_args->delay);
>   		r = reader_args->handler(reader_args->uffd_mode, uffd, &msg);
> -		if (r < 0)
> -			return NULL;
> +		TEST_ASSERT(r >= 0,
> +					"Reader thread handler fn returned negative value %d", r);
>   		pages++;
>   	}
>   

