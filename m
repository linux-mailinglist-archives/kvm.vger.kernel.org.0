Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B114D104957
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 04:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfKUDZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 22:25:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfKUDZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 22:25:12 -0500
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B452B20721;
        Thu, 21 Nov 2019 03:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574306711;
        bh=NQZEd8v97Kx8SQRm2lC/02RuQn2Hi0S1xJaELXyodjA=;
        h=From:To:Subject:Date:From;
        b=tjuF777b81OZLTIAEISe06O6iDt7pAlIM62+iBtTa7iDAgoQaOeOYqiwRledc6MmZ
         SYGM0S2jQSfuxk4O+A15KLBbZ0pASLcDvEf0naZPGQu0FGiAxkuAUxLhlb4j9obI2X
         zqkjvTESFPubj46tdActXy/4psdWpw6I5odTw+9I=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org
Subject: [PATCH] virt: Fix Kconfig indentation
Date:   Thu, 21 Nov 2019 04:25:02 +0100
Message-Id: <1574306702-7834-1-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:
	$ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Changes since v1:
1. Fix also 7-space and tab+1 space indentation issues.
---
 drivers/virt/Kconfig | 10 +++++-----
 virt/kvm/Kconfig     | 42 +++++++++++++++++++++---------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/virt/Kconfig b/drivers/virt/Kconfig
index 363af2eaf2ba..cb5d2d89592f 100644
--- a/drivers/virt/Kconfig
+++ b/drivers/virt/Kconfig
@@ -18,17 +18,17 @@ config FSL_HV_MANAGER
 	depends on FSL_SOC
 	select EPAPR_PARAVIRT
 	help
-          The Freescale hypervisor management driver provides several services
+	  The Freescale hypervisor management driver provides several services
 	  to drivers and applications related to the Freescale hypervisor:
 
-          1) An ioctl interface for querying and managing partitions.
+	  1) An ioctl interface for querying and managing partitions.
 
-          2) A file interface to reading incoming doorbells.
+	  2) A file interface to reading incoming doorbells.
 
-          3) An interrupt handler for shutting down the partition upon
+	  3) An interrupt handler for shutting down the partition upon
 	     receiving the shutdown doorbell from a manager partition.
 
-          4) A kernel interface for receiving callbacks when a managed
+	  4) A kernel interface for receiving callbacks when a managed
 	     partition shuts down.
 
 source "drivers/virt/vboxguest/Kconfig"
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index aad9284c043a..5f4184ecf1cf 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -2,61 +2,61 @@
 # KVM common configuration items and defaults
 
 config HAVE_KVM
-       bool
+	bool
 
 config HAVE_KVM_IRQCHIP
-       bool
+	bool
 
 config HAVE_KVM_IRQFD
-       bool
+	bool
 
 config HAVE_KVM_IRQ_ROUTING
-       bool
+	bool
 
 config HAVE_KVM_EVENTFD
-       bool
-       select EVENTFD
+	bool
+	select EVENTFD
 
 config KVM_MMIO
-       bool
+	bool
 
 config KVM_ASYNC_PF
-       bool
+	bool
 
 # Toggle to switch between direct notification and batch job
 config KVM_ASYNC_PF_SYNC
-       bool
+	bool
 
 config HAVE_KVM_MSI
-       bool
+	bool
 
 config HAVE_KVM_CPU_RELAX_INTERCEPT
-       bool
+	bool
 
 config KVM_VFIO
-       bool
+	bool
 
 config HAVE_KVM_ARCH_TLB_FLUSH_ALL
-       bool
+	bool
 
 config HAVE_KVM_INVALID_WAKEUPS
-       bool
+	bool
 
 config KVM_GENERIC_DIRTYLOG_READ_PROTECT
-       bool
+	bool
 
 config KVM_COMPAT
-       def_bool y
-       depends on KVM && COMPAT && !(S390 || ARM64)
+	def_bool y
+	depends on KVM && COMPAT && !(S390 || ARM64)
 
 config HAVE_KVM_IRQ_BYPASS
-       bool
+	bool
 
 config HAVE_KVM_VCPU_ASYNC_IOCTL
-       bool
+	bool
 
 config HAVE_KVM_VCPU_RUN_PID_CHANGE
-       bool
+	bool
 
 config HAVE_KVM_NO_POLL
-       bool
+	bool
-- 
2.7.4

