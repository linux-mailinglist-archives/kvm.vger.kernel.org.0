Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C612E1B4F
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 12:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgLWLAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Dec 2020 06:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgLWLAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Dec 2020 06:00:33 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61058C0613D6
        for <kvm@vger.kernel.org>; Wed, 23 Dec 2020 02:59:53 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id cm17so15844522edb.4
        for <kvm@vger.kernel.org>; Wed, 23 Dec 2020 02:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EJYssnIVO9+6+TEhutNIY19jP+0vyYszSOhuqVf4GPs=;
        b=h3NR7oNJIn5F3wRuwjTuh1CxonfEpyDcUAjhDF8YqjPoKP68o7yGLicZas6bNXZLwI
         mNwBwrPDtQho+r2o+MCdF/Hi4zNNnThaC0HyMSSdb75eteDBB2eS+bpUANrPGv8Jkjbe
         uDt/0UzQ42zq/mEWOa30tpD8U/ZafqJbezlF0aW4uB4JicN7DA+lYQppmb/HvQDQSAs4
         SrTu/o2DlHYvfmspF48uYG6PVAUtGcyNbBJJSh/SbRnhHDEYIrGVFAg0XzIX9owTt730
         lxtkqqK3Id2P4VS7pYhEvy/kzQRfCSu1FRyeOdfoMP+7Z1yUZehTGO2Kpr/yFGYI67wz
         kbgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EJYssnIVO9+6+TEhutNIY19jP+0vyYszSOhuqVf4GPs=;
        b=IV11AWewBUwqkytg6GZK0MYRbXsUvWqWcpXCSGnmeipKZB+iQbyF4KCI+LBFuJRNkY
         n0aVH98+5utZgZ6zjmlL4XztSS59tO9KRvmjHl5bdVmJZaDU2W3KBdhaehmNcnh+iXyg
         8lxSgxWAEolXvHas9L1b6fdeTUJ1FhbRlE9Kd/RzMtXe7eWEISxSHa3C2lFlEEnr78mx
         Y+iw8oZKQYuDGIqv+c9mx8ssuvU8APmmZ1ePmTHSnsWAO09kU9pexmcZW5B2Cc+sfg5D
         zYkPxqwItvIJ0v9vn8wo62MbQjcm3W0KwG0p5FCOzVH1Ifg9gz2sgq0pvBPShQ5f3GZY
         BzTg==
X-Gm-Message-State: AOAM531cfG3i83khn5y+rbeoWqe4hyUxapYFzlZxYazQieSGgDHXFVIt
        7S0O/Im/m+2vVDuwoNAVIym4yCl/tbmV6VCqVmqU
X-Google-Smtp-Source: ABdhPJx3rYPUtrISFW4ljkWLabhg1Bc8Nd7OaYANMSQqXeNKfHuAJ4ghonPQ7GPKFsoidfowCFGFzBOXvuD4xF3IT3g=
X-Received: by 2002:a50:f304:: with SMTP id p4mr23478658edm.118.1608721192052;
 Wed, 23 Dec 2020 02:59:52 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <c892652a-3f57-c337-8c67-084ba6d10834@redhat.com>
In-Reply-To: <c892652a-3f57-c337-8c67-084ba6d10834@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 23 Dec 2020 18:59:41 +0800
Message-ID: <CACycT3tr-1EDeH4j0AojD+-qM5yqDUU0tQHieVUXgL7AOTHyvQ@mail.gmail.com>
Subject: Re: [RFC v2 00/13] Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 23, 2020 at 2:38 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/22 =E4=B8=8B=E5=8D=8810:52, Xie Yongji wrote:
> > This series introduces a framework, which can be used to implement
> > vDPA Devices in a userspace program. The work consist of two parts:
> > control path forwarding and data path offloading.
> >
> > In the control path, the VDUSE driver will make use of message
> > mechnism to forward the config operation from vdpa bus driver
> > to userspace. Userspace can use read()/write() to receive/reply
> > those control messages.
> >
> > In the data path, the core is mapping dma buffer into VDUSE
> > daemon's address space, which can be implemented in different ways
> > depending on the vdpa bus to which the vDPA device is attached.
> >
> > In virtio-vdpa case, we implements a MMU-based on-chip IOMMU driver wit=
h
> > bounce-buffering mechanism to achieve that.
>
>
> Rethink about the bounce buffer stuffs. I wonder instead of using kernel
> pages with mmap(), how about just use userspace pages like what vhost did=
?
>
> It means we need a worker to do bouncing but we don't need to care about
> annoying stuffs like page reclaiming?
>

Now the I/O bouncing is done in the streaming DMA mapping routines
which can be called from interrupt context. If we put this into a
kworker, that means we need to synchronize with a kworker in an
interrupt context. I think it can't work.

Thanks,
Yongji
