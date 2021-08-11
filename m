Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082E53E8CBC
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 11:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhHKJBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 05:01:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236497AbhHKJBC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 05:01:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628672438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xVYk6O6UbKVQlEk4hpiQ+ioYAfkIhHzccxHN1Fx+454=;
        b=T/pogVQ6LOdA85cxys2r8Oov0oYWdqkwp4EIA6yINrMWIf8rUlOBOI2NJ6ecwD42S2IEDK
        FJRSU5xXa/fJogpaDT8SxftcvDOQgnbxTKZoywOOOl7OofO8xdfTJxvxzk9Hr5v5TV6mML
        cWjeq9kl6yCws6JbJxJYijPmrwRiG9U=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-7vFSFOBBNXqCd0u4i6b9Uw-1; Wed, 11 Aug 2021 05:00:35 -0400
X-MC-Unique: 7vFSFOBBNXqCd0u4i6b9Uw-1
Received: by mail-ej1-f70.google.com with SMTP id h17-20020a1709070b11b02905b5ced62193so425069ejl.1
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 02:00:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xVYk6O6UbKVQlEk4hpiQ+ioYAfkIhHzccxHN1Fx+454=;
        b=Le6XWN98W42famUCmdL0UG61u8aP4ZUFCD0aDo+4WQybxN/Pu4ZnXNAqEZevZl3GnH
         KVANOMMJXmtNyAIIM3dOldGEdTgmomWh+UtTb/nJiXTXl7oTPcNA3505/NdMUAivZB9B
         2U34syhMGGdnma+BcTMQl8fZgz4+UnWbcd60deS0CtZpwGXgTlCtfyyGyB5d+B5bLnlX
         Ik6Psx/eQpyaATYz7XdSeN1bM5foA7pFFZ2VfNkOvN6kZGn5Ur82VBRDxzs/LMPphY2A
         MYGg4fKGERJ7A+/2IdODu9h8aiINGql92dSfiDIHjX1g+YUUH4KqewGRBsvSRxfEVZQc
         zGMw==
X-Gm-Message-State: AOAM530DBFqS+ZNqKK/T/ZIQTKYxi/+pZZ5K6xHJQx+Bmo/EpDM16/7t
        ghBG/EMtJmO2KYeTm64YPe0YUacJ6BdVujh2CerKdtHWpLQhwKNs/91IvM3sEuZ1APsRR+TR9Sg
        W70XCFd3MvBzc
X-Received: by 2002:a17:906:a08a:: with SMTP id q10mr2593166ejy.100.1628672433740;
        Wed, 11 Aug 2021 02:00:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+Wh3oVEmn3QZnNAXMGsVm3JaAoH4eSr1ZKRKUam8aqa4jKG8XOA/RBO+z8M1b/2H29w2Viw==
X-Received: by 2002:a17:906:a08a:: with SMTP id q10mr2593146ejy.100.1628672433523;
        Wed, 11 Aug 2021 02:00:33 -0700 (PDT)
Received: from steredhat (a-nu5-14.tin.it. [212.216.181.13])
        by smtp.gmail.com with ESMTPSA id l19sm4147213edb.86.2021.08.11.02.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:00:33 -0700 (PDT)
Date:   Wed, 11 Aug 2021 11:00:30 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 1/5] virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOM' bit
Message-ID: <20210811090030.snu5ckf6bdkzxdg7@steredhat>
References: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
 <20210810113956.1214463-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210810113956.1214463-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 02:39:53PM +0300, Arseny Krasnov wrote:

The title is confusing, we are renaming EOR in EOM.

>This bit is used to mark end of messages('EOM' - end of message), while
>'VIRIO_VSOCK_SEQ_EOR' is used to pass MSG_EOR. Also rename 'record' to
>'message' in implementation as it is different things.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> drivers/vhost/vsock.c                   | 12 ++++++------
> include/uapi/linux/virtio_vsock.h       |  3 ++-
> net/vmw_vsock/virtio_transport_common.c | 14 +++++++-------
> 3 files changed, 15 insertions(+), 14 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index f249622ef11b..feaf650affbe 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -178,15 +178,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 			 * small rx buffers, headers of packets in rx queue are
> 			 * created dynamically and are initialized with 
> 			 header
> 			 * of current packet(except length). But in case of
>-			 * SOCK_SEQPACKET, we also must clear record delimeter
>-			 * bit(VIRTIO_VSOCK_SEQ_EOR). Otherwise, instead of one
>-			 * packet with delimeter(which marks end of record),
>+			 * SOCK_SEQPACKET, we also must clear message delimeter
>+			 * bit(VIRTIO_VSOCK_SEQ_EOM). Otherwise, instead of one
>+			 * packet with delimeter(which marks end of message),
> 			 * there will be sequence of packets with delimeter
> 			 * bit set. After initialized header will be copied to
> 			 * rx buffer, this bit will be restored.
> 			 */
>-			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
>-				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
>+				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
> 				restore_flag = true;
> 			}
> 		}
>@@ -225,7 +225,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		 */
> 		if (pkt->off < pkt->len) {
> 			if (restore_flag)
>-				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>
> 			/* We are queueing the same virtio_vsock_pkt to handle
> 			 * the remaining bytes, and we want to deliver it
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 3dd3555b2740..64738838bee5 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -97,7 +97,8 @@ enum virtio_vsock_shutdown {
>
> /* VIRTIO_VSOCK_OP_RW flags values */
> enum virtio_vsock_rw {
>-	VIRTIO_VSOCK_SEQ_EOR = 1,
>+	VIRTIO_VSOCK_SEQ_EOM = 1,
>+	VIRTIO_VSOCK_SEQ_EOR = 2,
         ^
I think is better to add this new flag in a separate patch.

> };
>
> #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 081e7ae93cb1..4d5a93beceb0 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -77,7 +77,7 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
>
> 		if (msg_data_left(info->msg) == 0 &&
> 		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET)
>-			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
> 	}
>
> 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
>@@ -457,7 +457,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 				dequeued_len += pkt_len;
> 		}
>
>-		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
>+		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
> 			msg_ready = true;
> 			vvs->msg_count--;
> 		}
>@@ -1029,7 +1029,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> 		goto out;
> 	}
>
>-	if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>+	if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM)
> 		vvs->msg_count++;
>
> 	/* Try to copy small packets into the buffer of last packet queued,
>@@ -1044,12 +1044,12 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>
> 		/* If there is space in the last packet queued, we copy the
> 		 * new packet in its buffer. We avoid this if the last packet
>-		 * queued has VIRTIO_VSOCK_SEQ_EOR set, because this is
>-		 * delimiter of SEQPACKET record, so 'pkt' is the first packet
>-		 * of a new record.
>+		 * queued has VIRTIO_VSOCK_SEQ_EOM set, because this is
>+		 * delimiter of SEQPACKET message, so 'pkt' is the first packet
>+		 * of a new message.
> 		 */
> 		if ((pkt->len <= last_pkt->buf_len - last_pkt->len) &&
>-		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)) {
>+		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM)) {
> 			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
> 			       pkt->len);
> 			last_pkt->len += pkt->len;
>-- 
>2.25.1
>

The rest LGTM!

Thanks,
Stefano

