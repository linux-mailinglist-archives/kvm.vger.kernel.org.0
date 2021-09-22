Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A69A414543
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbhIVJhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:37:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234436AbhIVJhU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 05:37:20 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M70Oqp016027;
        Wed, 22 Sep 2021 05:35:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=cI02JALUurSLBMbwJQRmC7CGq+JJQOaYXAf22NGUGxk=;
 b=sapsR9HKjZE8JPsUd3+OLSf0v/smsGZOH1xVB8uLWcaeGRtLrQ750I+UnOc05Db+gS7L
 WYLgVCnNQ7adTkqej/n1sahrfg2ENp1XTdVZou8O0k8jILGUkog6V+mgNU3bUEkflKo2
 3Sc1S4gva6LM8sYuqAdB6kTT5X++8+ejk/lgYiQfqHVDjI3gCYy1gtWrIx9durzVe3GO
 4R/H+RThQ2Nv5x6/WbPgueWohnOMZtBeAZM16n9y5uejvD4DO1YJrYfWMY32EBC8gI9u
 FUmCwlPCEfp2vNuFYFMsG/APR62mmJUbJOwzP4eoPw52v7+PwDakzL+tl+BlWuELmvTB Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7yqhb5x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:50 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M93pCA005949;
        Wed, 22 Sep 2021 05:35:49 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7yqhb5wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:49 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M9Wuwd014243;
        Wed, 22 Sep 2021 09:35:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3b7q66cmd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 09:35:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M9Zisn9109982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 09:35:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D4CAAE057;
        Wed, 22 Sep 2021 09:35:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E38B7AE045;
        Wed, 22 Sep 2021 09:35:43 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.24])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 09:35:43 +0000 (GMT)
Date:   Wed, 22 Sep 2021 11:24:34 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 6/9] lib: s390x: Print PGM code as hex
Message-ID: <20210922112434.4b914ccb@p-imbrenda>
In-Reply-To: <20210922071811.1913-7-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
        <20210922071811.1913-7-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: L44uv54JvLJ-ceprvsf8LpvX1tqFF4fu
X-Proofpoint-ORIG-GUID: LgH9adk3n3nktHlYe5RxiVb7-yoXEP3N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_03,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 malwarescore=0 impostorscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Sep 2021 07:18:08 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> We have them defined as hex constants in lib/s390x/asm/arch_def.h so
> why not print them as hex values?
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/interrupt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 126d4c0a..27d3b767 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -169,7 +169,7 @@ static void print_pgm_info(struct stack_frame_int *stack)
>  		  lc->pgm_old_psw.addr <= (uintptr_t)sie_exit);
>  
>  	printf("\n");
> -	printf("Unexpected program interrupt %s: %d on cpu %d at %#lx, ilen %d\n",
> +	printf("Unexpected program interrupt %s: %#x on cpu %d at %#lx, ilen %d\n",
>  	       in_sie ? "in SIE" : "",
>  	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr, lc->pgm_int_id);
>  	print_int_regs(stack);

