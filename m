Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06EA1D52A7
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 16:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgEOO4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 10:56:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726213AbgEOO4I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 10:56:08 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04FEY8oq017140;
        Fri, 15 May 2020 10:56:07 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310ub1caqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 10:56:06 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04FEZZbp024706;
        Fri, 15 May 2020 10:56:06 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310ub1capr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 10:56:06 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04FEoefB032561;
        Fri, 15 May 2020 14:56:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3100ubdt9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 14:56:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04FEtxII62062774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 14:55:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C73654C04A;
        Fri, 15 May 2020 14:55:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71CB14C044;
        Fri, 15 May 2020 14:55:59 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.30.128])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 14:55:59 +0000 (GMT)
Date:   Fri, 15 May 2020 16:55:39 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20200515165539.2e4a8485.pasic@linux.ibm.com>
In-Reply-To: <4e00c83b-146f-9f1d-882b-a5378257f32c@linux.ibm.com>
References: <20200513142934.28788-1-farman@linux.ibm.com>
        <20200514154601.007ae46f.pasic@linux.ibm.com>
        <4e00c83b-146f-9f1d-882b-a5378257f32c@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_06:2020-05-15,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=2
 lowpriorityscore=0 spamscore=0 clxscore=1015 cotscore=-2147483648
 mlxlogscore=999 bulkscore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 May 2020 09:09:47 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> 
> 
> On 5/14/20 9:46 AM, Halil Pasic wrote:
> > On Wed, 13 May 2020 16:29:30 +0200
> > Eric Farman <farman@linux.ibm.com> wrote:
> > 
> >> Hi Conny,
> >>
> >> Back in January, I suggested a small patch [1] to try to clean up
> >> the handling of HSCH/CSCH interrupts, especially as it relates to
> >> concurrent SSCH interrupts. Here is a new attempt to address this.
> >>
> >> There was some suggestion earlier about locking the FSM, but I'm not
> >> seeing any problems with that. Rather, what I'm noticing is that the
> >> flow between a synchronous START and asynchronous HALT/CLEAR have
> >> different impacts on the FSM state. Consider:
> >>
> >>     CPU 1                           CPU 2
> >>
> >>     SSCH (set state=CP_PENDING)
> >>     INTERRUPT (set state=IDLE)
> >>     CSCH (no change in state)
> >>                                     SSCH (set state=CP_PENDING)
> >>     INTERRUPT (set state=IDLE)
> >>                                     INTERRUPT (set state=IDLE)
> > 
> > How does the PoP view of the composite device look like 
> > (where composite device = vfio-ccw + host device)?
> 
> (Just want to be sure that "composite device" is a term that you're
> creating, because it's not one I'm familiar with.)

Yes I created this term because I'm unaware of an established one, and
I could not come up with a better one. If you have something established
or better please do tell, I will start using that.

> 
> In today's code, there isn't a "composite device" that contains
> POPs-defined state information like we find in, for example, the host
> SCHIB, but that incorporates vfio-ccw state. This series (in a far more
> architecturally valid, non-RFC, form) would get us closer to that.
> 

I think it is very important to start thinking about the ccw devices
that are exposed to the guest as a "composite device" in a sense that
the (passed-through) host ccw device is wrapped by vfio-ccw. For instance
the guest sees the SCHIB exposed by the vfio-ccw wrapper (adaptation
code in qemu and the kernel module), and not the SCHIB of the host
device.

This series definitely has some progressive thoughts. It just that
IMHO we sould to be more radical about this. And yes I'm a bit
frustrated.

> > 
> > I suppose at the moment where we accept the CSCH the FC bit
> > indicated clear function (19) goes to set. When this happens
> > there are 2 possibilities: either the start (17) bit is set,
> > or it is not. You describe a scenario where the start bit is
> > not set. In that case we don't have a channel program that
> > is currently being processed, and any SSCH must bounce right
> > off without doing anything (with cc 2) as long as FC clear
> > is set. Please note that we are still talking about the composite
> > device here.
> 
> Correct. Though, whether the START function control bit is currently set
> is immaterial to a CLEAR function; that's the biggest recovery action we
> have at our disposal, and will always go through.
> 
> The point is that there is nothing to prevent the START on CPU 2 from
> going through. The CLEAR does not affect the FSM today, and doesn't
> record a FC CLEAR bit within vfio-ccw, and so we're only relying on the
> return code from the SSCH instruction to give us cc0 vs cc2 (or
> whatever). The actual results of that will depend, since the CPU may
> have presented the interrupt for the CLEAR (via the .irq callback and
> thus FSM VFIO_CCW_EVENT_INTERRUPT) and thus a new START is perfectly
> legal from its point of view. Since vfio-ccw may not have unstacked the
> work it placed to finish up that interrupt handler means we have a problem.
> 
> > 
> > Thus in my reading CPU2 making the IDLE -> CP_PENDING transition
> > happen is already wrong. We should have rejected to look at the
> > channel program in the first place. Because as far as I can tell
> > for the composite device the FC clear bit remains set until we
> > process the last interrupt on the CPU 1 side in your scenario. Or
> > am I wrong?
> 
> You're not wrong. You're agreeing with everything I've described.  :)
> 

