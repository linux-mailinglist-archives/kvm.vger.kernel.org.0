Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3554A41C0FC
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 10:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244906AbhI2Ixw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 04:53:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244764AbhI2Ixu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 04:53:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632905530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2IuDph5pgXKhZLx55AOzdRIaR0YtM8hQePA5+y0Dae8=;
        b=PY1sbZAkUKZ2kHeGD2/NDQeHtIb2yfD988eNhXZ2F4X+FCCy/+7uVFYKh9uZsazFChywEQ
        tEDVhjcME3ZwTJgxFzD8RcqGXIBQCaXZh5YghnlpnadTKfHpjfRkGCr2MnfjLAuYsql8iP
        EW68D+Rs2s+U9KaAiUjc9pDcqE0x3Ko=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-BO48wGVeNVmprpTPunD4KA-1; Wed, 29 Sep 2021 04:52:08 -0400
X-MC-Unique: BO48wGVeNVmprpTPunD4KA-1
Received: by mail-ed1-f70.google.com with SMTP id h6-20020a50c386000000b003da01adc065so1670464edf.7
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 01:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2IuDph5pgXKhZLx55AOzdRIaR0YtM8hQePA5+y0Dae8=;
        b=GkXaCs802QtEL7mPgbxTw2jFtRx3Pj/TRvUSpY7akcB185LRk5Teaiwz+BAcT6oso5
         n50jgPaSbfX3ejqeJlr+H7/F8ljqzLzokR/j+UncClBHi9GmMrnLaOPMgtg25pGOvGc5
         Wm7jD3C3DcxuxaMzZaTqMvwZ07D/ndSb+/kal1DeVxxnto0JRi8j7vDmT0YFZDX4fJO0
         8napyWIR0J0obakueq6Zl/nfA5czk9EI5HU1EYexWkIJ7YFHdhX2wRjXMwGkLO07gevp
         3b4WBdkdcfbUOVtkM3dgzGp7hfhMo4E8qF95CXk/pEo9EeN3Tbng/VVfcamJ77vUh0le
         CB1w==
X-Gm-Message-State: AOAM530TFPOkkrV81YLvrthW42Ai1EAV7TRSjW7SKYr6zScRVauVvjnf
        FR1xNyez/ofNT4nDw8PF/GEXrC0ROnbXnAUpHmp3Z6fuctnzBhaDuzw1mYcp7bnnD+Il2YuXuwT
        Q2UWKcMgH2PQWiyuyg/uDjOh0gO0C
X-Received: by 2002:a17:906:840f:: with SMTP id n15mr12381707ejx.336.1632905527366;
        Wed, 29 Sep 2021 01:52:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtqxbpW9CaUe0Zk3O9ATbb6SACyGDKbqk1vQT4Q7fBlmtOJCKDORBVyAo1j/qBryhevc0gJzRnOU81x+LCRFw=
X-Received: by 2002:a17:906:840f:: with SMTP id n15mr12381683ejx.336.1632905527171;
 Wed, 29 Sep 2021 01:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210929075437.12985-1-lulu@redhat.com> <20210929043142-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210929043142-mutt-send-email-mst@kernel.org>
From:   Cindy Lu <lulu@redhat.com>
Date:   Wed, 29 Sep 2021 16:51:29 +0800
Message-ID: <CACLfguX3TPD0VOUngNVDzB_JYPY6AnPP+Jd7bAKTq5egXw93sA@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa:fix the worng input in config_cb
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 4:32 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Sep 29, 2021 at 03:54:37PM +0800, Cindy Lu wrote:
> > Fix the worng input in for config_cb,
> > in function vhost_vdpa_config_cb, the input
> > cb.private was used as struct vhost_vdpa,
> > So the inuput was worng here, fix this issue
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
>
> Maybe add
>
> Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
>
> and fix typos in the commit log.
>
thanks Michael, I will post a new version
> > ---
> >  drivers/vhost/vdpa.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 942666425a45..e532cbe3d2f7 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -322,7 +322,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
> >       struct eventfd_ctx *ctx;
> >
> >       cb.callback = vhost_vdpa_config_cb;
> > -     cb.private = v->vdpa;
> > +     cb.private = v;
> >       if (copy_from_user(&fd, argp, sizeof(fd)))
> >               return  -EFAULT;
> >
> > --
> > 2.21.3
>

