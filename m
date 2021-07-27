Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930753D7510
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 14:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhG0M2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 08:28:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32486 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236121AbhG0M2q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 08:28:46 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16RCF9u9009763;
        Tue, 27 Jul 2021 08:28:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HCdiutwE+gzKGKpeO11foKA+2rwK1cmQhlxUsoRVhr8=;
 b=rVPQI7fxzMtnbSv2NKuOvE6oWpc6Lq/D9ijXl270OEhec4Y52Xc5Y+ks16hlEXUfLblY
 InrRhbKKTrPnuQQiGw5ujqU7dpoPqqUd5FyUm+CtnKjpfWl8U/6uoTwr+EEtH7bS3eJu
 ZZ0bD77oW3a1KPndxLrAdFZbt92sh5DcOiyt1siHPTrigWwJA/6A7JyIP3rQ0ENAS93m
 gsczwL3EwQ0/o4Pzz1/vOWAtSgsRVPmJx4lbR1hJ7nx+hBkq9dm1eXIJqMRVybNzmFOD
 wVIZHEVqzMu9fDdmobuixkrJBaPBxC97wT4jKvYznIyuaGHLbt5NQ8DQV6ru10qummvm lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a2hyt0d4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 08:28:44 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16RCGheY014556;
        Tue, 27 Jul 2021 08:28:44 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a2hyt0d3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 08:28:44 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16RCSgQ0002897;
        Tue, 27 Jul 2021 12:28:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3a235ygdg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 12:28:41 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16RCScJi13697282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 12:28:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F773AE053;
        Tue, 27 Jul 2021 12:28:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0692AE04D;
        Tue, 27 Jul 2021 12:28:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.20.110])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Jul 2021 12:28:37 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Add specification exception test
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210706115459.372749-1-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <1bc12f4d-8a1c-ff9c-5abe-5a85d93c3e24@linux.ibm.com>
Date:   Tue, 27 Jul 2021 14:28:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706115459.372749-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hC0KPT8Z7djZYMHhwr2dZH0_18g4Ob6i
X-Proofpoint-GUID: HaDzkouWZCIhDrCcbHwpSPDAUXOh1exV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_07:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1011
 phishscore=0 priorityscore=1501 malwarescore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/6/21 1:54 PM, Janis Schoetterl-Glausch wrote:
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

Before you send out the next version could you please split up the
transactional and non-transactional code into separate patches?

350 non-trivial lines are a bit much for one patch :)