I'm happy our understanding seems to converge! :)

My problem is that you tie the denial of SSCH to outstanding interrupts
("C) A SSCH cannot be issued while an interrupt is outstanding") while
the PoP says "Condition code 2 is set, and no other action is
taken, when a start, halt, or clear function is currently
in progress at the subchannel (see “Function Control
(FC)” on page 16-22)".

This may or man not be what you have actually implemented, but it is what
you describe in this cover letter. Also patches 2 and 3 do the 
serialization operate on activity controls instead of on the function
controls (as described by the PoP).

> > 
> > AFAIR I was preaching about this several times, but could never
> > convince the people that 'let the host ccw device sort out
> > concurrency' is not the way this should work.
> 
> I'm going to ignore this paragraph.
> 

;) Wise, was just frustration venting on my side.

> > 
> > Maybe I have got a hole in my argument somewhere. If my argument
> > is wrong, please do point out why!
> > 
> >>
> >> The second interrupt on CPU 1 will call cp_free() for the START
> >> created by CPU 2, and our results will be, um, messy. This
> >> suggests that three things must be true:
> >>
> >>  A) cp_free() must be called for either a final interrupt,
> >> or a failure issuing a SSCH
> >>  B) The FSM state must only be set to IDLE once cp_free()
> >> has been called
> >>  C) A SSCH cannot be issued while an interrupt is outstanding
> > 
> > So you propose to reject SSCH in the IDLE state (if an interrupt
> > is outstanding)? That is one silly IDLE state and FSM for sure.
> 
> And sending a HSCH/CSCH without affecting the FSM or a POPs-valid
> structure is not silly?
> 

It is silly! I'm frustrated because I could not convince my peers that
it is silly.

> > 
> >>
> >> It's not great that items B and C are separated in the interrupt
> >> path by a mutex boundary where the copy into io_region occurs.
> >> We could (and perhaps should) move them together, which would
> >> improve things somewhat, but still doesn't address the scenario
> >> laid out above. Even putting that work within the mutex window
> >> during interrupt processing doesn't address things totally.
> >>
> >> So, the patches here do two things. One to handle unsolicited
> >> interrupts [2], which I think is pretty straightforward. Though,
> >> it does make me want to do a more drastic rearranging of the
> >> affected function. :)
> >>
> >> The other warrants some discussion, since it's sort of weird.
> >> Basically, recognize what commands we've issued, expect interrupts
> >> for each, and prevent new SSCH's while asynchronous commands are
> >> pending. It doesn't address interrupts from the HSCH/CSCH that
> >> could be generated by the Channel Path Handling code [3] for an
> >> offline CHPID yet, and it needs some TLC to make checkpatch happy.
> >> But it's the best possibility I've seen thus far.
> >>
> >> I used private->scsw for this because it's barely used for anything
> >> else; at one point I had been considering removing it outright because
> >> we have entirely too many SCSW's in this code. :) I could implement
> >> this as three small flags in private, to simplify the code and avoid
> >> confusion with the different fctl/actl flags in private vs schib.
> >>
> > 
> > Implementing the FSM described in the PoP (which in turn
> > conceptually relies on atomic operations on the FC bits) is IMHO
> > the way to go. But we can track that info in our FSM states. In
> > fact our FSM states should just add sub-partitioning of states to
> > those states (if necessary).
> 
> I'm not prepared to rule this out, as I originally stated, but I'm not
> thrilled with this idea. Today, we have FSM events for an IO (START) and
> asynchronous commands (HALT and CLEAR), and we have FSM states for the
> different stages of a START operation. Making asynchronous commands
> affect the FSM state isn't too big of a problem, but what happens if we
> expand the asynchronous support to handle other commands, such as CANCEL
> or RESUME? They don't have FC bits of their own to map into an FSM, and
> (just like HALT/CLEAR) have some reliance on the fctl/actl/stctl bits of
> the SCHIB.
> 

Well, fctl/actl/stctl can be seen as a possible representation of states
and state transitions. For example for RESUME the PoP says
"Condition code 2 is set, and no other action is
taken, when the resume function is not applicable.
The resume function is not applicable when the sub-
channel (1) has any function other than the start
function alone specified, (2) has no function speci-
fied, (3) is resume pending, or (4) does not have sus-
pend control specified for the start function in
progress"

