Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539AC360815
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 13:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhDOLRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 07:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhDOLRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 07:17:43 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5023C06175F
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 04:17:20 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r9so36273698ejj.3
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 04:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F2DnwbhM0K3eDbNV4OV/TxWIHc5j6rhfh7F0juu/TCM=;
        b=AcT1wLlEsw/hLOv9QVCK3pqYeHDLF0S+eaz51VVr8uYsXgRZeLZ8SX14FP/ssoFxXE
         R6WOrfa9wrzY/RDAiVI0Y7MTMehK81Ip1mxpyCwCO8ainJ4eo5vhUKUFAJGr/r//8Ucv
         uXcxtATK1evfslAqNE6cVpB533Rjx8jCplNXy5Fjlr/izCvWUUg9Nn0zB8bLmqdxWsOI
         yrUrsn1f9MY9c+lSCyv4m7uC3QRbsMlFqIu6BkNreQCZ7g/b7oHkU+qKKAPQlCAvz+5Q
         5J0MKHcBO86FfvBHtIqdT+lQSrFMUVPWqMO1WIMajZNbE3+mXiPRg5X8/oP0wfek+1uB
         WlSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F2DnwbhM0K3eDbNV4OV/TxWIHc5j6rhfh7F0juu/TCM=;
        b=C+9/yfP7N21CAyVpHOgTBTStZC/jNnqEB5Wo+V6eMvKQqe1ecQtV1UbiHG/hTCcViH
         Hu55iFE2C3//pJ8QkvC/wSSGlZnNti1LySIqUEsd50iaARvMvtCdlgyRlTAwJ/1z+HC1
         /Hdb+Nsdmq80jntlPAZQGB0SjHY6v3sf58b5QmKY+XAfhiCt7ZoJ8KBWDjJcjy8ZcYZu
         c4OQS4ogTMyH1LhFCzFuRw7dPZos9BN1xzxVmdU5dpYTy6kUWk0R/WB452jdMJC+Yolk
         O8Ko8uLLoAxA8/d9rplPbRs9rPv5ck6e936ryd4q3T9qvivSShfcgRcpIOhmMFiH4cC3
         GPvQ==
X-Gm-Message-State: AOAM533UD7ezPKCTEfmadt5NeYbkfhVygalz7axt0s1jt3yIdf45Gy3S
        WBgA0QXXR4kZXYaPU03j0aQEe4YnaXPhb4CF40E/
X-Google-Smtp-Source: ABdhPJxIpQXfXBo/LLGFCyadIaJENXp32QQMzwuSrfXBhX4qR+8lwIcRxRI0FBc6gO1lL3MVnpwlBAcZljWAliGUbS8=
X-Received: by 2002:a17:906:2a16:: with SMTP id j22mr2886917eje.247.1618485439307;
 Thu, 15 Apr 2021 04:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain> <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
 <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain> <80b31814-9e41-3153-7efb-c0c2fab44feb@redhat.com>
 <02c19c22-13ea-ea97-d99b-71edfee0b703@redhat.com>
In-Reply-To: <02c19c22-13ea-ea97-d99b-71edfee0b703@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 15 Apr 2021 19:17:08 +0800
Message-ID: <CACycT3tL7URz3n-KhMAwYH+Sn1e1TSyfU+RKcc8jpPDJ7WcZ2w@mail.gmail.com>
Subject: Re: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021 at 5:05 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/4/15 =E4=B8=8B=E5=8D=884:36, Jason Wang =E5=86=99=E9=81=93=
:
> >>>
> >> Please state this explicitly at the start of the document. Existing
> >> interfaces like FUSE are designed to avoid trusting userspace.
> >
> >
> > There're some subtle difference here. VDUSE present a device to kernel
> > which means IOMMU is probably the only thing to prevent a malicous
> > device.
> >
> >
> >> Therefore
> >> people might think the same is the case here. It's critical that peopl=
e
> >> are aware of this before deploying VDUSE with virtio-vdpa.
> >>
> >> We should probably pause here and think about whether it's possible to
> >> avoid trusting userspace. Even if it takes some effort and costs some
> >> performance it would probably be worthwhile.
> >
> >
> > Since the bounce buffer is used the only attack surface is the
> > coherent area, if we want to enforce stronger isolation we need to use
> > shadow virtqueue (which is proposed in earlier version by me) in this
> > case. But I'm not sure it's worth to do that.
>
>
>
> So this reminds me the discussion in the end of last year. We need to
> make sure we don't suffer from the same issues for VDUSE at least
>
> https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.com=
/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b
>
> Or we can solve it at virtio level, e.g remember the dma address instead
> of depending on the addr in the descriptor ring
>

I might miss something. But VDUSE has recorded the dma address during
dma mapping, so we would not do bouncing if the addr/length is invalid
during dma unmapping. Is it enough?

Thanks,
Yongji
