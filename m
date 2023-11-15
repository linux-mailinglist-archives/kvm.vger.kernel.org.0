Return-Path: <kvm+bounces-1821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A47B7EC122
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 12:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F6E0281252
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 11:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C4D171A3;
	Wed, 15 Nov 2023 11:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hBk0q8WC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E512D154B7
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 11:11:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CF5E6
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 03:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700046671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P+9IBIN2TseVRMl8fITJ/N2WS2NwQD1vqkbQglXI4X4=;
	b=hBk0q8WC1EsTqTSJOHK8rNcLHuiY9Lmh4sLgdMJlQ3vDWRbuyb/M8tyPigUDAps8EAS1og
	fLCEBBYsuRHXcNAiO7kyvSM7w++lchlxzxpBH5auqArM+aUq9Oy9TR5VeQFCNFS8ZOKeL2
	hkvHTjMrZQ3ZpykJ9mMHMLM+FXzfARc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-Tal2SVJ4MBioVQ8HGsNvLw-1; Wed, 15 Nov 2023 06:11:10 -0500
X-MC-Unique: Tal2SVJ4MBioVQ8HGsNvLw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9dfbccc2a8cso460845466b.1
        for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 03:11:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700046669; x=1700651469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P+9IBIN2TseVRMl8fITJ/N2WS2NwQD1vqkbQglXI4X4=;
        b=VVboaWFNgYnmiqECZCtAxf/WacSJ/KPgmh0TZzHbIJ/HfeKOJWQ3lMTR88mPzVHq0i
         IouASvuLDMv6DVvZcTLBooOuaT/aY24uTuM2BF/52lFaKk9GANHi85MXBBPnXqznNKdE
         Hop7837ZV7v5fU6Vbo/o2tkrNFIxGytAPiQdlgu4MAL1KP2a0v0gk0h9YLX1dxWsvJ3r
         PZtHV7k4Tv+FYglU3oUxFs0taqc0YGkcQTN3ocXo3QDBTKoSqw3Xghx0c0fkSez7xS3m
         1Ol+CJDV3pNv+ahsm2fYh8OXKKXE1PKsWqydmEE/95YYbp0PW4pFF9nbdbsoMdQwwBh4
         UJvw==
X-Gm-Message-State: AOJu0YzF2bPKqCNPNXu4/umCvyToVGeIuSL10JBTvyWgFr7kT6FbnXxc
	rSKrP4riMZGcdlHX3S6oaBClviK9XbE5KccZDzWCj42yujjAOoTbZEePEC5j4k7TH1dSc/L/IFi
	kp1bkiF339wyy
X-Received: by 2002:a17:906:d292:b0:9dd:f5ba:856d with SMTP id ay18-20020a170906d29200b009ddf5ba856dmr10523734ejb.62.1700046669457;
        Wed, 15 Nov 2023 03:11:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEicy/bLc4oN1a42wj/6SobC5kFcPGCJNdEL99xoe8FtbG79XQBALGZSqlBlQSbj2/E80ogpw==
X-Received: by 2002:a17:906:d292:b0:9dd:f5ba:856d with SMTP id ay18-20020a170906d29200b009ddf5ba856dmr10523724ejb.62.1700046669162;
        Wed, 15 Nov 2023 03:11:09 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-199.retail.telecomitalia.it. [79.46.200.199])
        by smtp.gmail.com with ESMTPSA id e10-20020a170906080a00b009a193a5acffsm6916813ejd.121.2023.11.15.03.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 03:11:08 -0800 (PST)
Date: Wed, 15 Nov 2023 12:11:02 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 2/2] vsock/test: SO_RCVLOWAT + deferred credit
 update test
Message-ID: <zukasb6k7ogta33c2wik6cgadg2rkacestat7pkexd45u53swh@ovso3hafta77>
References: <20231108072004.1045669-1-avkrasnov@salutedevices.com>
 <20231108072004.1045669-3-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231108072004.1045669-3-avkrasnov@salutedevices.com>

On Wed, Nov 08, 2023 at 10:20:04AM +0300, Arseniy Krasnov wrote:
>This adds test which checks, that updating SO_RCVLOWAT value also sends

You can avoid "This adds", and write just "Add test ...".

See https://docs.kernel.org/process/submitting-patches.html#describe-your-changes

     Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
     instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
     to do frotz", as if you are giving orders to the codebase to change
     its behaviour.

Also in the other patch.

