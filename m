Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A371D31AC
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 15:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgENNql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 09:46:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726073AbgENNql (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 09:46:41 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EDYCNQ134631;
        Thu, 14 May 2020 09:46:39 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310uauw4b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 09:46:39 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04EDaQgk147620;
        Thu, 14 May 2020 09:46:39 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310uauw4ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 09:46:39 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04EDkFVg025679;
        Thu, 14 May 2020 13:46:37 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3100ubhhdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 13:46:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04EDjNsS61407670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 13:45:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 842804C050;
        Thu, 14 May 2020 13:46:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 330E24C04A;
        Thu, 14 May 2020 13:46:34 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.163.147])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 May 2020 13:46:34 +0000 (GMT)
Date:   Thu, 14 May 2020 15:46:01 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20200514154601.007ae46f.pasic@linux.ibm.com>
In-Reply-To: <20200513142934.28788-1-farman@linux.ibm.com>
References: <20200513142934.28788-1-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_03:2020-05-14,2020-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 May 2020 16:29:30 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Hi Conny,
> 
> Back in January, I suggested a small patch [1] to try to clean up
> the handling of HSCH/CSCH interrupts, especially as it relates to
> concurrent SSCH interrupts. Here is a new attempt to address this.
> 
> There was some suggestion earlier about locking the FSM, but I'm not
> seeing any problems with that. Rather, what I'm noticing is that the
> flow between a synchronous START and asynchronous HALT/CLEAR have
> different impacts on the FSM state. Consider:
> 
>     CPU 1                           CPU 2
> 
>     SSCH (set state=CP_PENDING)
>     INTERRUPT (set state=IDLE)
>     CSCH (no change in state)
>                                     SSCH (set state=CP_PENDING)
>     INTERRUPT (set state=IDLE)
>                                     INTERRUPT (set state=IDLE)

How does the PoP view of the composite device look like 
(where composite device = vfio-ccw + host device)?

I suppose at the moment where we accept the CSCH the FC bit
indicated clear function (19) goes to set. When this happens
there are 2 possibilities: either the start (17) bit is set,
or it is not. You describe a scenario where the start bit is
not set. In that case we don't have a channel program that
is currently being processed, and any SSCH must bounce right
off without doing anything (with cc 2) as long as FC clear
is set. Please note that we are still talking about the composite
device here.

Thus in my reading CPU2 making the IDLE -> CP_PENDING transition
happen is already wrong. We should have rejected to look at the
channel program in the first place. Because as far as I can tell
for the composite device the FC clear bit remains set until we
process the last interrupt on the CPU 1 side in your scenario. Or
am I wrong?

AFAIR I was preaching about this several times, but could never
convince the people that 'let the host ccw device sort out
concurrency' is not the way this should work.

Maybe I have got a hole in my argument somewhere. If my argument
is wrong, please do point out why!

> 
> The second interrupt on CPU 1 will call cp_free() for the START
> created by CPU 2, and our results will be, um, messy. This
> suggests that three things must be true:
> 
>  A) cp_free() must be called for either a final interrupt,
> or a failure issuing a SSCH
>  B) The FSM state must only be set to IDLE once cp_free()
> has been called
>  C) A SSCH cannot be issued while an interrupt is outstanding

So you propose to reject SSCH in the IDLE state (if an interrupt
is outstanding)? That is one silly IDLE state and FSM for sure.

> 
> It's not great that items B and C are separated in the interrupt
> path by a mutex boundary where the copy into io_region occurs.
> We could (and perhaps should) move them together, which would
> improve things somewhat, but still doesn't address the scenario
> laid out above. Even putting that work within the mutex window
> during interrupt processing doesn't address things totally.
> 
> So, the patches here do two things. One to handle unsolicited
> interrupts [2], which I think is pretty straightforward. Though,
> it does make me want to do a more drastic rearranging of the
> affected function. :)
> 
> The other warrants some discussion, since it's sort of weird.
> Basically, recognize what commands we've issued, expect interrupts
> for each, and prevent new SSCH's while asynchronous commands are
> pending. It doesn't address interrupts from the HSCH/CSCH that
> could be generated by the Channel Path Handling code [3] for an
> offline CHPID yet, and it needs some TLC to make checkpatch happy.
> But it's the best possibility I've seen thus far.
> 
> I used private->scsw for this because it's barely used for anything
> else; at one point I had been considering removing it outright because
> we have entirely too many SCSW's in this code. :) I could implement
> this as three small flags in private, to simplify the code and avoid
> confusion with the different fctl/actl flags in private vs schib.
> 

Implementing the FSM described in the PoP (which in turn
conceptually relies on atomic operations on the FC bits) is IMHO
the way to go. But we can track that info in our FSM states. In
fact our FSM states should just add sub-partitioning of states to
those states (if necessary).


> It does make me wonder whether the CP_PENDING check before cp_free()
> is still necessary, but that's a query for a later date.
> 
> Also, perhaps this could be accomplished with two new FSM states,
> one for a HALT and one for a CLEAR. I put it aside because the
> interrupt handler got a little hairy with that, but I'm still looking
> at it in parallel to this discussion.
> 

You don't necessarily need 2 new states. Just one that corresponds
to FC clear function will do.

> I look forward to hearing your thoughts...

Please see above ;)

Also why do we see the scenario you describe in the wild? I agree that
this should be taken care of in the kernel as well, but according to my
understanding QEMU is already supposed to reject the second SSCH (CPU 2)
with cc 2 because it sees that FC clear function is set. Or?

Regards,
Halil

> 
> [1] https://lore.kernel.org/kvm/20200124145455.51181-1-farman@linux.ibm.com/
> [2] https://lore.kernel.org/kvm/9635c45f-4652-c837-d256-46f426737a5e@linux.ibm.com/
> [3] https://lore.kernel.org/kvm/20200505122745.53208-1-farman@linux.ibm.com/
> 
> Eric Farman (4):
>   vfio-ccw: Do not reset FSM state for unsolicited interrupts
>   vfio-ccw: Utilize scsw actl to serialize start operations
>   vfio-ccw: Expand SCSW usage to HALT and CLEAR
>   vfio-ccw: Clean up how to react to a failed START
> 
>  drivers/s390/cio/vfio_ccw_drv.c | 10 +++++++++-
>  drivers/s390/cio/vfio_ccw_fsm.c | 26 ++++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_ops.c |  3 +--
>  3 files changed, 36 insertions(+), 3 deletions(-)
> 

