Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7702C724828
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 17:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237854AbjFFPrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 11:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237603AbjFFPrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 11:47:01 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7441210D4;
        Tue,  6 Jun 2023 08:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686066420; x=1717602420;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=a7OcS8+yumWTq/BlaF7JXHbMEqlIKENdhEJ0HlWByrY=;
  b=o8ejMYsQeh7e3GinWoPh89a0ZHnIzVGm2EYW3qwv8pkEWI8wTUlwE4qH
   Wo9cfGU9rlnlzOAJjHw5NjRVTAsCUAZNrwtwjUbg8F4xloD3+KQ/JlAOx
   6zPglRYVZlL/9PaHE04c0nPafCuwCicu9i0fbvING7x3vUzQVWZDgpW5R
   g=;
X-IronPort-AV: E=Sophos;i="6.00,221,1681171200"; 
   d="scan'208";a="339446680"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 15:46:55 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com (Postfix) with ESMTPS id 939D14155D;
        Tue,  6 Jun 2023 15:46:54 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 6 Jun 2023 15:46:45 +0000
Received: from b0f1d8753182.ant.amazon.com.com (10.106.82.24) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 6 Jun 2023 15:46:41 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
CC:     Dave Martin <Dave.Martin@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zulinx86@gmail.com>,
        Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH v2] docs: KVM: Fix register ID of SPSR_FIQ
Date:   Tue, 6 Jun 2023 16:46:28 +0100
Message-ID: <20230606154628.95498-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.82.24]
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes the register ID of SPSR_FIQ.

SPSR_FIQ is a 64-bit register and the 64-bit register size mask is
0x0030000000000000ULL.

Fixes: fd3bc912d3d1 ("KVM: Documentation: Document arm64 core registers in detail")
Signed-off-by: Takahiro Itazuri <itazur@amazon.com>

---
Changes from v1
- Add a description about the 64-bit register size mask in the commit
  message.
- Link: https://lore.kernel.org/all/20230410121927.26953-1-itazur@amazon.com/

---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a5c803f39832..65dad2581751 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2535,7 +2535,7 @@ Specifically:
   0x6030 0000 0010 004a SPSR_ABT    64  spsr[KVM_SPSR_ABT]
   0x6030 0000 0010 004c SPSR_UND    64  spsr[KVM_SPSR_UND]
   0x6030 0000 0010 004e SPSR_IRQ    64  spsr[KVM_SPSR_IRQ]
-  0x6060 0000 0010 0050 SPSR_FIQ    64  spsr[KVM_SPSR_FIQ]
+  0x6030 0000 0010 0050 SPSR_FIQ    64  spsr[KVM_SPSR_FIQ]
   0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]    [1]_
   0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]    [1]_
   ...
-- 
2.38.0

