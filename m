Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEBF463F0B
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 21:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343609AbhK3UOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 15:14:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1343611AbhK3UOu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 15:14:50 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AUK7mEd029816;
        Tue, 30 Nov 2021 20:11:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=M5Rkav3ibQGLJXuvYhxz3AwZSJrXExulPfcP0R8sL4E=;
 b=jEPMD4risCFjgZi8Q3GO3+2vH75aiDLcRJ+5ZnMZebjkCYAtteIYCEnWwpm1KqqSNyHR
 Ge0MxHNC62yDaZ2VBaOUu5uEfCT6Fq5ujiMT85Bv8jCl7k6RC4Bi1vhC5WzS552xV3GP
 WaAsaIRITzJhOHXbrBKCdM6pTRORwJim5lmRZmhgCz5utSEByskfM5tH5VDM3t9s9xZw
 YslrbMuPOeBaUvgwHb1koOztlqOzM3/tkmriglAR/O7rrsQQNiIHqsuYy1p2lTgr9TK6
 pFgfXi+eotRW+SsGmoy+WEDmxkPm1c4Myf/DNALYBWCxYXX93Gt/B4vugFgk0ZaI5GlU cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cnte28g46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 20:11:29 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AUK8XGL005687;
        Tue, 30 Nov 2021 20:11:29 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cnte28g3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 20:11:29 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AUK3o3Z014985;
        Tue, 30 Nov 2021 20:11:28 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 3cn5ey86ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 20:11:28 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AUKBRiG45547834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 20:11:27 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 521B828064;
        Tue, 30 Nov 2021 20:11:27 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BF8E2805A;
        Tue, 30 Nov 2021 20:11:25 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.76.243])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 30 Nov 2021 20:11:24 +0000 (GMT)
Message-ID: <c37473352b1fd2d2e6211911750b6061d4806090.camel@linux.ibm.com>
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
Date:   Tue, 30 Nov 2021 15:11:23 -0500
In-Reply-To: <ffa6e5da-e0d2-6b21-f0aa-589ee7aabe47@redhat.com>
References: <20211110203322.1374925-1-farman@linux.ibm.com>
         <20211110203322.1374925-3-farman@linux.ibm.com>
         <dd8a8b49-da6d-0ab8-dc47-b24f5604767f@redhat.com>
         <ab82e68051674ea771e2cb5371ca2a204effab40.camel@linux.ibm.com>
         <32836eb5-532f-962d-161a-faa2213a0691@linux.ibm.com>
         <b116e738d8f9b185867ab28395012aaddd58af31.camel@linux.ibm.com>
         <85ba9fa3-ca25-b598-aecd-5e0c6a0308f2@redhat.com>
         <19a2543b24015873db736bddb14d0e4d97712086.camel@linux.ibm.com>
         <9c9bbf66-54c9-3d02-6d9f-1e147945abe8@de.ibm.com>
         <cd1c11a05cc13fb8c70ce3644dcf823a840872b5.camel@linux.ibm.com>
         <858e4f2b-d601-a4f1-9e80-8f7838299c9a@redhat.com>
         <8849fcae225c2e7255db4d2aa164ea77d1b26c7a.camel@linux.ibm.com>
         <ffa6e5da-e0d2-6b21-f0aa-589ee7aabe47@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DlAdnBzxNIe1cNEuMHfnRtZXyYHGbBO4
