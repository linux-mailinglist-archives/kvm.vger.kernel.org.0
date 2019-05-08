Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B64180DC
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 22:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfEHUNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 16:13:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727548AbfEHUNK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 16:13:10 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48KCwLm112526
        for <kvm@vger.kernel.org>; Wed, 8 May 2019 16:13:09 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sc50ctm5h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 16:13:09 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 8 May 2019 21:13:07 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 21:13:03 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48KD1qK53215336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 20:13:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74DE352052;
        Wed,  8 May 2019 20:13:01 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.71.200])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1B1315204F;
        Wed,  8 May 2019 20:13:00 +0000 (GMT)
Date:   Wed, 8 May 2019 22:12:58 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 01/10] virtio/s390: use vring_create_virtqueue
In-Reply-To: <ed6cbf63-f2ff-f259-ccb0-3b9ba60f2b35@de.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-2-pasic@linux.ibm.com>
        <20190503111724.70c6ec37.cohuck@redhat.com>
        <20190503160421-mutt-send-email-mst@kernel.org>
        <20190504160340.29f17b98.pasic@linux.ibm.com>
        <20190505131523.159bec7c.cohuck@redhat.com>
        <ed6cbf63-f2ff-f259-ccb0-3b9ba60f2b35@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050820-0008-0000-0000-000002E4A635
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050820-0009-0000-0000-000022512922
Message-Id: <20190508221258.6db20c81.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 May 2019 15:58:12 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> 
> 
> On 05.05.19 13:15, Cornelia Huck wrote:
> > On Sat, 4 May 2019 16:03:40 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> > 
> >> On Fri, 3 May 2019 16:04:48 -0400
> >> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >>
> >>> On Fri, May 03, 2019 at 11:17:24AM +0200, Cornelia Huck wrote:  
> >>>> On Fri, 26 Apr 2019 20:32:36 +0200
> >>>> Halil Pasic <pasic@linux.ibm.com> wrote:
> >>>>   
> >>>>> The commit 2a2d1382fe9d ("virtio: Add improved queue allocation API")
> >>>>> establishes a new way of allocating virtqueues (as a part of the effort
> >>>>> that taught DMA to virtio rings).
> >>>>>
> >>>>> In the future we will want virtio-ccw to use the DMA API as well.
> >>>>>
> >>>>> Let us switch from the legacy method of allocating virtqueues to
> >>>>> vring_create_virtqueue() as the first step into that direction.
> >>>>>
> >>>>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> >>>>> ---
> >>>>>  drivers/s390/virtio/virtio_ccw.c | 30 +++++++++++-------------------
> >>>>>  1 file changed, 11 insertions(+), 19 deletions(-)  
> >>>>
> >>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> >>>>
> >>>> I'd vote for merging this patch right away for 5.2.  
> >>>
> >>> So which tree is this going through? mine?
> >>>   
> >>
> >> Christian, what do you think? If the whole series is supposed to go in
> >> in one go (which I hope it is), via Martin's tree could be the simplest
> >> route IMHO.
> > 
> > 
> > The first three patches are virtio(-ccw) only and the those are the ones
> > that I think are ready to go.
> > 
> > I'm not feeling comfortable going forward with the remainder as it
> > stands now; waiting for some other folks to give feedback. (They are
> > touching/interacting with code parts I'm not so familiar with, and lack
> > of documentation, while not the developers' fault, does not make it
> > easier.)
> > 
> > Michael, would you like to pick up 1-3 for your tree directly? That
> > looks like the easiest way.
> 
> Agreed. Michael please pick 1-3.
> We will continue to review 4- first and then see which tree is best.

Thanks Christian!

Guys, I broke my right arm on last Thursday (2nd may). You may
have noticed that I was not as responsive as I'm supposed to be.
Unfortunately this less than responsiveness is about to persist for a
couple more weeks. Fortunate the guys from IBM, and chiefly Michael
Mueller is going to help me drive this -- thanks Michael! Due to this,
I would generally prefer doing as few changes to this series as
necessary, and deferring as many of the beautifying to patches on top
(possibly authored by somebody else) as possible.

Regards,
Halil

