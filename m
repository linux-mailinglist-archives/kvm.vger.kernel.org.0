Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894163E8CDF
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 11:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236348AbhHKJJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 05:09:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231497AbhHKJJc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 05:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628672948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JLjNDQUWebauLItmfnlQ+Tjthn4pJvLabefx75OaW6Y=;
        b=KbKy2lzWr3YkRHCEohOAq0kD/V8j1sThxlXUECjI6qN4J+32ilbkSWLr0gPFbddBoo1678
        Ah5wM2FitoIOgcknEOMhP3VJRNo8FABbJAz3L/GnD9guUTb9dShgAu90n+fl4qRaxK9Ict
        9IGCWHTIBElxjvuhyp4FhpDb2A2fTW4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-OdMtuhONMH-Ng7foFeINSg-1; Wed, 11 Aug 2021 05:09:07 -0400
X-MC-Unique: OdMtuhONMH-Ng7foFeINSg-1
Received: by mail-ej1-f72.google.com with SMTP id ju25-20020a17090798b9b029058c24b55273so433178ejc.8
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 02:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JLjNDQUWebauLItmfnlQ+Tjthn4pJvLabefx75OaW6Y=;
        b=VTDrSJSMa/1Vw7AxXkmKBw70TAve1ctVbHbh8LrzzVb3NVynzFS40Tmpp9bKVtAI9J
         wM5BzNOGjg41k/GGrjb0CZZUSLdDqRKVzRsQ8XpBb0pRWXiiv4S4LAObFAeHQ4FEpt8b
         dI1OKYK4GYJYRLYC5JNt9ZFw65g+tzeEwMhy0YGzZc1JwfDzonLjvaP1dscSAEkMNiXi
         RRySOMBziRSCrnToKbfqvv2SKIX4CNQaU0EeOWd2gkKh7v1y2+cXnhbUfxHX/Kv1JVJA
         HfxGrrlsoZU7+dmbG2GbIHtChCLmb3dAf7zcyCEB3AsaWNNMEXvKvPw5w0YRmefkrp70
         9/wg==
X-Gm-Message-State: AOAM5332I0VEC/eeEDjMt3f55MwwHSis4K8OsS6bGB3tdyPGBK/Nnv7j
        d7T73g2mP1P0LV1GuAGUjPbj3R3fJRtglDjkX+oJp2Jwx6aArCMB0cpevget4Z0TmwUP25ZmGMq
        FQ1qy0y2bgmV+
X-Received: by 2002:a17:907:35d0:: with SMTP id ap16mr2641395ejc.456.1628672946562;
        Wed, 11 Aug 2021 02:09:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw62doxoYPXhN9D22tEpGdIMeHAaw1IFlIKoYlluOKCXwbBvIxBAtg09tZOA20KjkBX0c0KiA==
X-Received: by 2002:a17:907:35d0:: with SMTP id ap16mr2641373ejc.456.1628672946373;
        Wed, 11 Aug 2021 02:09:06 -0700 (PDT)
Received: from steredhat (a-nu5-14.tin.it. [212.216.181.13])
        by smtp.gmail.com with ESMTPSA id p23sm11040297edw.94.2021.08.11.02.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:09:06 -0700 (PDT)
Date:   Wed, 11 Aug 2021 11:09:03 +0200
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
Subject: Re: [RFC PATCH v2 3/5] virito/vsock: support MSG_EOR bit processing
Message-ID: <20210811090903.27tcokpqofujhhgp@steredhat>
References: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
 <20210810114035.1214740-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210810114035.1214740-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 02:40:32PM +0300, Arseny Krasnov wrote:
>If packet has 'EOR' bit - set MSG_EOR in 'recvmsg()' flags.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 4d5a93beceb0..59ee1be5a6dd 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -76,8 +76,12 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
> 			goto out;
>
> 		if (msg_data_left(info->msg) == 0 &&
>-		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET)
>+		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
> 			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>+
>+			if (info->msg->msg_flags & MSG_EOR)
>+				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+		}
> 	}
>
> 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
>@@ -460,6 +464,9 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
> 			msg_ready = true;
> 			vvs->msg_count--;
>+
>+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>+				msg->msg_flags |= MSG_EOR;
> 		}
>
> 		virtio_transport_dec_rx_pkt(vvs, pkt);
>-- 
>2.25.1
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

