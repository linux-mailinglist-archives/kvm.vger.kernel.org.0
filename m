Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC0784E18
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 16:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387543AbfHGOBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 10:01:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43988 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729408AbfHGOBr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Aug 2019 10:01:47 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x77DnQrf042951
        for <kvm@vger.kernel.org>; Wed, 7 Aug 2019 10:01:46 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u7wyw6pfn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2019 10:01:45 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 7 Aug 2019 15:01:42 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 7 Aug 2019 15:01:40 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x77E1dLO43384870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Aug 2019 14:01:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6D414204C;
        Wed,  7 Aug 2019 14:01:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94B904204F;
        Wed,  7 Aug 2019 14:01:39 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.95.44])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Aug 2019 14:01:39 +0000 (GMT)
Date:   Wed, 7 Aug 2019 16:01:36 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC UNTESTED] vfio-ccw: indirect access to translated
 cps
In-Reply-To: <20190807132311.5238bc24.cohuck@redhat.com>
References: <20190726100617.19718-1-cohuck@redhat.com>
        <20190730174910.47930494.pasic@linux.ibm.com>
        <20190807132311.5238bc24.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19080714-0008-0000-0000-0000030644A2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19080714-0009-0000-0000-00004A24473A
Message-Id: <20190807160136.178e69de.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070149
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Aug 2019 13:23:11 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, 30 Jul 2019 17:49:10 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > On Fri, 26 Jul 2019 12:06:17 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> > 
> > > We're currently keeping a single area for translated channel
> > > programs in our private structure, which is filled out when
> > > we are translating a channel program we have been given by
> > > user space and marked invalid again when we received an final
> > > interrupt for that I/O.
> > > 
> > > Unfortunately, properly tracking the lifetime of that cp is
> > > not easy: failures may happen during translation or right when
> > > it is sent to the hardware, unsolicited interrupts may trigger
> > > a deferred condition code, a halt/clear request may be issued
> > > while the I/O is supposed to be running, or a reset request may
> > > come in from the side. The _PROCESSING state and the ->initialized
> > > flag help a bit, but not enough.
> > > 
> > > We want to have a way to figure out whether we actually have a cp
> > > currently in progress, so we can update/free only when applicable.
> > > Points to keep in mind:
> > > - We will get an interrupt after a cp has been submitted iff ssch
> > >   finished with cc 0.
> > > - We will get more interrupts for a cp if the interrupt status is
> > >   not final.
> > > - We can have only one cp in flight at a time.
> > > 
> > > Let's decouple the actual area in the private structure from the
> > > means to access it: Only after we have successfully submitted a
> > > cp (ssch with cc 0), update the pointer in the private structure
> > > to point to the area used. Therefore, the interrupt handler won't
> > > access the cp if we don't actually expect an interrupt pertaining
> > > to it.
> > > 
> > > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> > > ---
> > > 
> > > Just hacked this up to get some feedback, did not actually try it
> > > out. Not even sure if this is a sensible approach; if not, let's
> > > blame it on the heat and pretend it didn't happen :)
> > >   
> > 
> > Do not multiple threads access this new cp pointer (and at least one of
> > them writes)? If that is the case, it smells like a data race to me.
> 
> We might need some additional concurrent read/write handling on top, if
> state machine guarantees are not enough. (We may need a respin of the
> state machine locking for that, which we probably want anyway.)
> 

A respin of what? If you mean Pierre's "vfio: ccw: Make FSM functions
atomic" (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1711466.html)
that won't work any more because of async.

> > 
> > Besides the only point of converting cp to a pointer seems to be
> > policing access to cp_area (which used to be cp). I.e. if it is
> > NULL: don't touch it, otherwise: go ahead. We can do that with a single
> > bit, we don't need a pointer for that.
> 
> The idea was
> - do translation etc. on an area only accessed by the thread doing the
>   translation
> - switch the pointer to that area once the cp has been submitted
>   successfully (and it is therefore associated with further interrupts
>   etc.)
> The approach in this patch is probably a bit simplistic.
> 
> I think one bit is not enough, we have at least three states:
> - idle; start using the area if you like
> - translating; i.e. only the translator is touching the area, keep off
> - submitted; we wait for interrupts, handle them or free if no (more)
>   interrupts can happen

I think your patch assigns the pointer when transitioning from
translated --> submitted. That can be tracked with a single bit, that's
what I was trying to say. You seem to have misunderstood: I never
intended to claim that a single bit is sufficient to get this clean (only
to accomplish what the pointer accomplishes -- modulo races).

My impression was that the 'initialized' field is abut the idle -->
translating transition, but I never fully understood this 'initialized'
patch.

> 
> > 
> > Could we convert initialized into some sort of cp.status that
> > tracks/controls access and responsibilities? By working with bits we
> > could benefit from the atomicity of bit-ops -- if I'm not wrong.
> 
> We have both the state of the device (state machine) and the state of a
> cp, then. If we keep to a single cp area, we should track that within a
> single state (i.e. the device state).
> 

Maybe. Maybe not. I would have to write or see the code to figure that
out. Would we need additional states introduced to the device (state
machine)?

Anyway we do need to fix the races in the device state machine
for sure. I've already provided some food for thought (in form of a draft
patch) to Eric.

> > 
> > > I also thought about having *two* translation areas and switching
> > > the pointer between them; this might be too complicated, though?  
> > 
> > We only have one channel program at a time or? I can't see the benefit
> > of having two areas.
> 
> We can only have one in flight at a time; we could conceivably have
> another one that is currently in the process of being built. The idea
> was to switch between the two (so processing an in-flight one cannot
> overwrite one that is currently being built); but I think this is too
> complicated.
> 

I suppose the subchannel as seen by the guest should have FC 'start' bit
before the first translation (processing) starts. Please have a look at
the PoP if you don't agree. I.e. the translation/processing should be
considered a part of the asynchronous start function at the channel
subsystem, that is, from the guest perspective, that channel program is
already 'in flight'. So it does not make sense to me, to start
translating another cp.

Yes, the current implementation does the translation in instruction
context, and not as a part of the async io function. IMHO that is at
least sub-optimal if not wrong. QEMU however sets SCSW_FCTL_START_FUNC
before calling css_do_ssch(), but that should not be guest observable,
because of BQL. That also means QEMU won't try to issue the next cp
before the previous one was processed by vfio-ccw (submitted via ssch or
rejected) because of BQL. And then SCSW_FCTL_START_FUNC should prevent
acceptance of the next one while the previous one is still relevant.

TL;DR I don't think having two cp areas make sense.

Regards,
Halil

Regards,
Halil

