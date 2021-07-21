Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501E23D0F76
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 15:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbhGUMqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 08:46:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233136AbhGUMqW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 08:46:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626874018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nxbue+MLWJvvQ8pF8b05EKI2JgsXvT5iNg1fbAjEN3I=;
        b=ZxwMRavHdIJwd0UtYjKwlkOwavj5SqfkC6HugnybR8vKChbYqjOjiGrTJXcYIArZMNv8Nt
        cq8hJqLgukHDxwSGOXx1ZfShZKwnR3ztVXNPvZBjKjRKrGu461q5LvPr+U5QFUiP9cxD2y
        uqxhB3ZyWOuxBgCKjFoMT/rUSvzZXmU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-keE5kzFhOo6nLBUgc2FHkg-1; Wed, 21 Jul 2021 09:26:56 -0400
X-MC-Unique: keE5kzFhOo6nLBUgc2FHkg-1
Received: by mail-wm1-f70.google.com with SMTP id p9-20020a7bcc890000b02902190142995dso1066629wma.4
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 06:26:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nxbue+MLWJvvQ8pF8b05EKI2JgsXvT5iNg1fbAjEN3I=;
        b=SJKkmIEbfJKRxcS2v//u05dMSSVL2GTuIAWBT4/fSdBrnlwt3M3auIEmElSvgt3raD
         B4W0I3hxLSibdcaApwR8klkHGer5YG3IE3NOECrUCQhCic1bu6mTjnrBsD98GnvFdc5S
         c/seKXGwR8IqQlHPBP0HFgVnCH1hR7kLmojd/Xw6y5uit2w+NnURYvqdaMWf01ogrh4f
         SDEU0AANFlhxuPWXER3megkA5gcLREU1kfUM5jPYwd7/3Ub1qbJZ8iARk2ahTkA4I4vX
         C8xjwtiV9q/bDckgUnRQ7qKzdxZi/BL0fKIWru1ggXn5pMiEgMiPPz8HxzyZ3Gj6IpoY
         6LMA==
X-Gm-Message-State: AOAM532mDTkJkqkww9I3M6ykzM62fKHunU/BoiF/PybfApC5m07DxkXx
        UbgQBUaWAZOEOGNzqtaq8jtI9N+OuT8qyg9xheXCxn4h4ghQKwcz0n8mqyaXxMOeWbAjuvynEyz
        b1JdpA8mXxkIe
X-Received: by 2002:adf:e4c3:: with SMTP id v3mr42497489wrm.362.1626874015560;
        Wed, 21 Jul 2021 06:26:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzF1s9vsANbI81ZKdzcRt3/xvn/ljvrrk3zUkmrYEwYf8f0XJZJw/fByAxopNe+R5KbgSt/9A==
X-Received: by 2002:adf:e4c3:: with SMTP id v3mr42497467wrm.362.1626874015352;
        Wed, 21 Jul 2021 06:26:55 -0700 (PDT)
Received: from thuth.remote.csb (p5791d597.dip0.t-ipconnect.de. [87.145.213.151])
        by smtp.gmail.com with ESMTPSA id o7sm31442351wrv.72.2021.07.21.06.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 06:26:54 -0700 (PDT)
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210706115459.372749-1-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Add specification exception test
Message-ID: <18803632-6a9c-5999-2a8a-d4501a0a77d8@redhat.com>
Date:   Wed, 21 Jul 2021 15:26:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210706115459.372749-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/07/2021 13.54, Janis Schoetterl-Glausch wrote:
> Generate specification exceptions and check that they occur.
> Also generate specification exceptions during a transaction,
> which results in another interruption code.
> With the iterations argument one can check if specification
> exception interpretation occurs, e.g. by using a high value and
> checking that the debugfs counters are substantially lower.
> The argument is also useful for estimating the performance benefit
> of interpretation.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   s390x/Makefile           |   1 +
>   lib/s390x/asm/arch_def.h |   1 +
>   s390x/spec_ex.c          | 344 +++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg      |   3 +
>   4 files changed, 349 insertions(+)
>   create mode 100644 s390x/spec_ex.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 8820e99..be100d3 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -23,6 +23,7 @@ tests += $(TEST_DIR)/sie.elf
>   tests += $(TEST_DIR)/mvpg.elf
>   tests += $(TEST_DIR)/uv-host.elf
>   tests += $(TEST_DIR)/edat.elf
> +tests += $(TEST_DIR)/spec_ex.elf
>   
>   tests_binary = $(patsubst %.elf,%.bin,$(tests))
>   ifneq ($(HOST_KEY_DOCUMENT),)
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 15cf7d4..7cb0b92 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -229,6 +229,7 @@ static inline uint64_t stctg(int cr)
>   	return value;
>   }
>   
> +#define CTL0_TRANSACT_EX_CTL	(63 -  8)
>   #define CTL0_LOW_ADDR_PROT	(63 - 35)
>   #define CTL0_EDAT		(63 - 40)
>   #define CTL0_IEP		(63 - 43)
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> new file mode 100644
> index 0000000..2e05bfb
> --- /dev/null
> +++ b/s390x/spec_ex.c
> @@ -0,0 +1,344 @@

Please add a short comment header at the top of the file with some 
information on what it is all about, and license information (e.g. a 
SPDX-License-Identifier)

> +#include <stdlib.h>
> +#include <htmintrin.h>
> +#include <libcflat.h>
> +#include <asm/barrier.h>
> +#include <asm/interrupt.h>
> +#include <asm/facility.h>
> +
> +struct lowcore *lc = (struct lowcore *) 0;
> +
> +static bool expect_early;
> +static struct psw expected_early_pgm_psw;
> +static struct psw fixup_early_pgm_psw;
> +
> +static void fixup_early_pgm_ex(void)

