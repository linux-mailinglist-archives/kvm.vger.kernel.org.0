Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9339B7CAF8A
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbjJPQeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234323AbjJPQd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:33:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567FD728F;
        Mon, 16 Oct 2023 09:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473363; x=1729009363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i0N39TZmKLiC6CILEgWJyLqxHNkrsso5GLu5HE01vt8=;
  b=eEaG8Tes6WFK5ryKNQaSaRbKLfJsVOBaA5HYHFJGg17ycs50bYeLoDAT
   6xg2HDxtK+hoR0K5fFUHEeEzx+Cd/kDtR2JvezkenEhQcmYTOyZ3QDlCI
   6i3PIJciVPztBxAcEJ/xNnTEdw6b1/lyBDx5ZpHcKUO18GIXoDAUQWk+8
   vnXgz6bSw6ZodiCphmnl15JPzuPmDONaGjTl5nJsmxwZpsQyAV8VFbKyi
   INzy4QLYt1UgW2YSrP2JO0cFzxPVlAx92GmAmP6S9uyrLMTqw3BXsCR8D
   Jvmhb6Gu7HkkbfkVlf8xoQAJlj89odS89K6K41iIk+sPSKXPdIUzmdKD6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825988"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825988"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087126068"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087126068"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:32 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v16 024/116] [MARKER] The start of TDX KVM patch series: TD vcpu creation/destruction
Date:   Mon, 16 Oct 2023 09:13:36 -0700
Message-Id: <cbc8e36d9cdf9e5aea057bf5d0155f6fa36f00a2.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
index 098150da6ea2..25082e9c0b20 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -9,7 +9,7 @@ Layer status
 What qemu can do
 ----------------
 - TDX VM TYPE is exposed to Qemu.
-- Qemu can try to create VM of TDX VM type and then fails.
+- Qemu can create/destroy guest of TDX vm type.
 
 Patch Layer status
 ------------------
@@ -17,8 +17,8 @@ Patch Layer status
 
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

