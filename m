Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60B66CBF29
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 14:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbjC1McN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 08:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbjC1Mbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 08:31:51 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3834E9764;
        Tue, 28 Mar 2023 05:31:36 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxIk4f3iJk0hkTAA--.29034S3;
        Tue, 28 Mar 2023 20:31:27 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxPL4X3iJku2cPAA--.12046S31;
        Tue, 28 Mar 2023 20:31:27 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PING PATCH v4 29/29] LoongArch: KVM: Enable kvm config and add the makefile
Date:   Tue, 28 Mar 2023 20:31:19 +0800
Message-Id: <20230328123119.3649361-30-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
References: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxPL4X3iJku2cPAA--.12046S31
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxWr4xGF4xXF15tw4UWFWxZwb_yoW5KFy3pF
        4fAr1kGF4xWFn3JrZ3t34kWrs8CFn7KrW7u3Waya48CrW7Z34kur1ktr9rXFyUJ393JrW8
        Wr1rGa1agayUJaUanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4AFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6x
        kF7I0E14v26F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
        jxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6c
        x26rWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r12
        6r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWDJVCq3wCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6x
        kF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7xRiTKZJUUUUU==
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable loongarch kvm config and add the makefile to support build kvm
module.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/Kbuild                      |  1 +
 arch/loongarch/Kconfig                     |  2 ++
 arch/loongarch/configs/loongson3_defconfig |  2 ++
 arch/loongarch/kvm/Kconfig                 | 38 ++++++++++++++++++++++
 arch/loongarch/kvm/Makefile                | 22 +++++++++++++
 5 files changed, 65 insertions(+)
 create mode 100644 arch/loongarch/kvm/Kconfig
 create mode 100644 arch/loongarch/kvm/Makefile

diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
index b01f5cdb2..40be8a169 100644
--- a/arch/loongarch/Kbuild
+++ b/arch/loongarch/Kbuild
@@ -2,6 +2,7 @@ obj-y += kernel/
 obj-y += mm/
 obj-y += net/
 obj-y += vdso/
+obj-y += kvm/
 
 # for cleaning
 subdir- += boot
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 7fd51257e..f9beeb2e0 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -148,6 +148,7 @@ config LOONGARCH
 	select USE_PERCPU_NUMA_NODE_ID
 	select USER_STACKTRACE_SUPPORT
 	select ZONE_DMA32
+	select HAVE_KVM
 
 config 32BIT
 	bool
@@ -588,3 +589,4 @@ source "drivers/acpi/Kconfig"
 endmenu
 
 source "drivers/firmware/Kconfig"
+source "arch/loongarch/kvm/Kconfig"
diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
index e18213f01..c99520374 100644
--- a/arch/loongarch/configs/loongson3_defconfig
+++ b/arch/loongarch/configs/loongson3_defconfig
@@ -63,6 +63,8 @@ CONFIG_EFI_ZBOOT=y
 CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
 CONFIG_EFI_CAPSULE_LOADER=m
 CONFIG_EFI_TEST=m
+CONFIG_VIRTUALIZATION=y
+CONFIG_KVM=m
 CONFIG_MODULES=y
 CONFIG_MODULE_FORCE_LOAD=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
new file mode 100644
index 000000000..8a999b4c0
--- /dev/null
+++ b/arch/loongarch/kvm/Kconfig
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# KVM configuration
+#
+
+source "virt/kvm/Kconfig"
+
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	help
+	  Say Y here to get to see options for using your Linux host to run
+	  other operating systems inside virtual machines (guests).
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled.
+
+if VIRTUALIZATION
+
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on HAVE_KVM
+	select MMU_NOTIFIER
+	select ANON_INODES
+	select PREEMPT_NOTIFIERS
+	select KVM_MMIO
+	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	select HAVE_KVM_VCPU_ASYNC_IOCTL
+	select HAVE_KVM_EVENTFD
+	select SRCU
+	help
+	  Support hosting virtualized guest machines using hardware
+	  virtualization extensions. You will need a fairly processor
+	  equipped with virtualization extensions.
+
+	  If unsure, say N.
+
+endif # VIRTUALIZATION
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
new file mode 100644
index 000000000..2335e873a
--- /dev/null
+++ b/arch/loongarch/kvm/Makefile
@@ -0,0 +1,22 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for LOONGARCH KVM support
+#
+
+ccflags-y += -I $(srctree)/$(src)
+
+include $(srctree)/virt/kvm/Makefile.kvm
+
+obj-$(CONFIG_KVM) += kvm.o
+
+kvm-y += main.o
+kvm-y += vm.o
+kvm-y += vmid.o
+kvm-y += tlb.o
+kvm-y += mmu.o
+kvm-y += vcpu.o
+kvm-y += exit.o
+kvm-y += interrupt.o
+kvm-y += timer.o
+kvm-y += switch.o
+kvm-y += csr_ops.o
-- 
2.31.1

