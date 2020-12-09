Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201C82D4218
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 13:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731528AbgLIMWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 07:22:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731495AbgLIMWQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 07:22:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607516449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=02tquZiATMN/D94oqS1HgMSz6T4cchxv1MZSl+fk/68=;
        b=LlMssY+oeg62FO4iyAm4luod1eiUx1QnNPUL3ZKpQMT9SiDYYvC3P7IWr6Fyy94wtUHpcH
        ytHM7zVmGQaTbt+i2LGZKnROQNb1tHzRYID7ReM7uZ4MK1gOuaFMQ2SbqRsmxvIhIo/5Fs
        ECYKUpEUY9wGpaItMpcVf/wYCwpt+Uw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-KfyEmGOOP4eBXOGSsOfJAw-1; Wed, 09 Dec 2020 07:20:47 -0500
X-MC-Unique: KfyEmGOOP4eBXOGSsOfJAw-1
Received: by mail-qt1-f200.google.com with SMTP id n12so1056723qta.9
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 04:20:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=02tquZiATMN/D94oqS1HgMSz6T4cchxv1MZSl+fk/68=;
        b=nWPi//Ow471Wp2u7ftJz60Yfg4CpHWHxzvlark7ijMlC8Z6+gbzT5Ex/lQC/durSyu
         NQ9P7bgwL/F9RPOdpwS/+RNCUP0WgZ9Baql62o5iV3Z3B7KH3+vu6XJ5cLnWdyLmVxqO
         ZtA093I2rMGSqSFEtL1GcAKByHrbaPxjAVBMx1Xw/U2HNIIQleTM5BG1PvoVV5/1bttQ
         FA4iCfknDxrqj+i0AkGVEnNfonz9SDJhG0WowRXYBNVeXbceUf5w6VJhu03o9MAumrPN
         86rT7MUfgQCte3kaLwc9ZSDB0wDqgpHmAHXnIDaTRgwf6Y8vRNHeByRsaUr0KYVvQMj6
         tFVA==
X-Gm-Message-State: AOAM532TClwZAqIwWN52LvEOSQRnOmy/85ztzRkHXcFDFXoCvmg8zlux
        hgg111o3/KeqM0GZqWXdvNu6jFnMMLp94gKN7lJ8Yo+h6E+6lUAr8YwH499cxXdBy1hsKFOMTWL
        O7ExCMLK7aR7B1FqYHI/FBdQEyjvM
X-Received: by 2002:a37:8485:: with SMTP id g127mr2590261qkd.233.1607516447501;
        Wed, 09 Dec 2020 04:20:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxt/nrA+PEG+B8jRnIAdin9fm1aHeI7kL5mjtjcSfyl2llDTS9p8AJqVYo87tA8/xuhq3mMWO7Vd0gMqaadb3Y=
X-Received: by 2002:a37:8485:: with SMTP id g127mr2590212qkd.233.1607516447222;
 Wed, 09 Dec 2020 04:20:47 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-3-eperezma@redhat.com>
 <20201207161938.GJ203660@stefanha-x1.localdomain>
In-Reply-To: <20201207161938.GJ203660@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 9 Dec 2020 13:20:10 +0100
Message-ID: <CAJaqyWcZ_LEu1OibCoG+couDPoOjDPQNLkoEppEat=jDP6zvxQ@mail.gmail.com>
Subject: Re: [RFC PATCH 02/27] vhost: Add device callback in vhost_migration_log
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-level <qemu-devel@nongnu.org>,
        Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
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

On Mon, Dec 7, 2020 at 5:19 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 07:50:40PM +0100, Eugenio P=C3=A9rez wrote:
> > This allows code to reuse the logic to not to re-enable or re-disable
> > migration mechanisms. Code works the same way as before.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  hw/virtio/vhost.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> > index 2bd8cdf893..2adb2718c1 100644
> > --- a/hw/virtio/vhost.c
> > +++ b/hw/virtio/vhost.c
> > @@ -862,7 +862,9 @@ err_features:
> >      return r;
> >  }
> >
> > -static int vhost_migration_log(MemoryListener *listener, bool enable)
> > +static int vhost_migration_log(MemoryListener *listener,
> > +                               bool enable,
> > +                               int (*device_cb)(struct vhost_dev *, bo=
ol))
>
> Please document the argument. What is the callback function supposed to
> do ("device_cb" is not descriptive so I'm not sure)?

Sure, I will expand documentation if we stick with this approach to
enable/disable the shadow virtqueue (I hope we agree on a better one
anyway).

Just for completion, it was meant for vhost_dev_set_log, so vhost_dev*
is the device to enable/disable migration, and the second bool is for
enable/disable it.

Thanks!

