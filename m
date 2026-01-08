Return-Path: <kvm+bounces-67361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A0CD027FD
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 12:50:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A996230D7FAB
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 11:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0CC4383A5;
	Thu,  8 Jan 2026 09:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="LuUrR0+l"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4563A43839A;
	Thu,  8 Jan 2026 09:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767866145; cv=none; b=OhpZTP+I0/4aNf2gv/BqzL59dQG+0yTRnAPjzvmn0EvEeFh2NAy66fV2AOF+qGzi4iclGqwCW3zI746xCyPIOQBW25G60FwgzWpCemi2bE5N069YSqSolw876VYYl3ZyCDWQ5yDdjSdyGIzEZCZ/4JHgJqH8PGuCKwQwcnUEhQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767866145; c=relaxed/simple;
	bh=EvIONFN7UXUZL6xMVob3uUTPUEaNiM+IyoWJle+1bRo=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=hfyaN0WmbRKW4i6GtEirueHLlNnD2BL2WzXudtYcmjmTMcL4PaTzc9Gq8cnWH/ws3cWlCLydts5GjYZKaZ9lQWNUZZ5U0C17mL7pw/ZF0MTxtfrJsX/NMFP/GnMrBaQpW/c0cM4sAQV0e3Mhu2VyQM5O3CPaMnHJ132I/IAazRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=LuUrR0+l; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1vdmjp-0000fR-UL; Thu, 08 Jan 2026 10:55:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From; bh=P3hj6q3gjtPJPbpzzaDTeFeR0mK65piI4fXLK4GYSOQ=
	; b=LuUrR0+lSF0ZCpK1mRKfpcF4cGx437j9yQIJ4UtNCEm+N1wGJBkFpxCXsSioHem2HL0kFObR2
	SP6J1TDsKIi9NFtUUZn7IVD3KVgT5ZJnVyEM9zgFY6Wc5lLVd0UxAf1ehejI1csLtXtLlSi8eBdKN
	VP8BbxqrsWTBCjQgzyppdVCtU41LoKdH7J1ArrEh/LuUThOp8pKQL11RmzBZXP2NBgia28s6CJNzv
	CfTOG3SEHmOKWkDOHOSVZi4VwoYoYUy0o30lMSwFWwLXBJBhnoOBaTYUzlQTxRpWbOSnqcifjA61/
	kcYeKOOqaMZJowzU2+SiBRvtUnZRtcTwhP6JIA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1vdmjp-0000fD-8A; Thu, 08 Jan 2026 10:55:29 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vdmjY-00AchK-Rh; Thu, 08 Jan 2026 10:55:12 +0100
From: Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 0/2] vsock/virtio: Fix data loss/disclosure due to joining
 of non-linear skb in RX queue
Date: Thu, 08 Jan 2026 10:54:53 +0100
Message-Id: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAO1+X2kC/x3MQQqDMBBG4avIrB1IFFrxKqWLMP5ph5ZEMhAEy
 d0NLr/FeycZisJoHU4qqGqaU4cfB5JvSB+wbt00uenhvJu5WpYfF0hlyeEPEyQBz4t/LjHEzTu
 hHu8FUY97/Hq3dgFpg+z3aAAAAA==
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
Michal Luczaj (2):
      vsock/virtio: Coalesce only linear skb
      vsock/test: Add test for a linear and non-linear skb getting coalesced

 net/vmw_vsock/virtio_transport_common.c   |  3 +-
 tools/testing/vsock/vsock_test.c          |  5 +++
 tools/testing/vsock/vsock_test_zerocopy.c | 67 +++++++++++++++++++++++++++++++
 tools/testing/vsock/vsock_test_zerocopy.h |  3 ++
 4 files changed, 77 insertions(+), 1 deletion(-)
---
base-commit: 653267321f05316f159e05b3ef562aa700632db6
change-id: 20260103-vsock-recv-coalescence-38178fafd10c

Best regards,
-- 
Michal Luczaj <mhal@rbox.co>