X-Proofpoint-ORIG-GUID: VdpeDSzFVMa6i7UA77O289ID3hYbN3Mm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111300103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-11-23 at 19:44 +0100, David Hildenbrand wrote:
> > > > I ALSO took a stab at folding this into the S390 IRQ paths [2],
> > > > similar
> > > > to what was done with kvm_s390_stop_info. This worked
> > > > reasonably
> > > > well,
> > > > except the QEMU interface kvm_s390_vcpu_interrupt() returns a
> > > > void,
> > > > and
> > > > so wouldn't notice an error sent back by KVM. Not a deal
> > > > breaker,
> > > > but
> > > > having not heard anything to this idea, I didn't go much
> > > > farther.
> > > 
> > > We only care about SIGP STOP* handling so far, if anybody is
> > > aware of
> > > other issues
> > > that need fixing, it would be helpful  to spell them out. 
> > 
> > Yes, I keep using SIGP STOP* as an example because it offers (A) a
> > clear miscommunication with the status bits returned by SIGP SENSE,
> > and
> > (B) has some special handling in QEMU that to my experience is
> > still
> > incomplete. But I'm seeing issues with other orders, like SIGP
> > RESTART
> > [1] [2] (where QEMU does a kvm_s390_vcpu_interrupt() with
> > KVM_S390_RESTART, and thus adds to pending_irq) and SIGP (INITIAL)
> > CPU
> > RESET [2] (admittedly not greatly researched).
> 
> Sorry I missed that discussion previously. Summarizing what the PoP
> says:
> 
> Once we have a pending:
> * start (-> synchronous)
> * stop (-> asynchronous)
> * restart (-> asynchronous)
> * stop-and-store-status (-> asynchronous)
> * set-prefix (-> synchronous)
> * store-status-at-address (-> synchronous)
> * store-additional-status-at-address (-> synchronous)
> * initial-CPU-reset (-> synchronous)
> * CPU-reset order (-> synchronous)

I would argue that these last two are not necessarily synchronous.
Looking at QEMU...

handle_sigp_single_dst()
sigp_(initial_)cpu_reset()
s390_cpu_reset()
>> If kvm_enabled(), call
   kvm_s390_reset_vcpu_initial()
   -or-
   kvm_s390_reset_vcpu_normal()
kvm_s390_reset_vcpu()
kvm_vcpu_ioctl()

(Switch to KVM code)
kvm_vcpu_ioctl()
 -- Acquire vcpu->mutex
kvm_arch_vcpu_ioctl()
kvm_arch_vcpu_ioctl_initial_reset()
 -and/or-
kvm_arch_vcpu_ioctl_normal_reset()

So, given that, couldn't it be possible for a SIGP SENSE to be sent to
a CPU that is currently processing one of the RESET orders? The mutex
acquired as part of the ioctl would end up gating one of them, when
according to POPS a subsequent SENSE should get CC2 until the reset
completes. Unlike STOP*/RESTART, there's no IRQ that we can key off of
to know that the RESET is still in process, unless we define another
IOCTL as in v2-v4 here.

> 
> The following orders have to return busy (my take: only a must if the
> guest could observe the difference):
> * sense
> * external call
> * emergency signal

These ones:

> * start
> * stop
> * restart
> * stop and store status
> * set prefix
> * store status at address
> * set architecture
> * set multithreading
> * store additional status at address

... are handled in userspace, which QEMU serializes in handle_sigp()
and returns CC2 today:

    if (qemu_mutex_trylock(&qemu_sigp_mutex)) {
        ret = SIGP_CC_BUSY;
        goto out;
    }

> 
> We have to ask ourselves
> 
> a) How could a single VCPU observe the difference if executing any
> other
> instruction immediately afterwards. My take would be that for
> synchronous orders we can't really. So we're left with:
> * stop (-> asynchronous)
> * restart (-> asynchronous)
> * stop-and-store-status (-> asynchronous)
> 
> b) How could multiple VCPUs observe the difference that a single VCPU
> can't observe. That will require more thought, but I think it will be
> hardly possible.
> 
> 
> We know that SIGP STOP * needs care.
> 
> SIGP RESTART is interesting. We inject it only for OPERATING cpus and
> it
> will only change the LC psw. What if we execute immediately
> afterwards:
> 
> * sense -> does not affect any bits
> * external call -> has higher IRQ priority. There could be a
> difference
>   if injected before or after the restart was delivered. Could be
> fixed
>   in the kernel (check IRQ_PEND_RESTART).
> * emergency signal -> has higher IRQ priority. There could be a
>   difference if injected before or after the restart was delivered.
>   Could be fixed in the kernel (check IRQ_PEND_RESTART).
> * start -> CPU is already operating
> * stop -> restart is delivered first
> * restart -> I think the lowcore will look different if we inject two
>   RESTARTs immediately afterwards instead of only a single
>   one. Could be fixed in the kernel (double-deliver the interrupt).
> * stop and store status -> restart is delivered first
> * set prefix -> CPU is operating, not possible
> * store status at address -> CPU is operating, not possible
> * set architecture -> don't care
> * set multithreading -> don't care
> * store additional status at address -> CPU is operating, not
> possible
> * initial-CPU-reset -> clears local IRQ. LC will look different if
>   RESTART was delivered or not. Could be fixed in the kernel quite
>   easily (deliver restart first before clearing interrupts).
> * CPU-reset -> clears local IRQs. LC will look different if
>   injected before vs. after. Could be fixed in the kernel quite
>   easily (deliver restart first before clearing interrupts)..

