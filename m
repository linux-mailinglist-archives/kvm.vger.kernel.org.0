Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F9C201A61
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 20:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732009AbgFSS0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 14:26:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24811 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728522AbgFSS03 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 14:26:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592591187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o7jACTPMklupBCcyQ4Eej+eEvNAjD27aYrs6PEc/vLM=;
        b=Hu+g/wioYbreRDmEZA02uco8afd2fu9cS+f7wK2b9Huzy8mjkqz8MR4Dgxs5ZIezHNBloo
        IPml2XoI6kQpYGC8ibLDTOL7eVtFBan2mMYCw4KydxsB420PXdPMthtSmXcK99sw1URPBt
        xSafn/Qx+rq7TH6/8sryXdbS94rhG0Y=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-GPLmRYpFOSSrZzwj5jdqCQ-1; Fri, 19 Jun 2020 14:26:25 -0400
X-MC-Unique: GPLmRYpFOSSrZzwj5jdqCQ-1
Received: by mail-qt1-f197.google.com with SMTP id x6so5848801qtq.1
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 11:26:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o7jACTPMklupBCcyQ4Eej+eEvNAjD27aYrs6PEc/vLM=;
        b=MXlAWQVElfoctPQJX6XMcV8x24T8sDQSKwbr/72TIyJdoRYe0GdfYkDAM5x+eJ+9hk
         iK3/MRpGacuTW5o+cDV0iqlhSsu4nQ16eP3H0gZ3tZhR3zXCbhbrBBvM0nQGRscn+qRE
         Y1IkwO9uvDGPwlw7gytS/Pa9K13AEHp+j2RgVC1fauQc7S7i3ks+o/WYusGbipMT1SbO
         vOpGTZbaIR/SM4FfBrXTl5JFMPpXoeoLgcOzeIETxN+zQJ4Tmujkv/yCUmqOLySY6tkS
         XK3bHAvRWZqTa8VpIji1+QdumxKipMkq1kg8h80aUvW1KU86gY7GcJSVfthXVLs2VSOx
         DV7g==
X-Gm-Message-State: AOAM531Jq5dtFCR4z8W9Oz362J2n4yLL/mB9+8Y7RmYSc6w/L5JbzFFJ
        lvPe9uQFR+AOjYmNPrKnPntMca/Srb+jck+u3Bkb5d/H2nHThS5e/rGym4BLG8wEbnrnxFpXwMh
        E+SNIhuh0jta6cuROWZ89CKnBM2JO
X-Received: by 2002:aed:2171:: with SMTP id 104mr2351982qtc.22.1592591184845;
        Fri, 19 Jun 2020 11:26:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmu89J2VMwmehul4uuct4yakQaH6gNxgS333NyHo7rSAKDL/C3Yad8XzwEayBTHv1AAc0+ox+DOJ6fz/Cp2Vk=
X-Received: by 2002:aed:2171:: with SMTP id 104mr2351958qtc.22.1592591184592;
 Fri, 19 Jun 2020 11:26:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <20200611152257.GA1798@char.us.oracle.com> <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
 <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
In-Reply-To: <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 19 Jun 2020 20:25:48 +0200
Message-ID: <CAJaqyWe1+FmPC9L_+8oGfYUT63BaWuGrOnkRnUcGapvwtzqmPw@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 19, 2020 at 8:07 PM Eugenio Perez Martin
<eperezma@redhat.com> wrote:
>
> On Mon, Jun 15, 2020 at 2:28 PM Eugenio Perez Martin
> <eperezma@redhat.com> wrote:
> >
> > On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
> > <konrad.wilk@oracle.com> wrote:
> > >
> > > On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin wrote:
> > > > As testing shows no performance change, switch to that now.
> > >
> > > What kind of testing? 100GiB? Low latency?
> > >
> >
> > Hi Konrad.
> >
> > I tested this version of the patch:
> > https://lkml.org/lkml/2019/10/13/42
> >
> > It was tested for throughput with DPDK's testpmd (as described in
> > http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html)
> > and kernel pktgen. No latency tests were performed by me. Maybe it is
> > interesting to perform a latency test or just a different set of tests
> > over a recent version.
> >
> > Thanks!
>
> I have repeated the tests with v9, and results are a little bit different:
> * If I test opening it with testpmd, I see no change between versions
> * If I forward packets between two vhost-net interfaces in the guest
> using a linux bridge in the host:
>   - netperf UDP_STREAM shows a performance increase of 1.8, almost
> doubling performance. This gets lower as frame size increase.
>   - rests of the test goes noticeably worse: UDP_RR goes from ~6347
> transactions/sec to 5830
>   - TCP_STREAM goes from ~10.7 gbps to ~7Gbps
>   - TCP_RR from 6223.64 transactions/sec to 5739.44

And I forgot to add: It seems that avoiding IOV length math helps,
since performance increases in all tests from patch 02/11 ("vhost: use
batched get_vq_desc version") to 11/11 ("vhost: drop head based
APIs").

