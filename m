Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE823A1673
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbhFIOEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:04:50 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:40488 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbhFIOEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 10:04:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623247375; x=1654783375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=4oVrdW8RDdZZG7Xoq+7Ll5kvYL7d/7s+RMKz8VYriJU=;
  b=qbE1gX5MVo9g2iAUfHUcwDPPETWp1t02Ob4rlrIjCKJkObr5ae4lmmU1
   JSDrucw08B8kIxhdTRbiIE8+Q9SIHxVfRuMDKQtRsFIjTiNiZ6rVYUMch
   JWZpYyCxtJZ1uChcXm+FQ3+GRArs41NF/S55Fy/UchV5RHYOal1Lkgxsh
   c=;
X-IronPort-AV: E=Sophos;i="5.83,261,1616457600"; 
   d="scan'208";a="114733056"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 09 Jun 2021 14:02:51 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id 7B9DAA1883;
        Wed,  9 Jun 2021 14:02:50 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.17) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 9 Jun 2021 14:02:46 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>,
        Siddharth Chandrasekaran <sidcha@amazon.de>
Subject: [kvm-unit-tests PATCH] x86: Fix misspelled KVM parameter in error message
Date:   Wed, 9 Jun 2021 16:02:17 +0200
Message-ID: <20210609140217.1514-3-sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609140217.1514-1-sidcha@amazon.de>
References: <20210609140217.1514-1-sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.17]
X-ClientProxiedBy: EX13D23UWC003.ant.amazon.com (10.43.162.81) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM module parameter force_emulation_prefix is misspelled with a
"forced"; fix it.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 x86/emulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 6100b6d..97f28ba 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -1124,7 +1124,7 @@ int main(void)
 		test_mov_dr(mem);
 	} else {
 		report_skip("skipping register-only tests, "
-			    "use kvm.forced_emulation_prefix=1 to enable");
+			    "use kvm.force_emulation_prefix=1 to enable");
 	}
 
 	test_push16(mem);
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



