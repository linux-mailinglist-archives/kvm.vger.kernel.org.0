Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA8848D75F
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 13:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbiAMMVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 07:21:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10432 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231790AbiAMMVD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 07:21:03 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DBR2gx002239;
        Thu, 13 Jan 2022 12:21:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=qaqe1fM0InWRski0CtNdg29zJYX39IgyxVroyHI1n/8=;
 b=AJcsMYsAznCsvQDvx/3G1+KGVDvi4qWVzoKPwltmsjyqW2fU56SIQqLz2hVCLPijs0xH
 6fv/Ch1YB3eiCjv+0Oj3bTpEDKclp7dIoPzrUuRkhGpg9cBuhdJIThnfBpLt8zvXW29v
 47vZRekKXyfI5V8ln0SpZyQ1cWzkTQ2QOC/XCS/hEppdZNCDw4mvkU73pX9qu1WxJqZ0
 OImUbpFmUoCoGd84fjWOqTJkHb8gQi58go67Bzwc0slGEWFZrtLI58ReNLtd1ZCxuxMk
 cHCTq3WWVut/qj+IHJbos8l3exaIxFPCreJB/EESDhspyMN142RslV6fDvhxWFJQXBK/ 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djk7d8yde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:21:02 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DCARck027917;
        Thu, 13 Jan 2022 12:21:02 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djk7d8ycr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:21:02 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DCDMkn019754;
        Thu, 13 Jan 2022 12:21:00 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3df289t5eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:21:00 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DCKuZa35127718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 12:20:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9315CA4059;
        Thu, 13 Jan 2022 12:20:56 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B5A7A405D;
        Thu, 13 Jan 2022 12:20:56 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.156])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 12:20:55 +0000 (GMT)
Date:   Thu, 13 Jan 2022 13:20:47 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 2/2] s390x: Test specification
 exceptions during transaction
Message-ID: <20220113132047.68edce5e@p-imbrenda>
In-Reply-To: <20220111163901.1263736-3-scgl@linux.ibm.com>
References: <20220111163901.1263736-1-scgl@linux.ibm.com>
        <20220111163901.1263736-3-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 28T2uqA0-SRcFNKosa6nXUym6hljZcz8
X-Proofpoint-ORIG-GUID: n8h8dP0LXZpM632IAVVKS_wcpmFpSJVb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_04,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jan 2022 17:39:01 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Program interruptions during transactional execution cause other
> interruption codes.
> Check that we see the expected code for (some) specification exceptions.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
> I don't think we can use constraint transactions to guarantee successful
> execution of the transaction unless we implement it completely in asm,
> otherwise we cannot ensure that the constraints of the transaction are met.
> 
>  lib/s390x/asm/arch_def.h |   1 +
>  s390x/spec_ex.c          | 177 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 174 insertions(+), 4 deletions(-)
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
> index a9f9f31..e599994 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -4,12 +4,18 @@
>   *
>   * Specification exception test.
>   * Tests that specification exceptions occur when expected.
> + * This includes specification exceptions occurring during transactional execution
> + * as these result in another interruption code (the transactional-execution-aborted
> + * bit is set).
>   *
>   * Can be extended by adding triggers to spec_ex_triggers, see comments below.
>   */
>  #include <stdlib.h>
> +#include <htmintrin.h>

where is this header ?

