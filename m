Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1DE13A87
	for <lists+kvm@lfdr.de>; Sat,  4 May 2019 16:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfEDODw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 May 2019 10:03:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36346 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726217AbfEDODv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 4 May 2019 10:03:51 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x44E1RO2122516
        for <kvm@vger.kernel.org>; Sat, 4 May 2019 10:03:50 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s94ch6223-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 04 May 2019 10:03:50 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Sat, 4 May 2019 15:03:48 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 4 May 2019 15:03:44 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x44E3gOq59965526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 4 May 2019 14:03:42 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BD2442047;
        Sat,  4 May 2019 14:03:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCA2B42041;
        Sat,  4 May 2019 14:03:41 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.34.191])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  4 May 2019 14:03:41 +0000 (GMT)
Date:   Sat, 4 May 2019 16:03:40 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
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
In-Reply-To: <20190503160421-mutt-send-email-mst@kernel.org>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-2-pasic@linux.ibm.com>
        <20190503111724.70c6ec37.cohuck@redhat.com>
        <20190503160421-mutt-send-email-mst@kernel.org>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050414-0012-0000-0000-0000031841BC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050414-0013-0000-0000-00002150B6D2
Message-Id: <20190504160340.29f17b98.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-04_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905040094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 May 2019 16:04:48 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Fri, May 03, 2019 at 11:17:24AM +0200, Cornelia Huck wrote:
> > On Fri, 26 Apr 2019 20:32:36 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> > 
> > > The commit 2a2d1382fe9d ("virtio: Add improved queue allocation API")
> > > establishes a new way of allocating virtqueues (as a part of the effort
> > > that taught DMA to virtio rings).
> > > 
> > > In the future we will want virtio-ccw to use the DMA API as well.
> > > 
> > > Let us switch from the legacy method of allocating virtqueues to
> > > vring_create_virtqueue() as the first step into that direction.
> > > 
> > > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > > ---
> > >  drivers/s390/virtio/virtio_ccw.c | 30 +++++++++++-------------------
> > >  1 file changed, 11 insertions(+), 19 deletions(-)
> > 
> > Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> > 
> > I'd vote for merging this patch right away for 5.2.
> 
> So which tree is this going through? mine?
> 

Christian, what do you think? If the whole series is supposed to go in
in one go (which I hope it is), via Martin's tree could be the simplest
route IMHO.

Regards,
Halil

