Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8F34FB5B5
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 10:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343611AbiDKIQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 04:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiDKIQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 04:16:56 -0400
X-Greylist: delayed 128 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Apr 2022 01:14:36 PDT
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D1D33A05;
        Mon, 11 Apr 2022 01:14:34 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id GEY00121;
        Mon, 11 Apr 2022 16:12:21 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201604.home.langchao.com (10.100.2.4) with Microsoft SMTP Server id
 15.1.2308.21; Mon, 11 Apr 2022 16:12:20 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] KVM: x86: fix the return type of kvm_age_rmapp
Date:   Mon, 11 Apr 2022 04:12:18 -0400
Message-ID: <20220411081218.2296-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   2022411161221e79c7889c96454f924143db2f61e5534
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change the return type of kvm_age_rmapp to "bool"

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c623019929a7..799ab899f552 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1572,7 +1572,7 @@ static bool kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
-	int young = 0;
+	bool young = false;
 
 	for_each_rmap_spte(rmap_head, &iter, sptep)
 		young |= mmu_spte_age(sptep);
-- 
2.27.0

