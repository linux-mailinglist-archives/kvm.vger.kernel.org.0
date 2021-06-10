Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C223A2C98
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhFJNO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 09:14:58 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:54937 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhFJNO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 09:14:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623330781; x=1654866781;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=DJbVodLRF7Iv+MX39jBuSH8fHDGh5K+K4vK/srAYEh0=;
  b=rA0nhV5o9IpQYf8RVfg6hyLjNsCHaGP3LCKvA3qJCjW04uTYQC7JIkmS
   HOD066fuZNA43Rf81+sVz4+NjjEfA5aKud4Z0sMElWeOIWHBouCEx+vD0
   InDPY/rdsBMzTfMXm6LohzZNnL+2+s1lUOPNFhKJBgfz6uxxKB//dBlfA
   c=;
X-IronPort-AV: E=Sophos;i="5.83,263,1616457600"; 
   d="scan'208";a="937621803"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 10 Jun 2021 13:12:54 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id A41DDA189B;
        Thu, 10 Jun 2021 13:12:53 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.162.147) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 13:12:49 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 0/2] x86: hyper-v: expose hv_hypercall() from hyperv.h
Date:   Thu, 10 Jun 2021 15:12:28 +0200
Message-ID: <cover.1623330462.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.147]
X-ClientProxiedBy: EX13d09UWC004.ant.amazon.com (10.43.162.114) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Couple of minor patches that promote hyperv.h to lib/x86 and expose
hv_hypercall() from there so other tests can use do hypercalls too.

~ Sid.

Siddharth Chandrasekaran (2):
  x86: Move hyperv helpers into libs/x86
  x86: Move hyper-v hypercall related methods to lib/x86/

 x86/Makefile.common       |  9 +-----
 {x86 => lib/x86}/hyperv.h |  3 ++
 {x86 => lib/x86}/hyperv.c | 52 +++++++++++++++++++++++++++++++++
 x86/hyperv_connections.c  | 60 ++++-----------------------------------
 4 files changed, 61 insertions(+), 63 deletions(-)
 rename {x86 => lib/x86}/hyperv.h (98%)
 rename {x86 => lib/x86}/hyperv.c (63%)

-- 
2.17.1



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



