Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828F095FE3
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 15:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbfHTNVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 09:21:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729639AbfHTNVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 09:21:48 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F29FC10F23E0;
        Tue, 20 Aug 2019 13:21:47 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-232.ams2.redhat.com [10.36.116.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A10203DA5;
        Tue, 20 Aug 2019 13:21:43 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: STSI tests
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190820105550.4991-1-frankja@linux.ibm.com>
 <20190820105550.4991-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <ef4faf31-e9db-f984-94ec-f3c332823b6f@redhat.com>
Date:   Tue, 20 Aug 2019 15:21:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820105550.4991-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 20 Aug 2019 13:21:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/20/19 12:55 PM, Janosch Frank wrote:
> For now let's concentrate on the error conditions.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/stsi.c        | 123 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   5 +-
>  3 files changed, 128 insertions(+), 1 deletion(-)
>  create mode 100644 s390x/stsi.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index b654c56..311ab77 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -12,6 +12,7 @@ tests += $(TEST_DIR)/vector.elf
>  tests += $(TEST_DIR)/gs.elf
>  tests += $(TEST_DIR)/iep.elf
>  tests += $(TEST_DIR)/diag288.elf
> +tests += $(TEST_DIR)/stsi.elf
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  
>  all: directories test_cases test_cases_binary
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> new file mode 100644
> index 0000000..005f337
> --- /dev/null
> +++ b/s390x/stsi.c
> @@ -0,0 +1,123 @@
> +/*
> + * Store System Information tests
> + *
> + * Copyright (c) 2019 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU Library General Public License version 2.
> + */
> +
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +
> +static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
> +
> +static inline unsigned long stsi(unsigned long *addr,
> +				 unsigned long fc, uint8_t sel1, uint8_t sel2)

Return code should be "int", not "long".

I'd also suggest to use "void *addr" instead of "unsigned long *addr",
then you don't have to cast the pagebuf when you're calling this function.

> +{
> +	register unsigned long r0 asm("0") = (fc << 28) | sel1;
> +	register unsigned long r1 asm("1") = sel2;
> +	int cc;
> +
> +	asm volatile("stsi	0(%3)\n"
> +		     "ipm	 %[cc]\n"
> +		     "srl	 %[cc],28\n"
> +		     : "+d" (r0), [cc] "=d" (cc)
> +		     : "d" (r1), "a" (addr)
> +		     : "cc", "memory");
> +	return cc;
> +}

Bonus points for putting that function into a header and re-use it in
skey.c (maybe in a separate patch, though).

> +static inline void stsi_zero_r0(unsigned long *addr,
> +				unsigned long fc, uint8_t sel1, uint8_t sel2)
> +{
> +	register unsigned long r0 asm("0") = (fc << 28) | (1 << 8) | sel1;
> +	register unsigned long r1 asm("1") = sel2;
> +
> +

Please remove one empty line.

> +	asm volatile("stsi	0(%2)"
> +		     : "+d" (r0)
> +		     : "d" (r1), "a" (addr)
> +		     : "cc", "memory");
> +}
> +
> +static inline void stsi_zero_r1(unsigned long *addr,
> +				unsigned long fc, uint8_t sel1, uint8_t sel2)
> +{
> +	register unsigned long r0 asm("0") = (fc << 28) | sel1;
> +	register unsigned long r1 asm("1") = (1 << 16) | sel2;
> +
> +

dito

> +	asm volatile("stsi	0(%2)"
> +		     : "+d" (r0)
> +		     : "d" (r1), "a" (addr)
> +		     : "cc", "memory");
> +}

Also not sure whether you need separate functions for these tests ...
you could also change the type of sel1 and sel2  from "uint8_t" to "int"
in the stsi() function and then pass the invalid types to that function
instead?

> +static inline unsigned long stsi_get_fc(unsigned long *addr)
> +{
> +	register unsigned long r0 asm("0") = 0;
> +	register unsigned long r1 asm("1") = 0;
> +
> +

Superfluous empty line again.

> +	asm volatile("stsi	0(%2)"
> +		     : "+d" (r0)
> +		     : "d" (r1), "a" (addr)
> +		     : "cc", "memory");

Maybe assert that the CC is 0 after the call?

> +	return r0 >> 28;
> +}
> +
> +static void test_specs(void)
> +{
> +	report_prefix_push("spec ex");

s/spec ex/specification/ please

> +	report_prefix_push("inv r0");
> +	expect_pgm_int();
> +	stsi_zero_r0((void *)pagebuf, 1, 0, 0);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("inv r1");
> +	expect_pgm_int();
> +	stsi_zero_r1((void *)pagebuf, 1, 0, 0);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("unaligned");
> +	expect_pgm_int();
> +	stsi((void *)pagebuf + 42, 1, 0, 0);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}
> +
> +static void test_priv(void)
> +{
> +	report_prefix_push("privileged");
> +	expect_pgm_int();
> +	enter_pstate();
> +	stsi((void *)pagebuf, 0, 0, 0);
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +}
> +
> +static void test_fc(void)
> +{
> +	report("cc == 3", stsi((void *)pagebuf, 7, 0, 0));

Shouldn't that line look like this instead:

    	report("cc == 3", stsi((void *)pagebuf, 7, 0, 0) == 3);

?

> +	report("r0 == 3", stsi_get_fc((void *)pagebuf));

    report("r0 >= 3", stsi_get_fc((void *)pagebuf) >= 3);

?

> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("stsi");
> +	test_priv();
> +	test_specs();
> +	test_fc();
> +	return report_summary();
> +}

How about adding another test for access exceptions? Activate low
address protection, then store to address 4096 ... and/or check
"stsi((void *)-0xdeadadd, 1, 0, 0);" ?

 Thomas
