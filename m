Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B548412DBCF
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 21:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfLaUeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 15:34:16 -0500
Received: from mga17.intel.com ([192.55.52.151]:40107 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbfLaUeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 15:34:16 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 12:34:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,380,1571727600"; 
   d="scan'208";a="231385301"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 31 Dec 2019 12:34:13 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1imODU-000CGC-T2; Wed, 01 Jan 2020 04:34:12 +0800
Date:   Wed, 1 Jan 2020 04:33:31 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, sean.j.christopherson@intel.com,
        yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH] vmx: spp: kvm_spp_level_pages() can be static
Message-ID: <20191231203331.rsdoqhfvbwbxiot3@f53c9c00458a>
References: <20191231065043.2209-7-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231065043.2209-7-weijiang.yang@intel.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Fixes: 5ab8f03b84b6 ("vmx: spp: Set up SPP paging table at vmentry/vmexit")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 spp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index 9d9edb295394c..3ec4341409674 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -199,7 +199,7 @@ bool is_spp_spte(struct kvm_mmu_page *sp)
 	return sp->role.spp;
 }
 
-int kvm_spp_level_pages(gfn_t gfn_lower, gfn_t gfn_upper, int level)
+static int kvm_spp_level_pages(gfn_t gfn_lower, gfn_t gfn_upper, int level)
 {
 	int page_num = KVM_PAGES_PER_HPAGE(level);
 	gfn_t gfn_max = (gfn_lower & ~(page_num - 1)) + page_num - 1;
@@ -416,7 +416,7 @@ static void kvm_spp_zap_pte(struct kvm *kvm, u64 *spte, int level)
 	}
 }
 
-bool kvm_spp_flush_rmap(struct kvm *kvm, u64 gfn_min, u64 gfn_max)
+static bool kvm_spp_flush_rmap(struct kvm *kvm, u64 gfn_min, u64 gfn_max)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
