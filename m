Return-Path: <kvm+bounces-5942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D52F82909C
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:11:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48BECB26270
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D384BA98;
	Tue,  9 Jan 2024 23:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0EtyW66g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EF84B5B9
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5ea6aa02fa4so58960587b3.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841419; x=1705446219; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Xd2xi7qOc7aGWuph6eBSD2zpQtVKqQ03Fccj63JD6OI=;
        b=0EtyW66g7h9wTbLDVFakjezJ1qsmhifwRve6JwP8jY32t43TSefkcmuhs78qygtSn8
         30KH71a5bGShkRKzJRFWJSQkRBcL9Zx9Rr48vh2GUlIxq9dKg2jlIY2qRZHsg1ODyNec
         nvSs3ewHz8T3eFuC3AcBeJgaqVYgFnuNtqcw4ApeWtcOVVS4D/vbu73k3h20amPKLj/o
         dn55nzyBSFtNb+/iXRibbva0nrEbingm/q1ibXsfvCwL0d6AbyxVypSi4VYt83NXsPVF
         rghiyEgYXz4vJaV8l6s9ttdjB5DBC0JEP8syCqd6+l83eltUEi42c9hzkYcJTrrYnlWh
         48Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841419; x=1705446219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xd2xi7qOc7aGWuph6eBSD2zpQtVKqQ03Fccj63JD6OI=;
        b=Jbo3z8maLMtWZQF1WVsdg89Zr+BiPLXIrLTBb3M4V+mElNQGq7yoCg/E69fgg+oclA
         gwSn9tsjFkztArBcEDNyYAbcCjluwumZbJx3gOM7wQtzatIFEuyg7R7pSkFk9Eegn2Vx
         kTdkie2bFdtn+ERwV0D7CcWZ2FXepwiPu57tC2UHdHe8Q81t1hJVrwSCWTlakWbLEX9M
         krJ6dpnYKwqkmE0l8X1vx69eYqncZpwFcH/NeM5et8HAeAW+omhrmczAYUa3SDb21Co4
         plJfoAXPQK5mPGA0fWoCd3gmjqQxLNt4IcKV3dCotZVveITBf7twrVx8JzXmplc6REeA
         H2Rw==
X-Gm-Message-State: AOJu0Yz1ybfXX+88ENYFQTrpKMgj+lsfOJZiNADS3EuTCEKqmYi7GMl4
	EwUj8G5AJDokOOwhCGMBFqBkxj9I3F8j2+wJ5g==
X-Google-Smtp-Source: AGHT+IFb7hq34ZiLwcnqvvhqVazGOzeft5UTdfQzhTKUjv6qFO4HcNCyzgsQQTKpk+B3S5Qp43JxcGyWAlg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8251:0:b0:dbd:b056:b468 with SMTP id
 d17-20020a258251000000b00dbdb056b468mr32904ybn.7.1704841418864; Tue, 09 Jan
 2024 15:03:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:43 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-24-seanjc@google.com>
Subject: [PATCH v10 23/29] KVM: selftests: Add helpers to read integer module params
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
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
index 9e5afc472c14..070f250036fc 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -259,6 +259,10 @@ bool get_kvm_param_bool(const char *param);
 bool get_kvm_intel_param_bool(const char *param);
 bool get_kvm_amd_param_bool(const char *param);
 
+int get_kvm_param_integer(const char *param);
+int get_kvm_intel_param_integer(const char *param);
+int get_kvm_amd_param_integer(const char *param);
+
 unsigned int kvm_check_cap(long cap);
 
 static inline bool kvm_has_cap(long cap)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e066d584c656..9bafe44cb978 100644
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
2.43.0.472.g3155946c3a-goog


