Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120184F7BFF
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 11:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243897AbiDGJpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 05:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243913AbiDGJpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 05:45:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BC8206EDF;
        Thu,  7 Apr 2022 02:43:25 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23780pnk023353;
        Thu, 7 Apr 2022 09:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=vOrKx2vQqR4qussWSll2ECYl9QpKhC2w/NYCKbusm7o=;
 b=pvExi/sp3x9lii9bmuEZuHTyfu67j/9N3uLd8wHUzMo0M1dxoFv95HRfuy9b0FGEya0F
 DJs7EAIeZml7Yl1FG/8+KUHRhZJQAPrcg44CXYkdxg5SzW39/qPIohFVwLZ659auMEhk
 2WxErqB2WO0yIWx5CPsNyClta1xylf+WgjD+ziF0ZOaBikQ1VTvrKo/RnbtGYVKz34fD
 DK2L+KYdfFy0ujq+qviWEamaaHlZeyxJ48HJBPeEWcnZrPyHF5oh99ZCnOUVkKDebSFo
 LWTiXvMMGc4OUTqvj7aoy+rwjzh6xZjjfIMIWpw05QXyDLl9CtFhSX7oE500DkAo0+Hr gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f98yp16gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 09:43:25 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2379S7lS013064;
        Thu, 7 Apr 2022 09:43:24 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f98yp16g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 09:43:24 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2379SVGi014126;
        Thu, 7 Apr 2022 09:43:22 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3f6e48yv56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 09:43:22 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2379hQlJ40763788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 09:43:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2F9611C050;
        Thu,  7 Apr 2022 09:43:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73CED11C052;
        Thu,  7 Apr 2022 09:43:18 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.20])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 09:43:18 +0000 (GMT)
Date:   Thu, 7 Apr 2022 11:42:53 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/9] s390x: diag308: Only test subcode
 2 under QEMU
Message-ID: <20220407114253.5cb6f2aa@p-imbrenda>
In-Reply-To: <20220407084421.2811-4-frankja@linux.ibm.com>
References: <20220407084421.2811-1-frankja@linux.ibm.com>
        <20220407084421.2811-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tD1Cv2m3NYAVQkLE5KPmkac7Iabwi_3V
X-Proofpoint-ORIG-GUID: lZ32NK4dANKQvovpa3EqA0llLp7Y18Zh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  7 Apr 2022 08:44:15 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Other hypervisors might implement it and therefore not send a
> specification exception.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/diag308.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/diag308.c b/s390x/diag308.c
> index c9d6c499..ae5f5a5f 100644
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
> @@ -85,6 +86,18 @@ static void test_unsupported_subcode(void)
>  		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>  		report_prefix_pop();
>  	}
> +
> +	/*
> +	 * Subcode 2 is not available under QEMU but might be on other
> +	 * hypervisors.
> +	 */
> +	if (host_is_qemu()) {
> +		report_prefix_pushf("0x%04x", 2);
> +		expect_pgm_int();
> +		asm volatile ("diag %0,%1,0x308" :: "d"(0), "d"(2));
> +		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +		report_prefix_pop();
> +	}

move the prefix push and pop outside of the if, then add 

else {
	report_skip(...);
}

>  }
>  
>  static struct {