These might be of value. I don't yet have a clear order of events in
these scenarios, but will keep this in mind as I am seeing some
oddities there.

> 
> external call as handled by the SIGP interpretation facility will
> already also violate that description. We don't know that a SIGP
> restart
> is pending. We'd have to disable the SIGP interpretation facility
> temporarily.
> 
> /me shivers

/me too

> 
> This sounds like the kind of things we should happily not be fixing
> because nobody might really care :)
> 
> 

Hi, me again, really hoping I don't care about this aspect of it. :)

> 
> > The reason for why I have no spent a lot of time in the latter is
> > that
> > I have also mentioned that POPS has lists of orders that will
> > return
> > busy [3], and so something more general is perhaps warranted. The
> > QEMU
> > RFC's don't handle anything further than SIGP STOP*, on account of
> > it
> > makes sense to get the interface right first.
> 
> Right. My take is to have a look what we actually have to fix --
> where
> the guest can actually observe the difference. If the guest can't
> observe the difference there is no need to actually implement BUSY
> logic
> as instructed in the PoP.

My concern is largely with SIGP SENSE giving a clear answer for the
state of the cpu. Since most of the SIGP orders have some variation of
"may not occur/be completed during the execution of SIGNAL PROCESSOR"
in POPs, the SIGP SENSE is a quick mechanism (being defined as a "fast"
order) to determine if another order has completed or is still in-
process, and if the cpu was left in the expected state at the
completion of the order.

It does suggest that those synchronous orders could offer a misleading
answer, but since there's no (obvious) loss of control in those paths,
it's not as big a concern for me.

> 
> > > I'll keep assuming that
> > > only SIGP STOP*  needs fixing, as I already explained.
> > > 
> > > Whenever QEMU tells a CPU to stop asynchronously, it does so via
> > > a
> > > STOP IRQ from
> > > the destination CPU thread via KVM_S390_SIGP_STOP. Then, we know
> > > the
> > > CPU is busy
> > > ... until we clear that interrupt, which happens via
> > > kvm_s390_clear_stop_irq().
> > > 
> > > Interestingly, we clear that interrupt via two paths:
> > > 
> > > 1) kvm_s390_clear_local_irqs(), via KVM_S390_INITIAL_RESET and 
> > >    KVM_S390_NORMAL_RESET. Here, we expect that new user space
> > > also
> > > sets  
> > >    the CPU to stopped via KVM_MP_STATE_STOPPED. In fact, modern
> > > QEMU 
> > >    properly sets the CPU stopped before triggering clearing of
> > > the 
> > >    interrupts (s390_cpu_reset()).
> > > 2) kvm_s390_clear_stop_irq() via kvm_s390_vcpu_stop(), which is 
> > >    triggered via:
> > > 
> > > a) STOP intercept (handle_stop()), KVM_S390_INITIAL_RESET and 
> > >    KVM_S390_NORMAL_RESET with old user space -- 
> > >    !kvm_s390_user_cpu_state_ctrl().
> > > 
> > > b) KVM_MP_STATE_STOPPED for modern user space.
> > > 
> > > 
> > > 
> > > Would the following solve our SIGP STOP * issue w.o. uapi
> > > changes?
> > > 
> > 
> > A quick pass shows some promise, but I haven't the bandwidth to
> > throw
> > the battery of stuff at it. I'll have to take a closer look after
> > the
> > US Holiday to give a better answer. (Example: looking for
> > IRQ_PEND_SIGP_STOP || IRQ_PEND_RESTART is trivial.)
> 
> Yes, extending to IRQ_PEND_RESTART would make sense.
> 

Running my stressors at this combined patch goes well. Going to work on
some additional ones this week, with some debug on the reset orders.

Thanks,
Eric

