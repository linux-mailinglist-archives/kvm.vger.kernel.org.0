Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74EB669A9B4
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 12:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjBQLGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 06:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjBQLGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 06:06:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6CE2C660;
        Fri, 17 Feb 2023 03:05:41 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31H9qWAA023942;
        Fri, 17 Feb 2023 11:05:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=8MY8OySzjuadKjLQVlQsLe39x1qBN420fYQTdstHlss=;
 b=F0wfMKY9RQNI9euHhxS1ksH/4u6KQh3TcbcN8IdQqVWI+w3TzzLM2cVQHaYNBfWaoKHF
 mDjwxYeAvMfsNkHBBLmJqZkFh9SP1OWYrre1D+fZsNDPT+SShExXNFHp/sqjWp0Mm9P3
 nPww0eajZAonlJjEMRG+x22PA5yEwASf6m47i/Mc5/lsSQw9B85q9mvgUf7DRi5tU1fH
 5lmxNMLY+Qg8CUC/+tvFzb75bvdb4JjfpwJHTeWHlvWRxc1IbS+LJF4lIHu1ppjBowp5
 RcryXOSRcAwkrxYxjHvNkOJyTBePRRvMGJrw3QlvGKqnIn7qcUuiXV1KkHSX1HDolgMv eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nt225rm42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 11:05:28 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31HA9Msi024053;
        Fri, 17 Feb 2023 11:05:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nt225rm3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 11:05:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31GJ4Hma010804;
        Fri, 17 Feb 2023 11:05:26 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6yx2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 11:05:25 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31HB5MPA48234900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Feb 2023 11:05:22 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31C312004D;
        Fri, 17 Feb 2023 11:05:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE79820040;
        Fri, 17 Feb 2023 11:05:21 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.12.31])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 17 Feb 2023 11:05:21 +0000 (GMT)
Date:   Fri, 17 Feb 2023 12:05:16 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x/spec_ex: Add test
 introducing odd address into PSW
Message-ID: <20230217120516.13db2aa2@p-imbrenda>
In-Reply-To: <20230215171852.1935156-2-nsg@linux.ibm.com>
References: <20230215171852.1935156-1-nsg@linux.ibm.com>
        <20230215171852.1935156-2-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ifEB9jBpge6x-AALQ391P283io67ki_o
X-Proofpoint-ORIG-GUID: MgKiXpZ9h2h4PP7vRSWzNHvP-agw_iC5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_06,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 clxscore=1015 suspectscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302170101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Feb 2023 18:18:51 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> Instructions on s390 must be halfword aligned.
> Introducing an odd instruction address into the PSW leads to a
> specification exception when attempting to execute the instruction at
> the odd address.
> Add a test for this.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  s390x/spec_ex.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 69 insertions(+), 4 deletions(-)
> 
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index 42ecaed3..b6764677 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -44,9 +44,10 @@ static void fixup_invalid_psw(struct stack_frame_int *stack)
>  /*
>   * Load possibly invalid psw, but setup fixup_psw before,
>   * so that fixup_invalid_psw() can bring us back onto the right track.
> + * The provided argument is loaded into register 1.
>   * Also acts as compiler barrier, -> none required in expect/check_invalid_psw
>   */
> -static void load_psw(struct psw psw)
> +static void load_psw_with_arg(struct psw psw, uint64_t arg)
>  {
>  	uint64_t scratch;
>  
> @@ -57,15 +58,22 @@ static void load_psw(struct psw psw)
>  	fixup_psw.mask = extract_psw_mask();
>  	asm volatile ( "larl	%[scratch],0f\n"
>  		"	stg	%[scratch],%[fixup_addr]\n"
> +		"	lgr	%%r1,%[arg]\n"
>  		"	lpswe	%[psw]\n"
>  		"0:	nop\n"
>  		: [scratch] "=&d" (scratch),
>  		  [fixup_addr] "=&T" (fixup_psw.addr)
> -		: [psw] "Q" (psw)
> -		: "cc", "memory"
> +		: [psw] "Q" (psw),
> +		  [arg] "d" (arg)
> +		: "cc", "memory", "%r1"
>  	);
>  }
>  
> +static void load_psw(struct psw psw)
> +{
> +	load_psw_with_arg(psw, 0);
> +}
> +
>  static void load_short_psw(struct short_psw psw)
>  {
>  	uint64_t scratch;
> @@ -88,12 +96,18 @@ static void expect_invalid_psw(struct psw psw)
>  	invalid_psw_expected = true;
>  }
>  
> +static void clear_invalid_psw(void)
> +{
> +	expected_psw = (struct psw){0};

as of today, you can use PSW(0, 0)  :)

