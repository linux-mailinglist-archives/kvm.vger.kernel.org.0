Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47573115EB
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 23:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhBEWpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 17:45:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230029AbhBENe0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 08:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612531965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cUMsU3NGZgFC5JmllXsuFgXrYMXysZpJsQ4q9x7smF0=;
        b=ZazAXY3lkCu+qkYRJdzmQPvJqUxZL2wnufmXGDDLd79lMLVakHASZ5P69iY9aWbT8lPDnF
        DCgFBl+HW4DWZrzHCrCsZuvrmqUxcE3RpmhQWMvtsCKVbSfNdE+brV6S/IF+IEP8UzdC8+
        wtlzlrWSzLP9SE6rK8GH7RMMfocNCMA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-4MOdunk2PSyHfxqxjr63Jw-1; Fri, 05 Feb 2021 08:32:42 -0500
X-MC-Unique: 4MOdunk2PSyHfxqxjr63Jw-1
Received: by mail-wr1-f71.google.com with SMTP id c1so5436815wrx.2
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 05:32:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cUMsU3NGZgFC5JmllXsuFgXrYMXysZpJsQ4q9x7smF0=;
        b=apX6jvCGKjXSSdC1FrTw/IeXJcwZk7tfwGgDiEKRDQJ891folUVALmEWj1BCb1VeO2
         o5QDSQIent9jmpJ9nQnnj13bM9kxDjVQm3xjw1EsgK2UuJwCCXxApzNQixa50YRdFBt0
         VpEjBtc7vb6RWUNB2U05gK9lexz7E/hGplgxTN5UL9MVnz+QopFMeOuEeiJ/u0WwwrjC
         9zxfUbcSyrD1ZuSpDH+0TrBphAwNVH32zyVOtPZntyeadiela1RBv7AtQ8toLza2x8or
         nntXoJncy6Lb74nABMh+e7gcUMIuF4zTwReltjkONHJxOtJY7MMVtlICEwkZwKvMcOh/
         TCKg==
X-Gm-Message-State: AOAM532FIvui0XN1bx7DlSffmUQQ3lpog2wMHYOw9qUUFGkydp1+a702
        BYGWiBYuBYeeTTQzp98wW1YaNIsSL4cxQPMe+It8cfy2u6JNWdxDKC2xsucrOq3gXdKIsINEEMr
        BiYdST/gKJiQs
X-Received: by 2002:a1c:4e13:: with SMTP id g19mr3652563wmh.55.1612531960866;
        Fri, 05 Feb 2021 05:32:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzrXwq8EuygZ5k8QiHexM1uR2jRBlALztPICjodh6e2JfoV9w4ZW4+vGzj9tQPGab0c1bYgbQ==
X-Received: by 2002:a1c:4e13:: with SMTP id g19mr3652548wmh.55.1612531960678;
        Fri, 05 Feb 2021 05:32:40 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id t197sm18819401wmt.3.2021.02.05.05.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 05:32:40 -0800 (PST)
Date:   Fri, 5 Feb 2021 08:32:37 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/13] vhost/vdpa: remove vhost_vdpa_config_validate()
Message-ID: <20210205083108-mutt-send-email-mst@kernel.org>
References: <20210204172230.85853-1-sgarzare@redhat.com>
 <20210204172230.85853-10-sgarzare@redhat.com>
 <6919d2d4-cc8e-2b67-2385-35803de5e38b@redhat.com>
 <20210205091651.xfcdyuvwwzew2ufo@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210205091651.xfcdyuvwwzew2ufo@steredhat>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 10:16:51AM +0100, Stefano Garzarella wrote:
> On Fri, Feb 05, 2021 at 11:27:32AM +0800, Jason Wang wrote:
> > 
> > On 2021/2/5 上午1:22, Stefano Garzarella wrote:
> > > get_config() and set_config() callbacks in the 'struct vdpa_config_ops'
> > > usually already validated the inputs. Also now they can return an error,
> > > so we don't need to validate them here anymore.
> > > 
> > > Let's use the return value of these callbacks and return it in case of
> > > error in vhost_vdpa_get_config() and vhost_vdpa_set_config().
> > > 
> > > Originally-by: Xie Yongji <xieyongji@bytedance.com>
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > >  drivers/vhost/vdpa.c | 41 +++++++++++++----------------------------
> > >  1 file changed, 13 insertions(+), 28 deletions(-)
> > > 
> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > index ef688c8c0e0e..d61e779000a8 100644
> > > --- a/drivers/vhost/vdpa.c
> > > +++ b/drivers/vhost/vdpa.c
> > > @@ -185,51 +185,35 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
> > >  	return 0;
> > >  }
> > > -static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
> > > -				      struct vhost_vdpa_config *c)
> > > -{
> > > -	long size = 0;
> > > -
> > > -	switch (v->virtio_id) {
> > > -	case VIRTIO_ID_NET:
> > > -		size = sizeof(struct virtio_net_config);
> > > -		break;
> > > -	}
> > > -
> > > -	if (c->len == 0)
> > > -		return -EINVAL;
> > > -
> > > -	if (c->len > size - c->off)
> > > -		return -E2BIG;
> > > -
> > > -	return 0;
> > > -}
> > > -
> > >  static long vhost_vdpa_get_config(struct vhost_vdpa *v,
> > >  				  struct vhost_vdpa_config __user *c)
> > >  {
> > >  	struct vdpa_device *vdpa = v->vdpa;
> > >  	struct vhost_vdpa_config config;
> > >  	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
> > > +	long ret;
> > >  	u8 *buf;
> > >  	if (copy_from_user(&config, c, size))
> > >  		return -EFAULT;
> > > -	if (vhost_vdpa_config_validate(v, &config))
> > > +	if (config.len == 0)
> > >  		return -EINVAL;
> > >  	buf = kvzalloc(config.len, GFP_KERNEL);
> > 
> > 
> > Then it means usersapce can allocate a very large memory.
> 
> Good point.
> 
> > 
> > Rethink about this, we should limit the size here (e.g PAGE_SIZE) or
> > fetch the config size first (either through a config ops as you
> > suggested or a variable in the vdpa device that is initialized during
> > device creation).
> 
> Maybe PAGE_SIZE is okay as a limit.
> 
> If instead we want to fetch the config size, then better a config ops in my
> opinion, to avoid adding a new parameter to __vdpa_alloc_device().
> 
> I vote for PAGE_SIZE, but it isn't a strong opinion.
> 
> What do you and @Michael suggest?
> 
> Thanks,
> Stefano

Devices know what the config size is. Just have them provide it.

-- 
MST

