Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6E51902B
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 20:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfEIS0L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 9 May 2019 14:26:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726632AbfEIS0L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 May 2019 14:26:11 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x49ILclA121496
        for <kvm@vger.kernel.org>; Thu, 9 May 2019 14:26:10 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2scqnw4f3h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 14:26:09 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 9 May 2019 19:26:07 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 May 2019 19:26:04 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x49IQ32C59441336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 May 2019 18:26:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4E1311C052;
        Thu,  9 May 2019 18:26:02 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1560811C050;
        Thu,  9 May 2019 18:26:02 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.181.188])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 May 2019 18:26:02 +0000 (GMT)
Date:   Thu, 9 May 2019 20:26:00 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
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
Subject: Re: [PATCH 08/10] virtio/s390: add indirection to indicators access
In-Reply-To: <a4bf1976-8037-63bb-2cf6-c389edbd2e89@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-9-pasic@linux.ibm.com>
        <716d47ca-016f-e8f4-6d78-7746a7d9f6ba@linux.ibm.com>
        <a4bf1976-8037-63bb-2cf6-c389edbd2e89@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
x-cbid: 19050918-0028-0000-0000-0000036C075D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050918-0029-0000-0000-0000242B8A0E
Message-Id: <20190509202600.4fd6aebe.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905090105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 May 2019 14:01:01 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 08/05/2019 16:31, Pierre Morel wrote:
> > On 26/04/2019 20:32, Halil Pasic wrote:
> >> This will come in handy soon when we pull out the indicators from
> >> virtio_ccw_device to a memory area that is shared with the hypervisor
> >> (in particular for protected virtualization guests).
> >>
> >> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> >> ---
> >>   drivers/s390/virtio/virtio_ccw.c | 40 
> >> +++++++++++++++++++++++++---------------
> >>   1 file changed, 25 insertions(+), 15 deletions(-)
> >>
> >> diff --git a/drivers/s390/virtio/virtio_ccw.c 
> >> b/drivers/s390/virtio/virtio_ccw.c
> >> index bb7a92316fc8..1f3e7d56924f 100644
> >> --- a/drivers/s390/virtio/virtio_ccw.c
> >> +++ b/drivers/s390/virtio/virtio_ccw.c
> >> @@ -68,6 +68,16 @@ struct virtio_ccw_device {
> >>       void *airq_info;
> >>   };
> >> +static inline unsigned long *indicators(struct virtio_ccw_device *vcdev)
> >> +{
> >> +    return &vcdev->indicators;
> >> +}
> >> +
> >> +static inline unsigned long *indicators2(struct virtio_ccw_device 
> >> *vcdev)
> >> +{
> >> +    return &vcdev->indicators2;
> >> +}
> >> +
> >>   struct vq_info_block_legacy {
> >>       __u64 queue;
> >>       __u32 align;
> >> @@ -337,17 +347,17 @@ static void virtio_ccw_drop_indicator(struct 
> >> virtio_ccw_device *vcdev,
> >>           ccw->cda = (__u32)(unsigned long) thinint_area;
> >>       } else {
> >>           /* payload is the address of the indicators */
> >> -        indicatorp = kmalloc(sizeof(&vcdev->indicators),
> >> +        indicatorp = kmalloc(sizeof(indicators(vcdev)),
> >>                        GFP_DMA | GFP_KERNEL);
> >>           if (!indicatorp)
> >>               return;
> >>           *indicatorp = 0;
> >>           ccw->cmd_code = CCW_CMD_SET_IND;
> >> -        ccw->count = sizeof(&vcdev->indicators);
> >> +        ccw->count = sizeof(indicators(vcdev));
> > 
> > This looks strange to me. Was already weird before.
> > Lucky we are indicators are long...
> > may be just sizeof(long)
> 

I'm not sure I understand where are you coming from...

With CCW_CMD_SET_IND we tell the hypervisor the guest physical address
at which the so called classic indicators. There is a comment that
makes this obvious. The argument of the sizeof was and remained a
pointer type. AFAIU this is what bothers you. 
> 
> AFAIK the size of the indicators (AIV/AIS) is not restricted by the 
> architecture.

The size of vcdev->indicators is restricted or defined by the virtio
specification. Please have a look at '4.3.2.6.1 Setting Up Classic Queue
Indicators' here:
https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-1630002

Since with Linux on s390 only 64 bit is supported, both the sizes are in
line with the specification. Using u64 would semantically match the spec
better, modulo pre virtio 1.0 which ain't specified. I did not want to
do changes that are not necessary for what I'm trying to accomplish. If
we want we can change these to u64 with a patch on top.

> However we never use more than 64 bits, do we ever have an adapter 
> having more than 64 different interrupts?

These are one per queue. The number of queues used to be limited to 64
but it ain't no more. If the driver uses classic notifiers, only the
first 64 can be used.

> 
> May be we can state than we use a maximal number of AISB of 64 and 
> therefor use indicators with a size of unsigned long, or __u64 or 
> whatever is appropriate. Please clear this.
> 

I think you are mixing up adapter interrupts as defined by the
architecture, with virtio indicators which are kind of a special case
at best: the two stage stuff is modeled after AISB and AIBV.  

> With this cleared:

I hope, I managed to clear this up a bit. If not please try to re-state
your concern in different words.

> Reviewed-by: Pierre Morel<pmorel@linux.ibm.com>
> 

Thanks for your review!

Halil
 

