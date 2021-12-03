Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A6F4675B9
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 11:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380165AbhLCK7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 05:59:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34948 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237898AbhLCK67 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 05:58:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638528935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nFj9rWN7S7vuib57ob5QlML0gmhUnKVbSla0HzR2Qjs=;
        b=bmkNcHd7ViJAjiSJEI1gLM8QPW5JjTrviAZ+xviBaSsJTzwUm8OqJ6t3ntdiXeKtoBsrj+
        LSs1Cxl7kfkConMbBVN73uK90uVGGV1IUkw3Bc4zkds7jkzzgWBWW476gafKaPIVH4ujdD
        yd+pvjZ7ELKXCcG2mhD246M1ZE+kwmM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-u4edm0jlNgCkZhfzTQ_dGQ-1; Fri, 03 Dec 2021 05:55:34 -0500
X-MC-Unique: u4edm0jlNgCkZhfzTQ_dGQ-1
Received: by mail-wm1-f70.google.com with SMTP id 201-20020a1c04d2000000b003335bf8075fso1385962wme.0
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 02:55:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=nFj9rWN7S7vuib57ob5QlML0gmhUnKVbSla0HzR2Qjs=;
        b=nRPA4+AWGMOw5nPQ/1Q4GbUIPrrf7L061vQGLrETbUm3CwkIOyD5VH9B101aX/pnMk
         BjN0YGvrh5/ABwO31vZdLPYpSox7Jt3/ufv0LIePqpeFc/breNcDBTh3b1VjWrHOFzym
         NeKNsYm0py6QZB3Une6nW0rRHnq3Pvizwez0cuKHig2GBIbGHxHQbTLUg7XrsjT3PyDv
         jYVRYDi9Z4m/OKVtdIDR7k7ucj7GC7BIOHWAUc/J7P1S/1BV6auXO2n2ak9Ccyqu/Ehx
         YDUQt7/XXsX+E7NLyvWmOIjm4eEbnNPSWyVYn/Of0yl/y8StjRd8caUyyVA08Y48bSFZ
         uELg==
X-Gm-Message-State: AOAM532tnMbZvGGb29gmMfp2PRJni/GRx9T5wQHGTzO0GLmAR8hEBX1b
        6+pxup+KuR0bR1lYTauxTpFvK23CwYzZ822JEohLhm1YKzC4u8wgpg8Wn3zhQmEK0WkS+gROvHe
        sEgrPKo9bz0JS
X-Received: by 2002:adf:db04:: with SMTP id s4mr20392075wri.467.1638528932755;
        Fri, 03 Dec 2021 02:55:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZEQ+qZhV43zN2BozwBHr6roxUn9gyXW8s8bQmG1Ykj1VkU+fnEngvgmzKikpNKHkJ0EK/Zg==
X-Received: by 2002:adf:db04:: with SMTP id s4mr20392048wri.467.1638528932519;
        Fri, 03 Dec 2021 02:55:32 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id o10sm2914435wri.15.2021.12.03.02.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 02:55:32 -0800 (PST)
Message-ID: <11f0ff2f-2bae-0f1b-753f-b0e9dc24b345@redhat.com>
Date:   Fri, 3 Dec 2021 11:55:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
References: <20211202123553.96412-1-david@redhat.com>
 <20211202123553.96412-3-david@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: firq: floating interrupt
 test
