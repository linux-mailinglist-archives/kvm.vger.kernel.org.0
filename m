Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E9E6B802E
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 19:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjCMSQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 14:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjCMSQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 14:16:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86B27C3D3;
        Mon, 13 Mar 2023 11:16:11 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32DICU8s023609;
        Mon, 13 Mar 2023 18:16:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ohv1T3xbvXCPEADEHz4ZAugFaS0cY/DPukvfQH8XUPw=;
 b=mEQPP41Ebhs78LTZWIadJoff3aCLoYCYxXBtdYXdhF7x+XDLKN6+kDDzaVXW58UsbRBZ
 OGrE9aDrWCerMpPG3p4txDpP/A/7ny0iWdiOWIISmBNTMT7gDAhg6RVpANVDgndwOXdh
 qoja4UDj0NPLg9Yi7Kr5QgYX9dHjnpEk478XzGKS9dh2pho5t5ciCYogyCoFhqjkPV0x
 Z6aGxeebrNxGlOoNUebmz3yDrTBhk3En+T27KVRMQ08y6HiPJmHmOAZTO3DbdizQuzEv
 Zjw2Mu7+o6+Kqp7IYIUX+bFtRNsho3nwwx+DCqCaWERC5K+XCqqr6uOA0yn63V98hAME bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pa8wb03a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 18:16:11 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32DICcTX024355;
        Mon, 13 Mar 2023 18:16:10 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pa8wb037s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 18:16:10 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32DI1tiJ029416;
        Mon, 13 Mar 2023 18:16:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3p8gwfjw1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 18:16:08 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32DIG4Em52494838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Mar 2023 18:16:05 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4BA42004E;
        Mon, 13 Mar 2023 18:16:04 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EAB520040;
        Mon, 13 Mar 2023 18:16:04 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Mar 2023 18:16:04 +0000 (GMT)
Date:   Mon, 13 Mar 2023 19:16:02 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5] s390x: Add tests for execute-type
 instructions
