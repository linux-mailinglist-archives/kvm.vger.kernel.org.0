Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3138858BDD6
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242135AbiHGWJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241899AbiHGWHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:07:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12E4B1E1;
        Sun,  7 Aug 2022 15:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909803; x=1691445803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JDJD5HxBG16VKKz5Tw7vIJeGTJe3WzrVqBHL0IAN/Ng=;
  b=bGcy0mall8d3zqK9g/vLZcLxcPvMygzL74UeR1Ta69ZRxYMq14WpjXzq
   IIe4xADMyAsijdYYdFmKrpaiIxeuLHZHnXZncfVmyvK43qFpyOO1VSBgX
   vRhvqR9izia4oN8//WvCX9hoWdy0s8H2BENQFgqjFRiy3SOX3gwDg8FJv
   8FM6i593wrWQqrzn9+PGbnWfxwi+va+7xnQsvGxgwQAjz9VPpZGnvTHFa
   kMczMl2fRtzgJlYx+zFM+gpo+GanOCIJfJBHHJfywkGVnNih1XuswvUMU
   L34h7Fw9CmNSw4weY1UL9k4aZWF+lLTicz28l1WpQoZAgvqHCv8tiYkhy
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224172"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224172"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682673"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:39 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 069/103] [MARKER] The start of TDX KVM patch series: TD vcpu exits/interrupts/hypercalls
Date:   Sun,  7 Aug 2022 15:01:54 -0700
Message-Id: <7dfc7c1ef06ee75a42a86e023b2d255903366806.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of TD vcpu
exits, interrupts, and hypercalls.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index b51e8e6b1541..1cec14213f69 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -13,6 +13,7 @@ What qemu can do
 - Qemu can create/destroy vcpu of TDX vm type.
 - Qemu can populate initial guest memory image.
 - Qemu can finalize guest TD.
+- Qemu can start to run vcpu. But vcpu can not make progress yet.
 
 Patch Layer status
 ------------------
@@ -23,7 +24,7 @@ Patch Layer status
 * TD vcpu creation/destruction:         Applied
 * TDX EPT violation:                    Applied
 * TD finalization:                      Applied
-* TD vcpu enter/exit:                   Applying
+* TD vcpu enter/exit:                   Applied
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
-- 
2.25.1

