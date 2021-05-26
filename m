Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C33C391713
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 14:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbhEZMNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 08:13:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47532 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229958AbhEZMNE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 08:13:04 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QC4542162186;
        Wed, 26 May 2021 08:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cK7QrGGSV4nG6NPw0MQfF0jyBNIpK+F9t15/O3rq/6c=;
 b=e+sjamzSObfaxSOXXd/9IUdXBunsIZF5aGxRQQA6LF0hKU9b2utj5mIHukI5PBiC78FB
 itBcjjcizokGFwbulYafrLjffKg9uF6yPMgFNaixIU5/W5caS6m6b730dsy9XTyGIDBZ
 DySM/TJvM/emvCncByUqtA6pkxCSOLnJ8Wdruz6ohFbwBSUDB/A4mfD7TyCJLeQX0L5U
 v+1yS8QoVup8E8v/yCEoSsaN5qcJEJYSt0cT9rsq+U2o1G5RdMnDsb4KePc0B7qh8/ax
 r4TcnKULcD5Fe/68Rs7wp7hDj+/DnUia5S8k54gg3D+5qBvqtsORFIhWLe5Kv7xTwuKp tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38snyh0bmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 08:11:32 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QC66oc176694;
        Wed, 26 May 2021 08:11:32 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38snyh0bk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 08:11:32 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QC7eVS002715;
        Wed, 26 May 2021 12:11:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 38s2dt0911-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 12:11:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QCBRnM23527874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 12:11:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 533044C046;
        Wed, 26 May 2021 12:11:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2FEA4C04E;
        Wed, 26 May 2021 12:11:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.174.11])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 12:11:26 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
 <20210517200758.22593-6-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v1 05/11] KVM: s390: pv: refactor s390_reset_acc
Message-ID: <fb23fc95-50ed-284c-041a-c21f1753c101@linux.ibm.com>
Date:   Wed, 26 May 2021 14:11:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517200758.22593-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: F_BSXzbyVs60Zq3xgB0U015jWNryYR9x
X-Proofpoint-GUID: r298qfPj3cbKDQHaL6wmKS_Cv6IbFSAw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_08:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 clxscore=1011 spamscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105260082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/21 10:07 PM, Claudio Imbrenda wrote:
> Refactor s390_reset_acc so that its pieces can be reused in upcoming
> patches. The users parameter for s390_destroy_range will be needed in
> upcoming patches.
> 
> We don't want to hold all the locks used in a walk_page_range for too
> long, and the destroy page UVC does take some time to complete.
> Therefore we quickly gather the pages to destroy, and then destroy them
> without holding all the locks.
> 

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/include/asm/gmap.h |  5 +-
>  arch/s390/kvm/pv.c           | 12 ++++-
>  arch/s390/mm/gmap.c          | 88 ++++++++++++++++++++++++------------
>  3 files changed, 73 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index 40264f60b0da..618ddc455867 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -147,5 +147,8 @@ int gmap_mprotect_notify(struct gmap *, unsigned long start,
>  void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
>  			     unsigned long gaddr, unsigned long vmaddr);
>  int gmap_mark_unmergeable(void);
> -void s390_reset_acc(struct mm_struct *mm);
> +void s390_uv_destroy_range(struct mm_struct *mm, unsigned int users,
> +			   unsigned long start, unsigned long end);
> +void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
> +
>  #endif /* _ASM_S390_GMAP_H */
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index e0532ab725bf..c3f9f30d2ed4 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -12,6 +12,8 @@
>  #include <asm/gmap.h>
>  #include <asm/uv.h>
>  #include <asm/mman.h>
> +#include <linux/pagewalk.h>
> +#include <linux/sched/mm.h>
>  #include "kvm-s390.h"
>  
>  int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
> @@ -204,8 +206,14 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  {
>  	int cc;
>  
> -	/* make all pages accessible before destroying the guest */
> -	s390_reset_acc(kvm->mm);
> +	/*
> +	 * if the mm still has a mapping, make all its pages accessible
> +	 * before destroying the guest
> +	 */
> +	if (mmget_not_zero(kvm->mm)) {
> +		s390_uv_destroy_range(kvm->mm, 0, 0, TASK_SIZE);
> +		mmput(kvm->mm);
> +	}
>  
>  	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
>  			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index de679facc720..ad210a6e2c41 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2670,41 +2670,71 @@ void s390_reset_cmma(struct mm_struct *mm)
>  }
>  EXPORT_SYMBOL_GPL(s390_reset_cmma);
>  
> -/*
> - * make inaccessible pages accessible again
> - */
> -static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
> -			    unsigned long next, struct mm_walk *walk)
> +#define DESTROY_LOOP_THRESHOLD 32
> +
> +struct reset_walk_state {
> +	unsigned long next;
> +	unsigned long count;
> +	unsigned long pfns[DESTROY_LOOP_THRESHOLD];

Candidate for a module parameter and extensive performance testing?

> +};
> +
> +static int s390_gather_pages(pte_t *ptep, unsigned long addr,
> +			     unsigned long next, struct mm_walk *walk)

