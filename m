Return-Path: <kvm+bounces-517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4033D7E07D5
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 18:56:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E0AD1C21112
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 17:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04331224FC;
	Fri,  3 Nov 2023 17:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MCSzD4TB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B54421357;
	Fri,  3 Nov 2023 17:55:58 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF329136;
	Fri,  3 Nov 2023 10:55:57 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9d2e6c8b542so346259066b.0;
        Fri, 03 Nov 2023 10:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699034156; x=1699638956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10jqauWlqfvt/HR75hSWRIhJKNXu3uAakFmXumXKAxc=;
        b=MCSzD4TB7ZsG9U+wuhnzDVnohFihfVoB1INN+AAc3i6MoHdgWKIRtVVlMG+W0OVvUl
         6CsyQZq5+inijcJvpDPyZBHW5Advns2hBw1baEF65eCNKM+Kgf1eOAou/4QfRY6gIO3A
         qZUan5fvsV69t3vj1san7KMv52nxewjtpulOxA2yo7Xj8To147rhyARoH4AVsum1KQoy
         qlNh6XKUzBxYQApB+5QPeS8xIEqBacS70ZnM+2z+6cQZBB9cw4AN8PlK31XTyCRED/U5
         tFecs4SQbu7CBJJZ75rW8ukaWjBeyBDbO1IrVb1WpYSwuf69T1vmq+25E+8lQfTqpqqs
         gqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699034156; x=1699638956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=10jqauWlqfvt/HR75hSWRIhJKNXu3uAakFmXumXKAxc=;
        b=Km4dOqGzzgpL4oHf7mhi4HNwhuaqJIf4Mkb9MDpgxJviZERjS7JHG0JkZ0zg8N25XD
         vzvfl4CmilzBO8xlisF/Q6+WLiVFVyz0eyyBGo94P1VsMNOVT+a9fmcb7SNmsbQcC8Ou
         GXVJwkpeGUbBanex2WkziYte3/n/8yhcJLu6z31zWHEQ/zC9QW18n/ueFwkvscqXz70P
         kX4yRScCMYmPaGI4d2+8BvfNEsda0AwG0aVekOUXh1E2RffFB9O8tGSuhw/3pOEHqInK
         TiXExxKEHpgohHa30fdQ9uZzP8u3xeDISB0b1E6zxzFr1bib31WOj4mY/KVzbH1Y8vNZ
         1srQ==
X-Gm-Message-State: AOJu0Yy/ECOrvi4SYWQs0vUDXHCHTV8sKqGATbBsPn27CGJBlOs8JHNj
	0CBmY/qtTf6Zc8ufPv6TBPw=
X-Google-Smtp-Source: AGHT+IG72hMdXwEyKY8sI7nP1i81XqfpbLd/QUN0kt/ZLHlnFBIb2P77LqijxxqZe/1/2hhQ60F2DA==
X-Received: by 2002:a17:907:74b:b0:9ae:65a5:b6fa with SMTP id xc11-20020a170907074b00b009ae65a5b6famr7085261ejb.32.1699034155977;
        Fri, 03 Nov 2023 10:55:55 -0700 (PDT)
Received: from fedora.. (host-62-211-113-16.retail.telecomitalia.it. [62.211.113.16])
        by smtp.gmail.com with ESMTPSA id wj6-20020a170907050600b009ddf1a84379sm80306ejb.51.2023.11.03.10.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Nov 2023 10:55:55 -0700 (PDT)
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
Subject: [PATCH net 2/4] test/vsock fix: add missing check on socket creation
Date: Fri,  3 Nov 2023 18:55:49 +0100
Message-ID: <20231103175551.41025-3-f.storniolo95@gmail.com>
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

Add check on socket() return value in vsock_listen()
and vsock_connect()

Co-developed-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Filippo Storniolo <f.storniolo95@gmail.com>
---
 tools/testing/vsock/util.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 92336721321a..698b0b44a2ee 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -104,6 +104,10 @@ static int vsock_connect(unsigned int cid, unsigned int port, int type)
 	control_expectln("LISTENING");
 
 	fd = socket(AF_VSOCK, type, 0);
+	if (fd < 0) {
+		perror("socket");
+		exit(EXIT_FAILURE);
+	}
 
 	timeout_begin(TIMEOUT);
 	do {
@@ -158,6 +162,10 @@ static int vsock_accept(unsigned int cid, unsigned int port,
 	int old_errno;
 
 	fd = socket(AF_VSOCK, type, 0);
+	if (fd < 0) {
+		perror("socket");
+		exit(EXIT_FAILURE);
+	}
 
 	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
 		perror("bind");
-- 
2.41.0


