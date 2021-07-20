Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39603CF476
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 08:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbhGTFpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 01:45:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231852AbhGTFo6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Jul 2021 01:44:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626762337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+pFjrkcG2ZRzROzSDXE/qK9WLlZjt36K6e23WeKajZ8=;
        b=cfEzMyi4dscivap6mZVQ4CYHeSuu/QvSwU+v+ncbOTvPfbMyG7o4VNOXdzVToTHF2Krw4h
        nR2WIewAC3V380eEeWMjma+PgViEwVPofS6XSIxTInaYIbg3eKARlcyGvggWqO60GdVBxH
        a5zpDokfKyC0bdFWcZvCq/Jgy/tLvo4=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-7KOJucwCP22C3NhiAO7Szg-1; Tue, 20 Jul 2021 02:25:35 -0400
X-MC-Unique: 7KOJucwCP22C3NhiAO7Szg-1
Received: by mail-pg1-f198.google.com with SMTP id f16-20020a6562900000b029022c3e789d78so17058510pgv.6
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 23:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+pFjrkcG2ZRzROzSDXE/qK9WLlZjt36K6e23WeKajZ8=;
        b=crhRg6hZqgDPq/XdWoM7dW2O9eYSk0Wjc4bLOjol/6GAuIdVzLL9m8jVtnItQvVAJ6
         ZLF06T1ul5HAOeRoBDjvvYYeoud8fi/lKdd0vlK1r//8Q4fVoCtGx8p0T4HLwt2S+K3F
         XdIk49yZzak/UfQjFKB0IjJ5TPQO1gdPZZ7Loq8YNqMhq2dOu85EZ8DH/YULZrQO0O/r
         R+qrln1OK6ix2amm1zAI5cqMBTU7n1GTCK6RTJ7rNYDY9EjDXBbf0Xc/fRfwQz17c9Qy
         TUgAQExEDNQVzz92pLnrzyYpF53v+frCZiOtC7myKM3M45Ov3OWqLeLY9Pt4KDU2Ualy
         8KmQ==
X-Gm-Message-State: AOAM532ChaXpZt1TCfHSXBID3B7rtH4eZMzorl109Re44vcfTEm5pi6i
        tkRVGYJ1IpEfke+YZkdbNJc7fmmghTk36L0r5aaEPGArep+ocNeS19fUNhCc83S7mKdtTCct9XA
        41Vwiuo3vpDoW
X-Received: by 2002:a63:2041:: with SMTP id r1mr14924114pgm.59.1626762334871;
        Mon, 19 Jul 2021 23:25:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJFTlgkaKXwIn+1kT2a5RmA050X86XDvyy0tTwV3OcM/kDFkzn7QDPYu1L0FUL3OWMF00cPA==
X-Received: by 2002:a63:2041:: with SMTP id r1mr14924097pgm.59.1626762334630;
        Mon, 19 Jul 2021 23:25:34 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d13sm21831104pfn.136.2021.07.19.23.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 23:25:34 -0700 (PDT)
Subject: Re: [PATCH] vsock/virtio: set vsock frontend ready in
 virtio_vsock_probe()
To:     Xianting Tian <tianxianting.txt@linux.alibaba.com>,
        stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210720034039.1351-1-tianxianting.txt@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9a790a52-8f14-1a9a-51e0-9c35a03d33dd@redhat.com>
Date:   Tue, 20 Jul 2021 14:25:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720034039.1351-1-tianxianting.txt@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/7/20 ÉÏÎç11:40, Xianting Tian Ð´µÀ:
> Add the missed virtio_device_ready() to set vsock frontend ready.
>
> Signed-off-by: Xianting Tian <tianxianting.txt@linux.alibaba.com>
> ---
>   net/vmw_vsock/virtio_transport.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index e0c2c992a..eb4c607c4 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -637,6 +637,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>   	vdev->priv = vsock;
>   	rcu_assign_pointer(the_virtio_vsock, vsock);
>   
> +	virtio_device_ready(vdev);
> +
>   	mutex_unlock(&the_virtio_vsock_mutex);


It's better to do this after the mutex.

Thanks


>   
>   	return 0;

