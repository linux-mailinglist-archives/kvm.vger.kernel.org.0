Return-Path: <kvm+bounces-23625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71ADE94BE1F
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24802289337
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 13:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D7218CC10;
	Thu,  8 Aug 2024 13:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LvV4IiDy"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CD9EEA9
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 13:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723122172; cv=none; b=lcJ68MVDc1Dd9Np2X9sb+Axdu8R4bImfweDU5LWELhrIaD1D1sLC1FToZ2OMkOL3vUyk0U509CiS2Qo62gJkMNcHqOmt47pk0mXRtZimgZxH4Ci77bbEyD+vleyk7Oabj3YrykincT5dvKKQEm1N2bqafOZqAocdrN790bkKLWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723122172; c=relaxed/simple;
	bh=ns01SJLnHrxjWzd1fo9WyCo3K/MLEdtkRAmZR+YmjKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8E0GsjZLcEYdJk7+pgwj7giz+8vyePV07SsBfVkg/KwXNqU5HDMKCYcmTnhZ0m++CRDZerhTkf3p6E6evfvq2AdWW+Ay7bkpCLeTTraYsiE0JXB0IKqo8dMkskBdLjBj3rMeI0EJfkFhiAK56GnZo9YfFzvxz10uJzFCmTxRuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LvV4IiDy; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723122166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g54ATMTIXJG375b5OzuX0KxWMWCaU+/qcXwlqHIObZg=;
	b=LvV4IiDyBczFFuN4Y2t0kutoKNImwR5K6AsR+Ow4hKnzXJGKzn1LnXvHuklYxdQUXov4ci
	tSRHdAoz3RsXBQAEHYM0PC/SQ3TD1w+Z8K0IxJgPqstrH0wY2d4NvUOEMWOWoPC28uHSNk
	eLvsP2/sq7XJDB4a13yNAnzQ5e93upo=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 3/3] riscv: Extend gitlab CI
Date: Thu,  8 Aug 2024 15:02:33 +0200
Message-ID: <20240808130229.47415-8-andrew.jones@linux.dev>
In-Reply-To: <20240808130229.47415-5-andrew.jones@linux.dev>
References: <20240808130229.47415-5-andrew.jones@linux.dev>
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
 .gitlab-ci.yml | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index e0eb85a94910..ffbed7c8d301 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -133,18 +133,42 @@ build-ppc64le:
       | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
-# build-riscv32:
-# Fedora doesn't package a riscv32 compiler for QEMU. Oh, well.
+build-riscv32:
+ extends: .outoftree_template
+ script:
+ - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu
+ - ./configure --arch=riscv32 --cross-prefix=riscv64-linux-gnu-
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


