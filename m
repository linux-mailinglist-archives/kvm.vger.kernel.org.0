Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E2E38F845
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 04:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhEYCpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 22:45:14 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5693 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhEYCpO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 22:45:14 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fpyxc6Q55z1BRNV;
        Tue, 25 May 2021 10:40:52 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 10:43:43 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 10:43:43 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <x86@kernel.org>, <kvm@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: x86/mmu: Remove the repeated declaration
Date:   Tue, 25 May 2021 10:43:35 +0800
Message-ID: <1621910615-29985-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Function 'is_nx_huge_page_enabled' is declared twice, remove the
repeated declaration.

Cc: Ben Gardon <bgardon@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d64ccb417c60..54c6e6193ff2 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -158,8 +158,6 @@ int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
 				kvm_pfn_t *pfnp, int *goal_levelp);
 
-bool is_nx_huge_page_enabled(void);
-
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
-- 
2.7.4

