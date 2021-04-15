Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224303600A3
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 05:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhDODuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 23:50:19 -0400
Received: from mga18.intel.com ([134.134.136.126]:39811 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhDODuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 23:50:18 -0400
IronPort-SDR: LcAS/FaFqN+QrwO3Pu3kAeuEQD+ZViLj/tQcipVulWvblxVIEXizIJFzzqm0vvPt04vOyeyXw/
 B9gyF6n93nEA==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="182284123"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="182284123"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 20:49:55 -0700
IronPort-SDR: WRhIuMztRvqgxOokaF65zXkWd3BBzqc93Tlm5UoyMWHsnWjlUx5nbtMy3w/E901X0YSlf3/xUv
 8FuMA6ruRl/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="452746853"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by fmsmga002.fm.intel.com with ESMTP; 14 Apr 2021 20:49:54 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH] KVM: x86/mmu: Remove duplicate MMU trace log
Date:   Thu, 15 Apr 2021 12:01:41 +0800
Message-Id: <20210415040141.5218-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 018d82e73e31..0bd4c9972fc8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -781,8 +781,6 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 		trace_kvm_mmu_set_spte(iter->level, iter->gfn,
 				       rcu_dereference(iter->sptep));
 
-	trace_kvm_mmu_set_spte(iter->level, iter->gfn,
-			       rcu_dereference(iter->sptep));
 	if (!prefault)
 		vcpu->stat.pf_fixed++;
 
-- 
2.17.2

