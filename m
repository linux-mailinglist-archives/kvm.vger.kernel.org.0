Return-Path: <kvm+bounces-36034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 428C4A1705F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7FB6A7A2A6C
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949521E9B3D;
	Mon, 20 Jan 2025 16:43:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD37C372;
	Mon, 20 Jan 2025 16:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391421; cv=none; b=DDvwxqg5o/vUyVaUsTnveakAqI8vGsEqpafSt7ySKV3lDR+j11j7aeoHkbhyIE3w5HbFIsfGiTVTRvVgXA8Fpa67Fcq3OiuMgoCTVqOyJsiC+K2xYZiO+bwuv/fqZtmtF0OFhCQJ2/uqbdOGvLz1r7iahw+iwVt5sszDj06FnIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391421; c=relaxed/simple;
	bh=GfhxiJqzI2tLPyXNWcy2aEygOIOs18xCVccC1B0xNr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+FDmf54X1b+DOs117veaO6KHV1Qailfr84on63WMr+lixiFYQu4N4tqQEyGrkqO36JMhMhzECvydTS5edLXDhj0eGIY+T3fes8CSaXjjrcv0vH9VmfFIJOVbA+bwBnCbAHzfN+KBgL7obZPJznQ06n9eNo6k77jg7CYF2SVrH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDF701688;
	Mon, 20 Jan 2025 08:44:07 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEF843F5A1;
	Mon, 20 Jan 2025 08:43:35 -0800 (PST)
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
	Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v2 02/18] Document environment variables
Date: Mon, 20 Jan 2025 16:43:00 +0000
Message-ID: <20250120164316.31473-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250120164316.31473-1-alexandru.elisei@arm.com>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the environment variables that influence how a test is executed
by the run_tests.sh test runner.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 docs/unittests.txt |  5 ++++-
 run_tests.sh       | 12 +++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/docs/unittests.txt b/docs/unittests.txt
index c4269f6230c8..dbc2c11e3b59 100644
--- a/docs/unittests.txt
+++ b/docs/unittests.txt
@@ -88,7 +88,8 @@ timeout
 -------
 timeout = <duration>
 
-Optional timeout in seconds, after which the test will be killed and fail.
+Optional timeout in seconds, after which the test will be killed and fail. Can
+be overwritten with the TIMEOUT=<duration> environment variable.
 
 check
 -----
@@ -99,3 +100,5 @@ can contain multiple files to check separated by a space, but each check
 parameter needs to be of the form <path>=<value>
 
 The path and value cannot contain space, =, or shell wildcard characters.
+
+Can be overwritten with the CHECK environment variable with the same syntax.
diff --git a/run_tests.sh b/run_tests.sh
index f30b6dbd131c..23d81b2caaa1 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -27,9 +27,15 @@ Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-l]
     -l, --list          Only output all tests list
         --probe-maxsmp  Update the maximum number of VCPUs supported by host
 
-Set the environment variable QEMU=/path/to/qemu-system-ARCH to
-specify the appropriate qemu binary for ARCH-run.
-
+The following environment variables are used:
+
+    QEMU            Path to QEMU binary for ARCH-run
+    ACCEL           QEMU accelerator to use, e.g. 'kvm', 'hvf' or 'tcg'
+    ACCEL_PROPS     Extra argument to ACCEL
+    MACHINE         QEMU machine type
+    TIMEOUT         Timeout duration for the timeout(1) command
+    CHECK           Overwrites the 'check' unit test parameter (see
+                    docs/unittests.txt)
 EOF
 }
 
-- 
2.47.1


