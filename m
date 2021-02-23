Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEB9322DC6
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 16:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhBWPpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 10:45:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232209AbhBWPpe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 10:45:34 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NFWvmN119783;
        Tue, 23 Feb 2021 10:44:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=S6v1DHJgN2240quQzI87vbj/WnG5yMqlNJ1/R6YhXBQ=;
 b=pwC1IOaFg+FuD5JITQlrGol9K7mgJZ3DeYELRwGKHayiqM2WhQSo8LsSPozMQEZk72f3
 ZRfpujDyG0nuvEJW7/duKk7DD1Zl5BZn1anNxt/KvzPNYtqf5931oXmyJmC2+yCCNJxx
 KwzyQ0KDqrN14ZcB7YrKWhLn2tdfYG/dg7cWTBLYS0lQBNELh/0fuYmpQd/CZJP+ZaOi
 WeVTYMCkWsZzIyRPCMYac3KrA27dOXfbBdiTfXZucbd83khBYJt2gweS8iB01rW4VKBr
 KYnXadYVzEYN50X5XYABETkDwRksOhmuc3EZF1cPC8U9hmqQZtLlPwuWCXteIk3xJS6X hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkg3615r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 10:44:50 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NFXZQY122775;
        Tue, 23 Feb 2021 10:44:50 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkg3614t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 10:44:50 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NFgq5e002967;
        Tue, 23 Feb 2021 15:44:47 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 36tt28ar4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 15:44:47 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NFiWLq18547000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 15:44:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98DC8A4054;
        Tue, 23 Feb 2021 15:44:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30EBBA4065;
        Tue, 23 Feb 2021 15:44:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.67.183])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 15:44:44 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, pmorel@linux.ibm.com
References: <20210223140759.255670-1-imbrenda@linux.ibm.com>
 <20210223140759.255670-3-imbrenda@linux.ibm.com>
 <518e0f86-bbba-bd52-3962-2816b2f8ccf6@linux.ibm.com>
 <20210223162116.12fbd4ad@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/5] s390x: lib: fix pgtable.h
Message-ID: <acdcd652-55ef-0573-f51a-4b6a1c9434fa@linux.ibm.com>
Date:   Tue, 23 Feb 2021 16:44:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223162116.12fbd4ad@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 bulkscore=0 spamscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102230131
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/21 4:21 PM, Claudio Imbrenda wrote:
> On Tue, 23 Feb 2021 15:31:06 +0100
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 2/23/21 3:07 PM, Claudio Imbrenda wrote:
>>> Fix pgtable.h:
>>>
>>> * SEGMENT_ENTRY_SFAA had one extra bit set
>>> * pmd entries don't have a length
>>> * ipte does not need to clear the lower bits
>>> * pud entries should use SEGMENT_TABLE_LENGTH, as they point to
>>> segment tables
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>  lib/s390x/asm/pgtable.h | 9 ++++-----
>>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
>>> index 277f3480..a2ff2d4e 100644
>>> --- a/lib/s390x/asm/pgtable.h
>>> +++ b/lib/s390x/asm/pgtable.h
>>> @@ -60,7 +60,7 @@
>>>  #define SEGMENT_SHIFT			20
>>>  
>>>  #define SEGMENT_ENTRY_ORIGIN		0xfffffffffffff800UL
>>> -#define SEGMENT_ENTRY_SFAA		0xfffffffffff80000UL
>>> +#define SEGMENT_ENTRY_SFAA		0xfffffffffff00000UL
>>>  #define SEGMENT_ENTRY_AV		0x0000000000010000UL
>>>  #define SEGMENT_ENTRY_ACC		0x000000000000f000UL
>>>  #define SEGMENT_ENTRY_F			0x0000000000000800UL
>>> @@ -183,7 +183,7 @@ static inline pmd_t *pmd_alloc(pud_t *pud,
>>> unsigned long addr) if (pud_none(*pud)) {
>>>  		pmd_t *pmd = pmd_alloc_one();
>>>  		pud_val(*pud) = __pa(pmd) |
>>> REGION_ENTRY_TT_REGION3 |
>>> -				REGION_TABLE_LENGTH;
>>> +				SEGMENT_TABLE_LENGTH;  
>>
>> @David: I'd much rather have REGION_ENTRY_LENGTH instead of
>> REGION_TABLE_LENGTH and SEGMENT_TABLE_LENGTH.
> 
> I'm weakly against it
> 
>> My argument is that this is not really an attribute of the table and
> 
> it actually is an attribute of the table. the *_TABLE_LENGTH fields
> tell how long the _table pointed to_ is. we always allocate the full 4
> pages, so in our case it will always be 0x3.
> 

It's part of the entry nevertheless and should not be a *_TABLE_*
constant. It's used in entries and has a very specific format that only
makes sense if it's being used in a region entry.

Every other thing that you or into the entry apart from the address is
named *_ENTRY_* so this should be too.

> segment table entries don't have a length because they point to page
> tables. region3 table entries point to segment tables, so they have
> SEGMENT_TABLE_LENGTH in their length field.

Btw. I'd guess the SEGMENT_TABLE_LENGTH name is the reason that you had
to fix the problem in the next hunk...

>> very much specific to the format of the (region table) entry. We
>> already have the table order as a length anyway...
>>
>> Could you tell me what you had in mind when splitting this?
>>
>>>  	}
>>>  	return pmd_offset(pud, addr);
>>>  }
>>> @@ -202,15 +202,14 @@ static inline pte_t *pte_alloc(pmd_t *pmd,
>>> unsigned long addr) {
>>>  	if (pmd_none(*pmd)) {
>>>  		pte_t *pte = pte_alloc_one();
>>> -		pmd_val(*pmd) = __pa(pte) |
>>> SEGMENT_ENTRY_TT_SEGMENT |
>>> -				SEGMENT_TABLE_LENGTH;
>>> +		pmd_val(*pmd) = __pa(pte) |
>>> SEGMENT_ENTRY_TT_SEGMENT;  
>>
>> Uhhhh good catch!
>>
>>>  	}
>>>  	return pte_offset(pmd, addr);
>>>  }
>>>  
>>>  static inline void ipte(unsigned long vaddr, pteval_t *p_pte)
>>>  {
>>> -	unsigned long table_origin = (unsigned long)p_pte &
>>> PAGE_MASK;
>>> +	unsigned long table_origin = (unsigned long)p_pte;
>>>  
>>>  	asm volatile(
>>>  		"	ipte %0,%1\n"
>>>   
>>
>> IPTE ignores that data but having the page mask also doesn't hurt so
>> generally this is not a fix, right?
> 
> apart from avoiding an unnecessary operation, there is a small nit:
> IPTE wants the address of the page table, ignoring the rightmost _11_
> bits. with PAGE_MASK we ignore the rightmost _12_ bits instead.
> it's not an issue in practice, because we allocate one page table per
> page anyway, wasting the second half of the page, so in our case that
> stray bit will always be 0. but in case we decide to allocate the page
> tables more tightly, or in case some testcase wants to manually play
> tricks with the page tables, there might be the risk that IPTE would
> target the wrong page table.
> 
> by not clearing the lower 12 bits we not only save an unnecessary
> operation, but we are actually more architecturally correct.
> 

Right, the old 2k pgtable thing...
Would you mind putting that into the patch description?

