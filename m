Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185E93714F4
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 14:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhECMDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 08:03:04 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:33992 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbhECMCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 08:02:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1620043287; x=1651579287;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=9GGmmooWNh5b/DhW7CcR7eCoOpA7l9skAR5JujeFSO8=;
  b=i9DBpAm+FjYrw4Qd3ZTP1rhQKGjGuPkpMzDy0QlNZnDIHf3PiB6zniEf
   SCuxEik7ZRFhS20BPhRDYuUHBE9Kg6MUL7j0kXPvDN+4rgpsIo1cOr0UW
   Mjj8g8mtf27S8/9HWCQ7U6qWheD/+MEZ9yIbVDu+26OtpOfHzXFXdypAA
   Y=;
X-IronPort-AV: E=Sophos;i="5.82,270,1613433600"; 
   d="scan'208";a="111192371"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 03 May 2021 12:01:20 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 70AECA1CF5;
        Mon,  3 May 2021 12:01:19 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.119) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 3 May 2021 12:01:15 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Graf <graf@amazon.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Alexander Graf <graf@amazon.de>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] doc/kvm: Fix wrong entry for KVM_CAP_X86_MSR_FILTER
Date:   Mon, 3 May 2021 14:00:58 +0200
Message-ID: <20210503120059.9283-1-sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.119]
X-ClientProxiedBy: EX13D22UWC002.ant.amazon.com (10.43.162.29) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The capability that exposes new ioctl KVM_X86_SET_MSR_FILTER to
userspace is specified incorrectly as the ioctl itself (instead of
KVM_CAP_X86_MSR_FILTER). This patch fixes it.

Fixes: 1a155254ff93 ("KVM: x86: Introduce MSR filtering")
Cc: Alexander Graf <graf@amazon.de>
Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 Documentation/virt/kvm/api.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 307f2fcf1b02..e778f4aa08f4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4713,7 +4713,7 @@ KVM_PV_VM_VERIFY
 4.126 KVM_X86_SET_MSR_FILTER
 ----------------------------
 
-:Capability: KVM_X86_SET_MSR_FILTER
+:Capability: KVM_CAP_X86_MSR_FILTER
 :Architectures: x86
 :Type: vm ioctl
 :Parameters: struct kvm_msr_filter
@@ -6586,7 +6586,7 @@ accesses that would usually trigger a #GP by KVM into the guest will
 instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
 KVM_EXIT_X86_WRMSR exit notifications.
 
-8.27 KVM_X86_SET_MSR_FILTER
+8.27 KVM_CAP_X86_MSR_FILTER
 ---------------------------
 
 :Architectures: x86
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



