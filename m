Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53011353349
	for <lists+kvm@lfdr.de>; Sat,  3 Apr 2021 11:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbhDCJUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Apr 2021 05:20:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15537 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236587AbhDCJUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Apr 2021 05:20:25 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FCBCQ5t5kzNrcc;
        Sat,  3 Apr 2021 17:17:38 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Sat, 3 Apr 2021 17:20:11 +0800
From:   Zeng Tao <prime.zeng@hisilicon.com>
To:     <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <raspl@de.ibm.com>, <linuxarm@huawei.com>,
        Zeng Tao <prime.zeng@hisilicon.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] tools/kvm_stat: fix out of date aarch64 kvm_exit reason definations
Date:   Sat, 3 Apr 2021 17:17:31 +0800
Message-ID: <1617441453-15560-1-git-send-email-prime.zeng@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Aarch64 kvm exit reason defination is out of date for some time, so in
this patch:
1. Sync some newly introduced or missing EC definations.
2. Change the WFI to WFx.
3. Fix the comment.

Not all the definations are used or usable for aarch64 kvm, but it's
better to keep align across the whole kernel.

Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
---
 tools/kvm/kvm_stat/kvm_stat | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index b0bf56c..63d87fd 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -154,17 +154,19 @@ SVM_EXIT_REASONS = {
     'NPF':            0x400,
 }
 
-# EC definition of HSR (from arch/arm64/include/asm/kvm_arm.h)
+# EC definition of HSR (from arch/arm64/include/asm/esr.h)
 AARCH64_EXIT_REASONS = {
     'UNKNOWN':      0x00,
-    'WFI':          0x01,
+    'WFx':          0x01,
     'CP15_32':      0x03,
     'CP15_64':      0x04,
     'CP14_MR':      0x05,
     'CP14_LS':      0x06,
     'FP_ASIMD':     0x07,
     'CP10_ID':      0x08,
+    'PAC':          0x09,
     'CP14_64':      0x0C,
+    'BTI':          0x0D,
     'ILL_ISS':      0x0E,
     'SVC32':        0x11,
     'HVC32':        0x12,
@@ -173,6 +175,10 @@ AARCH64_EXIT_REASONS = {
     'HVC64':        0x16,
     'SMC64':        0x17,
     'SYS64':        0x18,
+    'SVE':          0x19,
+    'ERET':         0x1a,
+    'FPAC':         0x1c,
+    'IMP_DEF':      0x1f,
     'IABT':         0x20,
     'IABT_HYP':     0x21,
     'PC_ALIGN':     0x22,
-- 
2.8.1

