Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E0977C8EE
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 09:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbjHOH4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 03:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbjHOH4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 03:56:01 -0400
Received: from mail.nfschina.com (unknown [42.101.60.195])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 237EADD;
        Tue, 15 Aug 2023 00:55:58 -0700 (PDT)
Received: from localhost.localdomain (unknown [219.141.250.2])
        by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 8116460280B60;
        Tue, 15 Aug 2023 15:55:16 +0800 (CST)
X-MD-Sfrom: zeming@nfschina.com
X-MD-SrcIP: 219.141.250.2
From:   Li zeming <zeming@nfschina.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li zeming <zeming@nfschina.com>
Subject: [PATCH] x86: kvm: x86: Remove unnecessary initial values of variables
Date:   Thu, 17 Aug 2023 08:26:31 +0800
Message-Id: <20230817002631.2885-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_24_48,
        RDNS_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

bitmap and khz is assigned first, so it does not need to initialize the
assignment.

Signed-off-by: Li zeming <zeming@nfschina.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 278dbd37dab2..62715bb4754d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6529,7 +6529,7 @@ static void kvm_free_msr_filter(struct kvm_x86_msr_filter *msr_filter)
 static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
 			      struct kvm_msr_filter_range *user_range)
 {
-	unsigned long *bitmap = NULL;
+	unsigned long *bitmap;
 	size_t bitmap_size;
 
 	if (!user_range->nmsrs)
@@ -9169,7 +9169,7 @@ static int kvmclock_cpu_down_prep(unsigned int cpu)
 static void tsc_khz_changed(void *data)
 {
 	struct cpufreq_freqs *freq = data;
-	unsigned long khz = 0;
+	unsigned long khz;
 
 	WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_CONSTANT_TSC));
 
-- 
2.18.2

