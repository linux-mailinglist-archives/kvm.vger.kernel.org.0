Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8B74D1BC6
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347254AbiCHPe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiCHPeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:34:23 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2374626AEC
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 07:33:26 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id o9-20020adfca09000000b001ea79f7edf8so5595655wrh.16
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 07:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V0qLSKmNdWfl7ysxDcVASIR5OLeDQZJYiQEn2QSt4xw=;
        b=pYvtk5V1SMHE47mJEBu3p2iOLB6nJKeBbg8B2Q/37jKEWVAkPNsltYRWuJWf/5YKoG
         OxlM7x1gYfVLYAuvs9+kp5rB1Dha9MVINfFhCOERWFGcKsO0V7MwiuHPQ3YK+llfYks9
         1vW+t4ePkZv09beGf9xW5hgXyI+nxdm36WhLdz29DB+BpCnZ4JaTzHXcAu848goi8I7m
         PhDKTs/2fvBIvBM+tF001JgkAERQ8Tzx11cgv5wz6Yr/h76ZnS0kmOTSgSolvaUCaZs+
         NngWpdIPlePsg95RCEmaN/aGuj4CVeNRcJAhjHVRN9fflbOh6U5yFz5bboUiDnuo0rqd
         Arng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V0qLSKmNdWfl7ysxDcVASIR5OLeDQZJYiQEn2QSt4xw=;
        b=5oYLHwRy2Qv0Ybm/UECPqOCPQzwuenbSJLgrDV0ct8j9egmuAWDUyhyGRszLwQGNa1
         duCUP9la8+3bLJ1j/8VmnMOwGo4j6So5g7Va8hoSfgQvuAYrwva0IXJw9A5AhcKJySR3
         YsF1LSm6oluBSyHCa5gAJiBrN0j5uQqsZhDeiYjOvLWQ8XPrPa2LlwoVbqaNknLzEk1q
         PaqkP8piTWEMaYbS93BbtbI8mDmf4dLhPFVQO9jRxeevIs4QjALsjyksFfivL2bsSvCI
         vsQuv4KxXERCxMxIG9TyGCiZHkT5DguiB7R3TQzcLPMAp7NcJ+CLHdDUrIe2toJ8xQ80
         t+zQ==
X-Gm-Message-State: AOAM531rCuRIJHFqe9XIRJfWwg/qmV448iFmcQn9GV63UOo2nsqkAuzU
        M4f/5rFSn8ZxjaSWkNUTz0FGbUb2513MsJBfKM81Dy8C9MA1Qz2ACYXtjI82LTRnCYAqAnXxTCP
        eM3PjBDcjx3gc3cImkBBqfXz34JNxiMYxQL04OEfXpTNX8tjktMVfRTeAlLt5Z/jKPviNl1f8NQ
        ==
X-Google-Smtp-Source: ABdhPJylIXLscK0x024KFK9S2VpafD3kapDQIcyJXYl5QPtbOlPfdZ0W+ON/AkyvByXP39fnOUN0DicvbnJokClZmg8=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:a45:b0:346:5e67:cd54 with
 SMTP id c5-20020a05600c0a4500b003465e67cd54mr3957829wmq.127.1646753604618;
 Tue, 08 Mar 2022 07:33:24 -0800 (PST)
Date:   Tue,  8 Mar 2022 15:32:29 +0000
In-Reply-To: <20220308153227.2238533-1-sebastianene@google.com>
Message-Id: <20220308153227.2238533-3-sebastianene@google.com>
Mime-Version: 1.0
References: <20220308153227.2238533-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v9 2/3] aarch64: Add stolen time support
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds support for stolen time by sharing a memory region
with the guest which will be used by the hypervisor to store the stolen
time information. Reserve a 64kb MMIO memory region after the RTC peripheral
to be used by pvtime. The exact format of the structure stored by the
hypervisor is described in the ARM DEN0057A document.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 Makefile                               |  1 +
 arm/aarch32/include/kvm/kvm-cpu-arch.h |  5 ++
 arm/aarch64/arm-cpu.c                  |  2 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  2 +
 arm/aarch64/pvtime.c                   | 96 ++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |  6 +-
 arm/kvm-cpu.c                          |  1 +
 include/kvm/kvm-config.h               |  1 +
 8 files changed, 112 insertions(+), 2 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

diff --git a/Makefile b/Makefile
index f251147..e9121dc 100644
--- a/Makefile
+++ b/Makefile
@@ -182,6 +182,7 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/aarch64/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
+	OBJS		+= arm/aarch64/pvtime.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
index 780e0e2..6fe0206 100644
--- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
@@ -20,4 +20,9 @@ static inline int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
 	return 0;
 }
 
