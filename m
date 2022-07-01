Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22371562C12
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 08:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbiGAG4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 02:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGAG4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 02:56:34 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 385C561D4D;
        Thu, 30 Jun 2022 23:56:34 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 7612B1E80D22;
        Fri,  1 Jul 2022 14:55:05 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 05PgB2EeQt6V; Fri,  1 Jul 2022 14:55:02 +0800 (CST)
Received: from localhost.localdomain (unknown [112.65.12.78])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 1CD841E80D09;
        Fri,  1 Jul 2022 14:55:00 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] KVM: LAPIC: Fix a spelling mistake in comments
Date:   Fri,  1 Jul 2022 14:55:58 +0800
Message-Id: <20220701065558.9073-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a typo (writeable) in kvm_apic_match_physical_addr's comments.
Fix it.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0e68b4c937fc..ace161bf3744 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -808,7 +808,7 @@ static bool kvm_apic_match_physical_addr(struct kvm_lapic *apic, u32 mda)
 	 * Hotplug hack: Make LAPIC in xAPIC mode also accept interrupts as if
 	 * it were in x2APIC mode.  Hotplugged VCPUs start in xAPIC mode and
 	 * this allows unique addressing of VCPUs with APIC ID over 0xff.
-	 * The 0xff condition is needed because writeable xAPIC ID.
+	 * The 0xff condition is needed because writable xAPIC ID.
 	 */
 	if (kvm_x2apic_id(apic) > 0xff && mda == kvm_x2apic_id(apic))
 		return true;
-- 
2.25.1

