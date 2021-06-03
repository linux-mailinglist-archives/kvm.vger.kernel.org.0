Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1757939A4BB
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 17:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFCPjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 11:39:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhFCPjy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 11:39:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622734688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MAfOCgAL+/4c+u2cKFnHe9PJR7//GbNGS7l7MR7qaKc=;
        b=Vt0WcLCOaiemRoUncmv1MZTGgmuIdpKQ21SFnRn10IZ8+N1hRubwk9UZbM3IoXn1SaDyjI
        DXCQknqP1u4rN4UWPAZOAiZO2+dNuBoeIZVjtVsK125rtQ1gHs59lIwQ74QMcAapc4y3p9
        PGdDhniSbMxklxlH6N8OYU8m9/gBq8s=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-IEt0PNygPZmV-_GJfuz-0Q-1; Thu, 03 Jun 2021 11:38:07 -0400
X-MC-Unique: IEt0PNygPZmV-_GJfuz-0Q-1
Received: by mail-ej1-f70.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso2109423ejc.7
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 08:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MAfOCgAL+/4c+u2cKFnHe9PJR7//GbNGS7l7MR7qaKc=;
        b=KXVRnfPDLDS96J5jHkXOnv9IOdvHz+CazfNMMW9lOEtdH1MYWFaDw6dZJHctxFeTSa
         NFLEq1iX+iDAC5p+uEhUt9DZTkXxcEi3/RslXeffeTMWXdB2vlWhe+uLpWgORHHsBsR+
         /8v1/gNDh/c1x7o8sHaFEUTlolFY/cwyWTbFCT4qeifmfhvFEzX/XyHf29dCnRDMCPx4
         5BkG4/FRxvElbaC+u6HNVxTVaTwg8OXv8ihT9mfP1lOtxqqMpLu3oAh4kGJG9bh4Lfxg
         DX6uk7ITFMa7ETz2c4yeL+9jJMmHH81eLEtI+cKKvz+8Mw2xDeXxSJEJ5y6wzffBiyAp
         3utg==
X-Gm-Message-State: AOAM533JoziFv9gIFfwaO5tHG6zZqpACQlW7vKA6pQYQS1c5NgWQ+YEW
        YUFzFejFFHJDyr1a6+cZwge4zUEgRDyQwJXMNBkLMhQXQcQWlNUDA8guhMJHexZMfn/IUhKMyb6
        NPzzTWpgyoeFP
X-Received: by 2002:a05:6402:b1a:: with SMTP id bm26mr61516edb.387.1622734686331;
        Thu, 03 Jun 2021 08:38:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCg4RiY3uWsOMEkG7pXj17Pm1AGWGs6kIw12MPkL7qvmBz82U9B68S6pavqH2tLMDPO5l1tw==
X-Received: by 2002:a05:6402:b1a:: with SMTP id bm26mr61493edb.387.1622734686165;
        Thu, 03 Jun 2021 08:38:06 -0700 (PDT)
Received: from steredhat ([5.170.129.82])
        by smtp.gmail.com with ESMTPSA id z20sm1641999ejd.18.2021.06.03.08.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 08:38:05 -0700 (PDT)
Date:   Thu, 3 Jun 2021 17:38:01 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 17/18] vsock_test: add SOCK_SEQPACKET tests
Message-ID: <20210603153801.xyew6p5d4x4orwka@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191953.1272798-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520191953.1272798-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 10:19:50PM +0300, Arseny Krasnov wrote:
>Implement two tests of SOCK_SEQPACKET socket: first sends data by
>several 'write()'s and checks that number of 'read()' were same.
>Second test checks MSG_TRUNC flag. Cases for connect(), bind(),
>etc. are not tested, because it is same as for stream socket.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v9 -> v10:
> 1) Commit message updated.
> 2) Add second test for message bounds.

This patch LGTM, but I'll review better with the next version, running 
also the test suite on my VMs.

Thanks,
Stefano

