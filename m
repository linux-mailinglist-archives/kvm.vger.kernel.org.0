Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971D71ADD46
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 14:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgDQMZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 08:25:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58376 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727877AbgDQMZN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 08:25:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587126312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6SYQc5vlhk7XbIz6vBeT6lWe63ZtgKx7c9HrEfLpD3c=;
        b=jV8NcYhn2cLOsTRUG++CXfUHzP+dHqT1L+nd9VkwR7AK+RW24sMaYOgNcrtIZPDgkt47MX
        WoB4h3JMl16mQuA+07JKajppP5iaTW4yWwMjh8M/yl5Jxg/Peeh8tmrBHlMF77NcnVw63t
        CjHhRhXDPY1cafXvklEnfQrnFtca2gY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-SRsONdi4MT-8XCQ3JOWfEA-1; Fri, 17 Apr 2020 08:25:10 -0400
X-MC-Unique: SRsONdi4MT-8XCQ3JOWfEA-1
Received: by mail-qv1-f71.google.com with SMTP id t16so1998409qve.22
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 05:25:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6SYQc5vlhk7XbIz6vBeT6lWe63ZtgKx7c9HrEfLpD3c=;
        b=oltADJxx2eV9P8zYb8VZ6X/bzL+YI9oXZT9hXtheXV7XcFxsYR2CKYRGqKdg+ut/4g
         Cbo8VNterRzMEM2rVpwQc7CIbule67El2Wd08IR//0HfClFFsKTRlB4hjGBx5vLoAVd5
         uHzk8QBeGf+HYJrYsWQhAayu3KPNQZhgiUjzN/JP0ngto+xcozm4NeT74nEzqSrGVUY3
         wSvQwoyK0ZVDSMnpsbzPC3a2jy1hI/Z215H6J2wynToyiagkDPLWMTYjX8bK7V8qe8we
         0W9I5d3fRGUMIvtigyGNXt9b9oudJBd6C/X5j16jR2ZRfEivTy396m7BMnlzGUHvGzB5
         SDYQ==
X-Gm-Message-State: AGi0PuZl9Y+Ed1djzgER3SgUlrjfQcsXRkbT3s6VLwq7fv0J0RqvMl4B
        z33UlD5a2IuPXyBExFUPGXNbQRY7xCs0kH63z/5PSkjAitcCgt4GlJ5UUWj+rcKo8QpN4GoXKKF
        6BDbORGqvrbm8eGMzWoga8nUV/mXm
X-Received: by 2002:a37:7786:: with SMTP id s128mr2986055qkc.497.1587126307608;
        Fri, 17 Apr 2020 05:25:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypKBfWZGJeymkb2lYpO2MfszDQFTMR0yiJ30RKxU2YF4NbhBMAq5PZqSKtDRB05J3D3z30Fv7G/YFuiyJNOVrTM=
X-Received: by 2002:a37:7786:: with SMTP id s128mr2986028qkc.497.1587126307322;
 Fri, 17 Apr 2020 05:25:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200416075643.27330-1-eperezma@redhat.com> <20200416075643.27330-6-eperezma@redhat.com>
 <20200416183244-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200416183244-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 17 Apr 2020 14:24:31 +0200
Message-ID: <CAJaqyWcuxG03+J+BW=fPb=JFKLPi0h5sRGv9cjWv63eyspS4Qg@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] tools/virtio: Use __vring_new_virtqueue in virtio_test.c
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

On Fri, Apr 17, 2020 at 12:33 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Apr 16, 2020 at 09:56:40AM +0200, Eugenio P=C3=A9rez wrote:
> > As updated in ("2a2d1382fe9d virtio: Add improved queue allocation API"=
)
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
>
> Pls add motivation for these changes.
>

The original motivation was to make code as close as possible to
virtio_net. Also, it skips a (probably not expensive) initialization
in vring_new_virtqueue.

With the recent events, I think that this could be useful to test when
userspace and kernel use different struct layout, maybe with some
sanitizer. I can drop it if you don't see it the same way (or if I
didn't understand the problem and this does not help).

Thanks!

> > ---
> >  tools/virtio/virtio_test.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
> > index 1d5144590df6..d9827b640c21 100644
> > --- a/tools/virtio/virtio_test.c
> > +++ b/tools/virtio/virtio_test.c
> > @@ -106,10 +106,9 @@ static void vq_info_add(struct vdev_info *dev, int=
 num)
> >       assert(r >=3D 0);
> >       memset(info->ring, 0, vring_legacy_size(num, 4096));
> >       vring_legacy_init(&info->vring, num, info->ring, 4096);
> > -     info->vq =3D vring_new_virtqueue(info->idx,
> > -                                    info->vring.num, 4096, &dev->vdev,
> > -                                    true, false, info->ring,
> > -                                    vq_notify, vq_callback, "test");
> > +     info->vq =3D
> > +             __vring_new_virtqueue(info->idx, info->vring, &dev->vdev,=
 true,
> > +                                   false, vq_notify, vq_callback, "tes=
t");
> >       assert(info->vq);
> >       info->vq->priv =3D info;
> >       vhost_vq_setup(dev, info);
> > --
> > 2.18.1
>

