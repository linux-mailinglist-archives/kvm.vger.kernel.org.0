Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D1E44DA33
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 17:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhKKQTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 11:19:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35700 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233128AbhKKQTu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 11:19:50 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABFfPVL032256;
        Thu, 11 Nov 2021 16:17:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lWH4fDbvwG+jiWjivCOBDGkbXmXeNe/X63lgTFjdR+M=;
 b=SJYGh9JoC34wNd4jEmDHCiehIXITEIv59vEJxa/QXN9fdy+GYGVso/VZL6AZhhQwwVtZ
 BjtVIBOtZNnIcRv0OuLokNjjmZgCB9dlcCYoWD3pP4jNrUFAFz7poKGi6+oNB2aN4Gjx
 7iWz2jkiygaVzHtJUvCWKXKKC/TEb4QrkjzuWpEC3mA4otwRcd8ZZF2Dvi32K4mXhwZt
 3wlvUDRgtzwVz791qTIZU313RC6mGhRb4RdRfGDgCKWwj2J+bMK1aN42XZacYWlpjlmk
 vYVHQRmeAYx5tVfeBrAvWtsA5DVviHpbRY4jdQR1TSPDzaGH8QaGmfe/3tYRxHZSoNmk Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c94r32yq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 16:17:00 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ABGFS5b020622;
        Thu, 11 Nov 2021 16:17:00 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c94r32ypq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 16:16:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ABGCsJn005462;
        Thu, 11 Nov 2021 16:16:58 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3c5hbb01ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 16:16:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABGGtBL7144144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 16:16:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E38DAA4057;
        Thu, 11 Nov 2021 16:16:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69A93A4051;
        Thu, 11 Nov 2021 16:16:54 +0000 (GMT)
Received: from [9.145.12.141] (unknown [9.145.12.141])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Nov 2021 16:16:54 +0000 (GMT)
Message-ID: <55653464-8a84-d741-1b7e-eb4a163f121f@linux.ibm.com>
Date:   Thu, 11 Nov 2021 17:16:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 2/2] KVM: s390: Extend the USER_SIGP capability
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211110203322.1374925-1-farman@linux.ibm.com>
 <20211110203322.1374925-3-farman@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211110203322.1374925-3-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AxMP_y1SOFzCbVsYMc3bKZcRT9kf_RSW
