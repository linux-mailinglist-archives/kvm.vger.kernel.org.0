Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8DECC028E
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 11:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfI0JlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 05:41:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfI0JlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 05:41:14 -0400
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D2404FCD6
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:41:14 +0000 (UTC)
Received: by mail-qt1-f198.google.com with SMTP id f15so5171466qth.6
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 02:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hwNSPFXYcjt0ijpRdc1M38OvqU5g9p5x1VDMj8NBIGI=;
        b=HmpSN+3M99tCDUzU6sK7aHXbkre+pS1EDQ1eBAx5iSr76SmAuPzkpXG50AdrNu5Beq
         P0CMz+u11ZqQrZjeJ6HAQ6iDhk2tAKLNcXEYdj38OFWd19BUkoLMW5I8X5Xfj7/Z6PW7
         tC8+aG+J87Uz53ezdEn6Wg2zY5gfT0Eh+qOI2y2vDS/VKLy/5jYZCCkPjZ81TI/TOCoh
         2si+VVIfQ8bOPL+dEBfxyR8fE6NgEv8bdNyiK+S9HfsEKlDQgSVUXXu6InWMMZE48OyY
         w9DbWq6vO8utnfef4Al8n5FkmiCZZSCtmRBhKM5p+YFaG6LaNmYsMP86D82m+6TPGiSB
         +9lw==
X-Gm-Message-State: APjAAAVJa1XM8eaAbJLMhpk8LYsHfpDfb/IhVx8ssJeLa33ZQdlIgk88
        VXVNSIYvO4QiJOEYzTXhwUXksJzoPGCSc3XW0a/c5gQT0Ah/6FaaQ3Vq3kC9Ewzqtvv/Ahrww3Y
        1Dq4da62VC+5U
X-Received: by 2002:a37:aac8:: with SMTP id t191mr3503366qke.325.1569577273340;
        Fri, 27 Sep 2019 02:41:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw/89V+twr9hPNLSOQXPg0tKZiJPuTDeybpYPFwNhDmewmUrIv8Fs6bzVi79PPZFA45J2U/tg==
X-Received: by 2002:a37:aac8:: with SMTP id t191mr3503317qke.325.1569577272663;
        Fri, 27 Sep 2019 02:41:12 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id v26sm3013791qta.88.2019.09.27.02.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 02:41:11 -0700 (PDT)
Date:   Fri, 27 Sep 2019 05:41:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
Message-ID: <20190927053935-mutt-send-email-mst@kernel.org>
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <20190926042156-mutt-send-email-mst@kernel.org>
 <20190926131439.GA11652@___>
 <8ab5a8d9-284d-bba5-803d-08523c0814e1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ab5a8d9-284d-bba5-803d-08523c0814e1@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 11:27:12AM +0800, Jason Wang wrote:
> 
> On 2019/9/26 下午9:14, Tiwei Bie wrote:
> > On Thu, Sep 26, 2019 at 04:35:18AM -0400, Michael S. Tsirkin wrote:
> > > On Thu, Sep 26, 2019 at 12:54:27PM +0800, Tiwei Bie wrote:
> > [...]
> > > > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > > > index 40d028eed645..5afbc2f08fa3 100644
> > > > --- a/include/uapi/linux/vhost.h
> > > > +++ b/include/uapi/linux/vhost.h
> > > > @@ -116,4 +116,12 @@
> > > >   #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
> > > >   #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
> > > > +/* VHOST_MDEV specific defines */
> > > > +
> > > > +#define VHOST_MDEV_SET_STATE	_IOW(VHOST_VIRTIO, 0x70, __u64)
> > > > +
> > > > +#define VHOST_MDEV_S_STOPPED	0
> > > > +#define VHOST_MDEV_S_RUNNING	1
> > > > +#define VHOST_MDEV_S_MAX	2
> > > > +
> > > >   #endif
> > > So assuming we have an underlying device that behaves like virtio:
> > I think they are really good questions/suggestions. Thanks!
> > 
> > > 1. Should we use SET_STATUS maybe?
> > I like this idea. I will give it a try.
> > 
> > > 2. Do we want a reset ioctl?
> > I think it is helpful. If we use SET_STATUS, maybe we
> > can use it to support the reset.
> > 
> > > 3. Do we want ability to enable rings individually?
> > I will make it possible at least in the vhost layer.
> 
> 
> Note the API support e.g set_vq_ready().

virtio spec calls this "enabled" so let's stick to that.

> 
> > 
> > > 4. Does device need to limit max ring size?
> > > 5. Does device need to limit max number of queues?
> > I think so. It's helpful to have ioctls to report the max
> > ring size and max number of queues.
> 
> 
> An issue is the max number of queues is done through a device specific way,
> usually device configuration space. This is supported by the transport API,
> but how to expose it to userspace may need more thought.
> 
> Thanks

an ioctl for device config?  But for v1 I'd be quite happy to just have
a minimal working device with 2 queues.

> 
> > 
> > Thanks!
