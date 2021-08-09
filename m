Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009283E43AB
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 12:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhHIKQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 06:16:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46186 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233204AbhHIKQc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 06:16:32 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179A4Ejc135866;
        Mon, 9 Aug 2021 06:16:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KxeUycN4tpeIK/ctQtsUyYZ0kkixPeNTmzJwPm3cztw=;
 b=iAtPZaZfKuHMKmA3RLWvFBEgDChm7JUlXDL3gJM5MnU48xtr9KhKQfFyAUenn5R3sACM
 FnY4S4kHCLpy8/ngjiCvX8eLArV7etZCE5UoyvxUKlmksTpJyHSU51AE9OaI6ziMnua4
 OdKLgsUg2phOcDouEEFM9bbW06YqkHfrWb27lepBqsxNo5n3/FXqN6xjuTFhdZ6RBvXp
 6vHnk7F9Y0PU77nIxoI+3RfNJzcH12fOZ3RqLGySrAzqhNl5aNGutwl9OWnZIyvPTsWf
 ILQ0uEDMYxwvYWGAc153UrRNanfy+21Sf4RLpVhmwh5a/s7Q49t/JMeRsioNrKPFjvM5 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aa78b9sk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 06:16:11 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 179A4E5Q135854;
        Mon, 9 Aug 2021 06:16:11 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aa78b9sjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 06:16:10 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179AC6eW016900;
        Mon, 9 Aug 2021 10:16:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3a9ht8us03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 10:16:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 179AG5u955247194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 10:16:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B22D4A4062;
        Mon,  9 Aug 2021 10:16:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 484C9A4054;
        Mon,  9 Aug 2021 10:16:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.155.74])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 10:16:05 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 2/4] s390x: lib: Move stsi_get_fc to
 library
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
 <1628498934-20735-3-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <d8740bcd-19e0-c5d0-9f31-ba63e4471e4b@linux.ibm.com>
Date:   Mon, 9 Aug 2021 12:16:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1628498934-20735-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2Ag506TJVL7ZM4TzJAkrqhIUpw-P2bLo
X-Proofpoint-GUID: OxsFIGVZOmkLLf4GdVGA_XWptKz3h-it
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_03:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108090075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/21 10:48 AM, Pierre Morel wrote:
> It's needed in multiple tests now.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h | 16 ++++++++++++++++
>  s390x/stsi.c             | 16 ----------------
>  2 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 15cf7d48..57d7ddac 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -328,6 +328,22 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
>  	return cc;
>  }
>  
> +static inline unsigned long stsi_get_fc(void *addr)

We don't need an address for fc == 0. You can remove that and fix the
s390x/stsi.c call.

> +{
> +	register unsigned long r0 asm("0") = 0;
> +	register unsigned long r1 asm("1") = 0;
> +	int cc;
> +
> +	asm volatile("stsi	0(%[addr])\n"
> +		     "ipm	%[cc]\n"
> +		     "srl	%[cc],28\n"
> +		     : "+d" (r0), [cc] "=d" (cc)
> +		     : "d" (r1), [addr] "a" (addr)
> +		     : "cc", "memory");
> +	assert(!cc);
> +	return r0 >> 28;
> +}
> +
>  static inline int servc(uint32_t command, unsigned long sccb)
>  {
>  	int cc;
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index 87d48047..11986d13 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -71,22 +71,6 @@ static void test_priv(void)
>  	report_prefix_pop();
>  }
>  
> -static inline unsigned long stsi_get_fc(void *addr)
> -{
> -	register unsigned long r0 asm("0") = 0;
> -	register unsigned long r1 asm("1") = 0;
> -	int cc;
> -
> -	asm volatile("stsi	0(%[addr])\n"
> -		     "ipm	%[cc]\n"
> -		     "srl	%[cc],28\n"
> -		     : "+d" (r0), [cc] "=d" (cc)
> -		     : "d" (r1), [addr] "a" (addr)
> -		     : "cc", "memory");
> -	assert(!cc);
> -	return r0 >> 28;
> -}
> -
>  static void test_fc(void)
>  {
>  	report(stsi(pagebuf, 7, 0, 0) == 3, "invalid fc");
> 

