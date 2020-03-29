Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0E2196D3E
	for <lists+kvm@lfdr.de>; Sun, 29 Mar 2020 14:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgC2MUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 08:20:38 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:56820 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727916AbgC2MUi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Mar 2020 08:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585484436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JV+swSpDvLiRyfF8zduIYF+N/77uMAWPzm2YG1hsv6E=;
        b=a2lGXucnr0oYXe/l1KoX6tzXbtnoB/ZFJnr4tTK1ALU2MJ7JwsCTDFk8AjMLYuXgseW+rl
        PygIBWN7fUwuaLIY+3eelsoB2lt/JOzBRFYv/Wif5nK8M79YX9b2KFZ7ctHV0jchl7GcxY
        rmvlQKp8RXB0GlqsKE/EDRRDwaVpFw4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-XAVRrrJpPHqfVCZtho3A4Q-1; Sun, 29 Mar 2020 08:20:32 -0400
X-MC-Unique: XAVRrrJpPHqfVCZtho3A4Q-1
Received: by mail-qt1-f200.google.com with SMTP id x3so12428192qtv.10
        for <kvm@vger.kernel.org>; Sun, 29 Mar 2020 05:20:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JV+swSpDvLiRyfF8zduIYF+N/77uMAWPzm2YG1hsv6E=;
        b=WR13NAqez9sMXofPKpvHwmHcr38K0BTlMJljVRrsi3Okvp/kE6qlHwCJxwUb2X1JCg
         bgMtr5KV5QK4v2avV2UPV0J/oGpuyh+vKx9pwCGtfjJMOttglHzw3Y06QYG7ueM0ckwm
         hb61FB6ZDeEaIzIFgDIwpY1LbaAHx8I0Roh/jqXcWLxSyuNXekjLi65oDdPrd7EVA+cO
         GPfV2nd6pz8Nm8TE/9mc5cBy8r5i7AOocQePUUYO3lsjYuB2uROC7C1z/Btx+lZozld3
         +d5zJPcOzYONpQML6UOxvvXn0Dso+aq/WW3Svisgo+lFmO5gK29KwP3GMrDeUgaPvJRC
         wDfg==
X-Gm-Message-State: ANhLgQ3Ta4JIlx8DQAzqXzD6UrZq0BxnGWOztKT1yWLAngUiGc85ax3R
        JYXJxTrLknIV7Bp+OK2qGxtTSPir2IGETnHl45wpIAjvOFQ9EbbMuCnt79HXTyvtbvSuLccfhYR
        d7NdD/7pOab5Sv3Kvq87ch8nqKG3z
X-Received: by 2002:a37:648:: with SMTP id 69mr7654543qkg.353.1585484432326;
        Sun, 29 Mar 2020 05:20:32 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtuKBV3ksCZe4Rr2ouEcNs/zf3hutRMu9QCFjAIZrqsuNifj5DJq+Vsezn48JCHiYyh/9SYn2/cqGNyipdDUvA=
X-Received: by 2002:a37:648:: with SMTP id 69mr7654519qkg.353.1585484432049;
 Sun, 29 Mar 2020 05:20:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200329113359.30960-1-eperezma@redhat.com> <20200329074023-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200329074023-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Sun, 29 Mar 2020 14:19:55 +0200
Message-ID: <CAJaqyWdO8CHuWFJv+TRgYJ7a3Cb06Ln3prnQZs69L1PPw4Rj1Q@mail.gmail.com>
Subject: Re: [PATCH 0/6] vhost: Reset batched descriptors on SET_VRING_BASE call
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 29, 2020 at 1:49 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Sun, Mar 29, 2020 at 01:33:53PM +0200, Eugenio P=C3=A9rez wrote:
> > Vhost did not reset properly the batched descriptors on SET_VRING_BASE =
event. Because of that, is possible to return an invalid descriptor to the =
guest.
> > This series ammend this, and creates a test to assert correct behavior.=
 To do that, they need to expose a new function in virtio_ring, virtqueue_r=
eset_free_head. Not sure if this can be avoided.
>
> Question: why not reset the batch when private_data changes?
> At the moment both net and scsi poke at private data directly,
> if they do this through a wrapper we can use that to
> 1. check that vq mutex is taken properly
> 2. reset batching
>
> This seems like a slightly better API
>

I didn't do that way because qemu could just SET_BACKEND to -1 and
SET_BACKEND to the same one, with no call to SET_VRING. In this case,
I think that qemu should not change the descriptors already pushed. I
do agree with the interface to modify private_data properly (regarding
the mutex).

However, I can see how your proposal is safer, so we don't even need
to check if private_data is !=3D NULL when we have descriptors in the
batch_descs array. Also, this ioctls should not be in the hot path, so
we can change to that mode anyway.

> >
> > Also, change from https://lkml.org/lkml/2020/3/27/108 is not included, =
that avoids to update a variable in a loop where it can be updated once.
> >
> > This is meant to be applied on top of eccb852f1fe6bede630e2e4f1a121a81e=
34354ab in git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git, and some =
commits should be squashed with that series.
>
> Thanks a lot! I'll apply this for now so Christian can start testing,
> but I'd like the comment above addressed before I push this to Linus.
>
> > Eugenio P=C3=A9rez (6):
> >   tools/virtio: Add --batch option
> >   tools/virtio: Add --batch=3Drandom option
> >   tools/virtio: Add --reset=3Drandom
> >   tools/virtio: Make --reset reset ring idx
> >   vhost: Delete virtqueue batch_descs member
> >   fixup! vhost: batching fetches
> >
> >  drivers/vhost/test.c         |  57 ++++++++++++++++
> >  drivers/vhost/test.h         |   1 +
> >  drivers/vhost/vhost.c        |  12 +++-
> >  drivers/vhost/vhost.h        |   1 -
> >  drivers/virtio/virtio_ring.c |  18 +++++
> >  include/linux/virtio.h       |   2 +
> >  tools/virtio/linux/virtio.h  |   2 +
> >  tools/virtio/virtio_test.c   | 123 +++++++++++++++++++++++++++++++----
> >  8 files changed, 201 insertions(+), 15 deletions(-)
> >
> > --
> > 2.18.1
>

