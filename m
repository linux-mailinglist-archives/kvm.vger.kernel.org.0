Return-Path: <kvm+bounces-25227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75576961DCA
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 07:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CB652848E7
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 05:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2E514A609;
	Wed, 28 Aug 2024 05:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="e2V+1bFD"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C9812E1D9;
	Wed, 28 Aug 2024 05:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724821223; cv=none; b=Ikj+/BW09rpzZsjBeym9YDfAry2xXCx5Ka4vwQOxaWh3NguFpqL7j0gO+t0xsDDBpSMvpw94dT/OK+3egwuRHzPdDMxQXqVTqBUSNsMBq5fPPT1xdk6qHBhYFO88RCbr4Ct2etAxS235wgOIjzt/3wbI3jFh/9HFh7quq/FUpTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724821223; c=relaxed/simple;
	bh=VEDhVTVnY0zuzhewz0zm/PuilM0PMpgznKb+DAM1Xo8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pVnnv+fLPmFj58Vyd5Z9DOue3PF8LDS7+yiUXA09S5NDLmeyZ9REZ3onSP+TfPpGyBmNdd/jlyWcQ1m5vc9mjmYenLrW1eVcAb+3aTnSo+QSocc2KH8xOf9r5JJ2ID4YBWzXrpHICyYdgVWVASw5JclToxyEee1ftlNSP1FODQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=e2V+1bFD; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1724821216;
	bh=oVU55GyPUEvEL9hcGrB07XoY0OBZbqxfBQ2u9guts1c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=e2V+1bFDqf1L+DxNwUnLhgum2250OqR5MRWf50lERqKS3vgSnAOOrfsEannwWSQXq
	 OvPejG5CQO+xmDTt0R3Sld4LDzlZgNb2YDB0Lvfw/VUOuDzzw08dKTOwu1AuFujwlz
	 QN/jDf4X3ZFkgPK8avNbN3XRse8bKPXKRgH5/VYc=
X-QQ-mid: bizesmtp79t1724821209tmjq0y8y
X-QQ-Originating-IP: HSvd97IkU+jxIjPcvdHxQdd/9fxSsft1/zQzGcj2AoM=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 28 Aug 2024 13:00:07 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15732336081589095938
From: Dandan Zhang <zhangdandan@uniontech.com>
To: pbonzini@redhat.com,
	corbet@lwn.net,
	zhaotianrui@loongson.cn,
	maobibo@loongson.cn,
	chenhuacai@kernel.org,
	zenghui.yu@linux.dev
Cc: kernel@xen0n.name,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guanwentao@uniontech.com,
	wangyuli@uniontech.com,
	baimingcong@uniontech.com,
	Xianglai Li <lixianglai@loongson.cn>,
	Mingcong Bai <jeffbai@aosc.io>,
	Dandan Zhang <zhangdandan@uniontech.com>
Subject: [PATCH v3] Loongarch: KVM: Add KVM hypercalls documentation for LoongArch
Date: Wed, 28 Aug 2024 12:59:50 +0800
Message-ID: <4769C036576F8816+20240828045950.3484113-1-zhangdandan@uniontech.com>
X-Mailer: git-send-email 2.43.4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-0

From: Bibo Mao <maobibo@loongson.cn>

Add documentation topic for using pv_virt when running as a guest
on KVM hypervisor.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Co-developed-by: Mingcong Bai <jeffbai@aosc.io>
Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
Link: https://lore.kernel.org/all/5c338084b1bcccc1d57dce9ddb1e7081@aosc.io/
Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
---
 Documentation/virt/kvm/index.rst              |  1 +
 .../virt/kvm/loongarch/hypercalls.rst         | 89 +++++++++++++++++++
 Documentation/virt/kvm/loongarch/index.rst    | 10 +++
 MAINTAINERS                                   |  1 +
 4 files changed, 101 insertions(+)
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
index 000000000000..dd96ded5d17d
--- /dev/null
+++ b/Documentation/virt/kvm/loongarch/hypercalls.rst
@@ -0,0 +1,89 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+The LoongArch paravirtual interface
+===================================
+
+KVM hypercalls use the HVCL instruction with code 0x100 and the hypercall
+number is put in a0. Up to five arguments may be placed in registers a1 - a5.
+The return value is placed in v0 (an alias of a0).
+
+Source code for this interface can be found in arch/loongarch/kvm*.
+
+Querying for existence
+======================
+
+To determine if the host is running on KVM, we can utilize the cpucfg()
+function at index CPUCFG_KVM_BASE (0x40000000).
+
+The CPUCFG_KVM_BASE range, spanning from 0x40000000 to 0x400000FF, The
+CPUCFG_KVM_BASE range between 0x40000000 - 0x400000FF is marked as reserved.
+Consequently, all current and future processors will not implement any
+feature within this range.
+
+On a KVM-virtualized Linux system, a read operation on cpucfg() at index
+CPUCFG_KVM_BASE (0x40000000) returns the magic string 'KVM\0'.
+
+Once you have determined that your host is running on a paravirtualization-
+capable KVM, you may now use hypercalls as described below.
+
+KVM hypercall ABI
+=================
+
+The KVM hypercall ABI is simple, with one scratch register a0 (v0) and at most
+five generic registers (a1 - a5) used as input parameters. The FP (Floating-
+point) and vector registers are not utilized as input registers and must
+remain unmodified during a hypercall.
+
+Hypercall functions can be inlined as it only uses one scratch register.
+
+The parameters are as follows:
+
+	========	================	================
+	Register	IN			OUT
+	========	================	================
+	a0		function number		Return	code
+	a1		1st	parameter	-
+	a2		2nd	parameter	-
+	a3		3rd	parameter	-
+	a4		4th	parameter	-
+	a5		5th	parameter	-
+	========	================	================
+
+The return codes may be one of the following:
+
+	====		=========================
+	Code		Meaning
+	====		=========================
+	0		Success
+	-1		Hypercall not implemented
+	-2		Bad Hypercall parameter
+	====		=========================
+
+KVM Hypercalls Documentation
+============================
+
+The template for each hypercall is as follows:
+
+1. Hypercall name
+2. Purpose
+
+1. KVM_HCALL_FUNC_IPI
+------------------------
+
+:Purpose: Send IPIs to multiple vCPUs.
+
+- a0: KVM_HCALL_FUNC_IPI
+- a1: Lower part of the bitmap for destination physical CPUIDs
+- a2: Higher part of the bitmap for destination physical CPUIDs
+- a3: The lowest physical CPUID in the bitmap
+
+The hypercall lets a guest send multiple IPIs (Inter-Process Interrupts) with
+at most 128 destinations per hypercall. The destinations are represented in a
+bitmap contained in the first two input registers (a1 and a2).
+
+Bit 0 of a1 corresponds to the physical CPUID in the third input register (a3)
+and bit 1 corresponds to the physical CPUID in a3+1, and so on.
+
+PV IPI on LoongArch includes both PV IPI multicast sending and PV IPI receiving,
+and SWI is used for PV IPI inject since there is no VM-exits accessing SWI registers.
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
index 878dcd23b331..c267ad7cc2c5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12294,6 +12294,7 @@ L:	kvm@vger.kernel.org
 L:	loongarch@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
+F:	Documentation/virt/kvm/loongarch/
 F:	arch/loongarch/include/asm/kvm*
 F:	arch/loongarch/include/uapi/asm/kvm*
 F:	arch/loongarch/kvm/
-- 
2.43.4


