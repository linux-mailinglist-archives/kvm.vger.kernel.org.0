Return-Path: <kvm+bounces-50715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4207AE889C
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:48:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A2F8176A4A
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDC629E0E3;
	Wed, 25 Jun 2025 15:48:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B5929E0FA;
	Wed, 25 Jun 2025 15:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866513; cv=none; b=Tk3fIwnO6vhm0+pQBPuaB9QboGCMuwb49kKVuj6atqM40WuGt/7cAdqp2IDjT4KZqtA0rFgXx52mn3eQTDKoiRGN38yKeQd161PkfNobjUH48aj+SfDBKtxZqIBVr3SnIVttWeHyadYyJhLL8CNexLWpoX7D0+BjUG1fqjGXenA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866513; c=relaxed/simple;
	bh=bRLdb4osiLDpQNjg4gVws5noepcg1f2wTb1jVPp3Vdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tp/E+MsczrnNIibEMYjMSDKThNxylah3zeWTaTEqdTXhy6d3fjPoESr3DW6U6AJWEiHtvGZT14ChNhqWi/e8gHbkFer9u2wpSL/tWzUZiSukSYJ7pngJdf68feUPBydonejkLHZwk+CBIwAQRoWd5AOWyeAfMMA0GdN4twkJu0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CDAF204C;
	Wed, 25 Jun 2025 08:48:12 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06FDE3F58B;
	Wed, 25 Jun 2025 08:48:25 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev,
	eric.auger@redhat.com,
	lvivier@redhat.com,
	thuth@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	david@redhat.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	joey.gouly@arm.com,
	andre.przywara@arm.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v4 01/13] run_tests.sh: Document --probe-maxsmp argument
Date: Wed, 25 Jun 2025 16:48:01 +0100
Message-ID: <20250625154813.27254-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250625154813.27254-1-alexandru.elisei@arm.com>
References: <20250625154813.27254-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 5dd20ec76ea63 ("runtime: Update MAX_SMP probe") added the
--probe-maxmp argument, but the help message for run_tests.sh wasn't
updated. Document --probe-maxsmp.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 run_tests.sh | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index 152323ffc8a2..f30b6dbd131c 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -17,14 +17,15 @@ cat <<EOF
 
 Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-l]
 
-    -h, --help      Output this help text
-    -v, --verbose   Enables verbose mode
-    -a, --all       Run all tests, including those flagged as 'nodefault'
-                    and those guarded by errata.
-    -g, --group     Only execute tests in the given group
-    -j, --parallel  Execute tests in parallel
-    -t, --tap13     Output test results in TAP format
-    -l, --list      Only output all tests list
+    -h, --help          Output this help text
+    -v, --verbose       Enables verbose mode
+    -a, --all           Run all tests, including those flagged as 'nodefault'
+                        and those guarded by errata.
+    -g, --group         Only execute tests in the given group
+    -j, --parallel      Execute tests in parallel
+    -t, --tap13         Output test results in TAP format
+    -l, --list          Only output all tests list
+        --probe-maxsmp  Update the maximum number of VCPUs supported by host
 
 Set the environment variable QEMU=/path/to/qemu-system-ARCH to
 specify the appropriate qemu binary for ARCH-run.
-- 
2.50.0


