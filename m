Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86924927EC
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 15:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244561AbiAROBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 09:01:47 -0500
Received: from mga05.intel.com ([192.55.52.43]:21745 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244503AbiAROBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 09:01:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642514505; x=1674050505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=20/lkpLAvk9byHjbMoKSz+kjaVaWaf+VdeQbNGdz344=;
  b=cZ9Mm/AmCueZvWj75aBukP4ng4apWt2I935tIU9C673TF/K7gTRWFGWg
   zPPuG3vegiNJYTdTEBoLC1rkqp2BeAojgD41ACY5B62VeBly3QDHGsvxf
   wBUCCeXTUB9IIYqECvtVdr5lWMkkIsgLNWGTTmJfP4rRkDinUklVUyDYs
   KITeRDohXkkAovgiEscXlqDaqWXPnsUxYqxZTSHuux6oNViiCgalRDCKk
   +qPQBTJXoXM/xqIf+qV1vHo4r6mcMHFrZfebr30b82XsD6EOWsprhYYcQ
   M4H/oPiGwp9kvalRrE+E47CueambY/bVq1hdLn0GTLBKC0RustQ6QrCrR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="331169016"
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="331169016"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 06:01:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="530299054"
Received: from 984fee00bf64.jf.intel.com ([10.165.54.77])
  by fmsmga007.fm.intel.com with ESMTP; 18 Jan 2022 06:01:45 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yang.zhong@intel.com
Subject: [PATCH 1/2] kvm: selftests: Sync KVM_CAP_XSAVE2 from linux header
Date:   Tue, 18 Jan 2022 06:01:43 -0800
Message-Id: <20220118140144.58855-2-yang.zhong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118140144.58855-1-yang.zhong@intel.com>
References: <20220118140144.58855-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Need sync KVM_CAP_XSAVE2 from linux header to here.

Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 tools/include/uapi/linux/kvm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index f066637ee206..63b96839186c 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1131,7 +1131,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
-#define KVM_CAP_XSAVE2 207
+#define KVM_CAP_XSAVE2 208
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
