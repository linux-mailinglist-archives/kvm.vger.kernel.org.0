Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C003E58BF
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2019 07:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfJZF3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Oct 2019 01:29:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:24207 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbfJZF27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Oct 2019 01:28:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 22:28:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,230,1569308400"; 
   d="scan'208";a="224122612"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 25 Oct 2019 22:28:56 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iOEdE-000AqQ-6t; Sat, 26 Oct 2019 13:28:56 +0800
Date:   Sat, 26 Oct 2019 13:28:36 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     kbuild-all@lists.01.org, pbonzini@redhat.com, peterz@infradead.org,
        kvm@vger.kernel.org, like.xu@intel.com,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, wei.w.wang@intel.com,
        kan.liang@intel.com
Subject: [RFC PATCH] KVM: x86/vPMU: intel_msr_idx_to_pmc() can be static
Message-ID: <20191026052836.ttzqfv336iuykjos@4978f4969bb8>
References: <20191021160651.49508-5-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021160651.49508-5-like.xu@linux.intel.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Fixes: 0ca8f3f79a8c ("KVM: x86/vPMU: Introduce a new kvm_pmu_ops->msr_idx_to_pmc callback")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 pmu_amd.c       |    2 +-
 vmx/pmu_intel.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index 88fe3f5f5bd18..ce61d180cf70c 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -204,7 +204,7 @@ static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return false;
 }
 
-struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
+static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 714afcd9244ca..95f0ff9e39f3c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -162,7 +162,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return ret;
 }
 
-struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
+static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
