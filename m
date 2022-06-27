Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C46955D0FE
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241645AbiF0V4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241419AbiF0VzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:09 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB64C644C;
        Mon, 27 Jun 2022 14:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366897; x=1687902897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yzsW3HP34uHnzDykzPATauL2DDgMbwFkjBwFhJu1DX0=;
  b=GsesZUvOkKPN2I5eiX8EJK2QPKL+UKJh33nMsab4lvcbqam+K974HJH5
   +07B92/K2PB0t883rszgO/2lww3lmPokgvJmCBMS1DlgJar0TTBaZCOzn
   yqE7y60Ho1T/pUGGIXwvJMoUrS4dGckf+R85kRDXHRC1yArMn5Sqp9O5B
   Ucus40wq0y7U0gZFBJBqcaN65mZNZxWu31ysSzQpn1t9fKUnzAYjTS0j6
   itG+C8kMkYo81zd3bj15KI1tj+DQ7oXRlP6SCg149KVgMjdy4PFpit4s+
   bDkIQTZ7u7dwuItVRMPsvFenJIZA2WRE2R8rxmdwvRWNHyakdql+YfW3U
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="279116097"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="279116097"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:56 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863627"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:56 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 059/102] [MARKER] The start of TDX KVM patch series: TD finalization
Date:   Mon, 27 Jun 2022 14:53:51 -0700
Message-Id: <d385bde6f0ad58cb3a361e1401c22f548c268492.1656366338.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of TD finalization.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 5797d172176d..53897312699f 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -21,11 +21,11 @@ Patch Layer status
 * TD VM creation/destruction:           Applied
 * TD vcpu creation/destruction:         Applied
 * TDX EPT violation:                    Applied
-* TD finalization:                      Not yet
+* TD finalization:                      Applying
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
 * KVM TDP refactoring for TDX:          Applied
 * KVM TDP MMU hooks:                    Applied
-* KVM TDP MMU MapGPA:                   Not yet
+* KVM TDP MMU MapGPA:                   Applied
-- 
2.25.1

