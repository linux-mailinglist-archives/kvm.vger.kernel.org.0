Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99ED4155D14
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 18:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgBGRmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 12:42:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:13003 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgBGRms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 12:42:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 09:42:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="312095681"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 07 Feb 2020 09:42:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 4/4] nVMX: Extend EPT cap MSR test to allow 5-level EPT
Date:   Fri,  7 Feb 2020 09:42:44 -0800
Message-Id: <20200207174244.6590-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207174244.6590-1-sean.j.christopherson@intel.com>
References: <20200207174244.6590-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify the EMSR_IA32_VMX_EPT_VPID_CAP test to mark the 5-level EPT cap
bit as allowed-1. KVM is in the process of gaining support for 5-level
nested EPT[*].

[*] https://lkml.kernel.org/r/20200206220836.22743-1-sean.j.christopherson@intel.com

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/vmx.c b/x86/vmx.c
index ac4aa56..a15c2be 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1540,6 +1540,7 @@ static void test_vmx_caps(void)
 	fixed0 = -1ull;
 	fixed0 &= ~(EPT_CAP_WT |
 		    EPT_CAP_PWL4 |
+		    EPT_CAP_PWL5 |
 		    EPT_CAP_UC |
 		    EPT_CAP_WB |
 		    EPT_CAP_2M_PAGE |
-- 
2.24.1

