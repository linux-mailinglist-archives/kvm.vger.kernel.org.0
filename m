Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECE23A3241
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 19:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhFJRjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 13:39:14 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:11118 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbhFJRjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 13:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623346638; x=1654882638;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=5wBhl2kvo60tkZMH0L5EwPQTyWrw5edXYhFJvQFTPCk=;
  b=eHSNkk2I7kR8xJX1nWtut51qUpy0PQDthCBCFa7MgtMJUVK52V9ycE7t
   v3nfzLlGD0Ri3OGQOsdKZ4/Fk6N05raZl4LK1/bpRa2C278/5GdTIglUO
   I8jpgCadxp78IHxgfbo6xhoeLiFm4+JHdh2LBTJRfkJp3cVQuCgEgrUHI
   E=;
X-IronPort-AV: E=Sophos;i="5.83,264,1616457600"; 
   d="scan'208";a="115049420"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 10 Jun 2021 17:37:11 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id F0AEAA184A;
        Thu, 10 Jun 2021 17:37:09 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.55) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 17:37:06 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 0/3] x86: hyper-v: Add overlay page tests
Date:   Thu, 10 Jun 2021 19:36:47 +0200
Message-ID: <cover.1623346319.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D36UWA001.ant.amazon.com (10.43.160.71) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch series [1] starts treating hypercall code page as an overlay page
(along with the existing synic event and message pages). Add KVM unit
tests to make sure the underlying page contents are intact with various
overlay workflows.

While at it, promote hyperv.h to lib/x86 and expose hv_hypercall() from
there so future tests can use it to do hypercalls.

[1]: https://www.spinics.net/lists/kvm/msg244569.html

~ Sid.

Siddharth Chandrasekaran (3):
  x86: Move hyperv helpers into libs/x86
  x86: Move hyper-v hypercall related methods to lib/x86/
  x86: Add hyper-v overlay page tests

 x86/Makefile.common       |  8 +---
 {x86 => lib/x86}/hyperv.h |  4 ++
 {x86 => lib/x86}/hyperv.c | 51 +++++++++++++++++++++
 x86/hyperv_connections.c  | 60 ++----------------------
 x86/hyperv_overlay.c      | 96 +++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg         |  5 ++
 6 files changed, 163 insertions(+), 61 deletions(-)
 rename {x86 => lib/x86}/hyperv.h (97%)
 rename {x86 => lib/x86}/hyperv.c (63%)
 create mode 100644 x86/hyperv_overlay.c

-- 
2.17.1



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



