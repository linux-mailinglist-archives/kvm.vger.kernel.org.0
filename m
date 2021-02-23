Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7615E322C60
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 15:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhBWOcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 09:32:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27538 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233098AbhBWOcL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 09:32:11 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NEODgO079879;
        Tue, 23 Feb 2021 09:31:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1WO8mmr+eKBuOa3nE4/5UJIoESzkeEh1cGsFlVE7cb4=;
 b=fC67toktqHFjeWfXa2k+AnQTWeKD2ocw2JL2M3D+fbsrAc1TWB+Fof6zvEp1V3VvkQNc
 2GNH61f6NtlulWjwrVcbBZUOMcNmnhR49y/pgLHdFCbIZLLhFWcdKPxUe217YDXtELxI
 6WkXb5d9R0y7R1pPHDI7mCbHBGSK8zXofOnXCLcsNh5p/vbL5n9obdIkA6dlVRfECvZT
 oyTNpRYUGB94XSLmbpAc2gexqfeejxj2fr17sJJIpLi7kdpQTWwyfekOel82EAkI/+dZ
 0NqsoK9XLM1eE6/qLZwPXjj3QJ8ivBMuG8vIJUuE0AIaC7uLjLb4UrZabsjta+sUMMw/ tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkfkrw76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:31:30 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NEPce7086203;
        Tue, 23 Feb 2021 09:31:14 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkfkrw3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:31:14 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NESfPI001549;
        Tue, 23 Feb 2021 14:31:10 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 36tt282pca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 14:31:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NEUtvp35586518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 14:30:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B04D9A405C;
        Tue, 23 Feb 2021 14:31:07 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51C1EA405F;
        Tue, 23 Feb 2021 14:31:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.67.183])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 14:31:07 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, pmorel@linux.ibm.com
References: <20210223140759.255670-1-imbrenda@linux.ibm.com>
 <20210223140759.255670-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/5] s390x: lib: fix pgtable.h
Message-ID: <518e0f86-bbba-bd52-3962-2816b2f8ccf6@linux.ibm.com>
Date:   Tue, 23 Feb 2021 15:31:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223140759.255670-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_07:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=0 phishscore=0
 clxscore=1015 malwarescore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/21 3:07 PM, Claudio Imbrenda wrote:
> Fix pgtable.h:
> 
> * SEGMENT_ENTRY_SFAA had one extra bit set
> * pmd entries don't have a length
> * ipte does not need to clear the lower bits
> * pud entries should use SEGMENT_TABLE_LENGTH, as they point to segment tables
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/pgtable.h | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
> index 277f3480..a2ff2d4e 100644
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
> @@ -183,7 +183,7 @@ static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
>  	if (pud_none(*pud)) {
>  		pmd_t *pmd = pmd_alloc_one();
>  		pud_val(*pud) = __pa(pmd) | REGION_ENTRY_TT_REGION3 |
> -				REGION_TABLE_LENGTH;
> +				SEGMENT_TABLE_LENGTH;

@David: I'd much rather have REGION_ENTRY_LENGTH instead of
REGION_TABLE_LENGTH and SEGMENT_TABLE_LENGTH.

My argument is that this is not really an attribute of the table and
very much specific to the format of the (region table) entry. We already
have the table order as a length anyway...

Could you tell me what you had in mind when splitting this?

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

Uhhhh good catch!

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

IPTE ignores that data but having the page mask also doesn't hurt so
generally this is not a fix, right?

