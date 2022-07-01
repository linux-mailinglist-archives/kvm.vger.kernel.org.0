Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5495562B0B
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 07:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiGAFsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 01:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiGAFse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 01:48:34 -0400
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3F32F2;
        Thu, 30 Jun 2022 22:48:29 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id VCX00123;
        Fri, 01 Jul 2022 13:48:23 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201607.home.langchao.com (10.100.2.7) with Microsoft SMTP Server id
 15.1.2507.9; Fri, 1 Jul 2022 13:48:22 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <x86@kernel.org>, <hpa@zytor.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] KVM: x86/mmu: Return true/false from bool function
Date:   Fri, 1 Jul 2022 00:21:22 -0400
Message-ID: <20220701042122.5273-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   20227011348236a2f1c9ffd7be92f9e8e0b4b6e725e20
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return boolean values ("true" or "false") instead of integer values
from bool function.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bfb50262fd37..572e0c487376 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1024,7 +1024,7 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_memory_cache *mc;
 
 	mc = &vcpu->arch.mmu_pte_list_desc_cache;
-	return kvm_mmu_memory_cache_nr_free_objects(mc);
+	return !!kvm_mmu_memory_cache_nr_free_objects(mc);
 }
 
 static void rmap_remove(struct kvm *kvm, u64 *spte)
-- 
2.27.0

