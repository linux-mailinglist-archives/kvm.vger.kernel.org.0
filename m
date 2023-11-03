Return-Path: <kvm+bounces-519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B18D7E07D9
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 18:56:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2770A1C210AB
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 17:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A57D22EF9;
	Fri,  3 Nov 2023 17:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FjeJPHgS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D6F225A4;
	Fri,  3 Nov 2023 17:56:02 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC09B1BD;
	Fri,  3 Nov 2023 10:56:00 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-9d224dca585so354913066b.1;
        Fri, 03 Nov 2023 10:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699034159; x=1699638959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANnfbv1oGkDpEz/e45pUqxbq4vbbI9kV1Jy9Nq/Lv90=;
        b=FjeJPHgSk67T50NWxh5D7atfWqnCvkgvtcY+QMr54VoYRV4tu44oDD4kVvzXWV/PCH
         HcabX/RFYUe1Uiye4O/Ki1hsOoyCIEGUziDt2Y3NW+oAaY1N2i7WeU4so88gZGpmvXgF
         Uu9/y/XmPLxG5uMLVxC9X4SzxBCQNeOL/Bo6b8JSJ7o3ON8fHnhWuFgWiuP1rYR5kLVm
         sze6i0vI79Lf4+xNHFUE9Sten0Et/pQoue3bHo6PUhULDY1RKpCbvRpJDwIXhzV4u8rQ
         IXjkiD2uK8q7rR+fjmImY4OjfwYMCz3ny/E15mnV/kiaXREvUAlkONxj9lqk/AbNIDuq
         oq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699034159; x=1699638959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ANnfbv1oGkDpEz/e45pUqxbq4vbbI9kV1Jy9Nq/Lv90=;
        b=L6bw9ebbSWSX42T3KHT9LgoxrStV0bbJk/e7rCo5YxriySh2NNPSwP6IDQDJJ/H7Ja
         M/IrJ9OjhOFqvc8LMGAEv1ojD7PcutQXU7MvBOtG8XNhgcU2ZXDcXPrwodghRldszvtB
         fHXso4kn0/TIM58Z1Xot8sFtSI+snZqxnyikWKAtHhUJBCrWTNXfDSsM3umeygFUaXQF
         8ZZpzdXzQwZhcWC8/lWOYNPrulgTThxek90MsDlxQZyuncmIlVwrM0eHBeocBQDKjeqj
         XCombZlvgsP/mmUIZdRZ2fLJRwaNaM7QclplKcg2qhf2riqCgieDgww5Eyx+r9h0PhqB
         ZV+Q==
X-Gm-Message-State: AOJu0YwO6CCTYBHfpg3Q3nHmzKN/FqBliwM59qq4FFdeeGZNxek1c75K
	pzja79DiMmyxp/H7L/1n6LY=
X-Google-Smtp-Source: AGHT+IG+Ba5CGONVICNPRhtchYsMjNYT5WbIR+O63L72F5/7sEGvOVu44gBRrmbNu6Mhg9TmbQSthA==
X-Received: by 2002:a17:907:72c2:b0:9ad:c763:bc7a with SMTP id du2-20020a17090772c200b009adc763bc7amr8200301ejc.23.1699034159044;
        Fri, 03 Nov 2023 10:55:59 -0700 (PDT)
Received: from fedora.. (host-62-211-113-16.retail.telecomitalia.it. [62.211.113.16])
        by smtp.gmail.com with ESMTPSA id wj6-20020a170907050600b009ddf1a84379sm80306ejb.51.2023.11.03.10.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Nov 2023 10:55:58 -0700 (PDT)
From: f.storniolo95@gmail.com
To: luigi.leonardi@outlook.com,
	kvm@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	mst@redhat.com,
	imbrenda@linux.vnet.ibm.com,
	kuba@kernel.org,
	asias@redhat.com,
	stefanha@redhat.com,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Filippo Storniolo <f.storniolo95@gmail.com>
Subject: [PATCH net 4/4] test/vsock: add dobule bind connect test
Date: Fri,  3 Nov 2023 18:55:51 +0100
Message-ID: <20231103175551.41025-5-f.storniolo95@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231103175551.41025-1-f.storniolo95@gmail.com>
References: <20231103175551.41025-1-f.storniolo95@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filippo Storniolo <f.storniolo95@gmail.com>

This add bind connect test which creates a listening server socket
and tries to connect a client with a bound local port to it twice.

Co-developed-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Filippo Storniolo <f.storniolo95@gmail.com>
---
 tools/testing/vsock/util.c       | 47 ++++++++++++++++++++++++++++++
 tools/testing/vsock/util.h       |  3 ++
 tools/testing/vsock/vsock_test.c | 50 ++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 2fc96f29bdf2..ae2b33c21c45 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -85,6 +85,48 @@ void vsock_wait_remote_close(int fd)
 	close(epollfd);
 }
 
