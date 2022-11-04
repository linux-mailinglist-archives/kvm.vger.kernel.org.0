Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94EEF618E3B
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 03:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiKDCZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 22:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiKDCZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 22:25:46 -0400
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A9921A0;
        Thu,  3 Nov 2022 19:25:44 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id YDD00038;
        Fri, 04 Nov 2022 10:25:38 +0800
Received: from localhost.localdomain (10.200.104.82) by
 jtjnmail201602.home.langchao.com (10.100.2.2) with Microsoft SMTP Server id
 15.1.2507.12; Fri, 4 Nov 2022 10:25:38 +0800
From:   Deming Wang <wangdeming@inspur.com>
To:     <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <x86@kernel.org>
CC:     <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] KVM: x86: replace IS_ERR() with IS_ERR_VALUE()
Date:   Thu, 3 Nov 2022 22:25:35 -0400
Message-ID: <20221104022535.1633-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.200.104.82]
tUid:   202211041025380366107cf9ae0027b9ac0461f9b16739
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid typecasts that are needed for IS_ERR() and use IS_ERR_VALUE()
instead.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 521b433f978c..8f0043831db7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12488,7 +12488,7 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 		 */
 		hva = vm_mmap(NULL, 0, size, PROT_READ | PROT_WRITE,
 			      MAP_SHARED | MAP_ANONYMOUS, 0);
-		if (IS_ERR((void *)hva))
+		if (IS_ERR_VALUE(hva))
 			return (void __user *)hva;
 	} else {
 		if (!slot || !slot->npages)
-- 
2.27.0

