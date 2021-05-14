Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC809380560
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 10:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhENImD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 04:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbhENImC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 04:42:02 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EED5C06174A
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 01:40:51 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id w3so43619269ejc.4
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 01:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+wZab5pINZpwdaHt/bHMqJV5s7yiKsmN12nleLzipVI=;
        b=rUAG4q59lGFY+rT56KuTKMwS7etbeEVaacrURJbzUpHXBSlZZQjXTtA9QlTYv0kyRL
         GzQyq7nc7hQIJ9q19Zaf1gHWj8BCUMMQqnsp6z1thhfNd4+H6kU7OHdddjaPlLIvEcMj
         C+ijieV3F5OosGKQaAdRbzUkebJOEwdc2BK/oYqU5Ws/7lEdt2kLShiYj8fnZnx/+B1x
         CmSGcEUgYHVwvosm7EdxRcGdGonMcafbT9tiCzHD7lq30vgMP9dsgLSCm7fRZ55evYQS
         WaS0KpWWAkIPoiFXd740zrQ8myLp6wdMiSjju7N6y4JWp5tNJV3lcqWkxcyT62xyyA1O
         h4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+wZab5pINZpwdaHt/bHMqJV5s7yiKsmN12nleLzipVI=;
        b=EXtujpwwWp7vbmi/Km6/0hSbe2UvAr65qyqvtCjoowkZArrbKSZtQF/iUyKFKorIr9
         Addyox0UUKGMdfo2qrEclzT8VTII34QkzzhKHz46FNauwIt+cpnDMS/iVOHJyZIZ0WIc
         WSeos6Fa+YgdKWtTa95Qq2RJRJIYUakikgUjgpPvCLpJXCyhyaPkH4GoklZ8xbwlhPyz
         PAVo4ShEZMqIabGgW0n/ooT+Yw+2t9XP8lNMgEh9StoFLWPujvYDkQl2jQPTrjQ8vXFu
         4ZCdtEoEpmrssNJllFFh+z0PEDmvB6phZVRQ+LXgsPTOx5YEAHpv0xnLKuwunMun7zE1
         k/lg==
X-Gm-Message-State: AOAM533sRcWWFTq9MCEDtkRViOJwMzf305HIchV3BTQ+zbbPH4UZSKDO
        2qoavgNDeUMflbh8gtH4ciM3ctWduZnyBJADs/P2
X-Google-Smtp-Source: ABdhPJzJY5c+DF7FN0ZwRjpLJBuUIrZdr1brdVzSUyRRFXtqMVqLIf+pmWBDCh4xKAEK+E4SUTB/23nCC4pLH2qUxpc=
X-Received: by 2002:a17:906:edaf:: with SMTP id sa15mr10209317ejb.174.1620981650150;
 Fri, 14 May 2021 01:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210423080942.2997-1-jasowang@redhat.com> <YJ1TgoFSwOkQrC+1@stefanha-x1.localdomain>
 <CACycT3v-2naEaXEtPqaKcGz8qpfnmp4VzrHefqLNhO=9=57jdQ@mail.gmail.com> <CACGkMEvKByPZFwN8bU6_SfRbS9i43am7X5WGJQtE=Yh+YKWOHw@mail.gmail.com>
In-Reply-To: <CACGkMEvKByPZFwN8bU6_SfRbS9i43am7X5WGJQtE=Yh+YKWOHw@mail.gmail.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 14 May 2021 16:40:39 +0800
Message-ID: <CACycT3so8iqySjx0JFOMNAXM85v1GtrXFhA=uR8J-KFdicg8Eg@mail.gmail.com>
Subject: Re: Re: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm <kvm@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 3:31 PM Jason Wang <jasowang@redhat.com> wrote:
>
> On Fri, May 14, 2021 at 2:07 PM Yongji Xie <xieyongji@bytedance.com> wrote:
> >
> > On Fri, May 14, 2021 at 12:27 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > >
> > > On Fri, Apr 23, 2021 at 04:09:35PM +0800, Jason Wang wrote:
> > > > Sometimes, the driver doesn't trust the device. This is usually
> > > > happens for the encrtpyed VM or VDUSE[1].
> > >
> > > Thanks for doing this.
> > >
> > > Can you describe the overall memory safety model that virtio drivers
> > > must follow? For example:
> > >
> > > - Driver-to-device buffers must be on dedicated pages to avoid
> > >   information leaks.
> > >
> > > - Driver-to-device buffers must be on dedicated pages to avoid memory
> > >   corruption.
> > >
> > > When I say "pages" I guess it's the IOMMU page size that matters?
> > >
> > > What is the memory access granularity of VDUSE?
> > >
> >
> > Now we use PAGE_SIZE as the access granularity. I think it should be
> > safe to access the Driver-to-device buffers in VDUSE case because we
> > also use bounce-buffering mechanism like swiotlb does.
> >
> > Thanks,
> > Yongji
> >
>
> Yes, while at this, I wonder it's possible the re-use the swiotlb
> codes for VDUSE, or having some common library for this. Otherwise
> there would be duplicated codes (bugs).
>

I think there are still some gaps between VDUSE codes and swiotlb
codes.  For example, swiotlb allocates and uses contiguous memory for
bouncing but VDUSE doesn't. The swiotlb works in singleton mode
(designed for platform IOMMU) , but VDUSE is based on on-chip IOMMU
(supports multiple instances). So we will need some extra work if we
want a common library for them both.

And since the only duplicated codes now are swiotlb_bounce() (swiotlb)
and do_bounce() (VDUSE). So I prefer to do this work in future rather
than in the current series.

Thanks,
Yongji
