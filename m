Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0246A94E8
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 11:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjCCKLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 05:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjCCKLu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 05:11:50 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373815D46C;
        Fri,  3 Mar 2023 02:11:49 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3239tjhg027714;
        Fri, 3 Mar 2023 10:11:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PX45oXTad9of+NBB+jpgVmzJ2rUx1SOLd4UkrfdYdkE=;
 b=BOxtRH8bNIa2RZXeNo+X7pynix2xOwiGgSvSnlWzIM1y4cssQeu6rFx8VoClt1D//DM/
 uhLWHABYNYd7pRBbnkbGQJAFvfjsdqqU73+EaCZsD3ayYIzmGO1d+qkVfY7yhNaAVaRn
 i7r8vhSSMq/JCOsI+9MOMU2HklxxcX6w4L5k5pC703wdDIPiigXIk0RWRqv9MYRer3PB
 A3zH1Uyw+0OXMdGglOZ2JhsIyLKuakyjWezI1qzV8G3SPJ34QMcO/aS7tAw7tdpaJ7tZ
 Oq+Fep9PPyJoDzwiU3eiQuRJTLCSsUC4rxVBLFVy90P4vSqzqLv+KyOTi8cYrBsIgPyj /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p3epqgbn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 10:11:48 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3239uY1n029927;
        Fri, 3 Mar 2023 10:11:47 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p3epqgbmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 10:11:47 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 322JlNqd013004;
        Fri, 3 Mar 2023 10:11:45 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3nybcq70k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 10:11:45 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 323ABgFB45023636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Mar 2023 10:11:42 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B7F02008B;
        Fri,  3 Mar 2023 10:11:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D12B12008A;
        Fri,  3 Mar 2023 10:11:41 +0000 (GMT)
Received: from [9.171.60.119] (unknown [9.171.60.119])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  3 Mar 2023 10:11:41 +0000 (GMT)
Message-ID: <4e64cb7a-8503-f242-fd49-10b821e85441@linux.ibm.com>
Date:   Fri, 3 Mar 2023 11:11:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20230228204403.460107-1-nsg@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3] s390x: Add tests for execute-type
 instructions
In-Reply-To: <20230228204403.460107-1-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0xUJ8vFZyjl3Zs54E6krHVd9l7aLQyVM
X-Proofpoint-GUID: EN5sVlaS2jKCRKSVpGBORs2m0g54Csb9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_01,2023-03-02_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 impostorscore=0
 clxscore=1011 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303030084
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/28/23 21:44, Nina Schoetterl-Glausch wrote:
> Test the instruction address used by targets of an execute instruction.
> When the target instruction calculates a relative address, the result is
> relative to the target instruction, not the execute instruction.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Some small nits below, I can fix that up when picking.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
> 
> 
[...]
>   s390x/Makefile      |   1 +
>   s390x/ex.c          | 169 ++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |   3 +
>   .gitlab-ci.yml      |   1 +
>   4 files changed, 174 insertions(+)
>   create mode 100644 s390x/ex.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 97a61611..6cf8018b 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
>   tests += $(TEST_DIR)/panic-loop-pgm.elf
>   tests += $(TEST_DIR)/migration-sck.elf
>   tests += $(TEST_DIR)/exittime.elf
> +tests += $(TEST_DIR)/ex.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/ex.c b/s390x/ex.c
> new file mode 100644
> index 00000000..3a22e496
> --- /dev/null
> +++ b/s390x/ex.c
> @@ -0,0 +1,169 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright IBM Corp. 2023
> + *
> + * Test EXECUTE (RELATIVE LONG).
> + * These instruction execute a target instruction. The target instruction is formed

s/instruction/instructions/ ?

> + * by reading an instruction from memory and optionally modifying some of its bits.
> + * The execution of the target instruction is the same as if it was executed
> + * normally as part of the instruction sequence, except for the instruction
> + * address and the instruction-length code.
> + */
> +
> +#include <libcflat.h>
> +

[...]

> +static void test_larl(void)
> +{
> +	uint64_t target, addr;
> +
> +	report_prefix_push("LARL");
> +	asm volatile ( ".pushsection .rodata\n"
> +		"0:	larl	%[addr],0\n"
> +		"	.popsection\n"
> +
> +		"	larl	%[target],0b\n"
> +		"	exrl	0,0b\n"
> +		: [target] "=d" (target),
> +		  [addr] "=d" (addr)
> +	);
> +
> +	report(target == addr, "address calculated relative to LARL");
> +	report_prefix_pop();
> +}
> +
> +/* LOAD LOGICAL RELATIVE LONG.
> + * If it is the target of an execute-type instruction, the address is relative
> + * to the LLGFRL.
> + */

This is the only instruction where there's no comment about the execute 
behavior but it would only make sense that it follows the same address 
generation rules.

> +static void test_llgfrl(void)
> +{
> +	uint64_t target, value;
> +
> +	report_prefix_push("LLGFRL");
> +	asm volatile ( ".pushsection .rodata\n"
> +		"	.balign	4\n"
> +		"0:	llgfrl	%[value],0\n"
> +		"	.popsection\n"
> +
> +		"	llgfrl	%[target],0b\n"
> +		"	exrl	0,0b\n"
> +		: [target] "=d" (target),
> +		  [value] "=d" (value)
> +	);
> +
> +	report(target == value, "loaded correct value");
> +	report_prefix_pop();
> +}
> +
> +/*
> + * COMPARE RELATIVE LONG
> + * If it is the target of an execute-type instruction, the address is relative
> + * to the CRL.
> + */
> +static void test_crl(void)
> +{
> +	uint32_t program_mask, cc, crl_word;
> +
> +	report_prefix_push("CRL");
> +	asm volatile ( ".pushsection .rodata\n"
> +		"	.balign	4\n" //operand of crl must be word aligned

Just put it on a new line so we don't mix commenting stiles.
Inline assembly is already hardly readable anyway.

> +		"0:	crl	%[crl_word],0\n"
> +		"	.popsection\n"
> +
> +		"	lrl	%[crl_word],0b\n"
> +		//align (pad with nop), in case the wrong bad operand is used
> +		"	.balignw 4,0x0707\n"
> +		"	exrl	0,0b\n"
> +		"	ipm	%[program_mask]\n"
> +		: [program_mask] "=d" (program_mask),
> +		  [crl_word] "=d" (crl_word)
> +		:: "cc"
> +	);
> +
> +	cc = program_mask >> 28;
> +	report(!cc, "operand compared to is relative to CRL");
> +	report_prefix_pop();
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	report_prefix_push("ex");
> +	test_basr();
> +	test_bras();
> +	test_larl();
> +	test_llgfrl();
> +	test_crl();
> +	report_prefix_pop();
> +
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index d97eb5e9..b61faf07 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -215,3 +215,6 @@ file = migration-skey.elf
>   smp = 2
>   groups = migration
>   extra_params = -append '--parallel'
> +
> +[execute]
> +file = ex.elf
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index ad7949c9..a999f64a 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -275,6 +275,7 @@ s390x-kvm:
>     - ACCEL=kvm ./run_tests.sh
>         selftest-setup intercept emulator sieve sthyi diag10 diag308 pfmf
>         cmm vector gs iep cpumodel diag288 stsi sclp-1g sclp-3g css skrf sie
> +      execute
>         | tee results.txt
>     - grep -q PASS results.txt && ! grep -q FAIL results.txt
>    only:
> 
> base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6

