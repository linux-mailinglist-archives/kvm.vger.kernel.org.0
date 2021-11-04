Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56298445561
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 15:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhKDOgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 10:36:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22544 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231152AbhKDOgD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Nov 2021 10:36:03 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4DlQfD030055;
        Thu, 4 Nov 2021 14:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=hbCmTDioNgE9AyramxL99EI0WvI0SFAlQJTOfIwbFA0=;
 b=GpZJCe1kAz//aVFeZYJFNCuBd+ZIqUJnRl9k+Y/lOdHyneGEd82OjBru26PtGf9z+JpT
 76Qfa41+TxUY60lqWb8DM8CyS6g6D4eURkIFry6EukagLTOCeJh4XQy17k/nqdbDB68r
 EJw8rZRhqudiEYuTX4zNrZ6Lo8CK+he8IbNZ5O2hTB8cptdO4s9wSmBIvZ688+VjBZL+
 rki/teyBayJrjXzJ2goaAXSnOzYZJUzmxrlqOixQnIyz4KQkRmf3hfOba0RuXUTGPyMm
 xiAkYGdEsUOMy+TLwweT69c9ItxpGrDsEC3LTaBlgQrR96gZe2NnXCBNp0Dfp/9tdsWy Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c4gqa90vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 14:33:23 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A4ETB2l007143;
        Thu, 4 Nov 2021 14:33:23 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c4gqa90v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 14:33:23 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A4E2ETg012176;
        Thu, 4 Nov 2021 14:33:22 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02wdc.us.ibm.com with ESMTP id 3c0wpcjc8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 14:33:22 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A4EXLku46727542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Nov 2021 14:33:21 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79BD8B205F;
        Thu,  4 Nov 2021 14:33:21 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C01E5B2070;
        Thu,  4 Nov 2021 14:33:19 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.105.133])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  4 Nov 2021 14:33:19 +0000 (GMT)
Message-ID: <2ad9bef6b39a5a6c9b634cab7d70d110064d8f04.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v2 2/2] KVM: s390: Extend the USER_SIGP capability
From:   Eric Farman <farman@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Thu, 04 Nov 2021 10:33:18 -0400
In-Reply-To: <7e98f659-32ac-9b4e-0ddd-958086732c8d@redhat.com>
References: <20211102194652.2685098-1-farman@linux.ibm.com>
         <20211102194652.2685098-3-farman@linux.ibm.com>
         <7e98f659-32ac-9b4e-0ddd-958086732c8d@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0p0TTUpET_0aZ021ArU-buqyN511p5my
