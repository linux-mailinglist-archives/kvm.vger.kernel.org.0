Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696B6275D8D
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 18:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgIWQgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 12:36:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:7062 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgIWQgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 12:36:32 -0400
IronPort-SDR: KNRwUVmTqNdIS4cK9oal/jhU5lsVuchWpoKahstc+6wqh91WHLcuz0U2w1tk772A4AQuhd6PSv
 LOcXRL1qdBbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="140962217"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="140962217"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 09:36:32 -0700
IronPort-SDR: r5/8CJwFBi0iQuWgNQ4QZHZt9N9ErzUU59mvdfOWE9qFHsnf02ERdZ8MWX0uLpCUQGQj7bwGyh
 JxLRhAeQSdrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="454981828"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga004.jf.intel.com with ESMTP; 23 Sep 2020 09:36:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: x86: Unexport cpuid_query_maxphyaddr()
Date:   Wed, 23 Sep 2020 09:36:29 -0700
Message-Id: <20200923163629.20168-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923163629.20168-1-sean.j.christopherson@intel.com>
References: <20200923163629.20168-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop exporting cpuid_query_maxphyaddr() now that it's not being abused
by VMX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3fd6eec202d7..dc95b638911e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -186,7 +186,6 @@ int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
 not_found:
 	return 36;
 }
-EXPORT_SYMBOL_GPL(cpuid_query_maxphyaddr);
 
 /* when an old userspace process fills a new kernel module */
 int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
-- 
2.28.0

