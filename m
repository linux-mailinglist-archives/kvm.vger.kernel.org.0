Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B8C6F01A5
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 09:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243001AbjD0H04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 03:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239395AbjD0H0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 03:26:53 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0C80E45
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 00:26:51 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Cxd+m6I0pk4XcBAA--.2534S3;
        Thu, 27 Apr 2023 15:26:50 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axy7K1I0pk9Ec+AA--.18880S4;
        Thu, 27 Apr 2023 15:26:50 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn, philmd@linaro.org,
        richard.henderson@linaro.org, peter.maydell@linaro.org
Subject: [PATCH RFC v2 2/9] target/loongarch: Define some kvm_arch interfaces
Date:   Thu, 27 Apr 2023 15:26:38 +0800
Message-Id: <20230427072645.3368102-3-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axy7K1I0pk9Ec+AA--.18880S4
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxGrykuw1Dtw15Kw4rZr15CFg_yoW5CF1fpF
        4kCFn5Zr48J3y3J3s3Aws8XF15Zrs7u347XryxW342yr12kF1kJrWkKwsrJFWfGrZFga13
        XFnxJFs09w12qrJanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bcAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
        0267AKxVWxJr0_GcWln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF
        6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8V
        WrMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWU
        twCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26rWl4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
        67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
        8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
        wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8Jr0_Cr1UMIIF0xvEx4A2jsIEc7CjxV
        AFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvj4R_gAwDUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define some functions in target/loongarch/kvm.c, such as
kvm_arch_put_registers, kvm_arch_get_registers and
kvm_arch_handle_exit, etc. which are needed by kvm/kvm-all.c.
Now the most functions has no content and they will be
implemented in the next patches.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 target/loongarch/kvm.c | 126 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 target/loongarch/kvm.c

diff --git a/target/loongarch/kvm.c b/target/loongarch/kvm.c
new file mode 100644
index 0000000000..24327aaf71
--- /dev/null
+++ b/target/loongarch/kvm.c
@@ -0,0 +1,126 @@
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
2.31.1

