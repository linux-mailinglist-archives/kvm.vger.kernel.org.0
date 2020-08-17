Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8DE24651A
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 13:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgHQLIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 07:08:07 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9746 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbgHQLIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 07:08:05 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DFFEC183E6E7D710B54F;
        Mon, 17 Aug 2020 19:08:00 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 19:07:51 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
        "Andrew Jones" <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Will Deacon" <will@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v2 1/2] KVM: arm64: Some fixes of PV-time interface document
Date:   Mon, 17 Aug 2020 19:07:27 +0800
Message-ID: <20200817110728.12196-2-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200817110728.12196-1-zhukeqian1@huawei.com>
References: <20200817110728.12196-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename PV_FEATURES to PV_TIME_FEATURES.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 Documentation/virt/kvm/arm/pvtime.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm/pvtime.rst
index 687b60d..94bffe2 100644
--- a/Documentation/virt/kvm/arm/pvtime.rst
+++ b/Documentation/virt/kvm/arm/pvtime.rst
@@ -3,7 +3,7 @@
 Paravirtualized time support for arm64
 ======================================
 
-Arm specification DEN0057/A defines a standard for paravirtualised time
+Arm specification DEN0057/A defines a standard for paravirtualized time
 support for AArch64 guests:
 
 https://developer.arm.com/docs/den0057/a
@@ -19,8 +19,8 @@ Two new SMCCC compatible hypercalls are defined:
 
 These are only available in the SMC64/HVC64 calling convention as
 paravirtualized time is not available to 32 bit Arm guests. The existence of
-the PV_FEATURES hypercall should be probed using the SMCCC 1.1 ARCH_FEATURES
-mechanism before calling it.
+the PV_TIME_FEATURES hypercall should be probed using the SMCCC 1.1
+ARCH_FEATURES mechanism before calling it.
 
 PV_TIME_FEATURES
     ============= ========    ==========
-- 
1.8.3.1

