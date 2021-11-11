Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFD844D8D8
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 16:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhKKPGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 10:06:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232126AbhKKPGI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 10:06:08 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABEwv42004662;
        Thu, 11 Nov 2021 15:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=pJt7JxxwoIxkvnySVaWlHe9mBmlkZtl3vD835yG7Ik8=;
 b=OIDMyCq72GzCoFHLGC3hr8s5DHqac9zLF8XidQIdp+x6kKP+cPPjIzNA+86FN2ngaRIO
 HxhML08LfjpG/tTtVwHPUNNH9wWiskr8bokouNVRJWW9PR115S10kXxmCyG3BMA7u99K
 RVN3i5Nt18KNsbmrZ78uJxDF3dG1aobKpiUtEK8BrQVkyYu+aZau+lnT2ZvMyiZLFcO7
 ecXPo/kM3jf3Bc6Dxt/V33iGScAiQ0yvVVDfUz9ycsOBvsos7SXlL74CHgyE3+UHP8v8
 cb+67q2eSa4uNApCKuMXqlMeJzMF2lvj6XBQS3Umj9UhCvTm77TuZuJ2l1E1vTR+XldZ VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c94w5s57x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 15:03:18 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ABEwwK8004782;
        Thu, 11 Nov 2021 15:03:18 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c94w5s57g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 15:03:18 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ABF2vwL030386;
        Thu, 11 Nov 2021 15:03:17 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 3c5hbd5gr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 15:03:17 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABF3F7e15532666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 15:03:15 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A593BAE064;
        Thu, 11 Nov 2021 15:03:15 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FA50AE067;
        Thu, 11 Nov 2021 15:03:13 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.106.148])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 11 Nov 2021 15:03:13 +0000 (GMT)
Message-ID: <ab82e68051674ea771e2cb5371ca2a204effab40.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v3 2/2] KVM: s390: Extend the USER_SIGP capability
From:   Eric Farman <farman@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Thu, 11 Nov 2021 10:03:12 -0500
In-Reply-To: <dd8a8b49-da6d-0ab8-dc47-b24f5604767f@redhat.com>
References: <20211110203322.1374925-1-farman@linux.ibm.com>
         <20211110203322.1374925-3-farman@linux.ibm.com>
         <dd8a8b49-da6d-0ab8-dc47-b24f5604767f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4INnjYFx4JwrkGXBzSCK_OPMpkQx4mQo
X-Proofpoint-ORIG-GUID: 4QZCR_cBqu4o_3KKnkkz_KNXRa7iH5Rz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_04,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 clxscore=1011 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-11-11 at 10:15 +0100, David Hildenbrand wrote:
> On 10.11.21 21:33, Eric Farman wrote:
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
> > and two associated IOCTLs. One IOCTL will be used by userspace to
> > mark a
> > vcpu "busy" processing a SIGP order, and cause concurrent orders
> > handled
> > in-kernel to be returned with CC2 (busy). Another IOCTL will be
> > used by
> > userspace to mark the SIGP "finished", and the vcpu free to process
> > additional orders.
> > 
> 
> This looks much cleaner to me, thanks!
> 
> [...]
> 
> > diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> > index c07a050d757d..54371cede485 100644
> > --- a/arch/s390/kvm/kvm-s390.h
> > +++ b/arch/s390/kvm/kvm-s390.h
> > @@ -82,6 +82,22 @@ static inline int is_vcpu_idle(struct kvm_vcpu
> > *vcpu)
> >  	return test_bit(vcpu->vcpu_idx, vcpu->kvm->arch.idle_mask);
> >  }
> >  
> > +static inline bool kvm_s390_vcpu_is_sigp_busy(struct kvm_vcpu
> > *vcpu)
> > +{
> > +	return (atomic_read(&vcpu->arch.sigp_busy) == 1);
> 
> You can drop ()
> 
> > +}
> > +
> > +static inline bool kvm_s390_vcpu_set_sigp_busy(struct kvm_vcpu
> > *vcpu)
> > +{
> > +	/* Return zero for success, or -EBUSY if another vcpu won */
> > +	return (atomic_cmpxchg(&vcpu->arch.sigp_busy, 0, 1) == 0) ? 0 :
> > -EBUSY;
> 
> You can drop () as well.
> 
> We might not need the -EBUSY semantics after all. User space can just
> track if it was set, because it's in charge of setting it.

Hrm, I added this to distinguish a newer kernel with an older QEMU, but
of course an older QEMU won't know the difference either. I'll
doublecheck that this is works fine in the different permutations.

> 
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
> > index 5ad3fb4619f1..a37496ea6dfa 100644
> > --- a/arch/s390/kvm/sigp.c
> > +++ b/arch/s390/kvm/sigp.c
> > @@ -276,6 +276,10 @@ static int handle_sigp_dst(struct kvm_vcpu
> > *vcpu, u8 order_code,
> >  	if (!dst_vcpu)
> >  		return SIGP_CC_NOT_OPERATIONAL;
> >  
> > +	if (kvm_s390_vcpu_is_sigp_busy(dst_vcpu)) {
> > +		return SIGP_CC_BUSY;
> > +	}
> 
> You can drop {}

Arg, I had some debug in there which needed the braces, and of course
it's unnecessary now. Thanks.

> 
> > +
> >  	switch (order_code) {
> >  	case SIGP_SENSE:
> >  		vcpu->stat.instruction_sigp_sense++;
> > @@ -411,6 +415,12 @@ int kvm_s390_handle_sigp(struct kvm_vcpu
> > *vcpu)
> >  	if (handle_sigp_order_in_user_space(vcpu, order_code,
> > cpu_addr))
> >  		return -EOPNOTSUPP;
> >  
> > +	/* Check the current vcpu, if it was a target from another vcpu
> > */
> > +	if (kvm_s390_vcpu_is_sigp_busy(vcpu)) {
> > +		kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
> > +		return 0;
> > +	}
> 
> I don't think we need this. I think the above (checking the target of
> a
> SIGP order) is sufficient. Or which situation do you have in mind?
> 

Hrm... I think you're right. I was thinking of this:

VCPU 1 - SIGP STOP CPU 2
VCPU 2 - SIGP SENSE CPU 1

But of course either CPU2 is going to be marked "busy" first, and the
sense doesn't get processed until it's reset, or the sense arrives
first, and the busy/notbusy doesn't matter. Let me doublecheck my tests
for the non-RFC version.

> 
> 
> I do wonder if we want to make this a kvm_arch_vcpu_ioctl() instead,

In one of my original attempts between v1 and v2, I had put this there.
This reliably deadlocks my guest, because the caller (kvm_vcpu_ioctl())
tries to acquire vcpu->mutex, and racing SIGPs (via KVM_RUN) might
already be holding it. Thus, it's an async ioctl. I could fold it into
the existing interrupt ioctl, but as those are architected structs it
seems more natural do it this way. Or I have mis-understood something
along the way?

> essentially just providing a KVM_S390_SET_SIGP_BUSY *and* providing
> the
> order. "order == 0" sets it to !busy. 

I'd tried this too, since it provided some nice debug-ability.
Unfortunately, I have a testcase (which I'll eventually get folded into
kvm-unit-tests :)) that picks a random order between 0-255, knowing
that there's only a couple handfuls of valid orders, to check the
response. Zero is valid architecturally (POPS figure 4-29), even if
it's unassigned. The likelihood of it becoming assigned is probably
quite low, but I'm not sure that I like special-casing an order of zero
in this way.

> Not that we would need the value
> right now, but who knows for what we might reuse that interface in
> the
> future.
> 
> Thanks!
> 

