Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9996A412D83
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 05:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhIUDei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 23:34:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232386AbhIUD1b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 23:27:31 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18L0rCnq016418;
        Mon, 20 Sep 2021 23:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=TL+GlalNIK+3zibfx+nL1dORUR5W26SmgFjpn2woVJs=;
 b=QTp2rjHH/p29DQcBLn6fn8BzKlp8uUnGSbo9KW9JYPG2Y6wHJPqm9ax7GbZyCDAgTY0q
 Rnkg0OZ+C3oKcsgvvMSPYxtEnq9mz0lvqHO9H4CJaV/fBWcecKABCovFExGHB6r9063/
 RNus3bm54PI2DrfFEpd+aZ0lR9fknzWSi7JhJuNWBXkRV8oxVxJKrH1Xkdk1UBJnEg9e
 KtHUeBlQGlUnfb5ssFDu6W2sOsn46OtDYpwDYrbn8WQfswKZD0F2OEXECmW/tMk93ufB
 nGr3biSxUwRSIaqNEyNW3gb5V0CwqhUXGq5paeYVC7m+sbfHCFRJFlSiYi3HjZjE+bJz eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7587thut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 23:25:59 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18L3Mu50021877;
        Mon, 20 Sep 2021 23:25:59 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7587thuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 23:25:59 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18L3BJFL006177;
        Tue, 21 Sep 2021 03:25:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3b57r9eyjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 03:25:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18L3PqYq24117532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 03:25:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5DA54C04A;
        Tue, 21 Sep 2021 03:25:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26E824C052;
        Tue, 21 Sep 2021 03:25:52 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.4.199])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 21 Sep 2021 03:25:52 +0000 (GMT)
Date:   Tue, 21 Sep 2021 05:25:48 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfu@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio/s390: fix vritio-ccw device teardown
Message-ID: <20210921052548.4eea231f.pasic@linux.ibm.com>
In-Reply-To: <878rzrh86c.fsf@redhat.com>
References: <20210915215742.1793314-1-pasic@linux.ibm.com>
        <87pmt8hp5o.fsf@redhat.com>
        <20210916151835.4ab512b2.pasic@linux.ibm.com>
        <87mtobh9xn.fsf@redhat.com>
        <20210920003935.1369f9fe.pasic@linux.ibm.com>
        <88b514a4416cf72cda53a31ad2e15c13586350e4.camel@linux.ibm.com>
        <878rzrh86c.fsf@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XjDuFQpeAfPOVtWuR6W62JpRyGZKfIda
X-Proofpoint-ORIG-GUID: uf7iz-HTos6Z6VXiEOn7AkZE6YX7MiMM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_11,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109210017
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Sep 2021 12:07:23 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Mon, Sep 20 2021, Vineeth Vijayan <vneethv@linux.ibm.com> wrote:
> 
> > On Mon, 2021-09-20 at 00:39 +0200, Halil Pasic wrote:  
> >> On Fri, 17 Sep 2021 10:40:20 +0200
> >> Cornelia Huck <cohuck@redhat.com> wrote:
> >>   
> > ...snip...  
> >> > > 
> >> > > Thanks, if I find time for it, I will try to understand this
> >> > > better and
> >> > > come back with my findings.
> >> > >    
> >> > > > > * Can virtio_ccw_remove() get called while !cdev->online and 
> >> > > > >   virtio_ccw_online() is running on a different cpu? If yes,
> >> > > > > what would
> >> > > > >   happen then?      
> >> > > > 
> >> > > > All of the remove/online/... etc. callbacks are invoked via the
> >> > > > ccw bus
> >> > > > code. We have to trust that it gets it correct :) (Or have the
> >> > > > common
> >> > > > I/O layer maintainers double-check it.)
> >> > > >     
> >> > > 
> >> > > Vineeth, what is your take on this? Are the struct ccw_driver
> >> > > virtio_ccw_remove and the virtio_ccw_online callbacks mutually
> >> > > exclusive. Please notice that we may initiate the onlining by
> >> > > calling ccw_device_set_online() from a workqueue.
> >> > > 
> >> > > @Conny: I'm not sure what is your definition of 'it gets it
> >> > > correct'...
> >> > > I doubt CIO can make things 100% foolproof in this area.    
> >> > 
> >> > Not 100% foolproof, but "don't online a device that is in the
> >> > progress
> >> > of going away" seems pretty basic to me.
> >> >   
> >> 
> >> I hope Vineeth will chime in on this.  
> > Considering the online/offline processing, 
> > The ccw_device_set_offline function or the online/offline is handled
> > inside device_lock. Also, the online_store function takes care of
> > avoiding multiple online/offline processing. 
> >
> > Now, when we consider the unconditional remove of the device,
> > I am not familiar with the virtio_ccw driver. My assumptions are based
> > on how CIO/dasd drivers works. If i understand correctly, the dasd
> > driver sets different flags to make sure that a device_open is getting
> > prevented while the the device is in progress of offline-ing.   
> 
> Hm, if we are invoking the online/offline callbacks under the device
> lock already, 

I believe we have a misunderstanding here. I believe that Vineeth is
trying to tell us, that online_store_handle_offline() and
online_store_handle_offline() are called under the a device lock of
the ccw device. Right, Vineeth?

Conny, I believe, by online/offline callbacks, you mean
virtio_ccw_online() and virtio_ccw_offline(), right?

But the thing is that virtio_ccw_online() may get called (and is
typically called, AFAICT) with no locks held via:
virtio_ccw_probe() --> async_schedule(virtio_ccw_auto_online, cdev)
-*-> virtio_ccw_auto_online(cdev) --> ccw_device_set_online(cdev) -->
virtio_ccw_online()

Furthermore after a closer look, I believe because we don't take
a reference to the cdev in probe, we may get virtio_ccw_auto_online()
called with an invalid pointer (the pointer is guaranteed to be valid
in probe, but because of async we have no guarantee that it will be
called in the context of probe).

Shouldn't we take a reference to the cdev in probe? BTW what is the
reason for the async?


> how would that affect the remove callback?

I believe dev->bus->remove(dev) is called by 
bus_remove_device() with the device lock held. I.e. I believe that means
that virtio_ccw_remove() is called with the ccw devices device lock
held. Vineeth can you confirm that?


The thing is, both virtio_ccw_remove() and virtio_ccw_offline() are
very similar, with the notable exception that offline assumes we are
online() at the moment, while remove() does the same only if it
decides based on vcdev && cdev->online that we are online.


> Shouldn't they
> be serialized under the device lock already? I think we are fine.

AFAICT virtio_ccw_remove() and virtio_ccw_offline() are serialized
against each other under the device lock. And also against
virtio_ccw_online() iff it was initiated via the sysfs, and not via
the auto-online mechanism.

Thus I don't think we are fine at the moment.

> 
> For dasd, I think they also need to deal with the block device
> lifetimes. For virtio-ccw, we are basically a transport that does not
> know about devices further down the chain (that are associated with the
> virtio device, whose lifetime is tied to online/offline processing.) I'd
> presume that the serialization above would be enough.
> 

I don't know about dasd that much. For the reasons stated above, I don't
think the serialization we have right now is entirely sufficient.

Regards,
Halil