> +	invalid_psw_expected = false;
> +}
> +
>  static int check_invalid_psw(void)
>  {
>  	/* Since the fixup sets this to false we check for false here. */
>  	if (!invalid_psw_expected) {
>  		if (expected_psw.mask == invalid_psw.mask &&
> -		    expected_psw.addr == invalid_psw.addr)
> +		    expected_psw.addr == invalid_psw.addr - lowcore.pgm_int_id)

can you explain this change?

>  			return 0;
>  		report_fail("Wrong invalid PSW");
>  	} else {
> @@ -115,6 +129,56 @@ static int psw_bit_12_is_1(void)
>  	return check_invalid_psw();
>  }
>  
> +static int psw_odd_address(void)
> +{
> +	struct psw odd = {

now you can use PSW_WITH_CUR_MASK(0) here

> +		.mask = extract_psw_mask(),
> +	};
> +	uint64_t regs[16];
> +	int r;
> +
> +	/*
> +	 * This asm is reentered at an odd address, which should cause a specification
> +	 * exception before the first unaligned instruction is executed.
> +	 * In this case, the interrupt handler fixes the address and the test succeeds.
> +	 * If, however, unaligned instructions *are* executed, they are jumped to
> +	 * from somewhere, with unknown registers, so save and restore those before.
> +	 */

I wonder if this could be simplified

> +	asm volatile ( "stmg	%%r0,%%r15,%[regs]\n"
> +		//can only offset by even number when using larl -> increment by one
> +		"	larl	%[r],0f\n"
> +		"	aghi	%[r],1\n"
> +		"	stg	%[r],%[addr]\n"

the above is ok (set up illegal PSW)

(maybe call expect_invalid_psw here, see comments below)

put the address of the exit label in a register

then do a lpswe here to jump to the invalid PSW

> +		"	xr	%[r],%[r]\n"
> +		"	brc	0xf,1f\n"

then do the above. that will only happen if the PSW was not loaded.

> +		"0:	. = . + 1\n"

if we are here, things went wrong.
write something in r, jump to the exit label (using the address in the
register that we saved earlier)

> +		"	lmg	%%r0,%%r15,0(%%r1)\n"
> +		//address of the instruction itself, should be odd, store for assert
> +		"	larl	%[r],0\n"
> +		"	stg	%[r],%[addr]\n"
> +		"	larl	%[r],0f\n"
> +		"	aghi	%[r],1\n"
> +		"	bcr	0xf,%[r]\n"
> +		"0:	. = . + 1\n"
> +		"1:\n"
> +	: [addr] "=T" (odd.addr),
> +	  [regs] "=Q" (regs),
> +	  [r] "=d" (r)
> +	: : "cc", "memory"
> +	);
> +

if we come out here and r is 0, then things went well, otherwise we
fail.

> +	if (!r) {
> +		expect_invalid_psw(odd);

that ^ should probably go before the asm (or _in_ the asm, maybe you
can call the C function from asm)

> +		load_psw_with_arg(odd, (uint64_t)&regs);

this would not be needed anymore ^


this way you don't need to save registers or do crazy things where you
jump back in the middle of the asm from C code. and then you don't even
need load_psw_with_arg


> +		return check_invalid_psw();
> +	} else {
> +		assert(odd.addr & 1);
> +		clear_invalid_psw();
> +		report_fail("executed unaligned instructions");
> +		return 1;
> +	}
> +}
> +
>  /* A short PSW needs to have bit 12 set to be valid. */
>  static int short_psw_bit_12_is_0(void)
>  {
> @@ -176,6 +240,7 @@ struct spec_ex_trigger {
>  static const struct spec_ex_trigger spec_ex_triggers[] = {
>  	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
>  	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
> +	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
>  	{ "bad_alignment", &bad_alignment, true, NULL },
>  	{ "not_even", &not_even, true, NULL },
>  	{ NULL, NULL, false, NULL },

