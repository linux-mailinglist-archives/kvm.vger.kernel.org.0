Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213D553B2D3
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 06:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiFBEzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 00:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiFBEzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 00:55:00 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8C1DE332
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 21:54:59 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id n28so4741020edb.9
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 21:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CT5U1CNgwxidSdv3BAoIuCkc8N49tG8Y3S2gxdkEwQc=;
        b=qFLx03JiHRMRBF2tUKlivLscBJuszLtEorC4CphQhJPIYRPWkbUsJaf6JKz4cXlBsI
         RbuJqveOOZTmtYVWoBNRBBZYsxyWXOfnIv1PyKojemfoXaaMFEnbR4RkvZ6e2MlITMgz
         xndE4Kp0Ph9+YZleH3O20DAsAto/bZYRwYX0uCXA6HVMLpG09rxZFUdqJXRHw58CqO76
         CLDUc56DRzvxBmzGGg7xrhd42BPOSWqJHh4OU84ygOVOD6lJFfRC8pkHxq31cvodvxm2
         vuJRSMDlEWxawFB2Hm7bXeMKkDyioPuFWfxCITD7i2XBeB1OE4A56Evf28OvuPvi1i/H
         wzgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CT5U1CNgwxidSdv3BAoIuCkc8N49tG8Y3S2gxdkEwQc=;
        b=ttuil0QleOiGWIw9V1/F4/XwQV+Sl5876uJ4CPX2ZAuM+GQWVqbTSNJTogxYpgLRqF
         y/6KobB7CT9jEIGXyXqKzVFDgMtzf++Cm95tE9AfEHpVlUU6RZvrM9mFIAMf5rTTqkNj
         bakaHTWeGoAp/Gt6QtgOrRTV13tj4GCJuod8wvIo37Z56ArmhptGa+xJmW8abA7TiOPz
         e9QoX2vvse+1lMnh4R3saYIy9QL5QS9TWL8K2eOJuhEueAcYFCB85K3XBM5dCx87fjOX
         8mqdNmthkoqxBhgwO1GFmiIR0IAOjGZ7luIKNu111/iN8nQrjl/azxQduaLP6g585Xpr
         QK2g==
X-Gm-Message-State: AOAM533RuoQP9vg/46RkRfrZkkhY2r9Fv0C1xKHYjUaHof1r8+NcQM4O
        XQmO9wVnC/xnMWet6u4eY/owT2ai/flk9g43IY78
X-Google-Smtp-Source: ABdhPJy2nzbxpIUDhQw/9Q2i5yD2iJuGOy+CCGclsFLoGzrVa/htZh2BxqdApawF1bsXoBkus+DOa+5Pxk2GC8LRS2w=
X-Received: by 2002:a05:6402:254e:b0:42b:4633:e53e with SMTP id
 l14-20020a056402254e00b0042b4633e53emr3354727edb.314.1654145697926; Wed, 01
 Jun 2022 21:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220505100910.137-1-xieyongji@bytedance.com> <CACGkMEv3Ofbu7OOTB9vN2Lt85TD44LipjoPm26KEq3RiKJU0Yw@mail.gmail.com>
 <CACycT3uakPB_JeXb11hrBaPjcdqign3FmuQd3FXgFR7orO_Eaw@mail.gmail.com> <CACGkMEu72zPKyZXWvyeMsNwjKohXHEMu_hp1dwPVF_2RF5ezPA@mail.gmail.com>
In-Reply-To: <CACGkMEu72zPKyZXWvyeMsNwjKohXHEMu_hp1dwPVF_2RF5ezPA@mail.gmail.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 2 Jun 2022 12:55:50 +0800
Message-ID: <CACycT3v8bo=6YHmb-F3fEjVSCsJdWSLwLy4RTz6hCW39FAZZPA@mail.gmail.com>
Subject: Re: [PATCH v2] vringh: Fix loop descriptors check in the indirect cases
To:     mst <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc:     rusty <rusty@rustcorp.com.au>, fam.zheng@bytedance.com,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping.

On Tue, May 10, 2022 at 3:56 PM Jason Wang <jasowang@redhat.com> wrote:
>
> On Tue, May 10, 2022 at 3:54 PM Yongji Xie <xieyongji@bytedance.com> wrote:
> >
> > On Tue, May 10, 2022 at 3:44 PM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > > On Thu, May 5, 2022 at 6:08 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> > > >
> > > > We should use size of descriptor chain to test loop condition
> > > > in the indirect case. And another statistical count is also introduced
> > > > for indirect descriptors to avoid conflict with the statistical count
> > > > of direct descriptors.
> > > >
> > > > Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
> > > > ---
> > > >  drivers/vhost/vringh.c | 10 ++++++++--
> > > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > > > index 14e2043d7685..eab55accf381 100644
> > > > --- a/drivers/vhost/vringh.c
> > > > +++ b/drivers/vhost/vringh.c
> > > > @@ -292,7 +292,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
> > > >              int (*copy)(const struct vringh *vrh,
> > > >                          void *dst, const void *src, size_t len))
> > > >  {
> > > > -       int err, count = 0, up_next, desc_max;
> > > > +       int err, count = 0, indirect_count = 0, up_next, desc_max;
> > > >         struct vring_desc desc, *descs;
> > > >         struct vringh_range range = { -1ULL, 0 }, slowrange;
> > > >         bool slow = false;
> > > > @@ -349,7 +349,12 @@ __vringh_iov(struct vringh *vrh, u16 i,
> > > >                         continue;
> > > >                 }
> > > >
> > > > -               if (count++ == vrh->vring.num) {
> > > > +               if (up_next == -1)
> > > > +                       count++;
> > > > +               else
> > > > +                       indirect_count++;
> > > > +
> > > > +               if (count > vrh->vring.num || indirect_count > desc_max) {
> > > >                         vringh_bad("Descriptor loop in %p", descs);
> > > >                         err = -ELOOP;
> > > >                         goto fail;
> > > > @@ -411,6 +416,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
> > > >                                 i = return_from_indirect(vrh, &up_next,
> > > >                                                          &descs, &desc_max);
> > > >                                 slow = false;
> > > > +                               indirect_count = 0;
> > >
> > > Do we need to reset up_next to -1 here?
> > >
> >
> > It will be reset to -1 in return_from_indirect().
>
> Right. Then
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> Thanks
>
> >
> > Thanks,
> > Yongji
> >
>
