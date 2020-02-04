Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7840615214F
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 20:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgBDTsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 14:48:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:7061 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727314AbgBDTsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 14:48:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 11:48:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,402,1574150400"; 
   d="scan'208";a="224405634"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 04 Feb 2020 11:48:10 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: Use "-cpu host" for PCID tests
Date:   Tue,  4 Feb 2020 11:48:09 -0800
Message-Id: <20200204194809.2077-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the host CPU model for the PCID tests to allow testing the various
combinations of PCID and INVPCID enabled/disabled without having to
manually change the kvm-unit-tests command line.  I.e. give users the
option of changing the command line *OR* running on a (virtual) CPU
with or without PCID and/or INVPCID.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index aae1523..25f4535 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -228,7 +228,7 @@ extra_params = --append "10000000 `date +%s`"
 
 [pcid]
 file = pcid.flat
-extra_params = -cpu qemu64,+pcid
+extra_params = -cpu host
 arch = x86_64
 
 [rdpru]
-- 
2.24.1

