Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28493CF599
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 09:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhGTHOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 03:14:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233030AbhGTHOW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Jul 2021 03:14:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626767700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f4xS+Xn7d/Hv2qOixfVLURwcqLkm25EKLyV4db7jn+U=;
        b=bfxBRyTBVBC33lmDNdmKYELgdsmMmzd7ZGZcJwEQNs1SXDC0Q8Ly/pqoWH8FwPwfDoW3ze
        TQF8vApkHUJlDLCUxshuW0Sa6rEi+8uaOwFyandDO6ywEiKT91cmD+OuQ4jT22C3FUJ+jm
        3wy/lU/CDjuc/hxTHhIVVB0ASyOkb2s=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-JKPEB47dP3-fjYBm6RJpHA-1; Tue, 20 Jul 2021 03:54:59 -0400
X-MC-Unique: JKPEB47dP3-fjYBm6RJpHA-1
Received: by mail-pl1-f197.google.com with SMTP id u15-20020a1709026e0fb0290128b23b05c2so4385847plk.4
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 00:54:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=f4xS+Xn7d/Hv2qOixfVLURwcqLkm25EKLyV4db7jn+U=;
        b=PrJyQ830VS7PXgZVaVDi/n14hdi4BpKWd6lZdM2wAufYRLi9Qpp7KD4NNqEk/Oi/Fn
         oShy4n2+qpre0aAJ6eEsGY9IginLJFbk14O+gx8fTZTnUuyB6jCNMDC161pQHn+6znAx
         gmtxhLZzTVf2Asah03aAZSyG+1Dmj+r7lW4cMPMiYSQBDx1CalwGRACn/223WFlny61y
         SuyAV5mwAn+kn9rugl8ypwmHzOogNcoaMigjZmI4b8DNRnkS9r6QopnudoBts/IIUxhC
         puqHV7KMa/Ci90/p9lxrn3IsYHWI8aLB1beJRCXAbk4I9PtW52jlGBrAHLkbIgAacZIo
         85ng==
X-Gm-Message-State: AOAM53090GaSKSTfcBfe9vmAAybbdlM5LQoM5z0YW6g+OWYE6Mg0v6IA
        ViIL/8+huM4wZPjkppSusuif2DdZaZqWuMUuIIYKvMSLIag+Oiel5FnzO/EQ/4kzuagwwiqcrF+
        IA4ri5IrXrbwU
X-Received: by 2002:a17:90a:b78d:: with SMTP id m13mr23352984pjr.60.1626767698575;
        Tue, 20 Jul 2021 00:54:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXnQ+rg5UaIdGhKi/NFptG4RFBi9zHlqOmm3vU/LHn1hob4QbTpB1HpUcdfV/d8ngFK0/JqQ==
X-Received: by 2002:a17:90a:b78d:: with SMTP id m13mr23352974pjr.60.1626767698380;
        Tue, 20 Jul 2021 00:54:58 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f19sm18647355pjj.22.2021.07.20.00.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 00:54:57 -0700 (PDT)
Subject: Re: [PATCH v2] vsock/virtio: set vsock frontend ready in
 virtio_vsock_probe()
To:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210720071337.1995-1-xianting.tian@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <87deb4ff-c4f9-0a5e-e349-c1a8682a864e@redhat.com>
Date:   Tue, 20 Jul 2021 15:54:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720071337.1995-1-xianting.tian@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/7/20 下午3:13, Xianting Tian 写道:
> Add the missed virtio_device_ready() to set vsock frontend ready.
>
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>   net/vmw_vsock/virtio_transport.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index e0c2c992a..dc834b8fd 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -639,6 +639,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>   
>   	mutex_unlock(&the_virtio_vsock_mutex);
>   
> +	virtio_device_ready(vdev);
> +
>   	return 0;
>   
>   out:


Just notice this:

commit 5b40a7daf51812b35cf05d1601a779a7043f8414
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Feb 17 16:12:44 2015 +1030

     virtio: don't set VIRTIO_CONFIG_S_DRIVER_OK twice.

     I noticed this with the console device.  It's not *wrong*, just a bit
     weird.

     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index b9f70dfc4751..5ce2aa48fc6e 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -236,7 +236,10 @@ static int virtio_dev_probe(struct device *_d)
         if (err)
                 goto err;

-       add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK);
+       /* If probe didn't do it, mark device DRIVER_OK ourselves. */
+       if (!(dev->config->get_status(dev) & VIRTIO_CONFIG_S_DRIVER_OK))
+               virtio_device_ready(dev);
+
         if (drv->scan)
                 drv->scan(dev);

So I think we need to be consistent: switch to use virtio_device_ready() 
for all the drivers, and then we can remove this step and warn if 
(DRIVER_OK) is not set.

Thanks

