Return-Path: <kvm+bounces-67945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE537D19CA3
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 16:15:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B270830704CA
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 15:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBDC138F253;
	Tue, 13 Jan 2026 15:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="AjqgBDJT"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F9538F225;
	Tue, 13 Jan 2026 15:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316966; cv=none; b=oYjbvy5Z4iR9yrOxCeVplWCXJmKV09qD703DxvUEsarISwURchsbgK28YoV5wqZUTt0/akYQy/vXp7CXc8SFu5ApVpdyS3kNeUpyi8fVF/0faRf1O1vEixdecTKkhvdW/W899b3+ixlpwPqP1Vc0HmS1/0MXfjeB2eDJMSyjs/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316966; c=relaxed/simple;
	bh=APW+EJqGlo11Nfil1gNg8AwhxKUcfOhkC/Pj8Alu+yE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Ji+fH+blZnqTRHGP+jhKUV/gA+6PAZj7LijafJoaYh7U5XErNdx1XpTnP14fJ+Gq9x/SI23TnONN6W0lUVTY7kffymgqBPaeEvs3tg6g1onSJu4KUui1rpn1EY2oNNiu2adYp32PaU6Ckitck+snvpBEdwBx0aqfNcmVYElPaKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=AjqgBDJT; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1vfg1E-00GFv6-Mx; Tue, 13 Jan 2026 16:09:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From; bh=cxZA9OymIPUQa2MzaISiJK8WAe7p4NePlnkCYENkOz4=
	; b=AjqgBDJTZnsqToBFmZ1io0UhL7t+xA9pQLT79xgqnenoU7dAWSTWraYmz7XNjgA+UtXfsJczk
	2lXqLkfdEWsQOXTlH+1DUWEyaEqOxbAd0h08P0qFgX1dWSltNKEbYl/8i5CJRqyrejzZh/e0Lua1w
	9i1I6NgcFP25qRgKXB7j51YYpCnwgd2U9u1dXlvOu68oowOu5pH4NUz7tbuyGehryUQo603F343oO
	luctmLzEZLCWwk1Zz9amNEjTN5Y8JHsCz0yUxVp/J9IiiOlcqbSi99xZ8hvurt3R7ZdhRbWBmoLu2
	y5LFZv6jujnCjxAc5Ie9DU36vnIgN4QL7jCyVg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1vfg1E-0004kO-B5; Tue, 13 Jan 2026 16:09:16 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vfg0u-00DMTf-9Q; Tue, 13 Jan 2026 16:08:56 +0100
From: Michal Luczaj <mhal@rbox.co>
Subject: [PATCH net v2 0/2] vsock/virtio: Fix data loss/disclosure due to
 joining of non-linear skb
Date: Tue, 13 Jan 2026 16:08:17 +0100
Message-Id: <20260113-vsock-recv-coalescence-v2-0-552b17837cf4@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOFfZmkC/3WNwQqDMBBEf0X23C1JBDU99T/EQ7JuamhJSiLBI
 v57g/Ta45th3uyQOXnOcGt2SFx89jFUUJcGaDHhwejnyqCE6oQULZYc6YmJqSBF8+JMHIixHWQ
 /OONmKQjq+J3Y+e0UjxB4hamGi89rTJ/zrMiz+nmHf94iUaDqnO6t1UZre082bleKMB3H8QWDH
 K1VvwAAAA==
X-Change-ID: 20260103-vsock-recv-coalescence-38178fafd10c
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, 
 Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Michal Luczaj <mhal@rbox.co>
X-Mailer: b4 0.14.3

Loopback transport coalesces some skbs too eagerly. Handling a zerocopy
(non-linear) skb as a linear one leads to skb data loss and kernel memory
disclosure.

Plug the loss/leak by allowing only linear skb join. Provide a test.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
Changes in v2:
- Point out virtio transports affected/unaffected [Stefano]
- Move and comment skb_is_nonlinear() check [Stefano]
- Describe test logic in detail, mention "virtio" in the name [Stefano]
- Test: call poll() with a proper timeout, drop recv_verify()
- Link to v1: https://lore.kernel.org/r/20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co

---
Michal Luczaj (2):
      vsock/virtio: Coalesce only linear skb
      vsock/test: Add test for a linear and non-linear skb getting coalesced

 net/vmw_vsock/virtio_transport_common.c   |  6 ++-
 tools/testing/vsock/vsock_test.c          |  5 +++
 tools/testing/vsock/vsock_test_zerocopy.c | 74 +++++++++++++++++++++++++++++++
 tools/testing/vsock/vsock_test_zerocopy.h |  3 ++
 4 files changed, 86 insertions(+), 2 deletions(-)
---
base-commit: ffe4ccd359d006eba559cb1a3c6113144b7fb38c
change-id: 20260103-vsock-recv-coalescence-38178fafd10c

Best regards,
-- 
Michal Luczaj <mhal@rbox.co>


