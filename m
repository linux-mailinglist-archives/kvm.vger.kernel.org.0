Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B92429ED6
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 09:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhJLHqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 03:46:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26906 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233988AbhJLHqI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 03:46:08 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C7Gr0V012880;
        Tue, 12 Oct 2021 03:44:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9R1iOQaqbm44RHJE+TIceOf9mmITe7a3j0p2IsAMwz4=;
 b=E3Wycd1A+gAa7VjQqn6gMresUt1M6YM/snKE1XNohevcwU9TD2GCQgBHXsYezPStvrQo
 bLzMooKJqfZAyXBKJr2k8SgmuqryjSgkhCWM9EVZxVdMWFMnHfXcM4AFdJwzALy+QviO
 RS1mIhgps3qb9R0Ex3YMZKcjxKUpwO5gnp0t9Mqg1xZbQQ3Mvqvc7Xp/Cd7Em2X+oD6U
 ROmwp2RW/r3hx6I0aqPYWUDVL4qgnhI5mvUNqNc9IJDvq4KoZonV2A1yvOFaIukar0sn
 fwnKjDkOGzP5WdemKLA9lxqIu0YKkNvy01/5WtwRMJfozHLlqSiagSfKsnbn5G+ojxrN dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn3dtbfd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 03:44:06 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19C6nllG038870;
        Tue, 12 Oct 2021 03:44:05 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn3dtbfcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 03:44:05 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19C7fOKJ029460;
        Tue, 12 Oct 2021 07:44:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3bk2q9m2s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 07:44:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19C7cOn950397570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 07:38:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A382AA4072;
        Tue, 12 Oct 2021 07:43:56 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E508A404D;
        Tue, 12 Oct 2021 07:43:56 +0000 (GMT)
Received: from [9.145.20.44] (unknown [9.145.20.44])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 07:43:56 +0000 (GMT)
Message-ID: <2ce2d86e-d3cc-fb9c-60b7-6143f37f6dac@linux.ibm.com>
Date:   Tue, 12 Oct 2021 09:43:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 04/14] KVM: s390: pv: avoid stalls when making pages
 secure
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
 <20210920132502.36111-5-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20210920132502.36111-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w1mw6hRWnc-JmkV9oAdDNQKqgM2Cba9L
X-Proofpoint-GUID: 8DEcIN-GvnK8wXPlaJfWOwcgynQCtBei
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_01,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120041
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/20/21 15:24, Claudio Imbrenda wrote:
> Improve make_secure_pte to avoid stalls when the system is heavily
> overcommitted. This was especially problematic in kvm_s390_pv_unpack,
> because of the loop over all pages that needed unpacking.
> 
> Due to the locks being held, it was not possible to simply replace
> uv_call with uv_call_sched. A more complex approach was
> needed, in which uv_call is replaced with __uv_call, which does not
> loop. When the UVC needs to be executed again, -EAGAIN is returned, and
> the caller (or its caller) will try again.
> 
> When -EAGAIN is returned, the path is the same as when the page is in
> writeback (and the writeback check is also performed, which is
> harmless).
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/kernel/uv.c     | 29 +++++++++++++++++++++++------
>   arch/s390/kvm/intercept.c |  5 +++++
>   2 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index aeb0a15bcbb7..68a8fbafcb9c 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -180,7 +180,7 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
>   {
>   	pte_t entry = READ_ONCE(*ptep);
>   	struct page *page;
> -	int expected, rc = 0;
> +	int expected, cc = 0;
>   
>   	if (!pte_present(entry))
>   		return -ENXIO;
> @@ -196,12 +196,25 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
>   	if (!page_ref_freeze(page, expected))
>   		return -EBUSY;
>   	set_bit(PG_arch_1, &page->flags);
> -	rc = uv_call(0, (u64)uvcb);
> +	/*
> +	 * If the UVC does not succeed or fail immediately, we don't want to
> +	 * loop for long, or we might get stall notifications.
> +	 * On the other hand, this is a complex scenario and we are holding a lot of
> +	 * locks, so we can't easily sleep and reschedule. We try only once,
> +	 * and if the UVC returned busy or partial completion, we return
> +	 * -EAGAIN and we let the callers deal with it.
> +	 */
> +	cc = __uv_call(0, (u64)uvcb);
>   	page_ref_unfreeze(page, expected);
> -	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
> -	if (rc)
> -		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
> -	return rc;
> +	/*
> +	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
> +	 * If busy or partially completed, return -EAGAIN.
> +	 */
> +	if (cc == UVC_CC_OK)
> +		return 0;
> +	else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
> +		return -EAGAIN;
> +	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
>   }
>   
>   /*
> @@ -254,6 +267,10 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>   	mmap_read_unlock(gmap->mm);
>   
>   	if (rc == -EAGAIN) {
> +		/*
> +		 * If we are here because the UVC returned busy or partial
> +		 * completion, this is just a useless check, but it is safe.
> +		 */
>   		wait_on_page_writeback(page);
>   	} else if (rc == -EBUSY) {
>   		/*
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 72b25b7cc6ae..47833ade4da5 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -516,6 +516,11 @@ static int handle_pv_uvc(struct kvm_vcpu *vcpu)
>   	 */
>   	if (rc == -EINVAL)
>   		return 0;
> +	/*
> +	 * If we got -EAGAIN here, we simply return it. It will eventually
> +	 * get propagated all the way to userspace, which should then try
> +	 * again.
> +	 */
>   	return rc;
>   }
>   
> 

