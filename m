Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BE94199DF
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 19:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbhI0REU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 13:04:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23793 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235648AbhI0REH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 13:04:07 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RFovm9003082;
        Mon, 27 Sep 2021 13:02:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=XwMWVAPfUVtBp9xkfoDH0oKb5rjA2G+EFRxif3nx4bs=;
 b=sDgYUJbHP++hdkE9vxwJOfCr181532w/UBJiPyacq2rTxPXQog/kkB2X7geaYZgwMw5H
 7jiqOEyFP9OTW0LdRWdc+ooz96vGvXubJmmTNXIs1MYJEudKfr5lhlaUihXRvMyv4p4a
 9yCcwRmTnA7wnUHjJymHOvYnI8jXz1MDOQT4935PXhCHedrkIL/vlbX8SyEml97CR1m1
 gaGaZRlI3/ksYIyVPax6kAL/Ivx13P06BnNeyITjlp1tZLupJJ8/ewwioU+1rxAMI+sZ
 fNO61QLIiVkGy+rs6nfFkLN2HWg9Kp1UsjeaucUD4+OC1S69G3znycfCCWn1mrsdR5jx hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bagq49tyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 13:02:26 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18RFr2Cm011367;
        Mon, 27 Sep 2021 13:02:25 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bagq49tx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 13:02:25 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18RGvoN2031789;
        Mon, 27 Sep 2021 17:02:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3b9ud9ntcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 17:02:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18RH2JO363242674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 17:02:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C4F042042;
        Mon, 27 Sep 2021 17:02:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD57242047;
        Mon, 27 Sep 2021 17:02:18 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Sep 2021 17:02:18 +0000 (GMT)
Date:   Mon, 27 Sep 2021 19:02:07 +0200
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
Subject: Re: [PATCH resend RFC 9/9] s390/mm: optimize
 reset_guest_reference_bit()
Message-ID: <20210927190207.4b1e487a@p-imbrenda>
In-Reply-To: <20210909162248.14969-10-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
        <20210909162248.14969-10-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AESESzveP29-fVex9la2Gcm_TcSPcwXJ
X-Proofpoint-ORIG-GUID: 6eEy48gifxIhW1q5wkzVafrPtnS0nwKj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_06,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 adultscore=0 mlxscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109270116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Sep 2021 18:22:48 +0200
David Hildenbrand <david@redhat.com> wrote:

> We already optimize get_guest_storage_key() to assume that if we don't have
> a PTE table and don't have a huge page mapped that the storage key is 0.
> 
> Similarly, optimize reset_guest_reference_bit() to simply do nothing if
> there is no PTE table and no huge page mapped.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/mm/pgtable.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> index 534939a3eca5..50ab2fed3397 100644
> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -901,13 +901,23 @@ int reset_guest_reference_bit(struct mm_struct *mm, unsigned long addr)
>  	pte_t *ptep;
>  	int cc = 0;
>  
> -	if (pmd_lookup(mm, addr, &pmdp))
> +	/*
> +	 * If we don't have a PTE table and if there is no huge page mapped,
> +	 * the storage key is 0 and there is nothing for us to do.
> +	 */
> +	switch (pmd_lookup(mm, addr, &pmdp)) {
> +	case -ENOENT:
> +		return 0;
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
> +		return 0;
>  	}
>  
>  	if (pmd_large(*pmdp)) {

