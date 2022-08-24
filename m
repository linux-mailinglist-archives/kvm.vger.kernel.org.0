Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0558A59F659
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 11:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236349AbiHXJfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 05:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbiHXJfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 05:35:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505BE844C4;
        Wed, 24 Aug 2022 02:35:40 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27O9DeFc031080;
        Wed, 24 Aug 2022 09:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=himAtPMsP0L9bdz3liO0LjqM3kZT2GC00YBjoUfqu9c=;
 b=l/+jp3jIncRtsvdFbHvuRghBLn5CGOr9DP3CityrLUOj1Xu0cvL855Xu5IQycpkd0EBe
 65J0WNqXs5vAK2P9jQIyr9Z8XbD541aBzkH+iR4nFsDRq9u/xDP+axa2wZ0AzDvzyM4b
 n8uSqR1vUtHsnYW0q28VG8a+jp4TsjgalpJIbRslvwxOk8SxEGGOtfHYW79tuZMYPKNN
 An0R1555pWGO+sDMmsaC7K5pdRIiHOrX7wjoQiDI8Cklq4BR8M2dDVnUc1Pa59Gw9DIj
 u2Wfo92tRNcGNj5vl9O07O0TGoJBFap8fPFnz+hq/1TOzFiCvmZAPSibfQC5iv2/Ex9D yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5h5p8sd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 09:35:32 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27O9FpFt007599;
        Wed, 24 Aug 2022 09:35:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5h5p8sbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 09:35:32 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27O9N6I8026789;
        Wed, 24 Aug 2022 09:35:30 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3j2q88ukwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 09:35:30 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27O9WQbF29426044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 09:32:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A219FAE053;
        Wed, 24 Aug 2022 09:35:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4184BAE04D;
        Wed, 24 Aug 2022 09:35:26 +0000 (GMT)
Received: from [9.145.53.141] (unknown [9.145.53.141])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Aug 2022 09:35:26 +0000 (GMT)
Message-ID: <1d0ef541-2b83-3c61-ec22-d5bf9a7698af@linux.ibm.com>
Date:   Wed, 24 Aug 2022 11:35:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        qemu-s390x@nongnu.org
References: <20220720142526.29634-1-scgl@linux.ibm.com>
 <20220720142526.29634-2-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 1/2] s390x: Add specification exception
 test
In-Reply-To: <20220720142526.29634-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ryQZ4AhoCsolIrqan7QoBZzIXFpH5IZu
X-Proofpoint-GUID: h8IORoZLft5k0kDmswd3T1qR_3JuX5Kf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_05,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208240036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/20/22 16:25, Janis Schoetterl-Glausch wrote:
> Generate specification exceptions and check that they occur.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   s390x/Makefile           |   1 +
>   lib/s390x/asm/arch_def.h |   5 ++
>   s390x/spec_ex.c          | 180 +++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg      |   3 +
>   4 files changed, 189 insertions(+)
>   create mode 100644 s390x/spec_ex.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index efd5e0c1..58b1bf54 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -27,6 +27,7 @@ tests += $(TEST_DIR)/uv-host.elf
>   tests += $(TEST_DIR)/edat.elf
>   tests += $(TEST_DIR)/mvpg-sie.elf
>   tests += $(TEST_DIR)/spec_ex-sie.elf
> +tests += $(TEST_DIR)/spec_ex.elf
>   tests += $(TEST_DIR)/firq.elf
>   tests += $(TEST_DIR)/epsw.elf
>   tests += $(TEST_DIR)/adtl-status.elf
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 78b257b7..8fbc451c 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -41,6 +41,11 @@ struct psw {
>   	uint64_t	addr;
>   };
>   
> +struct short_psw {
> +	uint32_t	mask;
> +	uint32_t	addr;
> +};
> +
>   #define AS_PRIM				0
>   #define AS_ACCR				1
>   #define AS_SECN				2
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> new file mode 100644
> index 00000000..77fc6246
> --- /dev/null
> +++ b/s390x/spec_ex.c
> @@ -0,0 +1,180 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright IBM Corp. 2021, 2022
> + *
> + * Specification exception test.
> + * Tests that specification exceptions occur when expected.
> + *
> + * Can be extended by adding triggers to spec_ex_triggers, see comments below.
> + */
> +#include <stdlib.h>

Which things are you hoping to include from stdlib.h?
As we normally use libcflat including external files can be pretty 
dangerous.

