Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40E448D832
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 13:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbiAMMtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 07:49:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65448 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231395AbiAMMte (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 07:49:34 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DCn2rd021958;
        Thu, 13 Jan 2022 12:49:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dJ4SPrsbzY+hUKfzc2nDjHmaAVcXpINwLFM77wLNnN4=;
 b=dRIiUDjfTzF4xDfmEGrnDHNsRrD7bSrIlR9R1OGqD79bte8XAszyI8nMCn3giuJDkZQD
 sBFVL8zDMcwQ1RSCS+TwsF6wY2DdZFHvCcAcRp6MkB7Lh2wa4sLSDyc/WOEuc9CUmWaE
 a/h8y/h/HaCzBXv6GACQOi2gulIhtXsPukfbfGgyRXCFcMAbKWq2jTe41foaCwtF9Wuq
 1CYXU+8X6hceaqiYAUWely3CBryFOoDGgHo6qfWvly8F9ee00m60Jn/tXhG+2aCXXSmu
 I/hp8TYEgfgMHSQjhsGrQ2A4jUvrODicdYw+FDm5CkMb3trMgzsCCGmsJE4EIE3Th+b5 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djkkgs731-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:49:33 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DCnXDs022830;
        Thu, 13 Jan 2022 12:49:33 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djkkgs72h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:49:33 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DCmNMV014077;
        Thu, 13 Jan 2022 12:49:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3df1vjmmha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:49:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DCeMZT45351334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 12:40:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEC2F42045;
        Thu, 13 Jan 2022 12:49:27 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E71E4203F;
        Thu, 13 Jan 2022 12:49:27 +0000 (GMT)
Received: from [9.171.31.87] (unknown [9.171.31.87])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 12:49:27 +0000 (GMT)
Message-ID: <23a324b9-6b33-5047-e0a9-f11828e189cd@linux.ibm.com>
Date:   Thu, 13 Jan 2022 13:49:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v4 2/2] s390x: Test specification
 exceptions during transaction
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220111163901.1263736-1-scgl@linux.ibm.com>
 <20220111163901.1263736-3-scgl@linux.ibm.com>
 <20220113132047.68edce5e@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220113132047.68edce5e@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: f2KZpK5fGeV2VcdS_8-9N9wrmLy8XhAp
