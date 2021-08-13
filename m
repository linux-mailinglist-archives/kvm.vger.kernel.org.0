Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F4C3EB32F
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 11:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbhHMJKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 05:10:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61384 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231582AbhHMJK3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 05:10:29 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D92eEI143255;
        Fri, 13 Aug 2021 05:10:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=b29VkJErX6ra9h9tsHECxctrIURbLf9Ni0uQJc+Xv3g=;
 b=jjy4XptpjExWgdvLblM0sWEIVdTKRb2PRqD6ed+pGDPXPQR4VOHJdVyFy9qLf+mPbBVG
 By9IwCfAd5NqsxoKVYLdGjhZX/SgvI10wXpstG6yCmv0GOk7aatDo3I4xoSDLvechkxC
 xdBVh0WPq1kS6Nn+3kznu3gOlsyybRpV47FUwDdt/mI328050ybt3VyjIPJBP5eCkXJG
 nqZQUlnsmGBtyfmR7LDKtssziLWy4Tqv7DoBbXZgEnMg/rVHXPctEv7OaOxwOmWcqv28
 Mp9F3RKb+eaXI/FqWm7zyO7Q1CVvpzaD5COyafXA2IoYkiYEycy8XpebRi7/WzYDpjUN 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad0qyu2px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 05:10:03 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D92oEu143910;
        Fri, 13 Aug 2021 05:10:02 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad0qyu2np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 05:10:02 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D98UCd029771;
        Fri, 13 Aug 2021 09:10:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ada8sgq0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 09:10:00 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D96dlP39190998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:06:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E29E11C071;
        Fri, 13 Aug 2021 09:09:57 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4554211C058;
        Fri, 13 Aug 2021 09:09:57 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.2.79])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 09:09:57 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 7/8] lib: s390x: Control register constant
 cleanup
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <20210813073615.32837-1-frankja@linux.ibm.com>
 <20210813073615.32837-8-frankja@linux.ibm.com>
 <20210813104946.7e5b426f@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <927dbc05-c15c-a468-47f0-42af2e8d4ee4@linux.ibm.com>
Date:   Fri, 13 Aug 2021 11:09:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210813104946.7e5b426f@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XFHuxIrZ-lp-Cbx0ucpLngSNgN8HKwxQ
X-Proofpoint-ORIG-GUID: e2e1zW_7yo4HnK6UeFYLZbP99YOm_iZT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_03:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 clxscore=1015 phishscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108130054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/13/21 10:49 AM, Claudio Imbrenda wrote:
> On Fri, 13 Aug 2021 07:36:14 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> We had bits and masks defined and don't necessarily need both.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/asm/arch_def.h | 29 +++++++++++++----------------
>>  lib/s390x/smp.c          |  2 +-
>>  s390x/skrf.c             |  2 +-
>>  3 files changed, 15 insertions(+), 18 deletions(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 245453c3..4574a166 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -54,10 +54,19 @@ struct psw {
>>  #define PSW_MASK_BA			0x0000000080000000UL
>>  #define PSW_MASK_64			PSW_MASK_BA | PSW_MASK_EA;
>>  
>> -#define CR0_EXTM_SCLP			0x0000000000000200UL
>> -#define CR0_EXTM_EXTC			0x0000000000002000UL
>> -#define CR0_EXTM_EMGC			0x0000000000004000UL
>> -#define CR0_EXTM_MASK			0x0000000000006200UL
>> +#define CTL0_LOW_ADDR_PROT		(63 - 35)
>> +#define CTL0_EDAT			(63 - 40)
>> +#define CTL0_IEP			(63 - 43)
>> +#define CTL0_AFP			(63 - 45)
>> +#define CTL0_VECTOR			(63 - 46)
>> +#define CTL0_EMERGENCY_SIGNAL		(63 - 49)
>> +#define CTL0_EXTERNAL_CALL		(63 - 50)
>> +#define CTL0_CLOCK_COMPARATOR		(63 - 52)
>> +#define CTL0_SERVICE_SIGNAL		(63 - 54)
>> +#define CR0_EXTM_MASK			0x0000000000006200UL /*
>> Combined external masks */
>> +#define BIT_TO_MASK64(x)		1UL << x
> 
> don't we already have BIT and BIT_ULL?

Right, I should have looked first...
Will fix!

> 
>> +#define CTL2_GUARDED_STORAGE		(63 - 59)
>>  
>>  struct lowcore {
>>  	uint8_t		pad_0x0000[0x0080 - 0x0000];
>> /* 0x0000 */ @@ -239,18 +248,6 @@ static inline uint64_t stctg(int cr)
>>  	return value;
>>  }
>>  
>> -#define CTL0_LOW_ADDR_PROT	(63 - 35)
>> -#define CTL0_EDAT		(63 - 40)
>> -#define CTL0_IEP		(63 - 43)
>> -#define CTL0_AFP		(63 - 45)
>> -#define CTL0_VECTOR		(63 - 46)
>> -#define CTL0_EMERGENCY_SIGNAL	(63 - 49)
>> -#define CTL0_EXTERNAL_CALL	(63 - 50)
>> -#define CTL0_CLOCK_COMPARATOR	(63 - 52)
>> -#define CTL0_SERVICE_SIGNAL	(63 - 54)
>> -
>> -#define CTL2_GUARDED_STORAGE	(63 - 59)
>> -
>>  static inline void ctl_set_bit(int cr, unsigned int bit)
>>  {
>>          uint64_t reg;
>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>> index 228fe667..c2c6ffec 100644
>> --- a/lib/s390x/smp.c
>> +++ b/lib/s390x/smp.c
>> @@ -204,7 +204,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
>>  	cpu->lowcore->sw_int_grs[15] = (uint64_t)cpu->stack +
>> (PAGE_SIZE * 4); lc->restart_new_psw.mask = PSW_MASK_64;
>>  	lc->restart_new_psw.addr = (uint64_t)smp_cpu_setup_state;
>> -	lc->sw_int_crs[0] = 0x0000000000040000UL;
>> +	lc->sw_int_crs[0] = BIT_TO_MASK64(CTL0_AFP);
>>  
>>  	/* Start processing */
>>  	smp_cpu_restart_nolock(addr, NULL);
>> diff --git a/s390x/skrf.c b/s390x/skrf.c
>> index 9488c32b..a350ada6 100644
>> --- a/s390x/skrf.c
>> +++ b/s390x/skrf.c
>> @@ -125,8 +125,8 @@ static void ecall_cleanup(void)
>>  {
>>  	struct lowcore *lc = (void *)0x0;
>>  
>> -	lc->sw_int_crs[0] = 0x0000000000040000;
>>  	lc->ext_new_psw.mask = PSW_MASK_64;
>> +	lc->sw_int_crs[0] = BIT_TO_MASK64(CTL0_AFP);
>>  
>>  	/*
>>  	 * PGM old contains the ext new PSW, we need to clean it up,
> 

