Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919BE3F06D8
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 16:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239220AbhHROiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 10:38:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239019AbhHROiS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 10:38:18 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IEamZt068968;
        Wed, 18 Aug 2021 10:36:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=M3VW/+c3ccpqsZ7MnzPA6bUsWGd3kDAq7Tpz7Q0mJLQ=;
 b=J8S+yOxhX5sEAwRr09qFFxodPU2Nou3MhmMSTmJYval7pEUx82efmXDzEiKfOGY3cn2u
 4tkekD4tPDXC26AcRxNk732FerPSvw3KkUIqDTzdcS5OI6mtd/oZlNajcVxJnT/J0KlE
 esyRwtneNErs0S2syJDkT4NPIXx1Q4HmPSiPnaHun3VUTItz4+gbK47ruOyLlXq73wz2
 KDpvS4ai7VpsraqoSKYWFTWG3RQy3a8Auhp70o9qvOvxVhjG1uNnWDUle9dbA43D3Lfd
 K1n9ogt2tsA/4mjp9ETQkyDA8KTXTQt23KtbTxfMbUaA64NNW9zfgBSXH6FTcsQF3qAH cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcf6gmxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 10:36:54 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17IEarRE069518;
        Wed, 18 Aug 2021 10:36:54 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcf6gmv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 10:36:53 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IECZHi009310;
        Wed, 18 Aug 2021 14:31:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3ae5f8dtdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 14:31:50 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IEVkeQ58130844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 14:31:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2D6E11C06C;
        Wed, 18 Aug 2021 14:31:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF46311C05C;
        Wed, 18 Aug 2021 14:31:45 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.177])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 14:31:45 +0000 (GMT)
Date:   Wed, 18 Aug 2021 16:29:10 +0200
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
Subject: Re: [PATCH v4 05/13] KVM: Integrate gfn_to_memslot_approx() into
 search_memslots()
Message-ID: <20210818162910.700c16d0@p-imbrenda>
In-Reply-To: <278846ca7b51ab945bdaf1418f8ca94572f228d6.1628871413.git.maciej.szmigiero@oracle.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
        <278846ca7b51ab945bdaf1418f8ca94572f228d6.1628871413.git.maciej.szmigiero@oracle.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: frmiwtKnf2DNrJpQ2Cy8ySt2RNuhcjG1
X-Proofpoint-GUID: upGKNt3_M0pqMPy9pW0xw3Zs0iVpBgVo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_05:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 21:33:18 +0200
"Maciej S. Szmigiero" <mail@maciej.szmigiero.name> wrote:

> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> s390 arch has gfn_to_memslot_approx() which is almost identical to
> search_memslots(), differing only in that in case the gfn falls in a hole
> one of the memslots bordering the hole is returned.
> 
> Add this lookup mode as an option to search_memslots() so we don't have two
> almost identical functions for looking up a memslot by its gfn.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 39 ++-------------------------------------
>  include/linux/kvm_host.h | 25 ++++++++++++++++++++++---
>  virt/kvm/kvm_main.c      |  2 +-
>  3 files changed, 25 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 4bed65dbad5e..6b3f05086fae 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1941,41 +1941,6 @@ static long kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
>  /* for consistency */
>  #define KVM_S390_CMMA_SIZE_MAX ((u32)KVM_S390_SKEYS_MAX)
>  
> -/*
> - * Similar to gfn_to_memslot, but returns the index of a memslot also when the
> - * address falls in a hole. In that case the index of one of the memslots
> - * bordering the hole is returned.
> - */
> -static int gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn)
> -{
> -	int start = 0, end = slots->used_slots;
> -	int slot = atomic_read(&slots->last_used_slot);
> -	struct kvm_memory_slot *memslots = slots->memslots;
> -
> -	if (gfn >= memslots[slot].base_gfn &&
> -	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
> -		return slot;
> -
> -	while (start < end) {
> -		slot = start + (end - start) / 2;
> -
> -		if (gfn >= memslots[slot].base_gfn)
> -			end = slot;
> -		else
> -			start = slot + 1;
> -	}
> -
> -	if (start >= slots->used_slots)
> -		return slots->used_slots - 1;
> -
> -	if (gfn >= memslots[start].base_gfn &&
> -	    gfn < memslots[start].base_gfn + memslots[start].npages) {
> -		atomic_set(&slots->last_used_slot, start);
> -	}
> -
> -	return start;
> -}
> -
>  static int kvm_s390_peek_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
>  			      u8 *res, unsigned long bufsize)
>  {
> @@ -2002,8 +1967,8 @@ static int kvm_s390_peek_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
>  static unsigned long kvm_s390_next_dirty_cmma(struct kvm_memslots *slots,
>  					      unsigned long cur_gfn)
>  {
> -	int slotidx = gfn_to_memslot_approx(slots, cur_gfn);
> -	struct kvm_memory_slot *ms = slots->memslots + slotidx;
> +	struct kvm_memory_slot *ms = __gfn_to_memslot_approx(slots, cur_gfn, true);
> +	int slotidx = ms - slots->memslots;
>  	unsigned long ofs = cur_gfn - ms->base_gfn;
>  
>  	if (ms->base_gfn + ms->npages <= cur_gfn) {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2d62581b400e..6d0bbd6c8554 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1232,10 +1232,14 @@ try_get_memslot(struct kvm_memslots *slots, int slot_index, gfn_t gfn)
>   * Returns a pointer to the memslot that contains gfn and records the index of
>   * the slot in index. Otherwise returns NULL.
>   *
> + * With "approx" set returns the memslot also when the address falls
> + * in a hole. In that case one of the memslots bordering the hole is
> + * returned.
> + *
>   * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
>   */
>  static inline struct kvm_memory_slot *
> -search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
> +search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index, bool approx)
>  {
>  	int start = 0, end = slots->used_slots;
>  	struct kvm_memory_slot *memslots = slots->memslots;
> @@ -1253,11 +1257,20 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
>  			start = slot + 1;
>  	}
>  
> +	if (approx && start >= slots->used_slots) {
> +		*index = slots->used_slots - 1;
> +		return &memslots[slots->used_slots - 1];
> +	}
> +
>  	slot = try_get_memslot(slots, start, gfn);
>  	if (slot) {
>  		*index = start;
>  		return slot;
>  	}
> +	if (approx) {
> +		*index = start;
> +		return &memslots[start];
> +	}
>  
>  	return NULL;
>  }
> @@ -1268,7 +1281,7 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
>   * itself isn't here as an inline because that would bloat other code too much.
>   */
>  static inline struct kvm_memory_slot *
> -__gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
> +__gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn, bool approx)
>  {
>  	struct kvm_memory_slot *slot;
>  	int slot_index = atomic_read(&slots->last_used_slot);
> @@ -1277,7 +1290,7 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
>  	if (slot)
>  		return slot;
>  
> -	slot = search_memslots(slots, gfn, &slot_index);
> +	slot = search_memslots(slots, gfn, &slot_index, approx);
>  	if (slot) {
>  		atomic_set(&slots->last_used_slot, slot_index);
>  		return slot;
> @@ -1286,6 +1299,12 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
>  	return NULL;
>  }
>  
> +static inline struct kvm_memory_slot *
> +__gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
> +{
> +	return __gfn_to_memslot_approx(slots, gfn, false);
> +}
> +
>  static inline unsigned long
>  __gfn_to_hva_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 207306f7c559..03ef42d2e421 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2074,7 +2074,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>  	 * search_memslots() instead of __gfn_to_memslot() to avoid
>  	 * thrashing the VM-wide last_used_index in kvm_memslots.
>  	 */
> -	slot = search_memslots(slots, gfn, &slot_index);
> +	slot = search_memslots(slots, gfn, &slot_index, false);
>  	if (slot) {
>  		vcpu->last_used_slot = slot_index;
>  		return slot;

