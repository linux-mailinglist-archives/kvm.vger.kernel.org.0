Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C947F3F06C0
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 16:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238807AbhHROdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 10:33:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238113AbhHROdF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 10:33:05 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IE4VJl025100;
        Wed, 18 Aug 2021 10:31:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ixVU0B6ctDiCMO6CN8v/f7jFpKVp8bzxGq/SaMXixQ4=;
 b=I+363rL6NKkf63SbSGtoMjDvq0y6Et7CnPtGq6rtLW8QwUw3ynsjSJhLW1/z3ybwNzTT
 yQt+lyRO1xVDaCUmcmU4gUgknnqZaQMok1v1uuuvJoIggAIVJBCdjaJJQMI4WhSGvfzl
 fKNriwSymH60d6wjDN1C3QVmJGrdcUYUmwuLFUXDiBHbGajYhf0tGj3ZhqRzEpL3tDRJ
 aj9iJ97ggH+6XadNQfy5mZ8xp0jFYmWKtXOiDVKnJ2s13L2IbOhNtO6Bui4rFfP9C3w6
 VwhMR2xwCyqPohiZd9L2tUGXQgdLrBE9uk9rWx/61jy/pwDx7MXpCh13CK+wG9966bSF AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agfdxt0v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 10:31:48 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17IE7Eo3040613;
        Wed, 18 Aug 2021 10:31:47 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agfdxt0sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 10:31:47 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IEKsCw015409;
        Wed, 18 Aug 2021 14:31:44 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3afwrhtgyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 14:31:44 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IEVfqV49938882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 14:31:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0249211C054;
        Wed, 18 Aug 2021 14:31:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1AC211C06F;
        Wed, 18 Aug 2021 14:31:39 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.177])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 14:31:39 +0000 (GMT)
Date:   Wed, 18 Aug 2021 16:31:14 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/13] KVM: s390: Introduce kvm_s390_get_gfn_end()
Message-ID: <20210818163114.7f45646e@p-imbrenda>
In-Reply-To: <5de2569b7a6c7df38c5fdd3baf88e6d987f42776.1628871413.git.maciej.szmigiero@oracle.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
        <5de2569b7a6c7df38c5fdd3baf88e6d987f42776.1628871413.git.maciej.szmigiero@oracle.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P4Sw_-Hf568CwJOoyR_CXvm-l6ThWOIU
X-Proofpoint-ORIG-GUID: 1EsR_4AFI3fy43MUtS-fmDf45vJn479W
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_04:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 21:33:23 +0200
"Maciej S. Szmigiero" <mail@maciej.szmigiero.name> wrote:

> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> And use it where s390 code would just access the memslot with the highest
> gfn directly.
> 
> No functional change intended.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c |  2 +-
>  arch/s390/kvm/kvm-s390.h | 12 ++++++++++++
>  arch/s390/kvm/pv.c       |  4 +---
>  3 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6b3f05086fae..9c3a85793ba4 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2006,7 +2006,7 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
>  	if (!ms)
>  		return 0;
>  	next_gfn = kvm_s390_next_dirty_cmma(slots, cur_gfn + 1);
> -	mem_end = slots->memslots[0].base_gfn + slots->memslots[0].npages;
> +	mem_end = kvm_s390_get_gfn_end(slots);
>  
>  	while (args->count < bufsize) {
>  		hva = gfn_to_hva(kvm, cur_gfn);
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 9fad25109b0d..5787b12aff7e 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -208,6 +208,18 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
>  	return kvm->arch.user_cpu_state_ctrl != 0;
>  }
>  
> +/* get the end gfn of the last (highest gfn) memslot */
> +static inline unsigned long kvm_s390_get_gfn_end(struct kvm_memslots *slots)
> +{
> +	struct kvm_memory_slot *ms;
> +
> +	if (WARN_ON(!slots->used_slots))
> +		return 0;
> +
> +	ms = slots->memslots;
> +	return ms->base_gfn + ms->npages;
> +}
> +
>  /* implemented in pv.c */
>  int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
>  int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index c8841f476e91..e51cccfded25 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -117,7 +117,6 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>  	unsigned long base = uv_info.guest_base_stor_len;
>  	unsigned long virt = uv_info.guest_virt_var_stor_len;
>  	unsigned long npages = 0, vlen = 0;
> -	struct kvm_memory_slot *memslot;
>  
>  	kvm->arch.pv.stor_var = NULL;
>  	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL_ACCOUNT, get_order(base));
> @@ -131,8 +130,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>  	 * Slots are sorted by GFN
>  	 */
>  	mutex_lock(&kvm->slots_lock);
> -	memslot = kvm_memslots(kvm)->memslots;
> -	npages = memslot->base_gfn + memslot->npages;
> +	npages = kvm_s390_get_gfn_end(kvm_memslots(kvm));
>  	mutex_unlock(&kvm->slots_lock);
>  
>  	kvm->arch.pv.guest_len = npages * PAGE_SIZE;

