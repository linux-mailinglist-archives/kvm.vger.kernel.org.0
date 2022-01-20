Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF39E4952B5
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 17:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377174AbiATQ4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 11:56:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377163AbiATQ4J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 11:56:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642697768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8mR9FRdz8I70HhOfwdXd7Kde0lgoBA3u1XOQMHhojHo=;
        b=Cmyvq+bo/gfr0Tp6xWVV+nsnsvfNEzfI30IAZQd6ArSQrFhDIpPM/9WzMF4/h+0I18Hf86
        anleRtZvZJ+/RxpwDqmVZ7kUQwE5iDxSnCUTK+/nnL33M5919JHgcy+QASB4HfBjyxjDQb
        izdgipBRyrWiMIrPH/Z2sq2sTqPNNxg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-O3KoyG_LMtGkL5pNKU3qSw-1; Thu, 20 Jan 2022 11:56:07 -0500
X-MC-Unique: O3KoyG_LMtGkL5pNKU3qSw-1
Received: by mail-wm1-f72.google.com with SMTP id c188-20020a1c35c5000000b00346a2160ea8so3157235wma.9
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 08:56:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8mR9FRdz8I70HhOfwdXd7Kde0lgoBA3u1XOQMHhojHo=;
        b=RI2hJfrBzowJbpHo88k5CmyQ5DQqDRGK41KUqTxJEkKN5lc/qo1botYz7ULo8Qr8ub
         BcVdq5vDsfA0eynnH9MgVWkSmsnxYELjul0Egxutfnw27RXA9wUai49OE70vKxZAKkMI
         l9wk2xDYCqexOleBTOJ27rrf5nbzjpeyBvIV98pP6t6Gua4bksco5ZYB1xJtHJATmyav
         EDDfYy/2WZmaSstEmnK+l+uI/yzsJ4dFspptYT7RTeVSXtVh0w7ZE1suA4HfZm5yzLlG
         a0dsJV2kjZgHvS03tA+tuY2eJzvBa/l4uNSu9TbeNtRyF1vPj3WVJERqL3LQLWujxC45
         ZSvQ==
X-Gm-Message-State: AOAM532eqT9+I+KscWrvjVbVOuQBrhELAOf/y4rfrQ5SWZlNapxX0OfY
        q6zOz6n9LwwrwR7+MZ46YLxoUQhXN5vuYEfjes6zfYBX5+lnEYtPHnVtB0omRalJqL/j7STpeRW
        lCNEW8Gfztnom
X-Received: by 2002:a05:600c:4fd4:: with SMTP id o20mr9720469wmq.155.1642697764817;
        Thu, 20 Jan 2022 08:56:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz602JhtDTuZNmSMn/pluyt75fBTOcXq6oo9TvSS1+J7M5aQjpPqI7Y4TSrYEBGLNgdGX93aA==
X-Received: by 2002:a05:600c:4fd4:: with SMTP id o20mr9720458wmq.155.1642697764623;
        Thu, 20 Jan 2022 08:56:04 -0800 (PST)
Received: from redhat.com ([2.55.158.216])
        by smtp.gmail.com with ESMTPSA id l13sm4525133wry.87.2022.01.20.08.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 08:56:03 -0800 (PST)
Date:   Thu, 20 Jan 2022 11:55:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Linux Virtualization <virtualization@lists.linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kvm <kvm@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v1] vhost: cache avail index in vhost_enable_notify()
Message-ID: <20220120115520-mutt-send-email-mst@kernel.org>
References: <20220114090508.36416-1-sgarzare@redhat.com>
 <20220114074454-mutt-send-email-mst@kernel.org>
 <20220114133816.7niyaqygvdveddmi@steredhat>
 <20220114084016-mutt-send-email-mst@kernel.org>
 <CAGxU2F7r6cH9Ywygv1QNxKyfyn=yGoDPNDQ-tHkeFMUcbpfXYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F7r6cH9Ywygv1QNxKyfyn=yGoDPNDQ-tHkeFMUcbpfXYA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 20, 2022 at 04:08:39PM +0100, Stefano Garzarella wrote:
