Return-Path: <kvm+bounces-1381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B71967E7358
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D97C01C20C89
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E4503A280;
	Thu,  9 Nov 2023 21:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xGm3433i"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F317F3984F
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:03:57 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EA14C03
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:03:57 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7d261a84bso18621747b3.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563836; x=1700168636; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+gpIf+3+94gtvFVbnfXs0lHfYeXyNXAQWYAzs/xCr+4=;
        b=xGm3433iBc4/SCUy+u4pPm3tDLHqgsxejx2eWzQRN0+A7D+bfyGoh5SeSeNYiSR9gJ
         UHceAMMplmT0qFXTY9bNALKeoyeDVL1jHI9NPfAjQMMGgLjmnJ6AEqX6mrKI2cJTpRn/
         ZGGqPKcqNhYWbrsgyJMej2zkWAvyWLcFuVbUOhwhgNdC87z7TSN6RfSBLb3KalDWNEi1
         OSz7OCoyv46s8FVQh+KeXbP7JX8qxH22TehPCYWBn13xFxIXJSG3UU9o7GvJjfHo0RGS
         pEE8kaJUHD8idGCGPpa+xUiHkvvCufpKPYzg4JqVT+T/9byQt/4KNfggZ1Kib6rV/PW3
         vM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563836; x=1700168636;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+gpIf+3+94gtvFVbnfXs0lHfYeXyNXAQWYAzs/xCr+4=;
        b=GuG+czQx2Hq5DTLOf1y4r/koINshXgPxIO1oCumZl0IXHbE8mqTzj3SIRyg2rFF3kT
         /1qn7tqMFpYLfiVN35OjvMe5kWJvLEEXxvCujheY3ZDWLG8Zo+UVDCH69sFSUeObe+sS
         8itS/pBIp3BxMjVqo5CaZ8u1/cmG/nUeV0kXlWvgdqs3JD2c/ppZGWc+vxwNiIoTUVeQ
         VzRDsfS1XpucTpl1Cp0uGWECSg7oVl/obm5rCZ1ksuqCdknS+ghhqmfgbzzvMNuru+l1
         J8RGvtJo+d3Lw4DxPMn5ytRIRBq9eXdte9UXAjM6je2sj9uWGJBAhFnRG38rgK90y01U
         KZ/Q==
X-Gm-Message-State: AOJu0Yz/oulII7jaSMcacI7NIPPpUEpMb4GTxamMR3r0SFFQH8pVJqd8
	+HG8X8vCNOBQf4cbly5TUwkLjKr764+1hA==
X-Google-Smtp-Source: AGHT+IGot9REZNapp+cyRtlZcvZmtFQgUqJxuXKpOVq+Yvxt4bIIfoZ74Q/Nsan6zjTjWuZjAV1phgrvl0wnbA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:8343:0:b0:59f:77f6:6d12 with SMTP id
 t64-20020a818343000000b0059f77f66d12mr168413ywf.0.1699563836347; Thu, 09 Nov
 2023 13:03:56 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:23 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-13-amoorthy@google.com>
Subject: [PATCH v6 12/14] KVM: selftests: Use EPOLL in userfaultfd_util reader
 threads and signal errors via TEST_ASSERT
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

With multiple reader threads POLLing a single UFFD, the test suffers
from the thundering herd problem: performance degrades as the number of
reader threads is increased. Solve this issue [1] by switching the
the polling mechanism to EPOLL + EPOLLEXCLUSIVE.

Also, change the error-handling convention of uffd_handler_thread_fn.
Instead of just printing errors and returning early from the polling
loop, check for them via TEST_ASSERT. "return NULL" is reserved for a
successful exit from uffd_handler_thread_fn, ie one triggered by a
write to the exit pipe.

Performance samples generated by the command in [2] are given below.

Num Reader Threads, Paging Rate (POLL), Paging Rate (EPOLL)
1      249k      185k
2      201k      235k
4      186k      155k
16     150k      217k
32     89k       198k

[1] Single-vCPU performance does suffer somewhat.
[2] ./demand_paging_test -u MINOR -s shmem -v 4 -o -r <num readers>

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Acked-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/demand_paging_test.c        |  1 -
 .../selftests/kvm/lib/userfaultfd_util.c      | 74 +++++++++----------
 2 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index f7897a951f90..0455347f932a 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -13,7 +13,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
-#include <poll.h>
 #include <pthread.h>
 #include <linux/userfaultfd.h>
 #include <sys/syscall.h>
diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
index 6f220aa4fb08..2a179133645a 100644
--- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -16,6 +16,7 @@
 #include <poll.h>
 #include <pthread.h>
 #include <linux/userfaultfd.h>
+#include <sys/epoll.h>
 #include <sys/syscall.h>
 
 #include "kvm_util.h"
@@ -32,60 +33,55 @@ static void *uffd_handler_thread_fn(void *arg)
 	int64_t pages = 0;
 	struct timespec start;
 	struct timespec ts_diff;
+	int epollfd;
+	struct epoll_event evt;
+
+	epollfd = epoll_create(1);
+	TEST_ASSERT(epollfd >= 0, "Failed to create epollfd.");
+
+	evt.events = EPOLLIN | EPOLLEXCLUSIVE;
+	evt.data.u32 = 0;
+	TEST_ASSERT(epoll_ctl(epollfd, EPOLL_CTL_ADD, uffd, &evt) == 0,
+		    "Failed to add uffd to epollfd");
+
+	evt.events = EPOLLIN;
+	evt.data.u32 = 1;
+	TEST_ASSERT(epoll_ctl(epollfd, EPOLL_CTL_ADD, reader_args->pipe, &evt) == 0,
+		    "Failed to add pipe to epollfd");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	while (1) {
 		struct uffd_msg msg;
-		struct pollfd pollfd[2];
-		char tmp_chr;
 		int r;
 
-		pollfd[0].fd = uffd;
-		pollfd[0].events = POLLIN;
-		pollfd[1].fd = reader_args->pipe;
-		pollfd[1].events = POLLIN;
-
-		r = poll(pollfd, 2, -1);
-		switch (r) {
-		case -1:
-			pr_info("poll err");
-			continue;
-		case 0:
-			continue;
-		case 1:
-			break;
-		default:
-			pr_info("Polling uffd returned %d", r);
-			return NULL;
-		}
+		r = epoll_wait(epollfd, &evt, 1, -1);
+		TEST_ASSERT(r == 1,
+			    "Unexpected number of events (%d) from epoll, errno = %d",
+			    r, errno);
 
-		if (pollfd[0].revents & POLLERR) {
-			pr_info("uffd revents has POLLERR");
-			return NULL;
-		}
+		if (evt.data.u32 == 1) {
+			char tmp_chr;
 
-		if (pollfd[1].revents & POLLIN) {
-			r = read(pollfd[1].fd, &tmp_chr, 1);
+			TEST_ASSERT(!(evt.events & (EPOLLERR | EPOLLHUP)),
+				    "Reader thread received EPOLLERR or EPOLLHUP on pipe.");
+			r = read(reader_args->pipe, &tmp_chr, 1);
 			TEST_ASSERT(r == 1,
-				    "Error reading pipefd in UFFD thread\n");
+				    "Error reading pipefd in uffd reader thread");
 			break;
 		}
 
-		if (!(pollfd[0].revents & POLLIN))
-			continue;
+		TEST_ASSERT(!(evt.events & (EPOLLERR | EPOLLHUP)),
+			    "Reader thread received EPOLLERR or EPOLLHUP on uffd.");
 
 		r = read(uffd, &msg, sizeof(msg));
 		if (r == -1) {
-			if (errno == EAGAIN)
-				continue;
-			pr_info("Read of uffd got errno %d\n", errno);
-			return NULL;
+			TEST_ASSERT(errno == EAGAIN,
+				    "Error reading from UFFD: errno = %d", errno);
+			continue;
 		}
 
-		if (r != sizeof(msg)) {
-			pr_info("Read on uffd returned unexpected size: %d bytes", r);
-			return NULL;
-		}
+		TEST_ASSERT(r == sizeof(msg),
+			    "Read on uffd returned unexpected number of bytes (%d)", r);
 
 		if (!(msg.event & UFFD_EVENT_PAGEFAULT))
 			continue;
@@ -93,8 +89,8 @@ static void *uffd_handler_thread_fn(void *arg)
 		if (reader_args->delay)
 			usleep(reader_args->delay);
 		r = reader_args->handler(reader_args->uffd_mode, uffd, &msg);
-		if (r < 0)
-			return NULL;
+		TEST_ASSERT(r >= 0,
+			    "Reader thread handler fn returned negative value %d", r);
 		pages++;
 	}
 
-- 
2.42.0.869.gea05f2083d-goog


