Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92BA439D9F
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 19:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbhJYRdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 13:33:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2320 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231220AbhJYRdF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 13:33:05 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PFfHCX015524;
        Mon, 25 Oct 2021 17:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=j6FaJOjQeIIGXKLgrZQ5x26V1ZQRvTnOuVDxp8xyLNQ=;
 b=ZMayDffNHUeJGIO5GPR6GWAeBbIQ6DhOY2lTpR5aFJtNvJK2bI5UHU6MPQGF2M/Ylbiz
 ewHjL7RV+WTpS9eVIpGFzNIgiM/uy6Qa0O3nKJzqjrvMhzrlFcbkES3m8E48YM40cGbU
 gIWJymFFrv2tnH8T1Y9LDZ4jogioFz4DgMU498F/duXabuf1pBVoFlkToLo/bOGApp76
 XrV2vm5xNSKd86qIiSVAduCg+XtRmA5ddzfB0VX6GOdVTQsz9JBH7dUc83xHNqsxwMbb
 Sj+LgHbVuREnuT4O6aIltLgrOUGMji/J+kapU2RROBXiR2g6byfg930pA/sX5HRkpZMJ Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bwsvdvjsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 17:30:42 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19PHRfG1010026;
        Mon, 25 Oct 2021 17:30:42 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bwsvdvjrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 17:30:42 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19PHTAXL005859;
        Mon, 25 Oct 2021 17:30:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3bva1a7dsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 17:30:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19PHUaXw59310578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 17:30:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CFCB11C069;
        Mon, 25 Oct 2021 17:30:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1D6511C054;
        Mon, 25 Oct 2021 17:30:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.93])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 17:30:35 +0000 (GMT)
Date:   Mon, 25 Oct 2021 19:17:22 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 1/2] s390x: Add specification
 exception test
Message-ID: <20211025191722.31cf7215@p-imbrenda>
In-Reply-To: <20211022120156.281567-2-scgl@linux.ibm.com>
References: <20211022120156.281567-1-scgl@linux.ibm.com>
        <20211022120156.281567-2-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wntaKDy6gCAS2PlIcYeJ4TD6MP1s-qF_