>  #include <libcflat.h>
> +#include <asm/barrier.h>
>  #include <asm/interrupt.h>
> +#include <asm/facility.h>
>  
>  static struct lowcore *lc = (struct lowcore *) 0;
>  
> @@ -106,19 +112,21 @@ static int not_even(void)
>  /*
>   * Harness for specification exception testing.
>   * func only triggers exception, reporting is taken care of automatically.
> + * If a trigger is transactable it will also  be executed during a transaction.
>   */
>  struct spec_ex_trigger {
>  	const char *name;
>  	int (*func)(void);
> +	bool transactable;
>  	void (*fixup)(void);
>  };
>  
>  /* List of all tests to execute */
>  static const struct spec_ex_trigger spec_ex_triggers[] = {
> -	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw },
> -	{ "bad_alignment", &bad_alignment, NULL },
> -	{ "not_even", &not_even, NULL },
> -	{ NULL, NULL, NULL },
> +	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
> +	{ "bad_alignment", &bad_alignment, true, NULL },
> +	{ "not_even", &not_even, true, NULL },
> +	{ NULL, NULL, false, NULL },
>  };
>  
>  static void test_spec_ex(const struct spec_ex_trigger *trigger)
> @@ -138,10 +146,161 @@ static void test_spec_ex(const struct spec_ex_trigger *trigger)
>  	       expected_pgm, pgm);
>  }
>  
> +#define TRANSACTION_COMPLETED 4
> +#define TRANSACTION_MAX_RETRIES 5
> +
> +/* NULL must be passed to __builtin_tbegin via constant, forbid diagnose from
> + * being NULL to keep things simple
> + */
> +static int __attribute__((nonnull))
> +with_transaction(int (*trigger)(void), struct __htm_tdb *diagnose)
> +{
> +	int cc;
> +
> +	cc = __builtin_tbegin(diagnose);

this is __really__ hard to understand if you don't know exactly how
transactions work. I would like to see some comments explaining what's
going on and why

> +	if (cc == _HTM_TBEGIN_STARTED) {
> +		/* return code is meaningless: transaction needs to complete

please, in a multi-line comment, leave the first line empty, like this:

/*
 * first line
 * another line
 * last line
 */

> +		 * in order to return and completion indicates a test failure
> +		 */
> +		trigger();
> +		__builtin_tend();
> +		return TRANSACTION_COMPLETED;
> +	} else {
> +		return cc;
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
> +		if (trans_result == _HTM_TBEGIN_TRANSIENT) {
> +			mb();
> +			pgm = lc->pgm_int_code;
> +			if (pgm == 0)

add a comment to explain why we try again with pgm == 0 .

> +				continue;
> +			else if (pgm == expected_pgm)
> +				return 0;
> +		}
> +		return trans_result;
> +	}
> +	return TRANSACTION_MAX_RETRIES;
> +}
> +
> +struct args {
> +	uint64_t max_retries;
> +	bool diagnose;
> +};
> +
> +static void test_spec_ex_trans(struct args *args, const struct spec_ex_trigger *trigger)
> +{
> +	const uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION
> +				      | PGM_INT_CODE_TX_ABORTED_EVENT;
> +	union {
> +		struct __htm_tdb tdb;
> +		uint64_t dwords[sizeof(struct __htm_tdb) / sizeof(uint64_t)];
> +	} diag;
> +	unsigned int i;
> +	int trans_result;
> +
> +	if (!test_facility(73)) {
> +		report_skip("transactional-execution facility not installed");
> +		return;
> +	}
> +	ctl_set_bit(0, CTL0_TRANSACT_EX_CTL); /* enable transactional-exec */
> +
> +	register_pgm_cleanup_func(trigger->fixup);
> +	trans_result = retry_transaction(trigger, args->max_retries, &diag.tdb, expected_pgm);
> +	register_pgm_cleanup_func(NULL);
> +	switch (trans_result) {
> +	case 0:
> +		report_pass("Program interrupt: expected(%d) == received(%d)",
> +			    expected_pgm, expected_pgm);
> +		break;
> +	case _HTM_TBEGIN_INDETERMINATE:
> +	case _HTM_TBEGIN_PERSISTENT:
> +		report_info("transaction failed with cc %d", trans_result);
> +		report_info("transaction abort code: %llu", diag.tdb.abort_code);
> +		if (args->diagnose)
> +			for (i = 0; i < 32; i++)
> +				report_info("diag+%03d: %016lx", i * 8, diag.dwords[i]);
> +		break;
> +	case _HTM_TBEGIN_TRANSIENT:
> +		report_fail("Program interrupt: expected(%d) == received(%d)",
> +			    expected_pgm, clear_pgm_int());
> +		break;
> +	case TRANSACTION_COMPLETED:
> +		report_fail("Transaction completed without exception");
> +		break;
> +	case TRANSACTION_MAX_RETRIES:
> +		report_info("Retried transaction %lu times without exception",

I would word it differently, otherwise the difference between this
case and the one above is not clear. Maybe something like

"Transaction retried %lu times with transient failures, giving up"

Moreover, in this case the test is in practice skipped, I think you
should use report_skip

> +			    args->max_retries);
> +		break;
> +	default:
> +		report_fail("Invalid return transaction result");
> +		break;
> +	}
> +
> +	ctl_clear_bit(0, CTL0_TRANSACT_EX_CTL);
> +}
> +
> +static struct args parse_args(int argc, char **argv)
> +{

can you find a way to simplify this function, or at least to make it
more readable?

> +	struct args args = {
> +		.max_retries = 20,
> +		.diagnose = false
> +	};
> +	unsigned int i;
> +	long arg;
> +	bool no_arg;
> +	char *end;
> +	const char *flag;
> +	uint64_t *argp;
> +
> +	for (i = 1; i < argc; i++) {
> +		no_arg = true;
> +		if (i < argc - 1) {
> +			no_arg = *argv[i + 1] == '\0';
> +			arg = strtol(argv[i + 1], &end, 10);
> +			no_arg |= *end != '\0';
> +			no_arg |= arg < 0;
> +		}
> +
> +		flag = "--max-retries";
> +		argp = &args.max_retries;
> +		if (!strcmp(flag, argv[i])) {
> +			if (no_arg)
> +				report_abort("%s needs a positive parameter", flag);
> +			*argp = arg;
> +			++i;
> +			continue;
> +		}
> +		if (!strcmp("--diagnose", argv[i])) {
> +			args.diagnose = true;
> +			continue;
> +		}
> +		if (!strcmp("--no-diagnose", argv[i])) {
> +			args.diagnose = false;
> +			continue;
> +		}
> +		report_abort("Unsupported parameter '%s'",
> +			     argv[i]);
> +	}
> +
> +	return args;
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	unsigned int i;
>  
> +	struct args args = parse_args(argc, argv);
> +
>  	report_prefix_push("specification exception");
>  	for (i = 0; spec_ex_triggers[i].name; i++) {
>  		report_prefix_push(spec_ex_triggers[i].name);
> @@ -150,5 +309,15 @@ int main(int argc, char **argv)
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

