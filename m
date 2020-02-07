Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1142155D0F
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 18:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgBGRmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 12:42:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:13003 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgBGRmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 12:42:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 09:42:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="312095678"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 07 Feb 2020 09:42:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 3/4] nVMX: Mark bit 39 of MSR_IA32_VMX_EPT_VPID_CAP as reserved
Date:   Fri,  7 Feb 2020 09:42:43 -0800
Message-Id: <20200207174244.6590-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207174244.6590-1-sean.j.christopherson@intel.com>
References: <20200207174244.6590-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove bit 39, which is defined as reserved in Intel's SDM, from the set
of allowed-1 bits in MSR_IA32_VMX_EPT_VPID_CAP.

Fixes: 69c8d31 ("VMX: Validate capability MSRs")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 3a99d27..ac4aa56 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1550,7 +1550,6 @@ static void test_vmx_caps(void)
 		    EPT_CAP_INVEPT_SINGLE |
 		    EPT_CAP_INVEPT_ALL |
 		    VPID_CAP_INVVPID |
-		    (1ull << 39) |
 		    VPID_CAP_INVVPID_ADDR |
 		    VPID_CAP_INVVPID_CXTGLB |
 		    VPID_CAP_INVVPID_ALL |
-- 
2.24.1

