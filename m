Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C26475AC8
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 15:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbhLOOjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 09:39:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55182 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243415AbhLOOjZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 09:39:25 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BFDVVrN032035;
        Wed, 15 Dec 2021 14:39:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=dTXDxPIBM+7Po1b73WKzTSEpx4P0J1FtSJ0qi56iwPw=;
 b=fZupt5Bu62gZQCj853r2xnFNRcid+Lr+9WCCNEm6irf1tvguhdgiUQGo7GyVXbw40JFN
 oM/CL1tmRb8HyF5pxXHFHCzgQvbj+uO8ePWAxqcHqGeRpYQN5szDjUKM3LJQAtMbY3+n
 h7yT2qZkSeO0AkrwYVFUfRQwsnfNg68EQM68n5UsSHwrCGPUoHb6lapulAFeBCKaKSYv
 IpL9977YakDb0SAB+mIAZna1lWdniQUBngrFe0igSbm7+HFGD28e2HgYB9dqgRhBoGYp
 HUfaSmOASUpY5VIiYO2iMam6fmS/mtyoNGfFdqLznkt3vh27bIWHI0cvlYZPh/Zcoqqj 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cye11e63y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 14:39:24 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BFDwDA5025474;
        Wed, 15 Dec 2021 14:39:24 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cye11e63j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 14:39:23 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BFEbL8m016625;
        Wed, 15 Dec 2021 14:39:23 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma05wdc.us.ibm.com with ESMTP id 3cy7973uw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 14:39:23 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BFEdLt033095990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 14:39:21 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DFBEC605A;
        Wed, 15 Dec 2021 14:39:21 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A89CC605B;
        Wed, 15 Dec 2021 14:39:20 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.90.76])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 15 Dec 2021 14:39:20 +0000 (GMT)
Message-ID: <132f6fbce4a2de772113067b202fb1826cff24ce.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v5 1/1] KVM: s390: Clarify SIGP orders versus
 STOP/RESTART
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Wed, 15 Dec 2021 09:39:19 -0500
In-Reply-To: <c6536d85-dcee-1b6b-08bc-335716c7f23e@de.ibm.com>
References: <20211213210550.856213-1-farman@linux.ibm.com>
         <20211213210550.856213-2-farman@linux.ibm.com>
         <c6536d85-dcee-1b6b-08bc-335716c7f23e@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AxR6AHYUJFzK8ztfgT3yxqbtREKOBTqV
X-Proofpoint-ORIG-GUID: Q9IwIpz7H4XwZ4A32O-RCJqLfzE4n0Ca
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_09,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 impostorscore=0 spamscore=0 clxscore=1015
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-12-15 at 14:07 +0100, Christian Borntraeger wrote:
> 
> Am 13.12.21 um 22:05 schrieb Eric Farman:
> > With KVM_CAP_S390_USER_SIGP, there are only five Signal Processor
> > orders (CONDITIONAL EMERGENCY SIGNAL, EMERGENCY SIGNAL, EXTERNAL
> > CALL,
> > SENSE, and SENSE RUNNING STATUS) which are intended for frequent
> > use
> > and thus are processed in-kernel. The remainder are sent to
> > userspace
> > with the KVM_CAP_S390_USER_SIGP capability. Of those, three orders
> > (RESTART, STOP, and STOP AND STORE STATUS) have the potential to
> > inject work back into the kernel, and thus are asynchronous.
> > 
> > Let's look for those pending IRQs when processing one of the in-
> > kernel
> > SIGP orders, and return BUSY (CC2) if one is in process. This is in
> > agreement with the Principles of Operation, which states that only
> > one
> > order can be "active" on a CPU at a time.
> 
> As far as I understand this fixes a real bug with some test tools.
> Correct?

Correct.

> Then a stable tag might be appropriate.

Agreed.

> (Still have to review this)
> 
> How hard would it be to also build a kvm-unit test testcase?

I don't think it's too hard, and something I'd like to see done rather
than the setup I'm using. It's on my list for after the holidays.

