Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150474CDDD7
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiCDUJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiCDUHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:55 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33D024152C;
        Fri,  4 Mar 2022 12:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424145; x=1677960145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hfWfzCezrRDn/CUy5zuhAfXKn593PFsQAe+npFrkRKA=;
  b=WV+9vKMZuD0rjthTigQcrCYcEKTGWEZfXaybQSfsIh84bFpUDi8JUs5O
   5I0tACqpLiGcr1uAUX7nS/pXpN6FfjDbsGVyCe2q/9PfRW6Q7Ck9w/01e
   6WKxTtHPWNDWUgKvVK8eRdqWtU4CbcXhWn3M149nGQ+gChCOnKyU13+zr
   rVV9PVYdoF2WuFYgSr58sr4rUclLWNeMUOnodu71W3kI8Tb9Px1kr6K5C
   4Sn1ERu+TApuvKSE3WjK1/7CLq0EmPzxTzdx1XJ9GiAl+BF1ml+Arw0Ye
   JLRkfiFRqFit/1FeIMC02fGtYx98lfV12nb2Y/EzK3C58xHQpi9IH8OHJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983495"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983495"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:23 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344344"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:22 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 044/104] [MARKER] The start of TDX KVM patch series: KVM TDP MMU hooks
Date:   Fri,  4 Mar 2022 11:49:00 -0800
Message-Id: <9f6d2481e63286fe50c782c6f6a8c9840fd6aafe.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index b4c10eb46b8d..9b2b811c5bdf 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -25,6 +25,6 @@ Patch Layer status
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA stolen bits:              Applied
-* KVM TDP refactoring for TDX:          Applying
-* KVM TDP MMU hooks:                    Not yet
+* KVM TDP refactoring for TDX:          Applied
+* KVM TDP MMU hooks:                    Applying
 * KVM TDP MMU MapGPA:                   Not yet
-- 
2.25.1