What I'm trying to say is, there is a state machine described in the PoP,
and there the state transitions are marked by interlocked updates of bits
in fctl/actl/stctl. I don't know how many bits relevant for the state
machine are, but I'm pretty confident they can be packaged up in a
quadword. So if we want we can represent that stuff with a state variable
of ours.

BTW the whole notion of synchronous and asynchronous commands is IMHO
broken. I tried to argue against it back then. If you read the PoP SSCH
is asynchronous as well.

> The fact that you're talking about sub-partitioning of states, as we
> have with CP_PROCESSING and CP_PENDING in the context of a START,
> suggest we'd drift farther from what one actually finds in POPs and make
> it harder to decipher what vfio-ccw is actually up to.
> 

Yes. This may or may not be justified. Because we need to do that
translation-prefetching and we need to do some cleanup that in a
non-virtualized context isn't there additional states may be beneficial
or even necessary. But if our state machine is interlacing with
the PoP state machine something is very wrong.

> > 
> > 
> >> It does make me wonder whether the CP_PENDING check before cp_free()
> >> is still necessary, but that's a query for a later date.
> >>
> >> Also, perhaps this could be accomplished with two new FSM states,
> >> one for a HALT and one for a CLEAR. I put it aside because the
> >> interrupt handler got a little hairy with that, but I'm still looking
> >> at it in parallel to this discussion.
> >>
> > 
> > You don't necessarily need 2 new states. Just one that corresponds
> > to FC clear function will do.
> 
> I don't think so. Maybe for my example above regarding a CSCH, but we
> can issue a HSCH in the same way today, and a HALT should also get a cc2
> if either a HALT or CLEAR command is already in progress. Just as a
> START should get cc2 for a START, HALT, or CLEAR.
> 

Right. I was wrong. I misremembered something and mixed stuff up. We
have separate FC bits for HALT and CLEAR in the PoP and that's for a
good reason. Sorry for the noise.

> > 
> >> I look forward to hearing your thoughts...
> > 
> > Please see above ;)
> > 
> > Also why do we see the scenario you describe in the wild? I agree that
> > this should be taken care of in the kernel as well, but according to my
> > understanding QEMU is already supposed to reject the second SSCH (CPU 2)
> > with cc 2 because it sees that FC clear function is set. Or?
> 
> Maybe for virtio, but for vfio this all gets passed through to the
> kernel who makes that distinction. And as I've mentioned above, that's
> not happening.

Let's have a look at the following qemu functions. AFAIK it is
common to vfio and virtio, or? Will prefix my inline 
comments with ###


IOInstEnding css_do_ssch(SubchDev *sch, ORB *orb)
{   
    SCHIB *schib = &sch->curr_status;

    if (~(schib->pmcw.flags) & (PMCW_FLAGS_MASK_DNV | PMCW_FLAGS_MASK_ENA)) {
        return IOINST_CC_NOT_OPERATIONAL;
    }
    
    if (schib->scsw.ctrl & SCSW_STCTL_STATUS_PEND) {
        return IOINST_CC_STATUS_PRESENT;
    }
    
    if (schib->scsw.ctrl & (SCSW_FCTL_START_FUNC |
                   SCSW_FCTL_HALT_FUNC |
                   SCSW_FCTL_CLEAR_FUNC)) {
        return IOINST_CC_BUSY;
### Here we check the FC values and give cc2 when we
### need to.
    }
    
    /* If monitoring is active, update counter. */
    if (channel_subsys.chnmon_active) {
        css_update_chnmon(sch);
    }
    sch->orb = *orb;
    sch->channel_prog = orb->cpa;
    /* Trigger the start function. */
    schib->scsw.ctrl |= (SCSW_FCTL_START_FUNC | SCSW_ACTL_START_PEND);
## Here we set the FC
    schib->scsw.flags &= ~SCSW_FLAGS_MASK_PNO;

    return do_subchannel_work(sch);
}

IOInstEnding css_do_csch(SubchDev *sch)
{
    SCHIB *schib = &sch->curr_status;

    if (~(schib->pmcw.flags) & (PMCW_FLAGS_MASK_DNV | PMCW_FLAGS_MASK_ENA)) {
        return IOINST_CC_NOT_OPERATIONAL;
    }

    /* Trigger the clear function. */
    schib->scsw.ctrl &= ~(SCSW_CTRL_MASK_FCTL | SCSW_CTRL_MASK_ACTL);
    schib->scsw.ctrl |= SCSW_FCTL_CLEAR_FUNC | SCSW_ACTL_CLEAR_PEND;
### Here we set FC for the clear

    return do_subchannel_work(sch);
}

So unless somebody (e.g. the kernel vfio-ccw) nukes the FC bits qemu
should prevent the second SSCH from your example getting to the kernel,
or?

This is why I hold the notion of a "composite device" for
important.

Regards,
Halil
