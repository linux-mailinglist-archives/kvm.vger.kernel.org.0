Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFD72FF598
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 21:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbhAUUNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 15:13:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727050AbhAUUM4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 15:12:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611259884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9/S1AC2FTxz4g0HD+H8LDYzz2hqAr1Tv6Nfanb0Lvqs=;
        b=Wo7qzUEEH8jUuu1iTUF0T+fiC3jSR8HTgoVLanGKdCTq+JL1BfN1QPzlD0CEx/OQhth/SA
        y+8ll/BpfPPzdPt+IYaFaAbFOaBeZ1EA3EyE3tAIzxApby9YXiRShPh5fUlNu4AWw1mF7W
        hfma7EIYrj+b4s9Ab/pO5YL8Dg7w/58=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-dx4cmhYtMZ6-iaVN6Ma42Q-1; Thu, 21 Jan 2021 15:11:15 -0500
X-MC-Unique: dx4cmhYtMZ6-iaVN6Ma42Q-1
Received: by mail-qv1-f69.google.com with SMTP id f7so2264159qvr.4
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 12:11:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9/S1AC2FTxz4g0HD+H8LDYzz2hqAr1Tv6Nfanb0Lvqs=;
        b=a5Z8GW5PJ8LmPSTqvBeqZnDRhG6zGhjEDb4bqoIBNYGwnHCGdZIdJWVGUlXYL3tNa4
         1QgYpiWDr5QOmGzEKPa9pJhWdwabG4H92DUqcmzT2glIyof8rtDp7IweX2C7fNHHjocC
         tlO3iQVN1O/foPM9gJx+MqbGPJI5zPw2SmCkIuhlQEoTVALDGSJZAQ1X0m8YYURP3UsC
         EnWf54Lundv5geX9wJCrOyiG9S91l9Jr+oS6OgU/EayjoXfY+Q7iVMdxpw8PndE/PO8H
         lMatHcIgjcwCELIJc8Yg7Q2ssOkSUkaFYM8ZjKOmOMni+IJeHQv/jqkOrShyjLdqwFaV
         ccyg==
X-Gm-Message-State: AOAM533yt2H8kLB+aRT6K5QfliLlZYwN7IpTOtT3M+h3eTq/hqJQTHU+
        kiJlI479/2JB6/s7b9Fg/XN+3uizF4+CWv4W59XVg7UN30DDCTiQdkQFgNp0oF5d4KFGXyBq1O7
        jY6jwr1oa2BX0Atq+uynvXSLKRZWe
X-Received: by 2002:a0c:fa4c:: with SMTP id k12mr1256442qvo.16.1611259874853;
        Thu, 21 Jan 2021 12:11:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkXvOAGt6ZlMe8/BD9HMhDfNICZQCgC6hAVFS6cVSwfZjK0GbFoBhGZB0aChoPvFURG4te+3SSi7EtluXcDP4=
X-Received: by 2002:a0c:fa4c:: with SMTP id k12mr1256415qvo.16.1611259874594;
 Thu, 21 Jan 2021 12:11:14 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-8-eperezma@redhat.com>
 <20201207174233.GN203660@stefanha-x1.localdomain> <CAJaqyWfiMsRP9FgSv7cOj=3jHx=DJS7hRJTMbRcTTHHWng0eKg@mail.gmail.com>
 <20201210115052.GG416119@stefanha-x1.localdomain>
In-Reply-To: <20201210115052.GG416119@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 21 Jan 2021 21:10:38 +0100
Message-ID: <CAJaqyWcN2LWC+XmU6zSG-kgrfhGc4VXjG+zj2LgCe3haLfeRgg@mail.gmail.com>
Subject: Re: [RFC PATCH 07/27] vhost: Route guest->host notification through qemu
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-level <qemu-devel@nongnu.org>,
        Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 10, 2020 at 12:51 PM Stefan Hajnoczi <stefanha@redhat.com> wrot=
