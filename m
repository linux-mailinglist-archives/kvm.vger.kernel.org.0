Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88ED1AD6D1
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 09:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgDQHEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 03:04:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50403 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728327AbgDQHEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 03:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587107083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9GSTWfCb5EE/NSDaeZnWXhb9iMAdwIiOPhmKGByClik=;
        b=SfsHOjbVcJzTEbVVQm/MO4DdlBs74a01tu2h6Q1MQ+iY7NECF3IJqr9wUXHxHETbP/PBk1
        xVfPfKLMCYdvAlWB+rhy3xnolXrqqOoB1B8eCcFVhPW2qz826ZEKXTlACLjOzKo+fA5z0h
        1/FrQZwYnC2KE+Jfg/j09QsaOXy36iY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-K46RB1jZMOiQ8U2M7mh9sQ-1; Fri, 17 Apr 2020 03:04:41 -0400
X-MC-Unique: K46RB1jZMOiQ8U2M7mh9sQ-1
Received: by mail-qv1-f69.google.com with SMTP id y18so1443494qvx.1
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 00:04:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9GSTWfCb5EE/NSDaeZnWXhb9iMAdwIiOPhmKGByClik=;
        b=mjH+eukK35cJfVzvkHNTgMal5Y4eRPmEArUcQvRp1rIDzpTBk7h0ERVXXd9YmjADus
         NHYVQmA0MhQMZavLkdMiTkO5FWinFFtykt7xOKMF53yb0t34fT1lVZZdNTyE5IkcIye5
         BtPmYLBrlwmRR2eD/3yIskqCMWdijZ2dk8IIFMqIzhu8pkA17YsnJGqEirirnX58zIsN
         FVLdkPoqiNgsMBL08tMQlqNCLUfIRgWm9ifUtDQ1MJmXwUHYWZ7pNC7WuODt0prG10sH
         3NH/udcLnB9Gzl4HelQkBYSg3f4bR9IHkTw88RfrP0wSgbslU+m1ZFgkrbU0O3fWOF/7
         K1Wg==
X-Gm-Message-State: AGi0Pub7JbfZimtS+HGY/gkeFRhqdQa4OBIChbHf7Pqg0cjgMU9t5Jmw
        RYGVfCHkEXKkHpjMzxbhAhne2e/IrUh2N0PSLpyBXKvlj7SE6yIWIyq+J49kUbW/sC8JIQVD3Br
        McmamYl9MN3+CGgPkHTxae9UI55Q3
X-Received: by 2002:a05:6214:4ec:: with SMTP id cl12mr1273089qvb.8.1587107081144;
        Fri, 17 Apr 2020 00:04:41 -0700 (PDT)
X-Google-Smtp-Source: APiQypLG71hCSTWvUMfQMlDUtmUbHRC1VvkaUnEyqlX9ZNigexKVijGSiZkW+L51xi4Sx5Zi3ClZJ3yc09ey6KTQgRs=
X-Received: by 2002:a05:6214:4ec:: with SMTP id cl12mr1273073qvb.8.1587107080876;
 Fri, 17 Apr 2020 00:04:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200416075643.27330-1-eperezma@redhat.com> <20200416075643.27330-8-eperezma@redhat.com>
 <20200416183324-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200416183324-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 17 Apr 2020 09:04:04 +0200
Message-ID: <CAJaqyWcBTnXvkzaqfSOWODK=+jddeVpee-4ZuqfWc+zj0UsZLA@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] tools/virtio: Reset index in virtio_test --reset.
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 12:34 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Apr 16, 2020 at 09:56:42AM +0200, Eugenio P=C3=A9rez wrote:
> > This way behavior for vhost is more like a VM.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
>
> I dropped --reset from 5.7 since Linus felt it's unappropriate.
> I guess I should squash this in with --reset?
>

Yes please.

If you prefer I can do it using the base you want, so all commits
messages are right.

Thanks!

