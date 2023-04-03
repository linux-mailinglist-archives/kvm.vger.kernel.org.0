Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18216D4B33
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 16:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbjDCO5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 10:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjDCO5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 10:57:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A1316954;
        Mon,  3 Apr 2023 07:57:26 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 333EFEBI016202;
        Mon, 3 Apr 2023 14:57:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=94Qu7r1VQUH1WSULXUjMxRMmlpbvgxAC9U1zvon15wc=;
 b=D9LA+i/JWmo3lOHHMOOOSN5GKDx7OBBs0I2EDo5xzYSWZ/Uu6JWkpQVwjwCjj9CU6TQ2
 PJLkNmB1pJxPl+iICmeXd9vmydy/wNkqeqJ0F+iiW+15y+ux7qNfjolRxLhQuAkgukTO
 2hSUw7IsphnW160lDvowQaddRDD08aTTnJpeAmxrDR24kpVYte9DQ0Il1+GbdJKBBYnQ
 kW7znP8+K+79wtsVR4qJCFBmGXwBKuWsLP1btD/Ru2pRISYdbhVdu0KxQ8U34b5468TS
 sQhlouZeKIN7nPlArrrKy9w2kbJo7H86TQvsKO9uCNrz0YZrp0UmQ026zlXOWW3VPoEE Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pqv579yds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 14:57:25 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 333EFGWG024196;
        Mon, 3 Apr 2023 14:57:25 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pqv579ycn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 14:57:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 332MY5RP010775;
        Mon, 3 Apr 2023 14:57:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg1t9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 14:57:22 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 333EvJfv12321282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 14:57:19 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 337D12004D;
        Mon,  3 Apr 2023 14:57:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBCBD2004B;
        Mon,  3 Apr 2023 14:57:18 +0000 (GMT)
Received: from [9.179.22.128] (unknown [9.179.22.128])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon,  3 Apr 2023 14:57:18 +0000 (GMT)
Message-ID: <25d92c71-b495-9c0a-790d-d310710060d9@linux.ibm.com>
Date:   Mon, 3 Apr 2023 16:57:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH 5/5] s390x: ap: Add reset tests
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
References: <20230330114244.35559-1-frankja@linux.ibm.com>
 <20230330114244.35559-6-frankja@linux.ibm.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20230330114244.35559-6-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N7sMy_dj_zI5HUf9VWQBAICuyiMGy7Ee
X-Proofpoint-GUID: LVITq-NQMWd89DHCDOX5cCXH3Bvw-HYM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_11,2023-04-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030105
X-Spam-Status: No, score=-1.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/30/23 13:42, Janosch Frank wrote:
> Test if the IRQ enablement is turned off on a reset or zeroize PQAP.
>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/ap.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   lib/s390x/ap.h |  4 +++
>   s390x/ap.c     | 52 ++++++++++++++++++++++++++++++++++++++
>   3 files changed, 124 insertions(+)
>
> diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
> index aaf5b4b9..d969b2a5 100644
> --- a/lib/s390x/ap.c
> +++ b/lib/s390x/ap.c
> @@ -113,6 +113,74 @@ int ap_pqap_qci(struct ap_config_info *info)
>   	return cc;
>   }
>   
> +static int pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *r1,
> +		      bool zeroize)


NIT. Personal opinion, I find using this bool a little obfuscating and I 
would have prefer 2 different functions.

I see you added a ap_pqap_reset() and ap_pqap_zeroize() next in the code.

Why this intermediate level?