> On Fri, Jan 14, 2022 at 2:40 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Jan 14, 2022 at 02:38:16PM +0100, Stefano Garzarella wrote:
> > > On Fri, Jan 14, 2022 at 07:45:35AM -0500, Michael S. Tsirkin wrote:
> > > > On Fri, Jan 14, 2022 at 10:05:08AM +0100, Stefano Garzarella wrote:
> > > > > In vhost_enable_notify() we enable the notifications and we read
> > > > > the avail index to check if new buffers have become available in
> > > > > the meantime.
> > > > >
> > > > > We are not caching the avail index, so when the device will call
> > > > > vhost_get_vq_desc(), it will find the old value in the cache and
> > > > > it will read the avail index again.
> > > > >
> > > > > It would be better to refresh the cache every time we read avail
> > > > > index, so let's change vhost_enable_notify() caching the value in
> > > > > `avail_idx` and compare it with `last_avail_idx` to check if there
> > > > > are new buffers available.
> > > > >
> > > > > Anyway, we don't expect a significant performance boost because
> > > > > the above path is not very common, indeed vhost_enable_notify()
> > > > > is often called with unlikely(), expecting that avail index has
> > > > > not been updated.
> > > > >
> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > >
> > > > ... and can in theory even hurt due to an extra memory write.
> > > > So ... performance test restults pls?
> > >
> > > Right, could be.
> > >
> > > I'll run some perf test with vsock, about net, do you have a test suite or
> > > common step to follow to test it?
> > >
> > > Thanks,
> > > Stefano
> >
> > You can use the vhost test as a unit test as well.
> 
> Thanks for the advice, I did indeed use it!
> 
> I run virtio_test (with vhost_test.ko) using 64 as batch to increase the 
> chance of the path being taken. (I changed bufs=0x1000000 in 
> virtio_test.c to increase the duration).
> 
> I used `perf stat` to take some numbers, running this command:
> 
>    taskset -c 2 perf stat -r 10 --log-fd 1 -- ./virtio_test --batch=64
> 
> - Linux v5.16 without the patch applied
> 
>  Performance counter stats for './virtio_test --batch=64' (10 runs):
> 
>           2,791.70 msec task-clock                #    0.996 CPUs utilized            ( +-  0.36% )
>                 23      context-switches          #    8.209 /sec                     ( +-  2.75% )
>                  0      cpu-migrations            #    0.000 /sec
>                 79      page-faults               #   28.195 /sec                     ( +-  0.41% )
>      7,249,926,989      cycles                    #    2.587 GHz                      ( +-  0.36% )
>      7,711,999,656      instructions              #    1.06  insn per cycle           ( +-  1.08% )
>      1,838,436,806      branches                  #  656.134 M/sec                    ( +-  1.44% )
>          3,055,439      branch-misses             #    0.17% of all branches          ( +-  6.22% )
> 
>             2.8024 +- 0.0100 seconds time elapsed  ( +-  0.36% )
> 
> - Linux v5.16 with this patch applied
> 
>  Performance counter stats for './virtio_test --batch=64' (10 runs):
> 
>           2,753.36 msec task-clock                #    0.998 CPUs utilized            ( +-  0.20% )
>                 24      context-switches          #    8.699 /sec                     ( +-  2.86% )
>                  0      cpu-migrations            #    0.000 /sec
>                 76      page-faults               #   27.545 /sec                     ( +-  0.56% )
>      7,150,358,721      cycles                    #    2.592 GHz                      ( +-  0.20% )
>      7,420,639,950      instructions              #    1.04  insn per cycle           ( +-  0.76% )
>      1,745,759,193      branches                  #  632.730 M/sec                    ( +-  1.03% )
>          3,022,508      branch-misses             #    0.17% of all branches          ( +-  3.24% )
> 
>            2.75952 +- 0.00561 seconds time elapsed  ( +-  0.20% )
> 
> 
> The difference seems minimal with a slight improvement.
> 
> To try to stress the patch more, I modified vhost_test.ko to call 
> vhost_enable_notify()/vhost_disable_notify() on every cycle when calling 
> vhost_get_vq_desc():
> 
> - Linux v5.16 modified without the patch applied
> 
>  Performance counter stats for './virtio_test --batch=64' (10 runs):
> 
>           4,126.66 msec task-clock                #    1.006 CPUs utilized            ( +-  0.25% )
>                 28      context-switches          #    6.826 /sec                     ( +-  3.41% )
>                  0      cpu-migrations            #    0.000 /sec
>                 85      page-faults               #   20.721 /sec                     ( +-  0.44% )
>     10,716,808,883      cycles                    #    2.612 GHz                      ( +-  0.25% )
>     11,804,381,462      instructions              #    1.11  insn per cycle           ( +-  0.86% )
>      3,138,813,438      branches                  #  765.153 M/sec                    ( +-  1.03% )
>         11,286,860      branch-misses             #    0.35% of all branches          ( +-  1.23% )
> 
>             4.1027 +- 0.0103 seconds time elapsed  ( +-  0.25% )
> 
> - Linux v5.16 modified with this patch applied
> 
>  Performance counter stats for './virtio_test --batch=64' (10 runs):
> 
>           3,953.55 msec task-clock                #    1.001 CPUs utilized            ( +-  0.33% )
>                 29      context-switches          #    7.345 /sec                     ( +-  2.67% )
>                  0      cpu-migrations            #    0.000 /sec
>                 83      page-faults               #   21.021 /sec                     ( +-  0.65% )
>     10,267,242,653      cycles                    #    2.600 GHz                      ( +-  0.33% )
>      7,972,866,579      instructions              #    0.78  insn per cycle           ( +-  0.21% )
>      1,663,770,390      branches                  #  421.377 M/sec                    ( +-  0.45% )
>         16,986,093      branch-misses             #    1.02% of all branches          ( +-  0.47% )
> 
>             3.9489 +- 0.0130 seconds time elapsed  ( +-  0.33% )
> 
> In this case the difference is bigger, with a reduction in execution 
> time (3.7 %) and fewer branches and instructions. It should be the 
> branch `if (vq->avail_idx == vq->last_avail_idx)` in vhost_get_vq_desc() 
> that is not taken.
> 
> Should I resend the patch adding some more performance information?
> 
> Thanks,
> Stefano

Yea, pls do. You can just summarize it in a couple of lines.

-- 
MST

