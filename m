Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D7432E028
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 04:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhCEDh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 22:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCEDh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 22:37:59 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAC6C061756
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 19:37:58 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ci14so787155ejc.7
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 19:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EWyxb7ZF0q19re3TKnDSqg2Hfk1VfihXa9QY0hUoz9E=;
        b=q6E6/P5/bLlbRqpphJ58eBSCESMSvgxSXNCtDtRBh552X89e/X9AjirV47s7IKejog
         v0nPYNio+rfkWbsdD6WDsBKTUkTRMNV1XsouZ9mtTITDFQFvL/3sMxTa6hWUL2iObq5l
         PapF7w2o+muJDMtwcS4u+V3+gMYH0jpuDPwikrc8JFM87GbI/KBiy2U7gPqXolHOSImE
         igZ8wiHwfhBi5NdtsctAfNLkgCOr6L/viDXArLVBLvmU/BNDadMsGlhyQtcCbOqqVs29
         8APP6k8ly1mdbmV6A/zPSn7OpCL8e4+Mpp6j4muJam6YVWK60LTRQtOdnsp5BdTXxcgH
         WeXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EWyxb7ZF0q19re3TKnDSqg2Hfk1VfihXa9QY0hUoz9E=;
        b=V5yWqjKucqzbtzC5aNruR2Q57uTZsUwY5UywZ7+Fs8xX+xYmvEczLz1m4iWHGw6/Tp
         A2IaQgPZ9XeDfi4L16VUcukXwlSV8lsmA8DmfO5/9SaVwwaMU9HYhSg0dBqxYODpklK6
         boNsmmIvVWnDyJ/EpLfrGV8Hp0wBjkTScPBJZkpIfA2lxCl3So74s58jQn1He2q+YtMt
         gekYkIOVGfDrepEuNIJtF3dtPZUwXe5CEAlIYiGDJnZQC74tFj8x5EsW/5mzCKQTCcAv
         vdtvvCSzxSE8RpcQn4cXN/m8TIdpnYCqyL4PX82SBqnNwyD6PwFb+aDxvcLyfBWFiHwo
         bVjQ==
X-Gm-Message-State: AOAM531BCpETb1mHHkXQoK0QEHPKwpQ+9K9CLKQgJk4WVWaOnjbQvWad
        YFZUh8oT5KtYGzqft6HvtXm8KoS9Aqz8ZrLiZ+7W
X-Google-Smtp-Source: ABdhPJxWFC4tVSup0eWv+uEIXAYfO9dxY1nbFMC/0JFD8gj7j27meC0DHlK8QAEMC2JqjU1V79+K7Z37BKD35+Dm2mg=
X-Received: by 2002:a17:906:1b41:: with SMTP id p1mr552966ejg.174.1614915477313;
 Thu, 04 Mar 2021 19:37:57 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-12-xieyongji@bytedance.com>
 <d104a518-799d-c13f-311c-f7a673f9241b@redhat.com> <CACycT3uaOU5ybwojfiSL0kSpW9GUnh82ZeDH7drdkfK72iP8bg@mail.gmail.com>
 <86af7b84-23f0-dca7-183b-e4d586cbcea6@redhat.com>
In-Reply-To: <86af7b84-23f0-dca7-183b-e4d586cbcea6@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 5 Mar 2021 11:37:46 +0800
Message-ID: <CACycT3s+eO7Qi8aPayLbfNnLqOK_q1oB6+d+51hudd-zZf7n8w@mail.gmail.com>
Subject: Re: Re: [RFC v4 11/11] vduse: Support binding irq to the specified cpu
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 5, 2021 at 11:11 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/4 4:19 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> > On Thu, Mar 4, 2021 at 3:30 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> >>> Add a parameter for the ioctl VDUSE_INJECT_VQ_IRQ to support
> >>> injecting virtqueue's interrupt to the specified cpu.
> >>
> >> How userspace know which CPU is this irq for? It looks to me we need t=
o
> >> do it at different level.
> >>
> >> E.g introduce some API in sys to allow admin to tune for that.
> >>
> >> But I think we can do that in antoher patch on top of this series.
> >>
> > OK. I will think more about it.
>
>
> It should be soemthing like
> /sys/class/vduse/$dev_name/vq/0/irq_affinity. Also need to make sure
> eventfd could not be reused.
>

Looks like we doesn't use eventfd now. Do you mean we need to use
eventfd in this case?

Thanks,
Yongji
