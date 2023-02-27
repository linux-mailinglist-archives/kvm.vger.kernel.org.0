Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E246A4658
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 16:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjB0Ppl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 10:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjB0Ppf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 10:45:35 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48DD23843;
        Mon, 27 Feb 2023 07:44:52 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RF0GSZ012483;
        Mon, 27 Feb 2023 15:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jfk3d1zG7Y4es69SBEoaWorqTjrlfE08sbEXJkO2cLY=;
 b=jz26USHnA0e/rmVgM8m9nwo9Sdrx8XvOACzFkwxHqtoRibRTCvVi238mVh4noFVudtzG
 LkjYPBWoUPpzZrM/mnk4ll3R2F9DuFnmKsOJjkJTWE1gsKm+4qwwL4CRdI3iaJHnqIBg
 oVfCpVqEvbUAV8t+pXr1WIg117AGLMAIzUBhoquDBhwoQgjxQQUm4WmQVwwXV41pYOfh
 mJUtDGYXfhbUlyIfDvBM8G9cpv4ieWS2eV7tozEObScFd/HZcANnTT8T7gzR4cMQ09o+
 y5Uu6jtCmPWL5hm4MPF7rzMDifyTth0hoHo4+LMgQqFOsMr+iQq/ka7taM1gRilFIVkf dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0w20mf54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 15:44:51 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31RFPwMB004530;
        Mon, 27 Feb 2023 15:44:51 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0w20mf4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 15:44:51 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31R67dGA023377;
        Mon, 27 Feb 2023 15:44:49 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3nybab1hxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 15:44:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31RFijvL63177036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 15:44:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 640662004B;
        Mon, 27 Feb 2023 15:44:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF86820040;
        Mon, 27 Feb 2023 15:44:44 +0000 (GMT)
Received: from [9.171.95.33] (unknown [9.171.95.33])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 27 Feb 2023 15:44:44 +0000 (GMT)
Message-ID: <0d48cb35-738a-af5e-419a-5827dc6e3531@linux.ibm.com>
Date:   Mon, 27 Feb 2023 16:44:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20230224152015.2943564-1-nsg@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2] s390x: Add tests for execute-type
 instructions
In-Reply-To: <20230224152015.2943564-1-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WVlS-lK9KE1bobUFyS39qRg1HkLuIqjX
X-Proofpoint-GUID: gIh20hXN6pNP7dCpWWZiPO3YxDMLtvHO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_12,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302270119
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/24/23 16:20, Nina Schoetterl-Glausch wrote:
> Test the instruction address used by targets of an execute instruction.
> When the target instruction calculates a relative address, the result is
> relative to the target instruction, not the execute instruction.

For instructions like execute where the details matter it's a great idea 
to have a lot of comments maybe even loose references to the PoP so 
people can read up on the issue more easily.


> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> ---
> 
> 
> v1 -> v2:
>   * add test to unittests.cfg and .gitlab-ci.yml
>   * pick up R-b (thanks Nico)
> 
> 
> TCG does the address calculation relative to the execute instruction.

Always?
I.e. what are you telling me here?

> 
> 
>   s390x/Makefile      |  1 +
>   s390x/ex.c          | 92 +++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |  3 ++
>   .gitlab-ci.yml      |  1 +
>   4 files changed, 97 insertions(+)
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
> index 00000000..1bf4d8cd
> --- /dev/null
> +++ b/s390x/ex.c
> @@ -0,0 +1,92 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright IBM Corp. 2023
> + *
> + * Test EXECUTE (RELATIVE LONG).
> + */
> +
> +#include <libcflat.h>
> +

Take my words with some salt, I never had a close look at the branch 
instructions other than brc.

This is "branch and save" and the "r" in "basr" says that it's the RR 
variant. It's not relative the way that "bras" is, right?

Hence ret_addr and after_ex both point to 1f.

I'd like to have a comment here that states that this is not a relative 
branch at all. The r specifies the instruction format.

> +static void test_basr(void)
> +{
> +	uint64_t ret_addr, after_ex;
> +
> +	report_prefix_push("BASR");
> +	asm volatile ( ".pushsection .rodata\n"
> +		"0:	basr	%[ret_addr],0\n"
> +		"	.popsection\n"
> +
> +		"	larl	%[after_ex],1f\n"
> +		"	exrl	0,0b\n"
> +		"1:\n"
> +		: [ret_addr] "=d" (ret_addr),
> +		  [after_ex] "=d" (after_ex)
> +	);
> +
> +	report(ret_addr == after_ex, "return address after EX");
> +	report_prefix_pop();
> +}
> +
> +/*
> + * According to PoP (Branch-Address Generation), the address is relative to
> + * BRAS when it is the target of an execute-type instruction.
> + */

Is there any merit in testing the other br* instructions as well or are 
they running through the same TCG function?

> +static void test_bras(void)
> +{
> +	uint64_t after_target, ret_addr, after_ex, branch_addr;
> +
> +	report_prefix_push("BRAS");
> +	asm volatile ( ".pushsection .text.ex_bras, \"x\"\n"
> +		"0:	bras	%[ret_addr],1f\n"
> +		"	nopr	%%r7\n"
> +		"1:	larl	%[branch_addr],0\n"
> +		"	j	4f\n"
> +		"	.popsection\n"
> +
> +		"	larl	%[after_target],1b\n"
> +		"	larl	%[after_ex],3f\n"
> +		"2:	exrl	0,0b\n"
> +		"3:	larl	%[branch_addr],0\n"
> +		"4:\n"
> +
> +		"	.if (1b - 0b) != (3b - 2b)\n"
> +		"	.error	\"right and wrong target must have same offset\"\n"
> +		"	.endif\n"
> +		: [after_target] "=d" (after_target),
> +		  [ret_addr] "=d" (ret_addr),
> +		  [after_ex] "=d" (after_ex),
> +		  [branch_addr] "=d" (branch_addr)
> +	);
> +
> +	report(after_target == branch_addr, "address calculated relative to BRAS");
> +	report(ret_addr == after_ex, "return address after EX");
> +	report_prefix_pop();
> +}
> +

Add:
/* larl follows the address generation of relative branch instructions */
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
> +int main(int argc, char **argv)
> +{

We're missing push and pop around the test function block so that we 
know which file generated the output.

report_prefix_push("execute");

> +	test_basr();
> +	test_bras();
> +	test_larl();

report_prefix_pop();

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

