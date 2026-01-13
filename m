Return-Path: <kvm+bounces-67947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A5931D19C79
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 16:14:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 823F0308963F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 15:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E0A38F225;
	Tue, 13 Jan 2026 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="WhE7lXar"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4143904D1;
	Tue, 13 Jan 2026 15:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316972; cv=none; b=MDk62ZBkwpvYev8xGmeV0tJaQcfitNID8H5Rx/rvrRZaG1MYn+YpJzaTO4lX9lVt7md4kGexTLey5BoURq9Ix1cPqDFPcMAMWO4OnaFk/GRdUhyEUn3vbDwTnmIxu0ba2uL3iuBda0ZazGcg6EtzfBOjzVK3LdU76AEwVlxZcEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316972; c=relaxed/simple;
	bh=+m/zcz9m5qjJUbvy4oHymY9PyGgul7PKAKQGzkSYjno=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=px5NkkqzW34UaDJuUxkn1S6+79mVqFru31RrG47jKyRUtL4kGjJR9RUdcevvZeroPARqYC0QtiYNIsSXFLRFJe7oZ+RNtZmkWEdfU+g07fpvAvizjSzQvwx7OMlYBsEo+e/RSvPqaSxyiI1qt2kyO5XMSY9s9ig0x6QoJ5611s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=WhE7lXar; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1vfg1B-00GIga-TJ; Tue, 13 Jan 2026 16:09:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=cY/xVqDotsaOhRcTT+mmKBIUBa7/ehWTCbrX7fejO/o=; b=WhE7lXarkujclW4JMyz1blCVA7
	U096LEiJIJDuu/DxkbEZRe4dPlZhFZUS/w0BGt5NlnxVKofYJLWIqA5eN5JJts7VgwFayvrxCsIiH
	9d48SDNcUmMCxL8kjc3m35dMMEGwzzbCxDclVg4NJtR2OcCuGgpEuMlf4tUvNbX8OCeJ35Pz+LZgT
	BMvCP0NjBEf/aT1neBJfj64klly806QmRCwLZR/rmByehsEprSstiTRRhMcOjGPN60L12UJx17kbp
	boduUz6fsZrhNoTgyHQY1ZBiiOQ2vioD6c6p1i+iAORRVtOZFcVB4peZ/xqdW0rDgZjr1kn0g860g
	uRXPoUww==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1vfg1A-0007vx-OB; Tue, 13 Jan 2026 16:09:12 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vfg0w-00DMTf-1M; Tue, 13 Jan 2026 16:08:58 +0100
From: Michal Luczaj <mhal@rbox.co>
Date: Tue, 13 Jan 2026 16:08:19 +0100
Subject: [PATCH net v2 2/2] vsock/test: Add test for a linear and
 non-linear skb getting coalesced
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260113-vsock-recv-coalescence-v2-2-552b17837cf4@rbox.co>
References: <20260113-vsock-recv-coalescence-v2-0-552b17837cf4@rbox.co>
In-Reply-To: <20260113-vsock-recv-coalescence-v2-0-552b17837cf4@rbox.co>
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

To exercise the logic, send out two packets: a weirdly sized one (to ensure
some spare tail room in the skb) and a zerocopy one that's small enough to
fit in the spare room of its predecessor. Then, wait for both to land in
the rx queue, and check the data received. Faulty packets merger manifests
itself by corrupting payload of the later packet.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 tools/testing/vsock/vsock_test.c          |  5 +++
 tools/testing/vsock/vsock_test_zerocopy.c | 74 +++++++++++++++++++++++++++++++
 tools/testing/vsock/vsock_test_zerocopy.h |  3 ++
 3 files changed, 82 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index bbe3723babdc..27e39354499a 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -2403,6 +2403,11 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_accepted_setsockopt_client,
 		.run_server = test_stream_accepted_setsockopt_server,
 	},
+	{
+		.name = "SOCK_STREAM virtio MSG_ZEROCOPY coalescence corruption",
+		.run_client = test_stream_msgzcopy_mangle_client,
+		.run_server = test_stream_msgzcopy_mangle_server,
+	},
 	{},
 };
 
diff --git a/tools/testing/vsock/vsock_test_zerocopy.c b/tools/testing/vsock/vsock_test_zerocopy.c
index 9d9a6cb9614a..a31ddfc1cd0c 100644
--- a/tools/testing/vsock/vsock_test_zerocopy.c
+++ b/tools/testing/vsock/vsock_test_zerocopy.c
@@ -9,14 +9,18 @@
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
+#include <linux/time64.h>
 #include <errno.h>
 
 #include "control.h"
+#include "timeout.h"
 #include "vsock_test_zerocopy.h"
 #include "msg_zerocopy_common.h"
 
@@ -356,3 +360,73 @@ void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts)
 	control_expectln("DONE");
 	close(fd);
 }
+
+#define GOOD_COPY_LEN	128	/* net/vmw_vsock/virtio_transport_common.c */
+
+void test_stream_msgzcopy_mangle_client(const struct test_opts *opts)
+{
+	char sbuf1[PAGE_SIZE + 1], sbuf2[GOOD_COPY_LEN];
+	unsigned long hash;
+	struct pollfd fds;
+	int fd, i;
+
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	enable_so_zerocopy_check(fd);
+
+	memset(sbuf1, 'x', sizeof(sbuf1));
+	send_buf(fd, sbuf1, sizeof(sbuf1), 0, sizeof(sbuf1));
+
+	for (i = 0; i < sizeof(sbuf2); i++)
+		sbuf2[i] = rand() & 0xff;
+
+	send_buf(fd, sbuf2, sizeof(sbuf2), MSG_ZEROCOPY, sizeof(sbuf2));
+
+	hash = hash_djb2(sbuf2, sizeof(sbuf2));
+	control_writeulong(hash);
+
+	fds.fd = fd;
+	fds.events = 0;
+
+	if (poll(&fds, 1, TIMEOUT * MSEC_PER_SEC) != 1 ||
+	    !(fds.revents & POLLERR)) {
+		perror("poll");
+		exit(EXIT_FAILURE);
+	}
+
+	close(fd);
+}
+
+void test_stream_msgzcopy_mangle_server(const struct test_opts *opts)
+{
+	unsigned long local_hash, remote_hash;
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
+	/* Discard the first packet. */
+	recv_buf(fd, rbuf, PAGE_SIZE + 1, 0, PAGE_SIZE + 1);
+
+	recv_buf(fd, rbuf, GOOD_COPY_LEN, 0, GOOD_COPY_LEN);
+	remote_hash = control_readulong();
+	local_hash = hash_djb2(rbuf, GOOD_COPY_LEN);
+
+	if (local_hash != remote_hash) {
+		fprintf(stderr, "Data received corrupted\n");
+		exit(EXIT_FAILURE);
+	}
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


