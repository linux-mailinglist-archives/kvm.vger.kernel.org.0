Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C192F42F3
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 05:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbhAMEPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 23:15:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26120 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726416AbhAMEPT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 23:15:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610511233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UfDrAPvjsoYVMqNEVx94XHjGqbWNvX3wApkmUTM+rnQ=;
        b=Ui9U/WeoHyKUNL4RMn6j9AzeRCVwVIw6LovmI0z1tSXsZT12oSwV03P4QZyGFNurMQGRVS
        +VzUXJ0UVzOFfVrvFmAuxjRELyDdjfqpOXJuXlIl5CpH1DtY/LeF4hT+B8jfdm+lVUV0Fq
        WqVkgJ4Jm7CQeW1gZCOYAoQFzjFn78w=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-WbX0k5s1NHuEF5FLOj-TWQ-1; Tue, 12 Jan 2021 23:13:51 -0500
X-MC-Unique: WbX0k5s1NHuEF5FLOj-TWQ-1
Received: by mail-pf1-f200.google.com with SMTP id e126so534370pfh.15
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 20:13:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UfDrAPvjsoYVMqNEVx94XHjGqbWNvX3wApkmUTM+rnQ=;
        b=DkIq6vXek9j5J2Hrijh1Hep0MqqkBpKeMpUqP4d1S0S7s512Fvwa3Da2IjNAt2ZgGu
         j81uKjtRagdeea9WveK11QiD76KgmCXdFPYZ+8yqeU4C2Si/wAMMbnrDWFsn1roSxHHE
         iFBelfj4Yc9ycQso/l1s+M/wsDJ+1C3iAOnDtvpyFL7LTclBZWaDURhp6dnoJmTOvRvO
         HYH52NWrkbC7NlKIKhKHkZgOjhyQKi1U8/NgLuhdqiSYuWLmWK5UJxuwFVHJBMgehbXJ
         kJdIzlnBihV4VpR2FcMwuxm8rT8jyYDV7M8z1tJeMfuLTPgd/2zXWQHxKIDn5OjaSCrZ
         zdtw==
X-Gm-Message-State: AOAM530AWyKOwhd7p8uK0XkJgXsIT6+Lgh2AHThXS0UTnEs2oyHj7+NY
        BoLSHUZeHJNyNsi/mTIu/ER0tlNY385PIOdk1yhl2APAD43+xxl2jnAGlLWxW7q8fbYzuwgRIuC
        fN49K7/t1VrQ8U9hi/NtmdQOtkhVt
X-Received: by 2002:aa7:97bc:0:b029:19e:18c7:76b with SMTP id d28-20020aa797bc0000b029019e18c7076bmr270869pfq.23.1610511230809;
        Tue, 12 Jan 2021 20:13:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwL2OenbuBUblwlUNcw3x1ULR/Z+jRldpO3boKIQ/Xb8tMIvpRP21VUS+e1MBM0V79w64PV65ol/7dXaBACQ0E=
X-Received: by 2002:aa7:97bc:0:b029:19e:18c7:76b with SMTP id
 d28-20020aa797bc0000b029019e18c7076bmr270848pfq.23.1610511230515; Tue, 12 Jan
 2021 20:13:50 -0800 (PST)
MIME-Version: 1.0
References: <20210112053629.9853-1-lulu@redhat.com> <X/1Up+fcTcYq2osi@kroah.com>
In-Reply-To: <X/1Up+fcTcYq2osi@kroah.com>
From:   Cindy Lu <lulu@redhat.com>
Date:   Wed, 13 Jan 2021 12:13:14 +0800
Message-ID: <CACLfguUbB08xCZ5hk3+8jHGZtBy_YC4twuxpEf-MvKAJHq46Xg@mail.gmail.com>
Subject: Re: [PATCH v3] vhost_vdpa: fix the problem in vhost_vdpa_set_config_call
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jason Wang <jasowang@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 3:53 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 12, 2021 at 01:36:29PM +0800, Cindy Lu wrote:
> > In vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.
> > this cb.private will finally use in vhost_vdpa_config_cb as
> > vhost_vdpa. Fix this issue.
> >
> > Fixes: 776f395004d82 ("vhost_vdpa: Support config interrupt in vdpa")
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
> >  drivers/vhost/vdpa.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>
>
Thanks Greg, I will fix this and send a new version

