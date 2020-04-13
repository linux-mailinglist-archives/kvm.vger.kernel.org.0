Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D331A685B
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 16:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730875AbgDMOuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 10:50:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42919 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730872AbgDMOus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 10:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586789447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kr9KTKBU+/+uofMSqlPA49Feo8xCOB4FV94CTTUBStM=;
        b=gIgeNYN3UEVzJvuC/tn2pX9HmzUjMegOtGjyQy6THwv07nqGRNmVqaLwIWXafZCoH28JIc
        YtHOU7Tx8Xq6+pm/mDbRKgH+XRCk/58dLLA/kpbAZ90DeOn3EUDwo9UuqyOzoMYVEdhyuT
        ryXcF/7djImlKcclQrBc1Apm/WRfyfY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-BRnJnPTaOCOVYIXGMQOkvQ-1; Mon, 13 Apr 2020 10:50:43 -0400
X-MC-Unique: BRnJnPTaOCOVYIXGMQOkvQ-1
Received: by mail-qt1-f198.google.com with SMTP id g14so6710261qts.7
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 07:50:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kr9KTKBU+/+uofMSqlPA49Feo8xCOB4FV94CTTUBStM=;
        b=B8f7/lDz88AQLINf2xMx1FQdWSfjAK9PtNNt9E14PI+erxB8rpNtJNEZ6QrZyQonE9
         zpIC2dIf4sbqL0qVTOBLU1bRE18Ux2fkJzzD7OU9AE0Z/2+0+h5aaWYJLcbJbUSTOj3b
         trJ33q1hp+UwVOqWfi0w0Yf5ADWDJIqO6OTTPiazd6CWiMcn+Y3FqYa8fLWkPTXyrJ/J
         +kDAOT9XR45DliNq4lbNIUnbdA3bVSqjgz+4VOTimvD01rIo0qNX7LgSkIWAMhQjNMlc
         zVvos0yl2hWyXvaZQlFWzAHQ1BBRtVIgv3NJNuFZ5Swz9EZqUvSbvlVPauaJv0NuMSqd
         VbeQ==
X-Gm-Message-State: AGi0PuYBeeZlLf8t6oIIK2clSZXRv4kWydSLtNqZ0maG15C/SZD1Z58N
        Pqz4L+BfzZBQ4l4NGux/D3Z6OoKfuXiZG3duXHU1IbcfQWWkLqsYUFolE9z1KXffK2hGgt9Hqrb
        4xFjOV87nBnOqpBt4RxzTyDyVbTc2
X-Received: by 2002:a37:a090:: with SMTP id j138mr17159946qke.168.1586789443340;
        Mon, 13 Apr 2020 07:50:43 -0700 (PDT)
X-Google-Smtp-Source: APiQypIS1bM7/cnw0/cmr0zxcGu/p79bSOTSNpyLGH30P81IUc3vIXTO+mjh49kiiytoU5bQ/OGlrY1RcCqeUjyOqso=
X-Received: by 2002:a37:a090:: with SMTP id j138mr17159916qke.168.1586789443027;
 Mon, 13 Apr 2020 07:50:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200403165119.5030-1-eperezma@redhat.com> <20200413071044-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200413071044-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 13 Apr 2020 16:50:06 +0200
Message-ID: <CAJaqyWcOmzxfOodudSjrZa1SeYDZKiO3MFMy_w44cL_eaBhYDA@mail.gmail.com>
Subject: Re: [PATCH 0/8] tools/vhost: Reset virtqueue on tests
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 13, 2020 at 1:13 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Apr 03, 2020 at 06:51:11PM +0200, Eugenio P=C3=A9rez wrote:
> > This series add the tests used to validate the "vhost: Reset batched
> > descriptors on SET_VRING_BASE call" series, with a small change on the
> > reset code (delete an extra unneded reset on VHOST_SET_VRING_BASE).
> >
> > They are based on the tests sent back them, the ones that were not
> > included (reasons in that thread). This series changes:
> >
> > * Delete need to export the ugly function in virtio_ring, now all the
> > code is added in tools/virtio (except the one line fix).
> > * Add forgotten uses of vhost_vq_set_backend. Fix bad usage order in
> > vhost_test_set_backend.
> > * Drop random reset, not really needed.
> > * Minor changes updating tests code.
> >
> > This serie is meant to be applied on top of
> > 5de4e0b7068337cf0d4ca48a4011746410115aae in
> > git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git.
>
> Is this still needed?

("tools/virtio: fix virtio_test.c") indentation is actually cosmetic.
("vhost: Not cleaning batched descs in VHOST_SET_VRING_BASE ioctl")
just avoid to clean batches descriptors for a third time (they are
cleaned on backend removal and addition).

("vhost: Fix bad order in vhost_test_set_backend at enable") is
actually a fix, the test does not work properly without it. And
("tools/virtio: Reset index in virtio_test --reset.") Makes the test
work more similar than the actual VM does in a reset.

("tools/virtio: Use __vring_new_virtqueue in virtio_test.c") and
("tools/virtio: Extract virtqueue initialization in vq_reset") are
convenience commits to reach the previous two.

Lastly, ("tools/virtio: Use tools/include/list.h instead of stubs")
just removes stub code, I did it when I try to test vdpa code and it
seems to me a nice to have, but we can drop it from the patchset if
you don't see that way.

> The patches lack Signed-off-by and
> commit log descriptions, reference commit Ids without subject.
> See Documentation/process/submitting-patches.rst
>

Sorry, I will try to keep an eye on that from now on. I will send a v2
with Signed-off-by and extended descriptions if you see it ok.

Thanks!

> > Eugenio P=C3=A9rez (8):
> >   tools/virtio: fix virtio_test.c indentation
> >   vhost: Not cleaning batched descs in VHOST_SET_VRING_BASE ioctl
> >   vhost: Replace vq->private_data access by backend accesors
> >   vhost: Fix bad order in vhost_test_set_backend at enable
> >   tools/virtio: Use __vring_new_virtqueue in virtio_test.c
> >   tools/virtio: Extract virtqueue initialization in vq_reset
> >   tools/virtio: Reset index in virtio_test --reset.
> >   tools/virtio: Use tools/include/list.h instead of stubs
> >
> >  drivers/vhost/test.c        |  8 ++---
> >  drivers/vhost/vhost.c       |  1 -
> >  tools/virtio/linux/kernel.h |  7 +----
> >  tools/virtio/linux/virtio.h |  5 ++--
> >  tools/virtio/virtio_test.c  | 58 +++++++++++++++++++++++++++----------
> >  tools/virtio/vringh_test.c  |  2 ++
> >  6 files changed, 51 insertions(+), 30 deletions(-)
> >
> > --
> > 2.18.1
>

