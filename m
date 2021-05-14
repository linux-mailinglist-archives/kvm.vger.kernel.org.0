Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA4D380899
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 13:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhENLhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 07:37:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232389AbhENLhb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 May 2021 07:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620992179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mIcQUlsHB9GjnPE2QvhbTigpY+9TcUPrmrRb1c8BGPY=;
        b=BhKsNEpaDK/ku6xyrloGUDQklDGReeydD0UKcJ23Sh+TpfpyKGA/4GGrXwHS7Jv8oaCE3U
        f5Yev2vA2oW+wu0cXtQUBHXv4Lty7XUwhZWJnPxiX1OlAYMkL6gMQtRd5Ex/lLIjn0dwZV
        ReXMEC9lwUPe4jiVuR9znD3gizPIsaA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-IbBsXLB0M0aPcgxDos3GEA-1; Fri, 14 May 2021 07:36:17 -0400
X-MC-Unique: IbBsXLB0M0aPcgxDos3GEA-1
Received: by mail-wr1-f70.google.com with SMTP id 36-20020adf91a70000b029010ec34b3f27so4421035wri.10
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 04:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mIcQUlsHB9GjnPE2QvhbTigpY+9TcUPrmrRb1c8BGPY=;
        b=ZXN9TeaSffAeAUtZKOBfwcvj2SeCwkrqbYCkKKSWlsqIwPIeIQ1vDJFWinKxxsv9tP
         v9Hih0LIB+eM9TTDG+vQ5z+Na0egItxlUKmXsyAOILl8TuQqDZ6KHsVVu7gblOhH2AX9
         tRQMhDT5rMX1SvDCrHZgjpm1vt4A59HA95CsAQpzFBGjfBEDbhMhpQuX5u5+wA735vL5
         cYXQ4AhAiLxneB9ClTYN0NMfmBPIYHUO2F1r4KFPKpOnRkwsYLCr6lFjWGHqG3kuWy6k
         i1/qFXYOMP7H27ZNfRcadWz4sAFZZIIZgRELauWhEzkmotHPWbcP117zxaE4P0IStI36
         laLQ==
X-Gm-Message-State: AOAM531Ff6GU+UG+se7X/mj6kxB0mndeO8N8Rl3IKrR129OiNx7ypXz8
        EUqcZOHwtquHxB8hTmGcQMyozllbrWyOcTXfMvdjno4NZi1KYJ3YVNWp0a1NAxy0Eq/N1/w6ZUw
        2pux+Un2qyOjg
X-Received: by 2002:adf:e991:: with SMTP id h17mr13348566wrm.265.1620992176519;
        Fri, 14 May 2021 04:36:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkheG6+9wAfmTav7j8nkCGClt/d84UwVpHJTyKDfom/4CboPHupI3U474RxUhnHPIO1Tj/hw==
X-Received: by 2002:adf:e991:: with SMTP id h17mr13348540wrm.265.1620992176305;
        Fri, 14 May 2021 04:36:16 -0700 (PDT)
Received: from redhat.com ([2a10:800c:1fa6:0:3809:fe0c:bb87:250e])
        by smtp.gmail.com with ESMTPSA id t7sm4707wrs.87.2021.05.14.04.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 04:36:15 -0700 (PDT)
Date:   Fri, 14 May 2021 07:36:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm <kvm@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
Message-ID: <20210514073452-mutt-send-email-mst@kernel.org>
References: <20210423080942.2997-1-jasowang@redhat.com>
 <YJ1TgoFSwOkQrC+1@stefanha-x1.localdomain>
 <CACGkMEv0uWd+X87cYoG-GGjTXBvRztp2CY3RKyq9jFbSYK1n0Q@mail.gmail.com>
 <YJ5cKe0egklXDpng@stefanha-x1.localdomain>
 <CACycT3u+hQbDJtf5gxS1NVVpiTffMz1skuhTExy5d_oRjYKoxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3u+hQbDJtf5gxS1NVVpiTffMz1skuhTExy5d_oRjYKoxg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 07:27:22PM +0800, Yongji Xie wrote:
