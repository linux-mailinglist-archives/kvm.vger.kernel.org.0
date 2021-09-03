Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CB53FFF9E
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 14:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbhICMPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 08:15:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235119AbhICMPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 08:15:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630671249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jKhxEryxOvV3BCEV05H9WKrbxCCVH7ys4JOnEtcYv0o=;
        b=Y/UqbhFAomHE1i62TT3wb9Jt0IW4itTzDLvLExiz6EX7FnlJxvlt/vBEAG3Y+qcOj5cxCB
        V2gAbH3WABNKJCI1Es//s9Y173fR1rkSjaxQFnyL/QDCrvwYCZmB3wXzIEIXegBXNCeo6T
        uWA2zw4PCqWNY69GsqX3dLRcK3CxjJ0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-kKJsDknzPxSNSOE3U6GagA-1; Fri, 03 Sep 2021 08:14:07 -0400
X-MC-Unique: kKJsDknzPxSNSOE3U6GagA-1
Received: by mail-ed1-f70.google.com with SMTP id v13-20020a056402174d00b003c25d6b2f13so2659158edx.4
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 05:14:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jKhxEryxOvV3BCEV05H9WKrbxCCVH7ys4JOnEtcYv0o=;
        b=Xodrt1wzaqYG8z7BlDKTlfOOIrBE1jNWLytp974zzVOB4Ca/WL0bFrcw3Ogl8NWllj
         E+IKi8utYp5k1YSuVM53+dga0YgLiCCWTvEQK88jOccU86Oc4y3G/zMALrcJ0lAbXKsc
         B81Ox5XXk3KjCPov5Lgcbzklp8q5aWovmV1tGBq/eFWpmVqIUduRiiGktZkjbc1qkgLo
         mIOP4vyzJ9P1FIl/Q5sh1u1OoZ+dB8vZEKOTvWNirTOJBlEXcJOJaRc8oSiGPtvLpOxC
         WXkRC0IxFMnKFvE1M8YRh9U9pVOIsxEi1xw9jPpuKHbIGRYbhvJhH6cWbBiozUPXtTSY
         5LCw==
X-Gm-Message-State: AOAM531mkC+ciEmHMAxkopMdr1KKUwkQi/ER+EB2E66+W8XxqY92Ctfh
        N2HXrLSj6chdGOPGykhE+VP2e48568+yq35x45Ilj94XIl3Zywxv7KXrKsQ8bO8fCPkNv5BD4Ny
        RxNydSfbVhL38
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr3852017ejc.69.1630671246105;
        Fri, 03 Sep 2021 05:14:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrZ9hQ5skCpK7Qi697152xoz1AkM543cXdpgGsazHd3sse474FPdYSbyN9lc3iS+HY2SJFkQ==
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr3852004ejc.69.1630671245896;
        Fri, 03 Sep 2021 05:14:05 -0700 (PDT)
Received: from steredhat (host-79-51-2-59.retail.telecomitalia.it. [79.51.2.59])
        by smtp.gmail.com with ESMTPSA id g19sm2607768eje.121.2021.09.03.05.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 05:14:05 -0700 (PDT)
Date:   Fri, 3 Sep 2021 14:14:02 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v4 3/6] vhost/vsock: support MSG_EOR bit
 processing
Message-ID: <20210903121402.vfdaxznxwepezacf@steredhat>
References: <20210903061353.3187150-1-arseny.krasnov@kaspersky.com>
 <20210903061541.3187840-1-arseny.krasnov@kaspersky.com>
 <20210903065539.nb2hk4sszdtlqfmb@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210903065539.nb2hk4sszdtlqfmb@steredhat>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 08:55:39AM +0200, Stefano Garzarella wrote:
>On Fri, Sep 03, 2021 at 09:15:38AM +0300, Arseny Krasnov wrote:
>>'MSG_EOR' handling has similar logic as 'MSG_EOM' - if bit present
>>in packet's header, reset it to 0. Then restore it back if packet
>>processing wasn't completed. Instead of bool variable for each
>>flag, bit mask variable was added: it has logical OR of 'MSG_EOR'
>>and 'MSG_EOM' if needed, to restore flags, this variable is ORed
>>with flags field of packet.
>>
>>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>---
>>drivers/vhost/vsock.c | 22 +++++++++++++---------
>>1 file changed, 13 insertions(+), 9 deletions(-)
>>
>>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>index feaf650affbe..93e8d635e18f 100644
>>--- a/drivers/vhost/vsock.c
>>+++ b/drivers/vhost/vsock.c
>>@@ -114,7 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>		size_t nbytes;
>>		size_t iov_len, payload_len;
>>		int head;
>>-		bool restore_flag = false;
>>+		u32 flags_to_restore = 0;
>>
>>		spin_lock_bh(&vsock->send_pkt_list_lock);
>>		if (list_empty(&vsock->send_pkt_list)) {
>>@@ -179,15 +179,20 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>			 * created dynamically and are initialized with header
>>			 * of current packet(except length). But in case of
>>			 * SOCK_SEQPACKET, we also must clear message delimeter
>>-			 * bit(VIRTIO_VSOCK_SEQ_EOM). Otherwise, instead of one
>>-			 * packet with delimeter(which marks end of message),
>>-			 * there will be sequence of packets with delimeter
>>-			 * bit set. After initialized header will be copied to
>>-			 * rx buffer, this bit will be restored.
>>+			 * bit (VIRTIO_VSOCK_SEQ_EOM) and MSG_EOR bit
>>+			 * (VIRTIO_VSOCK_SEQ_EOR) if set. Otherwise,
>>+			 * there will be sequence of packets with these
>>+			 * bits set. After initialized header will be copied to
>>+			 * rx buffer, these required bits will be restored.
>>			 */
>>			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
>>				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>>-				restore_flag = true;
>>+				flags_to_restore |= VIRTIO_VSOCK_SEQ_EOM;
>>+
>>+				if (le32_to_cpu(pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR)) {
                                                               ^
Ooops, le32_to_cpu() should close before bitwise and operator.
I missed this, but kernel test robot discovered :-)

>>+					pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>>+					flags_to_restore |= VIRTIO_VSOCK_SEQ_EOR;
>>+				}
>>			}
>>		}
>>
>>@@ -224,8 +229,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>		 * to send it with the next available buffer.
>>		 */
>>		if (pkt->off < pkt->len) {
>>-			if (restore_flag)
>>-				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>>+			pkt->hdr.flags |= cpu_to_le32(flags_to_restore);
>>
>>			/* We are queueing the same virtio_vsock_pkt to handle
>>			 * the remaining bytes, and we want to deliver it
>>-- 2.25.1
>>
>
>Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

NACK

Please resend fixing the issue.

Stefano

