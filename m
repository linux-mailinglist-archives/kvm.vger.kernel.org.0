Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12665589912
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 10:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239163AbiHDINR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 04:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbiHDINP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 04:13:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 056636555B
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 01:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659600789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8F0S6LKNOGe0vGnCxY64jodkA263GuoIQL9zPEblVo0=;
        b=IQLPo9hNhgcFaXzy8KwY/Xc6CPtldJ8YbYkXJ8zLtYTdb5u+CbH7mm9Kt+r9WS6c9o5JtJ
        wNVlUhO1AmwxvK83CuFK8Y/JsJKtkj7w2ePBwVY/Gzvo09DiSqzQkgFLjOrymG41zPlyNN
        ROQLRT+5Atk1oDoumanaQhsx8CCJXTI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-bEBPGoRCM8CQQ4C7p6WjMw-1; Thu, 04 Aug 2022 03:53:16 -0400
X-MC-Unique: bEBPGoRCM8CQQ4C7p6WjMw-1
Received: by mail-qv1-f72.google.com with SMTP id o9-20020a0cecc9000000b0047491274bb1so9227351qvq.19
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 00:52:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8F0S6LKNOGe0vGnCxY64jodkA263GuoIQL9zPEblVo0=;
        b=PZ+gYk0C33CsQF/P2AI4eJO62TsgZO/rFYoGcaDcXipUlWBokting00F0i3tu8KDSx
         2eUx+BdEUJbm0SjYNJmraoh7MXt0zx3cn7RnN2LySxbpiZD/gydjGh5VUIVA+oHdPVsS
         GQHjo81wqCcHeneMM2oDhHCeIrY06SiLX8kUhUo6WA5/9Y09YNIQGCx/eoc346p83kt2
         vJv9z3v2sQ+bV9qwXzjujCfER9eFvUfJ7c8F7qsx8lShZFvSct659bKiDvoR6ctOGLft
         weXhge20VGSjFk5EZmeXejnXyFUGFYKs7E64con0K4Qjdk1eDEzQVkGmQ+i7S54+FWdM
         IeAg==
X-Gm-Message-State: ACgBeo06H70sBZer9vnv8wvaWo+ps9X2uaE1KH+5Dr44x1R0WV8+jmqG
        ga81V9KviqurXCXuMnGk0h7g/CQg8o1HwQRd2J3YSLiT5bZ+w4OMaxkVt3x2CX8rMPnPo8B4N23
        zg/1rdBpOb3PQpm8rw0OYtLo6CBEo
X-Received: by 2002:a05:622a:110f:b0:31e:e0ae:a734 with SMTP id e15-20020a05622a110f00b0031ee0aea734mr460088qty.495.1659599555618;
        Thu, 04 Aug 2022 00:52:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR75aAwbdfHLU6s3SaSU/UUeQWjFDM6Z/PynWnM5uITHZk/mGdwFmveZqryri6JJlbW8y3+579zJnBtqmN4yxus=
X-Received: by 2002:a05:622a:110f:b0:31e:e0ae:a734 with SMTP id
 e15-20020a05622a110f00b0031ee0aea734mr460065qty.495.1659599555414; Thu, 04
 Aug 2022 00:52:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220803171821.481336-1-eperezma@redhat.com> <20220803171821.481336-7-eperezma@redhat.com>
 <c25c142f-ad9d-a5cf-9837-5570d563ad07@redhat.com>
In-Reply-To: <c25c142f-ad9d-a5cf-9837-5570d563ad07@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 4 Aug 2022 09:51:59 +0200
Message-ID: <CAJaqyWd8ddjFLk=C=Mw_6o2=+0w=ior5fvCV2jSMx7LodVnmAA@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] vhost_net: Add NetClientInfo prepare callback
To:     Jason Wang <jasowang@redhat.com>
Cc:     qemu-level <qemu-devel@nongnu.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Parav Pandit <parav@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 4, 2022 at 6:46 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/8/4 01:18, Eugenio P=C3=A9rez =E5=86=99=E9=81=93:
> > This is used by the backend to perform actions before the device is
> > started.
> >
> > In particular, vdpa will use it to isolate CVQ in its own ASID if
> > possible, and start SVQ unconditionally only in CVQ.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >   include/net/net.h  | 2 ++
> >   hw/net/vhost_net.c | 4 ++++
> >   2 files changed, 6 insertions(+)
> >
> > diff --git a/include/net/net.h b/include/net/net.h
> > index a8d47309cd..efa6448886 100644
> > --- a/include/net/net.h
> > +++ b/include/net/net.h
> > @@ -44,6 +44,7 @@ typedef struct NICConf {
> >
> >   typedef void (NetPoll)(NetClientState *, bool enable);
> >   typedef bool (NetCanReceive)(NetClientState *);
> > +typedef void (NetPrepare)(NetClientState *);
> >   typedef int (NetLoad)(NetClientState *);
> >   typedef ssize_t (NetReceive)(NetClientState *, const uint8_t *, size_=
t);
> >   typedef ssize_t (NetReceiveIOV)(NetClientState *, const struct iovec =
*, int);
> > @@ -72,6 +73,7 @@ typedef struct NetClientInfo {
> >       NetReceive *receive_raw;
> >       NetReceiveIOV *receive_iov;
> >       NetCanReceive *can_receive;
> > +    NetPrepare *prepare;
> >       NetLoad *load;
> >       NetCleanup *cleanup;
> >       LinkStatusChanged *link_status_changed;
> > diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
> > index a9bf72dcda..bbbb6d759b 100644
> > --- a/hw/net/vhost_net.c
> > +++ b/hw/net/vhost_net.c
> > @@ -244,6 +244,10 @@ static int vhost_net_start_one(struct vhost_net *n=
et,
> >       struct vhost_vring_file file =3D { };
> >       int r;
> >
> > +    if (net->nc->info->prepare) {
> > +        net->nc->info->prepare(net->nc);
> > +    }
>
>
> Any chance we can reuse load()?
>

We would be setting the ASID of CVQ after DRIVER_OK, vring
addresses... if we move to load.

Thanks!

> Thanks
>
>
> > +
> >       r =3D vhost_dev_enable_notifiers(&net->dev, dev);
> >       if (r < 0) {
> >           goto fail_notifiers;
>

