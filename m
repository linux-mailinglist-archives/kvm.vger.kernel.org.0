Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0FC1D8A6E
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 00:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgERWKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 18:10:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbgERWKT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 18:10:19 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04IM3lve154696;
        Mon, 18 May 2020 18:10:18 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312c8nee1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 18:10:18 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04IM6Qc0170460;
        Mon, 18 May 2020 18:10:17 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312c8nee0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 18:10:17 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04IM0kU0026492;
        Mon, 18 May 2020 22:10:15 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 313xdhr4v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 22:10:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04IMACD552297826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 22:10:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E4F4A4054;
        Mon, 18 May 2020 22:10:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B5C5A405B;
        Mon, 18 May 2020 22:10:12 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.176.157])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 18 May 2020 22:10:12 +0000 (GMT)
Date:   Tue, 19 May 2020 00:09:43 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20200519000943.70098774.pasic@linux.ibm.com>
In-Reply-To: <20200518180903.7cb21dd8.cohuck@redhat.com>
References: <20200513142934.28788-1-farman@linux.ibm.com>
 <20200518180903.7cb21dd8.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=791
 priorityscore=1501 clxscore=1015 mlxscore=0 suspectscore=0
 lowpriorityscore=0 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180186
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 18:09:03 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, 13 May 2020 16:29:30 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
> > Hi Conny,
> > 
> > Back in January, I suggested a small patch [1] to try to clean up
> > the handling of HSCH/CSCH interrupts, especially as it relates to
> > concurrent SSCH interrupts. Here is a new attempt to address this.
> > 
> > There was some suggestion earlier about locking the FSM, but I'm not
> > seeing any problems with that. Rather, what I'm noticing is that the
> > flow between a synchronous START and asynchronous HALT/CLEAR have
> > different impacts on the FSM state. Consider:
> > 
> >     CPU 1                           CPU 2
> > 
> >     SSCH (set state=CP_PENDING)
> >     INTERRUPT (set state=IDLE)
> >     CSCH (no change in state)
> >                                     SSCH (set state=CP_PENDING)
> 
> This is the transition I do not understand. When we get a request via
> the I/O area, we go to CP_PROCESSING and start doing translations.
> However, we only transition to CP_PENDING if we actually do a SSCH with
> cc 0 -- which shouldn't be possible in the flow you outline... unless
> it really is something that can be taken care of with locking (state
> machine transitioning due to an interrupt without locking, so we go to
> IDLE without other parts noticing.)

I argued, that the second SSCH is to be caught by QEMU. So I think
we are kind of on the same page, and yet when it comes to details
we are not.

The details: We have multiple non-atomic things going on
* the clear function FC gets set at the host subchannel 
* the clear function completes and the subchannel becomes status pending
* an interrupt is delivered that indicates the subchannel event
* the interrupt handler gets invoked
* STSCH does its thing
* state is set to IDLE

So theoretically, between STSCH is done (and cleared FC clear bit)
and state=IDLE an SSCH can go through.


> 
> >     INTERRUPT (set state=IDLE)
> >                                     INTERRUPT (set state=IDLE)
> 
> But taking a step back (and ignoring your series and the discussion,
> sorry about that):
> 
> We need to do something (creating a local translation of the guest's
> channel program) that does not have any relation to the process in the
> architecture at all, but is only something that needs to be done
> because of what vfio-ccw is trying to do (issuing a channel program on
> behalf of another entity.) 

I violently disagree with this point. Looking at the whole vfio-ccw
device the translation is part of the execution of the channel program,
more specifically it fits in as prefetching. Thus it needs to happen
with the FC start bit set. Before FC start is set the subchannel is
not allowed to process (including look at) the channel program. At least
that is what I remember.

> Trying to sort that out by poking at actl
> and fctl bits does not seem like the best way; especially as keeping
> the bits up-to-date via STSCH is an exercise in futility.

I disagree. A single subchannel is processing at most one channel
program at any given point in time. Or am I reading the PoP wrong?

> 
> What about the following (and yes, I had suggested something vaguely in
> that direction before):
> 
> - Detach the cp from the subchannel (or better, remove the 1:1
>   relationship). By that I mean building the cp as a separately
>   allocated structure (maybe embedding a kref, but that might not be
>   needed), and appending it to a list after SSCH with cc=0. Discard it
>   if cc!=0.
> - Remove the CP_PENDING state. The state is either IDLE after any
>   successful SSCH/HSCH/CSCH, or a new state in that case. But no
>   special state for SSCH.
> - A successful CSCH removes the first queued request, if any.
> - A final interrupt removes the first queued request, if any.
> 
> Thoughts?
> 

See above. IMHO the second SSCH is to be rejected by QEMU. I've
explained this in more detail in my previous mail.

Regards,
Halil



