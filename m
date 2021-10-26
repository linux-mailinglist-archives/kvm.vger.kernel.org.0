Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C36743B1BC
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 14:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhJZMDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 08:03:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235112AbhJZMDC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 08:03:02 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QBwlc2003921;
        Tue, 26 Oct 2021 12:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6cDpulC4NFiqOE9gYEJ8u718hKjYzOvrjzOGLYjPpls=;
 b=h/W5s35blNIQyM3wdHSTBPDprhSOU3smskEVKt8uAvMkiIXcTYKnwfcA6RJlmDiGlIrd
 v6CrR1PzCW/KIYq9aoiBHJ0/boDag6MeHTsQfRj5FYOOimGMbcIuL60q0ib5BqUtIfdS
 cfXKSpltzHbkVj1VzZVMUwEvu4dnp5OShX3A15DEv92WvUz1h6EytlH+33D8uy/wumGF
 a6anvZP0smxzqZwWUiWllycWiNDpbCjVWEyd6Iq9ekFSgs6ykQgrfslDubUtoKLygccR
 027RGkb/gAx5tYr6lzMFi3pdlFPnqf6XMZru02JmtsLQHMcv17TmtUAc0WKZBWHbwFrJ YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bx4msvgrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 12:00:37 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19QBvEqw027228;
        Tue, 26 Oct 2021 12:00:37 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bx4msvgqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 12:00:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19QBws08003774;
        Tue, 26 Oct 2021 12:00:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3bx4f153fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 12:00:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19QC0WRH54001998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 12:00:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 174B5AE059;
        Tue, 26 Oct 2021 12:00:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB10DAE073;
        Tue, 26 Oct 2021 12:00:31 +0000 (GMT)
Received: from [9.171.95.189] (unknown [9.171.95.189])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Oct 2021 12:00:31 +0000 (GMT)
Message-ID: <d7b701ba-785f-5019-d2e4-a7eb30598c8f@linux.vnet.ibm.com>
Date:   Tue, 26 Oct 2021 14:00:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 1/2] s390x: Add specification exception
 test
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211022120156.281567-1-scgl@linux.ibm.com>
 <20211022120156.281567-2-scgl@linux.ibm.com>
 <20211025191722.31cf7215@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
