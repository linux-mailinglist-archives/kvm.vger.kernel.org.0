Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607BD419AA3
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 19:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbhI0RKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 13:10:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236493AbhI0RJK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 13:09:10 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RH6rGm014024;
        Mon, 27 Sep 2021 13:07:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=/pZLnV4O+hTOZCX7MZFbuguZgzytK6+jQqgZO/Bf5CY=;
 b=WX7rdNCdRdRtZ0k+fh31F7DB1qGzw6tVXj/P2OBxAbpLbkNfnwcL7byB33ebk/MnTFdL
 A8F+cYP5NYxwOUAxdGK0NjF2Z/qg1ImirTWUQzgsZvYk40zmrWgVLxyhLJ0C47k/T77F
 CcK/TDwic/gMBAlCBL/RFPGXWFItPo9ewZoxsIp4ah44BLEZ2GZ6nNlTGYsAyF2aM5ti
 nDGyOoMqIUxdjYvWrgdl+oScZSlF11x+75gzjW9bk3DiqDKPr2GO6n2VvRWTsBG0+tyE
 EooQ6qe/K8TCyFc4PrWSO/wvhfmHtDw59W/GOGCVKIIBEHOG55tQJeNwXjaGcaTv1Bx6 Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3baguagu61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 13:07:29 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18RH7Txg016078;
        Mon, 27 Sep 2021 13:07:29 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3baguagtbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 13:07:26 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18RGvmqx019480;
        Mon, 27 Sep 2021 17:02:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3b9ud9dufp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 17:02:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18RGvKMM55312688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 16:57:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E092C4204D;
        Mon, 27 Sep 2021 17:02:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67CB842047;
        Mon, 27 Sep 2021 17:02:21 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Sep 2021 17:02:21 +0000 (GMT)
Date:   Mon, 27 Sep 2021 19:01:57 +0200
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
Subject: Re: [PATCH resend RFC 8/9] s390/mm: optimize
 set_guest_storage_key()
Message-ID: <20210927190157.65ce9f54@p-imbrenda>
In-Reply-To: <20210909162248.14969-9-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
        <20210909162248.14969-9-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: skm3WqG9TvCnjM41kfvnFIQO-Wcerqxb
X-Proofpoint-ORIG-GUID: sU04ZfL8nKoKUHEdrUF6uqMy17v9dSlw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_06,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Sep 2021 18:22:47 +0200
David Hildenbrand <david@redhat.com> wrote:

> We already optimize get_guest_storage_key() to assume that if we don't have
> a PTE table and don't have a huge page mapped that the storage key is 0.
> 
> Similarly, optimize set_guest_storage_key() to simply do nothing in case
> the key to set is 0.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/mm/pgtable.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> index 4e77b8ebdcc5..534939a3eca5 100644
> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -792,13 +792,23 @@ int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
>  	pmd_t *pmdp;
>  	pte_t *ptep;
>  
> -	if (pmd_lookup(mm, addr, &pmdp))
> +	/*
> +	 * If we don't have a PTE table and if there is no huge page mapped,
> +	 * we can ignore attempts to set the key to 0, because it already is 0.
> +	 */
> +	switch (pmd_lookup(mm, addr, &pmdp)) {
> +	case -ENOENT:
> +		return key ? -EFAULT : 0;
> +	case 0:
> +		break;
> +	default:
>  		return -EFAULT;
> +	}
>  
>  	ptl = pmd_lock(mm, pmdp);
>  	if (!pmd_present(*pmdp)) {
>  		spin_unlock(ptl);
> -		return -EFAULT;
> +		return key ? -EFAULT : 0;
>  	}
>  
>  	if (pmd_large(*pmdp)) {

