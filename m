Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D27249F5EE
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 10:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbiA1JGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 04:06:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238005AbiA1JGP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 04:06:15 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20S78Ugr015022;
        Fri, 28 Jan 2022 09:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Wm8q/+JIsIHSJxOCXeuK0kGhR+9XYt3i507K3HvkjUA=;
 b=eSAiwYpjadk4azUk6OLaFZygntQSYYPUd2FCtw8tDAHSIl3d0mfwSCgbroqLD7oooskt
 nmhWc0VZ62YDeCxhhMWg1ll9ofQ+Ro5uUybhBjcq37rlhPrRAf3ugCnyiKgYKyDNi74C
 ywPGWrx+eWxP+roTf89hkcPPkR4b4MLRZVk2SZUcG599QnQCznQ0fg15RoP6VdTeCy4w
 vcGfcYrlC9fw17G1uQWgeiyWoZq2i2glaY/Y+3thpjbUbXkACAUye1PYWkaxF07dNucK
 sA7nd8QDJQOT129felS31raHa/J/kmUFnWzpvgqijyjhXPUkzGI0RTX7sXUs2+ohw4B0 sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvak23620-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 09:06:14 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20S9008a000336;
        Fri, 28 Jan 2022 09:06:14 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvak2361b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 09:06:14 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20S92i75014030;
        Fri, 28 Jan 2022 09:06:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3dr96k7hrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 09:06:12 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20S9685h42139994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 09:06:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A45C0AE051;
        Fri, 28 Jan 2022 09:06:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6274CAE056;
        Fri, 28 Jan 2022 09:06:08 +0000 (GMT)
Received: from [9.145.170.148] (unknown [9.145.170.148])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jan 2022 09:06:08 +0000 (GMT)
Message-ID: <af0fd379-4beb-b002-4612-612c6ae85a99@linux.ibm.com>
Date:   Fri, 28 Jan 2022 10:06:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: uv-guest: remove duplicated
 checks
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220127141559.35250-1-seiden@linux.ibm.com>
 <20220127141559.35250-4-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220127141559.35250-4-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uUUdwU0pEbhk2VVitQDQ2lEl9iulWUKW
X-Proofpoint-ORIG-GUID: 13TETGgpp0HDHRWpKm6VstkmCA_BW6km
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-28_01,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 phishscore=0 suspectscore=0 mlxscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201280055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/22 15:15, Steffen Eiden wrote:
> Removing some tests which are done at other points in the code
> implicitly.
> 
> In lib/s390x/uc.c#setup_uv(void) the rc of the qui result is verified
> using asserts.
> The whole test is fenced by lib/s390x/uc.c#os_is_guest(void) which
> checks if SET and REMOVE SHARED is present.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/uv-guest.c | 24 ++++++++----------------
>   1 file changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index 44ad2154..909b7256 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -2,7 +2,7 @@
>   /*
>    * Guest Ultravisor Call tests
>    *
> - * Copyright (c) 2020 IBM Corp
> + * Copyright (c) 2020, 2022 IBM Corp
>    *
>    * Authors:
>    *  Janosch Frank <frankja@linux.ibm.com>
> @@ -69,23 +69,15 @@ static void test_query(void)
>   	cc = uv_call(0, (u64)&uvcb);
>   	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
>   
> -	uvcb.header.len = sizeof(uvcb);
> -	cc = uv_call(0, (u64)&uvcb);
> -	report((!cc && uvcb.header.rc == UVC_RC_EXECUTED) ||
> -	       (cc == 1 && uvcb.header.rc == 0x100),
> -		"successful query");
> -
>   	/*
> -	 * These bits have been introduced with the very first
> -	 * Ultravisor version and are expected to always be available
> -	 * because they are basic building blocks.
> +	 * BIT_UVC_CMD_QUI, BIT_UVC_CMD_SET_SHARED_ACCESS and
> +	 * BIT_UVC_CMD_SET_SHARED_ACCESS are always present as they
> +	 * have been introduced with the first Ultravisor version.
> +	 * However, we only need to check for QUI as
> +	 * SET/REMOVE SHARED are used to fence this test to be only
> +	 * executed by protected guests.
>   	 */
> -	report(test_bit_inv(BIT_UVC_CMD_QUI, &uvcb.inst_calls_list[0]),
> -	       "query indicated");
> -	report(test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, &uvcb.inst_calls_list[0]),
> -	       "share indicated");
> -	report(test_bit_inv(BIT_UVC_CMD_REMOVE_SHARED_ACCESS, &uvcb.inst_calls_list[0]),
> -	       "unshare indicated");
> +	report(uv_query_test_call(BIT_UVC_CMD_QUI), "query indicated");
>   	report_prefix_pop();
>   }
>   
> 

