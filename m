Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E94A4137DB
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 18:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhIUQyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 12:54:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43766 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229601AbhIUQyK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 12:54:10 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LGUZMf008466;
        Tue, 21 Sep 2021 12:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zq7YY3YY+sxUoqCZOSv7oBX0nJQbTKqcrFtg5oANv1s=;
 b=DrYrnkzVv6SXbIyICfswMh9+n1qwl7O9z6/gxpUA9NvNsRnjK0QAto9xzMgANdNPIsqZ
 +66Hvp7VnFQ0YWG6Zp5rPevthlu9W9M3idYqDbzZgO7gsSafzRXJvbYRZGxgCdj0PeWS
 wpgpzGVx0JT0Ae8nGSOgQ/HyX2UgO3QBrAOwJys0ZlvSsNEZH3ykzHDGAHxFGizoLvDO
 Hq50Q1xNF1ITpFhh/gYkd5H/KomZ08p2999+nk5Rldz5BHSj+xALmIYyvlNegdIzN7vb
 hVFadApy2WoYDldS7Jetj+vCdOBCEQiPXSix28r/ONqKSqUOvQ5QUpJ1yAD5xTmszvGx ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7jyrgf7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 12:52:40 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18LGatrn007253;
        Tue, 21 Sep 2021 12:52:39 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7jyrgf75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 12:52:39 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18LGpZmW029688;
        Tue, 21 Sep 2021 16:52:37 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3b57r8yu7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 16:52:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18LGqYds64356724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 16:52:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3381142047;
        Tue, 21 Sep 2021 16:52:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60B7D42045;
        Tue, 21 Sep 2021 16:52:33 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.4.199])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 21 Sep 2021 16:52:33 +0000 (GMT)
Date:   Tue, 21 Sep 2021 18:52:22 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Vineeth Vijayan <vneethv@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfu@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio/s390: fix vritio-ccw device teardown
Message-ID: <20210921185222.246b15bb.pasic@linux.ibm.com>
In-Reply-To: <05b1ac0e4aa4a1c7df1a8994c898630e9b2e384d.camel@linux.ibm.com>
References: <20210915215742.1793314-1-pasic@linux.ibm.com>
        <87pmt8hp5o.fsf@redhat.com>
        <20210916151835.4ab512b2.pasic@linux.ibm.com>
        <87mtobh9xn.fsf@redhat.com>
        <20210920003935.1369f9fe.pasic@linux.ibm.com>
        <88b514a4416cf72cda53a31ad2e15c13586350e4.camel@linux.ibm.com>
        <878rzrh86c.fsf@redhat.com>
        <20210921052548.4eea231f.pasic@linux.ibm.com>
        <05b1ac0e4aa4a1c7df1a8994c898630e9b2e384d.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cNbMBuXq06W4CDMkwxrKesH3Zq0-0zsb
X-Proofpoint-ORIG-GUID: AwH4AXAt3PYdrg-FToX5RJsf1fRJy4ev
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_04,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109210098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Sep 2021 15:31:03 +0200
Vineeth Vijayan <vneethv@linux.ibm.com> wrote:

> On Tue, 2021-09-21 at 05:25 +0200, Halil Pasic wrote:
> > On Mon, 20 Sep 2021 12:07:23 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> > > On Mon, Sep 20 2021, Vineeth Vijayan <vneethv@linux.ibm.com> wrote:
> > >   
> > > > On Mon, 2021-09-20 at 00:39 +0200, Halil Pasic wrote:    
> > > > > On Fri, 17 Sep 2021 10:40:20 +0200
> > > > > Cornelia Huck <cohuck@redhat.com> wrote:
> > > > >     
> > > > ...snip...    
> > > > > > > Thanks, if I find time for it, I will try to understand
> > > > > > > this
> > > > > > > better and
> > > > > > > come back with my findings.
> > > > > > >      
> > > > > > > > > * Can virtio_ccw_remove() get called while !cdev-  
> > > > > > > > > >online and   
> > > > > > > > >   virtio_ccw_online() is running on a different cpu? If
> > > > > > > > > yes,
> > > > > > > > > what would
> > > > > > > > >   happen then?        
> > > > > > > > 
> > > > > > > > All of the remove/online/... etc. callbacks are invoked
> > > > > > > > via the
> > > > > > > > ccw bus
> > > > > > > > code. We have to trust that it gets it correct :) (Or
> > > > > > > > have the
> > > > > > > > common
> > > > > > > > I/O layer maintainers double-check it.)
> > > > > > > >       
> > > > > > > 
> > > > > > > Vineeth, what is your take on this? Are the struct
> > > > > > > ccw_driver
> > > > > > > virtio_ccw_remove and the virtio_ccw_online callbacks
> > > > > > > mutually
> > > > > > > exclusive. Please notice that we may initiate the onlining
> > > > > > > by
> > > > > > > calling ccw_device_set_online() from a workqueue.
> > > > > > > 
> > > > > > > @Conny: I'm not sure what is your definition of 'it gets it
> > > > > > > correct'...
> > > > > > > I doubt CIO can make things 100% foolproof in this
> > > > > > > area.      
> > > > > > 
> > > > > > Not 100% foolproof, but "don't online a device that is in the
> > > > > > progress
> > > > > > of going away" seems pretty basic to me.
> > > > > >     
> > > > > 
> > > > > I hope Vineeth will chime in on this.    
> > > > Considering the online/offline processing, 
> > > > The ccw_device_set_offline function or the online/offline is
> > > > handled
> > > > inside device_lock. Also, the online_store function takes care of
> > > > avoiding multiple online/offline processing. 
> > > > 
> > > > Now, when we consider the unconditional remove of the device,
> > > > I am not familiar with the virtio_ccw driver. My assumptions are
> > > > based
> > > > on how CIO/dasd drivers works. If i understand correctly, the
> > > > dasd
> > > > driver sets different flags to make sure that a device_open is
> > > > getting
> > > > prevented while the the device is in progress of offline-ing.     
> > > 
> > > Hm, if we are invoking the online/offline callbacks under the
> > > device
> > > lock already,   
> > 
> > I believe we have a misunderstanding here. I believe that Vineeth is
> > trying to tell us, that online_store_handle_offline() and
> > online_store_handle_offline() are called under the a device lock of
> > the ccw device. Right, Vineeth?  
> Yes. I wanted to bring-out both the scenario.The set_offline/_online()
> calls and the unconditional-remove call.

I don't understand the paragraph above. I can't map the terms
set_offline/_online() and unconditional-remove call to chunks of code.
:( 

> For the set_online The virtio_ccw_online() also invoked with ccwlock
> held. (ref: ccw_device_set_online)

I don't think virtio_ccw_online() is invoked with the ccwlock held. I
think we call virtio_ccw_online() in this line:
https://elixir.bootlin.com/linux/v5.15-rc2/source/drivers/s390/cio/device.c#L394
and we have released the cdev->ccwlock literally 2 lines above.


> > 
> > Conny, I believe, by online/offline callbacks, you mean
> > virtio_ccw_online() and virtio_ccw_offline(), right?
> > 
> > But the thing is that virtio_ccw_online() may get called (and is
> > typically called, AFAICT) with no locks held via:
> > virtio_ccw_probe() --> async_schedule(virtio_ccw_auto_online, cdev)
> > -*-> virtio_ccw_auto_online(cdev) --> ccw_device_set_online(cdev) -->
> > virtio_ccw_online()
> > 
> > Furthermore after a closer look, I believe because we don't take
> > a reference to the cdev in probe, we may get virtio_ccw_auto_online()
> > called with an invalid pointer (the pointer is guaranteed to be valid
> > in probe, but because of async we have no guarantee that it will be
> > called in the context of probe).
> > 
> > Shouldn't we take a reference to the cdev in probe?  
> We just had a quick look at the virtio_ccw_probe() function.
> Did you mean to have a get_device() during the probe() and put_device()
> just after the virtio_ccw_auto_online() ?

Yes, that would ensure that cdev pointer is still valid when
virtio_ccw_auto_online() is executed, and that things are cleaned up
properly, I guess. But I'm not 100% sure about all the interactions.
AFAIR ccw_device_set_online(cdev) would bail out if !drv. But then
we have the case where we already assigned it to a new driver (e.g.
vfio for dasd).

BTW I believe if we have a problem here, the dasd driver has the same
problem as well. The code looks very, very similar.

And shouldn't this auto-online be common CIO functionality? What is the
reason the char devices don't seem to have it?

Regards,
Halil
