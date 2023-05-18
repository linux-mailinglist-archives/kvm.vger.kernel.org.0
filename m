Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989B3707C88
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 11:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjERJN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 05:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjERJNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 05:13:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A3D2113
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 02:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684401226; x=1715937226;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pw8l4n2mOVVmegt6txD7DS91TNvz1PTS1w9ewy4nGuo=;
  b=NsU1tIgpONhBwyd6trVnBhx/AlOcC9yQNltSU2kCoPFufOwBh6Ww5Ogj
   wjPrz3e2rjpQDBgmYfmAk6wAS0gSp7lqT+/8F4+EauX/2QTruIjLQ2wF0
   T+5gFDNXB96Y/D+1DF49GXx98+RcGd5gLIe/3Unoj3or/sWaMkzpOMp8G
   s7qrHF3Czr1p26UQvoH2XxHsGdzSUwq73o4kZLBc3LCaz1H4zWyV3GM3+
   NYWFhRPgjp7UvlLC9m7nkor0YeObzWcQv7QBRm3UX1elhX/MwO3gWdbyk
   IdKIakn8jK99dBq2s4CoHBw5sqGrZLhov0bBofzq3ZUR/qi0dQCrXjxEr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="332383004"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="332383004"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:13:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="735006637"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="735006637"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.208.101])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:13:44 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, binbin.wu@linux.intel.com
Subject: [PATCH v2 1/3] KVM: Fix comment for KVM_ENABLE_CAP
Date:   Thu, 18 May 2023 17:13:37 +0800
Message-Id: <20230518091339.1102-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230518091339.1102-1-binbin.wu@linux.intel.com>
References: <20230518091339.1102-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix comment for vcpu ioctl version of KVM_ENABLE_CAP.

KVM provides ioctl KVM_ENABLE_CAP to allow userspace to enable an
extension which is not enabled by default. For vcpu ioctl version,
it is available with the capability KVM_CAP_ENABLE_CAP. For vm ioctl
version, it is available with the capability KVM_CAP_ENABLE_CAP_VM.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 include/uapi/linux/kvm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 737318b1c1d9..bddf2871db8f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1613,7 +1613,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
 #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
 /*
- * vcpu version available with KVM_ENABLE_CAP
+ * vcpu version available with KVM_CAP_ENABLE_CAP
  * vm version available with KVM_CAP_ENABLE_CAP_VM
  */
 #define KVM_ENABLE_CAP            _IOW(KVMIO,  0xa3, struct kvm_enable_cap)
-- 
2.25.1

