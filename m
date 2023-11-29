Return-Path: <kvm+bounces-2726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D427FCF5C
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 07:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D0D7281CD9
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 06:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A39566FD3;
	Wed, 29 Nov 2023 06:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CxZL+k/Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EB819A6
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 22:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701240617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AHA+jAwKlaCovHGQsXB1D2aSSp8od4/kNe2Qw9++Xtw=;
	b=CxZL+k/Y0ApaOqSJ1ZmNAp5YuFDws078BM0N2tewOlfNDvz8WhW6UTlZedNQYHqGX6e9aJ
	j7U1zqC2AaOCyNMsgOpIN3fCoTpY0dJ7nQ3U61jx0YYi+nKXTpNSkNZ1AIBSumAoe1EjlV
	cuWvNfmfH86tMW2F2fbYkaI/B6CfZI0=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-686xEI3KMD6oNGrHwDtD6g-1; Wed, 29 Nov 2023 01:50:15 -0500
X-MC-Unique: 686xEI3KMD6oNGrHwDtD6g-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1cfc340c40cso12804965ad.1
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 22:50:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701240614; x=1701845414;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AHA+jAwKlaCovHGQsXB1D2aSSp8od4/kNe2Qw9++Xtw=;
        b=OlkwlXkqXZH/ClHaYPRgFAsKJlH5fksYcd5OYDyv1+/bZIl73IVBvMnIJgsi7CrJcc
         0ZZKvJyc4vxkwy6cAE86ncj2Dfj+8YKsrBAm/w6a0My10WgQ1wsHm2ASEyFBusj53DST
         Btuo+V+T7KKYrqIDq3Ww2i2oz1Qb4Bz+sSLWBeJyHuHDdJzgnIRBgJs2UvJMMagRRZwl
         l7DXzSrAl2K/bC6UCsJ4LAOc6FSNHwY+W0klYifs4+H7m8lk9tnap9zTqtGtoZ5ZYQk2
         iD4CJP30Ko6c2eJ9V8C08GXMJBfAh9h5/T8SaTJmdQArrraWkUdhD8lqsa5k1qMUOZpW
         89Hw==
X-Gm-Message-State: AOJu0YxYVGt3mA6V7LwN7cl6CsusTgWmFkJ1r3AI3mz0x2WqcPW28C6C
	N5IRP/erHBrC4qSaMnZcgXLCD0SaJZNFIcggzc3MoukvE8Mz6n3X9bXy4DqyNhwthq49ftjAHiD
	4YsVptRs50oixJFWygdj1K7fGJB0Clg3FAwHjTVaAtqEIQx+ajPJrpxjq8MVw7/DWNVJ+lI6hgI
	qysA==
X-Received: by 2002:a05:6a20:a11c:b0:18b:c9cf:4521 with SMTP id q28-20020a056a20a11c00b0018bc9cf4521mr17747845pzk.2.1701240613774;
        Tue, 28 Nov 2023 22:50:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHE2xrUao/RhjJjda73nPdFOnK+/MrmdpsZADcu3bAluUflDUxgKey5q7Du+Lm1fFtsc+6eug==
X-Received: by 2002:a05:6a20:a11c:b0:18b:c9cf:4521 with SMTP id q28-20020a056a20a11c00b0018bc9cf4521mr17747829pzk.2.1701240613314;
        Tue, 28 Nov 2023 22:50:13 -0800 (PST)
Received: from [10.72.112.34] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c14200b001c755810f89sm11381913plj.181.2023.11.28.22.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Nov 2023 22:50:12 -0800 (PST)
Message-ID: <7bd42b9b-5173-6737-4a54-e5a2bb0986df@redhat.com>
Date: Wed, 29 Nov 2023 14:50:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] KVM: selftests: Fix the dirty_log_test semaphore
 imbalance
Content-Language: en-US
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>
References: <20231117052210.26396-1-shahuang@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231117052210.26396-1-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Kindly ping..

