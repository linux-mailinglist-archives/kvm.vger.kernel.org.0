Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F0A380ADE
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 15:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhENN7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 09:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhENN7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 09:59:54 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DB7C06174A
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 06:58:43 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e14so25825754ils.12
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 06:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bfYFyDNOaHNznWD3QdjOTFC8+ozDhd6BMb68HdfprOU=;
        b=c01F5hKE8Z6Bx4tcWxeDqSwTHAQXEuTzA80kuP5Y/4gWobUYbKnf5x5a93aCLtQt+7
         /T4/ZcijHUQ5pkR6PldpwKw+JI6Wt4AAZTEsno0EtwfWn+Dl5vO/fCwWQvoiYrmKDXm1
         8JHA5ipjZoX8GXyEiaK011JEGH291V6SxSpiqWFZOc8TQLsacNXWfjBVTK86yx+znbq/
         iuYuY2/1bkI2uResvm8SG90jQPrWRWDeyKphHoX/dFo69ehgrmgAXPLd0W7LLHECpkDo
         w58oYYU5YoSVmTEL5KEmHEhzQseJVKY5XZkkNSZq9VIvqb9F9DvJbrBjY/d86yxRvplT
         0XhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bfYFyDNOaHNznWD3QdjOTFC8+ozDhd6BMb68HdfprOU=;
        b=kXa5DitGQ5VPXT2X2UTI4mOerBRjucd9EnXY8TTy9Cj3zdwmNMsEtyaPxATbJt1k9s
         uNGHoocWV8vcCfTjBQuBnMAaxzwt1z3RlpNg8kDbmFNDWuCWLrLITqbv+6FCTXiRfssw
         evj7FxqjODYnb9A4KT/s6sngf7juyGzB5eREqCFhEPn8m38aIyUOIVNYOD6zf4qMiYfP
         9wq2wW8SRLoKWdTWULyOxUMk1UZ3Bt/5cCnkeL3+CwGyfKNeRUbg7FO1mjtcaW4/FC5h
         YKTBfhEQTLLcyz+ba8JWQN+fAhmf1MobOO5l2AL35ex4fEmNKMJ4iAfpEF84pPrJnjQU
         08Zg==
X-Gm-Message-State: AOAM532UqN8ImvgNyBTf8bRGwW9CQgwAPZULwsLaQEAQCIUbDUK5pUYm
        JgG0nDX/UgG4XlVCUdVTVfl41IuEve72JLAyjrn7
X-Google-Smtp-Source: ABdhPJxalKKFR43HiA8yCE0dJ8wr0xiO9hBKUHab9MyXauJN2iIVjG1vmjJpu9op6ncTeNps+BNJ6gnsJ8KcevdkWRw=
X-Received: by 2002:a92:c884:: with SMTP id w4mr40269472ilo.186.1621000722714;
 Fri, 14 May 2021 06:58:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210423080942.2997-1-jasowang@redhat.com> <YJ1TgoFSwOkQrC+1@stefanha-x1.localdomain>
 <CACGkMEv0uWd+X87cYoG-GGjTXBvRztp2CY3RKyq9jFbSYK1n0Q@mail.gmail.com>
 <YJ5cKe0egklXDpng@stefanha-x1.localdomain> <CACycT3u+hQbDJtf5gxS1NVVpiTffMz1skuhTExy5d_oRjYKoxg@mail.gmail.com>
 <20210514073452-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210514073452-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 14 May 2021 21:58:32 +0800
