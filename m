Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96732380870
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 13:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhENL2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 07:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhENL2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 07:28:46 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6A5C06174A
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 04:27:35 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g14so34325408edy.6
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 04:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6VTAUnp96WvnXms28tMWvj3Ilwf5M8EYB2gCnZeyU+0=;
        b=xEpLjb3l0myWq5PwbpIv6kQxuCRtBtTocSeotDlVRZE9ocm9eBXCkwGio5UoK6nPSZ
         EcUpUJ+DEjEqzU/QwfB3nc3LG6UmkQ9bOFcT+69ah/dlgEeOio+FxN0ibvwWX7J2sQAE
         QPoJhBNE5sEoJLwy9nH0kmLPx5xscwyu4ku/iJIQyKH8jLP53+MoSjsKX66w4pVwXM6e
         anSDDAUFTxQdRKwqrzHYXnb6WYhcMrfn0nDZiuORWlipzMh+QOZLdL3AXgRRNTgzfM5F
         YeelKbUT9r7YMSrNJeFGnz3GEfTwv68jptrS09MBJiwnO52eo7O6aMIrxWcV3A05L4Co
         5Omg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6VTAUnp96WvnXms28tMWvj3Ilwf5M8EYB2gCnZeyU+0=;
        b=KDsTAa3BrjWTUqq3O+Yp5zA6q/Q8xcnvpAlP2h8rESmyJiqV9kChDSzTjU0ImfEoi0
         MWiYUx57Olp1DQl3uYYRfvkN6IX3s6XfdYR7l6nkxtesS9nlBFx1PnqIZ7w1juqJ5jh9
         01YuBXqWlfpt+2DIAYWd2N/edwk2jl1Xism8JEtZ2Fv1v4L/rNLqY/g1W/Gyy2E2Y8ZG
         Be5bc8XQotbNu+fxX4BiNct3GwLa7SywIUyfR5rqEmhgAxx4Mpz9eUmp+FBU8KiNAw26
         KDaTEzioM+oqg0f0xkKyYeoPo8ziqpZQNVwijzmwxkPJvOgmoyxvzha2s+WMZMsV/6zn
         qEFw==
X-Gm-Message-State: AOAM530QPB4KvCIGgk6d3qBcee/PwK+UiDeOduYPRmvLvIPBytltDSKn
        vj+X3BlWzXfYHNnK0T3zM2ahBAku6sPEwANjnZJA
X-Google-Smtp-Source: ABdhPJz27foFmU3UAsQ+AVSJgr9h6pnvgfEP9/FHa2zUQkozr9sOWppdSmapcxS8voiKB2XjEYRyAbUTD8RbznsBSkw=
X-Received: by 2002:a05:6402:254a:: with SMTP id l10mr56200162edb.145.1620991653732;
 Fri, 14 May 2021 04:27:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210423080942.2997-1-jasowang@redhat.com> <YJ1TgoFSwOkQrC+1@stefanha-x1.localdomain>
 <CACGkMEv0uWd+X87cYoG-GGjTXBvRztp2CY3RKyq9jFbSYK1n0Q@mail.gmail.com> <YJ5cKe0egklXDpng@stefanha-x1.localdomain>
In-Reply-To: <YJ5cKe0egklXDpng@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 14 May 2021 19:27:22 +0800
Message-ID: <CACycT3u+hQbDJtf5gxS1NVVpiTffMz1skuhTExy5d_oRjYKoxg@mail.gmail.com>
Subject: Re: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm <kvm@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 7:17 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Fri, May 14, 2021 at 03:29:20PM +0800, Jason Wang wrote:
> > On Fri, May 14, 2021 at 12:27 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > >
> > > On Fri, Apr 23, 2021 at 04:09:35PM +0800, Jason Wang wrote:
> > > > Sometimes, the driver doesn't trust the device. This is usually
> > > > happens for the encrtpyed VM or VDUSE[1].
> > >
> > > Thanks for doing this.
> > >
> > > Can you describe the overall memory safety model that virtio drivers
> > > must follow?
> >
> > My understanding is that, basically the driver should not trust the
> > device (since the driver doesn't know what kind of device that it
> > tries to drive)
> >
> > 1) For any read only metadata (required at the spec level) which is
> > mapped as coherent, driver should not depend on the metadata that is
> > stored in a place that could be wrote by the device. This is what this
> > series tries to achieve.
> > 2) For other metadata that is produced by the device, need to make
> > sure there's no malicious device triggered behavior, this is somehow
> > similar to what vhost did. No DOS, loop, kernel bug and other stuffs.
> > 3) swiotb is a must to enforce memory access isolation. (VDUSE or encrypted VM)
> >
> > > For example:
> > >
> > > - Driver-to-device buffers must be on dedicated pages to avoid
> > >   information leaks.
> >
> > It looks to me if swiotlb is used, we don't need this since the
> > bouncing is not done at byte not page.
> >
> > But if swiotlb is not used, we need to enforce this.
> >
> > >
> > > - Driver-to-device buffers must be on dedicated pages to avoid memory
> > >   corruption.
> >
> > Similar to the above.
> >
> > >
> > > When I say "pages" I guess it's the IOMMU page size that matters?
> > >
> >
> > And the IOTLB page size.
> >
> > > What is the memory access granularity of VDUSE?
> >
> > It has an swiotlb, but the access and bouncing is done per byte.
> >
> > >
> > > I'm asking these questions because there is driver code that exposes
> > > kernel memory to the device and I'm not sure it's safe. For example:
> > >
> > >   static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *vbr,
> > >                   struct scatterlist *data_sg, bool have_data)
> > >   {
> > >           struct scatterlist hdr, status, *sgs[3];
> > >           unsigned int num_out = 0, num_in = 0;
> > >
> > >           sg_init_one(&hdr, &vbr->out_hdr, sizeof(vbr->out_hdr));
> > >                             ^^^^^^^^^^^^^
> > >           sgs[num_out++] = &hdr;
> > >
> > >           if (have_data) {
> > >                   if (vbr->out_hdr.type & cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_OUT))
> > >                           sgs[num_out++] = data_sg;
> > >                   else
> > >                           sgs[num_out + num_in++] = data_sg;
> > >           }
> > >
> > >           sg_init_one(&status, &vbr->status, sizeof(vbr->status));
> > >                                ^^^^^^^^^^^^
> > >           sgs[num_out + num_in++] = &status;
> > >
> > >           return virtqueue_add_sgs(vq, sgs, num_out, num_in, vbr, GFP_ATOMIC);
> > >   }
> > >
> > > I guess the drivers don't need to be modified as long as swiotlb is used
> > > to bounce the buffers through "insecure" memory so that the memory
> > > surrounding the buffers is not exposed?
> >
> > Yes, swiotlb won't bounce the whole page. So I think it's safe.
>
> Thanks Jason and Yongji Xie for clarifying. Seems like swiotlb or a
> similar mechanism can handle byte-granularity isolation so the drivers
> not need to worry about information leaks or memory corruption outside
> the mapped byte range.
>
> We still need to audit virtio guest drivers to ensure they don't trust
> data that can be modified by the device. I will look at virtio-blk and
> virtio-fs next week.
>

Oh, that's great. Thank you!

I also did some audit work these days and will send a new version for
reviewing next Monday.

Thanks,
Yongji
