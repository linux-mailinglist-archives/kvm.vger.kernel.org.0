Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 634EE107AAF
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfKVWkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:40:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:61230 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbfKVWkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:40:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:40:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409029712"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:40:05 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] KVM: x86: Allow userspace to disable the kernel's emulator
Date:   Fri, 22 Nov 2019 14:39:59 -0800
Message-Id: <20191122223959.13545-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122223959.13545-1-sean.j.christopherson@intel.com>
References: <20191122223959.13545-1-sean.j.christopherson@intel.com>
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
index 312dd5f8172c..4e5a27874656 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -155,7 +155,8 @@ EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
 static bool __read_mostly force_emulation_prefix = false;
 module_param(force_emulation_prefix, bool, S_IRUGO);
 
-static const bool enable_emulator = true;
+static bool __read_mostly enable_emulator = true;
+module_param_named(emulator, enable_emulator, bool, 0440);
 
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
-- 
2.24.0

