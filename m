Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1352541D560
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 10:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349098AbhI3I2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 04:28:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348048AbhI3I2H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 04:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632990384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HSk9jfMRB9kSdiGq11uRPW4mbMRPUAN/8ESuN4KseJo=;
        b=NSJfqPmgXy3IVzinuwRgbi8excHjSCnU7fe8FmgUQ/rOyvR0i9z29i9653lBYQhWpuseUB
        0qbsCsLDJysSFT06QecokjqOnH6yvKVZuxYNINA+ZHAb+upaySQLqQMoP2iQTY6vki49vH
        on3ppdcScEy+zNSWcvUfZ6XLAOAeQh0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-jLWfwbaWOleM8QUIcLyOGA-1; Thu, 30 Sep 2021 04:26:23 -0400
X-MC-Unique: jLWfwbaWOleM8QUIcLyOGA-1
Received: by mail-ed1-f69.google.com with SMTP id w8-20020a50f108000000b003da70d30658so5456245edl.6
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 01:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HSk9jfMRB9kSdiGq11uRPW4mbMRPUAN/8ESuN4KseJo=;
        b=RQ+jDGaFdKSNCN+LT+GJkw9nddyf2bURQkXKLZY24fHvE4Kw6VCpCzlUVdj1Wg8khf
         cg4/ALQeJof0WTNTsNfY+TgX9GvG53SfSeGPZb4257/jdRHDtboy/szK6o7IfXNHXxg9
         GrmpnmEk3j1+kcX8DbV6z7JoS6MHdSD05zZYLWc8SZsDb4zl8xDOnOxqP2ck27bdH4P4
         4TbPXaAzyceRFfAdsVNzh2/aFX+hntFltiSFkSqxyZlNepgvieqmCSoDtuOGv1RirBKz
         p2FeqamEHznckZFvlyozeYqjUWjAuPwqgxxPC5+K1al4ep4OSzfugviq3+Bk/2FJBigM
         v1Jw==
X-Gm-Message-State: AOAM53098x/FcGr+sZYvBHcrS6bZuH11aNL/C7WCPXVUko7VoLwmrUfx
        pOyLYE7tokxAALJH5lb3lSccsNyauMS9bAxwg/FIopLLaOo7MIWL4VCB0xYbjkWeQdcj5xq21ow
        19RTTFxzpUXeZ
X-Received: by 2002:a17:906:4f82:: with SMTP id o2mr5310072eju.10.1632990382029;
        Thu, 30 Sep 2021 01:26:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqNLGi0BHi4i2hOmRNg+Ye5dw0X2NHj9Gj/9542H6uOqiL7/HheHHFd2uWWjlhjd1F03+YzQ==
X-Received: by 2002:a17:906:4f82:: with SMTP id o2mr5310054eju.10.1632990381784;
        Thu, 30 Sep 2021 01:26:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id p26sm1081556eds.58.2021.09.30.01.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 01:26:21 -0700 (PDT)