In-Reply-To: <20211025191722.31cf7215@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CTdQMgU9y_gSc1A9opJa5X5zCyP2RdY2
X-Proofpoint-GUID: 2BCLY6nHUv55LXFbZcYTnSmOkxe2Qups
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_02,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110260066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/21 19:17, Claudio Imbrenda wrote:
> On Fri, 22 Oct 2021 14:01:55 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> Generate specification exceptions and check that they occur.
>> With the iterations argument one can check if specification
>> exception interpretation occurs, e.g. by using a high value and
>> checking that the debugfs counters are substantially lower.
>> The argument is also useful for estimating the performance benefit
>> of interpretation.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>  s390x/Makefile      |   1 +
>>  s390x/spec_ex.c     | 181 ++++++++++++++++++++++++++++++++++++++++++++
>>  s390x/unittests.cfg |   3 +
>>  3 files changed, 185 insertions(+)
>>  create mode 100644 s390x/spec_ex.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index d18b08b..3e42784 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
>>  tests += $(TEST_DIR)/uv-host.elf
>>  tests += $(TEST_DIR)/edat.elf
>>  tests += $(TEST_DIR)/mvpg-sie.elf
>> +tests += $(TEST_DIR)/spec_ex.elf
>>  
>>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>  ifneq ($(HOST_KEY_DOCUMENT),)
>> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
>> new file mode 100644
>> index 0000000..ec3322a
>> --- /dev/null
>> +++ b/s390x/spec_ex.c
>> @@ -0,0 +1,181 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright IBM Corp. 2021
>> + *
>> + * Specification exception test.
>> + * Tests that specification exceptions occur when expected.
>> + */
>> +#include <stdlib.h>
>> +#include <libcflat.h>
>> +#include <asm/interrupt.h>
>> +#include <asm/facility.h>
>> +
>> +static struct lowcore *lc = (struct lowcore *) 0;
>> +
>> +static bool expect_invalid_psw;
>> +static struct psw expected_psw;
>> +static struct psw fixup_psw;
>> +
>> +/* The standard program exception handler cannot deal with invalid old PSWs,
>> + * especially not invalid instruction addresses, as in that case one cannot
>> + * find the instruction following the faulting one from the old PSW.
>> + * The PSW to return to is set by load_psw.
>> + */
>> +static void fixup_invalid_psw(void)
>> +{
>> +	if (expect_invalid_psw) {
>> +		report(expected_psw.mask == lc->pgm_old_psw.mask
>> +		       && expected_psw.addr == lc->pgm_old_psw.addr,
>> +		       "Invalid program new PSW as expected");
>> +		expect_invalid_psw = false;
> 
> can you find a way to call report() where the test is
> triggered (psw_bit_12_is_1), instead of burying it here?
> 
Yes, should be doable.

> maybe instead of calling report you can set a flag like
> "expected_psw_found" and then call report on it?
> 
>> +	}
>> +	lc->pgm_old_psw = fixup_psw;
>> +}
>> +
>> +/* Load possibly invalid psw, but setup fixup_psw before,
>> + * so that *fixup_invalid_psw() can bring us back onto the right track.
>> + */
>> +static void load_psw(struct psw psw)
>> +{
>> +	uint64_t scratch;
>> +
> 
> I understand why you are doing this, but I wonder if there is a "nicer"
> way to do it. What happens if you chose a nicer and unique name for the
> label and make it global?
> 
I don't think that would work, the compiler might inline the function,
duplicating the label.

I suppose I could replace the stg with an assignment in C, not sure if that's nicer.

>> +	fixup_psw.mask = extract_psw_mask();
> 
> then you could add this here:
> 	fixup_psw.addr = after_lpswe;
> 
>> +	asm volatile (
>> +		"	larl	%[scratch],nop%=\n"
>> +		"	stg	%[scratch],%[addr]\n"
> 	^ those two lines are no longer needed ^
>> +		"	lpswe	%[psw]\n"
>> +		"nop%=:	nop\n"
> 	".global after_lpswe \n"
> 	"after_lpswe:	nop"
>> +		: [scratch] "=&r"(scratch),
>> +		  [addr] "=&T"(fixup_psw.addr)
>> +		: [psw] "Q"(psw)
>> +		: "cc", "memory"
>> +	);
>> +}
>> +
>> +static void psw_bit_12_is_1(void)
>> +{
>> +	expected_psw.mask = 0x0008000000000000;
>> +	expected_psw.addr = 0x00000000deadbeee;
>> +	expect_invalid_psw = true;
>> +	load_psw(expected_psw);
> 
> and here something like
> 	report(expected_psw_found, "blah blah blah");
> 
>> +}
>> +
>> +static void bad_alignment(void)
>> +{
>> +	uint32_t words[5] = {0, 0, 0};
>> +	uint32_t (*bad_aligned)[4];
>> +
>> +	register uint64_t r1 asm("6");
>> +	register uint64_t r2 asm("7");
>> +	if (((uintptr_t)&words[0]) & 0xf)
>> +		bad_aligned = (uint32_t (*)[4])&words[0];
>> +	else
>> +		bad_aligned = (uint32_t (*)[4])&words[1];
> 
> this is a lot of work... can't you just declare it like:
> 
> 	uint32_t words[5] __attribute__((aligned(16)));
> and then just use
> 	(words + 1) ?

That's nicer indeed.
> 
>> +	asm volatile ("lpq %0,%2"
>> +		      : "=r"(r1), "=r"(r2)
> 
> since you're ignoring the return value, can't you hardcode r6, and mark
> it (and r7) as clobbered? like:
> 		"lpq 6, %[bad]"
> 		: : [bad] "T"(words[1])
> 		: "%r6", "%r7" 
> 
Ok, btw. is there a reason bare register numbers seem to be more common
compared to %%rN ?

>> +		      : "T"(*bad_aligned)
>> +	);
>> +}
>> +
>> +static void not_even(void)
>> +{
>> +	uint64_t quad[2];
>> +
>> +	register uint64_t r1 asm("7");
>> +	register uint64_t r2 asm("8");
>> +	asm volatile (".insn	rxy,0xe3000000008f,%0,%2" //lpq
>> %0,%2
> 
> this is even uglier. I guess you had already tried this?
> 
Yes, the assembler won't let you do that.

> 		"lpq 7, %[good]"
> 			: : [good] "T"(quad)
> 			: "%r7", "%r8"
> 
> if that doesn't work, then the same but with .insn
> 
>> +		      : "=r"(r1), "=r"(r2)
>> +		      : "T"(quad)
>> +	);
>> +}
>> +
>> +struct spec_ex_trigger {
>> +	const char *name;
>> +	void (*func)(void);
>> +	void (*fixup)(void);
>> +};
>> +
>> +static const struct spec_ex_trigger spec_ex_triggers[] = {
>> +	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw},
>> +	{ "bad_alignment", &bad_alignment, NULL},
>> +	{ "not_even", &not_even, NULL},
>> +	{ NULL, NULL, NULL},
>> +};
>> +
> 
> this is a lot of infrastructure for 3 tests... (or even for 5 tests,
> since you will add the transactions in the next patch)

