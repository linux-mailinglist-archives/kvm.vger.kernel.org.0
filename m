Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDB644DB3F
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 18:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhKKRvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 12:51:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229872AbhKKRvR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 12:51:17 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABHIW4K020082;
        Thu, 11 Nov 2021 17:48:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=0jp1/G18zqu5yevVf5RoBimfKFOzzp3Wt8cnNv6qzyw=;
 b=Eg15nMiWAGi/1MVqhNIo9KcSNiY8PVXltF0jS7CgFG6MhAKGiGPYIQNIV4IKHTdYhoKa
 FxS5/Jdaku6AiarSgcfH16oPtqpv2Axwtdza59XT9cy3agcf+zBcN4mQqOL5ekfMHg0y
 x4bSvKqOBA4ZmGg+epbKF2MYj3Uaqn6PTpPOQh5FiEcLR70RimON/HmPBKj2d/HY93dE
 nOy5LJro5iudV656OhazRtoqFyk2IdXtLDDOkxauq926qM7rXMs5uy0EORyJXSjLff9g
 noyRFOd+1BIJ/GoGfdzXxl0cyaqXfEBdZGbXw+/kTQu0iuLs2ZKQsQC1fe9NSAamwO3k qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c97f98hx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 17:48:27 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ABHTboB000645;
        Thu, 11 Nov 2021 17:48:27 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c97f98hws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 17:48:27 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ABHlLvD011213;
        Thu, 11 Nov 2021 17:48:26 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 3c5hbdd0ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 17:48:26 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABHmOaE25690596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 17:48:24 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C124B11206E;
        Thu, 11 Nov 2021 17:48:24 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B873A11206B;
        Thu, 11 Nov 2021 17:48:21 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.106.148])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 11 Nov 2021 17:48:21 +0000 (GMT)
Message-ID: <b116e738d8f9b185867ab28395012aaddd58af31.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v3 2/2] KVM: s390: Extend the USER_SIGP capability
From:   Eric Farman <farman@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Thu, 11 Nov 2021 12:48:20 -0500
In-Reply-To: <32836eb5-532f-962d-161a-faa2213a0691@linux.ibm.com>
References: <20211110203322.1374925-1-farman@linux.ibm.com>
         <20211110203322.1374925-3-farman@linux.ibm.com>
         <dd8a8b49-da6d-0ab8-dc47-b24f5604767f@redhat.com>
         <ab82e68051674ea771e2cb5371ca2a204effab40.camel@linux.ibm.com>
         <32836eb5-532f-962d-161a-faa2213a0691@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tojX6H5ZY0eJh1bYwWknuJ_ufvmnymwW