> On Fri, May 14, 2021 at 7:17 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >
> > On Fri, May 14, 2021 at 03:29:20PM +0800, Jason Wang wrote:
> > > On Fri, May 14, 2021 at 12:27 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > > >
> > > > On Fri, Apr 23, 2021 at 04:09:35PM +0800, Jason Wang wrote:
> > > > > Sometimes, the driver doesn't trust the device. This is usually
> > > > > happens for the encrtpyed VM or VDUSE[1].
> > > >
> > > > Thanks for doing this.
> > > >
> > > > Can you describe the overall memory safety model that virtio drivers
> > > > must follow?
> > >
> > > My understanding is that, basically the driver should not trust the
> > > device (since the driver doesn't know what kind of device that it
> > > tries to drive)
> > >
> > > 1) For any read only metadata (required at the spec level) which is
> > > mapped as coherent, driver should not depend on the metadata that is
> > > stored in a place that could be wrote by the device. This is what this
> > > series tries to achieve.
> > > 2) For other metadata that is produced by the device, need to make
> > > sure there's no malicious device triggered behavior, this is somehow
> > > similar to what vhost did. No DOS, loop, kernel bug and other stuffs.
> > > 3) swiotb is a must to enforce memory access isolation. (VDUSE or encrypted VM)
> > >
> > > > For example:
> > > >
> > > > - Driver-to-device buffers must be on dedicated pages to avoid
> > > >   information leaks.
> > >
> > > It looks to me if swiotlb is used, we don't need this since the
> > > bouncing is not done at byte not page.
> > >
> > > But if swiotlb is not used, we need to enforce this.
> > >
> > > >
> > > > - Driver-to-device buffers must be on dedicated pages to avoid memory
> > > >   corruption.
> > >
> > > Similar to the above.
> > >
> > > >
> > > > When I say "pages" I guess it's the IOMMU page size that matters?
> > > >
> > >
> > > And the IOTLB page size.
> > >
> > > > What is the memory access granularity of VDUSE?
> > >
> > > It has an swiotlb, but the access and bouncing is done per byte.
> > >
> > > >
> > > > I'm asking these questions because there is driver code that exposes
> > > > kernel memory to the device and I'm not sure it's safe. For example:
> > > >
> > > >   static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *vbr,
> > > >                   struct scatterlist *data_sg, bool have_data)
> > > >   {
> > > >           struct scatterlist hdr, status, *sgs[3];
> > > >           unsigned int num_out = 0, num_in = 0;
> > > >
> > > >           sg_init_one(&hdr, &vbr->out_hdr, sizeof(vbr->out_hdr));
> > > >                             ^^^^^^^^^^^^^
> > > >           sgs[num_out++] = &hdr;
> > > >
> > > >           if (have_data) {
> > > >                   if (vbr->out_hdr.type & cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_OUT))
> > > >                           sgs[num_out++] = data_sg;
> > > >                   else
> > > >                           sgs[num_out + num_in++] = data_sg;
> > > >           }
> > > >
> > > >           sg_init_one(&status, &vbr->status, sizeof(vbr->status));
> > > >                                ^^^^^^^^^^^^
> > > >           sgs[num_out + num_in++] = &status;
> > > >
> > > >           return virtqueue_add_sgs(vq, sgs, num_out, num_in, vbr, GFP_ATOMIC);
> > > >   }
> > > >
> > > > I guess the drivers don't need to be modified as long as swiotlb is used
> > > > to bounce the buffers through "insecure" memory so that the memory
> > > > surrounding the buffers is not exposed?
> > >
> > > Yes, swiotlb won't bounce the whole page. So I think it's safe.
> >
> > Thanks Jason and Yongji Xie for clarifying. Seems like swiotlb or a
> > similar mechanism can handle byte-granularity isolation so the drivers
> > not need to worry about information leaks or memory corruption outside
> > the mapped byte range.
> >
> > We still need to audit virtio guest drivers to ensure they don't trust
> > data that can be modified by the device. I will look at virtio-blk and
> > virtio-fs next week.
> >
> 
> Oh, that's great. Thank you!
> 
> I also did some audit work these days and will send a new version for
> reviewing next Monday.
> 
> Thanks,
> Yongji

Doing it in a way that won't hurt performance for simple
configs that trust the device is a challenge though.
Pls take a look at the discussion with Christoph for some ideas
on how to do this.


-- 
MST

