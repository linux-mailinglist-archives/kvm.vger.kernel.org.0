Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA7A45AA42
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 18:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbhKWRpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 12:45:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239427AbhKWRpv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 12:45:51 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANGr6TI023965;
        Tue, 23 Nov 2021 17:42:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=4dPI25DugXh75ywKTSqyHELyDlKxoi6J2HgaAaJoz8M=;
 b=crimNd2V3G2M81Pqw/iE5T6DO4cT1gmU0OS9QADf0ziOYB/S4JQFxT5TWTu1CvzxgLa0
 cgN/bNuv8i03zJ+e8i5/+KqujMDE0yMYrXuIUSOXu96invDLgBoYxqEbLIm41Tp5snmT
 i/RfdDj7wFCPDvWn4jg8SgK2Kn/uSgOobxyESYmV8B8hh2l/FsRuXluknzsTa99qLOoa
 Ot4CfPLbI7CTYmUj9CszSqjgFw/DIY/lkw1b/X6e/aNzJtLmnO50Oc3Vmygwch3FFx6M
 SbxO4Smu8Hy8KXrqoEhE28R73abP+fh3QrRdIsirA8NAtEooAoCHbqtA6EysM+/iIZfa UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ch206vhn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 17:42:40 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANH7lkL010500;
        Tue, 23 Nov 2021 17:42:40 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ch206vhmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 17:42:40 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANHbuwV027371;
        Tue, 23 Nov 2021 17:42:39 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01wdc.us.ibm.com with ESMTP id 3cerna8kwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 17:42:39 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANHgcBD41812428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 17:42:38 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82AC5136059;
        Tue, 23 Nov 2021 17:42:38 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7ACB136051;
        Tue, 23 Nov 2021 17:42:37 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.99.212])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 17:42:37 +0000 (GMT)
Message-ID: <8849fcae225c2e7255db4d2aa164ea77d1b26c7a.camel@linux.ibm.com>
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
Date:   Tue, 23 Nov 2021 12:42:36 -0500
In-Reply-To: <858e4f2b-d601-a4f1-9e80-8f7838299c9a@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rrMWvGn3s5Maor64piKxP0HMEAI8SV9-
X-Proofpoint-ORIG-GUID: 98yFarZVnsHXYci9C1qDGgdcIUzZCIA8
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_06,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-11-22 at 11:52 +0100, David Hildenbrand wrote:
> On 19.11.21 21:20, Eric Farman wrote:
> > On Wed, 2021-11-17 at 08:54 +0100, Christian Borntraeger wrote:
> > > Am 11.11.21 um 20:05 schrieb Eric Farman:
> > > > On Thu, 2021-11-11 at 19:29 +0100, David Hildenbrand wrote:
> > > > > On 11.11.21 18:48, Eric Farman wrote:
> > > > > > On Thu, 2021-11-11 at 17:13 +0100, Janosch Frank wrote:
> > > > > > > Looking at the API I'd like to avoid having two IOCTLs
> > > > > > 
> > > > > > Since the order is a single byte, we could have the payload
> > > > > > of
> > > > > > an
> > > > > > ioctl
> > > > > > say "0-255 is an order that we're busy processing, anything
> > > > > > higher
> > > > > > than
> > > > > > that resets the busy" or something. That would remove the
> > > > > > need
> > > > > > for
> > > > > > a
> > > > > > second IOCTL.
> > > > > 
> > > > > Maybe just pass an int and treat a negative (or just -1)
> > > > > value as
> > > > > clearing the order.
> > > > > 
> > > > 
> > > > Right, that's exactly what I had at one point. I thought it was
> > > > too
> > > > cumbersome, but maybe not. Will dust it off, pending my
> > > > question to
> > > > Janosch about 0-vs-1 IOCTLs.
> > > 
> > > As a totally different idea. Would a sync_reg value called
> > > SIGP_BUSY
> > > work as well?
> > > 
> > 
> > Hrm... I'm not sure. I played with it a bit, and it's not looking
> > great. I'm almost certainly missing some serialization, because I
> > was
> > frequently "losing" one of the toggles (busy/not-busy) when
> > hammering
> > CPUs with various SIGP orders on this interface and thus getting
> > incorrect responses from the in-kernel orders.
> 
> You can only modify the destination CPU from the destination CPU
> thread,
> after synchronizing the CPU state. 

Correct, but that was not missing from my quick pass down that rabbit
hole.

