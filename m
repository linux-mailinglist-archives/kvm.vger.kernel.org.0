Return-Path: <kvm+bounces-23639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE28994C1AB
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 846E0288860
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3352D190497;
	Thu,  8 Aug 2024 15:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DhOdt5pn"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E70619004D
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 15:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723131765; cv=none; b=dMRk7EqknIPt+aTRgvzLxZ6wV09ImPLyhZknlVijatRE3iTWd3g5VYaTVoXepFh/cpBwh56QM41Cg+PJXWk6XO99WDrerkIJdc3ofts6IVuXoNUQiUZuXMsau1DoT1iMw/QxM7016p6GUTDGKKgvG8sx64qVf7dSClbwBHoMkQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723131765; c=relaxed/simple;
	bh=jsi+iMy1Wh7imB5R35XeD76Eyu76Vvq0ojuhydvg2hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejHBk7+pEl2mEQuSFr2BbE7p2ORZZCfYFsEyrcsxa9d2N3LEIEOuLIDBhdjpocIk8xmiXI3ZDwjN/GbcYCUWT8DwRVpydfk/rDObeR4z9+n0Mlvcy16gWw8XeIrPT/RKGAi/2Zc/MV8GulPl26FG+ef0hoJ/QCisyYE0Yi6TshM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DhOdt5pn; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723131761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZOJpg8s6ygbLQkQYpNC1VIrC+vX7StgdkAjnRcG8SnM=;
	b=DhOdt5pnL96SYHY2G5OucIgq1eOLgMpIPLbVf/LWFFY/v+nsd7vGjOMRdAp7kH2XrxNYa4
	ZXKrickiBSvYT8P1qOVaenZuJV5wFUcwXgd4pxoKhOgYzm818t43+dvLm1HDtqRjA18aag
	To8xV3mGFexUaHIWOeezJZbS/zYsc/0=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 4/4] riscv: Extend gitlab CI
Date: Thu,  8 Aug 2024 17:42:28 +0200
Message-ID: <20240808154223.79686-10-andrew.jones@linux.dev>
In-Reply-To: <20240808154223.79686-6-andrew.jones@linux.dev>
References: <20240808154223.79686-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fedora's riscv64 gcc supports ilp32 so enable 32-bit RISCV testing.
And use the out-of-tree template for the 32-bit build to get that
covered too. Also add EFI build testing and, since Fedora has been
updated which brings in a later QEMU, we can now use the 'max' cpu
type.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 .gitlab-ci.yml | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index e0eb85a94910..180ef6e78558 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -133,18 +133,44 @@ build-ppc64le:
       | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
-# build-riscv32:
-# Fedora doesn't package a riscv32 compiler for QEMU. Oh, well.
+build-riscv32:
+ extends: .outoftree_template
+ script:
+ - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu
+ - mkdir build
+ - cd build
+ - ../configure --arch=riscv32 --cross-prefix=riscv64-linux-gnu-
+ - make -j2
+ - printf "FOO=foo\nBAR=bar\nBAZ=baz\nMVENDORID=0\nMARCHID=0\nMIMPID=0\n" >test-env
+ - ACCEL=tcg KVM_UNIT_TESTS_ENV=test-env ./run_tests.sh
+      selftest
+      sbi
+      | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
-# Select 'rv64' with PROCESSOR_OVERRIDE in case QEMU is too old to have 'max'
 build-riscv64:
  extends: .intree_template
  script:
  - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu
  - ./configure --arch=riscv64 --cross-prefix=riscv64-linux-gnu-
  - make -j2
- - printf "FOO=foo\nBAR=bar\nBAZ=baz\nMVENDORID=0\n" >test-env
- - PROCESSOR_OVERRIDE=rv64 ACCEL=tcg KVM_UNIT_TESTS_ENV=test-env ./run_tests.sh
+ - printf "FOO=foo\nBAR=bar\nBAZ=baz\nMVENDORID=0\nMARCHID=0\nMIMPID=0\n" >test-env
+ - ACCEL=tcg KVM_UNIT_TESTS_ENV=test-env ./run_tests.sh
+      selftest
+      sbi
+      | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
+build-riscv64-efi:
+ extends: .intree_template
+ script:
+ - dnf install -y edk2-riscv64 qemu-system-riscv gcc-riscv64-linux-gnu
+ - cp /usr/share/edk2/riscv/RISCV_VIRT_CODE.fd .
+ - truncate -s 32M RISCV_VIRT_CODE.fd
+ - ./configure --arch=riscv64 --cross-prefix=riscv64-linux-gnu- --enable-efi
+ - make -j2
+ - printf "FOO=foo\nBAR=bar\nBAZ=baz\nMVENDORID=0\nMARCHID=0\nMIMPID=0\n" >test-env
+ - ACCEL=tcg KVM_UNIT_TESTS_ENV=test-env ./run_tests.sh
       selftest
       sbi
       | tee results.txt
-- 
2.45.2