Is it? I think we'd want a test for a "normal" specification exception,
and one for an invalid PSW at least. Even for just those two, I don't
think it would be nice to duplicate the test_spec_ex harness.
> 
> are you planning to significantly extend this test in the future?

Not really, but I thought having it be easily extensible might be nice.
> 
>> +struct args {
>> +	uint64_t iterations;
>> +};
>> +
>> +static void test_spec_ex(struct args *args,
>> +			 const struct spec_ex_trigger *trigger)
>> +{
>> +	uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
>> +	uint16_t pgm;
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < args->iterations; i++) {
>> +		expect_pgm_int();
>> +		register_pgm_cleanup_func(trigger->fixup);
>> +		trigger->func();
>> +		register_pgm_cleanup_func(NULL);
>> +		pgm = clear_pgm_int();
>> +		if (pgm != expected_pgm) {
>> +			report_fail("Program interrupt: expected(%d)
>> == received(%d)",
>> +				    expected_pgm,
>> +				    pgm);
>> +			return;
>> +		}
>> +	}
>> +	report_pass("Program interrupt: always expected(%d) ==
>> received(%d)",
>> +		    expected_pgm,
>> +		    expected_pgm);
>> +}
>> +
>> +static struct args parse_args(int argc, char **argv)
> 
> do we _really_ need commandline arguments?
> 
No, but they can be useful.
The iterations argument can be used to check if interpretation happens.
The transaction arguments can be useful while developing a test case.

> is it really so important to be able to control these parameters?
> 
> can you find some values for the parameters so that the test works (as
> in, it actually tests what it's supposed to) and also so that the whole
> unit test ends in less than 30 seconds?

I think the defaults are fine for that, no?
> 
>> +{
>> +	struct args args = {
>> +		.iterations = 1,
>> +	};
>> +	unsigned int i;
>> +	long arg;
>> +	bool no_arg;
>> +	char *end;
>> +
>> +	for (i = 1; i < argc; i++) {
>> +		no_arg = true;
>> +		if (i < argc - 1) {
>> +			no_arg = *argv[i + 1] == '\0';
>> +			arg = strtol(argv[i + 1], &end, 10);
>> +			no_arg |= *end != '\0';
>> +			no_arg |= arg < 0;
>> +		}
>> +
>> +		if (!strcmp("--iterations", argv[i])) {
>> +			if (no_arg)
>> +				report_abort("--iterations needs a
>> positive parameter");
>> +			args.iterations = arg;
>> +			++i;
>> +		} else {
>> +			report_abort("Unsupported parameter '%s'",
>> +				     argv[i]);
>> +		}
>> +	}
>> +	return args;
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> +	unsigned int i;
>> +
>> +	struct args args = parse_args(argc, argv);
>> +
>> +	report_prefix_push("specification exception");
>> +	for (i = 0; spec_ex_triggers[i].name; i++) {
>> +		report_prefix_push(spec_ex_triggers[i].name);
>> +		test_spec_ex(&args, &spec_ex_triggers[i]);
>> +		report_prefix_pop();
>> +	}
>> +	report_prefix_pop();
>> +
>> +	return report_summary();
>> +}
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index 9e1802f..5f43d52 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -109,3 +109,6 @@ file = edat.elf
>>  
>>  [mvpg-sie]
>>  file = mvpg-sie.elf
>> +
>> +[spec_ex]
>> +file = spec_ex.elf
> 

