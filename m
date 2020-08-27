Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456322541FB
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 11:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgH0JXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 05:23:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10327 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728401AbgH0JWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 05:22:46 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A9564DBC4605A4C958E9;
        Thu, 27 Aug 2020 17:22:42 +0800 (CST)
Received: from huawei.com (10.174.187.31) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 17:22:32 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <sagark@eecs.berkeley.edu>, <kbastian@mail.uni-paderborn.de>,
        <victor.zhangxiaofeng@huawei.com>, <wu.wubin@huawei.com>,
        <zhang.zhanghailiang@huawei.com>, <dengkai1@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC v3 09/14] target/riscv: Add host cpu type
Date:   Thu, 27 Aug 2020 17:21:32 +0800
Message-ID: <20200827092137.479-10-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200827092137.479-1-jiangyifei@huawei.com>
References: <20200827092137.479-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.187.31]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, host cpu is inherited simply.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
---
 target/riscv/cpu.c | 6 ++++++
 target/riscv/cpu.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 266e70cc47..d8c32a8f84 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -179,6 +179,10 @@ static void rv32_imafcu_nommu_cpu_init(Object *obj)
 
 #endif
 
+static void riscv_host_cpu_init(Object *obj)
+{
+}
+
 static ObjectClass *riscv_cpu_class_by_name(const char *cpu_model)
 {
     ObjectClass *oc;
@@ -635,10 +639,12 @@ static const TypeInfo riscv_cpu_type_infos[] = {
     DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_E31,       rvxx_sifive_e_cpu_init),
     DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_E34,       rv32_imafcu_nommu_cpu_init),
     DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_U34,       rvxx_sifive_u_cpu_init),
+    DEFINE_CPU(TYPE_RISCV_CPU_HOST,             riscv_host_cpu_init),
 #elif defined(TARGET_RISCV64)
     DEFINE_CPU(TYPE_RISCV_CPU_BASE64,           riscv_base_cpu_init),
     DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_E51,       rvxx_sifive_e_cpu_init),
     DEFINE_CPU(TYPE_RISCV_CPU_SIFIVE_U54,       rvxx_sifive_u_cpu_init),
+    DEFINE_CPU(TYPE_RISCV_CPU_HOST,             riscv_host_cpu_init),
 #endif
 };
 
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index d4cafe37e1..7795e7ae13 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -42,6 +42,7 @@
 #define TYPE_RISCV_CPU_SIFIVE_E51       RISCV_CPU_TYPE_NAME("sifive-e51")
 #define TYPE_RISCV_CPU_SIFIVE_U34       RISCV_CPU_TYPE_NAME("sifive-u34")
 #define TYPE_RISCV_CPU_SIFIVE_U54       RISCV_CPU_TYPE_NAME("sifive-u54")
+#define TYPE_RISCV_CPU_HOST             RISCV_CPU_TYPE_NAME("host")
 
 #define RV32 ((target_ulong)1 << (TARGET_LONG_BITS - 2))
 #define RV64 ((target_ulong)2 << (TARGET_LONG_BITS - 2))
-- 
2.19.1


