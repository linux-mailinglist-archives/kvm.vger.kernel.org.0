Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F18378F83F
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 07:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348307AbjIAF7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 01:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348304AbjIAF7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 01:59:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096B410C7
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 22:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693547967; x=1725083967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kBJjgJUqdsnUFUfQUjqAeWVl/5i30fjbjZiEHQKmmFc=;
  b=NckSp6X3YTXhFeF1AfTSErZ9ALeDlxyYty6StDcUQr3RsXg2dJ6Zx6D2
   p34XHAzKssAzwnE5HzQQalKhkPQN08l8IdW4kSwmdJfJ4UYHX4lpTyfUh
   SDtO5zZnWmtCcVPlJQIcjlZ7blIY+QZpRRUh0KZ+KfkPC9tBWE4m46BbO
   +/cebGKnq9dQ0AibcctW0kxOnSQFvBTsRnjvmCEBdhvH/T4iinSJSXoDq
   jU+/VIYUemezIvqd+td+4gtllJycNQb2AbYfC1hGueGzoJ8eWMoF2+LT8
   +E+l64BZJnwo2cHAIAjk5RLBKndIgSTDgbeOUG0L+gW/KS61bUKlm1ZFQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="356456641"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="356456641"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 22:59:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="739816168"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="739816168"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 31 Aug 2023 22:59:25 -0700
From:   Xin Li <xin3.li@intel.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        chao.gao@intel.com, hpa@zytor.com, xiaoyao.li@intel.com,
        weijiang.yang@intel.com
Subject: [PATCH 3/4] target/i386: enumerate VMX nested-exception support
Date:   Thu, 31 Aug 2023 22:30:21 -0700
Message-Id: <20230901053022.18672-4-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230901053022.18672-1-xin3.li@intel.com>
References: <20230901053022.18672-1-xin3.li@intel.com>
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

Allow VMX nested-exception support to be exposed in KVM guests, thus
nested KVM guests can enumerate it.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 target/i386/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3dba6b46d9..ba579e1fb7 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1340,6 +1340,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .feat_names = {
             [54] = "vmx-ins-outs",
             [55] = "vmx-true-ctls",
+            [58] = "vmx-nested-exception",
         },
         .msr = {
             .index = MSR_IA32_VMX_BASIC,
-- 
2.34.1

