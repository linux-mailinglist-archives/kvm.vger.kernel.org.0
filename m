Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC1D5F08CD
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiI3KWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiI3KUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:20:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3710C20856B;
        Fri, 30 Sep 2022 03:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533158; x=1696069158;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A805Zxruh6yYNtylIzj9f+DsWSAMkPS9vWZxb71Yd8s=;
  b=fK7hIKNGBr84y5QUFJMYXERkj7iqE+i3PWBE/d0nHTT9tiN5UfRfOD/s
   ujtCnM8y1H4s/b9qpeTRY7LT4SmlIVx6mwhs8z7Hkl7YL66TdIxPDu0kA
   feIIijFXMzqbiJhrtYQ5Dq7VIG0DCsoyIujQ+8RAwox8oG0MGJ8NJ58ub
   wUNAz7M4smHLHeyqTs282nAz8W6aGCpzbm91l1i7z2ZyxRPAZI6JC0YDj
   beBqPc09fJILs0oaGGtvrzWN0DuF+J3zP9qRlGC5kkqP5o/JESbxUmPAM
   EuB6+/CNEC3sG6AUriul/KJiiGXtX7xYnzCpynnJKoDlpbTmp42cC9Usa
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870118"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870118"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:00 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807686"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807686"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:00 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 056/105] [MARKER] The start of TDX KVM patch series: KVM TDP MMU MapGPA
Date:   Fri, 30 Sep 2022 03:17:50 -0700
Message-Id: <66be3394bafbbe603b7f637c6edc3c12992679c4.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of KVM TDP MMU
MapGPA.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index c3e675bea802..5797d172176d 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -11,6 +11,7 @@ What qemu can do
 - TDX VM TYPE is exposed to Qemu.
 - Qemu can create/destroy guest of TDX vm type.
 - Qemu can create/destroy vcpu of TDX vm type.
+- Qemu can populate initial guest memory image.
 
 Patch Layer status
 ------------------
@@ -19,7 +20,7 @@ Patch Layer status
 * TDX architectural definitions:        Applied
 * TD VM creation/destruction:           Applied
 * TD vcpu creation/destruction:         Applied
-* TDX EPT violation:                    Applying
+* TDX EPT violation:                    Applied
 * TD finalization:                      Not yet
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
-- 
2.25.1

