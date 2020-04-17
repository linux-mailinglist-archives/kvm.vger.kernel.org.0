Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE6F1AD887
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 10:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbgDQI25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 04:28:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45104 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729697AbgDQI2z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 04:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587112132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJ8xriwhJnwxVRszo7sZYDjt+bqPl2dFP/ChGE8P0zA=;
        b=dQ5tQf9TN1/lkub+aQ2RfjRmfvoC4+vTE6TdcAN8yRvGUa/QX+gKMkCmJFQUXjfS6s6omc
        362gN5Wb1fXtQOGnFZ8gfAyZ4Q16FNeEaZCfvep5onP8ZcZkWCMHnCcYMvTT4PTns1kMJ9
        TNJjHKJPUDISL4143MLbWvY/QV/ckoU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-IsHh8U9FNgeXTPk8uWiIWw-1; Fri, 17 Apr 2020 04:28:51 -0400
X-MC-Unique: IsHh8U9FNgeXTPk8uWiIWw-1
Received: by mail-wr1-f70.google.com with SMTP id s11so636184wru.6
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 01:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mJ8xriwhJnwxVRszo7sZYDjt+bqPl2dFP/ChGE8P0zA=;
        b=Xrq9hF+TvacLpO8Kp3Q669/4D14AIUAXFYe8ExRBwN96CGHjO/mf1Mh4Hkqpn/1COg
         mpz/WJs08rZ/6MQC2ave+Odpz7jsehdp5rUbDihL0FZxGqCFQun2P7TymZWoTxlgfL62
         s09yXpxi8gR73OWRbF4FieIsfFt2DKmcqN5eGaCZ59I++2vF5qQ2PdBapQ3Xqcsw+sUa
         Amk5tCu+DrJcydL7cKqCB9JOTHYQWIhGDiG+BgA174Gug6FcIgxhFtopxAkhrB4y+msM
         2ga3oZixMkNpdrRv4PgMekggZSG2CY3r8Sos8knpODZvp6EDAs/+j0JeevIX0IYmUx3K
         FoVg==
X-Gm-Message-State: AGi0PuZ7UtztoV/+odiEZq+9dO46zFU5GqLiSJHIQCXRp42oU6hB0lL4
        CbRIuIxrh2utaXGSaq0Oc7+amAUL53wS8ln2sheWkCKefZPrNVFJdC/md83E8vNv2ATY+hbUl3r
        /Xa+HDQY6TVaJ
X-Received: by 2002:a05:600c:2c04:: with SMTP id q4mr2078496wmg.7.1587112130080;
        Fri, 17 Apr 2020 01:28:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ2Sn7FUvpE07r59sGuE5XHGLLO0BakznVfq9gjnT4uADElM12aSKCTNB609s6nmfxAJ2jCoQ==
X-Received: by 2002:a05:600c:2c04:: with SMTP id q4mr2078477wmg.7.1587112129750;
        Fri, 17 Apr 2020 01:28:49 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id u7sm7319215wmg.41.2020.04.17.01.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 01:28:49 -0700 (PDT)
Date:   Fri, 17 Apr 2020 04:28:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 7/8] tools/virtio: Reset index in virtio_test --reset.
Message-ID: <20200417042551-mutt-send-email-mst@kernel.org>
References: <20200416075643.27330-1-eperezma@redhat.com>
 <20200416075643.27330-8-eperezma@redhat.com>
 <20200416183324-mutt-send-email-mst@kernel.org>
 <CAJaqyWcBTnXvkzaqfSOWODK=+jddeVpee-4ZuqfWc+zj0UsZLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWcBTnXvkzaqfSOWODK=+jddeVpee-4ZuqfWc+zj0UsZLA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 09:04:04AM +0200, Eugenio Perez Martin wrote:
> On Fri, Apr 17, 2020 at 12:34 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Apr 16, 2020 at 09:56:42AM +0200, Eugenio Pérez wrote:
> > > This way behavior for vhost is more like a VM.
> > >
> > > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> >
> > I dropped --reset from 5.7 since Linus felt it's unappropriate.
> > I guess I should squash this in with --reset?
> >
> 
> Yes please.
> 
> If you prefer I can do it using the base you want, so all commits
> messages are right.
> 
> Thanks!

OK so I dropped new tests from vhost for now, pls rebased on
top of that.

Thanks!

