Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25AF4F3ACE
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 17:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbiDELst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 07:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380269AbiDELmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 07:42:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9FC79389;
        Tue,  5 Apr 2022 04:05:57 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235ADwnp015141;
        Tue, 5 Apr 2022 11:05:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bcuSbqeJflRbX6NyO3lbBoliDhyVefXFvOjb7NPEjmk=;
 b=GBMMUpxh1TxrhfqVfwBW4eqkmruSgimL7dRRsXcNe8oyzEBv0gHcuHzjKiilZ482+50+
 xidnYKT6BClXBe2NMiXr19n1c7gGEC7Ef7l9q2p5LPKu1WhT6eM1b6yZwfYKVvgZw0Cl
 gbV0gPn9f1puuXKUJTemRnMaK5qlQvY5xhD5X88AjcawB/vLWseqNqRX5JH4sV8DRL/o
 CRkg1XkCFYM0W7r1LTjJENl1Yzl90ERn0pmyeEYmzll3b4nGhSp1dWYWS6tQCStoXooK
 T+menGQQcNfas3foh/fUFeW5p/voPzWMU1X66XABfNhlJhr80xWYvzH9MDR/efCya5aj /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yuq0wkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:05:56 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 235Av75E009989;
        Tue, 5 Apr 2022 11:05:55 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yuq0wk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:05:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 235B2xrb009571;
        Tue, 5 Apr 2022 11:05:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3f6e48wjn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:05:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 235B5oHd40763796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 11:05:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EB5AA405B;
        Tue,  5 Apr 2022 11:05:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D93D0A4054;
        Tue,  5 Apr 2022 11:05:49 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.146])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 11:05:49 +0000 (GMT)
Date:   Tue, 5 Apr 2022 13:03:32 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 3/8] s390x: pfmf: Initialize pfmf_r1
 union on declaration
Message-ID: <20220405130332.304ba1bb@p-imbrenda>
In-Reply-To: <20220405075225.15903-4-frankja@linux.ibm.com>
References: <20220405075225.15903-1-frankja@linux.ibm.com>
        <20220405075225.15903-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fj4ELqA9AfmaEMn2nZARepMRrxrMRn7E
X-Proofpoint-ORIG-GUID: GQoStxrwvamZABtv8yFLFruv8TqIhsQb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-05_02,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204050066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 Apr 2022 07:52:20 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's make this test look a bit nicer.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/pfmf.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/s390x/pfmf.c b/s390x/pfmf.c
> index aa130529..178abb5a 100644
> --- a/s390x/pfmf.c
> +++ b/s390x/pfmf.c
> @@ -28,7 +28,11 @@ static void test_priv(void)
>  
>  static void test_4k_key(void)
>  {
> -	union pfmf_r1 r1;
> +	union pfmf_r1 r1 = {
> +		.reg.sk = 1,
> +		.reg.fsc = PFMF_FSC_4K,
> +		.reg.key = 0x30,
> +	};
>  	union skey skey;
>  
>  	report_prefix_push("4K");
> @@ -36,10 +40,6 @@ static void test_4k_key(void)
>  		report_skip("storage key removal facility is active");
>  		goto out;
>  	}
> -	r1.val = 0;
> -	r1.reg.sk = 1;
> -	r1.reg.fsc = PFMF_FSC_4K;
> -	r1.reg.key = 0x30;
>  	pfmf(r1.val, pagebuf);
>  	skey.val = get_storage_key(pagebuf);
>  	skey.val &= SKEY_ACC | SKEY_FP;
> @@ -52,18 +52,19 @@ static void test_1m_key(void)
>  {
>  	int i;
>  	bool rp = true;
> -	union pfmf_r1 r1;
>  	union skey skey;
> +	union pfmf_r1 r1 = {
> +		.reg.fsc = PFMF_FSC_1M,
> +		.reg.key = 0x30,
> +		.reg.sk = 1,
> +	};
>  
>  	report_prefix_push("1M");
>  	if (test_facility(169)) {
>  		report_skip("storage key removal facility is active");
>  		goto out;
>  	}
> -	r1.val = 0;
> -	r1.reg.sk = 1;
> -	r1.reg.fsc = PFMF_FSC_1M;
> -	r1.reg.key = 0x30;
> +
>  	pfmf(r1.val, pagebuf);
>  	for (i = 0; i < 256; i++) {
>  		skey.val = get_storage_key(pagebuf + i * PAGE_SIZE);
> @@ -80,11 +81,10 @@ out:
>  
>  static void test_4k_clear(void)
>  {
> -	union pfmf_r1 r1;
> -
> -	r1.val = 0;
> -	r1.reg.cf = 1;
> -	r1.reg.fsc = PFMF_FSC_4K;
> +	union pfmf_r1 r1 = {
> +		.reg.cf = 1,
> +		.reg.fsc = PFMF_FSC_4K,
> +	};
>  
>  	report_prefix_push("4K");
>  	memset(pagebuf, 42, PAGE_SIZE);
> @@ -97,13 +97,12 @@ static void test_4k_clear(void)
>  static void test_1m_clear(void)
>  {
>  	int i;
> -	union pfmf_r1 r1;
> +	union pfmf_r1 r1 = {
> +		.reg.cf = 1,
> +		.reg.fsc = PFMF_FSC_1M,
> +	};
>  	unsigned long sum = 0;
>  
> -	r1.val = 0;
> -	r1.reg.cf = 1;
> -	r1.reg.fsc = PFMF_FSC_1M;
> -
>  	report_prefix_push("1M");
>  	memset(pagebuf, 42, PAGE_SIZE * 256);
>  	pfmf(r1.val, pagebuf);

