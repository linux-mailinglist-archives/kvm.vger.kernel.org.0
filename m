Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F98F55E37B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241638AbiF0V4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241375AbiF0Vy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA796263;
        Mon, 27 Jun 2022 14:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366896; x=1687902896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rWTnsxMrIzKafHc5a68BzRinBeuJZkWqHiP4eLXCUc4=;
  b=b/5njh9HM5oKt+cWpwuvJabzcafyWG9ZKHtqho18khgWY6nlbuiNkmnr
   yTko3sDiYmjVcIVj+vbV6jn0PS9SKU854Gj6AtKEY86yZv3VuiP0xlhLz
   g8FMRr9Vwn7+8LwN+KM6yrB/5BfgaZJui4YWTmZC/Vh1wXMHvm5TRoC+g
   hEpNQ2Wz4jfZ6lbGgxFpB5/Lx9xShEnMf3YAYlQQi2BPtTIrLjQvggvub
   B1E6hkj18nNWyCrYT9D4rWE1DCoY9+GRgEYXC8jKDetU+PhhqLaqYxVTN
   7dNWSjZKq6za801OALYStBDHfRPwmA8dV4jmvj/TW5OyUwpBv9F4dvm9U
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609540"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609540"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:52 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863544"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:52 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 034/102] [MARKER] The start of TDX KVM patch series: KVM TDP refactoring for TDX
Date:   Mon, 27 Jun 2022 14:53:26 -0700
Message-Id: <a08806c284ffa271570dcb98e87608789ca9daac.1656366338.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of KVM TDP
refactoring for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 6e3f71ab6b59..df003d2ed89e 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -24,7 +24,7 @@ Patch Layer status
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
-* KVM MMU GPA shared bits:              Applying
-* KVM TDP refactoring for TDX:          Not yet
+* KVM MMU GPA shared bits:              Applied
+* KVM TDP refactoring for TDX:          Applying
 * KVM TDP MMU hooks:                    Not yet
 * KVM TDP MMU MapGPA:                   Not yet
-- 
2.25.1

