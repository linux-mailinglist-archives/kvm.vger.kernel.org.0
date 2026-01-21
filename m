Return-Path: <kvm+bounces-68696-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0NVOEFihcGlyYgAAu9opvQ
	(envelope-from <kvm+bounces-68696-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:50:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DAADD54B23
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:50:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 313E04AA91B
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA40647CC81;
	Wed, 21 Jan 2026 09:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cdZZq3Y8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mBOWZvf4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48BD47D952
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 09:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768988202; cv=none; b=vGBqvVJeoYzviA6emEDJIOHKs64+HHGZ3joaAYRT3W5+oUCV5mugvK+US9k9f+xkTX3I8Uh82hxqAhc6NRM1wq+M8OZxizZYjO9c6u3HUt7LDJlGJ+f0XpS4K5yIYPdcqJjn46RQ8SOlJYj8najWknKaS7oY9U//HGnVfdFAc70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768988202; c=relaxed/simple;
	bh=QU6xQfM9f00ZpwjUsd6GPQ+PxU3JVUFFAWJJEmaV/o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPkwBtVRDy5hdvC7bvRetbVtaHI9YVV7B5S4KMJOzbvmaWoFDEaz3pTpUWupvCpoUvV4UveP63TqA+2NKYwLRETsY81YBP8zHAhOMz20MJU+jq+MVMCVrrJww96VkACY/0NtO1TmOgGshwL0iCq+0muvR3INVk2Ta2No5374kS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cdZZq3Y8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mBOWZvf4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768988199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7DV1XJTkbFynFHoZNtzuqUf26Hx/N2mSbX7HPLgi2JE=;
	b=cdZZq3Y8WETJZIDNagRnmx1CA721fBg7aSNzrfQ/sGuVCm801X+3TO9ZMAmw/HSabXoEvQ
	x6YmIqAc+I0jGD0RnUBe2jGBQn5DyhEvmLXkkWdGirUWwlCuPwWsVymCVC9bE18dJHg3EH
	vjAJHccL4tCzh0y/Ws/xymwvHv0yNxo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-JJRl09ZYODmSdF8N716XRQ-1; Wed, 21 Jan 2026 04:36:38 -0500
X-MC-Unique: JJRl09ZYODmSdF8N716XRQ-1
X-Mimecast-MFC-AGG-ID: JJRl09ZYODmSdF8N716XRQ_1768988197
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47ee868f5adso48978705e9.0
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 01:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768988197; x=1769592997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7DV1XJTkbFynFHoZNtzuqUf26Hx/N2mSbX7HPLgi2JE=;
        b=mBOWZvf4/lGHrh3XqrfKWkliWdWejnSk88BhDi+tWVE5NQjr1CO/QSXEiszUfg6+jr
         SuObPYERvU4XR2R1PrXsHon+dROyaSJsw2SXKDe6bFRvvGkDOl24gGXUerXdvweaRYN4
         H3nMXTPTnq9pmSVM49HF2OcYrmaqHlakD7QAc5eW3AYFkcZCgxFpSqabManMkL6StVw/
         hzVAuW/xzR/mAVkDfEH+aq6CVlbFvMaiuPE68BPsyaEoSCIOQ8WYxNKWLYN+TueBUzDC
         6NOVQWqbjtrDHny/JB70RE1AXCPB5lWI1IL/n36qX9231+3LKO4UWrOjA+RYqZA7dNpM
         Eifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768988197; x=1769592997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7DV1XJTkbFynFHoZNtzuqUf26Hx/N2mSbX7HPLgi2JE=;
        b=Dt2KLr4Bf82ptutTTljBeA9e0ugPtrlM5/fMzcPwjCzPhxcb2eIRc/YvyNgWi+FPt8
         r6jzFN/sW36EJmgrrBVzKt2LWfs5tYnVBL9ZtgNlc+tZLCImQx+PYkiVYgmvjdaQynOQ
         FGpFAaRZltQDmF1mo9ax/+SzyyTmwvjbeeV9ZXSVBrWoTg8g6Qtnm4Ekdf2axD2kTJLs
         vVBRiNKEpFp0EFyibrqA/iz/foxl47/8kcuaEh0AQ02v8ZLBaREbNKMvuOquCChs2ZbZ
         2M+Pu/aQQ9eo3fzEyBIcVKatxyBZF5Q/Efamv+r3ay+5mM8MyC5TrGy3d/EO3fCwmHu1
         87sA==
X-Forwarded-Encrypted: i=1; AJvYcCWK0FW1qmcsNB2CnE1pdSZ3ooUnkkx0AhXT2Zb2zyroJqMGP686kWJTAlQQ8DyvdQfQu1w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwycTGLYO3Mm4HbUVD+TXsCFajn/H14bqAYAyYtRS/pMy3eFaBW
	at3/zUXqQdr6J3Stpc1fwEVMEjSuhjEvQJinVfnCB3Up94T0kLaQe68oaoBrgGsCgtDyqZlXcil
	Au1B65mpXlQ012gpo/nsL3vmYp0R3VPJm53psx3zehtK/o1pfupsbcw==
X-Gm-Gg: AZuq6aJUaDMp5E+Aze/sm+/XiVA7VtjoqDLMsLerFtsiwlcBAKbcDXKCdKuI8ccd/xQ
	Lmn9UjagUiyzKnpPrlCk3tn2K8b+e9+Qrpo//LWqfB3db05e4anioCTbzJFWW1xXckGG7Vemt67
	rQthGM1JQJnyB6Ly3pt7NJAVADGCaXqHvAnIz8EqkTYiKWa4iTu/Z7PMzwyyxbhkFx+w7X8WO7c
	DXRZVfojAkTiUnVhWWuoBYzvfnK0M5S/kTGULq2+j/UXXrPCJvv1jyydksKJOslB9XpLVTnmaXl
	SgzAi9LBJmhszWDhsceoeukh0diLhpNB/9mKNhNY1Iv4QOYqbrMfu6XA6LS5z+PveLovY5tXaC2
	U7THjg6AVN4a8L/Lu0/YKbQF95Lf96YjU5t3Bhg1UJOeBTrNhWfh8AGN10Qfb
X-Received: by 2002:a05:600c:5493:b0:480:3a71:92b2 with SMTP id 5b1f17b1804b1-4803a71968bmr114132315e9.26.1768988197296;
        Wed, 21 Jan 2026 01:36:37 -0800 (PST)
X-Received: by 2002:a05:600c:5493:b0:480:3a71:92b2 with SMTP id 5b1f17b1804b1-4803a71968bmr114131865e9.26.1768988196858;
        Wed, 21 Jan 2026 01:36:36 -0800 (PST)
Received: from stex1.redhat.com (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43595e0a6fasm7161626f8f.10.2026.01.21.01.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 01:36:35 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: netdev@vger.kernel.org
Cc: Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Stefano Garzarella <sgarzare@redhat.com>,
	virtualization@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Asias He <asias@redhat.com>,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH net v6 1/4] vsock/virtio: fix potential underflow in virtio_transport_get_credit()
Date: Wed, 21 Jan 2026 10:36:25 +0100
Message-ID: <20260121093628.9941-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121093628.9941-1-sgarzare@redhat.com>
References: <20260121093628.9941-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68696-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,google.com,redhat.com,sberdevices.ru,davemloft.net,lists.linux.dev,vger.kernel.org,linux.vnet.ibm.com,linux.alibaba.com,gmail.com];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: DAADD54B23
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Melbin K Mathew <mlbnkm1@gmail.com>

