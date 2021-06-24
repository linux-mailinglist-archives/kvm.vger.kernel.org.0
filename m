Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048683B25F8
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 06:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFXEFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 00:05:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229924AbhFXEFp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 00:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624507381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t6l8HNUseLWNe4QRrXc5Pxgwkec9RXr3zdcloJqebyc=;
        b=gLVhDbID8o+MCAotB9oBrboA8Z3X58AE9zXVhWit2X/zYiiEi3AljxMpNralw70AJQxrbW
        Yi0xe2Y5z9qVkxjtJ60hyvbjovBnWFbegieiyLFet2Vbx/u2VskGXGPl1vN06pmOfSjxuy
        VN+gEMX0Ba9Gn0IxZ4EpWpfFG3HSQ6U=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-0rrkw6C2OE6jp_y0OTZQ3A-1; Thu, 24 Jun 2021 00:02:59 -0400
X-MC-Unique: 0rrkw6C2OE6jp_y0OTZQ3A-1
Received: by mail-pj1-f69.google.com with SMTP id p22-20020a17090a9316b029016a0aced749so2655465pjo.9
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 21:02:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=t6l8HNUseLWNe4QRrXc5Pxgwkec9RXr3zdcloJqebyc=;
        b=eOPdWIuKw2CfPbVvShpXS9MWYbv0mj6OZ4+ih4xveKgCqFcR/lSWjM0PVH9BA/k+vO
         POJgJkN27vNI5B3wTemwK6f7IigOe3ODZ/dfyq1++S13BW2qxEKUYMY9SPJnPXNB9k0k
         WvX6ORhcgGgHi37GbVfzATJziC59bsI7C7G1+N7MtKWqFrpppWDN2tFQfemdC9JvcFeH
         R5Kz+OxbJw9IJ7u7r4zw3MkJplC0GybOcyES4pSOqzPQ3DRmzGRNKPLD5jonIAGxESFA
         APeVmerqMXYGPYTuYnWOo4iiLBB/QvMvD6gA6e+dhN4gi6BpbK3+gD9qDvvrUSwWasia
         l+5Q==
X-Gm-Message-State: AOAM531EYZFiEzOZiyYqRnltpGhSpUh53uuMXHjH5P9kHrmHcVsNtLXC
        ku801xjtR7JTISpoUJx9Tm4UEUL7FjHGwE8XC5XWuGw69AadW7g4Pd0VWwHd13fehloWZYDZSd6
        c0tfmm5dQmpg0VMZZr+EuBDKJt9vQ77Dp8NJfbIdKHJbQHnrkQT3dcM1t0DljrSd7
X-Received: by 2002:a17:90a:bc89:: with SMTP id x9mr3143560pjr.228.1624507378392;
        Wed, 23 Jun 2021 21:02:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxANFKxiBZPVYUWF8G1+pn0yAJ3j5nPH8r+gAHEprM5IowLdBJhaK1UbOKwNKvW/vGrG1fMTQ==
X-Received: by 2002:a17:90a:bc89:: with SMTP id x9mr3143534pjr.228.1624507378157;
        Wed, 23 Jun 2021 21:02:58 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b6sm599868pgw.67.2021.06.23.21.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 21:02:57 -0700 (PDT)
Subject: Re: [PATCH v2] virtio_net/vringh: add "else { }" according coding
 style
To:     Cai Huoqing <caihuoqing@baidu.com>, mst@redhat.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210624011757.338-1-caihuoqing@baidu.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <93b1bdd8-93b7-9e85-7c52-9b4b8ff36292@redhat.com>
Date:   Thu, 24 Jun 2021 12:02:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624011757.338-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/24 ÉÏÎç9:17, Cai Huoqing Ð´µÀ:
> coding-style.rst shows that:
>          if (condition) {
>                  do_this();
>                  do_that();
>          } else {
>                  otherwise();
>          }


So git grep told me there're at least 28 similar "issues" in 
drivers/virito. And there will be a lot in the other part of the kernel

I think it's not worth to bother. We can start to work on something that 
is really interesting.

E.g we had the plan to convert to use iov iterator instead of using a 
vringh specific iov "iterator" implementation. Do you want to do that?

Thanks


>
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>   drivers/net/virtio_net.c | 3 ++-
>   drivers/vhost/vringh.c   | 3 ++-
>   2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 21ff7b9e49c2..7cd062cb468e 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -314,8 +314,9 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
>                  rq->pages = (struct page *)p->private;
>                  /* clear private here, it is used to chain pages */
>                  p->private = 0;
> -       } else
> +       } else {
>                  p = alloc_page(gfp_mask);
> +       }
>          return p;
>   }
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 4af8fa259d65..79542cad1072 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -454,8 +454,9 @@ static inline int __vringh_complete(struct vringh *vrh,
>                  if (!err)
>                          err = putused(vrh, &used_ring->ring[0], used + part,
>                                        num_used - part);
> -       } else
> +       } else {
>                  err = putused(vrh, &used_ring->ring[off], used, num_used);
> +       }
>
>          if (err) {
>                  vringh_bad("Failed to write %u used entries %u at %p",
> --
> 2.17.1
>