Message-ID: <20230313191602.58b16c31@p-imbrenda>
In-Reply-To: <20230310181131.2138736-1-nsg@linux.ibm.com>
References: <20230310181131.2138736-1-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TwQHaUjK-mdXX7zHJN3NJr8Ke3rskIVX
X-Proofpoint-ORIG-GUID: 9VjXQgaDOKVUvc7Rs0W24feiBjOA3dxa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_09,2023-03-13_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 impostorscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303130141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Mar 2023 19:11:31 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> Test the instruction address used by targets of an execute instruction.
> When the target instruction calculates a relative address, the result is
> relative to the target instruction, not the execute instruction.
>=20
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>=20
>=20
> v4 -> v5:
>  * word align the execute-type instruction, preventing a specification
>    exception if the address calculation is wrong, since LLGFRL requires
>    word alignment
>  * change wording of comment
>=20
> v3 -> v4:
>  * fix nits (thanks Janosch)
>  * pickup R-b (thanks Janosch)
>=20
> v2 -> v3:
>  * add some comments (thanks Janosch)
>  * add two new tests (drop Nico's R-b)
>  * push prefix
>=20
> v1 -> v2:
>  * add test to unittests.cfg and .gitlab-ci.yml
>  * pick up R-b (thanks Nico)
>=20
>=20
> TCG does the address calculation relative to the execute instruction.
> Everything that has an operand that is relative to the instruction given =
by
> the immediate in the instruction and goes through in2_ri2 in TCG has this
> problem, because in2_ri2 does the calculation relative to pc_next which i=
s the
> address of the EX(RL).
> That should make fixing it easier tho.
>=20
>=20
> Range-diff against v4:
> 1:  f29ef634 ! 1:  57f8f256 s390x: Add tests for execute-type instructions
>     @@ s390x/ex.c (new)
>      +		"	.popsection\n"
>      +
>      +		"	llgfrl	%[target],0b\n"
>     ++		//align (pad with nop), in case the wrong operand is used
>     ++		"	.balignw 4,0x0707\n"
>      +		"	exrl	0,0b\n"
>      +		: [target] "=3Dd" (target),
>      +		  [value] "=3Dd" (value)
>     @@ s390x/ex.c (new)
>      +		"	.popsection\n"
>      +
>      +		"	lrl	%[crl_word],0b\n"
>     -+		//align (pad with nop), in case the wrong bad operand is used
>     ++		//align (pad with nop), in case the wrong operand is used
>      +		"	.balignw 4,0x0707\n"
>      +		"	exrl	0,0b\n"
>      +		"	ipm	%[program_mask]\n"
>=20
>  s390x/Makefile      |   1 +
>  s390x/ex.c          | 172 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   3 +
>  .gitlab-ci.yml      |   1 +
>  4 files changed, 177 insertions(+)
>  create mode 100644 s390x/ex.c
>=20
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 97a61611..6cf8018b 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -39,6 +39,7 @@ tests +=3D $(TEST_DIR)/panic-loop-extint.elf
>  tests +=3D $(TEST_DIR)/panic-loop-pgm.elf
>  tests +=3D $(TEST_DIR)/migration-sck.elf
>  tests +=3D $(TEST_DIR)/exittime.elf
> +tests +=3D $(TEST_DIR)/ex.elf
> =20
>  pv-tests +=3D $(TEST_DIR)/pv-diags.elf
> =20
> diff --git a/s390x/ex.c b/s390x/ex.c
> new file mode 100644
> index 00000000..f05f8f90
> --- /dev/null
> +++ b/s390x/ex.c
> @@ -0,0 +1,172 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright IBM Corp. 2023
> + *
> + * Test EXECUTE (RELATIVE LONG).
> + * These instructions execute a target instruction. The target instructi=
on is formed
> + * by reading an instruction from memory and optionally modifying some o=
f its bits.
> + * The execution of the target instruction is the same as if it was exec=
uted
> + * normally as part of the instruction sequence, except for the instruct=
ion
> + * address and the instruction-length code.
> + */
> +
> +#include <libcflat.h>
> +
> +/*
> + * BRANCH AND SAVE, register register variant.
> + * Saves the next instruction address (address from PSW + length of inst=
ruction)
> + * to the first register. No branch is taken in this test, because 0 is
> + * specified as target.
> + * BASR does *not* perform a relative address calculation with an interm=
ediate.
> + */
> +static void test_basr(void)
> +{
> +	uint64_t ret_addr, after_ex;
> +
> +	report_prefix_push("BASR");
> +	asm volatile ( ".pushsection .rodata\n"

you use .text.ex_bras in the next test, why not something like that here
(and everywhere else) too?

> +		"0:	basr	%[ret_addr],0\n"
> +		"	.popsection\n"
> +
> +		"	larl	%[after_ex],1f\n"
> +		"	exrl	0,0b\n"
> +		"1:\n"
> +		: [ret_addr] "=3Dd" (ret_addr),
> +		  [after_ex] "=3Dd" (after_ex)
> +	);
> +
> +	report(ret_addr =3D=3D after_ex, "return address after EX");
> +	report_prefix_pop();
> +}
> +
> +/*
> + * BRANCH RELATIVE AND SAVE.
> + * According to PoP (Branch-Address Generation), the address calculated =
relative
> + * to the instruction address is relative to BRAS when it is the target =
of an
> + * execute-type instruction, not relative to the execute-type instructio=
n.
> + */
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
> +		"	.if (1b - 0b) !=3D (3b - 2b)\n"
> +		"	.error	\"right and wrong target must have same offset\"\n"

please explain why briefly (i.e. if the wrong target is executed and
the offset mismatches Bad Things=E2=84=A2 happen)

> +		"	.endif\n"
> +		: [after_target] "=3Dd" (after_target),
> +		  [ret_addr] "=3Dd" (ret_addr),
> +		  [after_ex] "=3Dd" (after_ex),
> +		  [branch_addr] "=3Dd" (branch_addr)
> +	);
> +
> +	report(after_target =3D=3D branch_addr, "address calculated relative to=
 BRAS");
> +	report(ret_addr =3D=3D after_ex, "return address after EX");
> +	report_prefix_pop();
> +}
> +
> +/*
> + * LOAD ADDRESS RELATIVE LONG.
> + * If it is the target of an execute-type instruction, the address is re=
lative
> + * to the LARL.
> + */
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
> +		: [target] "=3Dd" (target),
> +		  [addr] "=3Dd" (addr)
> +	);
> +
> +	report(target =3D=3D addr, "address calculated relative to LARL");
> +	report_prefix_pop();
> +}
> +
> +/* LOAD LOGICAL RELATIVE LONG.
> + * If it is the target of an execute-type instruction, the address is re=
lative
> + * to the LLGFRL.
> + */
> +static void test_llgfrl(void)
> +{
> +	uint64_t target, value;
> +
> +	report_prefix_push("LLGFRL");
> +	asm volatile ( ".pushsection .rodata\n"
> +		"	.balign	4\n"

explain the alignment (like you did in the test below)

> +		"0:	llgfrl	%[value],0\n"
> +		"	.popsection\n"
> +
> +		"	llgfrl	%[target],0b\n"
> +		//align (pad with nop), in case the wrong operand is used
> +		"	.balignw 4,0x0707\n"
> +		"	exrl	0,0b\n"
> +		: [target] "=3Dd" (target),
> +		  [value] "=3Dd" (value)
> +	);
> +
> +	report(target =3D=3D value, "loaded correct value");
> +	report_prefix_pop();
> +}
> +
> +/*
> + * COMPARE RELATIVE LONG
> + * If it is the target of an execute-type instruction, the address is re=
lative
> + * to the CRL.
> + */
> +static void test_crl(void)
> +{
> +	uint32_t program_mask, cc, crl_word;
> +
> +	report_prefix_push("CRL");
> +	asm volatile ( ".pushsection .rodata\n"
> +		 //operand of crl must be word aligned
> +		 "	.balign	4\n"
> +		"0:	crl	%[crl_word],0\n"
> +		"	.popsection\n"
> +
> +		"	lrl	%[crl_word],0b\n"
> +		//align (pad with nop), in case the wrong operand is used
> +		"	.balignw 4,0x0707\n"
> +		"	exrl	0,0b\n"
> +		"	ipm	%[program_mask]\n"
> +		: [program_mask] "=3Dd" (program_mask),
> +		  [crl_word] "=3Dd" (crl_word)
> +		:: "cc"
> +	);
> +
> +	cc =3D program_mask >> 28;
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
> @@ -215,3 +215,6 @@ file =3D migration-skey.elf
>  smp =3D 2
>  groups =3D migration
>  extra_params =3D -append '--parallel'
> +
> +[execute]
> +file =3D ex.elf
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index ad7949c9..a999f64a 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -275,6 +275,7 @@ s390x-kvm:
>    - ACCEL=3Dkvm ./run_tests.sh
>        selftest-setup intercept emulator sieve sthyi diag10 diag308 pfmf
>        cmm vector gs iep cpumodel diag288 stsi sclp-1g sclp-3g css skrf s=
ie
> +      execute
>        | tee results.txt
>    - grep -q PASS results.txt && ! grep -q FAIL results.txt
>   only:
>=20
> base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6