X-Proofpoint-ORIG-GUID: IPhubRuwuPRZrqlsrBn3ZFeCY9gepS9N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_04,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-11-04 at 10:06 +0100, David Hildenbrand wrote:
> On 02.11.21 20:46, Eric Farman wrote:
> > With commit 2444b352c3ac ("KVM: s390: forward most SIGP orders to
> > user
> > space") we have a capability that allows the "fast" SIGP orders (as
> > defined by the Programming Notes for the SIGNAL PROCESSOR
> > instruction in
> > the Principles of Operation) to be handled in-kernel, while all
> > others are
> > sent to userspace for processing.
> > 
> > This works fine but it creates a situation when, for example, a
> > SIGP SENSE
> > might return CC1 (STATUS STORED, and status bits indicating the
> > vcpu is
> > stopped), when in actuality userspace is still processing a SIGP
> > STOP AND
> > STORE STATUS order, and the vcpu is not yet actually stopped. Thus,
> > the
> > SIGP SENSE should actually be returning CC2 (busy) instead of CC1.
> > 
> > To fix this, add another CPU capability, dependent on the USER_SIGP
> > one,
> > that will mark a vcpu as "busy" processing a SIGP order, and a
> > corresponding IOCTL that userspace can call to indicate it has
> > finished
> > its work and the SIGP operation is completed.
> > 
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >  arch/s390/include/asm/kvm_host.h |  2 ++
> >  arch/s390/kvm/kvm-s390.c         | 18 ++++++++++++++
> >  arch/s390/kvm/kvm-s390.h         | 10 ++++++++
> >  arch/s390/kvm/sigp.c             | 40
> > ++++++++++++++++++++++++++++++++
> >  4 files changed, 70 insertions(+)
> > 
> > diff --git a/arch/s390/include/asm/kvm_host.h
> > b/arch/s390/include/asm/kvm_host.h
> > index a604d51acfc8..bd202bb3acb5 100644
> > --- a/arch/s390/include/asm/kvm_host.h
> > +++ b/arch/s390/include/asm/kvm_host.h
> > @@ -746,6 +746,7 @@ struct kvm_vcpu_arch {
> >  	__u64 cputm_start;
> >  	bool gs_enabled;
> >  	bool skey_enabled;
> > +	atomic_t sigp_busy;
> >  	struct kvm_s390_pv_vcpu pv;
> >  	union diag318_info diag318_info;
> >  };
> > @@ -941,6 +942,7 @@ struct kvm_arch{
> >  	int user_sigp;
> >  	int user_stsi;
> >  	int user_instr0;
> > +	int user_sigp_busy;
> >  	struct s390_io_adapter *adapters[MAX_S390_IO_ADAPTERS];
> >  	wait_queue_head_t ipte_wq;
> >  	int ipte_lock_count;
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 5f52e7eec02f..ff23a46288cc 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -564,6 +564,7 @@ int kvm_vm_ioctl_check_extension(struct kvm
> > *kvm, long ext)
> >  	case KVM_CAP_S390_VCPU_RESETS:
> >  	case KVM_CAP_SET_GUEST_DEBUG:
> >  	case KVM_CAP_S390_DIAG318:
> > +	case KVM_CAP_S390_USER_SIGP_BUSY:
> >  		r = 1;
> >  		break;
> >  	case KVM_CAP_SET_GUEST_DEBUG2:
> > @@ -706,6 +707,15 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > struct kvm_enable_cap *cap)
> >  		kvm->arch.user_sigp = 1;
> >  		r = 0;
> >  		break;
> > +	case KVM_CAP_S390_USER_SIGP_BUSY:
> > +		r = -EINVAL;
> > +		if (kvm->arch.user_sigp) {
> > +			kvm->arch.user_sigp_busy = 1;
> > +			r = 0;
> > +		}
> > +		VM_EVENT(kvm, 3, "ENABLE: CAP_S390_USER_SIGP_BUSY %s",
> > +			 r ? "(not available)" : "(success)");
> > +		break;
> >  	case KVM_CAP_S390_VECTOR_REGISTERS:
> >  		mutex_lock(&kvm->lock);
> >  		if (kvm->created_vcpus) {
> > @@ -4825,6 +4835,14 @@ long kvm_arch_vcpu_async_ioctl(struct file
> > *filp,
> >  			return -EINVAL;
> >  		return kvm_s390_inject_vcpu(vcpu, &s390irq);
> >  	}
> > +	case KVM_S390_VCPU_RESET_SIGP_BUSY: {
> > +		if (!vcpu->kvm->arch.user_sigp_busy)
> > +			return -EFAULT;
> > +
> > +		VCPU_EVENT(vcpu, 3, "SIGP: CPU %x reset busy", vcpu-
> > >vcpu_id);
> > +		kvm_s390_vcpu_clear_sigp_busy(vcpu);
> > +		return 0;
> > +	}
> >  	}
> >  	return -ENOIOCTLCMD;
> >  }
> > diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> > index c07a050d757d..9ce97832224b 100644
> > --- a/arch/s390/kvm/kvm-s390.h
> > +++ b/arch/s390/kvm/kvm-s390.h
> > @@ -82,6 +82,16 @@ static inline int is_vcpu_idle(struct kvm_vcpu
> > *vcpu)
> >  	return test_bit(vcpu->vcpu_idx, vcpu->kvm->arch.idle_mask);
> >  }
> >  
> > +static inline bool kvm_s390_vcpu_set_sigp_busy(struct kvm_vcpu
> > *vcpu)
> > +{
> > +	return (atomic_cmpxchg(&vcpu->arch.sigp_busy, 0, 1) == 0);
> > +}
> > +
> > +static inline void kvm_s390_vcpu_clear_sigp_busy(struct kvm_vcpu
> > *vcpu)
> > +{
> > +	atomic_set(&vcpu->arch.sigp_busy, 0);
> > +}
> > +
> >  static inline int kvm_is_ucontrol(struct kvm *kvm)
> >  {
> >  #ifdef CONFIG_KVM_S390_UCONTROL
> > diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> > index 5ad3fb4619f1..034ea72e098a 100644
> > --- a/arch/s390/kvm/sigp.c
> > +++ b/arch/s390/kvm/sigp.c
> > @@ -341,9 +341,42 @@ static int handle_sigp_dst(struct kvm_vcpu
> > *vcpu, u8 order_code,
> >  			   "sigp order %u -> cpu %x: handled in user
> > space",
> >  			   order_code, dst_vcpu->vcpu_id);
> >  
> > +	kvm_s390_vcpu_clear_sigp_busy(dst_vcpu);
> > +
> >  	return rc;
> >  }
> >  
> > +static int handle_sigp_order_busy(struct kvm_vcpu *vcpu, u8
> > order_code,
> > +				  u16 cpu_addr)
> > +{
> > +	struct kvm_vcpu *dst_vcpu = kvm_get_vcpu_by_id(vcpu->kvm,
> > cpu_addr);
> > +
> > +	if (!vcpu->kvm->arch.user_sigp_busy)
> > +		return 0;
> > +
> > +	/*
> > +	 * Just see if the target vcpu exists; the CC3 will be set
> > wherever
> > +	 * the SIGP order is processed directly.
> > +	 */
> > +	if (!dst_vcpu)
> > +		return 0;
> > +
> > +	/* Reset orders will be accepted, regardless if target vcpu is
> > busy */
> > +	if (order_code == SIGP_INITIAL_CPU_RESET ||
> > +	    order_code == SIGP_CPU_RESET)
> > +		return 0;
> > +
> > +	/* Orders that affect multiple vcpus should not flag one vcpu
> > busy */
> > +	if (order_code == SIGP_SET_ARCHITECTURE)
> > +		return 0;
> > +
> > +	/* If this fails, the vcpu is already busy processing another
> > SIGP */
> > +	if (!kvm_s390_vcpu_set_sigp_busy(dst_vcpu))
> > +		return -EBUSY;
> > +
> > +	return 0;
> > +}
> > +
> >  static int handle_sigp_order_in_user_space(struct kvm_vcpu *vcpu,
> > u8 order_code,
> >  					   u16 cpu_addr)
> >  {
> > @@ -408,6 +441,13 @@ int kvm_s390_handle_sigp(struct kvm_vcpu
> > *vcpu)
> >  		return kvm_s390_inject_program_int(vcpu,
> > PGM_PRIVILEGED_OP);
> >  
> >  	order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
> > +
> > +	rc = handle_sigp_order_busy(vcpu, order_code, cpu_addr);
> > +	if (rc) {
> > +		kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
> > +		return 0;
> > +	}
> > +
> >  	if (handle_sigp_order_in_user_space(vcpu, order_code,
> > cpu_addr))
> >  		return -EOPNOTSUPP;
> 
> After looking at the QEMU side, I wonder if we should instead:
> 
> a) Let user space always set/reset SIGP busy. Don't set/reset it in
> the
>    kernel automatically. All "heavy weight" SIGP orders are carried
> out
>    in user space nowadays either way.
> b) Reject all in-kernel SIGP orders targeting a CPU if marked BUSY by
>    user space. (i.e., SIGP SENSE)
> c) Don't reject SIGP orders that will be handled in QEMU from the
>    kernel. Just let user space deal with it -- especially with the
>    "problematic" ones like RESET and SET_ARCHITECTURE.
> 
> For example, we don't care about concurrent SIGP SENSE. We only care
> about "lightweight" SIGP orders with concurrent "heavy weight" SIGP
> orders.