> ---
>  s390x/Makefile           |   1 +
>  lib/s390x/asm/arch_def.h |   1 +
>  s390x/spec_ex.c          | 344 +++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg      |   3 +
>  4 files changed, 349 insertions(+)
>  create mode 100644 s390x/spec_ex.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 8820e99..be100d3 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -23,6 +23,7 @@ tests += $(TEST_DIR)/sie.elf
>  tests += $(TEST_DIR)/mvpg.elf
>  tests += $(TEST_DIR)/uv-host.elf
>  tests += $(TEST_DIR)/edat.elf
> +tests += $(TEST_DIR)/spec_ex.elf
>  
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  ifneq ($(HOST_KEY_DOCUMENT),)
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 15cf7d4..7cb0b92 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -229,6 +229,7 @@ static inline uint64_t stctg(int cr)
>  	return value;
>  }
>  
> +#define CTL0_TRANSACT_EX_CTL	(63 -  8)
>  #define CTL0_LOW_ADDR_PROT	(63 - 35)
>  #define CTL0_EDAT		(63 - 40)
>  #define CTL0_IEP		(63 - 43)
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> new file mode 100644
> index 0000000..2e05bfb
> --- /dev/null
> +++ b/s390x/spec_ex.c
> @@ -0,0 +1,344 @@
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
> +		"	larl	%0,nop%=\n"
> +		"	stg	%0,%[addr]\n"
> +		"	lpsw	%[psw]\n"
> +		"nop%=:	nop\n"
> +		: "+&r"(r0), "+&a"(r1), [high] "=&R"(*high), [low] "=&R"(*low)
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
> +
> +static int retry_transaction(const struct spec_ex_trigger *trigger, unsigned int max_retries,
> +			     struct __htm_tdb *tdb, uint16_t expected_pgm)
> +{
> +	int trans_result, i;
> +	uint16_t pgm;
> +
> +	for (i = 0; i < max_retries; i++) {
> +		expect_pgm_int();
> +		trans_result = with_transaction(trigger->func, tdb);
> +		if (trans_result == -_HTM_TBEGIN_TRANSIENT) {
> +			mb();
> +			pgm = lc->pgm_int_code;
> +			if (pgm == 0) {
> +				continue;
> +			} else if (pgm == expected_pgm) {
> +				return 0;
> +			}
> +		}
> +		return trans_result;
> +	}
> +	return -TRANSACTION_MAX_RETRIES;
> +}
> +
> +#define report_info_if(cond, fmt, ...)			\
> +	do {						\
> +		if (cond) {				\
> +			report_info(fmt, ##__VA_ARGS__);\
> +		}					\
> +	} while (0)
> +
> +static void test_spec_ex_trans(struct args *args, const struct spec_ex_trigger *trigger)
> +{
> +	const uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION
> +			      | PGM_INT_CODE_TX_ABORTED_EVENT;
> +	union {
> +		struct __htm_tdb tdb;
> +		uint64_t dwords[sizeof(struct __htm_tdb) / sizeof(uint64_t)];
> +	} diag;
> +	unsigned int i, failures = 0;
> +	int trans_result;
> +
> +	if (!test_facility(73)) {
> +		report_skip("transactional-execution facility not installed");
> +		return;
> +	}
> +	ctl_set_bit(0, CTL0_TRANSACT_EX_CTL); /* enable transactional-exec */
> +
> +	register_pgm_cleanup_func(trigger->fixup);
> +	for (i = 0; i < args->iterations && failures <= args->max_failures; i++) {
> +		trans_result = retry_transaction(trigger, args->max_retries, &diag.tdb, expected_pgm);
> +		switch (trans_result) {
> +		case 0:
> +			continue;
> +		case -_HTM_TBEGIN_INDETERMINATE:
> +		case -_HTM_TBEGIN_PERSISTENT:
> +			report_info_if(failures < args->suppress_info,
> +				       "transaction failed with cc %d",
> +				       -trans_result);
> +			break;
> +		case -_HTM_TBEGIN_TRANSIENT:
> +			report(0,
> +			       "Program interrupt: expected(%d) == received(%d)",
> +			       expected_pgm,
> +			       clear_pgm_int());
> +			goto out;
> +		case -TRANSACTION_COMPLETED:
> +			report(0,
> +			       "Transaction completed without exception");
> +			goto out;
> +		case -TRANSACTION_MAX_RETRIES:
> +			report_info_if(failures < args->suppress_info,
> +				       "Retried transaction %u times without exception",
> +				       10);
> +			break;
> +		default:
> +			report(0, "Invalid return transaction result");
> +			goto out;
> +		}
> +
> +		report_info_if(failures < args->suppress_info,
> +			       "transaction abort code: %llu", diag.tdb.abort_code);
> +		if (args->diagnose && failures < args->suppress_info) {
> +			for (i = 0; i < 32; i++) {
> +				report_info("diag+%03d: %016lx", i*8, diag.dwords[i]);
> +			}
> +		}
> +		++failures;
> +	}
> +	if (failures <= args->max_failures) {
> +		report(1,
> +		       "Program interrupt: always expected(%d) == received(%d), transaction failures: %u",
> +		       expected_pgm,
> +		       expected_pgm,
> +		       failures);
> +	} else {
> +		report(0,
> +		       "Too many transaction failures: %u", failures);
> +	}
> +	report_info_if(failures > args->suppress_info,
> +		       "Suppressed some transaction failure information messages");
> +
> +out:
> +	ctl_clear_bit(0, CTL0_TRANSACT_EX_CTL);
> +}
> +
> +static struct args parse_args(int argc, char **argv)
> +{
> +	struct args args = {
> +		.iterations = 1,
> +		.max_retries = 20,
> +		.suppress_info = 20,
> +		.diagnose = false
> +	};
> +	unsigned int i;
> +	long parsed;
> +	bool error, max_failures = false;
> +	char *end;
> +
> +	for (i = 1; i < argc; i++) {
> +		error = true;
> +		if (i < argc - 1) {
> +			error = *argv[i+1] == '\0';
> +			parsed = strtol(argv[i+1], &end, 10);
> +			error |= *end != '\0';
> +			error |= parsed < 0;
> +		}
> +
> +		if (!strcmp("--iterations", argv[i])) {
> +			if (error)
> +				report_abort("--iterations needs a positive parameter");
> +			args.iterations = parsed;
> +			++i;
> +		} else if (!strcmp("--max-retries", argv[i])) {
> +			if (error)
> +				report_abort("--max-retries needs a positive parameter");
> +			args.max_retries = parsed;
> +			++i;
> +		} else if (!strcmp("--suppress-info", argv[i])) {
> +			if (error)
> +				report_abort("--suppress-info needs a positive parameter");
> +			args.suppress_info = parsed;
> +			++i;
> +		} else if (!strcmp("--max-failures", argv[i])) {
> +			if (error)
> +				report_abort("--max-failures needs a positive parameter");
> +			args.max_failures = parsed;
> +			max_failures = true;
> +			++i;
> +		} else if (!strcmp("--diagnose", argv[i])) {
> +			args.diagnose = true;
> +		} else if (!strcmp("--no-diagnose", argv[i])) {
> +			args.diagnose = false;
> +		} else {
> +			report_abort("Unsupported parameter '%s'",
> +				     argv[i]);
> +		}
> +	}
> +
> +	if (!max_failures)
> +		args.max_failures = args.iterations / 1000;
> +
> +	return args;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	unsigned int i;
> +
> +	struct args args = parse_args(argc, argv);
> +
> +	report_prefix_push("specification exception");
> +	for (i = 0; spec_ex_triggers[i].name; i++) {
> +		report_prefix_push(spec_ex_triggers[i].name);
> +		test_spec_ex(&args, &spec_ex_triggers[i]);
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +
> +	report_prefix_push("specification exception during transaction");
> +	for (i = 0; spec_ex_triggers[i].name; i++) {
> +		if (spec_ex_triggers[i].transactable) {
> +			report_prefix_push(spec_ex_triggers[i].name);
> +			test_spec_ex_trans(&args, &spec_ex_triggers[i]);
> +			report_prefix_pop();
> +		}
> +	}
> +	report_prefix_pop();
> +
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index a0ec886..b93aead 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -106,3 +106,6 @@ timeout = 10
>  
>  [edat]
>  file = edat.elf
> +
> +[spec_ex]
> +file = spec_ex.elf
> 
> base-commit: bc6f264386b4cb2cadc8b2492315f3e6e8a801a2
> 

