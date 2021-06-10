Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E13D3A2A39
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 13:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhFJLdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 07:33:54 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:49497 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhFJLdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 07:33:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623324717; x=1654860717;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=gWhvJRNguQBwlVloQwZWnKjv0boCqKyH6EZqi+5k5yA=;
  b=AIW1/iOy3W9Fc8oSgJGHdUZPf1KjcjcE1zFfu5rRCYnZGb29Nwjv9BI9
   YmjYyq49r4vuftIJQVCcuTbTJYrSGYErvn3w1rA0+QzxybWBZFMj0ijv8
   sGWwEZlVhrpcxRF2qWktyRMKBtmJndEzj46kKKJOTT82zSd4l96iKvWFN
   o=;
X-IronPort-AV: E=Sophos;i="5.83,263,1616457600"; 
   d="scan'208";a="937606044"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-41350382.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 10 Jun 2021 11:31:50 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-41350382.us-west-2.amazon.com (Postfix) with ESMTPS id A674FC08B1;
        Thu, 10 Jun 2021 11:31:49 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.162.134) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 11:31:45 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>,
        Siddharth Chandrasekaran <sidcha@amazon.de>
Subject: [kvm-unit-tests PATCH] make: Add tags target and gitignore the tags file
Date:   Thu, 10 Jun 2021 13:31:28 +0200
Message-ID: <20210610113128.5418-1-sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.134]
X-ClientProxiedBy: EX13D23UWC002.ant.amazon.com (10.43.162.22) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add make target to generate ctags tags file and add it to .gitignore.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 Makefile   | 4 ++++
 .gitignore | 1 +
 2 files changed, 5 insertions(+)

diff --git a/Makefile b/Makefile
index e0828fe..017e7d8 100644
--- a/Makefile
+++ b/Makefile
@@ -128,3 +128,7 @@ cscope:
 	find -L $(cscope_dirs) -maxdepth 1 \
 		-name '*.[chsS]' -exec realpath --relative-base=$(PWD) {} \; | sort -u > ./cscope.files
 	cscope -bk
+
+.PHONY: tags
+tags:
+	ctags -R
diff --git a/.gitignore b/.gitignore
index 784cb2d..8534fb7 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,3 +1,4 @@
+tags
 .gdbinit
 *.a
 *.d
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