> This would be trivial with my QEMU proposal.
> 
> > I also took a stab at David's idea of tying it to KVM_MP_STATE [1].
> > I
> > still think it's a little odd, considering the existing states are
> > all
> > z/Arch-defined CPU states, but it does sound like the sort of thing
> > we're trying to do (letting userspace announce what the CPU is up
> > to).
> > One flaw is that most of the rest of QEMU uses s390_cpu_set_state()
> > for
> > this, which returns the number of running CPUs instead of the
> > return
> > code from the MP_STATE ioctl (via kvm_s390_set_cpu_state()) that
> > SIGP
> > would be interested in. Even if I made the ioctl call directly, I
> > still
> > encounter some system problems that smell like ones I've addressed
> > in
> > v2 and v3. Possibly fixable, but I didn't pursue them far enough to
> > be
> > certain.
> 
> Well, we can essentially observe this special state of that CPU
> ("stopping"), so
> it's not that weird. STOPPING is essentially OPERATING with the
> notion of
> "the CPU is blocked for some actions.".

My point is that any state we define here (STOPPING, BLOCKED, BUSY,
whatever) is something that we are inventing and not something that is
in POPS, which is what the existing states (STOPPED, OPERATING, LOAD,
CHECK-STOP) are. That's a little weird.

I'm not against it. The fact that MP_STATE is already a path back into
KVM without requiring a new uapi is really pleasant.

> 
> > I ALSO took a stab at folding this into the S390 IRQ paths [2],
> > similar
> > to what was done with kvm_s390_stop_info. This worked reasonably
> > well,
> > except the QEMU interface kvm_s390_vcpu_interrupt() returns a void,
> > and
> > so wouldn't notice an error sent back by KVM. Not a deal breaker,
> > but
> > having not heard anything to this idea, I didn't go much farther.
> 
> We only care about SIGP STOP* handling so far, if anybody is aware of
> other issues
> that need fixing, it would be helpful  to spell them out. 

Yes, I keep using SIGP STOP* as an example because it offers (A) a
clear miscommunication with the status bits returned by SIGP SENSE, and
(B) has some special handling in QEMU that to my experience is still
incomplete. But I'm seeing issues with other orders, like SIGP RESTART
[1] [2] (where QEMU does a kvm_s390_vcpu_interrupt() with
KVM_S390_RESTART, and thus adds to pending_irq) and SIGP (INITIAL) CPU
RESET [2] (admittedly not greatly researched).

The reason for why I have no spent a lot of time in the latter is that
I have also mentioned that POPS has lists of orders that will return
busy [3], and so something more general is perhaps warranted. The QEMU
RFC's don't handle anything further than SIGP STOP*, on account of it
makes sense to get the interface right first.

[1]
https://lore.kernel.org/kvm/4c733158506497972d5b04b34a169c054fca4ba5.camel@linux.ibm.com/
[2]
https://lore.kernel.org/kvm/006980fd7d0344b0258aa87128891fcd81c005b7.camel@linux.ibm.com/
[3]
https://lore.kernel.org/kvm/2ad9bef6b39a5a6c9b634cab7d70d110064d8f04.camel@linux.ibm.com/


> I'll keep assuming that
> only SIGP STOP*  needs fixing, as I already explained.
> 
> Whenever QEMU tells a CPU to stop asynchronously, it does so via a
> STOP IRQ from
> the destination CPU thread via KVM_S390_SIGP_STOP. Then, we know the
> CPU is busy
> ... until we clear that interrupt, which happens via
> kvm_s390_clear_stop_irq().
> 
> Interestingly, we clear that interrupt via two paths:
> 
> 1) kvm_s390_clear_local_irqs(), via KVM_S390_INITIAL_RESET and 
>    KVM_S390_NORMAL_RESET. Here, we expect that new user space also
> sets  
>    the CPU to stopped via KVM_MP_STATE_STOPPED. In fact, modern QEMU 
>    properly sets the CPU stopped before triggering clearing of the 
>    interrupts (s390_cpu_reset()).
> 2) kvm_s390_clear_stop_irq() via kvm_s390_vcpu_stop(), which is 
>    triggered via:
> 
> a) STOP intercept (handle_stop()), KVM_S390_INITIAL_RESET and 
>    KVM_S390_NORMAL_RESET with old user space -- 
>    !kvm_s390_user_cpu_state_ctrl().
> 
> b) KVM_MP_STATE_STOPPED for modern user space.
> 
> 
> 
> Would the following solve our SIGP STOP * issue w.o. uapi changes?
> 

