Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CE863CF52
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 07:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbiK3Gnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 01:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiK3Gnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 01:43:33 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95B72B248
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 22:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669790610; x=1701326610;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yHDS3S4wQ++auMG6gCcSd1yjFp9S+SAIYcv3Tr7A+uc=;
  b=UrZ+b8t76xFtgEePRfErH9sIh5H/rOWBWus8g6NnJS576gUiBDuHIYVS
   UR/mFMqtWp8sOOttjBdgadeDj65eXTJWeggnco4hCEnboebJXtjvagblV
   BHDQYmh1MsGAFhbXEwpggNS+PdtFeqUVR8DGEmKHqVd+oriN1JhKJDNEi
   IvB+rABfVFqe9tiT9ASqz00Cs4McHja1L2Gz9/jcgHfLWzVqZcgIP5PH6
   Nogi3DzH2Je6ExpYuARpRfCsRPS3azwE0dB+NCCJ4dxDKx5w1MYFwwJC1
   +UtW7JJQFYCDFa9LHmqhwNlmjagXAWW20aZU8tPNuPnEmy/QT5d68vho2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="314012496"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="314012496"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 22:43:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="646216124"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="646216124"
Received: from b49691d8dae0.jf.intel.com ([10.112.228.155])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 22:43:27 -0800
From:   Lei Wang <lei4.wang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com
Subject: [PATCH] KVM: Change non-existent ioctl comment "KVM_CREATE_MEMORY_REGION" to "KVM_SET_MEMORY_REGION"
Date:   Tue, 29 Nov 2022 22:43:25 -0800
Message-Id: <20221130064325.386359-1-lei4.wang@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ioctl "KVM_CREATE_MEMORY_REGION" doesn't exist and should be
"KVM_SET_MEMORY_REGION", change the comment.

No functional change intended.

Signed-off-by: Lei Wang <lei4.wang@intel.com>
---
 include/uapi/linux/kvm.h       | 2 +-
 tools/include/uapi/linux/kvm.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0d5d4419139a..b1918e6a7f38 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -86,7 +86,7 @@ struct kvm_debug_guest {
 /* *** End of deprecated interfaces *** */
 
 
-/* for KVM_CREATE_MEMORY_REGION */
+/* for KVM_SET_MEMORY_REGION */
 struct kvm_memory_region {
 	__u32 slot;
 	__u32 flags;
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 0d5d4419139a..b1918e6a7f38 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -86,7 +86,7 @@ struct kvm_debug_guest {
 /* *** End of deprecated interfaces *** */
 
 
-/* for KVM_CREATE_MEMORY_REGION */
+/* for KVM_SET_MEMORY_REGION */
 struct kvm_memory_region {
 	__u32 slot;
 	__u32 flags;
-- 
2.34.1

