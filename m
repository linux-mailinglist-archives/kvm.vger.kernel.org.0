Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5A44EDA79
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 15:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbiCaN12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 09:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235041AbiCaN11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 09:27:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156E221407F;
        Thu, 31 Mar 2022 06:25:39 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VBkbTV029581;
        Thu, 31 Mar 2022 13:25:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SHP/oX2gI5uI7a2d9woYTjs3yd9xQwRqpxtXiY/crng=;
 b=TSRe2A4dC5yj6xBirh1B9s5WztohMJXRcwXoaN9HEZBo6vp6FYJNAcq4gxS0nuBTLole
 4xQiN23+/tx9wvXfBbyjPFfxekSfhKg7gEpDprrgoWY5OCyAIZY1fyXBIJF5BAIbC+YH
 U3rcj9gGx4cQA4sxpOqshENP6/2NdNJ/B7hfuVAODC62tE9F9xJ/VF4bcNii+DPOIaXt
 wvDw2duPnfsm3YaQWP+5xDgDOOm8/m61LDzEhvfDD33qv/Mjtj2xTUiwGghDsrkG0np0
 lKMi5HMv1x89u/mwVJFfCTCB4tw/+dBtbewRKXTC7moM/TysRQKwHBUp/YQzYdcN1CQG MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f556tjktg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 13:25:38 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VDKQiR000705;
        Thu, 31 Mar 2022 13:25:38 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f556tjksh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 13:25:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VDHVEv017146;
        Thu, 31 Mar 2022 13:25:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3f3rs3nuv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 13:25:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VDPWxa41943402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 13:25:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CF3111C05C;
        Thu, 31 Mar 2022 13:25:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA30511C04C;
        Thu, 31 Mar 2022 13:25:31 +0000 (GMT)
Received: from [9.145.159.108] (unknown [9.145.159.108])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 13:25:31 +0000 (GMT)
Message-ID: <1fe44cd4-4ea9-ad68-2690-54c78dd4f5ad@linux.ibm.com>
Date:   Thu, 31 Mar 2022 15:25:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v9 04/18] KVM: s390: pv: refactor s390_reset_acc
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220330122605.247613-1-imbrenda@linux.ibm.com>
 <20220330122605.247613-5-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220330122605.247613-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DDh0UajLbk5CYeYv973pH3o6D0Goc_wZ
X-Proofpoint-ORIG-GUID: RWQVbFN5Hy1I99pA25sCrsN9CyK58G-E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 adultscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/22 14:25, Claudio Imbrenda wrote:
> Refactor s390_reset_acc so that it can be reused in upcoming patches.
> 
> We don't want to hold all the locks used in a walk_page_range for too
> long, and the destroy page UVC does take some time to complete.
> Therefore we quickly gather the pages to destroy, and then destroy them
> without holding all the locks.
> 
> The new refactored function optionally allows to return early without
> completing if a fatal signal is pending (and return and appropriate
> error code). Two wrappers are provided to call the new function.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> (dropping Janosch's Ack because of major changes to the patch)

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

[...]
> +#define DESTROY_LOOP_THRESHOLD 32

A question out of curiosity:
Is there any particular reason for the number?
Have you tested other numbers and experienced a speedup/slowdown?

> +
> +struct reset_walk_state {
> +	unsigned long next;
> +	unsigned long count;
> +	unsigned long pfns[DESTROY_LOOP_THRESHOLD];
> +};
> +
> +static int s390_gather_pages(pte_t *ptep, unsigned long addr,
> +			     unsigned long next, struct mm_walk *walk)
>   {
> +	struct reset_walk_state *p = walk->private;
>   	pte_t pte = READ_ONCE(*ptep);
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
>   }
>   
> -static const struct mm_walk_ops reset_acc_walk_ops = {
> -	.pte_entry		= __s390_reset_acc,
> +static const struct mm_walk_ops gather_pages_ops = {
> +	.pte_entry = s390_gather_pages,
>   };
>   
> -#include <linux/sched/mm.h>
> -void s390_reset_acc(struct mm_struct *mm)
> +/*
> + * Call the Destroy secure page UVC on each page in the given array of PFNs.
> + * Each page needs to have an extra reference, which will be released here.
> + */
> +void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns)
>   {
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
> +/**
> + * __s390_uv_destroy_range - Walk the given range of the given address
> + * space, and call the destroy secure page UVC on each page.
> + * Optionally exit early if a fatal signal is pending.
> + * @mm the mm to operate on
> + * @start the start of the range
> + * @end the end of the range
> + * @interruptible if not 0, stop when a fatal signal is received
> + * Return: 0 on success, -EINTR if the function stopped before completing
> + */
> +int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
> +			    unsigned long end, bool interruptible)
> +{
> +	struct reset_walk_state state = { .next = start };
> +	int r = 1;
> +
> +	while (r > 0) {
> +		state.count = 0;
> +		mmap_read_lock(mm);
> +		r = walk_page_range(mm, state.next, end, &gather_pages_ops, &state);
> +		mmap_read_unlock(mm);
> +		cond_resched();
> +		s390_uv_destroy_pfns(state.count, state.pfns);
> +		if (interruptible && fatal_signal_pending(current))
> +			return -EINTR;
> +	}
> +	return 0;
>   }
> -EXPORT_SYMBOL_GPL(s390_reset_acc);
> +EXPORT_SYMBOL_GPL(__s390_uv_destroy_range);
>   
>   /**
>    * s390_remove_old_asce - Remove the topmost level of page tables from the

