Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F774115B7
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239571AbhITN3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:29:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236329AbhITN3W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:29:22 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD7wN024097;
        Mon, 20 Sep 2021 09:27:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=U7cmcijDA1vNzgXHEI3npVm3DS1EdsroG6ZTmXPrYJY=;
 b=RJ6jIXbk/+7kl5zb/i4F2MDCokka5vKNUjVo6y42PcZYg+5YVtBzr6eOwpzGk0yui8Bu
 H6ELeQfQGXzsY1D75vELW8ufqhfBHpUfs2KXY3jIhrQYCLXeBbfHXHkN3gGrukwskch6
 StDpJko7PCLVlS6sTQdb9iIkGXOLeK+P8vfFnOq2jQFQe+Jz7BHHQRjtfOd5y3bQMiUo
 IAKX0KcwHfxmytkQVvQqIiXaxbzl521gk+CLAnpXg6xHYe3ivN3SZtg53Dwvnu8WqHVe
 h5Roun6Kcvdypyj54bKqN2oiGTaf/vemDjQR3bzFpltL1/Ep2HtKzsiYtaAMEz+y0sDr Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w69a0a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:27:54 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KDDKRj027950;
        Mon, 20 Sep 2021 09:27:54 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w69a09a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:27:54 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD6nJ031008;
        Mon, 20 Sep 2021 13:27:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3b57cj87jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 13:27:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KDN5d561866464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 13:23:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CB7342041;
        Mon, 20 Sep 2021 13:27:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E3C24204D;
        Mon, 20 Sep 2021 13:27:47 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.4.199])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 20 Sep 2021 13:27:47 +0000 (GMT)
Date:   Mon, 20 Sep 2021 15:27:44 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfu@redhat.com,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio/s390: fix vritio-ccw device teardown
Message-ID: <20210920152744.55af1201.pasic@linux.ibm.com>
In-Reply-To: <875yuvh73k.fsf@redhat.com>
References: <20210915215742.1793314-1-pasic@linux.ibm.com>
        <87pmt8hp5o.fsf@redhat.com>
        <20210916151835.4ab512b2.pasic@linux.ibm.com>
        <87mtobh9xn.fsf@redhat.com>
        <20210920003935.1369f9fe.pasic@linux.ibm.com>
        <875yuvh73k.fsf@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4eHUpD-siLTy7unl_x02mAm-wE0tsff9
X-Proofpoint-ORIG-GUID: FPpECGWfhLUor-LoVx62bmLIqey1yVpV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0 clxscore=1015
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Sep 2021 12:30:39 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Mon, Sep 20 2021, Halil Pasic <pasic@linux.ibm.com> wrote:
[..]
> 
> Basically, the vcdev is supposed to be around while the ccw device is
> online (with a tail end until references have been given up, of course.)
> It embeds a virtio device that has the ccw device as a parent, which
> will give us a reference on the ccw device as long as the virtio device
> is alive. Any interactions with the ccw device (except freeing the dma
> buffer) are limited to the time where we still have a reference to it
> via the virtio device.
>

I didn't remember that device_add() takes a reference to the parent, and
that device_del() before device_put(dev) and remove callback.


> >  
> >>   
> >> > So my intuition tells me that
> >> > drivers should manage explicitly. Yes virtio_ccw happens to have dma
> >> > memory whose lifetime is more or less the lifetime of struct virtio_ccw,
> >> > but that may not be always the case.    
> >> 
> >> I'm not sure what you're getting at here. Regardless of the lifetime of
> >> the dma memory, it depends on the presence of the ccw device to which it
> >> is tied. This means that the ccw device must not be released while the
> >> dma memory is alive. We can use the approach in your patch here due to
> >> the lifetime of the dma memory that virtio-ccw allocates when we start
> >> using the device and frees when we stop using the device, or we can use
> >> get/put with every allocate/release dma memory pair, which should be
> >> safe for everyone?
> >>   
> >
> > What I mean is that ccw_device_dma_[zalloc,free]() take a pointer to the
> > ccw_device. If we get/put in those we can ensure that, provided the
> > alloc and the free calls are properly paired, the device will be still
> > alive (and the pointer valid) for the free, if it was valid for the
> > alloc. But it does not ensure that each and every call to alloc is with
> > a valid pointer, or that other uses of the pointer are OK. So I don't
> > think it is completely safe for everyone, because we could try to use
> > a pointer to a ccw device when not having any dma memory allocated from
> > its pool.  
> 
> But the problem is the dma memory, right? Also, it is the same issue for
> any potential caller of the ccw_device_dma_* interfaces.

I tend to agree, my argument was based on the assumption that we did not
use to take a reference to the ccw device in virtio_ccw_online(), but we
do via register_virtio_device(). This reference however gets dropped
right before virtio_ccw_release_dev() is called.
> 
> >
> > This patch takes reference to cdev before the pointer is published via
> > vcdev->cdev and drops the reference after *vcdev is freed. The idea is
> > that the pointee basically outlives the pointer. (Without having a full
> > understanding of how things are synchronized).  
> 
> I don't think we have to care about accessing ->cdev (see above.) Plus,
> as we give up the dma memory at the very last point, we would also give
> up the reference via that memory at the very last point, so I'm not sure
> what additional problems could come up.

I understand now. Let me think about it some more. I'm wonderning about
leafs. Will come back at you shortly.

Regards,
Halil
