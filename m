Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5296BE58C
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 10:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjCQJ1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 05:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjCQJ1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 05:27:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1528DBAD27;
        Fri, 17 Mar 2023 02:27:01 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32H9MCAO030820;
        Fri, 17 Mar 2023 09:27:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=J4+VmfAJyRrEjWsNTQmJD5vAMkBzq6IQ4G3x/3hcbhA=;
 b=FgqqFRMeSrWDKLgeL46Aq/8mRXldpU//yEk8T6sTY03OA3i/pzPQy4qdWuyInjmoRIFQ
 iJiDS2nVLGgI3aP6K8CjRhA1aaL/6wxX6YhpdnTesPrCLXpjgiwdTARJ25SJeA2fOGsa
 un8z6qAxaW6tD6apoSscdjwtT//B2WVnhoZkTJX7bn0sIdh7lV1YurTN3Bj9kyK6p3T8
 YfcGP3JPLMAS6d7hajNHrCUX/1CLAl+dXXC3glSFxO9irqOwfbiq/znCxZxwIs6DNjZY
 Y42/g9st23vKeZ4YIugrInMk37l0gm+62hiqMp+5jv6at8rGVmDW7ZAW2DM0gY7M3Uy4 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcnh0827h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 09:27:00 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32H9MCqh030856;
        Fri, 17 Mar 2023 09:27:00 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcnh0826q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 09:27:00 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32GJ0iRi028055;
        Fri, 17 Mar 2023 09:26:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pbsyxsjkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 09:26:58 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32H9QtgO19006046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 09:26:55 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1279C20040;
        Fri, 17 Mar 2023 09:26:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 723012004D;
        Fri, 17 Mar 2023 09:26:54 +0000 (GMT)
Received: from [9.171.47.172] (unknown [9.171.47.172])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Mar 2023 09:26:54 +0000 (GMT)
Message-ID: <b6705072-de79-614d-d5fc-c78f1b65196f@linux.ibm.com>
Date:   Fri, 17 Mar 2023 10:26:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v3 2/3] s390x/spec_ex: Add test introducing
 odd address into PSW
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20230315155445.1688249-1-nsg@linux.ibm.com>
 <20230315155445.1688249-3-nsg@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230315155445.1688249-3-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1TFZwN9tPT0qYMvNcrTnPaoqr9sLmTV_
X-Proofpoint-GUID: ggBsW7FCQQCYxxb-sAk9lJ6rF9rkPxVV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_04,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 spamscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/23 16:54, Nina Schoetterl-Glausch wrote:
> Instructions on s390 must be halfword aligned.
> Introducing an odd instruction address into the PSW leads to a
> specification exception when attempting to execute the instruction at
> the odd address.
> Add a test for this.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

Some nits below.

> ---
>   s390x/spec_ex.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index 2adc5996..83b8c58e 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -88,12 +88,23 @@ static void expect_invalid_psw(struct psw psw)
>   	invalid_psw_expected = true;
>   }
>   
> +static void clear_invalid_psw(void)
> +{
> +	expected_psw = PSW(0, 0);
> +	invalid_psw_expected = false;
> +}
> +
>   static int check_invalid_psw(void)
>   {
>   	/* Since the fixup sets this to false we check for false here. */
>   	if (!invalid_psw_expected) {
> +		/*
> +		 * Early exception recognition: pgm_int_id == 0.
> +		 * Late exception recognition: psw address has been
> +		 *	incremented by pgm_int_id (unpredictable value)
> +		 */
>   		if (expected_psw.mask == invalid_psw.mask &&
> -		    expected_psw.addr == invalid_psw.addr)
> +		    expected_psw.addr == invalid_psw.addr - lowcore.pgm_int_id)
>   			return 0;
>   		report_fail("Wrong invalid PSW");
>   	} else {
> @@ -112,6 +123,42 @@ static int psw_bit_12_is_1(void)
>   	return check_invalid_psw();
>   }
>   
> +extern char misaligned_code[];
> +asm (  ".balign	2\n"

Is the double space intended?
Looking at the file itself some asm blocks have no space before the "(" 
and some have one.

> +"	. = . + 1\n"
> +"misaligned_code:\n"
> +"	larl	%r0,0\n"
> +"	br	%r1\n"
> +);

Any reason this is not indented?

> +
> +static int psw_odd_address(void)
> +{
> +	struct psw odd = PSW_WITH_CUR_MASK((uint64_t)&misaligned_code);
> +	uint64_t executed_addr;
> +
> +	expect_invalid_psw(odd);
> +	fixup_psw.mask = extract_psw_mask();
> +	asm volatile ( "xr	%%r0,%%r0\n"

While it will likely never make a difference I'd still use xgr here 
instead of xr.

> +		"	larl	%%r1,0f\n"
> +		"	stg	%%r1,%[fixup_addr]\n"
> +		"	lpswe	%[odd_psw]\n"
> +		"0:	lr	%[executed_addr],%%r0\n"
> +	: [fixup_addr] "=&T" (fixup_psw.addr),
> +	  [executed_addr] "=d" (executed_addr)
> +	: [odd_psw] "Q" (odd)
> +	: "cc", "%r0", "%r1"
> +	);
> +
> +	if (!executed_addr) {
> +		return check_invalid_psw();
> +	} else {
> +		assert(executed_addr == odd.addr);
> +		clear_invalid_psw();
> +		report_fail("did not execute unaligned instructions");
> +		return 1;
> +	}
> +}
> +
>   /* A short PSW needs to have bit 12 set to be valid. */
>   static int short_psw_bit_12_is_0(void)
>   {
> @@ -170,6 +217,7 @@ struct spec_ex_trigger {
>   static const struct spec_ex_trigger spec_ex_triggers[] = {
>   	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
>   	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
> +	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
>   	{ "bad_alignment", &bad_alignment, true, NULL },
>   	{ "not_even", &not_even, true, NULL },
>   	{ NULL, NULL, false, NULL },