Message-ID: <6e60db1e-3ca0-55e0-f700-bcd0a5e4084d@redhat.com>
Date:   Thu, 30 Sep 2021 10:26:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: selftests: Ensure all migrations are performed when
 test is affined
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dongli Zhang <dongli.zhang@oracle.com>
References: <20210929234112.1862848-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210929234112.1862848-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/21 01:41, Sean Christopherson wrote:
> Rework the CPU selection in the migration worker to ensure the specified
> number of migrations are performed when the test iteslf is affined to a
> subset of CPUs.  The existing logic skips iterations if the target CPU is
> not in the original set of possible CPUs, which causes the test to fail
> if too many iterations are skipped.
> 
>    ==== Test Assertion Failure ====
>    rseq_test.c:228: i > (NR_TASK_MIGRATIONS / 2)
>    pid=10127 tid=10127 errno=4 - Interrupted system call
>       1  0x00000000004018e5: main at rseq_test.c:227
>       2  0x00007fcc8fc66bf6: ?? ??:0
>       3  0x0000000000401959: _start at ??:?
>    Only performed 4 KVM_RUNs, task stalled too much?
> 
> Calculate the min/max possible CPUs as a cheap "best effort" to avoid
> high runtimes when the test is affined to a small percentage of CPUs.
> Alternatively, a list or xarray of the possible CPUs could be used, but
> even in a horrendously inefficient setup, such optimizations are not
> needed because the runtime is completely dominated by the cost of
> migrating the task, and the absolute runtime is well under a minute in
> even truly absurd setups, e.g. running on a subset of vCPUs in a VM that
> is heavily overcommited (16 vCPUs per pCPU).
> 
> Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/rseq_test.c | 69 +++++++++++++++++++++----
>   1 file changed, 59 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index c5e0dd664a7b..4158da0da2bb 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -10,6 +10,7 @@
>   #include <signal.h>
>   #include <syscall.h>
>   #include <sys/ioctl.h>
> +#include <sys/sysinfo.h>
>   #include <asm/barrier.h>
>   #include <linux/atomic.h>
>   #include <linux/rseq.h>
> @@ -39,6 +40,7 @@ static __thread volatile struct rseq __rseq = {
>   
>   static pthread_t migration_thread;
>   static cpu_set_t possible_mask;
> +static int min_cpu, max_cpu;
>   static bool done;
>   
>   static atomic_t seq_cnt;
> @@ -57,20 +59,37 @@ static void sys_rseq(int flags)
>   	TEST_ASSERT(!r, "rseq failed, errno = %d (%s)", errno, strerror(errno));
>   }
>   
> +static int next_cpu(int cpu)
> +{
> +	/*
> +	 * Advance to the next CPU, skipping those that weren't in the original
> +	 * affinity set.  Sadly, there is no CPU_SET_FOR_EACH, and cpu_set_t's
> +	 * data storage is considered as opaque.  Note, if this task is pinned
> +	 * to a small set of discontigous CPUs, e.g. 2 and 1023, this loop will
> +	 * burn a lot cycles and the test will take longer than normal to
> +	 * complete.
> +	 */
> +	do {
> +		cpu++;
> +		if (cpu > max_cpu) {
> +			cpu = min_cpu;
> +			TEST_ASSERT(CPU_ISSET(cpu, &possible_mask),
> +				    "Min CPU = %d must always be usable", cpu);
> +			break;
> +		}
> +	} while (!CPU_ISSET(cpu, &possible_mask));
> +
> +	return cpu;
> +}
> +
>   static void *migration_worker(void *ign)
>   {
>   	cpu_set_t allowed_mask;
> -	int r, i, nr_cpus, cpu;
> +	int r, i, cpu;
>   
>   	CPU_ZERO(&allowed_mask);
>   
> -	nr_cpus = CPU_COUNT(&possible_mask);
> -
> -	for (i = 0; i < NR_TASK_MIGRATIONS; i++) {
> -		cpu = i % nr_cpus;
> -		if (!CPU_ISSET(cpu, &possible_mask))
> -			continue;
> -
> +	for (i = 0, cpu = min_cpu; i < NR_TASK_MIGRATIONS; i++, cpu = next_cpu(cpu)) {
>   		CPU_SET(cpu, &allowed_mask);
>   
>   		/*
> @@ -154,6 +173,36 @@ static void *migration_worker(void *ign)
>   	return NULL;
>   }
>   
> +static int calc_min_max_cpu(void)
> +{
> +	int i, cnt, nproc;
> +
> +	if (CPU_COUNT(&possible_mask) < 2)
> +		return -EINVAL;
> +
> +	/*
> +	 * CPU_SET doesn't provide a FOR_EACH helper, get the min/max CPU that
> +	 * this task is affined to in order to reduce the time spent querying
> +	 * unusable CPUs, e.g. if this task is pinned to a small percentage of
> +	 * total CPUs.
> +	 */
> +	nproc = get_nprocs_conf();
> +	min_cpu = -1;
> +	max_cpu = -1;
> +	cnt = 0;
> +
> +	for (i = 0; i < nproc; i++) {
> +		if (!CPU_ISSET(i, &possible_mask))
> +			continue;
> +		if (min_cpu == -1)
> +			min_cpu = i;
> +		max_cpu = i;
> +		cnt++;
> +	}
> +
> +	return (cnt < 2) ? -EINVAL : 0;
> +}
> +
>   int main(int argc, char *argv[])
>   {
>   	int r, i, snapshot;
> @@ -167,8 +216,8 @@ int main(int argc, char *argv[])
>   	TEST_ASSERT(!r, "sched_getaffinity failed, errno = %d (%s)", errno,
>   		    strerror(errno));
>   
> -	if (CPU_COUNT(&possible_mask) < 2) {
> -		print_skip("Only one CPU, task migration not possible\n");
> +	if (calc_min_max_cpu()) {
> +		print_skip("Only one usable CPU, task migration not possible");
>   		exit(KSFT_SKIP);
>   	}
>   
> 

Queued, thanks.

Paolo