Could you please add a comment in front of this function with a description 
why this is required / good for?

> +{
> +	if (expect_early) {
> +		report(expected_early_pgm_psw.mask == lc->pgm_old_psw.mask
> +		       && expected_early_pgm_psw.addr == lc->pgm_old_psw.addr,
> +		       "Early program new PSW as expected");
> +		expect_early = false;
> +	}
> +	lc->pgm_old_psw = fixup_early_pgm_psw;
> +}
> +
> +static void lpsw(uint64_t psw)
> +{
> +	uint32_t *high, *low;
> +	uint64_t r0 = 0, r1 = 0;
> +
> +	high = (uint32_t *) &fixup_early_pgm_psw.mask;
> +	low = high + 1;
> +
> +	asm volatile (
> +		"	epsw	%0,%1\n"
> +		"	st	%0,%[high]\n"
> +		"	st	%1,%[low]\n"

What's all this magic with high and low good for? Looks like high and low 
are not used afterwards anymore?

> +		"	larl	%0,nop%=\n"
> +		"	stg	%0,%[addr]\n"
> +		"	lpsw	%[psw]\n"
> +		"nop%=:	nop\n"
> +		: "+&r"(r0), "+&a"(r1), [high] "=&R"(*high), [low] "=&R"(*low)

... also not sure why you need the "&" modifiers here?

> +		, [addr] "=&R"(fixup_early_pgm_psw.addr)
> +		: [psw] "Q"(psw)
> +		: "cc", "memory"
> +	);
> +}
> +
> +static void psw_bit_31_32_are_1_0(void)
> +{
> +	uint64_t bad_psw = 0x000800015eadbeef;
> +
> +	//bit 12 gets inverted when extending to 128-bit PSW

I'd prefer a space after the "//"

> +	expected_early_pgm_psw.mask = 0x0000000100000000;
> +	expected_early_pgm_psw.addr = 0x000000005eadbeef;
> +	expect_early = true;
> +	lpsw(bad_psw);
> +}
> +
> +static void bad_alignment(void)
> +{
> +	uint32_t words[5] = {0, 0, 0};
> +	uint32_t (*bad_aligned)[4];
> +
> +	register uint64_t r1 asm("6");
> +	register uint64_t r2 asm("7");
> +	if (((uintptr_t)&words[0]) & 0xf) {
> +		bad_aligned = (uint32_t (*)[4])&words[0];
> +	} else {
> +		bad_aligned = (uint32_t (*)[4])&words[1];
> +	}
> +	asm volatile ("lpq %0,%2"
> +		      : "=r"(r1), "=r"(r2)
> +		      : "T"(*bad_aligned)
> +	);
> +}
> +
> +static void not_even(void)
> +{
> +	uint64_t quad[2];
> +
> +	register uint64_t r1 asm("7");
> +	register uint64_t r2 asm("8");
> +	asm volatile (".insn	rxy,0xe3000000008f,%0,%2" //lpq %0,%2
> +		      : "=r"(r1), "=r"(r2)
> +		      : "T"(quad)
> +	);
> +}
> +
> +struct spec_ex_trigger {
> +	const char *name;
> +	void (*func)(void);
> +	bool transactable;
> +	void (*fixup)(void);
> +};
> +
> +static const struct spec_ex_trigger spec_ex_triggers[] = {
> +	{ "psw_bit_31_32_are_1_0", &psw_bit_31_32_are_1_0, false, &fixup_early_pgm_ex},
> +	{ "bad_alignment", &bad_alignment, true, NULL},
> +	{ "not_even", &not_even, true, NULL},
> +	{ NULL, NULL, true, NULL},
> +};
> +
> +struct args {
> +	uint64_t iterations;
> +	uint64_t max_retries;
> +	uint64_t suppress_info;
> +	uint64_t max_failures;
> +	bool diagnose;
> +};
> +
> +static void test_spec_ex(struct args *args,
> +			 const struct spec_ex_trigger *trigger)
> +{
> +	uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
> +	uint16_t pgm;
> +	unsigned int i;
> +
> +	register_pgm_cleanup_func(trigger->fixup);
> +	for (i = 0; i < args->iterations; i++) {
> +		expect_pgm_int();
> +		trigger->func();
> +		pgm = clear_pgm_int();
> +		if (pgm != expected_pgm) {
> +			report(0,
> +			"Program interrupt: expected(%d) == received(%d)",
> +			expected_pgm,
> +			pgm);
> +			return;
> +		}
> +	}

Maybe it would be nice to "unregister" the cleanup function at the end with 
register_pgm_cleanup_func(NULL) ?

> +	report(1,
> +	"Program interrupt: always expected(%d) == received(%d)",
> +	expected_pgm,
> +	expected_pgm);
> +}
> +
> +#define TRANSACTION_COMPLETED 4
> +#define TRANSACTION_MAX_RETRIES 5
> +
> +static int __attribute__((nonnull))

Not sure whether that attribute makes much sense with a static function? ... 
the compiler has information about the implementation details here, so it 
should be able to see that e.g. trigger must be non-NULL anyway?

> +with_transaction(void (*trigger)(void), struct __htm_tdb *diagnose)
> +{
> +	int cc;
> +
> +	cc = __builtin_tbegin(diagnose);
> +	if (cc == _HTM_TBEGIN_STARTED) {
> +		trigger();
> +		__builtin_tend();
> +		return -TRANSACTION_COMPLETED;
> +	} else {
> +		return -cc;
> +	}
> +}
[...]

  Thomas



