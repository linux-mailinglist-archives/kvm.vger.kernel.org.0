Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B708F70D
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 00:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbfHOWeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 18:34:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728956AbfHOWeK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Aug 2019 18:34:10 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7FMWADm033038
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 18:34:10 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2udemdbdng-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 18:34:09 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 15 Aug 2019 23:34:07 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 15 Aug 2019 23:34:05 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7FMY4m237945780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 22:34:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2635F4205E;
        Thu, 15 Aug 2019 22:34:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE6D442059;
        Thu, 15 Aug 2019 22:34:03 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.177.40])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Aug 2019 22:34:03 +0000 (GMT)
Date:   Fri, 16 Aug 2019 00:34:02 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC UNTESTED] vfio-ccw: indirect access to translated
 cps
In-Reply-To: <20190808104306.2450bdcf.cohuck@redhat.com>
References: <20190726100617.19718-1-cohuck@redhat.com>
        <20190730174910.47930494.pasic@linux.ibm.com>
        <20190807132311.5238bc24.cohuck@redhat.com>
        <20190807160136.178e69de.pasic@linux.ibm.com>
        <20190808104306.2450bdcf.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19081522-4275-0000-0000-000003598D6E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081522-4276-0000-0000-0000386BA429
Message-Id: <20190816003402.2a52b863.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-15_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908150213
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Aug 2019 10:43:06 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, 7 Aug 2019 16:01:36 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:

[..]

> > A respin of what? If you mean Pierre's "vfio: ccw: Make FSM functions
> > atomic" (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1711466.html)
> > that won't work any more because of async.
> 
> s/respin/rework/, more likely.

Nod.

> 
> > 
> > > > 
> > > > Besides the only point of converting cp to a pointer seems to be
> > > > policing access to cp_area (which used to be cp). I.e. if it is
> > > > NULL: don't touch it, otherwise: go ahead. We can do that with a single
> > > > bit, we don't need a pointer for that.  
> > > 
> > > The idea was
> > > - do translation etc. on an area only accessed by the thread doing the
> > >   translation
> > > - switch the pointer to that area once the cp has been submitted
> > >   successfully (and it is therefore associated with further interrupts
> > >   etc.)
> > > The approach in this patch is probably a bit simplistic.
> > > 
> > > I think one bit is not enough, we have at least three states:
> > > - idle; start using the area if you like
> > > - translating; i.e. only the translator is touching the area, keep off
> > > - submitted; we wait for interrupts, handle them or free if no (more)
> > >   interrupts can happen  
> > 
> > I think your patch assigns the pointer when transitioning from
> > translated --> submitted. That can be tracked with a single bit, that's
> > what I was trying to say. You seem to have misunderstood: I never
> > intended to claim that a single bit is sufficient to get this clean (only
> > to accomplish what the pointer accomplishes -- modulo races).
> > 
> > My impression was that the 'initialized' field is abut the idle -->
> > translating transition, but I never fully understood this 'initialized'
> > patch.
> 
> So we do have three states here, right? (I hope we're not talking past
> each other again...)

Right, AFAIR  and without any consideration to fine details the three
states and two state transitions do make sense.

> 
> > 
> > >   
> > > > 
> > > > Could we convert initialized into some sort of cp.status that
> > > > tracks/controls access and responsibilities? By working with bits we
> > > > could benefit from the atomicity of bit-ops -- if I'm not wrong.  
> > > 
> > > We have both the state of the device (state machine) and the state of a
> > > cp, then. If we keep to a single cp area, we should track that within a
> > > single state (i.e. the device state).
> > >   
> > 
> > Maybe. Maybe not. I would have to write or see the code to figure that
> > out. Would we need additional states introduced to the device (state
> > machine)?
> 
> We might, but I don't think so. My point is that we probably want to
> track on a device level and not introduce extra tracking.
> 

OK

> > 
> > Anyway we do need to fix the races in the device state machine
> > for sure. I've already provided some food for thought (in form of a draft
> > patch) to Eric.
> 
> Any chance you could post that patch? :)
> 

Unfortunately I don't have the bandwidth to make a proper patch out of
it. The interactions are quite complex and it would take quite some time
to reach the point where I can say everything feels water-proof and
clean (inclusive testing). But since you seem curious about it I will
send you my draft work.

[..]

> > 
> > TL;DR I don't think having two cp areas make sense.
> 
> Let's stop going down that way further, I agree.
> 

Great!

Regards,
Halil

