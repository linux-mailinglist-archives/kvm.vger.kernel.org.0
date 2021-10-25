Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C468439D9D
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 19:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhJYRdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 13:33:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231220AbhJYRdC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 13:33:02 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PHIDlS006427;
        Mon, 25 Oct 2021 17:30:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4vjo791HT9YOBZMCd63KusLtp4nxc2sEGUysFHt82U0=;
 b=CdLvFr3OlCdgG/DTlhVTL2AAg2jw1v07HkINNJzGiI6COw+Ix2Xwpnh9VHBMakzU4JNy
 PNrdRkNA86OcEDX+eSFkKQ5Rae1G8p2j8EhVKQPNUR+bJEB3q8bIXUn5gDNEjbVwKKlJ
 8kpq8cbKIJMaYuBraCM5ryahQ/7DtCrByW2GSBIaNWzN03E7fnOUgXj4VZ05x+vA5wGc
 VLrohpmgf/Lzq+ujXEIR3N/j3WpAJOT4zmpamOo/F0M3Ed9mf8iZc7I/1CNhPI/m1SWY
 VtJu3JqVy/j5qjQDWEFdc/c9CWzrk7KsxIRMyVlxI1DIhpIh878L1t2j6RGEGl8ZEN7Q iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bwt36v89g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 17:30:39 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19PHLRRf017787;
        Mon, 25 Oct 2021 17:30:38 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bwt36v88s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 17:30:38 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19PHSo4C026282;
        Mon, 25 Oct 2021 17:30:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3bv9njh8pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 17:30:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19PHUXS362587174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 17:30:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60DC811C052;
        Mon, 25 Oct 2021 17:30:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B18011C069;
        Mon, 25 Oct 2021 17:30:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.93])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 17:30:32 +0000 (GMT)
Date:   Mon, 25 Oct 2021 19:30:12 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 2/2] s390x: Test specification
 exceptions during transaction
Message-ID: <20211025193012.3be31938@p-imbrenda>
In-Reply-To: <20211022120156.281567-3-scgl@linux.ibm.com>
References: <20211022120156.281567-1-scgl@linux.ibm.com>
        <20211022120156.281567-3-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4NnW6SZ3BvROMq_y3msqjGZpmLGYIFcT
X-Proofpoint-GUID: O9iBYCYZifwgVhsGpiE8uh_tTyrrjOkR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_06,2021-10-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 spamscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Oct 2021 14:01:56 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Program interruptions during transactional execution cause other
> interruption codes.
> Check that we see the expected code for (some) specification exceptions.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h |   1 +
>  s390x/spec_ex.c          | 172 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 168 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 40626d7..f7fb467 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -55,6 +55,7 @@ struct psw {
>  #define PSW_MASK_BA			0x0000000080000000UL
>  #define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
>  
> +#define CTL0_TRANSACT_EX_CTL		(63 -  8)
>  #define CTL0_LOW_ADDR_PROT		(63 - 35)
>  #define CTL0_EDAT			(63 - 40)
>  #define CTL0_IEP			(63 - 43)
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index ec3322a..f3628bd 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -4,9 +4,14 @@
>   *
>   * Specification exception test.
>   * Tests that specification exceptions occur when expected.
> + * This includes specification exceptions occurring during transactional execution
> + * as these result in another interruption code (the transactional-execution-aborted
> + * bit is set).
>   */
>  #include <stdlib.h>
> +#include <htmintrin.h>
>  #include <libcflat.h>
> +#include <asm/barrier.h>
>  #include <asm/interrupt.h>
>  #include <asm/facility.h>
>  
> @@ -92,18 +97,23 @@ static void not_even(void)
>  struct spec_ex_trigger {
>  	const char *name;
>  	void (*func)(void);
> +	bool transactable;
>  	void (*fixup)(void);
>  };
>  
>  static const struct spec_ex_trigger spec_ex_triggers[] = {
> -	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw},
> -	{ "bad_alignment", &bad_alignment, NULL},
> -	{ "not_even", &not_even, NULL},
> -	{ NULL, NULL, NULL},
> +	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw},
> +	{ "bad_alignment", &bad_alignment, true, NULL},
> +	{ "not_even", &not_even, true, NULL},
> +	{ NULL, NULL, true, NULL},
>  };
>  
>  struct args {
>  	uint64_t iterations;
> +	uint64_t max_retries;
> +	uint64_t suppress_info;
> +	uint64_t max_failures;
> +	bool diagnose;
>  };
>  
>  static void test_spec_ex(struct args *args,
> @@ -131,14 +141,132 @@ static void test_spec_ex(struct args *args,
>  		    expected_pgm);
>  }
>  
> +#define TRANSACTION_COMPLETED 4
> +#define TRANSACTION_MAX_RETRIES 5
> +
> +/* NULL must be passed to __builtin_tbegin via constant, forbid diagnose from
> + * being NULL to keep things simple
> + */
> +static int __attribute__((nonnull))
> +with_transaction(void (*trigger)(void), struct __htm_tdb *diagnose)
> +{
> +	int cc;
> +

if you want to be extra sure, put an assert here (although I'm not sure
how nonnull works, I have never seen it before)

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
> +			if (pgm == 0)
> +				continue;
> +			else if (pgm == expected_pgm)
> +				return 0;
> +		}
> +		return trans_result;
> +	}
> +	return -TRANSACTION_MAX_RETRIES;

