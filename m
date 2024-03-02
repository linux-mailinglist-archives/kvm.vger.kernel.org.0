Return-Path: <kvm+bounces-10717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32D8586EFA7
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 09:47:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59D921C21207
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 08:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD97134AB;
	Sat,  2 Mar 2024 08:47:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0AE79F0;
	Sat,  2 Mar 2024 08:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709369259; cv=none; b=ZwJawgAXZjfQGxvhmzHq9NswWykXZFYheB4v94+Vsoaga0DlUpDATI8ayta9Jiqc4Q1cpjcgP4srb5xSSfia5j1dKmYbkS6djdwhs63Wt3/2W5phx3DoWR1dLu0nxUgv40Wu6rjiK4fJ7v/VG5lNfsCSVzwJXZoAp8WiKUqjhp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709369259; c=relaxed/simple;
	bh=f1Y+/ht0z9E9BsX+uCJhSCI5UEi794liFywZ4dOZfI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iZCTbURCg46shpFlZasJlFlu5JLTYxClxNiuiM0tPPRGtz/N/86tt8B5Lt5KF1m0xYUi4+0vLD4JwUWp7erPD+xB772aG0GE05kOtWNZs9qpstiebGlLLIA7ZhD7/+az1qGzhIfQOFpxa0iUSEuogv33t6gd6Q/xAv62VFm430I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxSPCf5+JlLYsTAA--.50243S3;
	Sat, 02 Mar 2024 16:47:27 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxfROd5+JlmFtMAA--.39607S2;
	Sat, 02 Mar 2024 16:47:25 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v6 7/7] Documentation: KVM: Add hypercall for LoongArch
Date: Sat,  2 Mar 2024 16:47:24 +0800
Message-Id: <20240302084724.1415344-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240302082532.1415200-1-maobibo@loongson.cn>
References: <20240302082532.1415200-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxfROd5+JlmFtMAA--.39607S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxAFWUtr15Xr4UWw17tFy3WrX_yoWrCr1DpF
	95G34fKrn7Jry7A34xJr1UWryjkr97JF47J3W8Jr10qr1DJr1fJr4UtFZ0y3W8G3y8AFW8
	XF18tr1jkr1UAwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
	0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26F4j6r4UJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7IU8siSPUUUUU==

Add documentation topic for using pv_virt when running as a guest
on KVM hypervisor.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 Documentation/virt/kvm/index.rst              |  1 +
 .../virt/kvm/loongarch/hypercalls.rst         | 79 +++++++++++++++++++
 Documentation/virt/kvm/loongarch/index.rst    | 10 +++
 3 files changed, 90 insertions(+)
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
-- 
2.39.3


