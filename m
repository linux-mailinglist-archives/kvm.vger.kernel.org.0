Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B1A7BD60B
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 11:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345657AbjJIJCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 05:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345631AbjJIJCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 05:02:19 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A982CDE
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 02:02:16 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Dxg_CWwSNlkz0wAA--.27574S3;
        Mon, 09 Oct 2023 17:02:14 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Dx_y+TwSNlDW4cAA--.59991S4;
        Mon, 09 Oct 2023 17:02:13 +0800 (CST)
From:   xianglai li <lixianglai@loongson.cn>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Bibo Mao <maobibo@loongson.cn>, Song Gao <gaosong@loongson.cn>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>
Subject: [PATCH RFC v4 2/9] target/loongarch: Define some kvm_arch interfaces
Date:   Mon,  9 Oct 2023 17:01:30 +0800
Message-Id: <579fb58997b7a8dd2c492daeff9bcd8d3330debd.1696841645.git.lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1696841645.git.lixianglai@loongson.cn>
References: <cover.1696841645.git.lixianglai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Dx_y+TwSNlDW4cAA--.59991S4
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianrui Zhao <zhaotianrui@loongson.cn>

Define some functions in target/loongarch/kvm.c, such as
kvm_arch_put_registers, kvm_arch_get_registers and
kvm_arch_handle_exit, etc. which are needed by kvm/kvm-all.c.
Now the most functions has no content and they will be
implemented in the next patches.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Marc-André Lureau" <marcandre.lureau@redhat.com>
Cc: "Daniel P. Berrangé" <berrange@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: "Philippe Mathieu-Daudé" <philmd@linaro.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Song Gao <gaosong@loongson.cn>
Cc: Xiaojuan Yang <yangxiaojuan@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: xianglai li <lixianglai@loongson.cn>
---
 target/loongarch/kvm.c | 131 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)
 create mode 100644 target/loongarch/kvm.c

diff --git a/target/loongarch/kvm.c b/target/loongarch/kvm.c
new file mode 100644
index 0000000000..0d67322fd9
--- /dev/null
+++ b/target/loongarch/kvm.c
@@ -0,0 +1,131 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * QEMU LoongArch KVM
+ *
+ * Copyright (c) 2023 Loongson Technology Corporation Limited
+ */
+
+#include "qemu/osdep.h"
+#include <sys/ioctl.h>
+#include <linux/kvm.h>
+
+#include "qemu/timer.h"
+#include "qemu/error-report.h"
+#include "qemu/main-loop.h"
+#include "sysemu/sysemu.h"
+#include "sysemu/kvm.h"
+#include "sysemu/kvm_int.h"
+#include "hw/pci/pci.h"
+#include "exec/memattrs.h"
+#include "exec/address-spaces.h"
+#include "hw/boards.h"
+#include "hw/irq.h"
+#include "qemu/log.h"
+#include "hw/loader.h"
+#include "migration/migration.h"
+#include "sysemu/runstate.h"
+#include "cpu-csr.h"
+#include "kvm_loongarch.h"
+
+static bool cap_has_mp_state;
+const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
+    KVM_CAP_LAST_INFO
+};
+
+int kvm_arch_get_registers(CPUState *cs)
+{
+    return 0;
+}
+int kvm_arch_put_registers(CPUState *cs, int level)
+{
+    return 0;
+}
+
+int kvm_arch_init_vcpu(CPUState *cs)
+{
+    return 0;
+}
+
+int kvm_arch_destroy_vcpu(CPUState *cs)
+{
+    return 0;
+}
+
+unsigned long kvm_arch_vcpu_id(CPUState *cs)
+{
+    return cs->cpu_index;
+}
+
+int kvm_arch_release_virq_post(int virq)
+{
+    return 0;
+}
+
+int kvm_arch_msi_data_to_gsi(uint32_t data)
+{
+    abort();
+}
+
+int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
+                             uint64_t address, uint32_t data, PCIDevice *dev)
+{
+    return 0;
+}
+
+int kvm_arch_add_msi_route_post(struct kvm_irq_routing_entry *route,
+                                int vector, PCIDevice *dev)
+{
+    return 0;
+}
+
+void kvm_arch_init_irq_routing(KVMState *s)
+{
+}
+
+int kvm_arch_get_default_type(MachineState *ms)
+{
+    return 0;
+}
+
+int kvm_arch_init(MachineState *ms, KVMState *s)
+{
+    return 0;
+}
+
+int kvm_arch_irqchip_create(KVMState *s)
+{
+    return 0;
+}
+
+void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
+{
+}
+
+MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
+{
+    return MEMTXATTRS_UNSPECIFIED;
+}
+
+int kvm_arch_process_async_events(CPUState *cs)
+{
+    return cs->halted;
+}
+
+bool kvm_arch_stop_on_emulation_error(CPUState *cs)
+{
+    return true;
+}
+
+bool kvm_arch_cpu_check_are_resettable(void)
+{
+    return true;
+}
+
+int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
+{
+    return 0;
+}
+
+void kvm_arch_accel_class_init(ObjectClass *oc)
+{
+}
-- 
2.39.1

