Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302E53094E8
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 12:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhA3LeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 06:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhA3LeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 06:34:00 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDB4C061573
        for <kvm@vger.kernel.org>; Sat, 30 Jan 2021 03:33:19 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id s24so599119iob.6
        for <kvm@vger.kernel.org>; Sat, 30 Jan 2021 03:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zlnOAlpg1GtSpu1xKi1eZAqDsQ7edDAr7Vp6F9yr4ik=;
        b=oNhQwU7Z4Jd/9Ln5W6pTQq+juW1tBwrhMGDBckNJt8DbF0tKgmFXzn8zVUl+7mpyFd
         Urol29lc9CJPtNATHMDIOIAdGw/4AEHmi8u61cT9b1x+lME38k4XZuBn/HfqKes4iulF
         WvjNhUxLcg6KxyXyqz9wEz9PqH7hj8yvy5+R39ueQnbub/WE/kknN1ZR5+vZpDU61LL4
         fSp/8ocIIupi1cRe5EH/xB/GsE8f+wTsCdnaaQkReo/nIbLTrvjKAnxqnJyY6IkhDDB8
         aNBV/FN3dZ7k1gV4pN2+1eGF/QX3jvttLMIt/Jb2CxRayKfJhU6+hSrPpCR8DnjMnN9a
         WSyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zlnOAlpg1GtSpu1xKi1eZAqDsQ7edDAr7Vp6F9yr4ik=;
        b=NRA9QfF26ic6n4HajPf3yK4AFCTAjhIltakkJKmoctsnznDXABiXYq02HqZWLz76rC
         FBvDCE1xUaQ0lsy60Kfi4bSEpsodKKRdL6NN1rNXp3W1otLhwvgRH4Xc1cNerxMDHpNm
         dR5MQv4RtbGQtgfJNYbVL8APROf2ygu54eJ16wd01KDYdDtfpadRjhpRQTtD5grby1Yw
         yvv7ykCckVEBXtqAu5M6BSeuKYrQCHaVjR6Y+PXCUpzyvFkIpdQ6IY5bLp6VotU6aLXy
         B78fofrt4B6K8Kw8A9J+kD2YloN99N+88YRqFRk/RvoGlnTb7JH4EcZD56+hyeCS7C37
         8Sfw==
X-Gm-Message-State: AOAM533lg13iA3VP+DAtF0PXSMgbQ47HzWdkYc0s2sOQa/6mkf8LaEO2
        hhMiMrX5syeASy48W/gjMtdc9uzyJH2x7J2CBWqz
X-Google-Smtp-Source: ABdhPJwCLF1shA14X4b/xAEjeRqRRYGA7JeKdoQy3whfagOtH+o0gP2B892A8yMhtlCU2IhMH3FMMxkyE7pdwy/8sEA=
X-Received: by 2002:a6b:7717:: with SMTP id n23mr6665293iom.73.1612006399320;
 Sat, 30 Jan 2021 03:33:19 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119045920.447-4-xieyongji@bytedance.com>
 <310d7793-e4ff-fba3-f358-418cb64c7988@redhat.com> <20210120110832.oijcmywq7pf7psg3@steredhat>
 <1979cffc-240e-a9f9-b0ab-84a1f82ac81e@redhat.com> <20210127085728.j6x5yzrldp2wp55c@steredhat>
 <3cb239f5-fdd5-8311-35a0-c0f50b552521@redhat.com> <20210129150359.caitcskrfhqed73z@steredhat>