X-Proofpoint-ORIG-GUID: B729jEKoh6gKypBZMm0s2q1dEX753DnF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_05,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/21 21:33, Eric Farman wrote:
> With commit 2444b352c3ac ("KVM: s390: forward most SIGP orders to user
> space") we have a capability that allows the "fast" SIGP orders (as
> defined by the Programming Notes for the SIGNAL PROCESSOR instruction in
> the Principles of Operation) to be handled in-kernel, while all others are
> sent to userspace for processing.
> 
> This works fine but it creates a situation when, for example, a SIGP SENSE
> might return CC1 (STATUS STORED, and status bits indicating the vcpu is
> stopped), when in actuality userspace is still processing a SIGP STOP AND
> STORE STATUS order, and the vcpu is not yet actually stopped. Thus, the
> SIGP SENSE should actually be returning CC2 (busy) instead of CC1.
> 
> To fix this, add another CPU capability, dependent on the USER_SIGP one,
> and two associated IOCTLs. One IOCTL will be used by userspace to mark a
> vcpu "busy" processing a SIGP order, and cause concurrent orders handled
> in-kernel to be returned with CC2 (busy). Another IOCTL will be used by
> userspace to mark the SIGP "finished", and the vcpu free to process
> additional orders.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  2 ++
>   arch/s390/kvm/kvm-s390.c         | 29 +++++++++++++++++++++++++++++
>   arch/s390/kvm/kvm-s390.h         | 16 ++++++++++++++++
>   arch/s390/kvm/sigp.c             | 10 ++++++++++
>   4 files changed, 57 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a604d51acfc8..c93271557de3 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -748,6 +748,7 @@ struct kvm_vcpu_arch {
>   	bool skey_enabled;
>   	struct kvm_s390_pv_vcpu pv;
>   	union diag318_info diag318_info;
> +	atomic_t sigp_busy;
>   };
>   
>   struct kvm_vm_stat {
> @@ -941,6 +942,7 @@ struct kvm_arch{
>   	int user_sigp;
>   	int user_stsi;
>   	int user_instr0;
> +	int user_sigp_busy;
>   	struct s390_io_adapter *adapters[MAX_S390_IO_ADAPTERS];
>   	wait_queue_head_t ipte_wq;
>   	int ipte_lock_count;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 5f52e7eec02f..06d188dd2c89 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -564,6 +564,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_S390_VCPU_RESETS:
>   	case KVM_CAP_SET_GUEST_DEBUG:
>   	case KVM_CAP_S390_DIAG318:
> +	case KVM_CAP_S390_USER_SIGP_BUSY:
>   		r = 1;
>   		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
> @@ -706,6 +707,15 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   		kvm->arch.user_sigp = 1;
>   		r = 0;
>   		break;
> +	case KVM_CAP_S390_USER_SIGP_BUSY:
> +		r = -EINVAL;
> +		if (kvm->arch.user_sigp) {
> +			kvm->arch.user_sigp_busy = 1;
> +			r = 0;
> +		}
> +		VM_EVENT(kvm, 3, "ENABLE: CAP_S390_USER_SIGP_BUSY %s",
> +			 r ? "(not available)" : "(success)");
> +		break;
>   	case KVM_CAP_S390_VECTOR_REGISTERS:
>   		mutex_lock(&kvm->lock);
>   		if (kvm->created_vcpus) {
> @@ -4825,6 +4835,25 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>   			return -EINVAL;
>   		return kvm_s390_inject_vcpu(vcpu, &s390irq);
>   	}
> +	case KVM_S390_VCPU_SET_SIGP_BUSY: {
> +		int rc;
> +
> +		if (!vcpu->kvm->arch.user_sigp_busy)
> +			return -EFAULT;

Huh?
This should be EINVAL, no?

> +
> +		rc = kvm_s390_vcpu_set_sigp_busy(vcpu);
> +		VCPU_EVENT(vcpu, 3, "SIGP: CPU %x set busy rc %x", vcpu->vcpu_id, rc);
> +
> +		return rc;
> +	}
> +	case KVM_S390_VCPU_RESET_SIGP_BUSY: {
> +		if (!vcpu->kvm->arch.user_sigp_busy)
> +			return -EFAULT;

Same

> +
> +		VCPU_EVENT(vcpu, 3, "SIGP: CPU %x reset busy", vcpu->vcpu_id);
> +		kvm_s390_vcpu_clear_sigp_busy(vcpu);
> +		return 0;
> +	}
>   	}
>   	return -ENOIOCTLCMD;
>   }
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index c07a050d757d..54371cede485 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -82,6 +82,22 @@ static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
>   	return test_bit(vcpu->vcpu_idx, vcpu->kvm->arch.idle_mask);
>   }
>   
> +static inline bool kvm_s390_vcpu_is_sigp_busy(struct kvm_vcpu *vcpu)
> +{
> +	return (atomic_read(&vcpu->arch.sigp_busy) == 1);
> +}
> +
> +static inline bool kvm_s390_vcpu_set_sigp_busy(struct kvm_vcpu *vcpu)
> +{
> +	/* Return zero for success, or -EBUSY if another vcpu won */
> +	return (atomic_cmpxchg(&vcpu->arch.sigp_busy, 0, 1) == 0) ? 0 : -EBUSY;
> +}
> +
> +static inline void kvm_s390_vcpu_clear_sigp_busy(struct kvm_vcpu *vcpu)
> +{
> +	atomic_set(&vcpu->arch.sigp_busy, 0);
> +}
> +
>   static inline int kvm_is_ucontrol(struct kvm *kvm)
>   {
>   #ifdef CONFIG_KVM_S390_UCONTROL
> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> index 5ad3fb4619f1..a37496ea6dfa 100644
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -276,6 +276,10 @@ static int handle_sigp_dst(struct kvm_vcpu *vcpu, u8 order_code,
>   	if (!dst_vcpu)
>   		return SIGP_CC_NOT_OPERATIONAL;
>   
> +	if (kvm_s390_vcpu_is_sigp_busy(dst_vcpu)) {
> +		return SIGP_CC_BUSY;
> +	}
> +
>   	switch (order_code) {
>   	case SIGP_SENSE:
>   		vcpu->stat.instruction_sigp_sense++;
> @@ -411,6 +415,12 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
>   	if (handle_sigp_order_in_user_space(vcpu, order_code, cpu_addr))
>   		return -EOPNOTSUPP;
>   
> +	/* Check the current vcpu, if it was a target from another vcpu */
> +	if (kvm_s390_vcpu_is_sigp_busy(vcpu)) {
> +		kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
> +		return 0;
> +	}
> +
>   	if (r1 % 2)
>   		parameter = vcpu->run->s.regs.gprs[r1];
>   	else
> 

