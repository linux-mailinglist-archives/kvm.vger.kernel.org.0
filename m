Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C1E6C41C4
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 05:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCVE6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 00:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCVE6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 00:58:39 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD0B2798B
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 21:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679461116; x=1710997116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CXAQoa4L+I8g8RoevRzmm3sZT2HOTX6tqIRXbCNKSgY=;
  b=aZEemSVUlL4Nqok5j9+6oSMDEaDjZodiPs+Xn+xcGP8LTNX+OKeCCrdj
   4PkDt3AZUMxxKqSzMo6qebJnQIvvOdZqVS3NkBd8AP99iJomRuKv4kQc1
   3F3UL8s9Ah3dgcMpo1YrIgPHK5mylf+wWJIYT3/2Nv7uG735I/mUjFfb1
   SCU9rB3BpCz9Y4ne94H830oKrdiKLPAcOhEIs1VQTV7Z24HvO68Lvkjvv
   EbFm0taWbGGT85d7tOiXd4Hfc0up3VvwDiJ1TELCJ0bK1gKvJv9P/ZW/T
   eip6CXfssMGjdk8XEIRZCdTcf5mm7Gm1GhnaH9xWrJPlCaWVnrHwjzRLO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="327507209"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="327507209"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:58:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="750908548"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="750908548"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.235])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:58:33 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, robert.hu@linux.intel.com
Subject: [PATCH 4/4] KVM: x86: Change return type of is_long_mode() to bool
Date:   Wed, 22 Mar 2023 12:58:24 +0800
Message-Id: <20230322045824.22970-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230322045824.22970-1-binbin.wu@linux.intel.com>
References: <20230322045824.22970-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change return type of is_long_mode() to bool to avoid implicit cast.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/x86.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 577b82358529..203fb6640b5b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -126,12 +126,12 @@ static inline bool is_protmode(struct kvm_vcpu *vcpu)
 	return kvm_is_cr0_bit_set(vcpu, X86_CR0_PE);
 }
 
-static inline int is_long_mode(struct kvm_vcpu *vcpu)
+static inline bool is_long_mode(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
-	return vcpu->arch.efer & EFER_LMA;
+	return !!(vcpu->arch.efer & EFER_LMA);
 #else
-	return 0;
+	return false;
 #endif
 }
 
-- 
2.25.1

