Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D9E4F8034
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 15:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343590AbiDGNNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 09:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343584AbiDGNNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 09:13:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E3141F9B;
        Thu,  7 Apr 2022 06:11:35 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237COTdi019798;
        Thu, 7 Apr 2022 13:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=scNBQJ1kvc6Uoa+bx7dQRxfV1/8LaND6Two4g9g94yE=;
 b=Ms4ZP9CqmVQ3Alm/vaYJbGnqLg80i7hS1sesDUH8xA7kLM6MeiBibEQyRAxCPumTg6xY
 uScGK/rB+aeIQ6hExKBjVlfmJjA34OkFv3SgUJEOWm3tOejj5ylejgN6vQYMAmsy4SLB
 MbE6K3p8tetZehRIrgciWwKXxAMxV4odZ+qyE6Atxp+sOjep3zilhKv0YhrqCX2hXnFs
 n7xSbQI3tbU6QpjgE9h9Uj4EnP4Jh8qcTYsyhWjM37bQ3gBPcf3wl6NP8nC+w0B6/cZW
 7u/tOUz0rw1ioVk8Il6foiBQnstqeksMWENOvdkTC9NscZh/sUpSbYCH1MyffjUQTrzZ JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9yw7h7kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 13:11:34 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 237D2cpH028423;
        Thu, 7 Apr 2022 13:11:34 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9yw7h7j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 13:11:34 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 237CvtHW013790;
        Thu, 7 Apr 2022 13:11:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3f6e49060a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 13:11:31 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 237DBSmU25231812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 13:11:28 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5A8EAE04D;
        Thu,  7 Apr 2022 13:11:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 538C0AE053;
        Thu,  7 Apr 2022 13:11:28 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.20])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 13:11:28 +0000 (GMT)
Date:   Thu, 7 Apr 2022 15:11:26 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3] s390x: diag308: Only test subcode 2
 under QEMU
Message-ID: <20220407151126.284f4e73@p-imbrenda>
In-Reply-To: <20220407130252.15603-1-frankja@linux.ibm.com>
References: <20220407114253.5cb6f2aa@p-imbrenda>
        <20220407130252.15603-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: glGQqrA-yRs4ZT1Pu2bwULiY2cxqzDHu
X-Proofpoint-ORIG-GUID: 4zP5_dHj11SJiMfTc1SvRBT71NorZKiK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-07_01,2022-04-07_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  7 Apr 2022 13:02:52 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Other hypervisors might implement it and therefore not send a
> specification exception.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/diag308.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/diag308.c b/s390x/diag308.c
> index c9d6c499..ea41b455 100644
> --- a/s390x/diag308.c
> +++ b/s390x/diag308.c
> @@ -8,6 +8,7 @@
>  #include <libcflat.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
> +#include <hardware.h>
>  
>  /* The diagnose calls should be blocked in problem state */
>  static void test_priv(void)
> @@ -75,7 +76,7 @@ static void test_subcode6(void)
>  /* Unsupported subcodes should generate a specification exception */
>  static void test_unsupported_subcode(void)
>  {
> -	int subcodes[] = { 2, 0x101, 0xffff, 0x10001, -1 };
> +	int subcodes[] = { 0x101, 0xffff, 0x10001, -1 };
>  	int idx;
>  
>  	for (idx = 0; idx < ARRAY_SIZE(subcodes); idx++) {
> @@ -85,6 +86,21 @@ static void test_unsupported_subcode(void)
>  		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>  		report_prefix_pop();
>  	}
> +
> +	/*
> +	 * Subcode 2 is not available under QEMU but might be on other
> +	 * hypervisors so we only check for the specification
> +	 * exception on QEMU.
> +	 */
> +	report_prefix_pushf("0x%04x", 2);
> +	if (host_is_qemu()) {
> +		expect_pgm_int();
> +		asm volatile ("diag %0,%1,0x308" :: "d"(0), "d"(2));
> +		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	} else {
> +		report_skip("subcode is supported");
> +	}
> +	report_prefix_pop();
>  }
>  
>  static struct {

