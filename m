Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40B826DB34
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 14:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgIQMLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 08:11:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57040 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgIQMKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 08:10:02 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 138A631110B1340EA5B1;
        Thu, 17 Sep 2020 20:10:00 +0800 (CST)
Received: from localhost.localdomain (10.175.104.175) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 20:09:53 +0800
From:   Peng Liang <liangpeng10@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <maz@kernel.org>, <will@kernel.org>,
        <drjones@redhat.com>, <zhang.zhanghailiang@huawei.com>,
        <xiexiangyou@huawei.com>, Peng Liang <liangpeng10@huawei.com>
Subject: [RFC v2 7/7] kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
Date:   Thu, 17 Sep 2020 20:01:01 +0800
Message-ID: <20200917120101.3438389-8-liangpeng10@huawei.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200917120101.3438389-1-liangpeng10@huawei.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add KVM_CAP_ARM_CPU_FEATURE extension for userpace to check whether KVM
supports to set CPU features in AArch64.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 Documentation/virt/kvm/api.rst | 8 ++++++++
 arch/arm64/kvm/arm.c           | 1 +
 include/uapi/linux/kvm.h       | 1 +
 3 files changed, 10 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d2b733dc7892..50214ed8f50e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6173,3 +6173,11 @@ specific interfaces must be consistent, i.e. if one says the feature
 is supported, than the other should as well and vice versa.  For arm64
 see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
 For x86 see Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".
+
+8.25 KVM_CAP_ARM_CPU_FEATURE
+-----------------------------------
+
+:Architecture: arm64
+
+This capability indicates that userspace can modify the ID registers via
+KVM_SET_ONE_REG ioctl.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6d961e192268..918a7a56b224 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -178,6 +178,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
 	case KVM_CAP_ARM_NISV_TO_USER:
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
+	case KVM_CAP_ARM_CPU_FEATURE:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7d8eced6f459..12356beadd5a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1037,6 +1037,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
 #define KVM_CAP_STEAL_TIME 187
+#define KVM_CAP_ARM_CPU_FEATURE 188
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.26.2

