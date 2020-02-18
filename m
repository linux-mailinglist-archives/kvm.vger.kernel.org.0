Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F89816372D
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgBRXaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:30:03 -0500
Received: from mga04.intel.com ([192.55.52.120]:38644 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728090AbgBRXaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:30:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:29:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="282936694"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2020 15:29:58 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/13] KVM: x86: Allow userspace to disable the kernel's emulator
Date:   Tue, 18 Feb 2020 15:29:53 -0800
Message-Id: <20200218232953.5724-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218232953.5724-1-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose the emulator control to userspace via a module param.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f9134e1104c2..ca3aa185f5ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -159,7 +159,8 @@ EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
 static bool __read_mostly force_emulation_prefix = false;
 module_param(force_emulation_prefix, bool, S_IRUGO);
 
-static const bool enable_emulator = true;
+static bool __read_mostly enable_emulator = true;
+module_param_named(emulator, enable_emulator, bool, 0440);
 
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
-- 
2.24.1