e:
>
> On Wed, Dec 09, 2020 at 06:08:14PM +0100, Eugenio Perez Martin wrote:
> > On Mon, Dec 7, 2020 at 6:42 PM Stefan Hajnoczi <stefanha@gmail.com> wro=
te:
> > > On Fri, Nov 20, 2020 at 07:50:45PM +0100, Eugenio P=C3=A9rez wrote:
> > > > +{
> > > > +    struct vhost_vring_file file =3D {
> > > > +        .index =3D idx
> > > > +    };
> > > > +    VirtQueue *vq =3D virtio_get_queue(dev->vdev, idx);
> > > > +    VhostShadowVirtqueue *svq;
> > > > +    int r;
> > > > +
> > > > +    svq =3D g_new0(VhostShadowVirtqueue, 1);
> > > > +    svq->vq =3D vq;
> > > > +
> > > > +    r =3D event_notifier_init(&svq->hdev_notifier, 0);
> > > > +    assert(r =3D=3D 0);
> > > > +
> > > > +    file.fd =3D event_notifier_get_fd(&svq->hdev_notifier);
> > > > +    r =3D dev->vhost_ops->vhost_set_vring_kick(dev, &file);
> > > > +    assert(r =3D=3D 0);
> > > > +
> > > > +    return svq;
> > > > +}
> > >
> > > I guess there are assumptions about the status of the device? Does th=
e
> > > virtqueue need to be disabled when this function is called?
> > >
> >
> > Yes. Maybe an assertion checking the notification state?
>
> Sounds good.
>
> > > > +
> > > > +static int vhost_sw_live_migration_stop(struct vhost_dev *dev)
> > > > +{
> > > > +    int idx;
> > > > +
> > > > +    vhost_dev_enable_notifiers(dev, dev->vdev);
> > > > +    for (idx =3D 0; idx < dev->nvqs; ++idx) {
> > > > +        vhost_sw_lm_shadow_vq_free(dev->sw_lm_shadow_vq[idx]);
> > > > +    }
> > > > +
> > > > +    return 0;
> > > > +}
> > > > +
> > > > +static int vhost_sw_live_migration_start(struct vhost_dev *dev)
> > > > +{
> > > > +    int idx;
> > > > +
> > > > +    for (idx =3D 0; idx < dev->nvqs; ++idx) {
> > > > +        dev->sw_lm_shadow_vq[idx] =3D vhost_sw_lm_shadow_vq(dev, i=
dx);
> > > > +    }
> > > > +
> > > > +    vhost_dev_disable_notifiers(dev, dev->vdev);
> > >
> > > There is a race condition if the guest kicks the vq while this is
> > > happening. The shadow vq hdev_notifier needs to be set so the vhost
> > > device checks the virtqueue for requests that slipped in during the
> > > race window.
> > >
> >
> > I'm not sure if I follow you. If I understand correctly,
> > vhost_dev_disable_notifiers calls virtio_bus_cleanup_host_notifier,
> > and the latter calls virtio_queue_host_notifier_read. That's why the
> > documentation says "This might actually run the qemu handlers right
> > away, so virtio in qemu must be completely setup when this is
> > called.". Am I missing something?
>
> There are at least two cases:
>
> 1. Virtqueue kicks that come before vhost_dev_disable_notifiers().
>    vhost_dev_disable_notifiers() notices that and calls
>    virtio_queue_notify_vq(). Will handle_sw_lm_vq() be invoked or is the
>    device's vq handler function invoked?
>

As I understand both the code and your question, no kick can call
handle_sw_lm_vq before vhost_dev_disable_notifiers (in particular,
before memory_region_add_eventfd calls in
virtio_{pci,mmio,ccw}_ioeventfd_assign(true) calls. So these will be
handled by the device.

> 2. Virtqueue kicks that come in after vhost_dev_disable_notifiers()
>    returns. We hold the QEMU global mutex so the vCPU thread cannot
>    perform MMIO/PIO dispatch immediately. The vCPU thread's
>    ioctl(KVM_RUN) has already returned and will dispatch dispatch the
>    MMIO/PIO access inside QEMU as soon as the global mutex is released.
>    In other words, we're not taking the kvm.ko ioeventfd path but
>    memory_region_dispatch_write_eventfds() should signal the ioeventfd
>    that is registered at the time the dispatch occurs. Is that eventfd
>    handled by handle_sw_lm_vq()?
>

I didn't think on that case, but it's being very difficult for me to
reproduce that behavior. It should be handled by handle_sw_lm_vq, but
maybe I'm trusting too much in vhost_dev_disable_notifiers.

> Neither of these cases are obvious from the code. At least comments
> would help but I suspect restructuring the code so the critical
> ioeventfd state changes happen in a sequence would make it even clearer.

Could you expand on this? That change is managed entirely by
virtio_bus_set_host_notifier, and the virtqueue callback is already
changed before the call to vhost_dev_disable_notifiers(). Did you mean
to restructure virtio_bus_set_host_notifier or
vhost_dev_disable_notifiers maybe?

Thanks!

