Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9192524922A
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 03:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgHSBMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 21:12:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:52000 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgHSBMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 21:12:41 -0400
IronPort-SDR: oCJq3mHJjnbgjpWkjUIEbArfabb3o6fX0IM1kAucGItBNqle7yJOz5BilnNtozpXd1ehL91IvJ
 qsrL8V9qmakw==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="239860550"
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="239860550"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 18:12:41 -0700
IronPort-SDR: WHjjL7HYHZXQ9FrXWjKxlGHPfwGm5HJJyECI8mtTbxwXPvJ++pizBC0k2lozOEKdp0bf4iSvwq
 nKNp4+OWot4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="371078486"
Received: from lkp-server02.sh.intel.com (HELO 2f0d8b563e65) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 18 Aug 2020 18:12:39 -0700
Received: from kbuild by 2f0d8b563e65 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1k8Cec-0001Xp-E4; Wed, 19 Aug 2020 01:12:38 +0000
Date:   Wed, 19 Aug 2020 09:12:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>, jmattson@google.com,
        graf@amazon.com
Cc:     kbuild-all@lists.01.org, pshier@google.com, oupton@google.com,
        kvm@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Subject: [RFC PATCH] KVM: x86: vmx_set_user_msr_intercept() can be static
Message-ID: <20200819011212.GA51816@07257158eb45>
References: <20200818211533.849501-8-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818211533.849501-8-aaronlewis@google.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 svm/svm.c |    2 +-
 vmx/vmx.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c49d121ee1021..144724c0b4111 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -633,7 +633,7 @@ static void set_user_msr_interception(struct kvm_vcpu *vcpu, u32 msr, int read,
 		__set_msr_interception(msrpm, msr, read, write, offset);
 }
 
-void svm_set_user_msr_intercept(struct kvm_vcpu *vcpu, u32 msr)
+static void svm_set_user_msr_intercept(struct kvm_vcpu *vcpu, u32 msr)
 {
 	set_user_msr_interception(vcpu, msr, 0, 0);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 12478ea7aac71..20f432c698bcd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3820,7 +3820,7 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
 	}
 }
 
-void vmx_set_user_msr_intercept(struct kvm_vcpu *vcpu, u32 msr)
+static void vmx_set_user_msr_intercept(struct kvm_vcpu *vcpu, u32 msr)
 {
 	vmx_enable_intercept_for_msr(vcpu, msr, MSR_TYPE_RW);
 }
