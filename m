Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7A917E9BD
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 21:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgCIUJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 16:09:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:35230 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgCIUJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 16:09:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Mar 2020 13:09:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,534,1574150400"; 
   d="scan'208";a="245452413"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 09 Mar 2020 13:09:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: Bump apicv timeout to 30s to play nice with running in L1
Date:   Mon,  9 Mar 2020 13:09:15 -0700
Message-Id: <20200309200915.17244-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Increase the timeout for the apicv testcase to 30 seconds to avoid false
positives on the timeout when running the test in L1.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f2401eb..828a62a 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -276,7 +276,7 @@ file = vmx.flat
 extra_params = -cpu host,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test"
 arch = x86_64
 groups = vmx
-timeout = 10
+timeout = 30
 
 [vmx_apic_passthrough_thread]
 file = vmx.flat
-- 
2.24.1

