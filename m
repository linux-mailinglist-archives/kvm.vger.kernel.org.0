Return-Path: <kvm+bounces-29603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A60619ADF29
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 10:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D56631C215DD
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 08:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0807B1B0F17;
	Thu, 24 Oct 2024 08:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wrG+2ELj"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A9418A6D9
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 08:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729758679; cv=none; b=cpjEC2Y1CqOuAApCHUWuuN+QpgegSMwGkqfLziIH6e17a7xUXGlCCuYcfAnjcOtAJhqUVtYSccUKp1p+KaU+XmGxhgYaE3kTMUBOrH9nNXXIGIQGNSLcLRvvz0eC+isoiF/ww9Df/AJkkRYkiOeyF3hoS4IRVQec3+2M/P9/RvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729758679; c=relaxed/simple;
	bh=SLxGWY68OHG0AINM51aVgPJt6dLPEQxTn05PoCqvbZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDo6Y/16dQf9GWXM98YStrnrUZ3l99XyQWoLtf+YaWZ17K64iSC7zobUAh688RHur2zJqvBqZpnbPNg8cmOYa2ucmE8htKbB4OrWUPxCdm2oIxJCRBhNkbwHAGM+0efxQkbGTvzD+Nja8q3wxWBwdCY/xfLLTy+dShXd+Pk7j6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wrG+2ELj; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729758670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjte7RtBn7FVljJYgwwoEgon3WN/ThmaGIVx5uuDnBE=;
	b=wrG+2ELjwwKYlj5fGMNSv9CBTqaOi9XQzss1ya4zurKvYKLDA2w9eohtYAl3zdcuVWEf5T
	WKQ/3Se94bzzj1HQfYBSR9fzytsJI+Q0Z9FQqiEWJ9SIObLRTWvzn7c5mJG6e9ePIfN16q
	Jtx1Vi46vDooxQYyCO3mReKR8Ws5UoU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: rananta@google.com,
	pbonzini@redhat.com,
	thuth@redhat.com,
	subhasish.ghosh@arm.com,
	joey.gouly@arm.com,
	oliver.upton@linux.dev,
	maz@kernel.org
Subject: [kvm-unit-tests PATCH 5/4] arm64: gitlab-ci: Add clang build tests
Date: Thu, 24 Oct 2024 10:31:05 +0200
Message-ID: <20241024083104.44236-2-andrew.jones@linux.dev>
In-Reply-To: <20241023152638.3317648-1-rananta@google.com>
References: <20241023152638.3317648-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Test building aarch64 with clang both with and without --enable-efi.
Use in-tree building for one and out-of-tree building for the other
to get more coverage there too.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 .gitlab-ci.yml | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index b7ad99870e5a..aa69ca594ba3 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -80,6 +80,52 @@ build-aarch64-efi-acpi:
       | tee results.txt
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
+build-aarch64-clang:
+ extends: .outoftree_template
+ script:
+ - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu clang
+ - mkdir build
+ - cd build
+ - ../configure --arch=arm64 --cc=clang --cflags='--target=aarch64' --cross-prefix=aarch64-linux-gnu-
+ - make -j2
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
+      cache
+      debug-bp
+      debug-sstep
+      debug-wp
+      gicv2-active
+      gicv2-ipi
+      gicv2-mmio
+      gicv3-active
+      gicv3-ipi
+      its-introspection
+      its-trigger
+      pci-test
+      pmu-cycle-counter
+      pmu-event-counter-config
+      pmu-sw-incr
+      selftest-setup
+      selftest-smp
+      selftest-vectors-kernel
+      selftest-vectors-user
+      timer
+      | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
+build-aarch64-clang-efi:
+ extends: .intree_template
+ script:
+ - dnf install -y edk2-aarch64 qemu-system-aarch64 gcc-aarch64-linux-gnu clang
+ - ./configure --arch=arm64 --cc=clang --cflags='--target=aarch64' --cross-prefix=aarch64-linux-gnu- --enable-efi --enable-efi-direct
+ - make -j2
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
+      selftest-setup
+      selftest-smp
+      selftest-vectors-kernel
+      selftest-vectors-user
+      | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
 build-arm:
  extends: .outoftree_template
  script:
-- 
2.47.0


