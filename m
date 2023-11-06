Return-Path: <kvm+bounces-659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1E57E1ED7
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:48:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01C601F21A7F
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 10:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89487179B3;
	Mon,  6 Nov 2023 10:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EcEREucO"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE1E17730
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:48:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5653BBD
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 02:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699267711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AY8KQ4dvEPvqonuERioJ87ft9Eic3IHQdrVBtrNqSWo=;
	b=EcEREucOH+GLWegbwMGGfNlERT/ekUyRxxklseJTzdL3FMtQyyHdjhm2gC1f8uQFV96tvP
	/xxNSZJR3k+a3MKtEdNZ8ezhEjlHs0a/zFsO1bGVx22E+MIammMZw65ShBlB4z0oBIsfRs
	C+H37Z9Wj71iHQYu6i5P83kXZtNdxOc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-DY1PowN-NXu-9mbJ5cFxUQ-1; Mon, 06 Nov 2023 05:48:30 -0500
X-MC-Unique: DY1PowN-NXu-9mbJ5cFxUQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6707401e1aeso51760816d6.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 02:48:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699267710; x=1699872510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AY8KQ4dvEPvqonuERioJ87ft9Eic3IHQdrVBtrNqSWo=;
        b=uwFRNpRBoVWSQhFSnCxFa5JobOQnBRim5ZO0fZLUlYzGmWP2NAtKrnED1cikZPlOkV
         E2GH1uCLHK4joNVuMOZtZukIHmkqbuQiljJMvIYMJYEMf/vUeQHmmMVWDnQy3CqaZs1r
         Ron07QH7lB3NKkV45STknnK30f+dF/sMqwbC/G/L0iue0K29tuZmZyYeq6irOPRujFP8
         ZGHalpez8NuXVTJ3Cpa7hvQ1Vkks0JbR/vsPVS8q+ujTGAatpmiKeikpXSfT2pwD7LO2
         TnFeHzB1iY+FG4rc0lNI/n0zEu5avcdGlVE2Y4yIwQ+x3obvtdXSUIqoc0poet0pF3Cu
         rHyg==
X-Gm-Message-State: AOJu0YzkuiY3YhpbqLCxtk/ZPDQUbkj+TjqxjdDg3U4SKJB/AKBdhngl
	KThUknJKq5JW3+eMZj3Ni/rT08ts3EeZ82od531UQJuzFBO4aYwG9OU2+dDTk0Y8/TKUVjiLz77
	FR2sAUo/xoudP
X-Received: by 2002:a05:6214:1bc6:b0:671:c324:9f45 with SMTP id m6-20020a0562141bc600b00671c3249f45mr26686710qvc.37.1699267709724;
        Mon, 06 Nov 2023 02:48:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGSWODpMGqUx3V+1IHlXcJNCdjNt6jKwKZosYLRGIC47MezPBYolbbHK/PWFX0kgd39uUHuxA==
X-Received: by 2002:a05:6214:1bc6:b0:671:c324:9f45 with SMTP id m6-20020a0562141bc600b00671c3249f45mr26686691qvc.37.1699267709389;
        Mon, 06 Nov 2023 02:48:29 -0800 (PST)
Received: from sgarzare-redhat ([5.179.191.143])
        by smtp.gmail.com with ESMTPSA id u5-20020a0cea45000000b00670bd5a3720sm3334051qvp.97.2023.11.06.02.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 02:48:29 -0800 (PST)
Date: Mon, 6 Nov 2023 11:48:23 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: f.storniolo95@gmail.com
Cc: luigi.leonardi@outlook.com, kvm@vger.kernel.org, davem@davemloft.net, 
	edumazet@google.com, mst@redhat.com, imbrenda@linux.vnet.ibm.com, kuba@kernel.org, 
	asias@redhat.com, stefanha@redhat.com, pabeni@redhat.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net 4/4] test/vsock: add dobule bind connect test
Message-ID: <65r6y2wdx3grj6ofsat2c2rpqwijvnfni2yxsbwnr6vcjalbpt@5rh46vj2dbcc>
References: <20231103175551.41025-1-f.storniolo95@gmail.com>
 <20231103175551.41025-5-f.storniolo95@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231103175551.41025-5-f.storniolo95@gmail.com>

On Fri, Nov 03, 2023 at 06:55:51PM +0100, f.storniolo95@gmail.com wrote:
>From: Filippo Storniolo <f.storniolo95@gmail.com>
>
>This add bind connect test which creates a listening server socket
>and tries to connect a client with a bound local port to it twice.
>
>Co-developed-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>Signed-off-by: Filippo Storniolo <f.storniolo95@gmail.com>
>---
> tools/testing/vsock/util.c       | 47 ++++++++++++++++++++++++++++++
> tools/testing/vsock/util.h       |  3 ++
> tools/testing/vsock/vsock_test.c | 50 ++++++++++++++++++++++++++++++++
> 3 files changed, 100 insertions(+)

