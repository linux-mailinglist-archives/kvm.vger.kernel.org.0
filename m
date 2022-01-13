Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F8448D761
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 13:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbiAMMVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 07:21:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231790AbiAMMVG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 07:21:06 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DARP2a006979;
        Thu, 13 Jan 2022 12:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ie9dV0H000Lgx2ctKCFMhLNOBS5hHII4vJIHy304OcU=;
 b=UZDRCmjuMlhMa/NdWFus8Xzd7cImw+Laigs3DH0CsEm4fmVIQ+c/81D3yTF4hAnFnN+U
 MBXdq1Zb15V8MV4qyn4dhJoAOtyPlHDRpNtu/4BQs45awvGID+K3kRGAfo3dkRbxFa2w
 gmOsNVL01ZVk3njwyJm+F05SuCBkR3UCQmZQNqdyGDNBW7OMMXGu39gOUXIEqUkMegwc
 EPHBr2smkx+jUwUz4Iy43DlxxaE2qngMsyPmzrBF2HSk6yDVIG3HAzIabUuM9kDkJCQe
 RrsJ2WKXZnWGDa1vp95HkMwKEOyjOIlkxXbRwv4VwFcqVo++TnBps/Y0LIoNjqbk/YJQ NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djjbja0hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:21:05 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DCEOR9022192;
        Thu, 13 Jan 2022 12:21:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3djjbja0gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:21:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DCCH4G024139;
        Thu, 13 Jan 2022 12:21:03 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3df1vjmbje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:21:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DCBsOZ45613358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 12:11:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C655EA4051;
        Thu, 13 Jan 2022 12:20:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 263AAA4055;
        Thu, 13 Jan 2022 12:20:59 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.156])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 12:20:59 +0000 (GMT)
Date:   Thu, 13 Jan 2022 08:56:48 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 1/2] s390x: Add specification
 exception test
Message-ID: <20220113085648.7cf81084@p-imbrenda>
In-Reply-To: <20220111163901.1263736-2-scgl@linux.ibm.com>
References: <20220111163901.1263736-1-scgl@linux.ibm.com>
        <20220111163901.1263736-2-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: u9wO9Gj0eZfqam_pp-oJg3zhpS1jGpqt
X-Proofpoint-GUID: 8ayI-VUkr7TfRr557LTcrg5ilzaNS6Wj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_04,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jan 2022 17:39:00 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Generate specification exceptions and check that they occur.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/spec_ex.c     | 154 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   3 +
>  3 files changed, 158 insertions(+)
>  create mode 100644 s390x/spec_ex.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 1e567c1..5635c08 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -25,6 +25,7 @@ tests += $(TEST_DIR)/uv-host.elf
>  tests += $(TEST_DIR)/edat.elf
>  tests += $(TEST_DIR)/mvpg-sie.elf
>  tests += $(TEST_DIR)/spec_ex-sie.elf
> +tests += $(TEST_DIR)/spec_ex.elf
>  tests += $(TEST_DIR)/firq.elf
>  
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> new file mode 100644
> index 0000000..a9f9f31
> --- /dev/null
> +++ b/s390x/spec_ex.c
> @@ -0,0 +1,154 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright IBM Corp. 2021
> + *
> + * Specification exception test.
> + * Tests that specification exceptions occur when expected.
> + *
> + * Can be extended by adding triggers to spec_ex_triggers, see comments below.
> + */
> +#include <stdlib.h>
> +#include <libcflat.h>
> +#include <asm/interrupt.h>
> +
> +static struct lowcore *lc = (struct lowcore *) 0;
> +
> +static bool invalid_psw_expected;
> +static struct psw expected_psw;
> +static struct psw invalid_psw;
> +static struct psw fixup_psw;
> +
> +/* The standard program exception handler cannot deal with invalid old PSWs,
> + * especially not invalid instruction addresses, as in that case one cannot
> + * find the instruction following the faulting one from the old PSW.
> + * The PSW to return to is set by load_psw.
> + */
> +static void fixup_invalid_psw(void)
> +{
> +	// signal occurrence of invalid psw fixup
> +	invalid_psw_expected = false;
> +	invalid_psw = lc->pgm_old_psw;
> +	lc->pgm_old_psw = fixup_psw;
> +}
> +
> +/* Load possibly invalid psw, but setup fixup_psw before,
> + * so that *fixup_invalid_psw() can bring us back onto the right track.

is the * just a typo?

> + * Also acts as compiler barrier, -> none required in expect/check_invalid_psw
> + */
> +static void load_psw(struct psw psw)
> +{
> +	uint64_t scratch;
> +
> +	fixup_psw.mask = extract_psw_mask();
> +	asm volatile ( "larl	%[scratch],nop%=\n"
> +		"	stg	%[scratch],%[addr]\n"
> +		"	lpswe	%[psw]\n"
> +		"nop%=:	nop\n"
> +		: [scratch] "=&r"(scratch),
> +		  [addr] "=&T"(fixup_psw.addr)
> +		: [psw] "Q"(psw)
> +		: "cc", "memory"
> +	);
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
> +	// toggled to signal occurrence of invalid psw fixup

please use /* */ style of comments also for single line comments

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
> +static int psw_bit_12_is_1(void)
> +{
> +	struct psw invalid = { .mask = 0x0008000000000000, .addr = 0x00000000deadbeee};
> +
> +	expect_invalid_psw(invalid);
> +	load_psw(expected_psw);
> +	return check_invalid_psw();
> +}
> +
> +static int bad_alignment(void)
> +{
> +	uint32_t words[5] __attribute__((aligned(16)));
> +	uint32_t (*bad_aligned)[4] = (uint32_t (*)[4])&words[1];
> +
> +	asm volatile ("lpq %%r6,%[bad]"
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
> +	asm volatile (".insn	rxy,0xe3000000008f,%%r7,%[quad]" //lpq %%r7,%[quad]
> +		      : : [quad] "T"(quad)
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
> +	{ "bad_alignment", &bad_alignment, NULL },
> +	{ "not_even", &not_even, NULL },
> +	{ NULL, NULL, NULL },
> +};
> +
> +static void test_spec_ex(const struct spec_ex_trigger *trigger)
> +{
> +	uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
> +	uint16_t pgm;
> +	int rc;
> +
> +	expect_pgm_int();
> +	register_pgm_cleanup_func(trigger->fixup);
> +	rc = trigger->func();
> +	register_pgm_cleanup_func(NULL);
> +	if (rc)
> +		return;

why do you exit early in case of failure? (moreover, your are not even
reporting the failure)

> +	pgm = clear_pgm_int();
> +	report(pgm == expected_pgm, "Program interrupt: expected(%d) == received(%d)",
> +	       expected_pgm, pgm);
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
> index 054560c..26510cf 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -113,6 +113,9 @@ file = mvpg-sie.elf
>  [spec_ex-sie]
>  file = spec_ex-sie.elf
>  
> +[spec_ex]
> +file = spec_ex.elf
> +
>  [firq-linear-cpu-ids]
>  file = firq.elf
>  timeout = 20

