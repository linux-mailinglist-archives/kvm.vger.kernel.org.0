Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DC3520F3E
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 09:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbiEJIBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 04:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237581AbiEJIA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 04:00:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E6DD1E325C
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 00:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652169408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/c1ztnUjsSvwMC8tPkMNFQeFrqhGiOZ2N5BrE2wTqhY=;
        b=FqHnGCcpuQn8sRN2GUjL11mhx/FdGlMXFuLHXn4sLOMYDud1GR8sM2Pho8ivUmoSVVGHvz
        DlOftJMpB6OLgBc2c0KpnoNu/UxRoyJwaxKBwDzEfVRxo+uNPCpRgrxb3A1XYmSXFmzqAH
        XhEB2oDiQsjb0xQvJQfvX+DZHpb4Pqg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-hURoXJ8KPUqSjc5JfORDOg-1; Tue, 10 May 2022 03:56:45 -0400
X-MC-Unique: hURoXJ8KPUqSjc5JfORDOg-1
Received: by mail-lf1-f69.google.com with SMTP id h15-20020ac24daf000000b00472586ed83dso6916103lfe.22
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 00:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/c1ztnUjsSvwMC8tPkMNFQeFrqhGiOZ2N5BrE2wTqhY=;
        b=bPMfPgU/x96kIE/h+84H3AKD0W5JRFKueOS1k6HKs2m8fmS92/BtoeLIjgP2UF00kv
         38E9LCHKt3dDc0V+Y2nCfnBPupwxXftJRRodxl3e3aiHvoOPjUOxawhelG2WogfBCQMN
         8G8tQ82GarCuTLdtXaCapUw0d7As9bsXNYJ6/Y+/utTjLaxemA0WRHJfaws/R2VfEcyE
         DzY4Ziy+2j1xskV/Ir8jLRJA7ce0av3l21f5aKs5/PooVggusP/mvpIstTvtFASuiWLY
         1tLIy8axlzlDwki0L8EZwuWxbg+eYH4cXKkRwHOohzRJruBwM3gHEZww53Xpfl6q0HOW
         NcGg==
X-Gm-Message-State: AOAM5309unUsqtwa4REWtNrTD1sgoYhchQV2cLOMBBWWEjpY2f3zFmRi
        Bs1vWaOMLeZW52Nzi5z1l+T7lJcT6H6j2vDgnkhknZqjLcrPd8X0Di3eDzl8d9G0SCsw+T325A9
        ctBQbjQbb1GpyLANLBWXT3hKnDHNP
X-Received: by 2002:a19:ca50:0:b0:471:f556:92b with SMTP id h16-20020a19ca50000000b00471f556092bmr15479994lfj.587.1652169404075;
        Tue, 10 May 2022 00:56:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxD3QYQhNm8OOhmYu9K618fwpvK2JHxPPxaipeoPj14mMMrx2E9jL681mf6nCwBi/RMtwvLQ6FsFANB6ecwX0c=
X-Received: by 2002:a19:ca50:0:b0:471:f556:92b with SMTP id
 h16-20020a19ca50000000b00471f556092bmr15479980lfj.587.1652169403887; Tue, 10
 May 2022 00:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220505100910.137-1-xieyongji@bytedance.com> <CACGkMEv3Ofbu7OOTB9vN2Lt85TD44LipjoPm26KEq3RiKJU0Yw@mail.gmail.com>
 <CACycT3uakPB_JeXb11hrBaPjcdqign3FmuQd3FXgFR7orO_Eaw@mail.gmail.com>
In-Reply-To: <CACycT3uakPB_JeXb11hrBaPjcdqign3FmuQd3FXgFR7orO_Eaw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 10 May 2022 15:56:33 +0800
Message-ID: <CACGkMEu72zPKyZXWvyeMsNwjKohXHEMu_hp1dwPVF_2RF5ezPA@mail.gmail.com>
Subject: Re: [PATCH v2] vringh: Fix loop descriptors check in the indirect cases
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     mst <mst@redhat.com>, rusty <rusty@rustcorp.com.au>,
        fam.zheng@bytedance.com, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 3:54 PM Yongji Xie <xieyongji@bytedance.com> wrote:
>
> On Tue, May 10, 2022 at 3:44 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Thu, May 5, 2022 at 6:08 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> > >
> > > We should use size of descriptor chain to test loop condition
> > > in the indirect case. And another statistical count is also introduced
> > > for indirect descriptors to avoid conflict with the statistical count
> > > of direct descriptors.
> > >
> > > Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
> > > ---
> > >  drivers/vhost/vringh.c | 10 ++++++++--
> > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > > index 14e2043d7685..eab55accf381 100644
> > > --- a/drivers/vhost/vringh.c
> > > +++ b/drivers/vhost/vringh.c
> > > @@ -292,7 +292,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
> > >              int (*copy)(const struct vringh *vrh,
> > >                          void *dst, const void *src, size_t len))
> > >  {
> > > -       int err, count = 0, up_next, desc_max;
> > > +       int err, count = 0, indirect_count = 0, up_next, desc_max;
> > >         struct vring_desc desc, *descs;
> > >         struct vringh_range range = { -1ULL, 0 }, slowrange;
> > >         bool slow = false;
> > > @@ -349,7 +349,12 @@ __vringh_iov(struct vringh *vrh, u16 i,
> > >                         continue;
> > >                 }
> > >
> > > -               if (count++ == vrh->vring.num) {
> > > +               if (up_next == -1)
> > > +                       count++;
> > > +               else
> > > +                       indirect_count++;
> > > +
> > > +               if (count > vrh->vring.num || indirect_count > desc_max) {
> > >                         vringh_bad("Descriptor loop in %p", descs);
> > >                         err = -ELOOP;
> > >                         goto fail;
> > > @@ -411,6 +416,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
> > >                                 i = return_from_indirect(vrh, &up_next,
> > >                                                          &descs, &desc_max);
> > >                                 slow = false;
> > > +                               indirect_count = 0;
> >
> > Do we need to reset up_next to -1 here?
> >
>
> It will be reset to -1 in return_from_indirect().

Right. Then

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

>
> Thanks,
> Yongji
>

