Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C85654C699
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 12:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344435AbiFOK6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 06:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242799AbiFOK6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 06:58:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FF9252A9;
        Wed, 15 Jun 2022 03:58:08 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FAJX03011824;
        Wed, 15 Jun 2022 10:58:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C4vMRRi1D2cJwV0PhiCWcFn+hJT19+STCZkVDOc5sqU=;
 b=I/2iGZ0pvMREkFB6BwfZI/zLUACk6n67iRPHWN7wbgG7GTbE90FJBeWmm8FeHPXgJflH
 moBP+7V5VP5aT0gAhFUQuqqNrgIdoXREtpHvA3v1t6eyE38GQ0s+YG5mnGpaad9n5VMD
 1ak+npE3Tcii8ytu0gISX4cvP/LkK+Jem29SPxH04eRBPkce9g7ukG7ojNFRBAjwff3k
 EvmA9C9FMxFqEunWx1+BFp3xBDQp1I3pSzy+aSnVVwM4RNd0C2XltfACyDsAZ7Ni+XWz
 lnW52fTFzRsQkqbSTtVuXhbL2wwJBPDnGnw1MlhzT6kIeDDy0WcHUiS619BQhvpsbI/V kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpr3g425r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 10:58:07 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25F8oVBN031273;
        Wed, 15 Jun 2022 10:58:06 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpr3g4251-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 10:58:06 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25FAoknN009479;
        Wed, 15 Jun 2022 10:58:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3gmjajdptj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 10:58:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25FAw1BH21758372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 10:58:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B85EBAE045;
        Wed, 15 Jun 2022 10:58:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C598AE055;
        Wed, 15 Jun 2022 10:58:01 +0000 (GMT)
Received: from [9.145.158.83] (unknown [9.145.158.83])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Jun 2022 10:58:00 +0000 (GMT)
Message-ID: <60d0d472-ca46-7a34-c1a2-b4342a4eb9f7@linux.ibm.com>
Date:   Wed, 15 Jun 2022 12:58:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
 <20220603065645.10019-16-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v11 15/19] KVM: s390: pv: asynchronous destroy for reboot
