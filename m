Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DBC2D221F
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 05:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgLHEfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 23:35:52 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9393 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgLHEfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 23:35:51 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CqnQP2rH8z7BGD;
        Tue,  8 Dec 2020 12:34:37 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 12:34:59 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC:     <corbet@lwn.net>, <wanghaibin.wang@huawei.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: Documentation: Update description of KVM_{GET,CLEAR}_DIRTY_LOG
Date:   Tue, 8 Dec 2020 12:34:39 +0800
Message-ID: <20201208043439.895-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update various words, including the wrong parameter name and the vague
description of the usage of "slot" field.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 Documentation/virt/kvm/api.rst | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 70254eaa5229..0eb236737f80 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -360,10 +360,9 @@ since the last call to this ioctl.  Bit 0 is the first page in the
 memory slot.  Ensure the entire structure is cleared to avoid padding
 issues.
 
-If KVM_CAP_MULTI_ADDRESS_SPACE is available, bits 16-31 specifies
-the address space for which you want to return the dirty bitmap.
-They must be less than the value that KVM_CHECK_EXTENSION returns for
-the KVM_CAP_MULTI_ADDRESS_SPACE capability.
+If KVM_CAP_MULTI_ADDRESS_SPACE is available, bits 16-31 of slot field specifies
+the address space for which you want to return the dirty bitmap.  See
+KVM_SET_USER_MEMORY_REGION for details on the usage of slot field.
 
 The bits in the dirty bitmap are cleared before the ioctl returns, unless
 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 is enabled.  For more information,
@@ -4427,7 +4426,7 @@ to I/O ports.
 :Capability: KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2
 :Architectures: x86, arm, arm64, mips
 :Type: vm ioctl
-:Parameters: struct kvm_dirty_log (in)
+:Parameters: struct kvm_clear_dirty_log (in)
 :Returns: 0 on success, -1 on error
 
 ::
@@ -4454,10 +4453,9 @@ in KVM's dirty bitmap, and dirty tracking is re-enabled for that page
 (for example via write-protection, or by clearing the dirty bit in
 a page table entry).
 
-If KVM_CAP_MULTI_ADDRESS_SPACE is available, bits 16-31 specifies
-the address space for which you want to return the dirty bitmap.
-They must be less than the value that KVM_CHECK_EXTENSION returns for
-the KVM_CAP_MULTI_ADDRESS_SPACE capability.
+If KVM_CAP_MULTI_ADDRESS_SPACE is available, bits 16-31 of slot field specifies
+the address space for which you want to clear the dirty status.  See
+KVM_SET_USER_MEMORY_REGION for details on the usage of slot field.
 
 This ioctl is mostly useful when KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2
 is enabled; for more information, see the description of the capability.
-- 
2.19.1

