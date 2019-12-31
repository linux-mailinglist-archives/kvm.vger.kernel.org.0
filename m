Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA0612DC1F
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 23:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfLaW1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 17:27:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:53005 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbfLaW1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 17:27:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 14:27:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,380,1571727600"; 
   d="scan'208";a="221519036"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 31 Dec 2019 14:27:35 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1imPzC-0009ev-KJ; Wed, 01 Jan 2020 06:27:34 +0800
Date:   Wed, 1 Jan 2020 06:26:46 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, sean.j.christopherson@intel.com,
        yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH] mmu: spp: is_spp_protected() can be static
Message-ID: <20191231222646.q2fcvpszi772zdox@f53c9c00458a>
References: <20191231065043.2209-8-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231065043.2209-8-weijiang.yang@intel.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Fixes: aacd4e33a5dd ("mmu: spp: Enable Lazy mode SPP protection")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 spp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index a5b881f438b1f..6b0317edf0b08 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -571,7 +571,7 @@ inline u64 construct_spptp(unsigned long root_hpa)
 }
 EXPORT_SYMBOL_GPL(construct_spptp);
 
-bool is_spp_protected(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+static bool is_spp_protected(struct kvm_memory_slot *slot, gfn_t gfn, int level)
 {
 	int page_num = KVM_PAGES_PER_HPAGE(level);
 	u32 *access;
