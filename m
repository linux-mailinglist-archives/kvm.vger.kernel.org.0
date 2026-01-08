Return-Path: <kvm+bounces-67362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC8DD02800
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 12:50:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7B8C430DA54A
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 11:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF11E43B828;
	Thu,  8 Jan 2026 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="izlHfe2F"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8446C438394;
	Thu,  8 Jan 2026 09:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767866150; cv=none; b=JSyYBijtZD6uGGY+OAttanPXMbeLcNfSr+8cutPCCDpjCLuPCCx/Ku7DPHjoWMflhSIvB+utccdDhaH+zuMHM31uMy/yO368AHY/S8zYZDt8FrPnO/EboC6t2D0yrmYLHWMbYZP/8tJTc/T47WhyTPqfbBdQ5bOjg156/o18q4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767866150; c=relaxed/simple;
	bh=3jZ3PnY0rvRwje5pT8WFOnFUVsdmBIg6g8gCqqdjnXk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NTyvGuTOKA/CzMXN5DrDL6qkonEWZ3FtY2ASToHvY8v4v0pHYhmW2oaOSbzAdWZtgBdpB6n8J8WXE7xbLxEDeBLKlEwFYgJ4DD5Ew+VKW3jNo3/lo+Ta59M6hVNT/x/98prUfuk6isPbyDKDISvtAgmg+TBYnFaNFDFmFpM47Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=izlHfe2F; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1vdmjp-0000fD-4B; Thu, 08 Jan 2026 10:55:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=YpKDnmUVRDQ3EFb4NR3P8XxM1eDZ24y3Eu5jxeXe8E4=; b=izlHfe2FXrL341BQRbKcZ49gRl
	hesTB2RqKJ+7ZwBnW4CVkubzBMnnkxJjKo52Za/hefJN6tUKFKmoPM3BqzAMN2rvzR1UIs7CG/B+R
	qA7AOT8nqDyc9ZaD0C3/q2DIoCvBXUdXWsgOMxbvIZMLDO5lQeIZjsPBCQLtlIDObkCRoQHRPYW2q
	IFbMeBkjEj5j6BYXal6ocYlj+sVp7v9w8JKGQ/YOK90D1UKKoDl9wqvfBtk1BbYLbcUryv85BsgOe
	lYH82W6mpZBCEoxsA70HnN+kUY9lo5K92a9atdH110n+6u/EdR3UcvV3jhZPgr+0d7Huf3Xv6AN1S
	mLDV2HeQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1vdmjo-0000eX-1W; Thu, 08 Jan 2026 10:55:28 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vdmja-00AchK-O4; Thu, 08 Jan 2026 10:55:14 +0100
From: Michal Luczaj <mhal@rbox.co>
Date: Thu, 08 Jan 2026 10:54:55 +0100
Subject: [PATCH 2/2] vsock/test: Add test for a linear and non-linear skb
 getting coalesced
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-vsock-recv-coalescence-v1-2-26f97bb9a99b@rbox.co>
References: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
In-Reply-To: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
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

Loopback transport can mangle data in rx queue when a linear skb is
followed by a small MSG_ZEROCOPY packet.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 tools/testing/vsock/vsock_test.c          |  5 +++
 tools/testing/vsock/vsock_test_zerocopy.c | 67 +++++++++++++++++++++++++++++++
 tools/testing/vsock/vsock_test_zerocopy.h |  3 ++
 3 files changed, 75 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index bbe3723babdc..21c8616100f1 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -2403,6 +2403,11 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_accepted_setsockopt_client,
 		.run_server = test_stream_accepted_setsockopt_server,
 	},
+	{
+		.name = "SOCK_STREAM MSG_ZEROCOPY coalescence corruption",
+		.run_client = test_stream_msgzcopy_mangle_client,
+		.run_server = test_stream_msgzcopy_mangle_server,
+	},
 	{},
 };
 
diff --git a/tools/testing/vsock/vsock_test_zerocopy.c b/tools/testing/vsock/vsock_test_zerocopy.c
index 9d9a6cb9614a..6735a9d7525d 100644
--- a/tools/testing/vsock/vsock_test_zerocopy.c
+++ b/tools/testing/vsock/vsock_test_zerocopy.c
@@ -9,11 +9,13 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <unistd.h>
 #include <poll.h>
 #include <linux/errqueue.h>
 #include <linux/kernel.h>
+#include <linux/sockios.h>
 #include <errno.h>
 
 #include "control.h"
@@ -356,3 +358,68 @@ void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts)
 	control_expectln("DONE");
 	close(fd);
 }
+
+#define GOOD_COPY_LEN	128	/* net/vmw_vsock/virtio_transport_common.c */
+
+void test_stream_msgzcopy_mangle_client(const struct test_opts *opts)
+{
+	char sbuf1[PAGE_SIZE + 1], sbuf2[GOOD_COPY_LEN];
+	struct pollfd fds;
+	int fd;
+
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	enable_so_zerocopy_check(fd);
+
+	memset(sbuf1, '1', sizeof(sbuf1));
+	memset(sbuf2, '2', sizeof(sbuf2));
+
+	send_buf(fd, sbuf1, sizeof(sbuf1), 0, sizeof(sbuf1));
+	send_buf(fd, sbuf2, sizeof(sbuf2), MSG_ZEROCOPY, sizeof(sbuf2));
+
+	fds.fd = fd;
+	fds.events = 0;
+
+	if (poll(&fds, 1, -1) != 1 || !(fds.revents & POLLERR)) {
+		perror("poll");
+		exit(EXIT_FAILURE);
+	}
+
+	close(fd);
+}
+
+static void recv_verify(int fd, char *buf, unsigned int len, char pattern)
+{
+	recv_buf(fd, buf, len, 0, len);
+
+	while (len--) {
+		if (*buf++ != pattern) {
+			fprintf(stderr, "Incorrect data received\n");
+			exit(EXIT_FAILURE);
+		}
+	}
+}
+
+void test_stream_msgzcopy_mangle_server(const struct test_opts *opts)
+{
+	char rbuf[PAGE_SIZE + 1];
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Wait, don't race the (buggy) skbs coalescence. */
+	vsock_ioctl_int(fd, SIOCINQ, PAGE_SIZE + 1 + GOOD_COPY_LEN);
+
+	recv_verify(fd, rbuf, PAGE_SIZE + 1, '1');
+	recv_verify(fd, rbuf, GOOD_COPY_LEN, '2');
+
+	close(fd);
+}
diff --git a/tools/testing/vsock/vsock_test_zerocopy.h b/tools/testing/vsock/vsock_test_zerocopy.h
index 3ef2579e024d..d46c91a69f16 100644
--- a/tools/testing/vsock/vsock_test_zerocopy.h
+++ b/tools/testing/vsock/vsock_test_zerocopy.h
@@ -12,4 +12,7 @@ void test_seqpacket_msgzcopy_server(const struct test_opts *opts);
 void test_stream_msgzcopy_empty_errq_client(const struct test_opts *opts);
 void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts);
 
+void test_stream_msgzcopy_mangle_client(const struct test_opts *opts);
+void test_stream_msgzcopy_mangle_server(const struct test_opts *opts);
+
 #endif /* VSOCK_TEST_ZEROCOPY_H */

-- 
2.52.0