+/* Bind to <bind_port>, connect to <cid, port> and return the file descriptor. */
+int vsock_bind_connect(unsigned int cid, unsigned int port, unsigned int bind_port, int type)
+{
+	struct sockaddr_vm sa_client = {
+		.svm_family = AF_VSOCK,
+		.svm_cid = VMADDR_CID_ANY,
+		.svm_port = bind_port,
+	};
+	struct sockaddr_vm sa_server = {
+		.svm_family = AF_VSOCK,
+		.svm_cid = cid,
+		.svm_port = port,
+	};
+
+	int client_fd, ret;
+
+	client_fd = socket(AF_VSOCK, type, 0);
+	if (client_fd < 0) {
+		perror("socket");
+		exit(EXIT_FAILURE);
+	}
+
+	if (bind(client_fd, (struct sockaddr *)&sa_client, sizeof(sa_client))) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	timeout_begin(TIMEOUT);
+	do {
+		ret = connect(client_fd, (struct sockaddr *)&sa_server, sizeof(sa_server));
+		timeout_check("connect");
+	} while (ret < 0 && errno == EINTR);
+	timeout_end();
+
+	if (ret < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	return client_fd;
+}
+
 /* Connect to <cid, port> and return the file descriptor. */
 static int vsock_connect(unsigned int cid, unsigned int port, int type)
 {
@@ -223,6 +265,11 @@ int vsock_stream_accept(unsigned int cid, unsigned int port,
 	return vsock_accept(cid, port, clientaddrp, SOCK_STREAM);
 }
 
+int vsock_stream_listen(unsigned int cid, unsigned int port)
+{
+	return vsock_listen(cid, port, SOCK_STREAM);
+}
+
 int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
 			   struct sockaddr_vm *clientaddrp)
 {
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index a77175d25864..03c88d0cb861 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -36,9 +36,12 @@ struct test_case {
 void init_signals(void);
 unsigned int parse_cid(const char *str);
 int vsock_stream_connect(unsigned int cid, unsigned int port);
+int vsock_bind_connect(unsigned int cid, unsigned int port,
+		       unsigned int bind_port, int type);
 int vsock_seqpacket_connect(unsigned int cid, unsigned int port);
 int vsock_stream_accept(unsigned int cid, unsigned int port,
 			struct sockaddr_vm *clientaddrp);
+int vsock_stream_listen(unsigned int cid, unsigned int port);
 int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
 			   struct sockaddr_vm *clientaddrp);
 void vsock_wait_remote_close(int fd);
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index c1f7bc9abd22..5b0e93f9996c 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -1180,6 +1180,51 @@ static void test_stream_shutrd_server(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_double_bind_connect_server(const struct test_opts *opts)
+{
+	int listen_fd, client_fd, i;
+	struct sockaddr_vm sa_client;
+	socklen_t socklen_client = sizeof(sa_client);
+
+	listen_fd = vsock_stream_listen(VMADDR_CID_ANY, 1234);
+
+	for (i = 0; i < 2; i++) {
+		control_writeln("LISTENING");
+
+		timeout_begin(TIMEOUT);
+		do {
+			client_fd = accept(listen_fd, (struct sockaddr *)&sa_client,
+					   &socklen_client);
+			timeout_check("accept");
+		} while (client_fd < 0 && errno == EINTR);
+		timeout_end();
+
+		if (client_fd < 0) {
+			perror("accept");
+			exit(EXIT_FAILURE);
+		}
+
+		/* Waiting for remote peer to close connection */
+		vsock_wait_remote_close(client_fd);
+	}
+
+	close(listen_fd);
+}
+
+static void test_double_bind_connect_client(const struct test_opts *opts)
+{
+	int i, client_fd;
+
+	for (i = 0; i < 2; i++) {
+		/* Wait until server is ready to accept a new connection */
+		control_expectln("LISTENING");
+
+		client_fd = vsock_bind_connect(opts->peer_cid, 1234, 4321, SOCK_STREAM);
+
+		close(client_fd);
+	}
+}
+
 static struct test_case test_cases[] = {
 	{
 		.name = "SOCK_STREAM connection reset",
@@ -1285,6 +1330,11 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_msgzcopy_empty_errq_client,
 		.run_server = test_stream_msgzcopy_empty_errq_server,
 	},
+	{
+		.name = "SOCK_STREAM double bind connect",
+		.run_client = test_double_bind_connect_client,
+		.run_server = test_double_bind_connect_server,
+	},
 	{},
 };
 
-- 
2.41.0


