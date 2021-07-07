Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF7F3BEBDE
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 18:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhGGQTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 12:19:52 -0400
Received: from mga05.intel.com ([192.55.52.43]:21268 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhGGQTv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 12:19:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10037"; a="294976392"
X-IronPort-AV: E=Sophos;i="5.84,220,1620716400"; 
   d="scan'208";a="294976392"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 09:17:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,220,1620716400"; 
   d="scan'208";a="487019568"
Received: from zhangyu-optiplex-7040.bj.intel.com ([10.238.154.154])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jul 2021 09:17:08 -0700
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: Remove vmx_msr_index from vmx.h
Date:   Thu,  8 Jul 2021 07:57:02 +0800
Message-Id: <20210707235702.31595-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_msr_index was used to record the list of MSRs which can be lazily
restored when kvm returns to userspace. It is now reimplemented as
kvm_uret_msrs_list, a common x86 list which is only used inside x86.c.
So just remove the obsolete declaration in vmx.h.

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 3979a947933a..db88ed4f2121 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -14,8 +14,6 @@
 #include "vmx_ops.h"
 #include "cpuid.h"
 
-extern const u32 vmx_msr_index[];
-
 #define MSR_TYPE_R	1
 #define MSR_TYPE_W	2
 #define MSR_TYPE_RW	3
-- 
2.17.1