> > > ---
> > >  tools/virtio/virtio_test.c | 33 ++++++++++++++++++++++++++-------
> > >  1 file changed, 26 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
> > > index 18d5347003eb..dca64d36a882 100644
> > > --- a/tools/virtio/virtio_test.c
> > > +++ b/tools/virtio/virtio_test.c
> > > @@ -20,7 +20,6 @@
> > >  #include "../../drivers/vhost/test.h"
> > >
> > >  #define RANDOM_BATCH -1
> > > -#define RANDOM_RESET -1
> > >
> > >  /* Unused */
> > >  void *__kmalloc_fake, *__kfree_ignore_start, *__kfree_ignore_end;
> > > @@ -49,6 +48,7 @@ struct vdev_info {
> > >
> > >  static const struct vhost_vring_file no_backend = { .fd = -1 },
> > >                                    backend = { .fd = 1 };
> > > +static const struct vhost_vring_state null_state = {};
> > >
> > >  bool vq_notify(struct virtqueue *vq)
> > >  {
> > > @@ -174,14 +174,19 @@ static void run_test(struct vdev_info *dev, struct vq_info *vq,
> > >       unsigned len;
> > >       long long spurious = 0;
> > >       const bool random_batch = batch == RANDOM_BATCH;
> > > +
> > >       r = ioctl(dev->control, VHOST_TEST_RUN, &test);
> > >       assert(r >= 0);
> > > +     if (!reset_n) {
> > > +             next_reset = INT_MAX;
> > > +     }
> > > +
> > >       for (;;) {
> > >               virtqueue_disable_cb(vq->vq);
> > >               completed_before = completed;
> > >               started_before = started;
> > >               do {
> > > -                     const bool reset = reset_n && completed > next_reset;
> > > +                     const bool reset = completed > next_reset;
> > >                       if (random_batch)
> > >                               batch = (random() % vq->vring.num) + 1;
> > >
> > > @@ -224,10 +229,24 @@ static void run_test(struct vdev_info *dev, struct vq_info *vq,
> > >                       }
> > >
> > >                       if (reset) {
> > > +                             struct vhost_vring_state s = { .index = 0 };
> > > +
> > > +                             vq_reset(vq, vq->vring.num, &dev->vdev);
> > > +
> > > +                             r = ioctl(dev->control, VHOST_GET_VRING_BASE,
> > > +                                       &s);
> > > +                             assert(!r);
> > > +
> > > +                             s.num = 0;
> > > +                             r = ioctl(dev->control, VHOST_SET_VRING_BASE,
> > > +                                       &null_state);
> > > +                             assert(!r);
> > > +
> > >                               r = ioctl(dev->control, VHOST_TEST_SET_BACKEND,
> > >                                         &backend);
> > >                               assert(!r);
> > >
> > > +                             started = completed;
> > >                               while (completed > next_reset)
> > >                                       next_reset += completed;
> > >                       }
> > > @@ -249,7 +268,9 @@ static void run_test(struct vdev_info *dev, struct vq_info *vq,
> > >       test = 0;
> > >       r = ioctl(dev->control, VHOST_TEST_RUN, &test);
> > >       assert(r >= 0);
> > > -     fprintf(stderr, "spurious wakeups: 0x%llx\n", spurious);
> > > +     fprintf(stderr,
> > > +             "spurious wakeups: 0x%llx started=0x%lx completed=0x%lx\n",
> > > +             spurious, started, completed);
> > >  }
> > >
> > >  const char optstring[] = "h";
> > > @@ -312,7 +333,7 @@ static void help(void)
> > >               " [--no-virtio-1]"
> > >               " [--delayed-interrupt]"
> > >               " [--batch=random/N]"
> > > -             " [--reset=random/N]"
> > > +             " [--reset=N]"
> > >               "\n");
> > >  }
> > >
> > > @@ -360,11 +381,9 @@ int main(int argc, char **argv)
> > >               case 'r':
> > >                       if (!optarg) {
> > >                               reset = 1;
> > > -                     } else if (0 == strcmp(optarg, "random")) {
> > > -                             reset = RANDOM_RESET;
> > >                       } else {
> > >                               reset = strtol(optarg, NULL, 10);
> > > -                             assert(reset >= 0);
> > > +                             assert(reset > 0);
> > >                               assert(reset < (long)INT_MAX + 1);
> > >                       }
> > >                       break;
> > > --
> > > 2.18.1
> >

