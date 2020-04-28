Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0441BB5AE
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 07:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgD1FHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 01:07:13 -0400
Received: from mga07.intel.com ([134.134.136.100]:28385 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbgD1FHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 01:07:12 -0400
IronPort-SDR: KK0D1eBQKzvWp2vlkrTGbugLjpQObnNuvH3ABzwy7VtZAk/2SVTYKp2j4TbcxwFkTF7NBE7ecK
 wFGQYr6xld2g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 22:07:12 -0700
IronPort-SDR: LhndOMvmy3OMlNNwE0WpgyY+lTgFSgbB/3QGupkQt5Y2JaSUXRuxq6csNWSqk2GUAkUKeMnoMI
 g9e3av3P5FdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,326,1583222400"; 
   d="scan'208";a="432049751"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 27 Apr 2020 22:07:09 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jTISa-000Gk9-UA; Tue, 28 Apr 2020 13:07:08 +0800
Date:   Tue, 28 Apr 2020 13:06:27 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com
Subject: [RFC PATCH] KVM: x86/pmu: kvm_pmu_lbr_cleanup() can be static
Message-ID: <20200428050627.GA26449@41ada6197895>
References: <20200423081412.164863-10-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423081412.164863-10-like.xu@linux.intel.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Signed-off-by: kbuild test robot <lkp@intel.com>
---
 pmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 7dad899850bb3..b9b6d16651c8b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -452,7 +452,7 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }
 
-void kvm_pmu_lbr_cleanup(struct kvm_vcpu *vcpu)
+static void kvm_pmu_lbr_cleanup(struct kvm_vcpu *vcpu)
 {
 	if (kvm_x86_ops.pmu_ops->lbr_cleanup)
 		kvm_x86_ops.pmu_ops->lbr_cleanup(vcpu);
