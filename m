Return-Path: <kvm+bounces-44830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 686C1AA3D40
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 01:55:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CFD24E2622
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 23:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D643235065;
	Tue, 29 Apr 2025 23:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XKD9Uo2N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD47235040;
	Tue, 29 Apr 2025 23:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970645; cv=none; b=LXoo9qnp0SfCTUm/JZMdl8QMr3HQSq+mlKeqxqf5kHTSLkzjQ0fhXgY599PpUfMQ8m34za2SfMQNqQWoByeXO/8RUU/Te23y15St78zKvYvXIt2QjSbOQMYtgSp0EwQzqFQvStDD3248izdm27WW1FtXrpszVPnvpWo42oTsfFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970645; c=relaxed/simple;
	bh=IzBhOCAVYFmFiUQDsYqBC9p3Z3/XGMlBkDU+3zszrB4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oLCVCl8k/mqhnL8DiOu4oytN0hUEgdwrWMb5zIa96+iuzvnjnT+bDzmtYPGC70znnxclAc4ucEM6MumRDHBdkR2qTwCwRD3j5VYDxvRjSwEY8rezSl/OiLVR5ae3dvV2Ou8VF+yRngEFYQfG2wK69sOIkN930Q+rsRTuKnnA2DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XKD9Uo2N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC36C4CEE3;
	Tue, 29 Apr 2025 23:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970645;
	bh=IzBhOCAVYFmFiUQDsYqBC9p3Z3/XGMlBkDU+3zszrB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKD9Uo2Nwi58iZASk/WbhQQzNhSalDGsDcP51TiWgeBfCqK6Rauop5WtoQW0JPwy0
	 VZgrVVN2YtXs9sTIpU1axF4g52msLd0SZPSDPRLEXq5yhlP/1jwqRHpOYANf0SCKF4
	 3pxWa4Z/Lo0M12sv11ox6Sc5kLkfMPjEtuXQ2S3IfVuHt8bqDYn/NHOim6IQc5cUWy
	 1TdhA6AFqv0nbQpnUX/y4cIoXg3Vrw1or/fBPB8wuu51cJGKlD0ae0GZiQSWk3U36W
	 9OCCBihhsYRM4L7uKxMjT4gDa/no3G2mC7l+xQG9Vw3Y7GZq3iFlFj8jyE0r1+PEr/
	 yxozTNgyqp6pw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 20/39] vhost_task: fix vhost_task_create() documentation
Date: Tue, 29 Apr 2025 19:49:47 -0400
Message-Id: <20250429235006.536648-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235006.536648-1-sashal@kernel.org>
References: <20250429235006.536648-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.4
Content-Transfer-Encoding: 8bit

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit fec0abf52609c20279243699d08b660c142ce0aa ]

Commit cb380909ae3b ("vhost: return task creation error instead of NULL")
changed the return value of vhost_task_create(), but did not update the
documentation.

Reflect the change in the documentation: on an error, vhost_task_create()
returns an ERR_PTR() and no longer NULL.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20250327124435.142831-1-sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/vhost_task.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index 2ef2e1b800916..2f844c279a3e0 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -111,7 +111,7 @@ EXPORT_SYMBOL_GPL(vhost_task_stop);
  * @arg: data to be passed to fn and handled_kill
  * @name: the thread's name
  *
- * This returns a specialized task for use by the vhost layer or NULL on
+ * This returns a specialized task for use by the vhost layer or ERR_PTR() on
  * failure. The returned task is inactive, and the caller must fire it up
  * through vhost_task_start().
  */
-- 
2.39.5