In-Reply-To: <20210129150359.caitcskrfhqed73z@steredhat>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Sat, 30 Jan 2021 19:33:08 +0800
Message-ID: <CACycT3sTx+NGg1iB8gmFbOPfzCvnq5F0nd2ePGs2_BUeU=-2_Q@mail.gmail.com>
Subject: Re: Re: [RFC v3 03/11] vdpa: Remove the restriction that only
 supports virtio-net devices
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 29, 2021 at 11:04 PM Stefano Garzarella <sgarzare@redhat.com> w=
rote:
>
> On Thu, Jan 28, 2021 at 11:11:49AM +0800, Jason Wang wrote:
> >
> >On 2021/1/27 =E4=B8=8B=E5=8D=884:57, Stefano Garzarella wrote:
> >>On Wed, Jan 27, 2021 at 11:33:03AM +0800, Jason Wang wrote:
> >>>
> >>>On 2021/1/20 =E4=B8=8B=E5=8D=887:08, Stefano Garzarella wrote:
> >>>>On Wed, Jan 20, 2021 at 11:46:38AM +0800, Jason Wang wrote:
> >>>>>
> >>>>>On 2021/1/19 =E4=B8=8B=E5=8D=8812:59, Xie Yongji wrote:
> >>>>>>With VDUSE, we should be able to support all kinds of virtio device=
s.
> >>>>>>
> >>>>>>Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>>>>>---
> >>>>>> drivers/vhost/vdpa.c | 29 +++--------------------------
> >>>>>> 1 file changed, 3 insertions(+), 26 deletions(-)
> >>>>>>
> >>>>>>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> >>>>>>index 29ed4173f04e..448be7875b6d 100644
> >>>>>>--- a/drivers/vhost/vdpa.c
> >>>>>>+++ b/drivers/vhost/vdpa.c
> >>>>>>@@ -22,6 +22,7 @@
> >>>>>> #include <linux/nospec.h>
> >>>>>> #include <linux/vhost.h>
> >>>>>> #include <linux/virtio_net.h>
> >>>>>>+#include <linux/virtio_blk.h>
> >>>>>> #include "vhost.h"
> >>>>>>@@ -185,26 +186,6 @@ static long
> >>>>>>vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user
> >>>>>>*statusp)
> >>>>>>     return 0;
> >>>>>> }
> >>>>>>-static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
> >>>>>>-                      struct vhost_vdpa_config *c)
> >>>>>>-{
> >>>>>>-    long size =3D 0;
> >>>>>>-
> >>>>>>-    switch (v->virtio_id) {
> >>>>>>-    case VIRTIO_ID_NET:
> >>>>>>-        size =3D sizeof(struct virtio_net_config);
> >>>>>>-        break;
> >>>>>>-    }
> >>>>>>-
> >>>>>>-    if (c->len =3D=3D 0)
> >>>>>>-        return -EINVAL;
> >>>>>>-
> >>>>>>-    if (c->len > size - c->off)
> >>>>>>-        return -E2BIG;
> >>>>>>-
> >>>>>>-    return 0;
> >>>>>>-}
> >>>>>
> >>>>>
> >>>>>I think we should use a separate patch for this.
> >>>>
> >>>>For the vdpa-blk simulator I had the same issues and I'm adding
> >>>>a .get_config_size() callback to vdpa devices.
> >>>>
> >>>>Do you think make sense or is better to remove this check in
> >>>>vhost/vdpa, delegating the boundaries checks to
> >>>>get_config/set_config callbacks.
> >>>
> >>>
> >>>A question here. How much value could we gain from
> >>>get_config_size() consider we can let vDPA parent to validate the
> >>>length in its get_config().
> >>>
> >>
> >>I agree, most of the implementations already validate the length,
> >>the only gain is an error returned since get_config() is void, but
> >>eventually we can add a return value to it.
> >
> >
> >Right, one problem here is that. For the virito path, its get_config()
> >returns void. So we can not propagate error to virtio drivers. But it
> >might not be a big issue since we trust kernel virtio driver.
> >
> >So I think it makes sense to change the return value in the vdpa config =
ops.
>
> Thanks for your feedback!
>
> @Xie do you plan to do this?
>
> Otherwise I can do in my vdpa-blk-sim series, where for now I used this
> patch as is.
>

Hi Stefano, please do in your vdpa-blk-sim series. I have no plan for it no=
w.

Thanks,
Yongji
