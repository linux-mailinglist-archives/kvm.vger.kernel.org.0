Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87E8589143
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 19:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbiHCRXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 13:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236321AbiHCRXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 13:23:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ABC53D06
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 10:23:44 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273HCCL7026236
        for <kvm@vger.kernel.org>; Wed, 3 Aug 2022 17:23:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=zGn+PE4WoQGp9O7mkVvyxRdZh4gLEjToor/Vy048WLQ=;
 b=UDXb4YcHOGSkdK4XlEIhanwCSPc8Xj0a/aBNQniK78l9ZyFCsikn+975gduu/UJ0IdxQ
 fXOeGPKOuHKvDrAYbEHGT6WZsS4SOgYw2kC5YRfishoX24vQTq3TTqUgG2SFMxMNfg6y
 VfhBVbNcMIlGJoNK8sUNFJyOwVm+3RwChbLJuCD2h2dZM1RyCAPEvHwWZzTx6OuDn4k8
 sHH0ieyOVNs4yCjTqv/U1ck3SANKpw4FCA9HBQE/hOuj5meLXA5bRrX5P5BqF1cmnGxg
 EBjYLdS5142X1JHmusC36rrXQ2YBtOCaH2n/Mk/1qJ4hg6AD55HWliAd5jcsec4PjSul jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqw748as0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 17:23:44 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 273HLXBW001092
        for <kvm@vger.kernel.org>; Wed, 3 Aug 2022 17:23:44 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqw748arb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 17:23:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 273HM2iD005933;
        Wed, 3 Aug 2022 17:23:41 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3hmv98n7jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 17:23:41 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 273HLLTq32375124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 17:21:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3FA2A405C;
        Wed,  3 Aug 2022 17:23:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22CA3A4054;
        Wed,  3 Aug 2022 17:23:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.230])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 17:23:36 +0000 (GMT)
Date:   Wed, 3 Aug 2022 19:23:34 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: verify EQBS/SQBS is
 unavailable
Message-ID: <20220803192334.44ebe902@p-imbrenda>
In-Reply-To: <20220803135851.384805-2-nrb@linux.ibm.com>
References: <20220803135851.384805-1-nrb@linux.ibm.com>
        <20220803135851.384805-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xElsWv234KaUVPUiH2wr-98-TMqCcrGC
X-Proofpoint-GUID: VAieu46CVuhe9fRzMW1elVcyqO1ltFBC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_04,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  3 Aug 2022 15:58:51 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> QEMU doesn't provide EQBS/SQBS instructions, so we should check they
> result in an exception.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/intercept.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/s390x/intercept.c b/s390x/intercept.c
> index 9e826b6c79ad..48eb2d22a2cc 100644
> --- a/s390x/intercept.c
> +++ b/s390x/intercept.c
> @@ -197,6 +197,34 @@ static void test_diag318(void)
>  
>  }
>  
> +static void test_qbs(void)
> +{
> +	report_prefix_push("qbs");
> +	if (!host_is_qemu()) {
> +		report_skip("QEMU-only test");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	report_prefix_push("sqbs");
> +	expect_pgm_int();
> +	asm volatile(
> +		"	.insn   rsy,0xeb000000008a,0,0,0(0)\n"
> +		: : : "memory", "cc");
> +	check_pgm_int_code(PGM_INT_CODE_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("eqbs");
> +	expect_pgm_int();
> +	asm volatile(
> +		"	.insn   rrf,0xb99c0000,0,0,0,0\n"
> +		: : : "memory", "cc");
> +	check_pgm_int_code(PGM_INT_CODE_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}
> +
>  struct {
>  	const char *name;
>  	void (*func)(void);
> @@ -208,6 +236,7 @@ struct {
>  	{ "stidp", test_stidp, false },
>  	{ "testblock", test_testblock, false },
>  	{ "diag318", test_diag318, false },
> +	{ "qbs", test_qbs, false },
>  	{ NULL, NULL, false }
>  };
>  

