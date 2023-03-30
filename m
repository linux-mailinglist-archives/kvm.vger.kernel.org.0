Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D23F6D1368
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbjC3XkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjC3XkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:40:15 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B73FC66C;
        Thu, 30 Mar 2023 16:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680219615; x=1711755615;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LNmjSR3S/bXR7CzTptdBltqNH7++NvqOXa0PpEvoA+U=;
  b=FF6yWB2gPBj1/QEZCdsUHKwFUeI8a+H236a+wtmCGA63KYCXpR7REMcN
   dRB6y+eBGPLOaRSH005amv4Eyx0+2/rvLlc2eBYJA47ZmZFVFB56gIy71
   3XlDFvwlYHJdT7xuzokbVg9RV0N6IC2V3kdrA0IsZNC8CVaMPkAmOxM03
   4=;
X-IronPort-AV: E=Sophos;i="5.98,306,1673913600"; 
   d="scan'208";a="199474312"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-8a14c045.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 23:40:12 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-8a14c045.us-west-2.amazon.com (Postfix) with ESMTPS id 971F58260D;
        Thu, 30 Mar 2023 23:40:11 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.22; Thu, 30 Mar 2023 23:40:11 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.82.30) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 30 Mar 2023 23:40:07 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Jonathan Corbet <corbet@lwn.net>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zulinx86@gmail.com>, Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH] docs: kvm: x86: Fix a broken field list
Date:   Fri, 31 Mar 2023 00:39:56 +0100
Message-ID: <20230330233956.78246-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.82.30]
X-ClientProxiedBy: EX19D038UWC004.ant.amazon.com (10.13.139.229) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-9.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit adds a missing `:` to fix a broken field list.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 62de0768d6aa..f9163590cda8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8296,7 +8296,7 @@ ENOSYS for the others.
 8.35 KVM_CAP_PMU_CAPABILITY
 ---------------------------
 
-:Capability KVM_CAP_PMU_CAPABILITY
+:Capability: KVM_CAP_PMU_CAPABILITY
 :Architectures: x86
 :Type: vm
 :Parameters: arg[0] is bitmask of PMU virtualization capabilities.
-- 
2.38.0

