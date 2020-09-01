Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A3E258D4B
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 13:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgIALRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 07:17:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28149 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726528AbgIALOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 07:14:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598958882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=STUtmyXZIT8KzVqJU5XU2kgQYureljA3Ku1GnLyYimw=;
        b=eflOJVhF4wU+cFqUufWQbmr0ly5UkDL027i6zHChfvAQluBtOVBB4t57Etw0iwiwLuknIz
        C6FLshb30wE32PSSs983xOx0tIM6rykIBvq30gSH9SFKbVc3QUbXjr9TdjJVwszXqM9Emt
        w5CIgpqc5ub7CF0uOXucpuBdge+yn2I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-dHmqPyfhNYSCw35OH8jQ8A-1; Tue, 01 Sep 2020 07:14:40 -0400
X-MC-Unique: dHmqPyfhNYSCw35OH8jQ8A-1
Received: by mail-wm1-f70.google.com with SMTP id c72so277433wme.4
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 04:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=STUtmyXZIT8KzVqJU5XU2kgQYureljA3Ku1GnLyYimw=;
        b=mcwrMCRdDdNw3n7pncktacisgm3ewomb3u4tIkoPGHkt0hnXwIWKrKrt02sN5FnQm5
         Oi+j/4yqcEZjWt3RzI8W7qg4pBB24wVP4hUkZR8JXUBuqcToYSImg9NRj7ebxuyMu4kq
         BcysyLemYl2cexFV11Z5gS9tGYkekbW+zgbJLTA9ZGnW5VET2t6s3D7pUFZS7NRWip9y
         UDS7O2dASHKMivimOcMuSCioqjCA2BaiOgMbxlA2rQ4fyj/OB9c6f5urW91f/y0L69U3
         sv/pbgRJbi+PgRbmWr9PXCpKomQsYE8bSWElZO7DzuRJ9IbUdJPKNRlxS8DKygldoIs4
         E71A==
X-Gm-Message-State: AOAM532Iyv8EMtoszVBdiegI3sUAhHGf7XSUuB7KORVHNy/R+YZJ8Mka
        5qBo+MrrARzQ6MZmmBg8Ahu9zATySSHdi5mfrFoMdAFyL6xZc0z/TGF/6Bxohmsn/08/SWvoAz/
        1ch9K+Z3jzHkQ
X-Received: by 2002:a7b:c925:: with SMTP id h5mr1261026wml.28.1598958879596;
        Tue, 01 Sep 2020 04:14:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhiep0HYoVEPjzoTxNmrDMLvfem8Qoq1Zugr1LpbcVQJKpBDMnkFnDG0mj5yp0i4zCh7HKeg==
X-Received: by 2002:a7b:c925:: with SMTP id h5mr1261007wml.28.1598958879391;
        Tue, 01 Sep 2020 04:14:39 -0700 (PDT)
Received: from redhat.com (bzq-79-181-14-13.red.bezeqint.net. [79.181.14.13])
        by smtp.gmail.com with ESMTPSA id d18sm1614949wrm.10.2020.09.01.04.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:14:38 -0700 (PDT)
Date:   Tue, 1 Sep 2020 07:14:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH net-next] vhost: fix typo in error message
Message-ID: <20200901071400-mutt-send-email-mst@kernel.org>
References: <1598927949-201997-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598927949-201997-1-git-send-email-linyunsheng@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 01, 2020 at 10:39:09AM +0800, Yunsheng Lin wrote:
> "enable" should be "disable" when the function name is
> vhost_disable_notify(), which does the disabling work.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Why net-next though? It's a bugfix, can go into net.


> ---
>  drivers/vhost/vhost.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 5857d4e..b45519c 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2537,7 +2537,7 @@ void vhost_disable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>  	if (!vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
>  		r = vhost_update_used_flags(vq);
>  		if (r)
> -			vq_err(vq, "Failed to enable notification at %p: %d\n",
> +			vq_err(vq, "Failed to disable notification at %p: %d\n",
>  			       &vq->used->flags, r);
>  	}
>  }
> -- 
> 2.8.1