> +{
> +	struct pqap_r0 r0 = {};
> +	int cc;
> +
> +	/*
> +	 * Reset/zeroize AP Queue
> +	 *
> +	 * Resets/zeroizes a queue and disables IRQs
> +	 *
> +	 * Inputs: 0
> +	 * Outputs: 1
> +	 * Asynchronous
> +	 */
> +	r0.ap = ap;
> +	r0.qn = qn;
> +	r0.fc = zeroize ? PQAP_ZEROIZE_APQ : PQAP_RESET_APQ;
> +	asm volatile(
> +		"	lgr	0,%[r0]\n"
> +		"	lgr	1,%[r1]\n"
> +		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
> +		"	ipm	%[cc]\n"
> +		"	srl	%[cc],28\n"
> +		: [r1] "+&d" (r1), [cc] "=&d" (cc)
> +		: [r0] "d" (r0)
> +		: "memory");
> +
> +	return cc;
> +}
> +
> +static int pqap_reset_wait(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
> +			   bool zeroize)
> +{
> +	struct pqap_r2 r2 = {};
> +	int cc;
> +
> +	cc = pqap_reset(ap, qn, apqsw, zeroize);
> +	/* On a cc == 3 / error we don't need to wait */
> +	if (cc)
> +		return cc;
> +
> +	/*
> +	 * TAPQ returns AP_RC_RESET_IN_PROGRESS if a reset is being
> +	 * processed
> +	 */
> +	do {
> +		cc = ap_pqap_tapq(ap, qn, apqsw, &r2);
> +		/* Give it some time to process before the retry */
> +		mdelay(20);
> +	} while (apqsw->rc == AP_RC_RESET_IN_PROGRESS);
> +
> +	if (apqsw->rc)
> +		printf("Wait for reset failed on ap %d queue %d with tapq rc %d.",
> +			ap, qn, apqsw->rc);
> +	return cc;
> +}
> +
> +int ap_pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw)
> +{
> +	return pqap_reset_wait(ap, qn, apqsw, false);
> +}
> +
> +int ap_pqap_reset_zeroize(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw)
> +{
> +	return pqap_reset_wait(ap, qn, apqsw, true);
> +}
> +
>   static int ap_get_apqn(uint8_t *ap, uint8_t *qn)
>   {
>   	unsigned long *ptr;
> diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
> index 3f9e2eb6..f9343b5f 100644
> --- a/lib/s390x/ap.h
> +++ b/lib/s390x/ap.h
> @@ -12,6 +12,8 @@
>   #ifndef _S390X_AP_H_
>   #define _S390X_AP_H_
>   
> +#define AP_RC_RESET_IN_PROGRESS	0x02
> +
>   enum PQAP_FC {
>   	PQAP_TEST_APQ,
>   	PQAP_RESET_APQ,
> @@ -94,6 +96,8 @@ _Static_assert(sizeof(struct ap_qirq_ctrl) == sizeof(uint64_t),
>   int ap_setup(uint8_t *ap, uint8_t *qn);
>   int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
>   		 struct pqap_r2 *r2);
> +int ap_pqap_reset(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw);
> +int ap_pqap_reset_zeroize(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw);
>   int ap_pqap_qci(struct ap_config_info *info);
>   int ap_pqap_aqic(uint8_t ap, uint8_t qn, struct ap_queue_status *apqsw,
>   		 struct ap_qirq_ctrl aqic, unsigned long addr);
> diff --git a/s390x/ap.c b/s390x/ap.c
> index 31dcfe29..47b4f832 100644
> --- a/s390x/ap.c
> +++ b/s390x/ap.c
> @@ -341,6 +341,57 @@ static void test_pqap_aqic(void)
>   	report_prefix_pop();
>   }
>   
> +static void test_pqap_resets(void)
> +{
> +	struct ap_queue_status apqsw = {};
> +	static uint8_t not_ind_byte;
> +	struct ap_qirq_ctrl aqic = {};
> +	struct pqap_r2 r2 = {};
> +
> +	int cc;
> +
> +	report_prefix_push("pqap");
> +	report_prefix_push("rapq");
> +
> +	/* Enable IRQs which the resets will disable */
> +	aqic.ir = 1;
> +	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
> +	report(cc == 0 && apqsw.rc == 0, "enable");

Depending on history I think we could have apqsw == 07 here.

(interrupt already set as requested)


> +
> +	do {
> +		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);


may be a little delay before retry as you do above for ap_reset_wait()?


> +	} while (cc == 0 && apqsw.irq_enabled == 0);
> +	report(apqsw.irq_enabled == 1, "IRQs enabled");
> +
> +	ap_pqap_reset(apn, qn, &apqsw);
> +	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
> +	assert(!cc);
> +	report(apqsw.irq_enabled == 0, "IRQs have been disabled");

shouldn't we check that the APQ is fine apqsw.rc == 0 ?


> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("zapq");
> +
> +	/* Enable IRQs which the resets will disable */
> +	aqic.ir = 1;
> +	cc = ap_pqap_aqic(apn, qn, &apqsw, aqic, (uintptr_t)&not_ind_byte);
> +	report(cc == 0 && apqsw.rc == 0, "enable");
> +
> +	do {
> +		cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
> +	} while (cc == 0 && apqsw.irq_enabled == 0);
> +	report(apqsw.irq_enabled == 1, "IRQs enabled");
> +
> +	ap_pqap_reset_zeroize(apn, qn, &apqsw);
> +	cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
> +	assert(!cc);
> +	report(apqsw.irq_enabled == 0, "IRQs have been disabled");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}
> +
>   int main(void)
>   {
>   	int setup_rc = ap_setup(&apn, &qn);
> @@ -362,6 +413,7 @@ int main(void)
>   		goto done;
>   	}
>   	test_pqap_aqic();
> +	test_pqap_resets();
>   
>   done:
>   	report_prefix_pop();
