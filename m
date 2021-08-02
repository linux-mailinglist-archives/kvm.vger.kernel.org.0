Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6083DE045
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 21:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhHBTqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 15:46:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229537AbhHBTqY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 15:46:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627933574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u4LSyR/0hL97TpqHNN7IRSJmq939orqyXRewz9/HhmU=;
        b=DnsxoZIr7cBwKawm3gdKJJmiFfByy0pbZZ0dI3n5SpMT+mrwlWhG0JOQGTGOAyVb5EyBk/
        gmN6DXD5wwEbYEgc7YkeNgWOgVmxB5++E7sr/Wt6JdTM4nHUkWSs+s0SNEZB9R9o4MwfAM
        1Wf9sUobgbAECXcTjmnSuiZIdya9YBk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-WD3A30pYOZ6ggzxVjQyY2A-1; Mon, 02 Aug 2021 15:46:12 -0400
X-MC-Unique: WD3A30pYOZ6ggzxVjQyY2A-1
Received: by mail-ej1-f69.google.com with SMTP id gg1-20020a170906e281b029053d0856c4cdso5068105ejb.15
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 12:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u4LSyR/0hL97TpqHNN7IRSJmq939orqyXRewz9/HhmU=;
        b=HFY7NNxiqyPrPVJrSOYPXb/NdXf+J9g4rY2KOuUTdzoDWN68d7pdUfEsJHG6ASLZk6
         Vm+6uAlc1bFSQAFXwsAp0+UYlwY3HlLFGVbBlW+vTTH8/6Cx0HNpkbotZRwjpTfsgqTZ
         N0tFaKmK6k3Kq+UtdQXTeBt/5aewhJjE3g3OEUBETT6pV7qqCdcGOnPU1ByMEwiMbsA7
         yHxU0L/ocKPSMjYnFzQzL1pbst1cuo77UgARVp9euaPEjEZr8IBc7h1drWVHssO2ma06
         sd9GQEQdNfPpWolYGnz3IeZsfwP57Jdq+sIdI9fWHGgx6GgqdO2mhot4XCKdN4LjHipa
         tUoA==
X-Gm-Message-State: AOAM533jtqhJf040TDmgdTah/8Bby+3m0/K/q5kqxrPGLgVatOjxMskX
        8EkQIZXOei/5jLb3G6S+A0/JDlyyRe1YBM2UDs/F8QNH6ajKNmu4K7YLrAU84POw9gMK67gkBkU
        mrFCr5AakL0LE
X-Received: by 2002:a05:6402:26d1:: with SMTP id x17mr22009499edd.126.1627933571722;
        Mon, 02 Aug 2021 12:46:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUxeZQ8QWOaFM+a5MHs53Gufa4vyRbkQJ+aLrM7GKCmZ6HoO4YrMab1RKippOjDtVlBAYgBQ==
X-Received: by 2002:a05:6402:26d1:: with SMTP id x17mr22009484edd.126.1627933571594;
        Mon, 02 Aug 2021 12:46:11 -0700 (PDT)
Received: from redhat.com ([2.55.140.205])
        by smtp.gmail.com with ESMTPSA id b3sm5036362ejb.7.2021.08.02.12.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 12:46:11 -0700 (PDT)
Date:   Mon, 2 Aug 2021 15:46:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Harshavardhan Unnibhavi <harshanavkis@gmail.com>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org, asias@redhat.com, imbrenda@linux.vnet.ibm.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] VSOCK: handle VIRTIO_VSOCK_OP_CREDIT_REQUEST
Message-ID: <20210802152624-mutt-send-email-mst@kernel.org>
References: <20210802173506.2383-1-harshanavkis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802173506.2383-1-harshanavkis@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021 at 07:35:06PM +0200, Harshavardhan Unnibhavi wrote:
> The original implementation of the virtio-vsock driver does not
> handle a VIRTIO_VSOCK_OP_CREDIT_REQUEST as required by the
> virtio-vsock specification. The vsock device emulated by
> vhost-vsock and the virtio-vsock driver never uses this request,
> which was probably why nobody noticed it. However, another
> implementation of the device may use this request type.
> 
> Hence, this commit introduces a way to handle an explicit credit
> request by responding with a corresponding credit update as
> required by the virtio-vsock specification.
> 
> Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
> 
> Signed-off-by: Harshavardhan Unnibhavi <harshanavkis@gmail.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  net/vmw_vsock/virtio_transport_common.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 169ba8b72a63..081e7ae93cb1 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1079,6 +1079,9 @@ virtio_transport_recv_connected(struct sock *sk,
>  		virtio_transport_recv_enqueue(vsk, pkt);
>  		sk->sk_data_ready(sk);
>  		return err;
> +	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
> +		virtio_transport_send_credit_update(vsk);
> +		break;
>  	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
>  		sk->sk_write_space(sk);
>  		break;
> -- 
> 2.17.1

