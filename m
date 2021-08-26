Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004513F812F
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 05:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbhHZDbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 23:31:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236845AbhHZDbI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Aug 2021 23:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629948620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eEAbeV6QhPu84KG5CC307zTKXbX2UdBwPkKc0p1KhSE=;
        b=G9aAHO3qBliltCFQA5BSZpizX/RxIZ1jkDGhVmlf2+DfOjwRmUUgGkwe4Jm+2NMcVS+Pop
        Rl7zyPl8Rapke5PvlBI//IhJZYz5bmUIfy+eypnqcFkisIEEJ7FHjDzJmzn+WvXzwG9DG3
        cQpy5zutsS/qKhYks4KseRn/lYl9wZU=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-eKQSZVIoPBeUNi1ooWAL8A-1; Wed, 25 Aug 2021 23:30:19 -0400
X-MC-Unique: eKQSZVIoPBeUNi1ooWAL8A-1
Received: by mail-lf1-f71.google.com with SMTP id x7-20020ac259c70000b02903c7883796e9so477687lfn.11
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 20:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eEAbeV6QhPu84KG5CC307zTKXbX2UdBwPkKc0p1KhSE=;
        b=bMwEq53wG7RvtU3RMpvx2kta8rEh9ZynmTzHEZpMO5U/VoopEp8OCvBNUpa3Rc9k+4
         ODgHgpsvOTBzYDhNKx0hUFLUvIpkApDkIOw0CsV5OLiQUzIuhZpa/4LbDl4D66GKRVhB
         QvJYkHjA+9ilnPY3ipMUd4c2uikQASy+veFrwo31zpAAX7AqYFYociwtR1HH7wrUZnCa
         xn9j6fPLBvbb9egp5ws7vbPretuihFm5jhYoXqV37HAsJlLOdUOLZpTSLCVo7d5s8lnw
         IxRfBdxLju7E3OdOldic7BHqto7OZMSCA8uiy1XYRRtD1nVBW+6cKt26N25ISphJ922Y
         2coA==
X-Gm-Message-State: AOAM530zpw8AuI1FCxMIquSbeMTTp6DL5cqh8UT+TLBLkjVVRyZ6NEXG
        SM3+wMww5d3R+wPApr0XYO2z8lVtp3Cfsyq0hYtTTqHh8U5LZcaVXqd5Guy+E+ONUXcG+sgB9m/
        7rY+NNCHPKUCzhJTQsRA0k5zAcpAD
X-Received: by 2002:a05:651c:10a3:: with SMTP id k3mr1143748ljn.471.1629948617804;
        Wed, 25 Aug 2021 20:30:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyovJ4/uCaZXr4m33mK988gFYVkr+C8ARZKldn+ftKy6xj/3lgAQDoaX2wc7igzKNKlWI3wDnMsLWgS4jENFjA=
X-Received: by 2002:a05:651c:10a3:: with SMTP id k3mr1143728ljn.471.1629948617641;
 Wed, 25 Aug 2021 20:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <1629946187-60536-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1629946187-60536-1-git-send-email-linyunsheng@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 26 Aug 2021 11:30:06 +0800
Message-ID: <CACGkMEsphZkkRv5AnXUE_86FUKHMgTXpyVVgDUb+tNdATKQsWA@mail.gmail.com>
Subject: Re: [PATCH net-next] sock: remove one redundant SKB_FRAG_PAGE_ORDER macro
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        linuxarm@openeuler.org, mst <mst@redhat.com>,
        Eric Dumazet <edumazet@google.com>, pabeni@redhat.com,
        fw@strlen.de, aahringo@redhat.com,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>, yangbo.lu@nxp.com,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 10:51 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> Both SKB_FRAG_PAGE_ORDER are defined to the same value in
> net/core/sock.c and drivers/vhost/net.c.
>
> Move the SKB_FRAG_PAGE_ORDER definition to net/core/sock.h,
> as both net/core/sock.c and drivers/vhost/net.c include it,
> and it seems a reasonable file to put the macro.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

>  drivers/vhost/net.c | 2 --
>  include/net/sock.h  | 1 +
>  net/core/sock.c     | 1 -
>  3 files changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 6414bd5..3a249ee 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -643,8 +643,6 @@ static bool tx_can_batch(struct vhost_virtqueue *vq, size_t total_len)
>                !vhost_vq_avail_empty(vq->dev, vq);
>  }
>
> -#define SKB_FRAG_PAGE_ORDER     get_order(32768)
> -
>  static bool vhost_net_page_frag_refill(struct vhost_net *net, unsigned int sz,
>                                        struct page_frag *pfrag, gfp_t gfp)
>  {
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 95b2577..66a9a90 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2717,6 +2717,7 @@ extern int sysctl_optmem_max;
>  extern __u32 sysctl_wmem_default;
>  extern __u32 sysctl_rmem_default;
>
> +#define SKB_FRAG_PAGE_ORDER    get_order(32768)
>  DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
>
>  static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 950f1e7..62627e8 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2574,7 +2574,6 @@ static void sk_leave_memory_pressure(struct sock *sk)
>         }
>  }
>
> -#define SKB_FRAG_PAGE_ORDER    get_order(32768)
>  DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
>
>  /**
> --
> 2.7.4
>