> 
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >   arch/s390/kvm/interrupt.c |  7 +++++++
> >   arch/s390/kvm/kvm-s390.c  |  9 +++++++--
> >   arch/s390/kvm/kvm-s390.h  |  1 +
> >   arch/s390/kvm/sigp.c      | 28 ++++++++++++++++++++++++++++
> >   4 files changed, 43 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> > index 37f47e32d9c4..d339e1c47e4d 100644
> > --- a/arch/s390/kvm/interrupt.c
> > +++ b/arch/s390/kvm/interrupt.c
> > @@ -2115,6 +2115,13 @@ int kvm_s390_is_stop_irq_pending(struct
> > kvm_vcpu *vcpu)
> >   	return test_bit(IRQ_PEND_SIGP_STOP, &li->pending_irqs);
> >   }
> >   
> > +int kvm_s390_is_restart_irq_pending(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
> > +
> > +	return test_bit(IRQ_PEND_RESTART, &li->pending_irqs);
> > +}
> > +
> >   void kvm_s390_clear_stop_irq(struct kvm_vcpu *vcpu)
> >   {
> >   	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 5f52e7eec02f..bfdf610bfecb 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -4641,10 +4641,15 @@ int kvm_s390_vcpu_stop(struct kvm_vcpu
> > *vcpu)
> >   		}
> >   	}
> >   
> > -	/* SIGP STOP and SIGP STOP AND STORE STATUS has been fully
> > processed */
> > +	/*
> > +	 * Set the VCPU to STOPPED and THEN clear the interrupt flag,
> > +	 * now that the SIGP STOP and SIGP STOP AND STORE STATUS orders
> > +	 * have been fully processed. This will ensure that the VCPU
> > +	 * is kept BUSY if another VCPU is inquiring with SIGP SENSE.
> > +	 */
> > +	kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
> >   	kvm_s390_clear_stop_irq(vcpu);
> >   
> > -	kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
> >   	__disable_ibs_on_vcpu(vcpu);
> >   
> >   	for (i = 0; i < online_vcpus; i++) {
> > diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> > index c07a050d757d..1876ab0c293f 100644
> > --- a/arch/s390/kvm/kvm-s390.h
> > +++ b/arch/s390/kvm/kvm-s390.h
> > @@ -427,6 +427,7 @@ void kvm_s390_destroy_adapters(struct kvm
> > *kvm);
> >   int kvm_s390_ext_call_pending(struct kvm_vcpu *vcpu);
> >   extern struct kvm_device_ops kvm_flic_ops;
> >   int kvm_s390_is_stop_irq_pending(struct kvm_vcpu *vcpu);
> > +int kvm_s390_is_restart_irq_pending(struct kvm_vcpu *vcpu);
> >   void kvm_s390_clear_stop_irq(struct kvm_vcpu *vcpu);
> >   int kvm_s390_set_irq_state(struct kvm_vcpu *vcpu,
> >   			   void __user *buf, int len);
> > diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> > index 5ad3fb4619f1..c4884de0858b 100644
> > --- a/arch/s390/kvm/sigp.c
> > +++ b/arch/s390/kvm/sigp.c
> > @@ -276,6 +276,34 @@ static int handle_sigp_dst(struct kvm_vcpu
> > *vcpu, u8 order_code,
> >   	if (!dst_vcpu)
> >   		return SIGP_CC_NOT_OPERATIONAL;
> >   
> > +	/*
> > +	 * SIGP RESTART, SIGP STOP, and SIGP STOP AND STORE STATUS
> > orders
> > +	 * are processed asynchronously. Until the affected VCPU
> > finishes
> > +	 * its work and calls back into KVM to clear the (RESTART or
> > STOP)
> > +	 * interrupt, we need to return any new non-reset orders
> > "busy".
> > +	 *
> > +	 * This is important because a single VCPU could issue:
> > +	 *  1) SIGP STOP $DESTINATION
> > +	 *  2) SIGP SENSE $DESTINATION
> > +	 *
> > +	 * If the SIGP SENSE would not be rejected as "busy", it could
> > +	 * return an incorrect answer as to whether the VCPU is STOPPED
> > +	 * or OPERATING.
> > +	 */
> > +	if (order_code != SIGP_INITIAL_CPU_RESET &&
> > +	    order_code != SIGP_CPU_RESET) {
> > +		/*
> > +		 * Lockless check. Both SIGP STOP and SIGP (RE)START
> > +		 * properly synchronize everything while processing
> > +		 * their orders, while the guest cannot observe a
> > +		 * difference when issuing other orders from two
> > +		 * different VCPUs.
> > +		 */
> > +		if (kvm_s390_is_stop_irq_pending(dst_vcpu) ||
> > +		    kvm_s390_is_restart_irq_pending(dst_vcpu))
> > +			return SIGP_CC_BUSY;
> > +	}
> > +
> >   	switch (order_code) {
> >   	case SIGP_SENSE:
> >   		vcpu->stat.instruction_sigp_sense++;
> > 