In-Reply-To: <20211202123553.96412-3-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/2021 13.35, David Hildenbrand wrote:
> We had a KVM BUG fixed by kernel commit a3e03bc1368c ("KVM: s390: index
> kvm->arch.idle_mask by vcpu_idx"), whereby a floating interrupt might get
> stuck forever because a CPU in the wait state would not get woken up.
> 
> The issue can be triggered when CPUs are created in a nonlinear fashion,
> such that the CPU address ("core-id") and the KVM cpu id don't match.
> 
> So let's start with a floating interrupt test that will trigger a
> floating interrupt (via SCLP) to be delivered to a CPU in the wait state.

Thank you very much for tackling this! Some remarks below...

> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   lib/s390x/sclp.c    |  11 ++--
>   lib/s390x/sclp.h    |   1 +
>   s390x/Makefile      |   1 +
>   s390x/firq.c        | 122 ++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |  10 ++++
>   5 files changed, 142 insertions(+), 3 deletions(-)
>   create mode 100644 s390x/firq.c
> 
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 0272249..33985eb 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -60,9 +60,7 @@ void sclp_setup_int(void)
>   void sclp_handle_ext(void)
>   {
>   	ctl_clear_bit(0, CTL0_SERVICE_SIGNAL);
> -	spin_lock(&sclp_lock);
> -	sclp_busy = false;
> -	spin_unlock(&sclp_lock);
> +	sclp_clear_busy();
>   }
>   
>   void sclp_wait_busy(void)
> @@ -89,6 +87,13 @@ void sclp_mark_busy(void)
>   	}
>   }
>   
> +void sclp_clear_busy(void)
> +{
> +	spin_lock(&sclp_lock);
> +	sclp_busy = false;
> +	spin_unlock(&sclp_lock);
> +}
> +
>   static void sclp_read_scp_info(ReadInfo *ri, int length)
>   {
>   	unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 61e9cf5..fead007 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -318,6 +318,7 @@ void sclp_setup_int(void);
>   void sclp_handle_ext(void);
>   void sclp_wait_busy(void);
>   void sclp_mark_busy(void);
> +void sclp_clear_busy(void);
>   void sclp_console_setup(void);
>   void sclp_print(const char *str);
>   void sclp_read_info(void);
> diff --git a/s390x/Makefile b/s390x/Makefile
> index f95f2e6..1e567c1 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -25,6 +25,7 @@ tests += $(TEST_DIR)/uv-host.elf
>   tests += $(TEST_DIR)/edat.elf
>   tests += $(TEST_DIR)/mvpg-sie.elf
>   tests += $(TEST_DIR)/spec_ex-sie.elf
> +tests += $(TEST_DIR)/firq.elf
>   
>   tests_binary = $(patsubst %.elf,%.bin,$(tests))
>   ifneq ($(HOST_KEY_DOCUMENT),)
> diff --git a/s390x/firq.c b/s390x/firq.c
> new file mode 100644
> index 0000000..1f87718
> --- /dev/null
> +++ b/s390x/firq.c
> @@ -0,0 +1,122 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Floating interrupt tests.
> + *
> + * Copyright 2021 Red Hat Inc
> + *
> + * Authors:
> + *    David Hildenbrand <david@redhat.com>
> + */
> +#include <libcflat.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/page.h>
> +#include <asm-generic/barrier.h>
> +
> +#include <sclp.h>
> +#include <smp.h>
> +#include <alloc_page.h>
> +
> +static void wait_for_sclp_int(void)
> +{
> +	/* Enable SCLP interrupts on this CPU only. */
> +	ctl_set_bit(0, CTL0_SERVICE_SIGNAL);
> +
> +	/* Enable external interrupts and go to the wait state. */
> +	wait_for_interrupt(PSW_MASK_EXT);
> +}

What happens if the CPU got an interrupt? Should there be a "while (true)" 
at the end of the function to avoid that the CPU ends up crashing at the end 
of the function?

> +/*
> + * Some KVM versions might mix CPUs when looking for a floating IRQ target,
> + * accidentially detecting a stopped CPU as waiting and resulting in the actually
> + * waiting CPU not getting woken up for the interrupt.
> + */
> +static void test_wait_state_delivery(void)
> +{
> +	struct psw psw;
> +	SCCBHeader *h;
> +	int ret;
> +
> +	report_prefix_push("wait state delivery");
> +
> +	if (smp_query_num_cpus() < 3) {
> +		report_skip("need at least 3 CPUs for this test");
> +		goto out;
> +	}
> +
> +	if (stap()) {
> +		report_skip("need to start on CPU #0");
> +		goto out;
> +	}

I think I'd rather turn this into an assert() instead ... no strong opinion 
about it, though.

> +
> +	/*
> +	 * We want CPU #2 to be stopped. This should be the case at this
> +	 * point, however, we want to sense if it even exists as well.
> +	 */
> +	ret = smp_cpu_stop(2);
> +	if (ret) {
> +		report_skip("CPU #2 not found");

Since you already queried for the availablity of at least 3 CPUs above, I 
think you could turn this into a report_fail() instead?

> +		goto out;
> +	}
> +
> +	/*
> +	 * We're going to perform an SCLP service call but expect
> +	 * the interrupt on CPU #1 while it is in the wait state.
> +	 */
> +	sclp_mark_busy();
> +
> +	/* Start CPU #1 and let it wait for the interrupt. */
> +	psw.mask = extract_psw_mask();
> +	psw.addr = (unsigned long)wait_for_sclp_int;
> +	ret = smp_cpu_setup(1, psw);
> +	if (ret) {
> +		sclp_clear_busy();
> +		report_skip("cpu #1 not found");
> +		goto out;
> +	}
> +
> +	/*
> +	 * We'd have to jump trough some hoops to sense e.g., via SIGP
> +	 * CONDITIONAL EMERGENCY SIGNAL if CPU #1 is already in the
> +	 * wait state.
> +	 *
> +	 * Although not completely reliable, use SIGP SENSE RUNNING STATUS
> +	 * until not reported as running -- after all, our SCLP processing
> +	 * will take some time as well and smp_cpu_setup() returns when we're
> +	 * either already in wait_for_sclp_int() or just about to execute it.
> +	 */
> +	while(smp_sense_running_status(1));
> +
> +	h = alloc_page();
> +	h->length = 4096;
> +	ret = servc(SCLP_CMDW_READ_CPU_INFO, __pa(h));
> +	if (ret) {
> +		sclp_clear_busy();
> +		report_fail("SCLP_CMDW_READ_CPU_INFO failed");
> +		goto out_destroy;
> +	}
> +
> +	/*
> +	 * Wait until the interrupt gets delivered on CPU #1, marking the
> +	 * SCLP requests as done.
> +	 */
> +	sclp_wait_busy();
> +
> +	report(true, "sclp interrupt delivered");
> +
> +out_destroy:
> +	free_page(h);
> +	smp_cpu_destroy(1);
> +out:
> +	report_prefix_pop();
> +}

Anyway, code looks fine for me, either with my comments addressed or not:

Reviewed-by: Thomas Huth <thuth@redhat.com>

