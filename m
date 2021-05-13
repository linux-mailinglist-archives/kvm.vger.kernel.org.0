Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCB637F7B0
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 14:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhEMMUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 08:20:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233872AbhEMMTy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 08:19:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620908324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IK5KASvNIAH9Eni0vYhJFRLrKtUI3CSzvduC524we5U=;
        b=I3JEWRhXBQLw0oPOYro1sRYjefeoRZX/lC8S8Yp0Fo9qwQ8TTBNBF+ZB/R54NzTaqjRouk
        j2/gPwIVxAPB0Ic61oJ2VhZLIdPtWxxpwoiKWAO4aWrIJswem0ISAioSujv15MniA2pFs7
        LtINpW+qmFboULYaBJynPmpvrQCfzgY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-jSxX-0LWOb-XYfWX0c4Frw-1; Thu, 13 May 2021 08:18:42 -0400
X-MC-Unique: jSxX-0LWOb-XYfWX0c4Frw-1
Received: by mail-ed1-f72.google.com with SMTP id k10-20020a50cb8a0000b0290387e0173bf7so14649094edi.8
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 05:18:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IK5KASvNIAH9Eni0vYhJFRLrKtUI3CSzvduC524we5U=;
        b=kUfuKB1NBAvgmgfbRgPunjU4+1tT/NMiCvyIoQ9XXYFcyge2BfUXL2jDX6lQ2XG1uZ
         xuZSQVwO85jalbBtmDKiI+wJgNamSEBJh40zZzs7mpJmU/hMIFpbDsb8F4cWF0EfIg2r
         XIhTTDpukWw9MbrS7mqeAY5kgSNd4nkqDXWlRKG1HZQK7Dxql/hrLgpo6T43BMd8lLDG
         Ynshxgs39Sc/wFoowZz39kVmDJQRHjwK0cIZHtCCjm5I2C4Z5surVA4lYfc1adlY2wWl
         A35wdPkQ8+WuE/WNYDCOTK43z6w2lrg3ltevXJzifptrmIHqHr9v6arY79NE0yK780bQ
         PYJw==
X-Gm-Message-State: AOAM533cSPWz57C8JgyqdPhj7TT4sGOjHO8NB+QXeI4q6gauImRYw0el
        D1Ris9ksXVs2u5uytRmqcU8wJxSHsvkE4dGE1tV/p57b3UWecPQ2BZQZDTtCjBi+46UGZoyThYN
        OkmhCqT05703C
X-Received: by 2002:a17:906:604a:: with SMTP id p10mr4996074ejj.148.1620908320991;
        Thu, 13 May 2021 05:18:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1Vg66JpJOxLpGs+6NIjUxFfgVCqpT78vMAZP1rCCIR2bhxg+eIcIxHZ+9opyz96knLH1DNA==
X-Received: by 2002:a17:906:604a:: with SMTP id p10mr4996058ejj.148.1620908320779;
        Thu, 13 May 2021 05:18:40 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id t14sm1697687ejc.121.2021.05.13.05.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:18:40 -0700 (PDT)
Date:   Thu, 13 May 2021 14:18:38 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v9 11/19] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210513121838.ndpgj56gwcww3pfc@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163523.3431999-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163523.3431999-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 08, 2021 at 07:35:20PM +0300, Arseny Krasnov wrote:
>This adds transport callback and it's logic for SEQPACKET dequeue.
>Callback fetches RW packets from rx queue of socket until whole record
>is copied(if user's buffer is full, user is not woken up). This is done
>to not stall sender, because if we wake up user and it leaves syscall,
>nobody will send credit update for rest of record, and sender will wait
>for next enter of read syscall at receiver's side. So if user buffer is
>full, we just send credit update and drop data.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v8 -> v9:
> 1) Check for RW packet type is removed from loop(all packet now
>    considered RW).
> 2) Locking in loop is fixed.
> 3) cpu_to_le32()/le32_to_cpu() now used.
> 4) MSG_TRUNC handling removed from transport.
>
> include/linux/virtio_vsock.h            |  5 ++
> net/vmw_vsock/virtio_transport_common.c | 64 +++++++++++++++++++++++++
> 2 files changed, 69 insertions(+)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index dc636b727179..02acf6e9ae04 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -80,6 +80,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t len, int flags);
>
>+ssize_t
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   int flags,
>+				   bool *msg_ready);
> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index ad0d34d41444..f649a21dd23b 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -393,6 +393,58 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>+						 struct msghdr *msg,
>+						 int flags,
>+						 bool *msg_ready)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct virtio_vsock_pkt *pkt;
>+	int err = 0;
>+	size_t user_buf_len = msg->msg_iter.count;

Forgot to mention that also here is better to use `msg_data_left(msg)`

Thanks,
Stefano

