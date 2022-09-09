Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE1C5B3496
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 11:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiIIJvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 05:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiIIJvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 05:51:23 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC5545F7C
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 02:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1662717030; x=1694253030;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VJBe3MZXHTcJss0IBb9fwg0kY5Z/ouM9RWdqt6S3lOE=;
  b=VuJyGsLNQK4GJRmLubx6PvRP9c9trVbM95RUP2oLvKGuQD8yk96Y6r/m
   1q69CibJBIXnhHGQ/tkaJWYCvOKU2WMoTTuJ8gitQr6unDCDbt9Rc74Vv
   kZp/FFkk31m70uFGDJu391WLgB4vxV3rSDuoxrphN1Slo6y6ugy4PMA2I
   8=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-26daedd8.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 09:50:17 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-26daedd8.us-east-1.amazon.com (Postfix) with ESMTPS id 358CEE1240;
        Fri,  9 Sep 2022 09:50:14 +0000 (UTC)
Received: from EX19D008UEA001.ant.amazon.com (10.252.134.62) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 9 Sep 2022 09:50:14 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX19D008UEA001.ant.amazon.com (10.252.134.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 9 Sep 2022 09:50:14 +0000
Received: from dev-dsk-metikaya-1c-d447d167.eu-west-1.amazon.com
 (10.13.250.103) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server (TLS) id 15.0.1497.38 via Frontend Transport; Fri, 9 Sep 2022 09:50:13
 +0000
From:   Metin Kaya <metikaya@amazon.co.uk>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <x86@kernel.org>, <bp@alien8.de>, <dwmw@amazon.co.uk>,
        <seanjc@google.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <dave.hansen@linux.intel.com>, <joao.m.martins@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>
Subject: [PATCH 1/2] KVM: x86/xen: Remove redundant NULL check
Date:   Fri, 9 Sep 2022 09:50:05 +0000
Message-ID: <20220909095006.65440-1-metikaya@amazon.co.uk>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'kvm' cannot be NULL if we are at that point.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from
guests")

Signed-off-by: Metin Kaya <metikaya@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 280cb5dc7341..f2e09481f633 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1734,8 +1734,7 @@ static int kvm_xen_eventfd_deassign(struct kvm *kvm, u32 port)
 	if (!evtchnfd)
 		return -ENOENT;
 
-	if (kvm)
-		synchronize_srcu(&kvm->srcu);
+	synchronize_srcu(&kvm->srcu);
 	if (!evtchnfd->deliver.port.port)
 		eventfd_ctx_put(evtchnfd->deliver.eventfd.ctx);
 	kfree(evtchnfd);
-- 
2.37.1

