Return-Path: <kvm+bounces-10133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F4B986A05C
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:40:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22B48B32884
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E5514CAC8;
	Tue, 27 Feb 2024 19:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F43c8lAb"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBCF14C5A4
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061752; cv=none; b=EtfMB3qdWD4XvJkISXzQFKkxu8pMdzePLTX4+R8pW38HjPSKFB33IQmp1bMOQLN1RHrOslJXbAoPSJtZa36PBagQmihREsrmRnP+nKfNKoxkNcGAuUKwE5XT7smZ75zQ2ADSLXgN/364FGJ8X0poA8kflnDsreZAK499tDElrNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061752; c=relaxed/simple;
	bh=rKneMKwXwUgk1Mn1AIOl3+psPJPKzWKDROU/ARqeloE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=t7U3OjSegdAYgUgKGG9I6sgE5ppOurgTGJMKjGRkIFkWDKO1pI7r7P6aMFiVhdbweM6wgnmhHt19pdbUQ4StizRFZjD3Bfjy+8RPjXeWHTAYWFm3p+h7/QxNHF9X1dk2sk2lbT5uv2PMUqh65hBDs4wYKJ8A7d+CwdSbNsXxv4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F43c8lAb; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gXnFBLWmHRwxeKkAlTPnozCwE2flSxAbIMfA6Fsg1qM=;
	b=F43c8lAbSDPQTd1AS/sc7YsIV+k9uh1UVHknp2HBMGUiuRwI05SNg1b3Ha/G/3aL0++KBI
	/KkqcLI0s/HxG3fTdiB6dINx9FWJ3sV8FHGvcR7OaQSgGVTONgxc6MoxlGuuFDobqHGZ4e
	wB8FQOznpc+2DOGalTJiuekIBzfi92E=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 18/18] arm64: efi: Add gitlab CI
Date: Tue, 27 Feb 2024 20:21:28 +0100
Message-ID: <20240227192109.487402-38-andrew.jones@linux.dev>
In-Reply-To: <20240227192109.487402-20-andrew.jones@linux.dev>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Now that we have efi-direct and tests run much faster, add a few
(just selftests) to the CI. Test with both DT and ACPI. While
touching the file update arm and arm64's pass/fail criteria to
the new style that ensures they're not all skips.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 .gitlab-ci.yml | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 71d986e9884e..ff34b1f5062e 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -44,7 +44,35 @@ build-aarch64:
       selftest-vectors-user
       timer
       | tee results.txt
- - if grep -q FAIL results.txt ; then exit 1 ; fi
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
+build-aarch64-efi:
+ extends: .intree_template
+ script:
+ - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu edk2-aarch64
+ - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu- --enable-efi --enable-efi-direct
+ - make -j2
+ - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
+      selftest-setup
+      selftest-smp
+      selftest-vectors-kernel
+      selftest-vectors-user
+      | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
+build-aarch64-efi-acpi:
+ extends: .intree_template
+ script:
+ - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu edk2-aarch64
+ - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu- --enable-efi --enable-efi-direct
+ - make -j2
+ - EFI_USE_ACPI=y ACCEL=tcg MAX_SMP=8 ./run_tests.sh
+      selftest-setup
+      selftest-smp
+      selftest-vectors-kernel
+      selftest-vectors-user
+      | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
 build-arm:
  extends: .outoftree_template
@@ -59,7 +87,7 @@ build-arm:
      pci-test pmu-cycle-counter gicv2-ipi gicv2-mmio gicv3-ipi gicv2-active
      gicv3-active
      | tee results.txt
- - if grep -q FAIL results.txt ; then exit 1 ; fi
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
 build-ppc64be:
  extends: .outoftree_template
-- 
2.43.0