On 11/17/23 13:22, Shaoqin Huang wrote:
> When execute the dirty_log_test on some aarch64 machine, it sometimes
> trigger the ASSERT:
> 
> ==== Test Assertion Failure ====
>    dirty_log_test.c:384: dirty_ring_vcpu_ring_full
>    pid=14854 tid=14854 errno=22 - Invalid argument
>       1  0x00000000004033eb: dirty_ring_collect_dirty_pages at dirty_log_test.c:384
>       2  0x0000000000402d27: log_mode_collect_dirty_pages at dirty_log_test.c:505
>       3   (inlined by) run_test at dirty_log_test.c:802
>       4  0x0000000000403dc7: for_each_guest_mode at guest_modes.c:100
>       5  0x0000000000401dff: main at dirty_log_test.c:941 (discriminator 3)
>       6  0x0000ffff9be173c7: ?? ??:0
>       7  0x0000ffff9be1749f: ?? ??:0
>       8  0x000000000040206f: _start at ??:?
>    Didn't continue vcpu even without ring full
> 
> The dirty_log_test fails when execute the dirty-ring test, this is
> because the sem_vcpu_cont and the sem_vcpu_stop is non-zero value when
> execute the dirty_ring_collect_dirty_pages() function. When those two
> sem_t variables are non-zero, the dirty_ring_wait_vcpu() at the
> beginning of the dirty_ring_collect_dirty_pages() will not wait for the
> vcpu to stop, but continue to execute the following code. In this case,
> before vcpu stop, if the dirty_ring_vcpu_ring_full is true, and the
> dirty_ring_collect_dirty_pages() has passed the check for the
> dirty_ring_vcpu_ring_full but hasn't execute the check for the
> continued_vcpu, the vcpu stop, and set the dirty_ring_vcpu_ring_full to
> false. Then dirty_ring_collect_dirty_pages() will trigger the ASSERT.
> 
> Why sem_vcpu_cont and sem_vcpu_stop can be non-zero value? It's because
> the dirty_ring_before_vcpu_join() execute the sem_post(&sem_vcpu_cont)
> at the end of each dirty-ring test. It can cause two cases:
> 
> 1. sem_vcpu_cont be non-zero. When we set the host_quit to be true,
>     the vcpu_worker directly see the host_quit to be true, it quit. So
>     the log_mode_before_vcpu_join() function will set the sem_vcpu_cont
>     to 1, since the vcpu_worker has quit, it won't consume it.
> 2. sem_vcpu_stop be non-zero. When we set the host_quit to be true,
>     the vcpu_worker has entered the guest state, the next time it exit
>     from guest state, it will set the sem_vcpu_stop to 1, and then see
>     the host_quit, no one will consume the sem_vcpu_stop.
> 
> When execute more and more dirty-ring tests, the sem_vcpu_cont and
> sem_vcpu_stop can be larger and larger, which makes many code paths
> don't wait for the sem_t. Thus finally cause the problem.
> 
> To fix this problem, we can wait a while before set the host_quit to
> true, which gives the vcpu time to enter the guest state, so it will
> exit again. Then we can wait the vcpu to exit, and let it continue
> again, then the vcpu will see the host_quit. Thus the sem_vcpu_cont and
> sem_vcpu_stop will be both zero when test finished.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
> v1->v2:
>    - Fix the real logic bug, not just fresh the context.
> 
> v1: https://lore.kernel.org/all/20231116093536.22256-1-shahuang@redhat.com/
> ---
>   tools/testing/selftests/kvm/dirty_log_test.c | 16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 936f3a8d1b83..a6e0ff46a07c 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -417,7 +417,8 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
>   
>   static void dirty_ring_before_vcpu_join(void)
>   {
> -	/* Kick another round of vcpu just to make sure it will quit */
> +	/* Wait vcpu exit, and let it continue to see the host_quit. */
> +	dirty_ring_wait_vcpu();
>   	sem_post(&sem_vcpu_cont);
>   }
>   
> @@ -719,6 +720,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   	struct kvm_vm *vm;
>   	unsigned long *bmap;
>   	uint32_t ring_buf_idx = 0;
> +	int sem_val;
>   
>   	if (!log_mode_supported()) {
>   		print_skip("Log mode '%s' not supported",
> @@ -726,6 +728,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   		return;
>   	}
>   
> +	sem_getvalue(&sem_vcpu_stop, &sem_val);
> +	assert(sem_val == 0);
> +	sem_getvalue(&sem_vcpu_cont, &sem_val);
> +	assert(sem_val == 0);
> +
>   	/*
>   	 * We reserve page table for 2 times of extra dirty mem which
>   	 * will definitely cover the original (1G+) test range.  Here
> @@ -825,6 +832,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   		sync_global_to_guest(vm, iteration);
>   	}
>   
> +	/*
> +	 *
> +	 * Before we set the host_quit, let the vcpu has time to run, to make
> +	 * sure we consume the sem_vcpu_stop and the vcpu consume the
> +	 * sem_vcpu_cont, to keep the semaphore balance.
> +	 */
> +	usleep(p->interval * 1000);
>   	/* Tell the vcpu thread to quit */
>   	host_quit = true;
>   	log_mode_before_vcpu_join();

-- 
Shaoqin