A "pv" somewhere in that function name would be helpful to me.
Also the "__" prefix applies here I think. We never call the function
directly and it's static. And I assume that's what the "__" prefix is
trying to tell us. :)

>  {
> +	struct reset_walk_state *p = walk->private;
>  	pte_t pte = READ_ONCE(*ptep);
>  
> -	/* There is a reference through the mapping */
> -	if (pte_present(pte))
> -		WARN_ON_ONCE(uv_destroy_owned_page(pte_val(pte) & PAGE_MASK));
> -
> -	return 0;
> +	if (pte_present(pte)) {
> +		/* we have a reference from the mapping, take an extra one */
> +		get_page(phys_to_page(pte_val(pte)));
> +		p->pfns[p->count] = phys_to_pfn(pte_val(pte));
> +		p->next = next;
> +		p->count++;
> +	}
> +	return p->count >= DESTROY_LOOP_THRESHOLD;
>  }
>  
> -static const struct mm_walk_ops reset_acc_walk_ops = {
> -	.pte_entry		= __s390_reset_acc,
> +static const struct mm_walk_ops gather_pages_ops = {
> +	.pte_entry = s390_gather_pages,
>  };
>  
> -#include <linux/sched/mm.h>
> -void s390_reset_acc(struct mm_struct *mm)
> +/*
> + * Call the Destroy secure page UVC on each page in the given array of PFNs.
> + * Each page needs to have an extra reference, which will be released here.
> + */
> +void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns)
>  {
> -	if (!mm_is_protected(mm))
> -		return;
> -	/*
> -	 * we might be called during
> -	 * reset:                             we walk the pages and clear
> -	 * close of all kvm file descriptors: we walk the pages and clear
> -	 * exit of process on fd closure:     vma already gone, do nothing
> -	 */
> -	if (!mmget_not_zero(mm))
> -		return;
> -	mmap_read_lock(mm);
> -	walk_page_range(mm, 0, TASK_SIZE, &reset_acc_walk_ops, NULL);
> -	mmap_read_unlock(mm);
> -	mmput(mm);
> +	unsigned long i;
> +
> +	for (i = 0; i < count; i++) {
> +		/* we always have an extra reference */
> +		uv_destroy_owned_page(pfn_to_phys(pfns[i]));
> +		/* get rid of the extra reference */
> +		put_page(pfn_to_page(pfns[i]));
> +		cond_resched();
> +	}
> +}
> +EXPORT_SYMBOL_GPL(s390_uv_destroy_pfns);
> +
> +/*
> + * Walk the given range of the given address space, and call the destroy
> + * secure page UVC on each page.
> + * Exit early if the number of users of the mm drops to (or below) the given
> + * value.
> + */
> +void s390_uv_destroy_range(struct mm_struct *mm, unsigned int users,
> +			   unsigned long start, unsigned long end)
> +{
> +	struct reset_walk_state state = { .next = start };
> +	int r = 1;
> +
> +	while ((r > 0) && (atomic_read(&mm->mm_users) > users)) {
> +		state.count = 0;
> +		mmap_read_lock(mm);
> +		r = walk_page_range(mm, state.next, end, &gather_pages_ops, &state);
> +		mmap_read_unlock(mm);
> +		cond_resched();
> +		s390_uv_destroy_pfns(state.count, state.pfns);
> +	}
>  }
> -EXPORT_SYMBOL_GPL(s390_reset_acc);
> +EXPORT_SYMBOL_GPL(s390_uv_destroy_range);
> 

