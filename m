Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8B52F42EE
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 05:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbhAMEOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 23:14:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726341AbhAMEOe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 23:14:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610511187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2uX+184DuL6+IbX64Mwow/W3eFyTHIEtajxhKilUb2U=;
        b=ioac+Wmu6mkdsW1k9LjGCeTztNpAIMssp8SXUPMk7jVl73+3p1VKCOV7AzWKV3IN8yZTTv
        wetVVvYI2aE4+9Az0/wwQLxoaw7QPyUVlvMJ8GV/CjUzVwVPmkIH9UkwJUbUVOp7aAQC+g
        qgpFtifzZjj7B3yskrO5UjrlgvB8DeM=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-R075pr2CM5WWI3Pj0IY7dg-1; Tue, 12 Jan 2021 23:13:03 -0500
X-MC-Unique: R075pr2CM5WWI3Pj0IY7dg-1
Received: by mail-pf1-f197.google.com with SMTP id 15so546685pfu.6
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 20:13:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2uX+184DuL6+IbX64Mwow/W3eFyTHIEtajxhKilUb2U=;
        b=fY9p2cmkvFsChC+SDB0z+f/nBlbiJkYXUasJw+D7MjQs0tsMb7ytUqW7Fvz41cS205
         mmpBwQOPQl4aEUHRuGgCWp8cvTjPQpdm5Y7gQJ8BWvZVYqrP4s3jbxFecBHVzhk8QcAu
         ukBJ0apyiXuqqhtZFo7ha4/HTpMfhKMGDfVhz+jVH+gkAbvljF7tw0NQCy9XA1PeS48S
         BiyIXZjnIIfxdnymD1NrLKQEfYStsjQNMVHTCtZM/+vwnUaJYg6ALRPAWeDKHGZsjiwX
         myPzhbqP0QEnJhHdTRqR/NXs2ZUCjHWhDRN25pcbkEcuOrtQa7J2TyLbvaqLq/HGlQb2
         DFjw==
X-Gm-Message-State: AOAM532VBdItVKOFfWHLx9zogIDBRyVTDAi7PpvjWQZNRqvVHjTymmIA
        cFmgCkQCjnj4y6SR8Ho7ZuM/h/Bai130k4dKXr3L/cvbE6exsaZ5pxXPuwnCISAgglbqKPuG3Bo
        mC6iklA1JPDhR6ZBU9uzbDxHsommq
X-Received: by 2002:a17:902:8a8a:b029:db:e003:4044 with SMTP id p10-20020a1709028a8ab02900dbe0034044mr366028plo.19.1610511182729;
        Tue, 12 Jan 2021 20:13:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJynudTkku66m+FnxiitvS/UCRuOamqko46/CvqV825uh3S7t3CEzojH3Xb6x1N1Bhbp9yNW4vMWEWRPv+P7H60=
X-Received: by 2002:a17:902:8a8a:b029:db:e003:4044 with SMTP id
 p10-20020a1709028a8ab02900dbe0034044mr366015plo.19.1610511182494; Tue, 12 Jan
 2021 20:13:02 -0800 (PST)
MIME-Version: 1.0
References: <20210112053629.9853-1-lulu@redhat.com> <1403c336-4493-255f-54e3-c55dd2015c40@redhat.com>
In-Reply-To: <1403c336-4493-255f-54e3-c55dd2015c40@redhat.com>
From:   Cindy Lu <lulu@redhat.com>
Date:   Wed, 13 Jan 2021 12:12:25 +0800
Message-ID: <CACLfguVi7XZ_HR4Gxcc3=_XHZnZ8q2bcuJcqEuu56E+MCZB+RA@mail.gmail.com>
Subject: Re: [PATCH v3] vhost_vdpa: fix the problem in vhost_vdpa_set_config_call
To:     Jason Wang <jasowang@redhat.com>
Cc:     Michael Tsirkin <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 13, 2021 at 11:38 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/12 =E4=B8=8B=E5=8D=881:36, Cindy Lu wrote:
> > In vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.
> > this cb.private will finally use in vhost_vdpa_config_cb as
> > vhost_vdpa. Fix this issue.
> >
> > Fixes: 776f395004d82 ("vhost_vdpa: Support config interrupt in vdpa")
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
>
>
> Hi Cindy:
>
> I think at least you forget to cc stable.
>
> Thanks
>
Sure Thanks Jason I will post a new version
>
> >   drivers/vhost/vdpa.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index ef688c8c0e0e..3fbb9c1f49da 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -319,7 +319,7 @@ static long vhost_vdpa_set_config_call(struct vhost=
_vdpa *v, u32 __user *argp)
> >       struct eventfd_ctx *ctx;
> >
> >       cb.callback =3D vhost_vdpa_config_cb;
> > -     cb.private =3D v->vdpa;
> > +     cb.private =3D v;
> >       if (copy_from_user(&fd, argp, sizeof(fd)))
> >               return  -EFAULT;
> >
>

