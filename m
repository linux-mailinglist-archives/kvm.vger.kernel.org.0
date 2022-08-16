Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA30C595C88
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 14:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbiHPM6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 08:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiHPM6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 08:58:19 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8B34C616;
        Tue, 16 Aug 2022 05:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660654695; x=1692190695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T9bRazRIYrBvNZKrb/osFhdFpmVXzwd4IiJTTKTm3gI=;
  b=j1BcE84jHm7jrVKROimDnpe5aQ2elB5wndUlxAtk6syeLeGJZYP426AZ
   DkpZ0E46snychLnlTnIoHBMyBo3g8XnVkMYtRCELg7ZuDMuLHzz7Saa3q
   IFrHCdtBeqyHaglIvyUHVw5tETMQMRhCkqeRXZLr0Nr+Es7JCByHAlRNu
   W3yryf3xtm+gaERjgtZ8yP8pg+5X2rGWuY5q4F4yG+jye0eP6AdfCc97p
   Y/VWpdX8J9bqocio05f3f7LcvNsq3V1D51kD6kGfsfSCU3n1ompkgxNXc
   SIpW3xLXGkQLUFY0qNfkAlKKvs3HVFp8JTt364uQmow8vi7cH0Ab9sCPB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="279170181"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="279170181"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 05:58:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="667099398"
Received: from chaop.bj.intel.com ([10.240.193.75])
  by fmsmga008.fm.intel.com with ESMTP; 16 Aug 2022 05:58:08 -0700
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: Rename KVM_PRIVATE_MEM_SLOTS to KVM_INTERNAL_MEM_SLOTS
Date:   Tue, 16 Aug 2022 20:53:21 +0800
Message-Id: <20220816125322.1110439-2-chao.p.peng@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220816125322.1110439-1-chao.p.peng@linux.intel.com>
References: <20220816125322.1110439-1-chao.p.peng@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_INTERNAL_MEM_SLOTS better reflects the fact those slots are KVM
internally used (invisible to userspace) and avoids confusion to future
private slots that can have different meaning.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
---
 arch/mips/include/asm/kvm_host.h | 2 +-
 arch/x86/include/asm/kvm_host.h  | 2 +-
 include/linux/kvm_host.h         | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 717716cc51c5..45a978c805bc 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -85,7 +85,7 @@
 
 #define KVM_MAX_VCPUS		16
 /* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS	0
+#define KVM_INTERNAL_MEM_SLOTS	0
 
 #define KVM_HALT_POLL_NS_DEFAULT 500000
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e8281d64a431..71a24625d143 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -53,7 +53,7 @@
 #define KVM_MAX_VCPU_IDS (KVM_MAX_VCPUS * KVM_VCPU_ID_RATIO)
 
 /* memory slots that are not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS 3
+#define KVM_INTERNAL_MEM_SLOTS 3
 
 #define KVM_HALT_POLL_NS_DEFAULT 200000
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1c480b1821e1..fd5c3b4715f8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -656,12 +656,12 @@ struct kvm_irq_routing_table {
 };
 #endif
 
-#ifndef KVM_PRIVATE_MEM_SLOTS
-#define KVM_PRIVATE_MEM_SLOTS 0
+#ifndef KVM_INTERNAL_MEM_SLOTS
+#define KVM_INTERNAL_MEM_SLOTS 0
 #endif
 
 #define KVM_MEM_SLOTS_NUM SHRT_MAX
-#define KVM_USER_MEM_SLOTS (KVM_MEM_SLOTS_NUM - KVM_PRIVATE_MEM_SLOTS)
+#define KVM_USER_MEM_SLOTS (KVM_MEM_SLOTS_NUM - KVM_INTERNAL_MEM_SLOTS)
 
 #ifndef __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
 static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
-- 
2.25.1

