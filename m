Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83376127D9
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJ3GZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJ3GYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AF2AA;
        Sat, 29 Oct 2022 23:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111047; x=1698647047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GrRrgKMz4riAK/ebZ/sI81D2KhEbTTaxZ+pXBobqoJ4=;
  b=Trh4Tkqmo6G+MruY22DAVcTXqOWU3+PEAZHCW7fvrsMawsQFM4mifBce
   rTrm1JQFW1wAYJpfFHbXozwpfmo3FofOTzwuuSGpFQENFgM8W1TSPzp8u
   Q2T0LtrWiXova6/LnL6UNMKAi/Gck4Y5aNMKtjQLWJ34DA0QUgu2F5JXu
   cbvtcBzxLO5T/ivjl7F/3/UCJhPKga0QF7MbHw3jRfKPhCiNw7/ZGJOyN
   JIIs3JLwhIsFk3QcjuMMsC/TDEnym0xFqOoEh87nxjjG/WXKrnuExIno0
   BFN973QkE6c9Ydcck9SWFe44r447FNhIJVrnT9r87CB2vE6rY56SfUyLE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037139"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037139"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:01 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392922"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392922"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:01 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 027/108] [MARKER] The start of TDX KVM patch series: KVM MMU GPA shared bits
Date:   Sat, 29 Oct 2022 23:22:28 -0700
Message-Id: <4a423a23e8b1057b203b4ee2ad3280cc6594f654.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of KVM MMU GPA
shared bits.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 3e8efde3e3f3..6e3f71ab6b59 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -10,6 +10,7 @@ What qemu can do
 ----------------
 - TDX VM TYPE is exposed to Qemu.
 - Qemu can create/destroy guest of TDX vm type.
+- Qemu can create/destroy vcpu of TDX vm type.
 
 Patch Layer status
 ------------------
@@ -17,13 +18,13 @@ Patch Layer status
 * TDX, VMX coexistence:                 Applied
 * TDX architectural definitions:        Applied
 * TD VM creation/destruction:           Applied
-* TD vcpu creation/destruction:         Applying
+* TD vcpu creation/destruction:         Applied
 * TDX EPT violation:                    Not yet
 * TD finalization:                      Not yet
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
-* KVM MMU GPA shared bits:              Not yet
+* KVM MMU GPA shared bits:              Applying
 * KVM TDP refactoring for TDX:          Not yet
 * KVM TDP MMU hooks:                    Not yet
 * KVM TDP MMU MapGPA:                   Not yet
-- 
2.25.1

