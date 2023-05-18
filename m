Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDED707C8A
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 11:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjERJOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 05:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjERJOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 05:14:01 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B15F1FFD
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 02:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684401234; x=1715937234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z+Itf9S6ADeHAGEtG8lpYUrE4BYHeW5u+qbQ92HBlGY=;
  b=OJEc73ShpYOEImC+B2qoGfF3VIYeWTvA6+lVh0c3KCiKzepCxqAvlWVO
   NuKs9aZRKOU3VKCEwMAv1ejMHiNyAAqRQVefr9Ngw39RdOKLllBzXfI2f
   hZ6D4F29DUvh8x+CH7XLvv9plTQruGELAiEmbg3gMz2g49qT9yVxx1w3L
   Qr6JVBznEK9bPl+aXLSodPV/uU/OE/7tZW12oo44DwRzK6ZRO/TIxekHX
   XRkB/hqHYBZEEpqtzgxLLM06UuHjB+MrmkyZlP9ii5MKU7KgtFNk/PCD6
   PNkiJPJbgcO8ZYB4EzjOfYhd+oPKX6PIP0lNBhWy2ZdQpKkJmT9eEBQQ3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="332383019"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="332383019"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:13:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="735006647"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="735006647"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.208.101])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:13:47 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, binbin.wu@linux.intel.com
Subject: [PATCH v2 3/3] KVM: Documentation: Fix a typo in Documentation/virt/kvm/x86/mmu.rst
Date:   Thu, 18 May 2023 17:13:39 +0800
Message-Id: <20230518091339.1102-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230518091339.1102-1-binbin.wu@linux.intel.com>
References: <20230518091339.1102-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

L1 CR4.LA57 should be '0' instead of '1' when shadowing 5-level NPT
for 4-level NPT L1 guest.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 8364afa228ec..26f62034b6f3 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -205,7 +205,7 @@ Shadow pages contain the following information:
   role.passthrough:
     The page is not backed by a guest page table, but its first entry
     points to one.  This is set if NPT uses 5-level page tables (host
-    CR4.LA57=1) and is shadowing L1's 4-level NPT (L1 CR4.LA57=1).
+    CR4.LA57=1) and is shadowing L1's 4-level NPT (L1 CR4.LA57=0).
   gfn:
     Either the guest page table containing the translations shadowed by this
     page, or the base page frame for linear translations.  See role.direct.
-- 
2.25.1