I very much care about concurrent SIGP SENSE (a "lightweight" order
handled in-kernel) and how that interacts with the "heavy weight" SIGP
orders (handled in userspace). SIGP SENSE might return CC0 (accepted)
if a vcpu is operating normally, or CC1 (status stored) with status
bits indicating an external call is pending and/or the vcpu is stopped.
This means that the actual response will depend on whether userspace
has picked up the sigp order and processed it or not. Giving CC0 when
userspace is actively processing a SIGP STOP/STOP AND STORE STATUS
would be misleading for the SIGP SENSE. (Did the STOP order get lost?
Failed? Not yet dispatched? Blocked?)

Meanwhile, the Principles of Operation (SA22-7832-12) page 4-95
describes a list of orders that would generate a CC2 (busy) when the
order is still "active" in userspace:

"""
A previously issued start, stop, restart, stop-
and-store-status, set-prefix, store-status-at-
address order, or store-additional-status-at-
address has been accepted by the
addressed CPU, and execution of the func-
tion requested by the order has not yet been
completed.
...
If the currently specified order is sense, external
call, emergency signal, start, stop, restart, stop
and store status, set prefix, store status at
address, set architecture, set multithreading, or
store additional status at address, then the order
is rejected, and condition code 2 is set. If the cur-
rently specified order is one of the reset orders,
or an unassigned or not-implemented order, the
order code is interpreted as described in “Status
Bits” on page 4-96.
"""

(There is another entry for the reset orders; not copied here for sake
of keeping my novella manageable.)

So, you're right that I could be more precise in terms how QEMU handles
a SIGP order while it's already busy handling one, and only limit the
CC2 from the kernel to those in-kernel orders. But I did say I took
this simplified approach in the cover letter. :)

Regardless, because of the above I really do want/need a way to give
the kernel a clue that userspace is doing something, without waiting
for userspace to say "hey, that order you kicked back to me? I'm
working on it now, I'll let you know when it's done!" Otherwise, SIGP
SENSE (and other lightweight friends) is still racing with the receipt
of a "start the sigp" ioctl.

> 
> This should simplify this code and avoid having to clear the the BUSY
> flag in QEMU (that might be bogus) when detecting another BUSY
> situation
> (the trylock thingy, see my QEMU reply).

Still digesting that one. Regarding the potential bogus indicator, at
one point I had the kernel recording the SIGP order itself that was
sent to a vcpu, similar to QEMU's cpu->env.sigp_order (which is only
used for the STOP variants?), instead of the simple toggle used here. I
found myself not really caring WHAT the order was, just that QEMU was
doing SOMETHING, which is why it's just on/off.

But it does mean that the QEMU patch is rather unpleasant, and maybe
knowing what order is being reset helps clean up that side of things?

>  The downside is that we have to
> issue yet another IOCTL to set the CPU busy for SIGP -- not sure if
> we
> really care.