X-Proofpoint-GUID: yDeES57oteefEuJ1EGLZyP7igomXSwkv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_04,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 mlxscore=0 clxscore=1015 suspectscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201130075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/22 13:20, Claudio Imbrenda wrote:
> On Tue, 11 Jan 2022 17:39:01 +0100
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> Program interruptions during transactional execution cause other
>> interruption codes.
>> Check that we see the expected code for (some) specification exceptions.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>> I don't think we can use constraint transactions to guarantee successful
>> execution of the transaction unless we implement it completely in asm,
>> otherwise we cannot ensure that the constraints of the transaction are met.
>>
>>  lib/s390x/asm/arch_def.h |   1 +
>>  s390x/spec_ex.c          | 177 ++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 174 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 40626d7..f7fb467 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -55,6 +55,7 @@ struct psw {
>>  #define PSW_MASK_BA			0x0000000080000000UL
>>  #define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
>>  
>> +#define CTL0_TRANSACT_EX_CTL		(63 -  8)
>>  #define CTL0_LOW_ADDR_PROT		(63 - 35)
>>  #define CTL0_EDAT			(63 - 40)
>>  #define CTL0_IEP			(63 - 43)
>> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
>> index a9f9f31..e599994 100644
>> --- a/s390x/spec_ex.c
>> +++ b/s390x/spec_ex.c
>> @@ -4,12 +4,18 @@
>>   *
>>   * Specification exception test.
>>   * Tests that specification exceptions occur when expected.
>> + * This includes specification exceptions occurring during transactional execution
>> + * as these result in another interruption code (the transactional-execution-aborted
>> + * bit is set).
>>   *
>>   * Can be extended by adding triggers to spec_ex_triggers, see comments below.
>>   */
>>  #include <stdlib.h>
>> +#include <htmintrin.h>
> 
> where is this header ?

Not sure what you're asking exactly. The path is /usr/lib/gcc/s390x-redhat-linux/11/include/htmintrin.h
on my machine.
> 
>>  #include <libcflat.h>
>> +#include <asm/barrier.h>
>>  #include <asm/interrupt.h>
>> +#include <asm/facility.h>
>>  
>>  static struct lowcore *lc = (struct lowcore *) 0;
>>  
>> @@ -106,19 +112,21 @@ static int not_even(void)
>>  /*
>>   * Harness for specification exception testing.
>>   * func only triggers exception, reporting is taken care of automatically.
>> + * If a trigger is transactable it will also  be executed during a transaction.
>>   */
>>  struct spec_ex_trigger {
>>  	const char *name;
>>  	int (*func)(void);
>> +	bool transactable;
>>  	void (*fixup)(void);
>>  };
>>  
>>  /* List of all tests to execute */
>>  static const struct spec_ex_trigger spec_ex_triggers[] = {
>> -	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw },
>> -	{ "bad_alignment", &bad_alignment, NULL },
>> -	{ "not_even", &not_even, NULL },
>> -	{ NULL, NULL, NULL },
>> +	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
>> +	{ "bad_alignment", &bad_alignment, true, NULL },
>> +	{ "not_even", &not_even, true, NULL },
>> +	{ NULL, NULL, false, NULL },
>>  };
>>  
>>  static void test_spec_ex(const struct spec_ex_trigger *trigger)
>> @@ -138,10 +146,161 @@ static void test_spec_ex(const struct spec_ex_trigger *trigger)
>>  	       expected_pgm, pgm);
>>  }
>>  
>> +#define TRANSACTION_COMPLETED 4
>> +#define TRANSACTION_MAX_RETRIES 5
>> +
>> +/* NULL must be passed to __builtin_tbegin via constant, forbid diagnose from
>> + * being NULL to keep things simple
>> + */
>> +static int __attribute__((nonnull))
>> +with_transaction(int (*trigger)(void), struct __htm_tdb *diagnose)
>> +{
>> +	int cc;
>> +
>> +	cc = __builtin_tbegin(diagnose);
> 
> this is __really__ hard to understand if you don't know exactly how
> transactions work. I would like to see some comments explaining what's
> going on and why

True.

[...]

>> +static void test_spec_ex_trans(struct args *args, const struct spec_ex_trigger *trigger)
>> +{
>> +	const uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION
>> +				      | PGM_INT_CODE_TX_ABORTED_EVENT;
>> +	union {
>> +		struct __htm_tdb tdb;
>> +		uint64_t dwords[sizeof(struct __htm_tdb) / sizeof(uint64_t)];
>> +	} diag;
>> +	unsigned int i;
>> +	int trans_result;
>> +
>> +	if (!test_facility(73)) {
>> +		report_skip("transactional-execution facility not installed");
>> +		return;
>> +	}
>> +	ctl_set_bit(0, CTL0_TRANSACT_EX_CTL); /* enable transactional-exec */
>> +
>> +	register_pgm_cleanup_func(trigger->fixup);
>> +	trans_result = retry_transaction(trigger, args->max_retries, &diag.tdb, expected_pgm);
>> +	register_pgm_cleanup_func(NULL);
>> +	switch (trans_result) {
>> +	case 0:
>> +		report_pass("Program interrupt: expected(%d) == received(%d)",
>> +			    expected_pgm, expected_pgm);
>> +		break;
>> +	case _HTM_TBEGIN_INDETERMINATE:
>> +	case _HTM_TBEGIN_PERSISTENT:
>> +		report_info("transaction failed with cc %d", trans_result);
>> +		report_info("transaction abort code: %llu", diag.tdb.abort_code);
>> +		if (args->diagnose)
>> +			for (i = 0; i < 32; i++)
>> +				report_info("diag+%03d: %016lx", i * 8, diag.dwords[i]);
>> +		break;
>> +	case _HTM_TBEGIN_TRANSIENT:
>> +		report_fail("Program interrupt: expected(%d) == received(%d)",
>> +			    expected_pgm, clear_pgm_int());
>> +		break;
>> +	case TRANSACTION_COMPLETED:
>> +		report_fail("Transaction completed without exception");
>> +		break;
>> +	case TRANSACTION_MAX_RETRIES:
>> +		report_info("Retried transaction %lu times without exception",
> 
> I would word it differently, otherwise the difference between this
> case and the one above is not clear. Maybe something like
> 
> "Transaction retried %lu times with transient failures, giving up"
> 
> Moreover, in this case the test is in practice skipped, I think you
> should use report_skip

Yes to both.

[...]

>> +static struct args parse_args(int argc, char **argv)
>> +{
> 
> can you find a way to simplify this function, or at least to make it
> more readable?
> 
>> +	struct args args = {
>> +		.max_retries = 20,
>> +		.diagnose = false
>> +	};
>> +	unsigned int i;
>> +	long arg;
>> +	bool no_arg;
>> +	char *end;
>> +	const char *flag;
>> +	uint64_t *argp;
>> +
>> +	for (i = 1; i < argc; i++) {
>> +		no_arg = true;
>> +		if (i < argc - 1) {
>> +			no_arg = *argv[i + 1] == '\0';
>> +			arg = strtol(argv[i + 1], &end, 10);
>> +			no_arg |= *end != '\0';
>> +			no_arg |= arg < 0;
>> +		}

I'll try to make that ^ more readable, the stuff below seems fine to me.

>> +
>> +		flag = "--max-retries";
>> +		argp = &args.max_retries;
>> +		if (!strcmp(flag, argv[i])) {
>> +			if (no_arg)
>> +				report_abort("%s needs a positive parameter", flag);
>> +			*argp = arg;
>> +			++i;
>> +			continue;
>> +		}
>> +		if (!strcmp("--diagnose", argv[i])) {
>> +			args.diagnose = true;
>> +			continue;
>> +		}
>> +		if (!strcmp("--no-diagnose", argv[i])) {
>> +			args.diagnose = false;
>> +			continue;
>> +		}
>> +		report_abort("Unsupported parameter '%s'",
>> +			     argv[i]);
>> +	}
>> +
>> +	return args;
>> +}
>> +

[...]

