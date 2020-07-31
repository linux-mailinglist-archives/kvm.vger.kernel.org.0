Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC9B233D53
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 04:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731269AbgGaCmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 22:42:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:47518 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731265AbgGaCmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 22:42:40 -0400
IronPort-SDR: NlUGTou+5+FTjuvTS8XCGOIfGTVL6J86bnOWSXKwEDqOX4t+yvzKK/3RGGAaEpb0eDkkmeilcU
 xhGk8bgV9BZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131290117"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="131290117"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 19:42:40 -0700
IronPort-SDR: ql0sVBBsn9/EE9c6/ER1wChF2mCyoxvgnvktcDMJuXvEM8RzrVWzymOeM+vioxKBuiqGWxylRf
 tu8Eg00Pc0xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="304805968"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2020 19:42:37 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, xiaoyao.li@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 3/9] KVM:x86: Substitute kvm_update_cpuid_runtime() with kvm_xcr0_update_cpuid() in __kvm_set_xcr()
Date:   Fri, 31 Jul 2020 10:42:21 +0800
Message-Id: <1596163347-18574-4-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
References: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95ef629..263ba47 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -943,7 +943,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	vcpu->arch.xcr0 = xcr0;
 
 	if ((xcr0 ^ old_xcr0) & XFEATURE_MASK_EXTEND)
-		kvm_update_cpuid_runtime(vcpu);
+		kvm_xcr0_update_cpuid(vcpu);
 	return 0;
 }
 
-- 
1.8.3.1

