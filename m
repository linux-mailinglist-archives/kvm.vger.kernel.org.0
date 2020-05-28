Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2E11E53C8
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 04:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgE1CQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 22:16:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:65126 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgE1CQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 22:16:25 -0400
IronPort-SDR: 0s3OLJt46aCvM27fGNn0BJuSuOaDIevXtwxSmwTobwk3RGkDAZV9RsiT/OhHh5SYSsWQJZAxOG
 RVy5vTKx27BQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 19:16:25 -0700
IronPort-SDR: KxXTxRiR8qvwMya+n1jxtQezw59GWa09vyxuwlNF/iejGh6wo2QsaRZyeSxRzsF+P2meBPWdFv
 zSoaz2qjtxQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="442767711"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 27 May 2020 19:16:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM: selftests: Add .gitignore entry for KVM_SET_GUEST_DEBUG test
Date:   Wed, 27 May 2020 19:16:24 -0700
Message-Id: <20200528021624.28348-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the KVM_SET_GUEST_DEBUG test's output binary to .gitignore.

Fixes: 449aa906e67e ("KVM: selftests: Add KVM_SET_GUEST_DEBUG test")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/kvm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 222e50104296a..d0079fce1764f 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -3,6 +3,7 @@
 /s390x/resets
 /s390x/sync_regs_test
 /x86_64/cr4_cpuid_sync_test
+/x86_64/debug_regs
 /x86_64/evmcs_test
 /x86_64/hyperv_cpuid
 /x86_64/mmio_warning_test
-- 
2.26.0

