Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03008322C82
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 15:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhBWOgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 09:36:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233120AbhBWOgP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 09:36:15 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NEWsAs051072;
        Tue, 23 Feb 2021 09:35:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ddCkdU+ctWpszHTsD4SbMD3fbLLXDXQq7PmNprWw1Ic=;
 b=hPx0R9ken5hwO7t6QYB+xu67hQO4KmW2ZkSC18oSxdN9rnWYoYSOf9TjCc6HFy4HOoE4
 udwjvScUx1FdQwWGIaVpEZzieRplsm4DHxDrKcLB2uSJCxu6xi7G16sJMs3cVC6aLtxI
 g/LaWDWvPuAfOTlfZsMoKr22HcI64XQH+g58l2DfP+RqKkJfe8O4T1HmOdAByy/94Ey1
 l6n2jQpScuqK9MZRMtINjXwuAXyzORyzKGDMWH/wTC6L+Bhgd26ZcR66Apb6WGDPRjMi
 ZHpJJOnZpu0LL93656kEf91VvjCbTbljzMNuj8DZ9bsm7GjeTDuxYF0R7RsU5YKgNCjL 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkg33dgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:35:34 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NEWuvp052498;
        Tue, 23 Feb 2021 09:35:34 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkg33dfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:35:34 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NEW3jU005924;
        Tue, 23 Feb 2021 14:35:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 36tt282pfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 14:35:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NEZGSQ29950332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 14:35:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE920A4062;
        Tue, 23 Feb 2021 14:35:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 857A3A4054;
        Tue, 23 Feb 2021 14:35:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.67.183])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 14:35:28 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/5] s390x: lib: improve pgtable.h
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, pmorel@linux.ibm.com
References: <20210223140759.255670-1-imbrenda@linux.ibm.com>
 <20210223140759.255670-4-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <3e87c3ec-2b32-05d2-aaed-d844be847bf2@linux.ibm.com>
Date:   Tue, 23 Feb 2021 15:35:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223140759.255670-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 bulkscore=0 spamscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102230119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/21 3:07 PM, Claudio Imbrenda wrote:
> Improve pgtable.h:
> 
> * add macros to check whether a pmd or a pud are large / huge
> * add idte functions for pmd, pud, p4d and pgd
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Could you please make the subject more specific?
"s390x: lib: Add idte and huge entry check functions"

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  lib/s390x/asm/pgtable.h | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
> index a2ff2d4e..70d4afde 100644
> --- a/lib/s390x/asm/pgtable.h
> +++ b/lib/s390x/asm/pgtable.h
> @@ -100,6 +100,9 @@
>  #define pmd_none(entry) (pmd_val(entry) & SEGMENT_ENTRY_I)
>  #define pte_none(entry) (pte_val(entry) & PAGE_ENTRY_I)
>  
> +#define pud_huge(entry)  (pud_val(entry) & REGION3_ENTRY_FC)
> +#define pmd_large(entry) (pmd_val(entry) & SEGMENT_ENTRY_FC)
> +
>  #define pgd_addr(entry) __va(pgd_val(entry) & REGION_ENTRY_ORIGIN)
>  #define p4d_addr(entry) __va(p4d_val(entry) & REGION_ENTRY_ORIGIN)
>  #define pud_addr(entry) __va(pud_val(entry) & REGION_ENTRY_ORIGIN)
> @@ -216,6 +219,34 @@ static inline void ipte(unsigned long vaddr, pteval_t *p_pte)
>  		: : "a" (table_origin), "a" (vaddr) : "memory");
>  }
>  
> +static inline void idte(unsigned long table_origin, unsigned long vaddr)
> +{
> +	vaddr &= SEGMENT_ENTRY_SFAA;
> +	asm volatile(
> +		"	idte %0,0,%1\n"
> +		: : "a" (table_origin), "a" (vaddr) : "memory");
> +}
> +
> +static inline void idte_pmdp(unsigned long vaddr, pmdval_t *pmdp)
> +{
> +	idte((unsigned long)(pmdp - pmd_index(vaddr)) | ASCE_DT_SEGMENT, vaddr);
> +}
> +
> +static inline void idte_pudp(unsigned long vaddr, pudval_t *pudp)
> +{
> +	idte((unsigned long)(pudp - pud_index(vaddr)) | ASCE_DT_REGION3, vaddr);
> +}
> +
> +static inline void idte_p4dp(unsigned long vaddr, p4dval_t *p4dp)
> +{
> +	idte((unsigned long)(p4dp - p4d_index(vaddr)) | ASCE_DT_REGION2, vaddr);
> +}
> +
> +static inline void idte_pgdp(unsigned long vaddr, pgdval_t *pgdp)
> +{
> +	idte((unsigned long)(pgdp - pgd_index(vaddr)) | ASCE_DT_REGION1, vaddr);
> +}
> +
>  void configure_dat(int enable);
>  
>  #endif /* _ASMS390X_PGTABLE_H_ */
> 

