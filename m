Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FF455D047
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241601AbiF0Vzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240041AbiF0Vy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B9C63AF;
        Mon, 27 Jun 2022 14:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366895; x=1687902895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dq/4kTxFog2mJ+pfF6ngUCSHtSzKcfcxTCggESSMMVA=;
  b=cGisTSfApHQlo/45wRkKZPPaCrgiynWYrdRV1rLjJ7sFVbBPTA3M1j3E
   v2GbAtSoBPaRvRnJHEeoZ7KD7NqlxwoZziITleQFVWa4ngatly8yzg7ma
   hi64YqyiFiH174WL8fVUbDzKVhExor37hecXENL9djTep2IYuwpfzEsrw
   7TDAe8cKJDqV851zIy91gwwTeNQYwY44QwbZUnH4i3svC/9mcFicQilHI
   9SlXlIu7uVPCK1JsTMwPFX9h+VVyxqk4hSzdr7GQwkAWaxihJ4RS07HdL
   E9YuWErrF01Jf1OQ4AXqI+dBJGC62ajO7vxwyGN23TkNpQmn3dMFR7WYq
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609525"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609525"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863520"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:51 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 027/102] [MARKER] The start of TDX KVM patch series: TD vcpu creation/destruction
Date:   Mon, 27 Jun 2022 14:53:19 -0700
Message-Id: <d8d12d1577a8cd296dbff430775fcb9bf3233217.1656366338.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of TD vcpu
creation/destruction.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 5e0deaebf843..3e8efde3e3f3 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -9,15 +9,15 @@ Layer status
 What qemu can do
 ----------------
 - TDX VM TYPE is exposed to Qemu.
-- Qemu can try to create VM of TDX VM type and then fails.
+- Qemu can create/destroy guest of TDX vm type.
 
 Patch Layer status
 ------------------
   Patch layer                          Status
 * TDX, VMX coexistence:                 Applied
 * TDX architectural definitions:        Applied
-* TD VM creation/destruction:           Applying
-* TD vcpu creation/destruction:         Not yet
+* TD VM creation/destruction:           Applied
+* TD vcpu creation/destruction:         Applying
 * TDX EPT violation:                    Not yet
 * TD finalization:                      Not yet
 * TD vcpu enter/exit:                   Not yet
-- 
2.25.1

