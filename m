Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE24F3CF47E
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 08:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237150AbhGTFsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 01:48:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51455 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233946AbhGTFsA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Jul 2021 01:48:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626762518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KNH6zsjCfAXwZqQxKujTcuZRpVuHUvtcZf7vWJW9dkY=;
        b=fShyt6cRZcK6wot+GTKNlc9f1RqhRXZrOBZ9sAuGLDAZmtZqw23INygdbdFDIsl16hEMib
        Yz4mBG8lPimQq4ZjA/bWVMyZn+ETgYkqL/wpsIM8sNh6+VeRlS7k2A3ZZc8FVqr3tC11Lj
        3hwZMTl8sJ93G2r3gh0OIf22N2OM7Q8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-UlHmFAZuNDSnUoMdXD2TRA-1; Tue, 20 Jul 2021 02:28:34 -0400
X-MC-Unique: UlHmFAZuNDSnUoMdXD2TRA-1
Received: by mail-pl1-f197.google.com with SMTP id n11-20020a170902e54bb029012b5431cb04so3353495plf.12
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 23:28:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KNH6zsjCfAXwZqQxKujTcuZRpVuHUvtcZf7vWJW9dkY=;
        b=Lpx26pGWwThimt6yrYkqfXGz/Z3LooM5edAhR8cP600fmv3lFSfOQRZmNKpw4n2HC0
         JU7WTkt9COgpLY2t6JibztFmsS28vuD4z31ZVwOmGhW636S8jMGrlXS+AQyhwbKb2MU9
         OMDLPTeBmdTxI2v2JVl5vZ2utU863079mYcx2b2TRq+9W/Io7nXvQMJV+4thjIdd45Ku
         Dh04XBji2gf3UJlrbKa8Wf1okVg5KWHXITo4vP38TZE3OkU+SQL9pnTcn7qgBz1l7zY2
         f64jyecEGdx+boO15Ow5T8JdevvG3JcJzfrJOk3iqdLkvIIdayQZjEF4ccSRbH7UsrZO
         duRw==
X-Gm-Message-State: AOAM533N4B+YXnV3JbiMy/5lRRd9OgX1RxVKL52EHYJ5kD7z0CKq686n
        /w3u0cragpkD0J99tlNSXEpkGSew06e1fsVI9x5k/oBDZ6HPDOLOelsp3kj0dVrKBE77ilwIhfA
        wAbq73Iqjsxy3
X-Received: by 2002:a63:ee0a:: with SMTP id e10mr29264290pgi.385.1626762513518;
        Mon, 19 Jul 2021 23:28:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqXIhBsHE4OMO19DsmYnji2nMu1Erm/LjLpnHHVNBKtlqCmktcLZd6Ck+YaPnj7kdpYu9RDQ==
X-Received: by 2002:a63:ee0a:: with SMTP id e10mr29264267pgi.385.1626762513229;
        Mon, 19 Jul 2021 23:28:33 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b15sm8946536pfi.49.2021.07.19.23.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 23:28:32 -0700 (PDT)
Subject: Re: [PATCH] vsock/virtio: set vsock frontend ready in
 virtio_vsock_probe()
To:     Xianting Tian <tianxianting.txt@linux.alibaba.com>,
        stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
References: <20210720034255.1408-1-tianxianting.txt@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <73d486dd-17d9-a3b3-c1e9-39a1138c0084@redhat.com>
Date:   Tue, 20 Jul 2021 14:28:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720034255.1408-1-tianxianting.txt@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/7/20 ÉÏÎç11:42, Xianting Tian Ð´µÀ:
> From: Xianting Tian <xianting.tian@linux.alibaba.com>
>
> Add the missed virtio_device_ready() to set vsock frontend ready.
>
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
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


It's better to do this after the mutex_lock().

Thanks


>   
>   	return 0;

