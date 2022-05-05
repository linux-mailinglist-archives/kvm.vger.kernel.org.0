Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957CE51C729
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350628AbiEESVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383309AbiEESTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338635DBCE;
        Thu,  5 May 2022 11:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774560; x=1683310560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fb3dBDV4drTH1Irv7AqwIGDFRaog5goehiwWHDo/z9Q=;
  b=FBPDH40SO0YDzvz4IsDSabrmXWYhTpVY0C0UUidp7C0fvtfm/xsqNA8f
   jbgFY/JcH22HQdLWbOAh43w2aT59jUCsWzHZffQ7b6ktbSFxxMTFj/KEa
   6NbFqsQb6+n4pAZEiWBMadvAE6sPoeUqayQuxbi9irmGBy6jANh4QQvym
   UWqXj2mcUkWGJW/jSTLetcPwtBdvPuJRR8KzYnB5VfPOT7g/SD9dON/vc
   pFjWSYSxzLFIjfCEIjrYS61gHBWjIHIe3FizTWK3IacG6vOd+r7J6fQ/l
   K5U3AzbUfvE/DGArkryXOh6PMDYqSq8VMPSOvw9KkHKGRyjyyZmCiCTLF
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248742036"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248742036"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:47 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083310"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:47 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 048/104] [MARKER] The start of TDX KVM patch series: TDX EPT violation
Date:   Thu,  5 May 2022 11:14:42 -0700
Message-Id: <3bf0b02c05298a4d3f33a2ee31a629401fb16909.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of TDX EPT
violation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index d5cace00c433..c3e675bea802 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -19,12 +19,12 @@ Patch Layer status
 * TDX architectural definitions:        Applied
 * TD VM creation/destruction:           Applied
 * TD vcpu creation/destruction:         Applied
-* TDX EPT violation:                    Not yet
+* TDX EPT violation:                    Applying
 * TD finalization:                      Not yet
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
 * KVM TDP refactoring for TDX:          Applied
-* KVM TDP MMU hooks:                    Applying
+* KVM TDP MMU hooks:                    Applied
 * KVM TDP MMU MapGPA:                   Not yet
-- 
2.25.1

