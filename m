Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0724F40B572
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhINQ5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:57:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35994 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229706AbhINQ5d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 12:57:33 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18EG8tOE006710;
        Tue, 14 Sep 2021 12:56:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=lp+azwXGvfoXYnGUPCWqCJLAWJvonHWGbIRe3sYYsXE=;
 b=VeqaJVY5I1QQneM/GPMjRA0knax+X4dNLSoJDjWF7CVt32PDwUuUJZi0NsMvTP5M02r/
 IiYzVgnId2Mpq+EU/fZGX6iIKBJj1vbossQTPkco2kKp1iKdmnns0WBnpruPXhnftVQl
 tXxO1CjLVczZ33i4R/wxLscQ97vspMt6fptd5jkV4A/LRaAVlN2VG5wZPrNp+YcT/Ymz
 /l5751fDWtwnBPA5qOpEfHPfC+3S5OhIBakmrXkGxjzov+MWe6+Q/NBKHgyhTmMnXd3Q
 Z1kFFe7LcXsz2mHZ4ZXMrHc2iu2SH7xjCNaT19JO1Dv7yn8MCe+9m+2jEvK3NiPS8BgR +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2y0ds08k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:56:14 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18EGRTB3014274;
        Tue, 14 Sep 2021 12:56:14 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2y0ds07x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:56:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18EGrS0u028541;
        Tue, 14 Sep 2021 16:56:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3b0m39xbwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 16:56:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18EGoNEw60883400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 16:50:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9226752052;
        Tue, 14 Sep 2021 16:54:52 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.12])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0706C52050;
        Tue, 14 Sep 2021 16:54:51 +0000 (GMT)
Date:   Tue, 14 Sep 2021 18:54:49 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: Re: [PATCH resend RFC 7/9] s390/mm: no need for
 pte_alloc_map_lock() if we know the pmd is present
Message-ID: <20210914185449.42d7d5ca@p-imbrenda>
In-Reply-To: <20210909162248.14969-8-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
 <20210909162248.14969-8-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CzbilcmD8M7zTU8rtsHxUbv_j4RhfGJE
X-Proofpoint-ORIG-GUID: cQpGxFB86TjgA5GPQXTyYbkzLxtXB232
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 phishscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Sep 2021 18:22:46 +0200
David Hildenbrand <david@redhat.com> wrote:

> pte_map_lock() is sufficient.

Can you explain the difference and why it is enough?

> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/mm/pgtable.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> index 5fb409ff7842..4e77b8ebdcc5 100644
> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -814,10 +814,7 @@ int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
>  	}
>  	spin_unlock(ptl);
>  
> -	ptep = pte_alloc_map_lock(mm, pmdp, addr, &ptl);
> -	if (unlikely(!ptep))
> -		return -EFAULT;
> -
> +	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>  	new = old = pgste_get_lock(ptep);
>  	pgste_val(new) &= ~(PGSTE_GR_BIT | PGSTE_GC_BIT |
>  			    PGSTE_ACC_BITS | PGSTE_FP_BIT);
> @@ -912,10 +909,7 @@ int reset_guest_reference_bit(struct mm_struct *mm, unsigned long addr)
>  	}
>  	spin_unlock(ptl);
>  
> -	ptep = pte_alloc_map_lock(mm, pmdp, addr, &ptl);
> -	if (unlikely(!ptep))
> -		return -EFAULT;
> -
> +	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>  	new = old = pgste_get_lock(ptep);
>  	/* Reset guest reference bit only */
>  	pgste_val(new) &= ~PGSTE_GR_BIT;
> @@ -977,10 +971,7 @@ int get_guest_storage_key(struct mm_struct *mm, unsigned long addr,
>  	}
>  	spin_unlock(ptl);
>  
> -	ptep = pte_alloc_map_lock(mm, pmdp, addr, &ptl);
> -	if (unlikely(!ptep))
> -		return -EFAULT;
> -
> +	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>  	pgste = pgste_get_lock(ptep);
>  	*key = (pgste_val(pgste) & (PGSTE_ACC_BITS | PGSTE_FP_BIT)) >> 56;
>  	paddr = pte_val(*ptep) & PAGE_MASK;

