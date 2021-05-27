Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3604392AF9
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 11:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbhE0JpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 05:45:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16752 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235675AbhE0JpM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 05:45:12 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14R9Y4Yh011614;
        Thu, 27 May 2021 05:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sd0+oPEZoxRo7IA9fLMmxZ1fKV+LmrHFhCD3OIXtSz4=;
 b=YHI8WjbC22gAJrxQajvYsa4MTQxpsHAbq4SIkpnW/HRjaL9AQq61KKxMUqQ3URnaReqv
 wVb6utt1GoXYErYqufA/cWLLux2C3gj2HQRjzO2rvlxlOvwVZNhMuhl/LbeCl4oOlhDM
 WP5TmAu7ca+OF7c7irMRijzyFtBylrYb3RKU9ePchzhm+cJIftLcSPfR2U3lx/7fB6XO
 21UC5pRwiVnRlBAr2VfukOlbuSqK2pZO+cVvXVAedLAz/1uz8sJw/uZUlTn+J7suEfza
 VqCnmY9WOIgWwPb/3btGgPKJlsmAUkpMA02xdcr1N23Dp3ZGawhb2ouOXDV5NDHG1OWe wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38t7y49st8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 05:43:39 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14R9YCRV011878;
        Thu, 27 May 2021 05:43:38 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38t7y49ssk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 05:43:38 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14R9ha5D004806;
        Thu, 27 May 2021 09:43:36 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 38sba2ruyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 09:43:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14R9hXtP15925640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 09:43:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F64311C04A;
        Thu, 27 May 2021 09:43:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 046B311C05E;
        Thu, 27 May 2021 09:43:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.86.253])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 May 2021 09:43:32 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
 <20210517200758.22593-9-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v1 08/11] KVM: s390: pv: lazy destroy for reboot
Message-ID: <1eb61235-75a7-4a57-38ca-d7a1219f1b8d@linux.ibm.com>
Date:   Thu, 27 May 2021 11:43:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517200758.22593-9-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3b2yRhmgVRyYSSgT8CZvd0Q1SEc1NxPy
X-Proofpoint-ORIG-GUID: XBD8x2Gfd42l7Go-6kSG0Sf4bM-YOYxU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_04:2021-05-26,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/21 10:07 PM, Claudio Imbrenda wrote:
> Until now, destroying a protected guest was an entirely synchronous
> operation that could potentially take a very long time, depending on
> the size of the guest, due to the time needed to clean up the address
> space from protected pages.
> 
> This patch implements a lazy destroy mechanism, that allows a protected
> guest to reboot significantly faster than previously.
> 
> This is achieved by clearing the pages of the old guest in background.
> In case of reboot, the new guest will be able to run in the same
> address space almost immediately.
> 
> The old protected guest is then only destroyed when all of its memory has
> been destroyed or otherwise made non protected.

LGTM some comments below

> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c |   6 +-
>  arch/s390/kvm/kvm-s390.h |   2 +-
>  arch/s390/kvm/pv.c       | 118 ++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 120 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 2f09e9d7dc95..db25aa1fb6a6 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2248,7 +2248,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  
>  		r = kvm_s390_cpus_to_pv(kvm, &cmd->rc, &cmd->rrc);
>  		if (r)
> -			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
> +			kvm_s390_pv_deinit_vm_deferred(kvm, &dummy, &dummy);
>  
>  		/* we need to block service interrupts from now on */
>  		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
> @@ -2267,7 +2267,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  		 */
>  		if (r)
>  			break;
> -		r = kvm_s390_pv_deinit_vm(kvm, &cmd->rc, &cmd->rrc);
> +		r = kvm_s390_pv_deinit_vm_deferred(kvm, &cmd->rc, &cmd->rrc);
>  
>  		/* no need to block service interrupts any more */
>  		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
> @@ -2796,7 +2796,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	 * complaining we do not use kvm_s390_pv_is_protected.
>  	 */
>  	if (kvm_s390_pv_get_handle(kvm))
> -		kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
> +		kvm_s390_pv_deinit_vm_deferred(kvm, &rc, &rrc);
>  	debug_unregister(kvm->arch.dbf);
>  	free_page((unsigned long)kvm->arch.sie_page2);
>  	if (!kvm_is_ucontrol(kvm))
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 79dcd647b378..b3c0796a3cc1 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -211,7 +211,7 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
>  /* implemented in pv.c */
>  int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
>  int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
> -int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
> +int kvm_s390_pv_deinit_vm_deferred(struct kvm *kvm, u16 *rc, u16 *rrc);
>  int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
>  int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
>  			      u16 *rrc);
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 59039b8a7be7..9a3547966e18 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -14,8 +14,17 @@
>  #include <asm/mman.h>
>  #include <linux/pagewalk.h>
>  #include <linux/sched/mm.h>
> +#include <linux/kthread.h>
>  #include "kvm-s390.h"
>  
> +struct deferred_priv {
> +	struct mm_struct *mm;
> +	unsigned long old_table;
> +	u64 handle;
> +	void *virt;
> +	unsigned long real;
> +};
> +
>  int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>  {
>  	int cc = 0;
> @@ -202,7 +211,7 @@ static int kvm_s390_pv_replace_asce(struct kvm *kvm)
>  }
>  
>  /* this should not fail, but if it does, we must not free the donated memory */
> -int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> +static int kvm_s390_pv_deinit_vm_now(struct kvm *kvm, u16 *rc, u16 *rrc)
>  {
>  	int cc;
>  
> @@ -230,6 +239,111 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	return cc ? -EIO : 0;
>  }
>  
> +static int kvm_s390_pv_destroy_vm_thread(void *priv)
> +{
> +	struct deferred_priv *p = priv;
> +	u16 rc, rrc;
> +	int r = 1;
> +
> +	/* Exit early if we end up being the only users of the mm */
> +	s390_uv_destroy_range(p->mm, 1, 0, TASK_SIZE_MAX);
> +	mmput(p->mm);

Where do we exit early?

> +
> +	r = uv_cmd_nodata(p->handle, UVC_CMD_DESTROY_SEC_CONF, &rc, &rrc);
> +	WARN_ONCE(r, "protvirt destroy vm failed rc %x rrc %x", rc, rrc);
> +	if (r)
> +		return r;
> +	atomic_dec(&p->mm->context.is_protected);
> +
> +	/*
> +	 * Intentional leak in case the destroy secure VM call fails. The
> +	 * call should never fail if the hardware is not broken.
> +	 */
> +	free_pages(p->real, get_order(uv_info.guest_base_stor_len));
> +	free_pages(p->old_table, CRST_ALLOC_ORDER);
> +	vfree(p->virt);
> +	kfree(p);
> +	return 0;
> +}
> +
> +static int deferred_destroy(struct kvm *kvm, struct deferred_priv *priv, u16 *rc, u16 *rrc)
> +{
> +	struct task_struct *t;
> +
> +	priv->virt = kvm->arch.pv.stor_var;
> +	priv->real = kvm->arch.pv.stor_base;

Now I know what the struct members actually mean...
Is there a reson you didn't like config_stor_* as a name or something
similar?

> +	priv->handle = kvm_s390_pv_get_handle(kvm);
> +	priv->old_table = (unsigned long)kvm->arch.gmap->table;
> +	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
> +
> +	if (kvm_s390_pv_replace_asce(kvm))
> +		goto fail;
> +
> +	t = kthread_create(kvm_s390_pv_destroy_vm_thread, priv,
> +			   "kvm_s390_pv_destroy_vm_thread");
> +	if (IS_ERR_OR_NULL(t))
> +		goto fail;
> +
> +	memset(&kvm->arch.pv, 0, sizeof(kvm->arch.pv));
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM DEFERRED %d", t->pid);
> +	wake_up_process(t);
> +	/*
> +	 * no actual UVC is performed at this point, just return a successful
> +	 * rc value to make userspace happy, and an arbitrary rrc
> +	 */
> +	*rc = 1;
> +	*rrc = 42;
> +
> +	return 0;
> +
> +fail:
> +	kfree(priv);
> +	return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
> +}
> +
> +/*  Clear the first 2GB of guest memory, to avoid prefix issues after reboot */
> +static void kvm_s390_clear_2g(struct kvm *kvm)
> +{
> +	struct kvm_memory_slot *slot;
> +	struct kvm_memslots *slots;
> +	unsigned long lim;
> +	int idx;
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +
> +	slots = kvm_memslots(kvm);
> +	kvm_for_each_memslot(slot, slots) {
> +		if (slot->base_gfn >= (SZ_2G / PAGE_SIZE))
> +			continue;
> +		if (slot->base_gfn + slot->npages > (SZ_2G / PAGE_SIZE))
> +			lim = slot->userspace_addr + SZ_2G - slot->base_gfn * PAGE_SIZE;
> +		else
> +			lim = slot->userspace_addr + slot->npages * PAGE_SIZE;
> +		s390_uv_destroy_range(kvm->mm, 1, slot->userspace_addr, lim);
> +	}
> +
> +	srcu_read_unlock(&kvm->srcu, idx);
> +}
> +
> +int kvm_s390_pv_deinit_vm_deferred(struct kvm *kvm, u16 *rc, u16 *rrc)
> +{
> +	struct deferred_priv *priv;
> +
> +	priv = kmalloc(sizeof(*priv), GFP_KERNEL | __GFP_ZERO);
> +	if (!priv)
> +		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
> +
> +	if (mmget_not_zero(kvm->mm)) {
> +		kvm_s390_clear_2g(kvm);
> +	} else {
> +		/* No deferred work to do */
> +		kfree(priv);
> +		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
> +	}
> +	priv->mm = kvm->mm;
> +	return deferred_destroy(kvm, priv, rc, rrc);
> +}
> +
>  int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  {
>  	struct uv_cb_cgc uvcb = {
> @@ -263,7 +377,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	atomic_inc(&kvm->mm->context.is_protected);
>  	if (cc) {
>  		if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
> -			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
> +			kvm_s390_pv_deinit_vm_now(kvm, &dummy, &dummy);
>  		} else {
>  			atomic_dec(&kvm->mm->context.is_protected);
>  			kvm_s390_pv_dealloc_vm(kvm);
> 

