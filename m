Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54EA31FBC2
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 22:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfEOUwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 16:52:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726170AbfEOUwm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 May 2019 16:52:42 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4FKg68I095987
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 16:52:40 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sgr4vds4p-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 16:52:40 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 15 May 2019 21:52:38 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 21:52:35 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4FKqYUb42860690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 20:52:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27CA84C058;
        Wed, 15 May 2019 20:52:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 602F04C04E;
        Wed, 15 May 2019 20:52:33 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.21.52])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 May 2019 20:52:33 +0000 (GMT)
Date:   Wed, 15 May 2019 22:51:58 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
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
In-Reply-To: <20190513114136.783c851c.cohuck@redhat.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-7-pasic@linux.ibm.com>
        <20190513114136.783c851c.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051520-0008-0000-0000-000002E7156C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051520-0009-0000-0000-00002253B66C
Message-Id: <20190515225158.301af387.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905150126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 May 2019 11:41:36 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Fri, 26 Apr 2019 20:32:41 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > As virtio-ccw devices are channel devices, we need to use the dma area
> > for any communication with the hypervisor.
> > 
> > This patch addresses the most basic stuff (mostly what is required for
> > virtio-ccw), and does take care of QDIO or any devices.
> 
> "does not take care of QDIO", surely? 

I did not bother making the QDIO library code use dma memory for
anything that is conceptually dma memory. AFAIK QDIO is out of scope for
prot virt for now. If one were to do some emulated qdio with prot virt
guests, one wound need to make a bunch of things shared.

> (Also, what does "any devices"
> mean? Do you mean "every arbitrary device", perhaps?)

What I mean is: this patch takes care of the core stuff, but any
particular device is likely to have to do more -- that is it ain't all
the cio devices support prot virt with this patch. For example
virtio-ccw needs to make sure that the ccws constituting the channel
programs, as well as the data pointed by the ccws is shared. If one
would want to make vfio-ccw DASD pass-through work under prot virt, one
would need to make sure, that everything that needs to be shared is
shared (data buffers, channel programs).

Does is clarify things?

> 
> > 
> > An interesting side effect is that virtio structures are now going to
> > get allocated in 31 bit addressable storage.
> 
> Hm...
> 
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > ---
> >  arch/s390/include/asm/ccwdev.h   |  4 +++
> >  drivers/s390/cio/ccwreq.c        |  8 ++---
> >  drivers/s390/cio/device.c        | 65 +++++++++++++++++++++++++++++++++-------
> >  drivers/s390/cio/device_fsm.c    | 40 ++++++++++++-------------
> >  drivers/s390/cio/device_id.c     | 18 +++++------
> >  drivers/s390/cio/device_ops.c    | 21 +++++++++++--
> >  drivers/s390/cio/device_pgid.c   | 20 ++++++-------
> >  drivers/s390/cio/device_status.c | 24 +++++++--------
> >  drivers/s390/cio/io_sch.h        | 21 +++++++++----
> >  drivers/s390/virtio/virtio_ccw.c | 10 -------
> >  10 files changed, 148 insertions(+), 83 deletions(-)
> 
> (...)
> 
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> > index 6d989c360f38..bb7a92316fc8 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -66,7 +66,6 @@ struct virtio_ccw_device {
> >  	bool device_lost;
> >  	unsigned int config_ready;
> >  	void *airq_info;
> > -	u64 dma_mask;
> >  };
> >  
> >  struct vq_info_block_legacy {
> > @@ -1255,16 +1254,7 @@ static int virtio_ccw_online(struct ccw_device *cdev)
> >  		ret = -ENOMEM;
> >  		goto out_free;
> >  	}
> > -
> >  	vcdev->vdev.dev.parent = &cdev->dev;
> > -	cdev->dev.dma_mask = &vcdev->dma_mask;
> > -	/* we are fine with common virtio infrastructure using 64 bit DMA */
> > -	ret = dma_set_mask_and_coherent(&cdev->dev, DMA_BIT_MASK(64));
> > -	if (ret) {
> > -		dev_warn(&cdev->dev, "Failed to enable 64-bit DMA.\n");
> > -		goto out_free;
> > -	}
> 
> This means that vring structures now need to fit into 31 bits as well,
> I think?

Nod.

> Is there any way to reserve the 31 bit restriction for channel
> subsystem structures and keep vring in the full 64 bit range? (Or am I
> fundamentally misunderstanding something?)
> 

At the root of this problem is that the DMA API basically says devices
may have addressing limitations expressed by the dma_mask, while our
addressing limitations are not coming from the device but from the IO
arch: e.g. orb.cpa and ccw.cda are 31 bit addresses. In our case it
depends on how and for what is the device going to use the memory (e.g.
buffers addressed by MIDA vs IDA vs direct).

Virtio uses the DMA properties of the parent, that is in our case the
struct device embedded in struct ccw_device.

The previous version (RFC) used to allocate all the cio DMA stuff from
this global cio_dma_pool using the css0.dev for the DMA API
interactions. And we set *css0.dev.dma_mask == DMA_BIT_MASK(31) so
e.g. the allocated ccws are 31 bit addressable.

But I was asked to change this so that when I allocate DMA memory for a
channel program of particular ccw device, a struct device of that ccw
device is used as the first argument of dma_alloc_coherent().

Considering

void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
                gfp_t flag, unsigned long attrs)
{
        const struct dma_map_ops *ops = get_dma_ops(dev);
        void *cpu_addr;

        WARN_ON_ONCE(dev && !dev->coherent_dma_mask);

        if (dma_alloc_from_dev_coherent(dev, size, dma_handle, &cpu_addr))
                return cpu_addr;

        /* let the implementation decide on the zone to allocate from: */
        flag &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);

that is the GFP flags dropped that implies that we really want
cdev->dev restricted to 31 bit addressable memory because we can't tell
(with the current common DMA code) hey but this piece of DMA mem you
are abot to allocate for me must be 31 bit addressable (using GFP_DMA
as we usually do).

So, as described in the commit message, the vring stuff being forced
into ZONE_DMA is an unfortunate consequence of this all.

A side note: making the subchannel device 'own' the DMA stuff of a ccw
device (something that was discussed in the RFC thread) is tricky
because the ccw device may outlive the subchannel (all that orphan
stuff).

So the answer is: it is technically possible (e.g. see RFC) but it comes
at a price, and I see no obviously brilliant solution.

Regards,
Halil

> > -
> >  	vcdev->config_block = kzalloc(sizeof(*vcdev->config_block),
> >  				   GFP_DMA | GFP_KERNEL);
> >  	if (!vcdev->config_block) {
> 

