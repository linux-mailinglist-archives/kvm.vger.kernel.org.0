Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8127E41453D
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhIVJhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:37:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41198 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234388AbhIVJhN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 05:37:13 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M80aF3029224;
        Wed, 22 Sep 2021 05:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1qehM8NKMfNJcBQOyakbw6L+bnhEY5Zr5z5Wv3Sjm1s=;
 b=F7buMNIght93koiJLFIvc/NNn3RFQ43zpwHCIN81ahU1uLsYq2Fi6R7tiwMs2PUzslMe
 HiJwvBVwxrX0iSmezfcUf0yOYqVZSjtMO7nQ0wMwAO0zbJEYkHzoNDOx6C1RGRYQi7oT
 cS9Jm97lcHmy1+VSK0yph430K+ibCLELOFZ6DOoITpz0iAvYKmFbs8y03v9nlWsmuHS1
 hOL+s7jFfDbuWUGMrrGM+HedFQ/iWBbBEyhi7Oy28TtS7mpc59PGgALCsnmTeIkXEVi3
 GFqqTVs/yACHF4hpLZG9FRgA3RZRPe84I+rha1AQCDIQbGWMTAK0vDR/e7l3JDsYjFxn /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b80kr9yq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:43 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M8Ru5m006675;
        Wed, 22 Sep 2021 05:35:42 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b80kr9ype-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:42 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M9VqWQ025276;
        Wed, 22 Sep 2021 09:35:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3b7q6nmv29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 09:35:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M9Uoak51970540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 09:30:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0AB7AE056;
        Wed, 22 Sep 2021 09:35:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21869AE05A;
        Wed, 22 Sep 2021 09:35:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.24])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 09:35:36 +0000 (GMT)
Date:   Wed, 22 Sep 2021 11:34:59 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 9/9] s390x: skrf: Fix tprot assembly
Message-ID: <20210922113459.56737df3@p-imbrenda>
In-Reply-To: <20210922071811.1913-10-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
        <20210922071811.1913-10-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ohpbl40oOlP-gG2ThfUq2YpChstPtoMX
X-Proofpoint-ORIG-GUID: 72yWcRWxX2Qw5aM16M1awaFPFmMRIpSS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_03,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Sep 2021 07:18:11 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> It's a base + displacement address so we need to address it via 0(%[addr]).
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

but see comment below

> ---
>  s390x/skrf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/skrf.c b/s390x/skrf.c
> index 8ca7588c..84fb762c 100644
> --- a/s390x/skrf.c
> +++ b/s390x/skrf.c
> @@ -103,7 +103,7 @@ static void test_tprot(void)
>  {
>  	report_prefix_push("tprot");
>  	expect_pgm_int();
> -	asm volatile("tprot	%[addr],0xf0(0)\n"
> +	asm volatile("tprot	0(%[addr]),0xf0(0)\n"

I think the displacement defaults to 0 if not specified?

did you get a warning, or why are you changing this now?

>  		     : : [addr] "a" (pagebuf) : );
>  	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
>  	report_prefix_pop();

