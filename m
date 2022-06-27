Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC7255C3FE
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241741AbiF0V42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241429AbiF0VzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:10 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B991C6326;
        Mon, 27 Jun 2022 14:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366898; x=1687902898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9+zynqxUnbt7L2tmrykvNHmz+Wt/xr8Fj4lA+9l+hKk=;
  b=GTshIsVXG/uRrjQyEBklKUdkUpM+a70v4j1US2GXah0W6Kwpfj023yU0
   ew2MCcuJ6n1WY8u//TMh0LSsc2it/Jw0gRisSQD7iCq98VyCUpWmhZyXk
   TMUgCRNyhMpeXjUBAATC8XQpINqgPUWBLC60gXP2DMvv/tr1sGNlyJETZ
   b74uPHTols/gUTxMFunU+WBm0ymbVBRKc5pJoNx5eom9qad108ffoYwu1
   LJC3X+asaUHyKrcLMZNSiYv+YGfRhCyATb4N/ZBCXkwpgZFrQXSiRAL4z
   zd3/97j5Mr8jjpGUPDn1irV+8SmfgZaexgxGn4rfMt+6J/HqL0aemsm44
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609557"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609557"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:53 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863571"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:53 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 042/102] [MARKER] The start of TDX KVM patch series: KVM TDP MMU hooks
Date:   Mon, 27 Jun 2022 14:53:34 -0700
Message-Id: <082bd1d5a2c99f9a5313be51790410b66280cd94.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of KVM TDP MMU
hooks.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index df003d2ed89e..d5cace00c433 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -25,6 +25,6 @@ Patch Layer status
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
-* KVM TDP refactoring for TDX:          Applying
-* KVM TDP MMU hooks:                    Not yet
+* KVM TDP refactoring for TDX:          Applied
+* KVM TDP MMU hooks:                    Applying
 * KVM TDP MMU MapGPA:                   Not yet
-- 
2.25.1

