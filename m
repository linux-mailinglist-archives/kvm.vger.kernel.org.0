Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17C5D376A
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 04:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfJKCLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 22:11:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:64396 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbfJKCLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 22:11:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 19:11:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,282,1566889200"; 
   d="scan'208";a="224185722"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 10 Oct 2019 19:11:10 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>, kvm@vger.kernel.org,
        like.xu@linux.intel.com
Subject: [PATCH] kvm/tools: update extension capability list for tools header
Date:   Thu, 10 Oct 2019 18:05:59 +0800
Message-Id: <20191010100559.27192-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although these two capabilities are not currently used in tools, the lack
of declarations are bothering users and synchronize them as placeholders.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 tools/include/uapi/linux/kvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 5e3f12d5359e..ebb1f3c49a19 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -996,6 +996,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
 #define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
+#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.21.0

