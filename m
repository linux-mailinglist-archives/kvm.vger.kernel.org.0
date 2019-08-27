Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79F59F1F2
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 19:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfH0R6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 13:58:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727683AbfH0R6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 13:58:49 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0DC8830821C2;
        Tue, 27 Aug 2019 17:58:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-79.ams2.redhat.com [10.36.116.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F42355D6B0;
        Tue, 27 Aug 2019 17:58:41 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Add storage key removal
 facility
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190827134936.1705-1-frankja@linux.ibm.com>
 <20190827134936.1705-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <ea6d114c-9025-2e15-89b8-52b938efc129@redhat.com>
Date:   Tue, 27 Aug 2019 19:58:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827134936.1705-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 27 Aug 2019 17:58:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/2019 15.49, Janosch Frank wrote:
> The storage key removal facility (stfle bit 169) makes all key related
> instructions result in a special operation exception if they handle a
> key.
> 
> Let's make sure that the skey and pfmf tests only run non key code
> (pfmf) or not at all (skey).
> 
> Also let's test this new facility. As lots of instructions are
> affected by this, only some of them are tested for now.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile |   1 +
>  s390x/pfmf.c   |  10 ++++
>  s390x/skey.c   |   5 ++
>  s390x/skrf.c   | 130 +++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 146 insertions(+)
>  create mode 100644 s390x/skrf.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 76db0bb..007611e 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -14,6 +14,7 @@ tests += $(TEST_DIR)/iep.elf
>  tests += $(TEST_DIR)/cpumodel.elf
>  tests += $(TEST_DIR)/diag288.elf
>  tests += $(TEST_DIR)/stsi.elf
> +tests += $(TEST_DIR)/skrf.elf
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  
>  all: directories test_cases test_cases_binary
> diff --git a/s390x/pfmf.c b/s390x/pfmf.c
> index 2840cf5..78b4a73 100644
> --- a/s390x/pfmf.c
> +++ b/s390x/pfmf.c
> @@ -34,6 +34,10 @@ static void test_4k_key(void)
>  	union skey skey;
>  
>  	report_prefix_push("4K");
> +	if (test_facility(169)) {
> +		report_skip("storage key removal facility is active");
> +		goto out;
> +	}
>  	r1.val = 0;
>  	r1.reg.sk = 1;
>  	r1.reg.fsc = PFMF_FSC_4K;
> @@ -42,6 +46,7 @@ static void test_4k_key(void)
>  	skey.val = get_storage_key(pagebuf);
>  	skey.val &= SKEY_ACC | SKEY_FP;
>  	report("set storage keys", skey.val == 0x30);
> +out:
>  	report_prefix_pop();
>  }
>  
> @@ -54,6 +59,10 @@ static void test_1m_key(void)
>  	void *addr = pagebuf;
>  
>  	report_prefix_push("1M");
> +	if (test_facility(169)) {
> +		report_skip("storage key removal facility is active");
> +		goto out;
> +	}
>  	r1.val = 0;
>  	r1.reg.sk = 1;
>  	r1.reg.fsc = PFMF_FSC_1M;
> @@ -70,6 +79,7 @@ static void test_1m_key(void)
>  		}
>  	}
>  	report("set storage keys", rp);
> +out:
>  	report_prefix_pop();
>  }
>  
> diff --git a/s390x/skey.c b/s390x/skey.c
> index efc4eca..5020e99 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -126,10 +126,15 @@ static void test_priv(void)
>  int main(void)
>  {
>  	report_prefix_push("skey");
> +	if (test_facility(169)) {
> +		report_skip("storage key removal facility is active");
> +		goto done;
> +	}
>  	test_priv();
>  	test_set();
>  	test_set_mb();
>  	test_chg();
> +done:
>  	report_prefix_pop();
>  	return report_summary();
>  }
> diff --git a/s390x/skrf.c b/s390x/skrf.c
> new file mode 100644
> index 0000000..8e5baea
> --- /dev/null
> +++ b/s390x/skrf.c
> @@ -0,0 +1,130 @@
> +/*
> + * Storage key removal facility tests
> + *
> + * Copyright (c) 2019 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
> +#include <libcflat.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/page.h>
> +#include <asm/facility.h>
> +#include <asm/mem.h>
> +
> +static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
> +
> +static void test_facilities(void)
> +{
> +	report_prefix_push("facilities");
> +	report("!10", !test_facility(10));
> +	report("!14", !test_facility(14));
> +	report("!66", !test_facility(66));
> +	report("!145", !test_facility(145));
> +	report("!149", !test_facility(140));
> +	report_prefix_pop();
> +}
> +
> +static void test_skey(void)
> +{
> +	report_prefix_push("(i|s)ske");
> +	expect_pgm_int();
> +	set_storage_key(pagebuf, 0x30, 0);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
> +	expect_pgm_int();
> +	get_storage_key(pagebuf);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
> +	report_prefix_pop();

Wouldn't it be better to have distinct prefixes for the two tests?

> +}
> +
> +static void test_pfmf(void)
> +{
> +	union pfmf_r1 r1;
> +
> +	report_prefix_push("pfmf");
> +	r1.val = 0;
> +	r1.reg.sk = 1;
> +	r1.reg.fsc = PFMF_FSC_4K;
> +	r1.reg.key = 0x30;
> +	expect_pgm_int();
> +	pfmf(r1.val, pagebuf);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
> +	report_prefix_pop();
> +}
> +
> +static void test_psw_key(void)
> +{
> +	uint64_t psw_mask = extract_psw_mask() | 0xF0000000000000UL;
> +
> +	report_prefix_push("psw key");
> +	expect_pgm_int();
> +	load_psw_mask(psw_mask);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
> +	report_prefix_pop();
> +}
> +
> +static void test_mvcos(void)
> +{
> +	uint64_t r3 = 64;
> +	uint8_t *src = pagebuf;
> +	uint8_t *dst = pagebuf + PAGE_SIZE;
> +	/* K bit set, as well as keys */
> +	register unsigned long oac asm("0") = 0xf002f002;
> +
> +	report_prefix_push("mvcos");
> +	expect_pgm_int();
> +	asm volatile(".machine \"z10\"\n"
> +		     ".machine \"push\"\n"

Shouldn't that be the other way round? first push the current one, then
set the new one?

Anyway, I've now also checked this patch in the CI:

diff a/s390x/Makefile b/s390x/Makefile
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -25,7 +25,7 @@ CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/s390x -I lib
 CFLAGS += -O2
-CFLAGS += -march=z900
+CFLAGS += -march=z10
 CFLAGS += -fno-delete-null-pointer-checks
 LDFLAGS += -nostdlib -Wl,--build-id=none

... and it also seems to work fine with the TCG there:

https://gitlab.com/huth/kvm-unit-tests/-/jobs/281450598

So I think you can simply change it in the Makefile instead.

 Thomas

> +		     "mvcos	%[dst],%[src],%[len]\n"
> +		     ".machine \"pop\"\n"
> +		     : [dst] "+Q" (*(dst))
> +		     : [src] "Q" (*(src)), [len] "d" (r3), "d" (oac)
> +		     : "cc", "memory");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
> +	report_prefix_pop();
> +}
