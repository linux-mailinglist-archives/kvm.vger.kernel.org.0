Return-Path: <kvm+bounces-22723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B632942612
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 07:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DBCCFB23BEB
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 05:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7B654757;
	Wed, 31 Jul 2024 05:59:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CB519478
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 05:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722405562; cv=none; b=h+Mc2sp126qHuT+B5NFjN1+qy1zRHrPQljDWoNBui29uFsi5AsuOqvZIqCSblX2amrFruBHREqBg9ygExtRdFKdCIt5KO5ROMcVElTqZ1iMdk8+PQxkI9OYAPkLLf+KABdUKSBcv7qBIZlIMFHiqbKLet/1/+A15bazcPV3XqVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722405562; c=relaxed/simple;
	bh=fw8pV2E6JodKBn5rCcZhCplE6uJAE3CqlzItsieqkQY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bmgc98aPr+meLVBXMWrK2UgxayfUgnm6J6TsgFk68WHXoF0bNO3tb+hAxHs8ZvUSt0esC6vqYMjOWAEx1VkvjTSk211JTqLEzcqzb6qeBCFS4k2qWF1YqTGtQTRKFKJp90OfJcM59ng0ivDUaKjNrG04wmG1LXbHnNomeygL4X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
X-QQ-mid: bizesmtpsz5t1722405490tkcp2mr
X-QQ-Originating-IP: H58t0EWCHvpjS6Y/q97tg7C/r3E8tCwlmahWgIbr3bo=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 31 Jul 2024 13:58:08 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8111145318027343872
From: WangYuli <wangyuli@uniontech.com>
To: pbonzini@redhat.com,
	corbet@lwn.net,
	zhaotianrui@loongson.cn,
	maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kernel@xen0n.name,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guanwentao@uniontech.com,
	Xianglai Li <lixianglai@loongson.cn>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH] Loongarch: KVM: Add KVM hypercalls documentation for LoongArch
Date: Wed, 31 Jul 2024 13:57:55 +0800
Message-ID: <04DAF94279B88A3F+20240731055755.84082-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.43.4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

From: Bibo Mao <maobibo@loongson.cn>

Add documentation topic for using pv_virt when running as a guest
on KVM hypervisor.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 Documentation/virt/kvm/index.rst              |  1 +
 .../virt/kvm/loongarch/hypercalls.rst         | 79 +++++++++++++++++++
 Documentation/virt/kvm/loongarch/index.rst    | 10 +++
 MAINTAINERS                                   |  1 +
 4 files changed, 91 insertions(+)
 create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
 create mode 100644 Documentation/virt/kvm/loongarch/index.rst

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index ad13ec55ddfe..9ca5a45c2140 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -14,6 +14,7 @@ KVM
    s390/index
    ppc-pv
    x86/index
+   loongarch/index
 
    locking
    vcpu-requests
diff --git a/Documentation/virt/kvm/loongarch/hypercalls.rst b/Documentation/virt/kvm/loongarch/hypercalls.rst
new file mode 100644
index 000000000000..1679e48d67d2
--- /dev/null
+++ b/Documentation/virt/kvm/loongarch/hypercalls.rst
@@ -0,0 +1,79 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+The LoongArch paravirtual interface
+===================================
+
+KVM hypercalls use the HVCL instruction with code 0x100, and the hypercall
+number is put in a0 and up to five arguments may be placed in a1-a5, the
+return value is placed in v0 (alias with a0).
+
+The code for that interface can be found in arch/loongarch/kvm/*
+
+Querying for existence
+======================
+
+To find out if we're running on KVM or not, cpucfg can be used with index
+CPUCFG_KVM_BASE (0x40000000), cpucfg range between 0x40000000 - 0x400000FF
+is marked as a specially reserved range. All existing and future processors
+will not implement any features in this range.
+
+When Linux is running on KVM, cpucfg with index CPUCFG_KVM_BASE (0x40000000)
+returns magic string "KVM\0"
+
+Once you determined you're running under a PV capable KVM, you can now use
+hypercalls as described below.
+
+KVM hypercall ABI
+=================
+
+Hypercall ABI on KVM is simple, only one scratch register a0 (v0) and at most
+five generic registers used as input parameter. FP register and vector register
+is not used for input register and should not be modified during hypercall.
+Hypercall function can be inlined since there is only one scratch register.
+
+The parameters are as follows:
+
+        ========	================	================
+	Register	IN			OUT
+        ========	================	================
+	a0		function number		Return code
+	a1		1st parameter		-
+	a2		2nd parameter		-
+	a3		3rd parameter		-
+	a4		4th parameter		-
+	a5		5th parameter		-
+        ========	================	================
+
+Return codes can be as follows:
+
+	====		=========================
+	Code		Meaning
+	====		=========================
+	0		Success
+	-1		Hypercall not implemented
+	-2		Hypercall parameter error
+	====		=========================
+
+KVM Hypercalls Documentation
+============================
+
+The template for each hypercall is:
+1. Hypercall name
+2. Purpose
+
+1. KVM_HCALL_FUNC_PV_IPI
+------------------------
+
+:Purpose: Send IPIs to multiple vCPUs.
+
+- a0: KVM_HCALL_FUNC_PV_IPI
+- a1: lower part of the bitmap of destination physical CPUIDs
+- a2: higher part of the bitmap of destination physical CPUIDs
+- a3: the lowest physical CPUID in bitmap
+
+The hypercall lets a guest send multicast IPIs, with at most 128
+destinations per hypercall.  The destinations are represented by a bitmap
+contained in the first two arguments (a1 and a2). Bit 0 of a1 corresponds
+to the physical CPUID in the third argument (a3), bit 1 corresponds to the
+physical ID a3+1, and so on.
diff --git a/Documentation/virt/kvm/loongarch/index.rst b/Documentation/virt/kvm/loongarch/index.rst
new file mode 100644
index 000000000000..83387b4c5345
--- /dev/null
+++ b/Documentation/virt/kvm/loongarch/index.rst
@@ -0,0 +1,10 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+KVM for LoongArch systems
+=========================
+
+.. toctree::
+   :maxdepth: 2
+
+   hypercalls.rst
diff --git a/MAINTAINERS b/MAINTAINERS
index 958e935449e5..8aa5d92b12ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12073,6 +12073,7 @@ L:	kvm@vger.kernel.org
 L:	loongarch@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
+F:	Documentation/virt/kvm/loongarch/
 F:	arch/loongarch/include/asm/kvm*
 F:	arch/loongarch/include/uapi/asm/kvm*
 F:	arch/loongarch/kvm/
-- 
2.43.4


