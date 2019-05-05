Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA2713F20
	for <lists+kvm@lfdr.de>; Sun,  5 May 2019 13:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfEELPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 May 2019 07:15:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbfEELPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 May 2019 07:15:33 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1923D300180D;
        Sun,  5 May 2019 11:15:33 +0000 (UTC)
Received: from gondolin (ovpn-204-34.brq.redhat.com [10.40.204.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E64655C6AB;
        Sun,  5 May 2019 11:15:26 +0000 (UTC)
Date:   Sun, 5 May 2019 13:15:23 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
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
Message-ID: <20190505131523.159bec7c.cohuck@redhat.com>
In-Reply-To: <20190504160340.29f17b98.pasic@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-2-pasic@linux.ibm.com>
        <20190503111724.70c6ec37.cohuck@redhat.com>
        <20190503160421-mutt-send-email-mst@kernel.org>
        <20190504160340.29f17b98.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Sun, 05 May 2019 11:15:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 4 May 2019 16:03:40 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Fri, 3 May 2019 16:04:48 -0400
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Fri, May 03, 2019 at 11:17:24AM +0200, Cornelia Huck wrote:  
> > > On Fri, 26 Apr 2019 20:32:36 +0200
> > > Halil Pasic <pasic@linux.ibm.com> wrote:
> > >   
> > > > The commit 2a2d1382fe9d ("virtio: Add improved queue allocation API")
> > > > establishes a new way of allocating virtqueues (as a part of the effort
> > > > that taught DMA to virtio rings).
> > > > 
> > > > In the future we will want virtio-ccw to use the DMA API as well.
> > > > 
> > > > Let us switch from the legacy method of allocating virtqueues to
> > > > vring_create_virtqueue() as the first step into that direction.
> > > > 
> > > > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > > > ---
> > > >  drivers/s390/virtio/virtio_ccw.c | 30 +++++++++++-------------------
> > > >  1 file changed, 11 insertions(+), 19 deletions(-)  
> > > 
> > > Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> > > 
> > > I'd vote for merging this patch right away for 5.2.  
> > 
> > So which tree is this going through? mine?
> >   
> 
> Christian, what do you think? If the whole series is supposed to go in
> in one go (which I hope it is), via Martin's tree could be the simplest
> route IMHO.


The first three patches are virtio(-ccw) only and the those are the ones
that I think are ready to go.

I'm not feeling comfortable going forward with the remainder as it
stands now; waiting for some other folks to give feedback. (They are
touching/interacting with code parts I'm not so familiar with, and lack
of documentation, while not the developers' fault, does not make it
easier.)

Michael, would you like to pick up 1-3 for your tree directly? That
looks like the easiest way.
