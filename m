Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9622639314B
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 16:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhE0Os6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 10:48:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229883AbhE0Oso (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 10:48:44 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14REca9f023170;
        Thu, 27 May 2021 10:47:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=74O1dA9NynbV/4AlfafLxagiq2rtCQGjc8nILwu0TCc=;
 b=XHreomd/gLqD86Ja8DURpnbaSZ3f8yu00ZUYgvZDJ4gnAVRmFw+iBf6dkWJAzL5WRNzI
 +r6NJOvjsOzMk1NyjGF+PFH0OMwQaTY9PyT4/5k1pTo7VWwIktpE5DRKnlRrr/vYAJWf
 xWcSMOm4TrU62jZX9mDtnnYvqCUccozhYFKAdI0IhHlwEPwSL0/+IuXBGmj0INf9hocQ
 UVOow3ALrGwRVegBRH3nBiG17NsntmAustAk/aNYEgPJhye0NQ+oGLTr0rhymG6yuD44
 09X23InfQc7Gde6jTA9AcEJSKlEw99Ie+49H3P27ZXlapTyZTL7u35/P5PKDRPmwO4Ih XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38tahjxw09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 10:47:07 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14REcmFU024475;
        Thu, 27 May 2021 10:47:06 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38tahjxvyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 10:47:06 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14REiF1D018410;
        Thu, 27 May 2021 14:47:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 38s1ht0pps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 14:47:04 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14REl2SR20578630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 14:47:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30CFB11C04C;
        Thu, 27 May 2021 14:47:02 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C25EA11C04A;
        Thu, 27 May 2021 14:47:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.86.253])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 May 2021 14:47:01 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 3/7] s390x: lib: fix pgtable.h
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <20210526134245.138906-1-imbrenda@linux.ibm.com>
 <20210526134245.138906-4-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <df7c33e0-54cb-f1ee-c905-76c142b3e043@linux.ibm.com>
Date:   Thu, 27 May 2021 16:47:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210526134245.138906-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1T_owBlY5J8iNCRHNzubYMiUh1brplV1
X-Proofpoint-ORIG-GUID: ZS31EXcw_EGD0oq_x38bJcGUQdJcOrjD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_07:2021-05-27,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 impostorscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/26/21 3:42 PM, Claudio Imbrenda wrote:
> Fix pgtable.h:
> 
> * SEGMENT_ENTRY_SFAA had one extra bit set
> * pmd entries don't have a length field
> * ipte does not need to clear the lower bits
>  - clearing the 12 lower bits is technically incorrect, as page tables are
>    architecturally aligned to 11 bit addresses (even though the unit tests
>    allocate always one full page)
> * region table entries should use REGION_ENTRY_TL instead of *_TABLE_LENGTH
>  - *_TABLE_LENGTH need to stay, because they should be used for ASCEs
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  lib/s390x/asm/pgtable.h | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
> index 277f3480..1a21f175 100644
> --- a/lib/s390x/asm/pgtable.h
> +++ b/lib/s390x/asm/pgtable.h
> @@ -60,7 +60,7 @@
>  #define SEGMENT_SHIFT			20
>  
>  #define SEGMENT_ENTRY_ORIGIN		0xfffffffffffff800UL
> -#define SEGMENT_ENTRY_SFAA		0xfffffffffff80000UL
> +#define SEGMENT_ENTRY_SFAA		0xfffffffffff00000UL
>  #define SEGMENT_ENTRY_AV		0x0000000000010000UL
>  #define SEGMENT_ENTRY_ACC		0x000000000000f000UL
>  #define SEGMENT_ENTRY_F			0x0000000000000800UL
> @@ -143,7 +143,7 @@ static inline p4d_t *p4d_alloc(pgd_t *pgd, unsigned long addr)
>  	if (pgd_none(*pgd)) {
>  		p4d_t *p4d = p4d_alloc_one();
>  		pgd_val(*pgd) = __pa(p4d) | REGION_ENTRY_TT_REGION1 |
> -				REGION_TABLE_LENGTH;
> +				REGION_ENTRY_TL;
>  	}
>  	return p4d_offset(pgd, addr);
>  }
> @@ -163,7 +163,7 @@ static inline pud_t *pud_alloc(p4d_t *p4d, unsigned long addr)
>  	if (p4d_none(*p4d)) {
>  		pud_t *pud = pud_alloc_one();
>  		p4d_val(*p4d) = __pa(pud) | REGION_ENTRY_TT_REGION2 |
> -				REGION_TABLE_LENGTH;
> +				REGION_ENTRY_TL;
>  	}
>  	return pud_offset(p4d, addr);
>  }
> @@ -183,7 +183,7 @@ static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
>  	if (pud_none(*pud)) {
>  		pmd_t *pmd = pmd_alloc_one();
>  		pud_val(*pud) = __pa(pmd) | REGION_ENTRY_TT_REGION3 |
> -				REGION_TABLE_LENGTH;
> +				REGION_ENTRY_TL;
>  	}
>  	return pmd_offset(pud, addr);
>  }
> @@ -202,15 +202,14 @@ static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
>  {
>  	if (pmd_none(*pmd)) {
>  		pte_t *pte = pte_alloc_one();
> -		pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT |
> -				SEGMENT_TABLE_LENGTH;
> +		pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT;
>  	}
>  	return pte_offset(pmd, addr);
>  }
>  
>  static inline void ipte(unsigned long vaddr, pteval_t *p_pte)
>  {
> -	unsigned long table_origin = (unsigned long)p_pte & PAGE_MASK;
> +	unsigned long table_origin = (unsigned long)p_pte;
>  
>  	asm volatile(
>  		"	ipte %0,%1\n"
> 