A quick pass shows some promise, but I haven't the bandwidth to throw
the battery of stuff at it. I'll have to take a closer look after the
US Holiday to give a better answer. (Example: looking for
IRQ_PEND_SIGP_STOP || IRQ_PEND_RESTART is trivial.)

Eric

> 
> a) Kernel
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index c6257f625929..bd7ee1ea8aa8 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4643,10 +4643,15 @@ int kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
>                 }
>         }
>  
> -       /* SIGP STOP and SIGP STOP AND STORE STATUS has been fully
> processed */
> +       /*
> +        * SIGP STOP and SIGP STOP AND STORE STATUS have been fully
> +        * processed. Clear the interrupt after setting the VCPU
> stopped,
> +        * such that the VCPU remains busy for most SIGP orders until
> fully
> +        * stopped.
> +        */
> +       kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
>         kvm_s390_clear_stop_irq(vcpu);
>  
> -       kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
>         __disable_ibs_on_vcpu(vcpu);
>  
>         for (i = 0; i < online_vcpus; i++) {
> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> index cf4de80bd541..e40f6412106d 100644
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -276,6 +276,38 @@ static int handle_sigp_dst(struct kvm_vcpu
> *vcpu, u8 order_code,
>         if (!dst_vcpu)
>                 return SIGP_CC_NOT_OPERATIONAL;
>  
> +       /*
> +        * SIGP STOP * orders are the only SIGP orders that are
> processed
> +        * asynchronously, and can theoretically, never complete.
> +        *
> +        * Until the destination VCPU is stopped via
> kvm_s390_vcpu_stop(), we
> +        * have a stop interrupt pending. While we have a pending
> stop
> +        * interrupt, that CPU is busy for most SIGP orders.
> +        *
> +        * This is important, because otherwise a single VCPU could
> issue on an
> +        * operating destination VCPU:
> +        * 1) SIGP STOP $DEST
> +        * 2) SIGP SENSE $DEST
> +        * And have 2) not rejected with BUSY although the
> destination is still
> +        * processing the pending SIGP STOP * order.
> +        *
> +        * Relevant code has to make sure to complete the SIGP STOP *
> action
> +        * (e.g., setting the CPU stopped, storing the status) before
> clearing
> +        * the STOP interrupt.
> +        */
> +       if (order_code != SIGP_INITIAL_CPU_RESET &&
> +           order_code != SIGP_CPU_RESET) {
> +               /*
> +                * Lockless check. SIGP STOP / SIGP RE(START)
> properly
> +                * synchronizes when processing these orders. In any
> other case,
> +                * we don't particularly care about races, as the
> guest cannot
> +                * observe the difference really when issuing orders
> from two
> +                * differing VCPUs.
> +                */
> +               if (kvm_s390_is_stop_irq_pending(dst_vcpu))
> +                       return SIGP_CC_BUSY;
> +       }
> +
>         switch (order_code) {
>         case SIGP_SENSE:
>                 vcpu->stat.instruction_sigp_sense++;
> 
> b) QEMU
> 
> diff --git a/target/s390x/sigp.c b/target/s390x/sigp.c
> index 51c727834c..e97e3a60fd 100644
> --- a/target/s390x/sigp.c
> +++ b/target/s390x/sigp.c
> @@ -479,13 +479,17 @@ void do_stop_interrupt(CPUS390XState *env)
>  {
>      S390CPU *cpu = env_archcpu(env);
>  
> -    if (s390_cpu_set_state(S390_CPU_STATE_STOPPED, cpu) == 0) {
> -        qemu_system_shutdown_request(SHUTDOWN_CAUSE_GUEST_SHUTDOWN);
> -    }
> +    /*
> +     * Complete the STOP operation before exposing the CPU as
> STOPPED to
> +     * the system.
> +     */
>      if (cpu->env.sigp_order == SIGP_STOP_STORE_STATUS) {
>          s390_store_status(cpu, S390_STORE_STATUS_DEF_ADDR, true);
>      }
>      env->sigp_order = 0;
> +    if (s390_cpu_set_state(S390_CPU_STATE_STOPPED, cpu) == 0) {
> +        qemu_system_shutdown_request(SHUTDOWN_CAUSE_GUEST_SHUTDOWN);
> +    }
>      env->pending_int &= ~INTERRUPT_STOP;
>  }
>  
> 
> 