> > ---
> >  tools/virtio/virtio_test.c | 33 ++++++++++++++++++++++++++-------
> >  1 file changed, 26 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
> > index 18d5347003eb..dca64d36a882 100644
> > --- a/tools/virtio/virtio_test.c
> > +++ b/tools/virtio/virtio_test.c
> > @@ -20,7 +20,6 @@
> >  #include "../../drivers/vhost/test.h"
> >
> >  #define RANDOM_BATCH -1
> > -#define RANDOM_RESET -1
> >
> >  /* Unused */
> >  void *__kmalloc_fake, *__kfree_ignore_start, *__kfree_ignore_end;
> > @@ -49,6 +48,7 @@ struct vdev_info {
> >
> >  static const struct vhost_vring_file no_backend =3D { .fd =3D -1 },
> >                                    backend =3D { .fd =3D 1 };
> > +static const struct vhost_vring_state null_state =3D {};
> >
> >  bool vq_notify(struct virtqueue *vq)
> >  {
> > @@ -174,14 +174,19 @@ static void run_test(struct vdev_info *dev, struc=
t vq_info *vq,
> >       unsigned len;
> >       long long spurious =3D 0;
> >       const bool random_batch =3D batch =3D=3D RANDOM_BATCH;
> > +
> >       r =3D ioctl(dev->control, VHOST_TEST_RUN, &test);
> >       assert(r >=3D 0);
> > +     if (!reset_n) {
> > +             next_reset =3D INT_MAX;
> > +     }
> > +
> >       for (;;) {
> >               virtqueue_disable_cb(vq->vq);
> >               completed_before =3D completed;
> >               started_before =3D started;
> >               do {
> > -                     const bool reset =3D reset_n && completed > next_=
reset;
> > +                     const bool reset =3D completed > next_reset;
> >                       if (random_batch)
> >                               batch =3D (random() % vq->vring.num) + 1;
> >
> > @@ -224,10 +229,24 @@ static void run_test(struct vdev_info *dev, struc=
t vq_info *vq,
> >                       }
> >
> >                       if (reset) {
> > +                             struct vhost_vring_state s =3D { .index =
=3D 0 };
> > +
> > +                             vq_reset(vq, vq->vring.num, &dev->vdev);
> > +
> > +                             r =3D ioctl(dev->control, VHOST_GET_VRING=
_BASE,
> > +                                       &s);
> > +                             assert(!r);
> > +
> > +                             s.num =3D 0;
> > +                             r =3D ioctl(dev->control, VHOST_SET_VRING=
_BASE,
> > +                                       &null_state);
> > +                             assert(!r);
> > +
> >                               r =3D ioctl(dev->control, VHOST_TEST_SET_=
BACKEND,
> >                                         &backend);
> >                               assert(!r);
> >
> > +                             started =3D completed;
> >                               while (completed > next_reset)
> >                                       next_reset +=3D completed;
> >                       }
> > @@ -249,7 +268,9 @@ static void run_test(struct vdev_info *dev, struct =
vq_info *vq,
> >       test =3D 0;
> >       r =3D ioctl(dev->control, VHOST_TEST_RUN, &test);
> >       assert(r >=3D 0);
> > -     fprintf(stderr, "spurious wakeups: 0x%llx\n", spurious);
> > +     fprintf(stderr,
> > +             "spurious wakeups: 0x%llx started=3D0x%lx completed=3D0x%=
lx\n",
> > +             spurious, started, completed);
> >  }
> >
> >  const char optstring[] =3D "h";
> > @@ -312,7 +333,7 @@ static void help(void)
> >               " [--no-virtio-1]"
> >               " [--delayed-interrupt]"
> >               " [--batch=3Drandom/N]"
> > -             " [--reset=3Drandom/N]"
> > +             " [--reset=3DN]"
> >               "\n");
> >  }
> >
> > @@ -360,11 +381,9 @@ int main(int argc, char **argv)
> >               case 'r':
> >                       if (!optarg) {
> >                               reset =3D 1;
> > -                     } else if (0 =3D=3D strcmp(optarg, "random")) {
> > -                             reset =3D RANDOM_RESET;
> >                       } else {
> >                               reset =3D strtol(optarg, NULL, 10);
> > -                             assert(reset >=3D 0);
> > +                             assert(reset > 0);
> >                               assert(reset < (long)INT_MAX + 1);
> >                       }
> >                       break;
> > --
> > 2.18.1
>

