Return-Path: <kvm+bounces-11039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09DA98724BB
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:48:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B924C28A0E7
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4151E14A9F;
	Tue,  5 Mar 2024 16:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nmBYy50P"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5194B182DF
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657251; cv=none; b=l0u6D1NbQ584KnahgM2RY57dxl/6WL+H4MzRl0Il/pP448e8Bg4Go+a4lW/9uGWpIdvc9fY/w+OhdiOPEdeNJrHGmvK/B6cBKGuVi26/iqzEu7M6tgWwOzDvIt30KJZWI42R0+3XpxxYbmjDcgSnFHkNpAlQL1Eelx7kHLVDWSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657251; c=relaxed/simple;
	bh=e4bXbx2KTvcdc5d5nvAkdolPvnGndbkaYf/rBUAU94E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=U/IVVfwjX+qgQF++zxdD7AcK3bUl8nSo9htdOHOae5BsqaRhZVGHKyoKdlFPjJyrtu/MwqxvCE+vNKYGFdci4K3nREwf7mrIZdnD/zfrNPs/GDZRVCcPIwyfPklZP+Ppe5zTvBHvnzpgI1cA7z9Be9Q9WEK8AhoJ32AMbfLlizI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nmBYy50P; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L+jSEC4/nnRJYhJ0h7r/3oDRG2E8rjWg83W2hl/qlns=;
	b=nmBYy50PjE2oyhy/nsjGkcSk/yrKuW3LfUHr9JJd4Xy/qikLIlPdfQP0/MHDBKn9FN3nd3
	mUX3L2pUQzOShdhRXh222QwQJxITHn5SM+qZto3iPbT/prjLHMsFaP4Y/PawN0FpI8iFAr
	JHrsAJuJP3781DfaRH1Tm6aAih1zQ54=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 18/18] arm64: efi: Add gitlab CI
Date: Tue,  5 Mar 2024 17:46:42 +0100
Message-ID: <20240305164623.379149-38-andrew.jones@linux.dev>
In-Reply-To: <20240305164623.379149-20-andrew.jones@linux.dev>
References: <20240305164623.379149-20-andrew.jones@linux.dev>
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

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
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
2.44.0