+static inline int kvm_cpu__teardown_pvtime(struct kvm *kvm)
+{
+	return 0;
+}
+
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index d7572b7..7e4a3c1 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -22,7 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
 {
 	vcpu->generate_fdt_nodes = generate_fdt_nodes;
-	return 0;
+	return kvm_cpu__setup_pvtime(vcpu);
 }
 
 static struct kvm_arm_target target_generic_v8 = {
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index 8dfb82e..35996dc 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -19,5 +19,7 @@
 
 void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
 int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
+int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
+int kvm_cpu__teardown_pvtime(struct kvm *kvm);
 
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
new file mode 100644
index 0000000..a45f0ea
--- /dev/null
+++ b/arm/aarch64/pvtime.c
@@ -0,0 +1,96 @@
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include <linux/byteorder.h>
+#include <linux/types.h>
+
+#define ARM_PVTIME_STRUCT_SIZE		(64)
+
+static void *usr_mem;
+
+static int pvtime__alloc_region(struct kvm *kvm)
+{
+	char *mem;
+	int ret = 0;
+
+	mem = mmap(NULL, ARM_PVTIME_BASE, PROT_RW,
+		   MAP_ANON_NORESERVE, -1, 0);
+	if (mem == MAP_FAILED)
+		return -errno;
+
+	ret = kvm__register_ram(kvm, ARM_PVTIME_BASE,
+				ARM_PVTIME_BASE, mem);
+	if (ret) {
+		munmap(mem, ARM_PVTIME_BASE);
+		return ret;
+	}
+
+	usr_mem = mem;
+	return ret;
+}
+
+static int pvtime__teardown_region(struct kvm *kvm)
+{
+	if (usr_mem == NULL)
+		return 0;
+
+	kvm__destroy_mem(kvm, ARM_PVTIME_BASE,
+			 ARM_PVTIME_BASE, usr_mem);
+	munmap(usr_mem, ARM_PVTIME_BASE);
+	usr_mem = NULL;
+	return 0;
+}
+
+int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
+{
+	int ret;
+	bool has_stolen_time;
+	u64 pvtime_guest_addr = ARM_PVTIME_BASE + vcpu->cpu_id *
+		ARM_PVTIME_STRUCT_SIZE;
+	struct kvm_config *kvm_cfg = NULL;
+	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
+		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
+		.addr	= KVM_ARM_VCPU_PVTIME_IPA
+	};
+
+	kvm_cfg = &vcpu->kvm->cfg;
+	if (kvm_cfg->no_pvtime)
+		return 0;
+
+	has_stolen_time = kvm__supports_extension(vcpu->kvm,
+						  KVM_CAP_STEAL_TIME);
+	if (!has_stolen_time) {
+		kvm_cfg->no_pvtime = true;
+		return 0;
+	}
+
+	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
+	if (ret) {
+		perror("KVM_HAS_DEVICE_ATTR failed\n");
+		goto out_err;
+	}
+
+	if (!usr_mem) {
+		ret = pvtime__alloc_region(vcpu->kvm);
+		if (ret) {
+			perror("Failed allocating pvtime region\n");
+			goto out_err;
+		}
+	}
+
+	pvtime_attr.addr = (u64)&pvtime_guest_addr;
+	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
+	if (!ret)
+		return 0;
+
+	perror("KVM_SET_DEVICE_ATTR failed\n");
+	pvtime__teardown_region(vcpu->kvm);
+out_err:
+	return ret;
+}
+
+int kvm_cpu__teardown_pvtime(struct kvm *kvm)
+{
+	return pvtime__teardown_region(kvm);
+}
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index c645ac0..43b1f77 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -15,7 +15,8 @@
  * |  PCI  |////| plat  |       |        |     |         |
  * |  I/O  |////| MMIO: | Flash | virtio | GIC |   PCI   |  DRAM
  * | space |////| UART, |       |  MMIO  |     |  (AXI)  |
- * |       |////| RTC   |       |        |     |         |
+ * |       |////| RTC,  |       |        |     |         |
+ * |       |////| PVTIME|       |        |     |         |
  * +-------+----+-------+-------+--------+-----+---------+---......
  */
 
@@ -34,6 +35,9 @@
 #define ARM_RTC_MMIO_BASE	(ARM_UART_MMIO_BASE + ARM_UART_MMIO_SIZE)
 #define ARM_RTC_MMIO_SIZE	0x10000
 
+#define ARM_PVTIME_BASE		(ARM_RTC_MMIO_BASE + ARM_RTC_MMIO_SIZE)
+#define ARM_PVTIME_SIZE		SZ_64K
+
 #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
 #define KVM_FLASH_MAX_SIZE	0x1000000
 
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 84ac1e9..00660d6 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -144,6 +144,7 @@ void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
 
 void kvm_cpu__delete(struct kvm_cpu *vcpu)
 {
+	kvm_cpu__teardown_pvtime(vcpu->kvm);
 	free(vcpu);
 }
 
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 6a5720c..48adf27 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -62,6 +62,7 @@ struct kvm_config {
 	bool no_dhcp;
 	bool ioport_debug;
 	bool mmio_debug;
+	bool no_pvtime;
 };
 
 #endif
-- 
2.35.1.616.g0bdcbb4464-goog