LGTM!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 2fc96f29bdf2..ae2b33c21c45 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -85,6 +85,48 @@ void vsock_wait_remote_close(int fd)
> 	close(epollfd);
> }
>
>+/* Bind to <bind_port>, connect to <cid, port> and return the file descriptor. */
>+int vsock_bind_connect(unsigned int cid, unsigned int port, unsigned int bind_port, int type)
>+{
>+	struct sockaddr_vm sa_client = {
>+		.svm_family = AF_VSOCK,
>+		.svm_cid = VMADDR_CID_ANY,
>+		.svm_port = bind_port,
>+	};
>+	struct sockaddr_vm sa_server = {
>+		.svm_family = AF_VSOCK,
>+		.svm_cid = cid,
>+		.svm_port = port,
>+	};
>+
>+	int client_fd, ret;
>+
>+	client_fd = socket(AF_VSOCK, type, 0);
>+	if (client_fd < 0) {
>+		perror("socket");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (bind(client_fd, (struct sockaddr *)&sa_client, sizeof(sa_client))) {
>+		perror("bind");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	timeout_begin(TIMEOUT);
>+	do {
>+		ret = connect(client_fd, (struct sockaddr *)&sa_server, sizeof(sa_server));
>+		timeout_check("connect");
>+	} while (ret < 0 && errno == EINTR);
>+	timeout_end();
>+
>+	if (ret < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	return client_fd;
>+}
>+
> /* Connect to <cid, port> and return the file descriptor. */
> static int vsock_connect(unsigned int cid, unsigned int port, int type)
> {
>@@ -223,6 +265,11 @@ int vsock_stream_accept(unsigned int cid, unsigned int port,
> 	return vsock_accept(cid, port, clientaddrp, SOCK_STREAM);
> }
>
>+int vsock_stream_listen(unsigned int cid, unsigned int port)
>+{
>+	return vsock_listen(cid, port, SOCK_STREAM);
>+}
>+
> int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
> 			   struct sockaddr_vm *clientaddrp)
> {
>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index a77175d25864..03c88d0cb861 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -36,9 +36,12 @@ struct test_case {
> void init_signals(void);
> unsigned int parse_cid(const char *str);
> int vsock_stream_connect(unsigned int cid, unsigned int port);
>+int vsock_bind_connect(unsigned int cid, unsigned int port,
>+		       unsigned int bind_port, int type);
> int vsock_seqpacket_connect(unsigned int cid, unsigned int port);
> int vsock_stream_accept(unsigned int cid, unsigned int port,
> 			struct sockaddr_vm *clientaddrp);
>+int vsock_stream_listen(unsigned int cid, unsigned int port);
> int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
> 			   struct sockaddr_vm *clientaddrp);
> void vsock_wait_remote_close(int fd);
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index c1f7bc9abd22..5b0e93f9996c 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -1180,6 +1180,51 @@ static void test_stream_shutrd_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+static void test_double_bind_connect_server(const struct test_opts *opts)
>+{
>+	int listen_fd, client_fd, i;
>+	struct sockaddr_vm sa_client;
>+	socklen_t socklen_client = sizeof(sa_client);
>+
>+	listen_fd = vsock_stream_listen(VMADDR_CID_ANY, 1234);
>+
>+	for (i = 0; i < 2; i++) {
>+		control_writeln("LISTENING");
>+
>+		timeout_begin(TIMEOUT);
>+		do {
>+			client_fd = accept(listen_fd, (struct sockaddr *)&sa_client,
>+					   &socklen_client);
>+			timeout_check("accept");
>+		} while (client_fd < 0 && errno == EINTR);
>+		timeout_end();
>+
>+		if (client_fd < 0) {
>+			perror("accept");
>+			exit(EXIT_FAILURE);
>+		}
>+
>+		/* Waiting for remote peer to close connection */
>+		vsock_wait_remote_close(client_fd);
>+	}
>+
>+	close(listen_fd);
>+}
>+
>+static void test_double_bind_connect_client(const struct test_opts *opts)
>+{
>+	int i, client_fd;
>+
>+	for (i = 0; i < 2; i++) {
>+		/* Wait until server is ready to accept a new connection */
>+		control_expectln("LISTENING");
>+
>+		client_fd = vsock_bind_connect(opts->peer_cid, 1234, 4321, SOCK_STREAM);
>+
>+		close(client_fd);
>+	}
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -1285,6 +1330,11 @@ static struct test_case test_cases[] = {
> 		.run_client = test_stream_msgzcopy_empty_errq_client,
> 		.run_server = test_stream_msgzcopy_empty_errq_server,
> 	},
>+	{
>+		.name = "SOCK_STREAM double bind connect",
>+		.run_client = test_double_bind_connect_client,
>+		.run_server = test_double_bind_connect_server,
>+	},
> 	{},
> };
>
>-- 
>2.41.0
>


