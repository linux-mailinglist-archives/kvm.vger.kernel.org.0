Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E130354CFC
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 08:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239459AbhDFGff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 02:35:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15484 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238603AbhDFGff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 02:35:35 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FDyQJ5nhYzvQlY;
        Tue,  6 Apr 2021 14:33:12 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 14:35:13 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: [PATCH] KVM: x86: Remove unused function declaration
Date:   Tue, 6 Apr 2021 14:35:04 +0800
Message-ID: <20210406063504.17552-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_mmu_slot_largepage_remove_write_access() is decared but not used,
just remove it.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/x86/include/asm/kvm_host.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3768819693e5..9c0af0971c9f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1440,8 +1440,6 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot);
-void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
-					struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
-- 
2.23.0

