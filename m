Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F0A414B1D
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 15:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhIVNzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 09:55:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57126 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232832AbhIVNzB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 09:55:01 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18MC69Ua009162;
        Wed, 22 Sep 2021 09:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7f6GPRDdDyd6Fk9IImEun7vElAtKqXzDzJDCnVK0juk=;
 b=LBKdfPn567OVxTIVsnC70wuW3Gwjc84LrB5RQyhtbMVknC1wOwRCDEwCmGDLsjafgAoR
 df6ozzRH18hDB3h8uG2mEoLvxDNqm9lg8IAIO1snH8zPWYPX+8GotVeuFPtpKBpLvIJB
 JEU9JCkFPNNt32MfLBtagRuCAJbpnYEzvsfUI9NOiqEp8Zpo87j5IcIILUXYerFudY5j
 fXc0F0trgRIQ0l0tpnt7SNt1Ay0kbS3ycYYZYCyqnyeTwBLRtQ+ZcTkqPaWkQ2biSioe
 E2DptWoVesgm7HZ0eD2WmWeTxtSI3TSyo8mDXcLNfcYYFT803TEJ2jsLV8BdfSTcKrdR +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b8230wx1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 09:53:31 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18MCR8hH001340;
        Wed, 22 Sep 2021 09:53:30 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b8230wx19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 09:53:30 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18MDlxfv022700;
        Wed, 22 Sep 2021 13:53:28 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3b7q6pqj4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 13:53:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18MDmXLD45744546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 13:48:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4D854C04E;
        Wed, 22 Sep 2021 13:53:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 518914C046;
        Wed, 22 Sep 2021 13:53:23 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.85.176])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 13:53:23 +0000 (GMT)
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org,
        seiden@linux.ibm.com, imbrenda@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-10-frankja@linux.ibm.com>
 <20210922134112.174842-1-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 9/9] s390x: skrf: Fix tprot assembly
Message-ID: <1472bd3a-f72e-16d0-4b99-cb3863b4a7bf@linux.ibm.com>
Date:   Wed, 22 Sep 2021 15:53:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922134112.174842-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KhbhahjLl045c4zVZhVN7CFhlPnHQRyL
X-Proofpoint-ORIG-GUID: EvzXLecY1eNJy8mVfmzMhrJkKfPR6vnS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_05,2021-09-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 impostorscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/21 3:41 PM, Janis Schoetterl-Glausch wrote:
> On Wed, Sep 22, 2021 at 07:18:11AM +0000, Janosch Frank wrote:
>> It's a base + displacement address so we need to address it via 0(%[addr]).
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/skrf.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/s390x/skrf.c b/s390x/skrf.c
>> index 8ca7588c..84fb762c 100644
>> --- a/s390x/skrf.c
>> +++ b/s390x/skrf.c
>> @@ -103,7 +103,7 @@ static void test_tprot(void)
>>  {
>>  	report_prefix_push("tprot");
>>  	expect_pgm_int();
>> -	asm volatile("tprot	%[addr],0xf0(0)\n"
>> +	asm volatile("tprot	0(%[addr]),0xf0(0)\n"
>>  		     : : [addr] "a" (pagebuf) : );
>>  	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
>>  	report_prefix_pop();
>> -- 
>> 2.30.2
>>
> 
> Let's add an argument to tprot instead.

Sure, LGTM

> -- >8 --
> Subject: [kvm-unit-tests PATCH] lib: s390x: Add access key argument to tprot
> 
> Currently there is only one callee passing a non zero key,
> but having the argument will be useful in the future.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h | 6 +++---
>  lib/s390x/sclp.c         | 2 +-
>  s390x/skrf.c             | 3 +--
>  3 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 302ef1f..55f3124 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -206,15 +206,15 @@ static inline unsigned short stap(void)
>  	return cpu_address;
>  }
>  
> -static inline int tprot(unsigned long addr)
> +static inline int tprot(unsigned long addr, char access_key)
>  {
>  	int cc;
>  
>  	asm volatile(
> -		"	tprot	0(%1),0\n"
> +		"	tprot	0(%1),0(%2)\n"
>  		"	ipm	%0\n"
>  		"	srl	%0,28\n"
> -		: "=d" (cc) : "a" (addr) : "cc");
> +		: "=d" (cc) : "a" (addr), "a" (access_key << 4) : "cc");
>  	return cc;
>  }
>  
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 9502d16..0272249 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -217,7 +217,7 @@ void sclp_memory_setup(void)
>  	/* probe for r/w memory up to max memory size */
>  	while (ram_size < max_ram_size) {
>  		expect_pgm_int();
> -		cc = tprot(ram_size + storage_increment_size - 1);
> +		cc = tprot(ram_size + storage_increment_size - 1, 0);
>  		/* stop once we receive an exception or have protected memory */
>  		if (clear_pgm_int() || cc != 0)
>  			break;
> diff --git a/s390x/skrf.c b/s390x/skrf.c
> index 9488c32..e0a1007 100644
> --- a/s390x/skrf.c
> +++ b/s390x/skrf.c
> @@ -102,8 +102,7 @@ static void test_tprot(void)
>  {
>  	report_prefix_push("tprot");
>  	expect_pgm_int();
> -	asm volatile("tprot	%[addr],0xf0(0)\n"
> -		     : : [addr] "a" (pagebuf) : );
> +	tprot((unsigned long)pagebuf, 0xf);
>  	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
>  	report_prefix_pop();
>  }
> 

