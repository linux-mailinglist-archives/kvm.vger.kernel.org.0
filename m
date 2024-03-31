Return-Path: <kvm+bounces-13199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DD118932A9
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF04F1C209FE
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2711F145321;
	Sun, 31 Mar 2024 16:22:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.v2201612906741603.powersrv.de (mail.weilnetz.de [37.120.169.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A719E1E531
	for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 16:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.169.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711902171; cv=none; b=m1FIw8FbSVlD6zU1bVRNYuL/ZJBdFNb10+3erl61xJdBg5Wli0+ffQRBDSzhsQIKPDMQ81wEJrTnH411rgzgpbX9yZkMPcmaipWGeGFEjurZbtMlinVy5mqtAoMxq4HhyCYdzMBk3CMAt3kPJjYJsvkJQIVcMaEWNC4y0rSyN7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711902171; c=relaxed/simple;
	bh=+OvOe02XCO4hD2WKRR3hasQMTHZAjHLlPU4vLOEQVPM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fbsQFuCm6iawXE6mtBwuJBM63Rmlb9yDypyUouh5iJk5TgOAv4JNn1tHhQNl+F/rddRfIWEpWy1wpaR9HxIJB3Yrupt08hWg1UEYEPtkKRDn/xffUKfQC6/qBAcPyQ/FKQi45tSGsHw3PhsxO4WO/Xx8CJF2JAeJBc0KiNqNcPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weilnetz.de; spf=pass smtp.mailfrom=weilnetz.de; arc=none smtp.client-ip=37.120.169.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weilnetz.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weilnetz.de
Received: from qemu.weilnetz.de (qemu.weilnetz.de [188.68.58.204])
	by mail.v2201612906741603.powersrv.de (Postfix) with ESMTP id 76012DA06D4;
	Sun, 31 Mar 2024 18:16:03 +0200 (CEST)
Received: by qemu.weilnetz.de (Postfix, from userid 1000)
	id F073D460023; Sun, 31 Mar 2024 18:16:02 +0200 (CEST)
From: Stefan Weil <sw@weilnetz.de>
To: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Luc Michel <luc@lmichel.fr>,
	Eric Blake <eblake@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	qemu-trivial@nongnu.org,
	Stefan Weil <sw@weilnetz.de>
Subject: [PATCH for-9.0] Fix some typos in documentation (found by codespell)
Date: Sun, 31 Mar 2024 18:15:26 +0200
Message-Id: <20240331161526.1746598-1-sw@weilnetz.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Stefan Weil <sw@weilnetz.de>
---
 docs/devel/atomics.rst     | 2 +-
 docs/devel/ci-jobs.rst.inc | 2 +-
 docs/devel/clocks.rst      | 2 +-
 docs/system/i386/sgx.rst   | 2 +-
 qapi/qom.json              | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/docs/devel/atomics.rst b/docs/devel/atomics.rst
index ff9b5ee30c..b77c6e13e1 100644
--- a/docs/devel/atomics.rst
+++ b/docs/devel/atomics.rst
@@ -119,7 +119,7 @@ The only guarantees that you can rely upon in this case are:
   ordinary accesses instead cause data races if they are concurrent with
   other accesses of which at least one is a write.  In order to ensure this,
   the compiler will not optimize accesses out of existence, create unsolicited
-  accesses, or perform other similar optimzations.
+  accesses, or perform other similar optimizations.
 
 - acquire operations will appear to happen, with respect to the other
   components of the system, before all the LOAD or STORE operations
diff --git a/docs/devel/ci-jobs.rst.inc b/docs/devel/ci-jobs.rst.inc
index ec33e6ee2b..be06322279 100644
--- a/docs/devel/ci-jobs.rst.inc
+++ b/docs/devel/ci-jobs.rst.inc
@@ -115,7 +115,7 @@ CI pipeline.
 QEMU_JOB_SKIPPED
 ~~~~~~~~~~~~~~~~
 
-The job is not reliably successsful in general, so is not
+The job is not reliably successful in general, so is not
 currently suitable to be run by default. Ideally this should
 be a temporary marker until the problems can be addressed, or
 the job permanently removed.
diff --git a/docs/devel/clocks.rst b/docs/devel/clocks.rst
index b2d1148cdb..177ee1c90d 100644
--- a/docs/devel/clocks.rst
+++ b/docs/devel/clocks.rst
@@ -279,7 +279,7 @@ You can change the multiplier and divider of a clock at runtime,
 so you can use this to model clock controller devices which
 have guest-programmable frequency multipliers or dividers.
 
-Similary to ``clock_set()``, ``clock_set_mul_div()`` returns ``true`` if
+Similarly to ``clock_set()``, ``clock_set_mul_div()`` returns ``true`` if
 the clock state was modified; that is, if the multiplier or the diviser
 or both were changed by the call.
 
diff --git a/docs/system/i386/sgx.rst b/docs/system/i386/sgx.rst
index 0f0a73f758..c293f7f44e 100644
--- a/docs/system/i386/sgx.rst
+++ b/docs/system/i386/sgx.rst
@@ -6,7 +6,7 @@ Overview
 
 Intel Software Guard eXtensions (SGX) is a set of instructions and mechanisms
 for memory accesses in order to provide security accesses for sensitive
-applications and data. SGX allows an application to use it's pariticular
+applications and data. SGX allows an application to use its particular
 address space as an *enclave*, which is a protected area provides confidentiality
 and integrity even in the presence of privileged malware. Accesses to the
 enclave memory area from any software not resident in the enclave are prevented,
diff --git a/qapi/qom.json b/qapi/qom.json
index 8d4ca8ed92..85e6b4f84a 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -802,7 +802,7 @@
 #
 # @fd: file descriptor name previously passed via 'getfd' command,
 #     which represents a pre-opened /dev/iommu.  This allows the
-#     iommufd object to be shared accross several subsystems (VFIO,
+#     iommufd object to be shared across several subsystems (VFIO,
 #     VDPA, ...), and the file descriptor to be shared with other
 #     process, e.g. DPDK.  (default: QEMU opens /dev/iommu by itself)
 #
-- 
2.39.2


