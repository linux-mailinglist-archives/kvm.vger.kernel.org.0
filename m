Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211959AD27
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 12:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403963AbfHWKbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 06:31:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56766 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390545AbfHWKbB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 06:31:01 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 698921801590;
        Fri, 23 Aug 2019 10:31:01 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-236.ams2.redhat.com [10.36.116.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A23D6377B;
        Fri, 23 Aug 2019 10:30:59 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/4] s390x: Diag288 test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190821104736.1470-1-frankja@linux.ibm.com>
 <20190821104736.1470-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <ac96277b-f2ae-3855-639e-9a4e7273aaba@redhat.com>
Date:   Fri, 23 Aug 2019 12:30:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821104736.1470-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Fri, 23 Aug 2019 10:31:01 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/21/19 12:47 PM, Janosch Frank wrote:
> A small test for the watchdog via diag288.
> 
> Minimum timer value is 15 (seconds) and the only supported action with
> QEMU is restart.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h |   1 +
>  s390x/Makefile           |   1 +
>  s390x/diag288.c          | 131 +++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg      |   4 ++
>  4 files changed, 137 insertions(+)
>  create mode 100644 s390x/diag288.c
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index d2cd727..4bbb428 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -15,6 +15,7 @@ struct psw {
>  	uint64_t	addr;
>  };
>  
> +#define PSW_MASK_EXT			0x0100000000000000UL
>  #define PSW_MASK_DAT			0x0400000000000000UL
>  #define PSW_MASK_PSTATE			0x0001000000000000UL
>  
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 574a9a2..3453373 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -12,6 +12,7 @@ tests += $(TEST_DIR)/vector.elf
>  tests += $(TEST_DIR)/gs.elf
>  tests += $(TEST_DIR)/iep.elf
>  tests += $(TEST_DIR)/cpumodel.elf
> +tests += $(TEST_DIR)/diag288.elf
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  
>  all: directories test_cases test_cases_binary
> diff --git a/s390x/diag288.c b/s390x/diag288.c
> new file mode 100644
> index 0000000..c129b6a
> --- /dev/null
> +++ b/s390x/diag288.c
[...]
> +static void test_specs(void)
> +{
> +	report_prefix_push("specification");
> +
> +	report_prefix_push("uneven");
> +	expect_pgm_int();
> +	asm volatile("diag %r1,%r2,0x288");

Don't you have to use "%%" in that case? ... well, if it also works
without, I don't mind, but in case you respin better play safe:

    asm volatile("diag %%r1,%%r2,0x288");

> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("unsupported action");
> +	expect_pgm_int();
> +	diag288(CODE_INIT, 15, 42);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("unsupported function");
> +	expect_pgm_int();
> +	diag288(42, 15, ACTION_RESTART);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("no init");
> +	expect_pgm_int();
> +	diag288(CODE_CANCEL, 15, ACTION_RESTART);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("min timer");
> +	expect_pgm_int();
> +	diag288(CODE_INIT, 14, ACTION_RESTART);
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
> +	diag288(CODE_INIT, 15, ACTION_RESTART);
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +}
> +
> +static inline void get_tod_clock_ext(char *clk)
> +{
> +	typedef struct { char _[16]; } addrtype;
> +
> +	asm volatile("stcke %0" : "=Q" (*(addrtype *) clk) : : "cc");
> +}
> +
> +static inline unsigned long long get_tod_clock(void)
> +{
> +	char clk[16];
> +
> +	get_tod_clock_ext(clk);
> +	return *((unsigned long long *)&clk[1]);

You could use uint64_t instead of "unsigned long long".

> +}
> +
> +static void test_bite(void)
> +{
> +	unsigned long time;
> +	uint64_t mask;
> +
> +	/* If watchdog doesn't bite, the cpu timer does */
> +	time = get_tod_clock();
> +	time += (uint64_t)(16000 * 1000) << 12;
> +	asm volatile("sckc %0" : : "Q" (time));
> +	ctl_set_bit(0, 11);
> +	mask = extract_psw_mask();
> +	mask |= PSW_MASK_EXT;
> +	load_psw_mask(mask);
> +
> +	/* Arm watchdog */
> +	lc->restart_new_psw.mask = extract_psw_mask() & ~PSW_MASK_EXT;
> +	diag288(CODE_INIT, 15, ACTION_RESTART);
> +	asm volatile("		larl	%r0, 1f\n"
> +		     "		stg	%r0, 424\n"
> +		     "0:	nop\n"
> +		     "		j	0b\n"
> +		     "1:");
> +	report("restart", true);
> +	return;

Superfluous return statement.

> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("diag288");
> +	test_priv();
> +	test_specs();
> +	test_bite();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index db58bad..9dd288a 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -64,3 +64,7 @@ file = iep.elf
>  
>  [cpumodel]
>  file = cpumodel.elf
> +
> +[diag288]
> +file = diag288.elf
> +extra_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
> 

Apart from the cosmetic nits, looks fine to me.

Reviewed-by: Thomas Huth <thuth@redhat.com>
