Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2A641453F
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhIVJhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:37:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9706 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234426AbhIVJhO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 05:37:14 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M9JaBg018966;
        Wed, 22 Sep 2021 05:35:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=IDcjcjcXFnVCYI6ttp8VAnAPZ34KH2iVgy4IOyIrmvk=;
 b=BFahJezH0z0ZR7+w80aaLFQSlZe8Df4aWf+v0UovF6QSOr4RxwAe2b1JtxGayP8zQItU
 F3727sGMkUYQoqm1usste38bW91eq8WsrVeiFvSjTXMeaSo0Dbh5X94UPMzYJD+BOAus
 R0Qx8eM+312Vh+FIajR/1OUJtznH1MQJJcdwbrjsZ3rCuRzUhf2YixddSgTySPEJU5Ev
 tnvE+eFqFC2RfdkOG02wb/QpXzc52yrKv5XkfXt5DIbZmorc3ump22xjb3hj1rK96OZK
 MMHq0URswj1gPDKfcowcq6qpICLffvPZGVIWXUe/9Wz1PN30nCk+3S5aMP4FXL4STEbj Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7y93ur10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:44 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M9JN44027272;
        Wed, 22 Sep 2021 05:35:44 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7y93ur0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:44 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M9VvMn007982;
        Wed, 22 Sep 2021 09:35:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3b7q6pmvge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 09:35:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M9Zdcn63766798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 09:35:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 227D6AE04D;
        Wed, 22 Sep 2021 09:35:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64BDCAE059;
        Wed, 22 Sep 2021 09:35:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.24])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 09:35:38 +0000 (GMT)
Date:   Wed, 22 Sep 2021 11:12:56 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/9] s390x: uv: Tolerate 0x100 query
 return code
Message-ID: <20210922111256.04febb7e@p-imbrenda>
In-Reply-To: <20210922071811.1913-2-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
        <20210922071811.1913-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mtpbhZ3T2ZBbwZmBHirr28C4aM45esZI
X-Proofpoint-GUID: _IhlKNqz024GFo0s8D1kyQ7KAnVc1V7n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_03,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Sep 2021 07:18:03 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> RC 0x100 is not an error but a notice that we could have gotten more
> data from the Ultravisor if we had asked for it. So let's tolerate
> them in our tests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/uv-guest.c | 4 ++--
>  s390x/uv-host.c  | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index f05ae4c3..e7446e03 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -70,8 +70,8 @@ static void test_query(void)
>  	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
>  
>  	uvcb.header.len = sizeof(uvcb);
> -	cc = uv_call(0, (u64)&uvcb);
> -	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "successful query");
> +	uv_call(0, (u64)&uvcb);
> +	report(uvcb.header.rc == UVC_RC_EXECUTED || uvcb.header.rc
> == 0x100, "successful query");

if you want to be even more pedantic:
	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED ||
		cc == 1 && uvcb.header.rc == 0x100, ... 

>  
>  	/*
>  	 * These bits have been introduced with the very first
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 28035707..66a11160 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -401,7 +401,7 @@ static void test_query(void)
>  
>  	uvcb_qui.header.len = sizeof(uvcb_qui);
>  	uv_call(0, (uint64_t)&uvcb_qui);
> -	report(uvcb_qui.header.rc == UVC_RC_EXECUTED, "successful query");
> +	report(uvcb_qui.header.rc == UVC_RC_EXECUTED || uvcb_qui.header.rc == 0x100, "successful query");

same here

>  
>  	for (i = 0; cmds[i].name; i++)
>  		report(uv_query_test_call(cmds[i].call_bit), "%s", cmds[i].name);

