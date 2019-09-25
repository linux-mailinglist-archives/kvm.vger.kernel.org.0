Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2F2BDEF2
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 15:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406443AbfIYN1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 09:27:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406256AbfIYN1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 09:27:03 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A2C1B10C051A;
        Wed, 25 Sep 2019 13:27:02 +0000 (UTC)
Received: from [10.36.117.14] (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A04C560BF1;
        Wed, 25 Sep 2019 13:27:01 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 6/6] s390x: SMP test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20190920080356.1948-1-frankja@linux.ibm.com>
 <20190920080356.1948-7-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <b8b574a0-aa5d-7a10-ccd3-d901bf2e0655@redhat.com>
Date:   Wed, 25 Sep 2019 15:27:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920080356.1948-7-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Wed, 25 Sep 2019 13:27:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.09.19 10:03, Janosch Frank wrote:
> Testing SIGP emulation for the following order codes:
> * start
> * stop
> * restart
> * set prefix
> * store status
> * stop and store status
> * reset
> * initial reset
> * external call
> * emegergency call
> 
> restart and set prefix are part of the library and needed to start
> other cpus.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/smp.c         | 242 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   4 +
>  3 files changed, 247 insertions(+)
>  create mode 100644 s390x/smp.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index d83dd0b..3744372 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -15,6 +15,7 @@ tests += $(TEST_DIR)/cpumodel.elf
>  tests += $(TEST_DIR)/diag288.elf
>  tests += $(TEST_DIR)/stsi.elf
>  tests += $(TEST_DIR)/skrf.elf
> +tests += $(TEST_DIR)/smp.elf
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  
>  all: directories test_cases test_cases_binary
> diff --git a/s390x/smp.c b/s390x/smp.c
> new file mode 100644
> index 0000000..7032494
> --- /dev/null
> +++ b/s390x/smp.c
> @@ -0,0 +1,242 @@
> +/*
> + * Tests sigp emulation
> + *
> + * Copyright 2019 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
> +#include <libcflat.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/page.h>
> +#include <asm/facility.h>
> +#include <asm-generic/barrier.h>
> +#include <asm/sigp.h>
> +
> +#include <smp.h>
> +#include <alloc_page.h>
> +
> +static int testflag = 0;
> +
> +static void cpu_loop(void)
> +{
> +	for (;;) {}

Won't that be optimized out completely?

> +}
> +
> +static void test_func(void)
> +{
> +	testflag = 1;
> +	mb();
> +	cpu_loop();
> +}
> +
> +static void test_start(void)
> +{
> +	struct psw psw;
> +	psw.mask =  extract_psw_mask();
> +	psw.addr = (unsigned long)test_func;
> +
> +	smp_cpu_setup(1, psw);
> +	while (!testflag) {
> +		mb();
> +	}
> +	report("start", 1);
> +}
> +
> +static void test_stop(void)
> +{
> +	smp_cpu_stop(1);
> +	/*
> +	 * The smp library waits for the CPU to shut down, but let's
> +	 * also do it here, so we don't rely on the library
> +	 * implementation
> +	 */
> +	while (!smp_cpu_stopped(1)) {}
> +	report("stop", 1);
> +}
> +
> +static void test_stop_store_status(void)
> +{
> +	struct cpu *cpu = smp_cpu_from_addr(1);
> +	struct lowcore *lc = (void *)0x0;
> +
> +	report_prefix_push("stop store status");
> +	lc->prefix_sa = 0;
> +	lc->grs_sa[15] = 0;
> +	smp_cpu_stop_store_status(1);
> +	mb();
> +	report("prefix", lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore);
> +	report("stack", lc->grs_sa[15]);
> +	report_prefix_pop();
> +}
> +
> +static void test_store_status(void)
> +{
> +	struct cpu_status *status = alloc_pages(1);
> +	uint32_t r;
> +
> +	report_prefix_push("store status at address");
> +	memset(status, 0, PAGE_SIZE * 2);
> +
> +	report_prefix_push("running");
> +	smp_cpu_restart(1);
> +	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, &r);
> +	report("incorrect state", r == SIGP_STATUS_INCORRECT_STATE);
> +	report("status not written", !memcmp(status, (void*)status + PAGE_SIZE, PAGE_SIZE));
> +	report_prefix_pop();
> +
> +	memset(status, 0, PAGE_SIZE);
> +	report_prefix_push("stopped");
> +	smp_cpu_stop(1);
> +	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
> +	while (!status->prefix) { mb(); }
> +	report("status written", 1);
> +	free_pages(status, PAGE_SIZE * 2);
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}
> +
> +static void ecall(void)
> +{
> +	unsigned long mask;
> +	struct lowcore *lc = (void *)0x0;
> +
> +	expect_ext_int();
> +	ctl_set_bit(0, 13);
> +	mask = extract_psw_mask();
> +	mask |= PSW_MASK_EXT;
> +	load_psw_mask(mask);
> +	testflag = 1;
> +	while (lc->ext_int_code != 0x1202) { mb(); }
> +	report("ecall", 1);
> +	testflag= 1;
> +}
> +
> +static void test_ecall(void)
> +{
> +	struct psw psw;
> +	psw.mask =  extract_psw_mask();
> +	psw.addr = (unsigned long)ecall;
> +
> +	report_prefix_push("ecall");
> +	testflag= 0;
> +	smp_cpu_destroy(1);
> +
> +	smp_cpu_setup(1, psw);
> +	while (!testflag) { mb(); }
> +	testflag= 0;
> +	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
> +	while(!testflag) {mb();}
> +	smp_cpu_stop(1);
> +	report_prefix_pop();
> +}
> +
> +static void emcall(void)
> +{
> +	unsigned long mask;
> +	struct lowcore *lc = (void *)0x0;
> +
> +	expect_ext_int();
> +	ctl_set_bit(0, 14);
> +	mask = extract_psw_mask();
> +	mask |= PSW_MASK_EXT;
> +	load_psw_mask(mask);
> +	testflag= 1;
> +	while (lc->ext_int_code != 0x1201) { mb(); }
> +	report("ecall", 1);
> +	testflag = 1;
> +}
> +
> +static void test_emcall(void)
> +{
> +	struct psw psw;
> +	psw.mask =  extract_psw_mask();
> +	psw.addr = (unsigned long)emcall;
> +
> +	report_prefix_push("emcall");
> +	testflag= 0;
> +	smp_cpu_destroy(1);
> +
> +	smp_cpu_setup(1, psw);
> +	while (!testflag) { mb(); }
> +	testflag= 0;
> +	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
> +	while(!testflag) { mb(); }
> +	smp_cpu_stop(1);
> +	report_prefix_pop();
> +}
> +
> +static void test_reset_initial(void)
> +{
> +	struct cpu_status *status = alloc_pages(0);
> +	struct psw psw;
> +
> +	psw.mask =  extract_psw_mask();
> +	psw.addr = (unsigned long)test_func;
> +
> +	report_prefix_push("reset initial");
> +	smp_cpu_setup(1, psw);
> +
> +	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
> +	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
> +
> +	report_prefix_push("clear");
> +	report("psw", !status->psw.mask && !status->psw.addr);
> +	report("prefix", !status->prefix);
> +	report("fpc", !status->fpc);
> +	report("cpu timer", !status->cputm);
> +	report("todpr", !status->todpr);
> +	report_prefix_pop();
> +
> +	report_prefix_push("initialized");
> +	report("cr0 == 0xE0", status->crs[0] == 0xE0UL);
> +	report("cr14 == 0xC2000000", status->crs[14] == 0xC2000000UL);
> +	report_prefix_pop();
> +
> +	report("cpu stopped", smp_cpu_stopped(1));
> +	free_pages(status, PAGE_SIZE);
> +	report_prefix_pop();
> +}
> +
> +static void test_reset(void)
> +{
> +	struct psw psw;
> +
> +	psw.mask =  extract_psw_mask();
> +	psw.addr = (unsigned long)test_func;
> +
> +	report_prefix_push("cpu reset");
> +	smp_cpu_setup(1, psw);
> +
> +	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
> +	report("cpu stopped", smp_cpu_stopped(1));
> +	report_prefix_pop();
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("smp");
> +
> +	if (smp_query_num_cpus() == 1) {
> +		report_abort("need at least 2 cpus for this test");
> +		goto done;
> +	}
> +
> +	test_start();
> +	test_stop();
> +	test_stop_store_status();
> +	test_store_status();
> +	test_ecall();
> +	test_emcall();
> +	test_reset();
> +	test_reset_initial();
> +
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index cc79a4e..f1b07cd 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -71,3 +71,7 @@ extra_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
>  
>  [stsi]
>  file = stsi.elf
> +
> +[smp]
> +file = smp.elf
> +extra_params =-smp 2
> 


-- 

Thanks,

David / dhildenb
