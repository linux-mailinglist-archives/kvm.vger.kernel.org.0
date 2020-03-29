Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65543196D46
	for <lists+kvm@lfdr.de>; Sun, 29 Mar 2020 14:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgC2MZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 08:25:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:33980 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727998AbgC2MZN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Mar 2020 08:25:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585484712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7vKFOd347o9WoHxHI6B5j1Zjim146jeGZmfmqH7fBaE=;
        b=VHUz0MaS4vNfPH/0cf3Zf+xwu5h5sHffUwCSz0zS8j0A333VSbvBkh+hV+phUmhOyoRAxJ
        pNoJ+h/8MkpqRgeZfUFfJCLw0I4zWZi2ikLj+inNBjpba1JmErmu7Up7Ojaf1fo03fa8LU
        neMk6zH/1A0wjNvjjeARfeaFcCYywO0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-5IwTlZGXO-ieEFy7gFxOKQ-1; Sun, 29 Mar 2020 08:25:10 -0400
X-MC-Unique: 5IwTlZGXO-ieEFy7gFxOKQ-1
Received: by mail-wr1-f71.google.com with SMTP id c8so6505003wru.20
        for <kvm@vger.kernel.org>; Sun, 29 Mar 2020 05:25:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7vKFOd347o9WoHxHI6B5j1Zjim146jeGZmfmqH7fBaE=;
        b=NmlsUhuN70U3NfA4QnScxvSkbjgwbt7fi5xUpCgmbHWcnAY9QJdek7OsmCFdpQyyZL
         hL/zLp26w+nZ4IerLdVqxMUOtZm591HCLgdAzMikHnK577+OFxcHaxlmV7t++gKOHMnR
         yQY6ILA6I5DAvjrhgC8KPZE2pNRjI8WNMgMRFAt1rvhLKKcljNQgprkQrIlJyYm6Jvie
         CQoTRFyyUjTTSQo3/PYIBtm05tDkUyPUgnIht4b4URIxGyWoVWVFZUGPnIUBNWPVZzLM
         FXVPqYd4BrWP1umI9BZt/AQDOYyp0bTJiUhy49wqLITGiioXvCSMJTtc0zZuFYXQjr6A
         S4Sg==
X-Gm-Message-State: ANhLgQ1BAryasl9qStz27XfZf28Wx3b3dzsl55jwuJZYw5ooNiPOwOf4
        7QXYmJJVjm2BVoZv5CBgMT++kT3gp+6ID9yOzhpGIaQVUYzdSgT/T332wkn83nORRs7pa3oh4i7
        OTsjlbCTxDjvb
X-Received: by 2002:adf:e942:: with SMTP id m2mr9560596wrn.364.1585484709181;
        Sun, 29 Mar 2020 05:25:09 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuHbrAQAMGspN3vkSyUCV4rlxQ2qSDmnNPRnKfein9CsAMF+8qjUPe34LCmI1NXow9ZnUY3qA==
X-Received: by 2002:adf:e942:: with SMTP id m2mr9560582wrn.364.1585484708917;
        Sun, 29 Mar 2020 05:25:08 -0700 (PDT)
Received: from redhat.com (bzq-79-183-139-129.red.bezeqint.net. [79.183.139.129])
        by smtp.gmail.com with ESMTPSA id z129sm16715180wmb.7.2020.03.29.05.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 05:25:08 -0700 (PDT)
Date:   Sun, 29 Mar 2020 08:25:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] vhost: Reset batched descriptors on SET_VRING_BASE
 call
Message-ID: <20200329082055-mutt-send-email-mst@kernel.org>
References: <20200329113359.30960-1-eperezma@redhat.com>
 <20200329074023-mutt-send-email-mst@kernel.org>
 <CAJaqyWdO8CHuWFJv+TRgYJ7a3Cb06Ln3prnQZs69L1PPw4Rj1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWdO8CHuWFJv+TRgYJ7a3Cb06Ln3prnQZs69L1PPw4Rj1Q@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 29, 2020 at 02:19:55PM +0200, Eugenio Perez Martin wrote:
> On Sun, Mar 29, 2020 at 1:49 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Sun, Mar 29, 2020 at 01:33:53PM +0200, Eugenio Pérez wrote:
> > > Vhost did not reset properly the batched descriptors on SET_VRING_BASE event. Because of that, is possible to return an invalid descriptor to the guest.
> > > This series ammend this, and creates a test to assert correct behavior. To do that, they need to expose a new function in virtio_ring, virtqueue_reset_free_head. Not sure if this can be avoided.
> >
> > Question: why not reset the batch when private_data changes?
> > At the moment both net and scsi poke at private data directly,
> > if they do this through a wrapper we can use that to
> > 1. check that vq mutex is taken properly
> > 2. reset batching
> >
> > This seems like a slightly better API
> >
> 
> I didn't do that way because qemu could just SET_BACKEND to -1 and
> SET_BACKEND to the same one, with no call to SET_VRING. In this case,
> I think that qemu should not change the descriptors already pushed.

Well dropping the batch is always safe, batch is an optimization.


> I
> do agree with the interface to modify private_data properly (regarding
> the mutex).
> 
> However, I can see how your proposal is safer, so we don't even need
> to check if private_data is != NULL when we have descriptors in the
> batch_descs array. Also, this ioctls should not be in the hot path, so
> we can change to that mode anyway.
> 
> > >
> > > Also, change from https://lkml.org/lkml/2020/3/27/108 is not included, that avoids to update a variable in a loop where it can be updated once.
> > >
> > > This is meant to be applied on top of eccb852f1fe6bede630e2e4f1a121a81e34354ab in git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git, and some commits should be squashed with that series.
> >
> > Thanks a lot! I'll apply this for now so Christian can start testing,
> > but I'd like the comment above addressed before I push this to Linus.
> >
> > > Eugenio Pérez (6):
> > >   tools/virtio: Add --batch option
> > >   tools/virtio: Add --batch=random option
> > >   tools/virtio: Add --reset=random
> > >   tools/virtio: Make --reset reset ring idx
> > >   vhost: Delete virtqueue batch_descs member
> > >   fixup! vhost: batching fetches
> > >
> > >  drivers/vhost/test.c         |  57 ++++++++++++++++
> > >  drivers/vhost/test.h         |   1 +
> > >  drivers/vhost/vhost.c        |  12 +++-
> > >  drivers/vhost/vhost.h        |   1 -
> > >  drivers/virtio/virtio_ring.c |  18 +++++
> > >  include/linux/virtio.h       |   2 +
> > >  tools/virtio/linux/virtio.h  |   2 +
> > >  tools/virtio/virtio_test.c   | 123 +++++++++++++++++++++++++++++++----
> > >  8 files changed, 201 insertions(+), 15 deletions(-)
> > >
> > > --
> > > 2.18.1
> >

