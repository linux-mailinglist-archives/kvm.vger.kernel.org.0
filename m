Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A866E3F5B70
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 11:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbhHXJxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 05:53:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235842AbhHXJxv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 05:53:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629798787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OQ7wXqd35jkq9u//jEUxGDrlsnHE5KbTspU7KytW0gQ=;
        b=HqDwvJ99XBvCZQC1rPGzjJjsNnGox5/vLTV7sKI/8CokpE54MFitxMGvFhnmAUcVLVkj+G
        4dZfa206SoATwy1RTbUndxLpLyxcR4cRynS9d3uGFDj0vttmO/yWglYNXa7t4VVluAAChG
        rY7vLzrD2LqcH8FDSTjxfebYV/UnOTU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-ZmfbjBqtOz-lAO7wGvaXqA-1; Tue, 24 Aug 2021 05:53:06 -0400
X-MC-Unique: ZmfbjBqtOz-lAO7wGvaXqA-1
Received: by mail-ed1-f71.google.com with SMTP id e3-20020a50ec830000b02903be5be2fc73so10203134edr.16
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 02:53:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OQ7wXqd35jkq9u//jEUxGDrlsnHE5KbTspU7KytW0gQ=;
        b=U66sWK7y2w51kHGX1OtvkurWQaYqUbniwHysDv3/6keZMI0FHsJCgCKD1YhmHA2XKH
         1Xsc3Ez4aKXYWUo1z60EISOUJrs9b8Cq94KFGJa2ehhOexxR0hkHoS+MzZ0HBa9sY+LD
         b3TJYh6j5FXcUpDDIVLMFw9PEb3PO94VvIcj7r+eRvRFaTBar3qy5hzzhX42/Sr51qIq
         ym8dVh4oO5oqoxEbWum1rdPDpptj/sAmMaucbyCwIBScAd5AyTlbOkoyA5t91+g7nh99
         ctgUoO3JlKsejCft/IxiLk6odJCu2o7xls8n+TlwCkA2/QRirc7dD9PMMYe8o0jbJwIR
         fY8g==
X-Gm-Message-State: AOAM5304sgP92XgSvI0vDBcAxsiF+C7yYXP4ZTErZbkGSwRyjzwN/Cf2
        20paWFjz5a1S5auKOG5myb8VClEn2irCM2rOcBDOgeEUnaWB1lrwz9tzgEAevZh/HMIMzieP187
        RyHscTOO0HAHA
X-Received: by 2002:a17:907:1dcf:: with SMTP id og15mr4899940ejc.470.1629798784613;
        Tue, 24 Aug 2021 02:53:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9y5QQWKGxjE2KrEc2IutIocxe55cgt45xzuJQQ4MACHDUf8AJaPA8kHZYDYQkMpudS3S8yg==
X-Received: by 2002:a17:907:1dcf:: with SMTP id og15mr4899921ejc.470.1629798784495;
        Tue, 24 Aug 2021 02:53:04 -0700 (PDT)
Received: from steredhat (host-79-45-8-152.retail.telecomitalia.it. [79.45.8.152])
        by smtp.gmail.com with ESMTPSA id o6sm4341681eje.6.2021.08.24.02.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 02:53:04 -0700 (PDT)
Date:   Tue, 24 Aug 2021 11:53:01 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.co
Subject: Re: [RFC PATCH v3 2/6] virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOR' bit.
Message-ID: <20210824095301.udvwh2hatrf2l3mh@steredhat>
References: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
 <20210816085126.4173978-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210816085126.4173978-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021 at 11:51:23AM +0300, Arseny Krasnov wrote:
>This bit is used to handle POSIX MSG_EOR flag passed from
>userspace in 'sendXXX()' system calls. It marks end of each

Maybe better 'send*()'.

>record and is visible to receiver using 'recvmsg()' system
>call.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/uapi/linux/virtio_vsock.h | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 8485b004a5f8..64738838bee5 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -98,6 +98,7 @@ enum virtio_vsock_shutdown {
> /* VIRTIO_VSOCK_OP_RW flags values */
> enum virtio_vsock_rw {
> 	VIRTIO_VSOCK_SEQ_EOM = 1,
>+	VIRTIO_VSOCK_SEQ_EOR = 2,
> };
>
> #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
>-- 
>2.25.1
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