>
> tools/testing/vsock/util.c       |  32 +++++++--
> tools/testing/vsock/util.h       |   3 +
> tools/testing/vsock/vsock_test.c | 116 +++++++++++++++++++++++++++++++
> 3 files changed, 146 insertions(+), 5 deletions(-)
>
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 93cbd6f603f9..2acbb7703c6a 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -84,7 +84,7 @@ void vsock_wait_remote_close(int fd)
> }
>
> /* Connect to <cid, port> and return the file descriptor. */
>-int vsock_stream_connect(unsigned int cid, unsigned int port)
>+static int vsock_connect(unsigned int cid, unsigned int port, int type)
> {
> 	union {
> 		struct sockaddr sa;
>@@ -101,7 +101,7 @@ int vsock_stream_connect(unsigned int cid, unsigned int port)
>
> 	control_expectln("LISTENING");
>
>-	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
>+	fd = socket(AF_VSOCK, type, 0);
>
> 	timeout_begin(TIMEOUT);
> 	do {
>@@ -120,11 +120,21 @@ int vsock_stream_connect(unsigned int cid, unsigned int port)
> 	return fd;
> }
>
>+int vsock_stream_connect(unsigned int cid, unsigned int port)
>+{
>+	return vsock_connect(cid, port, SOCK_STREAM);
>+}
>+
>+int vsock_seqpacket_connect(unsigned int cid, unsigned int port)
>+{
>+	return vsock_connect(cid, port, SOCK_SEQPACKET);
>+}
>+
> /* Listen on <cid, port> and return the first incoming connection.  The remote
>  * address is stored to clientaddrp.  clientaddrp may be NULL.
>  */
>-int vsock_stream_accept(unsigned int cid, unsigned int port,
>-			struct sockaddr_vm *clientaddrp)
>+static int vsock_accept(unsigned int cid, unsigned int port,
>+			struct sockaddr_vm *clientaddrp, int type)
> {
> 	union {
> 		struct sockaddr sa;
>@@ -145,7 +155,7 @@ int vsock_stream_accept(unsigned int cid, unsigned int port,
> 	int client_fd;
> 	int old_errno;
>
>-	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
>+	fd = socket(AF_VSOCK, type, 0);
>
> 	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
> 		perror("bind");
>@@ -189,6 +199,18 @@ int vsock_stream_accept(unsigned int cid, unsigned int port,
> 	return client_fd;
> }
>
>+int vsock_stream_accept(unsigned int cid, unsigned int port,
>+			struct sockaddr_vm *clientaddrp)
>+{
>+	return vsock_accept(cid, port, clientaddrp, SOCK_STREAM);
>+}
>+
>+int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
>+			   struct sockaddr_vm *clientaddrp)
>+{
>+	return vsock_accept(cid, port, clientaddrp, SOCK_SEQPACKET);
>+}
>+
> /* Transmit one byte and check the return value.
>  *
>  * expected_ret:
>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index e53dd09d26d9..a3375ad2fb7f 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -36,8 +36,11 @@ struct test_case {
> void init_signals(void);
> unsigned int parse_cid(const char *str);
> int vsock_stream_connect(unsigned int cid, unsigned int port);
>+int vsock_seqpacket_connect(unsigned int cid, unsigned int port);
> int vsock_stream_accept(unsigned int cid, unsigned int port,
> 			struct sockaddr_vm *clientaddrp);
>+int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
>+			   struct sockaddr_vm *clientaddrp);
> void vsock_wait_remote_close(int fd);
> void send_byte(int fd, int expected_ret, int flags);
> void recv_byte(int fd, int expected_ret, int flags);
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 5a4fb80fa832..67766bfe176f 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -14,6 +14,8 @@
> #include <errno.h>
> #include <unistd.h>
> #include <linux/kernel.h>
>+#include <sys/types.h>
>+#include <sys/socket.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -279,6 +281,110 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+#define MESSAGES_CNT 7
>+static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>+{
>+	int fd;
>+
>+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Send several messages, one with MSG_EOR flag */
>+	for (int i = 0; i < MESSAGES_CNT; i++)
>+		send_byte(fd, 1, 0);
>+
>+	control_writeln("SENDDONE");
>+	close(fd);
>+}
>+
>+static void test_seqpacket_msg_bounds_server(const struct test_opts *opts)
>+{
>+	int fd;
>+	char buf[16];
>+	struct msghdr msg = {0};
>+	struct iovec iov = {0};
>+
>+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("SENDDONE");
>+	iov.iov_base = buf;
>+	iov.iov_len = sizeof(buf);
>+	msg.msg_iov = &iov;
>+	msg.msg_iovlen = 1;
>+
>+	for (int i = 0; i < MESSAGES_CNT; i++) {
>+		if (recvmsg(fd, &msg, 0) != 1) {
>+			perror("message bound violated");
>+			exit(EXIT_FAILURE);
>+		}
>+	}
>+
>+	close(fd);
>+}
>+
>+#define MESSAGE_TRUNC_SZ 32
>+static void test_seqpacket_msg_trunc_client(const struct test_opts *opts)
>+{
>+	int fd;
>+	char buf[MESSAGE_TRUNC_SZ];
>+
>+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (send(fd, buf, sizeof(buf), 0) != sizeof(buf)) {
>+		perror("send failed");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("SENDDONE");
>+	close(fd);
>+}
>+
>+static void test_seqpacket_msg_trunc_server(const struct test_opts *opts)
>+{
>+	int fd;
>+	char buf[MESSAGE_TRUNC_SZ / 2];
>+	struct msghdr msg = {0};
>+	struct iovec iov = {0};
>+
>+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("SENDDONE");
>+	iov.iov_base = buf;
>+	iov.iov_len = sizeof(buf);
>+	msg.msg_iov = &iov;
>+	msg.msg_iovlen = 1;
>+
>+	ssize_t ret = recvmsg(fd, &msg, MSG_TRUNC);
>+
>+	if (ret != MESSAGE_TRUNC_SZ) {
>+		printf("%zi\n", ret);
>+		perror("MSG_TRUNC doesn't work");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (!(msg.msg_flags & MSG_TRUNC)) {
>+		fprintf(stderr, "MSG_TRUNC expected\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	close(fd);
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -309,6 +415,16 @@ static struct test_case test_cases[] = {
> 		.run_client = test_stream_msg_peek_client,
> 		.run_server = test_stream_msg_peek_server,
> 	},
>+	{
>+		.name = "SOCK_SEQPACKET msg bounds",
>+		.run_client = test_seqpacket_msg_bounds_client,
>+		.run_server = test_seqpacket_msg_bounds_server,
>+	},
>+	{
>+		.name = "SOCK_SEQPACKET MSG_TRUNC flag",
>+		.run_client = test_seqpacket_msg_trunc_client,
>+		.run_server = test_seqpacket_msg_trunc_server,
>+	},
> 	{},
> };
>
>-- 
>2.25.1
>