so this means that a test will be considered failed if the transaction
failed too many times?

this means that could fail if the test is run on busy system, even if
the host running the unit test is correct

also, do you really need to use negative values? it's probably easier
to read if you stick to positive values, and less prone to mistakes if
you accidentally forget a - somewhere.

> +}
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
> +	for (i = 0; i < args->iterations && failures <= args->max_failures; i++) {
> +		register_pgm_cleanup_func(trigger->fixup);
> +		trans_result = retry_transaction(trigger, args->max_retries, &diag.tdb, expected_pgm);

so you retry each iteration up to args->max_retries times, and if a
transaction aborts too many times (maybe because the host system is
very busy), then you consider it a fail

> +		register_pgm_cleanup_func(NULL);
> +		switch (trans_result) {
> +		case 0:
> +			continue;
> +		case -_HTM_TBEGIN_INDETERMINATE:
> +		case -_HTM_TBEGIN_PERSISTENT:
> +			if (failures < args->suppress_info)
> +				report_info("transaction failed with cc %d",
> +					    -trans_result);
> +			break;
> +		case -_HTM_TBEGIN_TRANSIENT:
> +			report_fail("Program interrupt: expected(%d) == received(%d)",
> +				    expected_pgm,
> +				    clear_pgm_int());
> +			goto out;
> +		case -TRANSACTION_COMPLETED:
> +			report_fail("Transaction completed without exception");
> +			goto out;
> +		case -TRANSACTION_MAX_RETRIES:
> +			if (failures < args->suppress_info)
> +				report_info("Retried transaction %lu times without exception",
> +					    args->max_retries);
> +			break;
> +		default:
> +			report_fail("Invalid return transaction result");
> +			goto out;
> +		}
> +
> +		if (failures < args->suppress_info)
> +			report_info("transaction abort code: %llu", diag.tdb.abort_code);
> +		if (args->diagnose && failures < args->suppress_info) {
> +			for (i = 0; i < 32; i++)
> +				report_info("diag+%03d: %016lx", i*8, diag.dwords[i]);
> +		}
> +		++failures;
> +	}
> +	if (failures <= args->max_failures) {
> +		report_pass(
> +			"Program interrupt: always expected(%d) == received(%d), transaction failures: %u",
> +			expected_pgm,
> +			expected_pgm,
> +			failures);
> +	} else {
> +		report_fail("Too many transaction failures: %u", failures);
> +	}
> +	if (failures > args->suppress_info)
> +		report_info("Suppressed some transaction failure information messages");
> +
> +out:
> +	ctl_clear_bit(0, CTL0_TRANSACT_EX_CTL);
> +}
> +
>  static struct args parse_args(int argc, char **argv)
>  {
>  	struct args args = {
>  		.iterations = 1,
> +		.max_retries = 20,
> +		.suppress_info = 20,
> +		.diagnose = false
>  	};
>  	unsigned int i;
>  	long arg;
> -	bool no_arg;
> +	bool no_arg, max_failures = false;
>  	char *end;
>  
>  	for (i = 1; i < argc; i++) {
> @@ -155,11 +283,35 @@ static struct args parse_args(int argc, char **argv)

again, do we _really_ need all these parameters?

>  				report_abort("--iterations needs a positive parameter");
>  			args.iterations = arg;
>  			++i;
> +		} else if (!strcmp("--max-retries", argv[i])) {
> +			if (no_arg)
> +				report_abort("--max-retries needs a positive parameter");
> +			args.max_retries = arg;
> +			++i;
> +		} else if (!strcmp("--suppress-info", argv[i])) {
> +			if (no_arg)
> +				report_abort("--suppress-info needs a positive parameter");
> +			args.suppress_info = arg;
> +			++i;
> +		} else if (!strcmp("--max-failures", argv[i])) {
> +			if (no_arg)
> +				report_abort("--max-failures needs a positive parameter");
> +			args.max_failures = arg;
> +			max_failures = true;
> +			++i;
> +		} else if (!strcmp("--diagnose", argv[i])) {
> +			args.diagnose = true;
> +		} else if (!strcmp("--no-diagnose", argv[i])) {
> +			args.diagnose = false;
>  		} else {
>  			report_abort("Unsupported parameter '%s'",
>  				     argv[i]);
>  		}
>  	}
> +
> +	if (!max_failures)
> +		args.max_failures = args.iterations / 1000;
> +
>  	return args;
>  }
>  
> @@ -177,5 +329,15 @@ int main(int argc, char **argv)
>  	}
>  	report_prefix_pop();
>  
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
>  	return report_summary();
>  }

