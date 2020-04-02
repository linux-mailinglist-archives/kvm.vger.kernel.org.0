Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF9719C17A
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 14:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388416AbgDBMyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 08:54:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45567 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387580AbgDBMyI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 08:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585832046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e+rpGY/lQzxU62GHHMv3q/FRvIYAGToP29ghNExNLYc=;
        b=RnfgyI9+oyMc3AuIbdtm6rrOc3vRp8y16aj+7KDdObR1zzjbELDemQJmQ9nBAXDh0CqtV7
        YshEO7NY2ybY+RRJA+t7j8A5HewgLXpKDX1h6aH+CcXS7hVnEpPdSw4jB21r8h0vX4Qdif
        AFFzVnrGAy8DXyTnyC1hpHpujER3UUw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-WHt0dfhIPymY9X3EoyvkZQ-1; Thu, 02 Apr 2020 08:54:05 -0400
X-MC-Unique: WHt0dfhIPymY9X3EoyvkZQ-1
Received: by mail-qv1-f70.google.com with SMTP id j7so2540509qvy.22
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 05:54:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=e+rpGY/lQzxU62GHHMv3q/FRvIYAGToP29ghNExNLYc=;
        b=KUm0rmThkvAhiLIW6jIXId+jD5SLkxJ3wA0zCENudxi0Q679W+fsmizr8BF/jlz0zD
         1EG6e9gOHeDjB9VozfaWGS/fV/GR/Rd3NWkXJifSG8NXkGEjMADowFy0WUOIift7FB+Y
         lE2VUdXFtfVCh7n4gyZVT/7bXPJhh1kRRjl5EJIruTvX5CBwUo77DzG3yIC4iOl7ubvI
         b98RbLrEXy9AZ1m7O0/dbKwoz9XhPuDfcRqzf0rmqCJuBFHaqA1wdWqsHhGMhaht6anz
         ku2iLlydHYtcxEj8klE3AimLhjCFESoUGM30zGjWm0D8ANA4Dkh5b28Ugak49tuAjz6w
         IMPQ==
X-Gm-Message-State: AGi0PuZl6QrpicLYnaBxmj3OP78T0nCBNe+6JjQGdfDj/1xjaFZxTKUh
        aqJuebjnjTpBkyyIUEuLSe6Yev/u0LNuPFToFsZrBS/h5wCAVbkLDLOTu02dpcI/DwXGiubtOn3
        VG4Y2THfGUhGK
X-Received: by 2002:a37:b17:: with SMTP id 23mr3444712qkl.326.1585832044803;
        Thu, 02 Apr 2020 05:54:04 -0700 (PDT)
X-Google-Smtp-Source: APiQypKWAXrSE3QY71rFZEVKPyM9P23H/+nJyT2FOKqzUpxwU6y4/YNd29YMt69nqsRb7v9SGkCigg==
X-Received: by 2002:a37:b17:: with SMTP id 23mr3444679qkl.326.1585832044434;
        Thu, 02 Apr 2020 05:54:04 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id m27sm3713948qtf.80.2020.04.02.05.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 05:54:03 -0700 (PDT)
Date:   Thu, 2 Apr 2020 08:53:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] virtio/test: fix up after IOTLB changes
Message-ID: <20200402084021-mutt-send-email-mst@kernel.org>
References: <20200401165100.276039-1-mst@redhat.com>
 <921fe999-e183-058d-722a-1a6a6ab066e0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <921fe999-e183-058d-722a-1a6a6ab066e0@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 12:01:56PM +0800, Jason Wang wrote:
> 
> On 2020/4/2 上午12:51, Michael S. Tsirkin wrote:
> > Allow building vringh without IOTLB (that's the case for userspace
> > builds, will be useful for CAIF/VOD down the road too).
> > Update for API tweaks.
> > Don't include vringh with kernel builds.
> 
> 
> I'm not quite sure we need this.
> 
> E.g the userspace accessor is not used by CAIF/VOP.

Well any exported symbols are always compiled in, right?
So we can save some kernel memory by not building unused stuff ...


