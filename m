Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51003E942C
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 17:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbhHKPBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 11:01:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35915 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232601AbhHKPBj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 11:01:39 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17BEorfm090530;
        Wed, 11 Aug 2021 11:01:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KyxpH/ASsCS7XLLj6aQoXJAhGOy0eEgnF7YxXBDrUtk=;
 b=TT3kpHQ0+5T7rilPv+O9DQtpCGVOCUdg2ZOCEuUftwPS/1GtL0FJ8Gcflg6Ing9f9Y/0
 8SAxCc2Zsz2pdhrsg/uEX1ZxW++AA5p6fU/ZoDSeJBUhSdWetjI/7ePhbkfeCGD+xXoz
 m05OSW3t0IQFNPnO2XvhOda8sU8AniFK6vHGxb1tORS2cjV2CeApSMoX7r6JCo+MTgY5
 8c/mh6Vr7SgIugU28FfZD29mJodU61A00IYZEcJdRigj3uaK/tMuHUBNJ8kfiiW1IO3a
 e6bGtsSGCD2Q10jqurWJD5L/BmPWzjrH+rxKl3MgYyWaR4kZ0hmMsG64PodjabFdD4J3 yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3abt14kbsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 11:01:14 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17BEqdf6096140;
        Wed, 11 Aug 2021 11:01:14 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3abt14kbk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 11:01:13 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17BEv6V2017032;
        Wed, 11 Aug 2021 15:01:06 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3abs261y7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 15:01:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17BF13R455771426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Aug 2021 15:01:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1F884C072;
        Wed, 11 Aug 2021 15:01:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99DB44C05A;
        Wed, 11 Aug 2021 15:01:02 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.12.48])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Aug 2021 15:01:02 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/4] s390x: lib: Simplify stsi_get_fc
 and move it to library
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
 <1628612544-25130-3-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <b38410e3-5248-4e48-6577-c57673e89378@linux.ibm.com>
Date:   Wed, 11 Aug 2021 17:01:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1628612544-25130-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9S42jzNhgcY0LH4SswyCcCLqlWe6sNPP
X-Proofpoint-GUID: qhDdE2Sh4VWP5sgAsbO8ZhJvmy9U5HFY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-11_05:2021-08-11,2021-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108110098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/21 6:22 PM, Pierre Morel wrote:
> stsi_get_fc is now needed in multiple tests.
> 
> As it does not need to store information but only returns
> the machine level, suppress the address parameter.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Please push this one to devel for coverage:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h | 16 ++++++++++++++++
>  s390x/stsi.c             | 20 ++------------------
>  2 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 15cf7d48..2f70d840 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -328,6 +328,22 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
>  	return cc;
>  }
>  
> +static inline unsigned long stsi_get_fc(void)
> +{
> +	register unsigned long r0 asm("0") = 0;
> +	register unsigned long r1 asm("1") = 0;
> +	int cc;
> +
> +	asm volatile("stsi	0\n"
> +		     "ipm	%[cc]\n"
> +		     "srl	%[cc],28\n"
> +		     : "+d" (r0), [cc] "=d" (cc)
> +		     : "d" (r1)
> +		     : "cc", "memory");
> +	assert(!cc);
> +	return r0 >> 28;
> +}
> +
>  static inline int servc(uint32_t command, unsigned long sccb)
>  {
>  	int cc;
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index 87d48047..391f8849 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -71,28 +71,12 @@ static void test_priv(void)
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
>  	report(stsi(pagebuf, 1, 0, 1) == 3, "invalid selector 1");
>  	report(stsi(pagebuf, 1, 1, 0) == 3, "invalid selector 2");
> -	report(stsi_get_fc(pagebuf) >= 2, "query fc >= 2");
> +	report(stsi_get_fc() >= 2, "query fc >= 2");
>  }
>  
>  static void test_3_2_2(void)
> @@ -112,7 +96,7 @@ static void test_3_2_2(void)
>  	report_prefix_push("3.2.2");
>  
>  	/* Is the function code available at all? */
> -	if (stsi_get_fc(pagebuf) < 3) {
> +	if (stsi_get_fc() < 3) {
>  		report_skip("Running under lpar, no level 3 to test.");
>  		goto out;
>  	}
> 

