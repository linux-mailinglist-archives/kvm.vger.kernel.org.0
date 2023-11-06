Return-Path: <kvm+bounces-655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D91517E1EBB
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:44:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 940CC2814BF
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 10:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2755179B8;
	Mon,  6 Nov 2023 10:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ux4XiRTB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0532156D4
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:43:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0567FFA
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 02:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699267433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tt2ufQi3V0WzCPqFhIfFg69WryxcO+HVUXT9JipxxcY=;
	b=Ux4XiRTB3P4EYpDP6g2Nc1UaZM0lJ85NuTBORbBlrwQnj/O5u9jR/4F1DYbt1XpqBEfDzq
	qDqoO8I4C8Q4M//TD0sx1cgfBvhyv/+zyU0Nv7TryJ3LtyjW1Jy83qkQUPu07CuGvPBnIo
	vmTkalm8sN7OBix394ovD7BLTGC0z2Q=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-K_lqpNfNPjWsauPUEYSSHA-1; Mon, 06 Nov 2023 05:43:51 -0500
X-MC-Unique: K_lqpNfNPjWsauPUEYSSHA-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-41cdce61c6cso47690731cf.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 02:43:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699267431; x=1699872231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tt2ufQi3V0WzCPqFhIfFg69WryxcO+HVUXT9JipxxcY=;
        b=usYIfgCXXgJXXrL20x/4LUZMSJljPR1ndXB0NeVEQbwYqRxBZic7gT7gVjW+Qd1tAY
         dZt07hZdpaUKtF3wv9iwUTS5XnGOkh+fCQpwelKXaTRdl2nyEymo48bNmeKOGwnzcyxF
         NG0TUBd/d3Ln9M3fpgvOn+3VcmmvNiXtTKD2V9GTjDheWBSiT77POXlktJ/VAUxebWeM
         Q5aPQEesrU61bdQseBUyXlv7I5oe23IKTuJLWjEwJWa14rwrHzCBiBNc4tI+HRjQqWvG
         H3X15CCxHN1rsd12pbw/Vt2tIoXMSdUSMUaBVmg3xnAra8Hy0RpaukRwlOuGZdh7cn4B
         o2Ag==
X-Gm-Message-State: AOJu0YyNZ/9IJaC7YGIUwNXn5uioLwOA7Myq7OmOrIqGo+ERPWpLvk1z
	76xSYyPRKkcGCYtLnIDVp/YtZb1e702gGb6Yi6KZKjonT8wgLBNqIglkReZRnuT7iW/50xZDpin
	QOICvUrY9gtT+
X-Received: by 2002:a05:622a:170f:b0:41e:1fea:8a49 with SMTP id h15-20020a05622a170f00b0041e1fea8a49mr33316907qtk.65.1699267431507;
        Mon, 06 Nov 2023 02:43:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHpuzj6aF53BZWIRx0q0bbK7VrzzNhPJJTleXguDnfuNabXjh8InW8/+0AEmmiTq79rP6tdsQ==
X-Received: by 2002:a05:622a:170f:b0:41e:1fea:8a49 with SMTP id h15-20020a05622a170f00b0041e1fea8a49mr33316894qtk.65.1699267431238;
        Mon, 06 Nov 2023 02:43:51 -0800 (PST)
Received: from sgarzare-redhat ([5.179.191.143])
        by smtp.gmail.com with ESMTPSA id bw7-20020a05622a098700b004181f542bcbsm3295696qtb.11.2023.11.06.02.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 02:43:50 -0800 (PST)
Date: Mon, 6 Nov 2023 11:43:25 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: f.storniolo95@gmail.com
Cc: luigi.leonardi@outlook.com, kvm@vger.kernel.org, davem@davemloft.net, 
	edumazet@google.com, mst@redhat.com, imbrenda@linux.vnet.ibm.com, kuba@kernel.org, 
	asias@redhat.com, stefanha@redhat.com, pabeni@redhat.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net 1/4] vsock/virtio: remove socket from connected/bound
 list on shutdown
Message-ID: <rpawubezrb23ktdzs4odz36lcyc7onyyyadcij3jxvw3sfb7yh@vawgl5x2ueoe>
References: <20231103175551.41025-1-f.storniolo95@gmail.com>
 <20231103175551.41025-2-f.storniolo95@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231103175551.41025-2-f.storniolo95@gmail.com>

On Fri, Nov 03, 2023 at 06:55:48PM +0100, f.storniolo95@gmail.com wrote:
>From: Filippo Storniolo <f.storniolo95@gmail.com>
>
>If the same remote peer, using the same port, tries to connect
>to a server on a listening port more than once, the server will
>reject the connection, causing a "connection reset by peer"
>error on the remote peer. This is due to the presence of a
>dangling socket from a previous connection in both the connected
>and bound socket lists.
>The inconsistency of the above lists only occurs when the remote
>peer disconnects and the server remains active.
>
>This bug does not occur when the server socket is closed:
>virtio_transport_release() will eventually schedule a call to
>virtio_transport_do_close() and the latter will remove the socket
>from the bound and connected socket lists and clear the sk_buff.
>
>However, virtio_transport_do_close() will only perform the above
>actions if it has been scheduled, and this will not happen
>if the server is processing the shutdown message from a remote peer.
>
>To fix this, introduce a call to vsock_remove_sock()
>when the server is handling a client disconnect.
>This is to remove the socket from the bound and connected socket
>lists without clearing the sk_buff.
>
>Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>Reported-by: Daan De Meyer <daan.j.demeyer@gmail.com>
>Tested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
>Co-developed-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>Signed-off-by: Filippo Storniolo <f.storniolo95@gmail.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 16 +++++++++++-----
> 1 file changed, 11 insertions(+), 5 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index e22c81435ef7..4c595dd1fd64 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1369,11 +1369,17 @@ virtio_transport_recv_connected(struct sock *sk,
> 			vsk->peer_shutdown |= RCV_SHUTDOWN;
> 		if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SHUTDOWN_SEND)
> 			vsk->peer_shutdown |= SEND_SHUTDOWN;
>-		if (vsk->peer_shutdown == SHUTDOWN_MASK &&
>-		    vsock_stream_has_data(vsk) <= 0 &&
>-		    !sock_flag(sk, SOCK_DONE)) {
>-			(void)virtio_transport_reset(vsk, NULL);
>-			virtio_transport_do_close(vsk, true);
>+		if (vsk->peer_shutdown == SHUTDOWN_MASK) {
>+			if (vsock_stream_has_data(vsk) <= 0 && !sock_flag(sk, SOCK_DONE)) {
>+				(void)virtio_transport_reset(vsk, NULL);
>+				virtio_transport_do_close(vsk, true);
>+			}
>+			/* Remove this socket anyway because the remote peer sent
>+			 * the shutdown. This way a new connection will succeed
>+			 * if the remote peer uses the same source port,
>+			 * even if the old socket is still unreleased, but now disconnected.
>+			 */
>+			vsock_remove_sock(vsk);
> 		}
> 		if (le32_to_cpu(virtio_vsock_hdr(skb)->flags))
> 			sk->sk_state_change(sk);
>-- 
>2.41.0
>

Thanks for fixing this issue! LGTM.

Just to inform other maintainers as well. Daan reported this issue to me
at DevConf.cz, I shared it with Filippo and Luigi who analyzed and
solved it.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>



