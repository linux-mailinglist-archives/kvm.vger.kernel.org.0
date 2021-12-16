Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF95477166
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 13:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbhLPMKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 07:10:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30956 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235098AbhLPMKB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 07:10:01 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGBKZKL017612;
        Thu, 16 Dec 2021 12:10:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nkYYAz8FvqLh6demCq9OGyUcgz+FSpbYtdSe2npehdQ=;
 b=nEvHMIz3RHBGRYwEYs567RjMip5ddNlBf80nmOnsSU7GNWN3IV6YsPG4LpAoSRvvFhqJ
 Cees9aAHtjoZfNXhRMj3P2EwiFVW7UyTFBsoPdybvsNBT2BMkGivqr9vjZrY3Bkm14bI
 kjznbae8BO94LkJa1FFGxSu8OQAs+2evs/8XiM2pxO7bzI7HvA40Jscr7hRVTpauZwHx
 gRvFXkBaaqP8+xKFsu25VWSpicT/EhpTNi7OM+DBBGi+orfMUpAOCLz2iE4xn/TgdwxE
 QaGPhTRgbixM4WeGH5JFMRFXfrB2+XiJrRHvbaYclh/HeYOz1IrB1aktsCyfTQnDEAoH Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cynfwb4qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 12:10:00 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BGBP7ZZ014612;
        Thu, 16 Dec 2021 12:10:00 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cynfwb4py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 12:10:00 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BGC7ADK005070;
        Thu, 16 Dec 2021 12:09:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3cy78eerny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 12:09:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BGC1r1b49217954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 12:01:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E063BA4060;
        Thu, 16 Dec 2021 12:09:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77FBCA405B;
        Thu, 16 Dec 2021 12:09:54 +0000 (GMT)
Received: from [9.171.25.78] (unknown [9.171.25.78])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Dec 2021 12:09:54 +0000 (GMT)
Message-ID: <9f996f90-46d2-55b5-323e-0e90286a7b67@linux.ibm.com>
Date:   Thu, 16 Dec 2021 13:09:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC PATCH v5 1/1] KVM: s390: Clarify SIGP orders versus
 STOP/RESTART
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211213210550.856213-1-farman@linux.ibm.com>
 <20211213210550.856213-2-farman@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211213210550.856213-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LtZ9nhhCOZIglTbrKOSrONw-OYqMzRTf
X-Proofpoint-ORIG-GUID: zR4Qyh0oWtDHTbYCTWYURdmXBSz24N8V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_04,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112160068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 13.12.21 um 22:05 schrieb Eric Farman:
> With KVM_CAP_S390_USER_SIGP, there are only five Signal Processor
> orders (CONDITIONAL EMERGENCY SIGNAL, EMERGENCY SIGNAL, EXTERNAL CALL,
> SENSE, and SENSE RUNNING STATUS) which are intended for frequent use
> and thus are processed in-kernel. The remainder are sent to userspace
> with the KVM_CAP_S390_USER_SIGP capability. Of those, three orders
> (RESTART, STOP, and STOP AND STORE STATUS) have the potential to
> inject work back into the kernel, and thus are asynchronous.
> 
> Let's look for those pending IRQs when processing one of the in-kernel
> SIGP orders, and return BUSY (CC2) if one is in process. This is in
> agreement with the Principles of Operation, which states that only one
> order can be "active" on a CPU at a time.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   arch/s390/kvm/interrupt.c |  7 +++++++
>   arch/s390/kvm/kvm-s390.c  |  9 +++++++--
>   arch/s390/kvm/kvm-s390.h  |  1 +
>   arch/s390/kvm/sigp.c      | 28 ++++++++++++++++++++++++++++
>   4 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 37f47e32d9c4..d339e1c47e4d 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -2115,6 +2115,13 @@ int kvm_s390_is_stop_irq_pending(struct kvm_vcpu *vcpu)
>   	return test_bit(IRQ_PEND_SIGP_STOP, &li->pending_irqs);
>   }
>   
> +int kvm_s390_is_restart_irq_pending(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
> +
> +	return test_bit(IRQ_PEND_RESTART, &li->pending_irqs);
> +}
> +
>   void kvm_s390_clear_stop_irq(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 5f52e7eec02f..bfdf610bfecb 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4641,10 +4641,15 @@ int kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
>   		}
>   	}
>   
> -	/* SIGP STOP and SIGP STOP AND STORE STATUS has been fully processed */
> +	/*
> +	 * Set the VCPU to STOPPED and THEN clear the interrupt flag,
> +	 * now that the SIGP STOP and SIGP STOP AND STORE STATUS orders
> +	 * have been fully processed. This will ensure that the VCPU
> +	 * is kept BUSY if another VCPU is inquiring with SIGP SENSE.
> +	 */
> +	kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
>   	kvm_s390_clear_stop_irq(vcpu);
>   
> -	kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
>   	__disable_ibs_on_vcpu(vcpu);
>   
>   	for (i = 0; i < online_vcpus; i++) {
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index c07a050d757d..1876ab0c293f 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -427,6 +427,7 @@ void kvm_s390_destroy_adapters(struct kvm *kvm);
>   int kvm_s390_ext_call_pending(struct kvm_vcpu *vcpu);
>   extern struct kvm_device_ops kvm_flic_ops;
>   int kvm_s390_is_stop_irq_pending(struct kvm_vcpu *vcpu);
> +int kvm_s390_is_restart_irq_pending(struct kvm_vcpu *vcpu);
>   void kvm_s390_clear_stop_irq(struct kvm_vcpu *vcpu);
>   int kvm_s390_set_irq_state(struct kvm_vcpu *vcpu,
>   			   void __user *buf, int len);
> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> index 5ad3fb4619f1..c4884de0858b 100644
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -276,6 +276,34 @@ static int handle_sigp_dst(struct kvm_vcpu *vcpu, u8 order_code,
>   	if (!dst_vcpu)
>   		return SIGP_CC_NOT_OPERATIONAL;
>   
> +	/*
> +	 * SIGP RESTART, SIGP STOP, and SIGP STOP AND STORE STATUS orders
> +	 * are processed asynchronously. Until the affected VCPU finishes
> +	 * its work and calls back into KVM to clear the (RESTART or STOP)
> +	 * interrupt, we need to return any new non-reset orders "busy".
> +	 *
> +	 * This is important because a single VCPU could issue:
> +	 *  1) SIGP STOP $DESTINATION
> +	 *  2) SIGP SENSE $DESTINATION
> +	 *
> +	 * If the SIGP SENSE would not be rejected as "busy", it could
> +	 * return an incorrect answer as to whether the VCPU is STOPPED
> +	 * or OPERATING.
> +	 */
> +	if (order_code != SIGP_INITIAL_CPU_RESET &&
> +	    order_code != SIGP_CPU_RESET) {
> +		/*
> +		 * Lockless check. Both SIGP STOP and SIGP (RE)START
> +		 * properly synchronize everything while processing
> +		 * their orders, while the guest cannot observe a
> +		 * difference when issuing other orders from two
> +		 * different VCPUs.
> +		 */
> +		if (kvm_s390_is_stop_irq_pending(dst_vcpu) ||
> +		    kvm_s390_is_restart_irq_pending(dst_vcpu))
> +			return SIGP_CC_BUSY;
> +	}
> +

Kind of similar to v1 but much simpler
took me a while to review, but I think you are right, no need for taking the lock.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>


>   	switch (order_code) {
>   	case SIGP_SENSE:
>   		vcpu->stat.instruction_sigp_sense++;
> 