> +#include <libcflat.h>
> +#include <asm/interrupt.h>
> +
> +static bool invalid_psw_expected;
> +static struct psw expected_psw;
> +static struct psw invalid_psw;
> +static struct psw fixup_psw;
> +
> +/*
> + * The standard program exception handler cannot deal with invalid old PSWs,
> + * especially not invalid instruction addresses, as in that case one cannot
> + * find the instruction following the faulting one from the old PSW.
> + * The PSW to return to is set by load_psw.
> + */
> +static void fixup_invalid_psw(void)
> +{
> +	/* signal occurrence of invalid psw fixup */
> +	invalid_psw_expected = false;
> +	invalid_psw = lowcore.pgm_old_psw;
> +	lowcore.pgm_old_psw = fixup_psw;
> +}
> +
> +/*
> + * Load possibly invalid psw, but setup fixup_psw before,
> + * so that fixup_invalid_psw() can bring us back onto the right track.
> + * Also acts as compiler barrier, -> none required in expect/check_invalid_psw
> + */
> +static void load_psw(struct psw psw)
> +{
> +	uint64_t scratch;
> +

/*
Store a valid mask and the address of the nop into the fixup PSW.
Then load the possibly invalid PSW.
*/

> +	fixup_psw.mask = extract_psw_mask();
> +	asm volatile ( "larl	%[scratch],0f\n"
> +		"	stg	%[scratch],%[addr]\n"
> +		"	lpswe	%[psw]\n"
> +		"0:	nop\n"
> +		: [scratch] "=&d"(scratch),
> +		  [addr] "=&T"(fixup_psw.addr)

s/addr/psw_addr/ ?

> +		: [psw] "Q"(psw)
> +		: "cc", "memory"
> +	);
> +}
> +
> +static void load_short_psw(struct short_psw psw)
> +{
> +	uint64_t scratch;
> +
> +	fixup_psw.mask = extract_psw_mask();
> +	asm volatile ( "larl	%[scratch],0f\n"
> +		"	stg	%[scratch],%[addr]\n"
> +		"	lpsw	%[psw]\n"
> +		"0:	nop\n"
> +		: [scratch] "=&d"(scratch),
> +		  [addr] "=&T"(fixup_psw.addr)
> +		: [psw] "Q"(psw)
> +		: "cc", "memory"
> +	);

Same story.

> +}
> +
> +static void expect_invalid_psw(struct psw psw)
> +{
> +	expected_psw = psw;
> +	invalid_psw_expected = true;
> +}
> +
> +static int check_invalid_psw(void)
> +{
> +	/* toggled to signal occurrence of invalid psw fixup */

That comment's location is a bit weird.
Move it to the declaration of the variable.

> +	if (!invalid_psw_expected) {
> +		if (expected_psw.mask == invalid_psw.mask &&
> +		    expected_psw.addr == invalid_psw.addr)
> +			return 0;
> +		report_fail("Wrong invalid PSW");
> +	} else {
> +		report_fail("Expected exception due to invalid PSW");
> +	}
> +	return 1;
> +}
> +

/* For normal PSWs bit 12 has to be 0 to be a valid PSW*/

> +static int psw_bit_12_is_1(void)
> +{
> +	struct psw invalid = { .mask = 0x0008000000000000, .addr = 0x00000000deadbeee};

You could use BIT(63-12) for the mask.
I usually but struct initializations on new lines, it's easier to read.

> +
> +	expect_invalid_psw(invalid);
> +	load_psw(invalid);
> +	return check_invalid_psw();
> +}
> +

/* A short PSW needs to have bit 12 set to be valid. */
> +static int short_psw_bit_12_is_0(void)
> +{
> +	struct short_psw short_invalid = { .mask = 0x00000000, .addr = 0xdeadbeee};

I don't see a reason to specify more than one 0 if the whole value is 0.

> +
> +	/*
> +	 * lpsw may optionally check bit 12 before loading the new psw
> +	 * -> cannot check the expected invalid psw like with lpswe
> +	 */
> +	load_short_psw(short_invalid);
> +	return 0;
> +}
> +
> +static int bad_alignment(void)
> +{
> +	uint32_t words[5] __attribute__((aligned(16)));
> +	uint32_t (*bad_aligned)[4] = (uint32_t (*)[4])&words[1];
> +

/* lpq loads a quad word into a register pair and requires quad word 
alignment */

> +	asm volatile ("lpq %%r6,%[bad]"

Of course there's an instruction for that...

> +		      : : [bad] "T"(*bad_aligned)
> +		      : "%r6", "%r7"
> +	);
> +	return 0;
> +}
> +
> +static int not_even(void)
> +{
> +	uint64_t quad[2] __attribute__((aligned(16))) = {0};
> +
> +	asm volatile (".insn	rxy,0xe3000000008f,%%r7,%[quad]" /* lpq %%r7,%[quad] */
> +		      : : [quad] "T"(quad)

Is there a reason you never put a space after the constraint?

> +		      : "%r7", "%r8"
> +	);
> +	return 0;
> +}
> +
> +/*
> + * Harness for specification exception testing.
> + * func only triggers exception, reporting is taken care of automatically.
> + */
> +struct spec_ex_trigger {
> +	const char *name;
> +	int (*func)(void);
> +	void (*fixup)(void);
> +};
> +
> +/* List of all tests to execute */
> +static const struct spec_ex_trigger spec_ex_triggers[] = {
> +	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw },
> +	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, &fixup_invalid_psw },
> +	{ "bad_alignment", &bad_alignment, NULL },
> +	{ "not_even", &not_even, NULL },
> +	{ NULL, NULL, NULL },
> +};
> +
> +static void test_spec_ex(const struct spec_ex_trigger *trigger)
> +{
> +	int rc;
> +
> +	expect_pgm_int();
> +	register_pgm_cleanup_func(trigger->fixup);
> +	rc = trigger->func();
> +	register_pgm_cleanup_func(NULL);
> +	/* test failed, nothing to be done, reporting responsibility of trigger */
> +	if (rc)
> +		return;
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	unsigned int i;
> +
> +	report_prefix_push("specification exception");
> +	for (i = 0; spec_ex_triggers[i].name; i++) {
> +		report_prefix_push(spec_ex_triggers[i].name);
> +		test_spec_ex(&spec_ex_triggers[i]);
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 8e52f560..d2740a40 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -113,6 +113,9 @@ file = mvpg-sie.elf
>   [spec_ex-sie]
>   file = spec_ex-sie.elf
>   
> +[spec_ex]
> +file = spec_ex.elf
> +
>   [firq-linear-cpu-ids-kvm]
>   file = firq.elf
>   timeout = 20

