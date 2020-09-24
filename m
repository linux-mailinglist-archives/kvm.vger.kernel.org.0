Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95AD277989
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 21:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgIXTm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 15:42:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:31798 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbgIXTmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 15:42:55 -0400
IronPort-SDR: 0bzjDASVhkmgWHIBvlHmqitJ9CTHHuDNWBheBhj4zKPuTPphmsAoFHcJdbZu71lNVRCmXljN8N
 xNEfak6LT1Bg==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="149076389"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="149076389"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 12:42:52 -0700
IronPort-SDR: +M5KDyTgN/hlVUCOjwRKiQfP2DPUmWbV0chdKSgptt9GkjPKjmAnnSfvsnFo88PU0jxcBgus8l
 yAI/m/kSyHkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="347953049"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Sep 2020 12:42:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] KVM: x86: Unexport cpuid_query_maxphyaddr()
Date:   Thu, 24 Sep 2020 12:42:47 -0700
Message-Id: <20200924194250.19137-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200924194250.19137-1-sean.j.christopherson@intel.com>
References: <20200924194250.19137-1-sean.j.christopherson@intel.com>
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