X-Proofpoint-GUID: cjuw1npjVV1hJBWEeyGyxANAXE0WNfm0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_06,2021-10-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Oct 2021 14:01:55 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Generate specification exceptions and check that they occur.
> With the iterations argument one can check if specification
> exception interpretation occurs, e.g. by using a high value and
> checking that the debugfs counters are substantially lower.
> The argument is also useful for estimating the performance benefit
> of interpretation.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/spec_ex.c     | 181 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   3 +
>  3 files changed, 185 insertions(+)
>  create mode 100644 s390x/spec_ex.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index d18b08b..3e42784 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
>  tests += $(TEST_DIR)/uv-host.elf
>  tests += $(TEST_DIR)/edat.elf
>  tests += $(TEST_DIR)/mvpg-sie.elf
> +tests += $(TEST_DIR)/spec_ex.elf
>  
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  ifneq ($(HOST_KEY_DOCUMENT),)
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> new file mode 100644
> index 0000000..ec3322a
> --- /dev/null
> +++ b/s390x/spec_ex.c
> @@ -0,0 +1,181 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright IBM Corp. 2021
> + *
> + * Specification exception test.
> + * Tests that specification exceptions occur when expected.
> + */
> +#include <stdlib.h>
> +#include <libcflat.h>
> +#include <asm/interrupt.h>
> +#include <asm/facility.h>
> +
> +static struct lowcore *lc = (struct lowcore *) 0;
> +
> +static bool expect_invalid_psw;
> +static struct psw expected_psw;
> +static struct psw fixup_psw;
> +
> +/* The standard program exception handler cannot deal with invalid old PSWs,
> + * especially not invalid instruction addresses, as in that case one cannot
> + * find the instruction following the faulting one from the old PSW.
> + * The PSW to return to is set by load_psw.
> + */
> +static void fixup_invalid_psw(void)
> +{
> +	if (expect_invalid_psw) {
> +		report(expected_psw.mask == lc->pgm_old_psw.mask
> +		       && expected_psw.addr == lc->pgm_old_psw.addr,
> +		       "Invalid program new PSW as expected");
> +		expect_invalid_psw = false;

can you find a way to call report() where the test is
triggered (psw_bit_12_is_1), instead of burying it here?

maybe instead of calling report you can set a flag like
"expected_psw_found" and then call report on it?

> +	}
> +	lc->pgm_old_psw = fixup_psw;
> +}
> +
> +/* Load possibly invalid psw, but setup fixup_psw before,
> + * so that *fixup_invalid_psw() can bring us back onto the right track.
> + */
> +static void load_psw(struct psw psw)
> +{
> +	uint64_t scratch;
> +

I understand why you are doing this, but I wonder if there is a "nicer"
way to do it. What happens if you chose a nicer and unique name for the
label and make it global?

> +	fixup_psw.mask = extract_psw_mask();

then you could add this here:
	fixup_psw.addr = after_lpswe;

> +	asm volatile (
> +		"	larl	%[scratch],nop%=\n"
> +		"	stg	%[scratch],%[addr]\n"
	^ those two lines are no longer needed ^
> +		"	lpswe	%[psw]\n"
> +		"nop%=:	nop\n"
	".global after_lpswe \n"
	"after_lpswe:	nop"
> +		: [scratch] "=&r"(scratch),
> +		  [addr] "=&T"(fixup_psw.addr)
> +		: [psw] "Q"(psw)
> +		: "cc", "memory"
> +	);
> +}
> +
> +static void psw_bit_12_is_1(void)
> +{
> +	expected_psw.mask = 0x0008000000000000;
> +	expected_psw.addr = 0x00000000deadbeee;
> +	expect_invalid_psw = true;
> +	load_psw(expected_psw);

and here something like
	report(expected_psw_found, "blah blah blah");

> +}
> +
> +static void bad_alignment(void)
> +{
> +	uint32_t words[5] = {0, 0, 0};
> +	uint32_t (*bad_aligned)[4];
> +
> +	register uint64_t r1 asm("6");
> +	register uint64_t r2 asm("7");
> +	if (((uintptr_t)&words[0]) & 0xf)
> +		bad_aligned = (uint32_t (*)[4])&words[0];
> +	else
> +		bad_aligned = (uint32_t (*)[4])&words[1];

this is a lot of work... can't you just declare it like:

	uint32_t words[5] __attribute__((aligned(16)));
and then just use
	(words + 1) ?

> +	asm volatile ("lpq %0,%2"
> +		      : "=r"(r1), "=r"(r2)

since you're ignoring the return value, can't you hardcode r6, and mark
it (and r7) as clobbered? like:
		"lpq 6, %[bad]"
		: : [bad] "T"(words[1])
		: "%r6", "%r7" 

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
> +	asm volatile (".insn	rxy,0xe3000000008f,%0,%2" //lpq
> %0,%2

this is even uglier. I guess you had already tried this?

		"lpq 7, %[good]"
			: : [good] "T"(quad)
			: "%r7", "%r8"

if that doesn't work, then the same but with .insn

> +		      : "=r"(r1), "=r"(r2)
> +		      : "T"(quad)
> +	);
> +}
> +
> +struct spec_ex_trigger {
> +	const char *name;
> +	void (*func)(void);
> +	void (*fixup)(void);
> +};
> +
> +static const struct spec_ex_trigger spec_ex_triggers[] = {
> +	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw},
> +	{ "bad_alignment", &bad_alignment, NULL},
> +	{ "not_even", &not_even, NULL},
> +	{ NULL, NULL, NULL},
> +};
> +

this is a lot of infrastructure for 3 tests... (or even for 5 tests,
since you will add the transactions in the next patch)

are you planning to significantly extend this test in the future?

> +struct args {
> +	uint64_t iterations;
> +};
> +
> +static void test_spec_ex(struct args *args,
> +			 const struct spec_ex_trigger *trigger)
> +{
> +	uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
> +	uint16_t pgm;
> +	unsigned int i;
> +
> +	for (i = 0; i < args->iterations; i++) {
> +		expect_pgm_int();
> +		register_pgm_cleanup_func(trigger->fixup);
> +		trigger->func();
> +		register_pgm_cleanup_func(NULL);
> +		pgm = clear_pgm_int();
> +		if (pgm != expected_pgm) {
> +			report_fail("Program interrupt: expected(%d)
> == received(%d)",
> +				    expected_pgm,
> +				    pgm);
> +			return;
> +		}
> +	}
> +	report_pass("Program interrupt: always expected(%d) ==
> received(%d)",
> +		    expected_pgm,
> +		    expected_pgm);
> +}
> +
> +static struct args parse_args(int argc, char **argv)

do we _really_ need commandline arguments?

is it really so important to be able to control these parameters?

can you find some values for the parameters so that the test works (as
in, it actually tests what it's supposed to) and also so that the whole
unit test ends in less than 30 seconds?

> +{
> +	struct args args = {
> +		.iterations = 1,
> +	};
> +	unsigned int i;
> +	long arg;
> +	bool no_arg;
> +	char *end;
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
> +		if (!strcmp("--iterations", argv[i])) {
> +			if (no_arg)
> +				report_abort("--iterations needs a
> positive parameter");
> +			args.iterations = arg;
> +			++i;
> +		} else {
> +			report_abort("Unsupported parameter '%s'",
> +				     argv[i]);
> +		}
> +	}
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
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 9e1802f..5f43d52 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -109,3 +109,6 @@ file = edat.elf
>  
>  [mvpg-sie]
>  file = mvpg-sie.elf
> +
> +[spec_ex]
> +file = spec_ex.elf