The credit calculation in virtio_transport_get_credit() uses unsigned
arithmetic:

  ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);

If the peer shrinks its advertised buffer (peer_buf_alloc) while bytes
are in flight, the subtraction can underflow and produce a large
positive value, potentially allowing more data to be queued than the
peer can handle.

Reuse virtio_transport_has_space() which already handles this case and
add a comment to make it clear why we are doing that.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
[Stefano: use virtio_transport_has_space() instead of duplicating the code]
[Stefano: tweak the commit message]
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 26b979ad71f0..6175124d63d3 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -28,6 +28,7 @@
 
 static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
 					       bool cancel_timeout);
+static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs);
 
 static const struct virtio_transport *
 virtio_transport_get_ops(struct vsock_sock *vsk)
@@ -499,9 +500,7 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
 		return 0;
 
 	spin_lock_bh(&vvs->tx_lock);
-	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
-	if (ret > credit)
-		ret = credit;
+	ret = min_t(u32, credit, virtio_transport_has_space(vvs));
 	vvs->tx_cnt += ret;
 	vvs->bytes_unsent += ret;
 	spin_unlock_bh(&vvs->tx_lock);
@@ -877,11 +876,14 @@ u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_has_data);
 
-static s64 virtio_transport_has_space(struct vsock_sock *vsk)
+static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs)
 {
-	struct virtio_vsock_sock *vvs = vsk->trans;
 	s64 bytes;
 
+	/* Use s64 arithmetic so if the peer shrinks peer_buf_alloc while
+	 * we have bytes in flight (tx_cnt - peer_fwd_cnt), the subtraction
+	 * does not underflow.
+	 */
 	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
 	if (bytes < 0)
 		bytes = 0;
@@ -895,7 +897,7 @@ s64 virtio_transport_stream_has_space(struct vsock_sock *vsk)
 	s64 bytes;
 
 	spin_lock_bh(&vvs->tx_lock);
-	bytes = virtio_transport_has_space(vsk);
+	bytes = virtio_transport_has_space(vvs);
 	spin_unlock_bh(&vvs->tx_lock);
 
 	return bytes;
@@ -1492,7 +1494,7 @@ static bool virtio_transport_space_update(struct sock *sk,
 	spin_lock_bh(&vvs->tx_lock);
 	vvs->peer_buf_alloc = le32_to_cpu(hdr->buf_alloc);
 	vvs->peer_fwd_cnt = le32_to_cpu(hdr->fwd_cnt);
-	space_available = virtio_transport_has_space(vsk);
+	space_available = virtio_transport_has_space(vvs);
 	spin_unlock_bh(&vvs->tx_lock);
 	return space_available;
 }
-- 
2.52.0