X-Proofpoint-GUID: XUWrA0VHIYcpaAYBd9SW27_jcegqqxGQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_06,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-11-11 at 17:13 +0100, Janosch Frank wrote:
> On 11/11/21 16:03, Eric Farman wrote:
> > On Thu, 2021-11-11 at 10:15 +0100, David Hildenbrand wrote:
> > > On 10.11.21 21:33, Eric Farman wrote:
> > > > With commit 2444b352c3ac ("KVM: s390: forward most SIGP orders
> > > > to
> > > > user
> > > > space") we have a capability that allows the "fast" SIGP orders
> > > > (as
> > > > defined by the Programming Notes for the SIGNAL PROCESSOR
> > > > instruction in
> > > > the Principles of Operation) to be handled in-kernel, while all
> > > > others are
> > > > sent to userspace for processing.
> > > > 
> > > > This works fine but it creates a situation when, for example, a
> > > > SIGP SENSE
> > > > might return CC1 (STATUS STORED, and status bits indicating the
> > > > vcpu is
> > > > stopped), when in actuality userspace is still processing a
> > > > SIGP
> > > > STOP AND
> > > > STORE STATUS order, and the vcpu is not yet actually stopped.
> > > > Thus,
> > > > the
> > > > SIGP SENSE should actually be returning CC2 (busy) instead of
> > > > CC1.
> > > > 
> > > > To fix this, add another CPU capability, dependent on the
> > > > USER_SIGP
> > > > one,
> > > > and two associated IOCTLs. One IOCTL will be used by userspace
> > > > to
> > > > mark a
> > > > vcpu "busy" processing a SIGP order, and cause concurrent
> > > > orders
> > > > handled
> > > > in-kernel to be returned with CC2 (busy). Another IOCTL will be
> > > > used by
> > > > userspace to mark the SIGP "finished", and the vcpu free to
> > > > process
> > > > additional orders.
> > > > 
> > > 
> > > This looks much cleaner to me, thanks!
> > > 
> > > [...]
> > > 
> > > > diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-
> > > > s390.h
> > > > index c07a050d757d..54371cede485 100644
> > > > --- a/arch/s390/kvm/kvm-s390.h
> > > > +++ b/arch/s390/kvm/kvm-s390.h
> > > > @@ -82,6 +82,22 @@ static inline int is_vcpu_idle(struct
> > > > kvm_vcpu
> > > > *vcpu)
> > > >   	return test_bit(vcpu->vcpu_idx, vcpu->kvm-
> > > > >arch.idle_mask);
> > > >   }
> > > >   
> > > > +static inline bool kvm_s390_vcpu_is_sigp_busy(struct kvm_vcpu
> > > > *vcpu)
> > > > +{
> > > > +	return (atomic_read(&vcpu->arch.sigp_busy) == 1);
> > > 
> > > You can drop ()
> > > 
> > > > +}
> > > > +
> > > > +static inline bool kvm_s390_vcpu_set_sigp_busy(struct kvm_vcpu
> > > > *vcpu)
> > > > +{
> > > > +	/* Return zero for success, or -EBUSY if another vcpu
> > > > won */
> > > > +	return (atomic_cmpxchg(&vcpu->arch.sigp_busy, 0, 1) ==
> > > > 0) ? 0 :
> > > > -EBUSY;
> > > 
> > > You can drop () as well.
> > > 
> > > We might not need the -EBUSY semantics after all. User space can
> > > just
> > > track if it was set, because it's in charge of setting it.
> > 
> > Hrm, I added this to distinguish a newer kernel with an older QEMU,
> > but
> > of course an older QEMU won't know the difference either. I'll
> > doublecheck that this is works fine in the different permutations.
> > 
> > > > +}
> > > > +
> > > > +static inline void kvm_s390_vcpu_clear_sigp_busy(struct
> > > > kvm_vcpu
> > > > *vcpu)
> > > > +{
> > > > +	atomic_set(&vcpu->arch.sigp_busy, 0);
> > > > +}
> > > > +
> > > >   static inline int kvm_is_ucontrol(struct kvm *kvm)
> > > >   {
> > > >   #ifdef CONFIG_KVM_S390_UCONTROL
> > > > diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> > > > index 5ad3fb4619f1..a37496ea6dfa 100644
> > > > --- a/arch/s390/kvm/sigp.c
> > > > +++ b/arch/s390/kvm/sigp.c
> > > > @@ -276,6 +276,10 @@ static int handle_sigp_dst(struct kvm_vcpu
> > > > *vcpu, u8 order_code,
> > > >   	if (!dst_vcpu)
> > > >   		return SIGP_CC_NOT_OPERATIONAL;
> > > >   
> > > > +	if (kvm_s390_vcpu_is_sigp_busy(dst_vcpu)) {
> > > > +		return SIGP_CC_BUSY;
> > > > +	}
> > > 
> > > You can drop {}
> > 
> > Arg, I had some debug in there which needed the braces, and of
> > course
> > it's unnecessary now. Thanks.
> > 
> > > > +
> > > >   	switch (order_code) {
> > > >   	case SIGP_SENSE:
> > > >   		vcpu->stat.instruction_sigp_sense++;
> > > > @@ -411,6 +415,12 @@ int kvm_s390_handle_sigp(struct kvm_vcpu
> > > > *vcpu)
> > > >   	if (handle_sigp_order_in_user_space(vcpu, order_code,
> > > > cpu_addr))
> > > >   		return -EOPNOTSUPP;
> > > >   
> > > > +	/* Check the current vcpu, if it was a target from
> > > > another vcpu
> > > > */
> > > > +	if (kvm_s390_vcpu_is_sigp_busy(vcpu)) {
> > > > +		kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
> > > > +		return 0;
> > > > +	}
> > > 
> > > I don't think we need this. I think the above (checking the
> > > target of
> > > a
> > > SIGP order) is sufficient. Or which situation do you have in
> > > mind?
> > > 
> > 
> > Hrm... I think you're right. I was thinking of this:
> > 
> > VCPU 1 - SIGP STOP CPU 2
> > VCPU 2 - SIGP SENSE CPU 1
> > 
> > But of course either CPU2 is going to be marked "busy" first, and
> > the
> > sense doesn't get processed until it's reset, or the sense arrives
> > first, and the busy/notbusy doesn't matter. Let me doublecheck my
> > tests
> > for the non-RFC version.
> > 
> > > 
> > > I do wonder if we want to make this a kvm_arch_vcpu_ioctl()
> > > instead,
> > 
> > In one of my original attempts between v1 and v2, I had put this
> > there.
> > This reliably deadlocks my guest, because the caller
> > (kvm_vcpu_ioctl())
> > tries to acquire vcpu->mutex, and racing SIGPs (via KVM_RUN) might
> > already be holding it. Thus, it's an async ioctl. I could fold it
> > into
> > the existing interrupt ioctl, but as those are architected structs
> > it
> > seems more natural do it this way. Or I have mis-understood
> > something
> > along the way?
> > 
> > > essentially just providing a KVM_S390_SET_SIGP_BUSY *and*
> > > providing
> > > the
> > > order. "order == 0" sets it to !busy.
> > 
> > I'd tried this too, since it provided some nice debug-ability.
> > Unfortunately, I have a testcase (which I'll eventually get folded
> > into
> > kvm-unit-tests :)) that picks a random order between 0-255, knowing
> > that there's only a couple handfuls of valid orders, to check the
> > response. Zero is valid architecturally (POPS figure 4-29), even if
> > it's unassigned. The likelihood of it becoming assigned is probably
> > quite low, but I'm not sure that I like special-casing an order of
> > zero
> > in this way.
> > 
> 
> Looking at the API I'd like to avoid having two IOCTLs 

Since the order is a single byte, we could have the payload of an ioctl
say "0-255 is an order that we're busy processing, anything higher than
that resets the busy" or something. That would remove the need for a
second IOCTL.

> and I'd love to 
> see some way to extend this without the need for a whole new IOCTL.
> 

Do you mean zero IOCTLs? Because... I think the only way we can do that
is to get rid of USER_SIGP altogether, and handle everything in-kernel. 
Some weeks ago I played with QEMU not enabling USER_SIGP, but I can't
say I've tried it since we went down this "mark a vcpu busy" path. If I
do that busy/not-busy tagging in the kernel for !USER_SIGP, that might
not be a bad thing anyway. But I don't know how we get the behavior
straightened out for USER_SIGP without some type of handshake.

> 
> 
> > > Not that we would need the value
> > > right now, but who knows for what we might reuse that interface
> > > in
> > > the
> > > future.
> > > 
> > > Thanks!
> > > 