In-Reply-To: <20220603065645.10019-16-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sLkvmm6zY2Dj_-IB-x04UoqclrtDjlTw
X-Proofpoint-GUID: DhV2RtsGLyCk748KZ6RxrBmkf9g6Qfcc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_03,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206150040
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/22 08:56, Claudio Imbrenda wrote:
> Until now, destroying a protected guest was an entirely synchronous
> operation that could potentially take a very long time, depending on
> the size of the guest, due to the time needed to clean up the address
> space from protected pages.
> 
> This patch implements an asynchronous destroy mechanism, that allows a
> protected guest to reboot significantly faster than previously.
> 
> This is achieved by clearing the pages of the old guest in background.
> In case of reboot, the new guest will be able to run in the same
> address space almost immediately.
> 
> The old protected guest is then only destroyed when all of its memory has
> been destroyed or otherwise made non protected.
> 
> Two new PV commands are added for the KVM_S390_PV_COMMAND ioctl:
> 
> KVM_PV_ASYNC_DISABLE_PREPARE: prepares the current protected VM for
> asynchronous teardown. The current VM will then continue immediately
> as non-protected. If a protected VM had already been set aside without
> starting the teardown process, this call will fail.
> 
> KVM_PV_ASYNC_DISABLE: tears down the protected VM previously set aside
> for asynchronous teardown. This PV command should ideally be issued by
> userspace from a separate thread. If a fatal signal is received (or the
> process terminates naturally), the command will terminate immediately
> without completing.
> 
> Leftover protected VMs are cleaned up when a KVM VM is torn down
> normally (either via IOCTL or when the process terminates); this
> cleanup has been implemented in a previous patch.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c |  34 +++++++++-
>   arch/s390/kvm/kvm-s390.h |   2 +
>   arch/s390/kvm/pv.c       | 131 +++++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/kvm.h |   2 +
>   4 files changed, 166 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 369de8377116..842419092c0c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2256,9 +2256,13 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>   
>   static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>   {
> +	const bool needslock = (cmd->cmd != KVM_PV_ASYNC_DISABLE);
> +	void __user *argp = (void __user *)cmd->data;
>   	int r = 0;
>   	u16 dummy;
> -	void __user *argp = (void __user *)cmd->data;
> +
> +	if (needslock)
> +		mutex_lock(&kvm->lock);
>   
>   	switch (cmd->cmd) {
>   	case KVM_PV_ENABLE: {
> @@ -2292,6 +2296,28 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>   		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
>   		break;
>   	}
> +	case KVM_PV_ASYNC_DISABLE_PREPARE:
> +		r = -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm) || !async_destroy)
> +			break;
> +
> +		r = kvm_s390_cpus_from_pv(kvm, &cmd->rc, &cmd->rrc);
> +		/*
> +		 * If a CPU could not be destroyed, destroy VM will also fail.
> +		 * There is no point in trying to destroy it. Instead return
> +		 * the rc and rrc from the first CPU that failed destroying.
> +		 */
> +		if (r)
> +			break;
> +		r = kvm_s390_pv_deinit_vm_async_prepare(kvm, &cmd->rc, &cmd->rrc);
> +
> +		/* no need to block service interrupts any more */
> +		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
> +		break;
> +	case KVM_PV_ASYNC_DISABLE:
> +		/* This must not be called while holding kvm->lock */
> +		r = kvm_s390_pv_deinit_vm_async(kvm, &cmd->rc, &cmd->rrc);
> +		break;
>   	case KVM_PV_DISABLE: {
>   		r = -EINVAL;
>   		if (!kvm_s390_pv_is_protected(kvm))
> @@ -2393,6 +2419,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>   	default:
>   		r = -ENOTTY;
>   	}
> +	if (needslock)
> +		mutex_unlock(&kvm->lock);
> +
>   	return r;
>   }
>   
> @@ -2597,9 +2626,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   			r = -EINVAL;
>   			break;
>   		}
> -		mutex_lock(&kvm->lock);
> +		/* must be called without kvm->lock */
>   		r = kvm_s390_handle_pv(kvm, &args);
> -		mutex_unlock(&kvm->lock);
>   		if (copy_to_user(argp, &args, sizeof(args))) {
>   			r = -EFAULT;
>   			break;
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index d3abedafa7a8..d296afb6041c 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -243,6 +243,8 @@ static inline u32 kvm_s390_get_gisa_desc(struct kvm *kvm)
>   /* implemented in pv.c */
>   int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
>   int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
> +int kvm_s390_pv_deinit_vm_async_prepare(struct kvm *kvm, u16 *rc, u16 *rrc);
> +int kvm_s390_pv_deinit_vm_async(struct kvm *kvm, u16 *rc, u16 *rrc);
>   int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
>   int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
>   int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 8471c17d538c..ab06fa366e49 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -279,6 +279,137 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	return cc ? -EIO : 0;
>   }
>   
> +/**
> + * kvm_s390_destroy_lower_2g - Destroy the first 2GB of protected guest memory.
> + * @kvm the VM whose memory is to be cleared.
> + * Destroy the first 2GB of guest memory, to avoid prefix issues after reboot.
> + */
> +static void kvm_s390_destroy_lower_2g(struct kvm *kvm)
> +{
> +	struct kvm_memory_slot *slot;
> +	unsigned long lim;
> +	int srcu_idx;
> +
> +	srcu_idx = srcu_read_lock(&kvm->srcu);
> +
> +	/* Take the memslot containing guest absolute address 0 */
> +	slot = gfn_to_memslot(kvm, 0);
> +	/* Clear all slots that are completely below 2GB */
> +	while (slot && slot->base_gfn + slot->npages < SZ_2G / PAGE_SIZE) {
> +		lim = slot->userspace_addr + slot->npages * PAGE_SIZE;
> +		s390_uv_destroy_range(kvm->mm, slot->userspace_addr, lim);
> +		/* Take the next memslot */
> +		slot = gfn_to_memslot(kvm, slot->base_gfn + slot->npages);
> +	}
> +	/* Last slot crosses the 2G boundary, clear only up to 2GB */
> +	if (slot && slot->base_gfn < SZ_2G / PAGE_SIZE) {
> +		lim = slot->userspace_addr + SZ_2G - slot->base_gfn * PAGE_SIZE;
> +		s390_uv_destroy_range(kvm->mm, slot->userspace_addr, lim);
> +	}

Any reason why you split that up instead of always calculating a length 
and using MIN()?

