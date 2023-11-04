Return-Path: <kvm+bounces-564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C55E7E0C83
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:04:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC9F61C21148
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B9DC2D8;
	Sat,  4 Nov 2023 00:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gxwbg3Vi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D865C154
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:03:23 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966C91715
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:03:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da13698a6d3so3428860276.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056193; x=1699660993; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QsiXyox+rGQhiB/Za0Yz/FRQCQ9gMcg4U4njvPOlEGQ=;
        b=gxwbg3ViatDEwtW2lzlL+SOzbs6wTJK9rxU2fjCkHCht9udbHlNFTLX1VVcN7QclCd
         /JLEMm9b1P8Gaj/qn1te0rJS6P5qlYYcuHHZqupCbll+BEfYL9NvrgRrwjVUv/grY+NK
         LOSN60MmpPMwTW1SDuuQrqDPzinzOE1WPUYc4PM/BZNIN2737NirQxz0gQkAxJWBPupq
         +aeiQw28PZT74af2K9cjpZ5ybeDfpeKO7o2fVDNHnXjXwUgR37vbDkxq70y66uAuxxPm
         O2Y8BWi+Nubs7EpbmJKOo+2gYr6lyyN4/UcrutBlDXXRw5rvhp+lAAGDymBrv+R8nvXE
         2YJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056193; x=1699660993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QsiXyox+rGQhiB/Za0Yz/FRQCQ9gMcg4U4njvPOlEGQ=;
        b=McCosxxQHxum9dUbwX8AuhAZMOta9OF0w4FLAK51Ckjt4NQ3CLhjN3vrnTjz2PJFF2
         cpxlUZxjfHqUZOPjiiVHNHhZy37l5/KTJ98+VYqy8hegjagOok5SwF2fg1zY7wATAGPL
         +Z6ecygpM5jJoZfilWZT09t/SWeiBqKAVfxv1Y/hFpN1A5IcHEcfJLK6Weuws4L1s9dm
         wTHBN485bDgGeSMPo8uxNUierwcL0F95hCKOlUJWS0Lq79abMH9YXrFPPqbrBrETxhG5
         m827S02vUSzvPiLK6mcDzpdmxs+eNTD4UllACfKwJF+y9m2Rl5aPxFdBB3/VH4kw4mQn
         QBXA==
X-Gm-Message-State: AOJu0YyqkL42ytQVeMYavdkSriwoHeKESsuZ/ORaQdjlN7ozdp24pH6J
	xE1B7ktCQb+d7aosyp+gsELGaTBxVQ0=
X-Google-Smtp-Source: AGHT+IHSCywEgy5CK7hwR38ijK7zsg2pTt3jxhE7nXfuXntDlnEPsZma8p8NOjYWoo2NEydALjtsZ1CzFoY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:84d1:0:b0:da0:cbe9:6bb5 with SMTP id
 x17-20020a2584d1000000b00da0cbe96bb5mr442124ybm.11.1699056193328; Fri, 03 Nov
 2023 17:03:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:35 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-18-seanjc@google.com>
Subject: [PATCH v6 17/20] KVM: selftests: Add helpers to read integer module params
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add helpers to read integer module params, which is painfully non-trivial
because the pain of dealing with strings in C is exacerbated by the kernel
inserting a newline.

Don't bother differentiating between int, uint, short, etc.  They all fit
in an int, and KVM (thankfully) doesn't have any integer params larger
than an int.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 62 +++++++++++++++++--
 2 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a18db6a7b3cf..46b71241216e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -238,6 +238,10 @@ bool get_kvm_param_bool(const char *param);
 bool get_kvm_intel_param_bool(const char *param);
 bool get_kvm_amd_param_bool(const char *param);
 
+int get_kvm_param_integer(const char *param);
+int get_kvm_intel_param_integer(const char *param);
+int get_kvm_amd_param_integer(const char *param);
+
 unsigned int kvm_check_cap(long cap);
 
 static inline bool kvm_has_cap(long cap)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7a8af1821f5d..65101c7d1a1a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -51,13 +51,13 @@ int open_kvm_dev_path_or_exit(void)
 	return _open_kvm_dev_path_or_exit(O_RDONLY);
 }
 
-static bool get_module_param_bool(const char *module_name, const char *param)
+static ssize_t get_module_param(const char *module_name, const char *param,
+				void *buffer, size_t buffer_size)
 {
 	const int path_size = 128;
 	char path[path_size];
-	char value;
-	ssize_t r;
-	int fd;
+	ssize_t bytes_read;
+	int fd, r;
 
 	r = snprintf(path, path_size, "/sys/module/%s/parameters/%s",
 		     module_name, param);
@@ -66,11 +66,46 @@ static bool get_module_param_bool(const char *module_name, const char *param)
 
 	fd = open_path_or_exit(path, O_RDONLY);
 
-	r = read(fd, &value, 1);
-	TEST_ASSERT(r == 1, "read(%s) failed", path);
+	bytes_read = read(fd, buffer, buffer_size);
+	TEST_ASSERT(bytes_read > 0, "read(%s) returned %ld, wanted %ld bytes",
+		    path, bytes_read, buffer_size);
 
 	r = close(fd);
 	TEST_ASSERT(!r, "close(%s) failed", path);
+	return bytes_read;
+}
+
+static int get_module_param_integer(const char *module_name, const char *param)
+{
+	/*
+	 * 16 bytes to hold a 64-bit value (1 byte per char), 1 byte for the
+	 * NUL char, and 1 byte because the kernel sucks and inserts a newline
+	 * at the end.
+	 */
+	char value[16 + 1 + 1];
+	ssize_t r;
+
+	memset(value, '\0', sizeof(value));
+
+	r = get_module_param(module_name, param, value, sizeof(value));
+	TEST_ASSERT(value[r - 1] == '\n',
+		    "Expected trailing newline, got char '%c'", value[r - 1]);
+
+	/*
+	 * Squash the newline, otherwise atoi_paranoid() will complain about
+	 * trailing non-NUL characters in the string.
+	 */
+	value[r - 1] = '\0';
+	return atoi_paranoid(value);
+}
+
+static bool get_module_param_bool(const char *module_name, const char *param)
+{
+	char value;
+	ssize_t r;
+
+	r = get_module_param(module_name, param, &value, sizeof(value));
+	TEST_ASSERT_EQ(r, 1);
 
 	if (value == 'Y')
 		return true;
@@ -95,6 +130,21 @@ bool get_kvm_amd_param_bool(const char *param)
 	return get_module_param_bool("kvm_amd", param);
 }
 
+int get_kvm_param_integer(const char *param)
+{
+	return get_module_param_integer("kvm", param);
+}
+
+int get_kvm_intel_param_integer(const char *param)
+{
+	return get_module_param_integer("kvm_intel", param);
+}
+
+int get_kvm_amd_param_integer(const char *param)
+{
+	return get_module_param_integer("kvm_amd", param);
+}
+
 /*
  * Capability
  *
-- 
2.42.0.869.gea05f2083d-goog