> > 
> > Cc: Jason Wang <jasowang@redhat.com>
> > Cc: Eugenio Pérez <eperezma@redhat.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >   drivers/vhost/test.c   | 4 ++--
> >   drivers/vhost/vringh.c | 5 +++++
> >   include/linux/vringh.h | 2 ++
> >   tools/virtio/Makefile  | 3 ++-
> >   4 files changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> > index 394e2e5c772d..9a3a09005e03 100644
> > --- a/drivers/vhost/test.c
> > +++ b/drivers/vhost/test.c
> > @@ -120,7 +120,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
> >   	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
> >   	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
> >   	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
> > -		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT);
> > +		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, NULL);
> >   	f->private_data = n;
> > @@ -225,7 +225,7 @@ static long vhost_test_reset_owner(struct vhost_test *n)
> >   {
> >   	void *priv = NULL;
> >   	long err;
> > -	struct vhost_umem *umem;
> > +	struct vhost_iotlb *umem;
> >   	mutex_lock(&n->dev.mutex);
> >   	err = vhost_dev_check_owner(&n->dev);
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index ee0491f579ac..878e565dfffe 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -13,9 +13,11 @@
> >   #include <linux/uaccess.h>
> >   #include <linux/slab.h>
> >   #include <linux/export.h>
> > +#ifdef VHOST_IOTLB
> 
> 
> Kbuild bot reports build issues with this.
> 
> It looks to me we should use #if IS_ENABLED(CONFIG_VHOST_IOTLB) here and
> following checks.
> 
> Thanks
> 

In fact IS_REACHEABLE is probably the right thing to do.


> 
> >   #include <linux/bvec.h>
> >   #include <linux/highmem.h>
> >   #include <linux/vhost_iotlb.h>
> > +#endif
> >   #include <uapi/linux/virtio_config.h>
> >   static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
> > @@ -1059,6 +1061,8 @@ int vringh_need_notify_kern(struct vringh *vrh)
> >   }
> >   EXPORT_SYMBOL(vringh_need_notify_kern);
> > +#ifdef VHOST_IOTLB
> > +
> >   static int iotlb_translate(const struct vringh *vrh,
> >   			   u64 addr, u64 len, struct bio_vec iov[],
> >   			   int iov_size, u32 perm)
> > @@ -1416,5 +1420,6 @@ int vringh_need_notify_iotlb(struct vringh *vrh)
> >   }
> >   EXPORT_SYMBOL(vringh_need_notify_iotlb);
> > +#endif
> >   MODULE_LICENSE("GPL");
> > diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> > index bd0503ca6f8f..ebff121c0b02 100644
> > --- a/include/linux/vringh.h
> > +++ b/include/linux/vringh.h
> > @@ -14,8 +14,10 @@
> >   #include <linux/virtio_byteorder.h>
> >   #include <linux/uio.h>
> >   #include <linux/slab.h>
> > +#ifdef VHOST_IOTLB
> >   #include <linux/dma-direction.h>
> >   #include <linux/vhost_iotlb.h>
> > +#endif
> >   #include <asm/barrier.h>
> >   /* virtio_ring with information needed for host access. */
> > diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
> > index f33f32f1d208..d3f152f4660b 100644
> > --- a/tools/virtio/Makefile
> > +++ b/tools/virtio/Makefile
> > @@ -22,7 +22,8 @@ OOT_CONFIGS=\
> >   	CONFIG_VHOST=m \
> >   	CONFIG_VHOST_NET=n \
> >   	CONFIG_VHOST_SCSI=n \
> > -	CONFIG_VHOST_VSOCK=n
> > +	CONFIG_VHOST_VSOCK=n \
> > +	CONFIG_VHOST_RING=n
> >   OOT_BUILD=KCFLAGS="-I "${OOT_VHOST} ${MAKE} -C ${OOT_KSRC} V=${V}
> >   oot-build:
> >   	echo "UNSUPPORTED! Don't use the resulting modules in production!"