>credit update message. Otherwise mutual hungup may happen when receiver
>didn't send credit update and then calls 'poll()' with non default
>SO_RCVLOWAT value (e.g. waiting enough bytes to read), while sender
>waits for free space at receiver's side.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> tools/testing/vsock/vsock_test.c | 131 +++++++++++++++++++++++++++++++
> 1 file changed, 131 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index c1f7bc9abd22..c71b3875fd16 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -1180,6 +1180,132 @@ static void test_stream_shutrd_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+#define RCVLOWAT_CREDIT_UPD_BUF_SIZE	(1024 * 128)
>+#define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE	(1024 * 64)

What about adding a comment like the one in the cover letter about
dependency with kernel values?

Please add it also in the commit description.

I'm thinking if we should move all the defines that depends on the
kernel in some special header.

>+
>+static void test_stream_rcvlowat_def_cred_upd_client(const struct test_opts *opts)
>+{
>+	size_t buf_size;
>+	void *buf;
>+	int fd;
>+
>+	fd = vsock_stream_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Send 1 byte more than peer's buffer size. */
>+	buf_size = RCVLOWAT_CREDIT_UPD_BUF_SIZE + 1;
>+
>+	buf = malloc(buf_size);
>+	if (!buf) {
>+		perror("malloc");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Wait until peer sets needed buffer size. */
>+	control_expectln("SRVREADY");
>+
>+	if (send(fd, buf, buf_size, 0) != buf_size) {
>+		perror("send failed");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	free(buf);
>+	close(fd);
>+}
>+
>+static void test_stream_rcvlowat_def_cred_upd_server(const struct test_opts *opts)
>+{
>+	size_t recv_buf_size;
>+	struct pollfd fds;
>+	size_t buf_size;
>+	void *buf;
>+	int fd;
>+
>+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	buf_size = RCVLOWAT_CREDIT_UPD_BUF_SIZE;
>+
>+	if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>+		       &buf_size, sizeof(buf_size))) {
>+		perror("setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	buf = malloc(buf_size);
>+	if (!buf) {
>+		perror("malloc");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("SRVREADY");
>+
>+	/* Wait until there will be 128KB of data in rx queue. */
>+	while (1) {
>+		ssize_t res;
>+
>+		res = recv(fd, buf, buf_size, MSG_PEEK);
>+		if (res == buf_size)
>+			break;
>+
>+		if (res <= 0) {
>+			fprintf(stderr, "unexpected 'recv()' return: %zi\n", res);
>+			exit(EXIT_FAILURE);
>+		}
>+	}
>+
>+	/* There is 128KB of data in the socket's rx queue,
>+	 * dequeue first 64KB, credit update is not sent.
>+	 */
>+	recv_buf_size = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>+	recv_buf(fd, buf, recv_buf_size, 0, recv_buf_size);
>+	recv_buf_size++;
>+
>+	/* Updating SO_RCVLOWAT will send credit update. */
>+	if (setsockopt(fd, SOL_SOCKET, SO_RCVLOWAT,
>+		       &recv_buf_size, sizeof(recv_buf_size))) {
>+		perror("setsockopt(SO_RCVLOWAT)");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	memset(&fds, 0, sizeof(fds));
>+	fds.fd = fd;
>+	fds.events = POLLIN | POLLRDNORM | POLLERR |
>+		     POLLRDHUP | POLLHUP;
>+
>+	/* This 'poll()' will return once we receive last byte
>+	 * sent by client.
>+	 */
>+	if (poll(&fds, 1, -1) < 0) {
>+		perror("poll");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (fds.revents & POLLERR) {
>+		fprintf(stderr, "'poll()' error\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (fds.revents & (POLLIN | POLLRDNORM)) {
>+		recv_buf(fd, buf, recv_buf_size, 0, recv_buf_size);
>+	} else {
>+		/* These flags must be set, as there is at
>+		 * least 64KB of data ready to read.
>+		 */
>+		fprintf(stderr, "POLLIN | POLLRDNORM expected\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	free(buf);
>+	close(fd);
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -1285,6 +1411,11 @@ static struct test_case test_cases[] = {
> 		.run_client = test_stream_msgzcopy_empty_errq_client,
> 		.run_server = test_stream_msgzcopy_empty_errq_server,
> 	},
>+	{
>+		.name = "SOCK_STREAM virtio SO_RCVLOWAT + deferred cred update",
>+		.run_client = test_stream_rcvlowat_def_cred_upd_client,
>+		.run_server = test_stream_rcvlowat_def_cred_upd_server,
>+	},
> 	{},
> };
>
>-- 
>2.25.1
>


