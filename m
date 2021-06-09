Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41AF3A1671
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhFIOEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:04:46 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:41831 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbhFIOEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 10:04:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623247372; x=1654783372;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=4F5kvUFoXOFvCn8TE8mDme2WiFgr0O2s8MBEhRHZo0Q=;
  b=B6ej3VvniXZS5qrNo8oZVXnv4XeAg6i3oldgwPs8IbgYPkpuCRX8LgHF
   l47LbgjtAK8xd2kra0V65CG/ut6v7/l71cqrPH4UKFUfk0QK7DSmmD8Q3
   +d2O4nBkkucGbjFANix5Z+KrbV1srY4oDHzqTvZqplgXVZ5hT6TbnMgO+
   8=;
X-IronPort-AV: E=Sophos;i="5.83,261,1616457600"; 
   d="scan'208";a="937427661"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 09 Jun 2021 14:02:44 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 4CDCDA1F7D;
        Wed,  9 Jun 2021 14:02:44 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.17) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 9 Jun 2021 14:02:40 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>,
        Siddharth Chandrasekaran <sidcha@amazon.de>
Subject: [kvm-unit-tests PATCH] gitignore: Add tags file to .gitignore
Date:   Wed, 9 Jun 2021 16:02:15 +0200
Message-ID: <20210609140217.1514-1-sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.17]
X-ClientProxiedBy: EX13D23UWC003.ant.amazon.com (10.43.162.81) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add ctags tags file to .gitignore so they don't get checked-in
accidentally.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

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



