Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78823692F9
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 15:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhDWNX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 09:23:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230305AbhDWNX4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 09:23:56 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13ND4ugO046332;
        Fri, 23 Apr 2021 09:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=T0+stmb3MDFFvPtn4KpQQH/Y5nNKocDbT0syzb/tLH4=;
 b=E0YgkIHWKT4obC3d1ImHpa/nLylVDx3JqdEQHfjGEa//qKUH5qtrjLD9kStlo9wx3ZXv
 2g6n/kkDpfvMP5bJ3yP1uj3X2Ee0fJSP69nqOGizRK/Co6VbFlhFw0gRu6/36EF4gqUj
 UGa0Itqd5NxWb0LDAvZ00tgTM/nF97HhGYH+ngvmG2aodbOkTP4QUoCWYAA4zk6W8HTa
 zvSA6X2tAKfheboootcpQGyqr5rpcIpRSyGuJhsKHlVuj54ct/SrT+m63neaNT+sTCXX
 wXhi5nwWnPKNHp4LbD11paKH8SI3iXQ3/UwGbUp0UJUl1bFYBaoIClYuxNcMClBytz+c CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3838bxah6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 09:23:19 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13ND59S4047465;
        Fri, 23 Apr 2021 09:23:19 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3838bxah5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 09:23:19 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13NDNHJY014614;
        Fri, 23 Apr 2021 13:23:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 37yqa89vjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 13:23:17 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13NDMo9m31261144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 13:22:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E806CA4068;
        Fri, 23 Apr 2021 13:23:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7191EA405C;
        Fri, 23 Apr 2021 13:23:13 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.88.237])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 23 Apr 2021 13:23:13 +0000 (GMT)
Date:   Fri, 23 Apr 2021 15:23:11 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20210423152311.20570945.pasic@linux.ibm.com>
In-Reply-To: <20210423130616.6dcbf4e4.cohuck@redhat.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
        <20210422025258.6ed7619d.pasic@linux.ibm.com>
        <1eb9cbdfe43a42a62f6afb0315bb1e3a103dac9a.camel@linux.ibm.com>
        <20210423130616.6dcbf4e4.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gyMRL6SkN0MNsn1qAq5QwaYCajwwUsdt
X-Proofpoint-GUID: Eb9DE4-tZGyjcI3U_0YuiyrgdD9QoSNL
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_04:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 23 Apr 2021 13:06:16 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 22 Apr 2021 16:49:21 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
> > On Thu, 2021-04-22 at 02:52 +0200, Halil Pasic wrote:  
> > > On Tue, 13 Apr 2021 20:24:06 +0200
> > > Eric Farman <farman@linux.ibm.com> wrote:
> > >     
> > > > Hi Conny, Halil,
> > > > 
> > > > Let's restart our discussion about the collision between interrupts
> > > > for
> > > > START SUBCHANNEL and HALT/CLEAR SUBCHANNEL. It's been a quarter
> > > > million
> > > > minutes (give or take), so here is the problematic scenario again:
> > > > 
> > > > 	CPU 1			CPU 2
> > > >  1	CLEAR SUBCHANNEL
> > > >  2	fsm_irq()
> > > >  3				START SUBCHANNEL
> > > >  4	vfio_ccw_sch_io_todo()
> > > >  5				fsm_irq()
> > > >  6				vfio_ccw_sch_io_todo()
> > > > 
> > > > From the channel subsystem's point of view the CLEAR SUBCHANNEL
> > > > (step 1)
> > > > is complete once step 2 is called, as the Interrupt Response Block
> > > > (IRB)
> > > > has been presented and the TEST SUBCHANNEL was driven by the cio
> > > > layer.
> > > > Thus, the START SUBCHANNEL (step 3) is submitted [1] and gets a
> > > > cc=0 to
> > > > indicate the I/O was accepted. However, step 2 stacks the bulk of
> > > > the
> > > > actual work onto a workqueue for when the subchannel lock is NOT
> > > > held,
> > > > and is unqueued at step 4. That code misidentifies the data in the
> > > > IRB
> > > > as being associated with the newly active I/O, and may release
> > > > memory
> > > > that is actively in use by the channel subsystem and/or device.
> > > > Eww.
> > > > 
> > > > In this version...
> > > > 
> > > > Patch 1 and 2 are defensive checks. Patch 2 was part of v3 [2], but
> > > > I
> > > > would love a better option here to guard between steps 2 and 4.
> > > > 
> > > > Patch 3 is a subset of the removal of the CP_PENDING FSM state in
> > > > v3.
> > > > I've obviously gone away from this idea, but I thought this piece
> > > > is
> > > > still valuable.
> > > > 
> > > > Patch 4 collapses the code on the interrupt path so that changes to
> > > > the FSM state and the channel_program struct are handled at the
> > > > same
> > > > point, rather than separated by a mutex boundary. Because of the
> > > > possibility of a START and HALT/CLEAR running concurrently, it does
> > > > not make sense to split them here.
> > > > 
> > > > With the above patches, maybe it then makes sense to hold the
> > > > io_mutex
> > > > across the entirety of vfio_ccw_sch_io_todo(). But I'm not
> > > > completely
> > > > sure that would be acceptable.
> > > > 
> > > > So... Thoughts?    
> > > 
> > > I believe we should address    
> > 
> > Who is the "we" here?
> >   
> > >  the concurrency, encapsulation and layering
> > > issues in the subchannel/ccw pass-through code (vfio-ccw) by taking a
> > > holistic approach as soon as possible.  
> 
> Let me also ask: what is "holistic"? If that's a complete rewrite, I
> definitely don't have the capacity for that; if others want to take
> over the code, feel free.
> 

In general: https://en.wikipedia.org/wiki/Holism

In this context I mean:
* Fix all data races in in the vfio-ccw module instead of making the
"race window" smaller. Reasoning about the behavior of racy programs
is very difficult.
* The passed-through subchannel of the VM, as seen by the guest OS is an
overlay of the host subchannel (which we have to assume is within the
specification), the vfio-ccw kernel module, and an userspace emulator.
The interface between the kernel module and the userspace emulator is
something the authors of the vfio-ccw kernel module design, and while
doing so we have to think about the interface the whole solution needs
to implemnet. For example we should ask ourselves: what is the right
response in kernel when we encounter the situation described by the
steps 1-3 of Eric's scenario. Our VMs subchannel needs to reward the
SSC with a cc=2 if the subchannel has the clear FC bit set. If we detect
the described condition, does it mean that the userspace emulator is
broken? Or is the userspace emulator allowed to rely on the vfio-ccw
kernel module to detect this condition and return an -EBUSY (which
corresponds to cc=2 because that is apart of the definition of the
interface between the kernel and the userspace)? When is the FC bit
of our VMs subchannel cleared? I read patch 2 like it is trying to catch
the condition and return an -EBUSY, but I don't see it catching all
the possible cases. I.e. what if another CPU is executing the first
instruction of vfio_ccw_sch_io_todo() when we check 
work_pending(&private->io_work) in fsm_io_helper()?

[..]

> >   
> > > Moreover patch 4 seems to rely on
> > > private->state which, AFAIR is still used in a racy fashion.
> > > 
> > > But if strong empirical evidence shows that it performs better (stops
> > > the bleeding), I think we can go ahead with it.    
> > 
> > Again with the bleeding. Is there a Doctor in the house? :)  
> 
> No idea, seen any blue boxes around? :)
> 

Let me also ask what: blue boxes do you mean? If you mean
https://en.wikipedia.org/wiki/Blue_box
then, I'm not sure I can follow your association. Are you looking for
phone to call a doctor?

Regards,
Halil
