Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379711FC16
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 23:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfEOVI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 17:08:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50832 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726566AbfEOVI5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 May 2019 17:08:57 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4FL3D94000912
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 17:08:56 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sgsq9huee-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 17:08:55 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 15 May 2019 22:08:53 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 22:08:49 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4FL8mis58261712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 21:08:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 169E94C052;
        Wed, 15 May 2019 21:08:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FA2F4C059;
        Wed, 15 May 2019 21:08:47 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.21.52])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 May 2019 21:08:47 +0000 (GMT)
Date:   Wed, 15 May 2019 23:08:17 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     "Jason J. Herne" <jjherne@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 06/10] s390/cio: add basic protected virtualization
 support
In-Reply-To: <d0ffefec-a14e-ee83-0aae-df288c3ffda4@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-7-pasic@linux.ibm.com>
        <20190513114136.783c851c.cohuck@redhat.com>
        <d0ffefec-a14e-ee83-0aae-df288c3ffda4@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051521-0008-0000-0000-000002E71637
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051521-0009-0000-0000-00002253B73F
Message-Id: <20190515230817.2f8a8a5d.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905150128
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 May 2019 10:47:34 -0400
"Jason J. Herne" <jjherne@linux.ibm.com> wrote:

> On 5/13/19 5:41 AM, Cornelia Huck wrote:
> > On Fri, 26 Apr 2019 20:32:41 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> > 
> >> As virtio-ccw devices are channel devices, we need to use the dma area
> >> for any communication with the hypervisor.
> >>
> >> This patch addresses the most basic stuff (mostly what is required for
> >> virtio-ccw), and does take care of QDIO or any devices.
> > 
> > "does not take care of QDIO", surely? (Also, what does "any devices"
> > mean? Do you mean "every arbitrary device", perhaps?)
> > 
> >>
> >> An interesting side effect is that virtio structures are now going to
> >> get allocated in 31 bit addressable storage.
> > 
> > Hm...
> > 
> >>
> >> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> >> ---
> >>   arch/s390/include/asm/ccwdev.h   |  4 +++
> >>   drivers/s390/cio/ccwreq.c        |  8 ++---
> >>   drivers/s390/cio/device.c        | 65 +++++++++++++++++++++++++++++++++-------
> >>   drivers/s390/cio/device_fsm.c    | 40 ++++++++++++-------------
> >>   drivers/s390/cio/device_id.c     | 18 +++++------
> >>   drivers/s390/cio/device_ops.c    | 21 +++++++++++--
> >>   drivers/s390/cio/device_pgid.c   | 20 ++++++-------
> >>   drivers/s390/cio/device_status.c | 24 +++++++--------
> >>   drivers/s390/cio/io_sch.h        | 21 +++++++++----
> >>   drivers/s390/virtio/virtio_ccw.c | 10 -------
> >>   10 files changed, 148 insertions(+), 83 deletions(-)
> > 
> > (...)
> > 
> >> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> >> index 6d989c360f38..bb7a92316fc8 100644
> >> --- a/drivers/s390/virtio/virtio_ccw.c
> >> +++ b/drivers/s390/virtio/virtio_ccw.c
> >> @@ -66,7 +66,6 @@ struct virtio_ccw_device {
> >>   	bool device_lost;
> >>   	unsigned int config_ready;
> >>   	void *airq_info;
> >> -	u64 dma_mask;
> >>   };
> >>   
> >>   struct vq_info_block_legacy {
> >> @@ -1255,16 +1254,7 @@ static int virtio_ccw_online(struct ccw_device *cdev)
> >>   		ret = -ENOMEM;
> >>   		goto out_free;
> >>   	}
> >> -
> >>   	vcdev->vdev.dev.parent = &cdev->dev;
> >> -	cdev->dev.dma_mask = &vcdev->dma_mask;
> >> -	/* we are fine with common virtio infrastructure using 64 bit DMA */
> >> -	ret = dma_set_mask_and_coherent(&cdev->dev, DMA_BIT_MASK(64));
> >> -	if (ret) {
> >> -		dev_warn(&cdev->dev, "Failed to enable 64-bit DMA.\n");
> >> -		goto out_free;
> >> -	}
> > 
> > This means that vring structures now need to fit into 31 bits as well,
> > I think? Is there any way to reserve the 31 bit restriction for channel
> > subsystem structures and keep vring in the full 64 bit range? (Or am I
> > fundamentally misunderstanding something?)
> > 
> 
> I hope I've understood everything... I'm new to virtio. But from what I'm understanding, 
> the vring structure (a.k.a. the VirtQueue) needs to be accessed and modified by both host 
> and guest. Therefore the page(s) holding that data need to be marked shared if using 
> protected virtualization. This patch set makes use of DMA pages by way of swiotlb (always 
> below 32-bit line right?) for shared memory.

The last sentence is wrong. You have to differentiate between stuff that
is mapped as DMA and that is allocated as DMA. The mapped stuff is
handled via swiotlb and bouncing. But that can not work for vring stuff
which needs to be allocated as DMA.

> Therefore, a side effect is that all shared 
> memory, including VirtQueue data will be in the DMA zone and in 32-bit memory.
> 

Consequently wrong. The reason I explained in a reply to Connie (see
there).

> I don't see any restrictions on sharing pages above the 32-bit line. So it seems possible. 
> I'm not sure how much more work it would be. I wonder if Halil has considered this?

I did consider this, the RFC was doing this (again see other mail).

> Are we 
> worried that virtio data structures are going to be a burden on the 31-bit address space?
> 
> 

That is a good question I can not answer. Since it is currently at least
a page per queue (because we use dma direct, right Mimu?), I am concerned
about this.

Connie, what is your opinion?

Regards,
Halil

