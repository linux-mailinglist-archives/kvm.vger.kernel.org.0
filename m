Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97D66C2D68
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 10:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjCUJCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 05:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjCUJC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 05:02:29 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A460B3B0ED
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 02:01:18 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id j11so18144991lfg.13
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 02:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1679389253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HmRSDNvLlxF5CoR4eIJPJCQoVLdUfrVCClwFh9umPc=;
        b=WH84tStCTN2kVoDG4iw/y8XypxSDWCpH07PyctmzeleHMO+Z7OTjlWzKzqPYZWZVcj
         n4Nbz46ImDTjTwNd7yQa+6GeyFQ+QQ0i1l1E1erdVgFDDZkCDp+SdUz0N1eONOxvSKz+
         THv1iJ08Opmu66D+QlIA5L9jx6NlB7FuaOlCoQEBWW5QAJq1FSHmT+qYnouo4cWsKMNK
         J1vRU5Th2xg4RGgtMcUEw4XmOFO7rZwmJvHPW/nE2RIlc6e1XIHIpq/204j7opi4gkaC
         SGMlU+jziooLbgLMdKzPkjwMaYdtaqEEObVY5eQ8DZGbSLZdcZDfaAbGL2JAPycKDb0j
         pcuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679389253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4HmRSDNvLlxF5CoR4eIJPJCQoVLdUfrVCClwFh9umPc=;
        b=VSjxUt30NlWMNo15pGgcwBaigBNZkEKUf7yLXdowBeHlJ/BbivxwGc2XV1yGr+lVNI
         /ahT7DEy3FuMq7oSk2Keck3xv4twf1YVdypv6Kate2xM5KDs7D7WYPhDn5035yRkF+HD
         1pUsIekGHvgqO/zSY2OtlGCDbi6UWJbLHfmRmD/1gy9FXEBLbzOHJx5H/Db1qJi3AGHI
         ZYz0d08mHO413vmfyMPvk7niP9Ti+K9j7UBByFjLjccFOB88jnFSR6NjvogIoBOyVMuv
         3u+rIWlc7LtI4K7IAlKDyB3M2JAqm8PSPSjboc6bwIjZnkf88pe80h+M7n/1RWjzQMwS
         FqfA==
X-Gm-Message-State: AO0yUKU5mymwQBsiMZWpwvW9ebZ3pnRDTUFG/BN0/FdCeEVM+xTMACs+
        qMPEHpFtJsJp9uGLpkz112STUvYhKpN8E9AW53n8Cw==
X-Google-Smtp-Source: AK7set+Y4RMBgQXO3mia89WCn37DTOJKBKUTQZe9XhWrDNe8MJs8ueZdrqzn9/txXLFz+XhoeNKkwnrS1Hg6TgIqeWk=
X-Received: by 2002:a19:5216:0:b0:4e8:5371:c884 with SMTP id
 m22-20020a195216000000b004e85371c884mr585630lfb.5.1679389252865; Tue, 21 Mar
 2023 02:00:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230320232115.1940587-1-viktor@daynix.com> <CACGkMEu5qa2KUHti3w59DcXNxBdh8_ogZ9oW9bo1_PHwbNiCBg@mail.gmail.com>
In-Reply-To: <CACGkMEu5qa2KUHti3w59DcXNxBdh8_ogZ9oW9bo1_PHwbNiCBg@mail.gmail.com>
From:   Viktor Prutyanov <viktor@daynix.com>
Date:   Tue, 21 Mar 2023 12:00:42 +0300
Message-ID: <CAPv0NP5wTMG=3kT_FX4xi9kGbX0Dah4qTQfFQPutWYsWvK1i-g@mail.gmail.com>
Subject: Re: [PATCH v2] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, cohuck@redhat.com, pasic@linux.ibm.com,
        farman@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 5:29=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Tue, Mar 21, 2023 at 7:21=E2=80=AFAM Viktor Prutyanov <viktor@daynix.c=
om> wrote:
> >
> > According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
> > indicates that the driver passes extra data along with the queue
> > notifications.
> >
> > In a split queue case, the extra data is 16-bit available index. In a
> > packed queue case, the extra data is 1-bit wrap counter and 15-bit
> > available index.
> >
> > Add support for this feature for MMIO and PCI transports. Channel I/O
> > transport will not accept this feature.
> >
> > Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
> > ---
> >
> >  v2: reject the feature in virtio_ccw, replace __le32 with u32
> >
> >  drivers/s390/virtio/virtio_ccw.c   |  4 +---
> >  drivers/virtio/virtio_mmio.c       | 15 ++++++++++++++-
> >  drivers/virtio/virtio_pci_common.c | 10 ++++++++++
> >  drivers/virtio/virtio_pci_common.h |  4 ++++
> >  drivers/virtio/virtio_pci_legacy.c |  2 +-
> >  drivers/virtio/virtio_pci_modern.c |  2 +-
> >  drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
> >  include/linux/virtio_ring.h        |  2 ++
> >  include/uapi/linux/virtio_config.h |  6 ++++++
> >  9 files changed, 56 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/vir=
tio_ccw.c
> > index a10dbe632ef9..d72a59415527 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -789,9 +789,7 @@ static u64 virtio_ccw_get_features(struct virtio_de=
vice *vdev)
> >
> >  static void ccw_transport_features(struct virtio_device *vdev)
> >  {
> > -       /*
> > -        * Currently nothing to do here.
> > -        */
> > +       __virtio_clear_bit(vdev, VIRTIO_F_NOTIFICATION_DATA);
>
> Is there any restriction that prevents us from implementing
> VIRTIO_F_NOTIFICATION_DATA? (Spec seems doesn't limit us from this)

Most likely, nothing.

>
> >  }
> >
> >  static int virtio_ccw_finalize_features(struct virtio_device *vdev)
> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.=
c
> > index 3ff746e3f24a..0e13da17fe0a 100644
> > --- a/drivers/virtio/virtio_mmio.c
> > +++ b/drivers/virtio/virtio_mmio.c
> > @@ -285,6 +285,19 @@ static bool vm_notify(struct virtqueue *vq)
> >         return true;
> >  }
> >
> > +static bool vm_notify_with_data(struct virtqueue *vq)
> > +{
> > +       struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vq-=
>vdev);
> > +       u32 data =3D vring_fill_notification_data(vq);
>
> Can we move this to the initialization?

This data is new for each notification, because it helps to identify
the next available index.

>
> Thanks
>

Thanks,
Viktor Prutyanov