Message-ID: <CACycT3ttN=t3LQGSVUbt9mbsgUsKOrZuRRziMkZJSiQkBP77iw@mail.gmail.com>
Subject: Re: Re: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm <kvm@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 7:36 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, May 14, 2021 at 07:27:22PM +0800, Yongji Xie wrote:
> > On Fri, May 14, 2021 at 7:17 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > >
> > > On Fri, May 14, 2021 at 03:29:20PM +0800, Jason Wang wrote:
> > > > On Fri, May 14, 2021 at 12:27 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > > > >
> > > > > On Fri, Apr 23, 2021 at 04:09:35PM +0800, Jason Wang wrote:
> > > > > > Sometimes, the driver doesn't trust the device. This is usually
> > > > > > happens for the encrtpyed VM or VDUSE[1].
> > > > >
> > > > > Thanks for doing this.
> > > > >
> > > > > Can you describe the overall memory safety model that virtio drivers
> > > > > must follow?
> > > >
> > > > My understanding is that, basically the driver should not trust the
> > > > device (since the driver doesn't know what kind of device that it
> > > > tries to drive)
> > > >
> > > > 1) For any read only metadata (required at the spec level) which is
> > > > mapped as coherent, driver should not depend on the metadata that is
> > > > stored in a place that could be wrote by the device. This is what this
> > > > series tries to achieve.
> > > > 2) For other metadata that is produced by the device, need to make
> > > > sure there's no malicious device triggered behavior, this is somehow
> > > > similar to what vhost did. No DOS, loop, kernel bug and other stuffs.
> > > > 3) swiotb is a must to enforce memory access isolation. (VDUSE or encrypted VM)
> > > >
> > > > > For example:
> > > > >
> > > > > - Driver-to-device buffers must be on dedicated pages to avoid
> > > > >   information leaks.
> > > >
> > > > It looks to me if swiotlb is used, we don't need this since the
> > > > bouncing is not done at byte not page.
> > > >
> > > > But if swiotlb is not used, we need to enforce this.
> > > >
> > > > >
> > > > > - Driver-to-device buffers must be on dedicated pages to avoid memory
> > > > >   corruption.
> > > >
> > > > Similar to the above.
> > > >
> > > > >
> > > > > When I say "pages" I guess it's the IOMMU page size that matters?
> > > > >
> > > >
> > > > And the IOTLB page size.
> > > >
> > > > > What is the memory access granularity of VDUSE?
> > > >
> > > > It has an swiotlb, but the access and bouncing is done per byte.
> > > >
> > > > >
> > > > > I'm asking these questions because there is driver code that exposes
> > > > > kernel memory to the device and I'm not sure it's safe. For example:
> > > > >
> > > > >   static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *vbr,
> > > > >                   struct scatterlist *data_sg, bool have_data)
> > > > >   {
> > > > >           struct scatterlist hdr, status, *sgs[3];
> > > > >           unsigned int num_out = 0, num_in = 0;
> > > > >
> > > > >           sg_init_one(&hdr, &vbr->out_hdr, sizeof(vbr->out_hdr));
> > > > >                             ^^^^^^^^^^^^^
> > > > >           sgs[num_out++] = &hdr;
> > > > >
> > > > >           if (have_data) {
> > > > >                   if (vbr->out_hdr.type & cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_OUT))
> > > > >                           sgs[num_out++] = data_sg;
> > > > >                   else
> > > > >                           sgs[num_out + num_in++] = data_sg;
> > > > >           }
> > > > >
> > > > >           sg_init_one(&status, &vbr->status, sizeof(vbr->status));
> > > > >                                ^^^^^^^^^^^^
> > > > >           sgs[num_out + num_in++] = &status;
> > > > >
> > > > >           return virtqueue_add_sgs(vq, sgs, num_out, num_in, vbr, GFP_ATOMIC);
> > > > >   }
> > > > >
> > > > > I guess the drivers don't need to be modified as long as swiotlb is used
> > > > > to bounce the buffers through "insecure" memory so that the memory
> > > > > surrounding the buffers is not exposed?
> > > >
> > > > Yes, swiotlb won't bounce the whole page. So I think it's safe.
> > >
> > > Thanks Jason and Yongji Xie for clarifying. Seems like swiotlb or a
> > > similar mechanism can handle byte-granularity isolation so the drivers
> > > not need to worry about information leaks or memory corruption outside
> > > the mapped byte range.
> > >
> > > We still need to audit virtio guest drivers to ensure they don't trust
> > > data that can be modified by the device. I will look at virtio-blk and
> > > virtio-fs next week.
> > >
> >
> > Oh, that's great. Thank you!
> >
> > I also did some audit work these days and will send a new version for
> > reviewing next Monday.
> >
> > Thanks,
> > Yongji
>
> Doing it in a way that won't hurt performance for simple
> configs that trust the device is a challenge though.
> Pls take a look at the discussion with Christoph for some ideas
> on how to do this.
>

I see. Thanks for the reminder.

Thanks,
Yongji
