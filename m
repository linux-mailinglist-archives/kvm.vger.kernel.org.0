Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0148B3617EA
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 04:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbhDPC7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 22:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbhDPC7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 22:59:04 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BB7C061756
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 19:58:38 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id mh2so18374210ejb.8
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 19:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h0yx5dLbv8rJZ5DCE5zdmaVWrPKFcLlOvqXcXEtQJwE=;
        b=tbJgN+AdMgDnjaLBifhtEFNZxnL7ynwTAMqglnR2mQ2OZupVsnB1ZWli4n80gNSFal
         CtVnloJrfet3S+QHctq8IXgCgyLFZsSWMxbxkNdBalgXIodKaEQlL6tnTxzUfPs4FE+d
         uY955LpqXDlJZqT7otwymIeBsRD1PuaxbkyOsurMW1BGnEMCrqemYTyHtor/TnJEuDLm
         wDQpDhY/3sQQ3sWKPupnEIZV4SYN3ErVLbFSMXKqoA+SSAV9TxY6CMkpIT9suwdsgGAI
         HOUdKobAWx1RU9WsBTKT6m8sdJH9C3U3qRAKTyBUYvpPQeRseZ+VJLqJbGuAnmDo+9Si
         DbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h0yx5dLbv8rJZ5DCE5zdmaVWrPKFcLlOvqXcXEtQJwE=;
        b=DwF1/TAV494wShnAPC1/hvhHad580aByeZ+9f80vRr4vCYWeaFDY0LQqk03vF1xVMB
         sxXFv8fUQ3/e6NP9us3GnJsaxbceAal9/g9dMQkoiWS1CSXDj3Sz7GcaKi0v+O+w/Qjj
         x1uyzf6VJqmkAD2+3eATqmJIup5hOIntb+jjtLNxNg+XV93JVJiI1KfD5PbzF9xu8ZDb
         Zz+kv9mvcDXYKovIsBgsXK46dAkYyHzJGfjVOtgulNgAQ+hh/VSUhqR8AieNRg4c/tSA
         404mFzmsu1hEbNPY304pzn9NotNea7lPVtwH3e706iMwbcNdZlJC6cZBwd5RD405ispE
         yNCQ==
X-Gm-Message-State: AOAM530GcvFi/VcHp/AyHNtHKnsMtHgvb2+cf7WDwnyF20oudWMgcT6A
        7uS9MK0/C0toQGiQeWil6asQImmyGGi7hQjwwP1g
X-Google-Smtp-Source: ABdhPJz7eIBRH8VgX2Zmf/UNErq4oU3Co9Ax6yOSZDoZbVBaR5IrNHQzKXw8PfZCO8wGmn+eYyHmnqnwdcPMdQf5ERg=
X-Received: by 2002:a17:906:1a0d:: with SMTP id i13mr6143661ejf.197.1618541917734;
 Thu, 15 Apr 2021 19:58:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain> <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
 <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain> <80b31814-9e41-3153-7efb-c0c2fab44feb@redhat.com>
 <02c19c22-13ea-ea97-d99b-71edfee0b703@redhat.com> <CACycT3tL7URz3n-KhMAwYH+Sn1e1TSyfU+RKcc8jpPDJ7WcZ2w@mail.gmail.com>
 <5beabeaf-52a6-7ee5-b666-f3616ea82811@redhat.com>
In-Reply-To: <5beabeaf-52a6-7ee5-b666-f3616ea82811@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 16 Apr 2021 10:58:26 +0800
Message-ID: <CACycT3tyksBYxgbQLFJ-mFCKkaWotucM5_ho_K3q4wMpR0P=gw@mail.gmail.com>
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

On Fri, Apr 16, 2021 at 10:20 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/4/15 =E4=B8=8B=E5=8D=887:17, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Thu, Apr 15, 2021 at 5:05 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/4/15 =E4=B8=8B=E5=8D=884:36, Jason Wang =E5=86=99=E9=81=
=93:
> >>>> Please state this explicitly at the start of the document. Existing
> >>>> interfaces like FUSE are designed to avoid trusting userspace.
> >>>
> >>> There're some subtle difference here. VDUSE present a device to kerne=
l
> >>> which means IOMMU is probably the only thing to prevent a malicous
> >>> device.
> >>>
> >>>
> >>>> Therefore
> >>>> people might think the same is the case here. It's critical that peo=
ple
> >>>> are aware of this before deploying VDUSE with virtio-vdpa.
> >>>>
> >>>> We should probably pause here and think about whether it's possible =
to
> >>>> avoid trusting userspace. Even if it takes some effort and costs som=
e
> >>>> performance it would probably be worthwhile.
> >>>
> >>> Since the bounce buffer is used the only attack surface is the
> >>> coherent area, if we want to enforce stronger isolation we need to us=
e
> >>> shadow virtqueue (which is proposed in earlier version by me) in this
> >>> case. But I'm not sure it's worth to do that.
> >>
> >>
> >> So this reminds me the discussion in the end of last year. We need to
> >> make sure we don't suffer from the same issues for VDUSE at least
> >>
> >> https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.=
com/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b
> >>
> >> Or we can solve it at virtio level, e.g remember the dma address inste=
ad
> >> of depending on the addr in the descriptor ring
> >>
> > I might miss something. But VDUSE has recorded the dma address during
> > dma mapping, so we would not do bouncing if the addr/length is invalid
> > during dma unmapping. Is it enough?
>
>
> E.g malicous device write a buggy dma address in the descriptor ring, so
> we had:
>
> vring_unmap_one_split(desc->addr, desc->len)
>      dma_unmap_single()
>          vduse_dev_unmap_page()
>              vduse_domain_bounce()
>
> And in vduse_domain_bounce() we had:
>
>          while (size) {
>                  map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
>                  offset =3D offset_in_page(iova);
>                  sz =3D min_t(size_t, PAGE_SIZE - offset, size);
>
> This means we trust the iova which is dangerous and exacly the issue
> mentioned in the above link.
>
>  From VDUSE level need to make sure iova is legal.
>

I think we already do that in vduse_domain_bounce():

    while (size) {
        map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];

        if (WARN_ON(!map->bounce_page ||
            map->orig_phys =3D=3D INVALID_PHYS_ADDR))
            return;


>  From virtio level, we should not truse desc->addr.
>

We would not touch desc->addr after vring_unmap_one_split(). So I'm
not sure what we need to do at the virtio level.

Thanks,
Yongji
