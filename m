Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B7D195371
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 09:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgC0I7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 04:59:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbgC0I7b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 04:59:31 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02R8Y8uf129497
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 04:59:31 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yxw7gxny7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 04:59:30 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 27 Mar 2020 08:59:21 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 27 Mar 2020 08:59:18 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02R8xOVd48037982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 08:59:24 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55A18AE04D;
        Fri, 27 Mar 2020 08:59:24 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 136ADAE053;
        Fri, 27 Mar 2020 08:59:24 +0000 (GMT)
Received: from [9.145.91.215] (unknown [9.145.91.215])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Mar 2020 08:59:24 +0000 (GMT)
Subject: Re: [PATCH] s390/gmap: return proper error code on ksm unsharing
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20200327085602.24535-1-borntraeger@de.ibm.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Date:   Fri, 27 Mar 2020 09:59:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200327085602.24535-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20032708-0020-0000-0000-000003BC4B8B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032708-0021-0000-0000-00002214DDB7
Message-Id: <1b2c74f9-cbe3-cb0e-64cc-aff4fd73daf7@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_02:2020-03-26,2020-03-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=504
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.03.20 09:56, Christian Borntraeger wrote:
> If a signal is pending we might return -ENOMEM instead of -EINTR.
> We should propagate the proper error during KSM unsharing.
> 
> Fixes: 3ac8e38015d4 ("s390/mm: disable KSM for storage key enabled pages")
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/mm/gmap.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 27926a06df32..2bf63035a295 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2552,15 +2552,16 @@ int gmap_mark_unmergeable(void)
>  {
>  	struct mm_struct *mm = current->mm;
>  	struct vm_area_struct *vma;
> +	int ret  = 0;
>  

extra whitespace

>  	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> -		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
> -				MADV_UNMERGEABLE, &vma->vm_flags)) {
> -			return -ENOMEM;
> -		}
> +		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
> +				MADV_UNMERGEABLE, &vma->vm_flags);
> +		if (ret)
> +			return ret;
>  	}
>  	mm->def_flags &= ~VM_MERGEABLE;
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(gmap_mark_unmergeable);
>  
> 

