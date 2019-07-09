Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 093FD63C71
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 22:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfGIUIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 16:08:10 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41553 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbfGIUII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 16:08:08 -0400
Received: by mail-lf1-f67.google.com with SMTP id 62so14274091lfa.8
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2019 13:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zBe6Clg/nrHpxQCV8ORxxfEDeRgWtb8vqB8MmWt0LB4=;
        b=Adz22CImkMbL2GH/Gtq43OilsXJnMnpxBjq/NaRq/HBb58Sf3d2JfrpeNL00Le6wwH
         fFLvbBclAbs9at2yjYXLSusAQuxoikAnUfw2GgkfB+OJrWzFNOQVCfHge2zjTpwXxzhE
         pMYEIXwwsVIONYY8k3GQ3LA39/pw7ke4qxmoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zBe6Clg/nrHpxQCV8ORxxfEDeRgWtb8vqB8MmWt0LB4=;
        b=WV1Q7PNLLjljofYG8EFODhEaUnD64yJHwC+9Urj8HLXrrcMZ2GaCov0IS4aRDPxkyp
         UJnKbBuSDgvatfOoLLUXuFpmEque7CQ98ZQj7wxlYfuM0D4iIMQjkzJzKpyTRX41tPF+
         RCAq1oBxgzIKbUkcWWSXFIDjoZN+GEHPztmhrIl0KdtO49ryk2B5D0o/iMMncd9DxvIR
         5PfqI1KcDj9yXOm/IDHK+O9XPuufiFGFVIW7d/t9P6DjXSl696v9itcQEjuFZIG38XxO
         JfqFjhqF2/HGeYX9HPoTdWfwqIPOTPxaiSKJVjZjWOQScBLsQXWYEr3mSVa1m0HuaqyY
         7NwA==
X-Gm-Message-State: APjAAAXj2Y0KosQjieYUhtve+GbYcVxm8wd/KZI0oH2Fu6qq2NJDT9OC
        s8uArCSoLCUJJhLtXwUs1Oy4/A==
X-Google-Smtp-Source: APXvYqwI1/YYISryAn+TiTObBNhFGlkQMEhurPr9ru/WtWQueqyHA7Oc6noZvwfkwvbsZePZYMthAA==
X-Received: by 2002:a19:4f42:: with SMTP id a2mr12356298lfk.23.1562702885227;
        Tue, 09 Jul 2019 13:08:05 -0700 (PDT)
Received: from luke-XPS-13.home (159-205-76-204.adsl.inetia.pl. [159.205.76.204])
        by smtp.gmail.com with ESMTPSA id f1sm4489ljk.86.2019.07.09.13.08.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 13:08:04 -0700 (PDT)
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
X-Google-Original-From: Luke Nowakowski-Krijger <lnowakow@neg.ucsd.edu>
To:     linux-kernel-mentees@lists.linuxfoundation.org
Cc:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>,
        pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] Documentation: kvm: Convert cpuid.txt to .rst
Date:   Tue,  9 Jul 2019 13:07:19 -0700
Message-Id: <20190709200721.16991-2-lnowakow@neg.ucsd.edu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709200721.16991-1-lnowakow@neg.ucsd.edu>
References: <20190709200721.16991-1-lnowakow@neg.ucsd.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>

Convert cpuid.txt to .rst format to be parsable by sphinx.

Change format and spacing to make function definitions and return values
much more clear. Also added a table that is parsable by sphinx and makes
the information much more clean. Updated Author email to their new
active email address. Added license identifier with the consent of the
author. 

Signed-off-by: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
---
 Changes since v2: 
 + added updated Author email address
 + changed table to simpler format
 - removed function bolding from v1
 Changes since v1:
 + Converted doc to .rst format
 
 Documentation/virtual/kvm/cpuid.rst | 99 +++++++++++++++++++++++++++++
 Documentation/virtual/kvm/cpuid.txt | 83 ------------------------
 2 files changed, 99 insertions(+), 83 deletions(-)
 create mode 100644 Documentation/virtual/kvm/cpuid.rst
 delete mode 100644 Documentation/virtual/kvm/cpuid.txt

diff --git a/Documentation/virtual/kvm/cpuid.rst b/Documentation/virtual/kvm/cpuid.rst
new file mode 100644
index 000000000000..644c53687861
--- /dev/null
+++ b/Documentation/virtual/kvm/cpuid.rst
@@ -0,0 +1,99 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+KVM CPUID bits
+==============
+
+:Author: Glauber Costa <glommer@gmail.com>
+
+A guest running on a kvm host, can check some of its features using
+cpuid. This is not always guaranteed to work, since userspace can
+mask-out some, or even all KVM-related cpuid features before launching
+a guest.
+
+KVM cpuid functions are:
+
+function: KVM_CPUID_SIGNATURE (0x40000000)
+
+returns::
+
+   eax = 0x40000001
+   ebx = 0x4b4d564b
+   ecx = 0x564b4d56
+   edx = 0x4d
+
+Note that this value in ebx, ecx and edx corresponds to the string "KVMKVMKVM".
+The value in eax corresponds to the maximum cpuid function present in this leaf,
+and will be updated if more functions are added in the future.
+Note also that old hosts set eax value to 0x0. This should
+be interpreted as if the value was 0x40000001.
+This function queries the presence of KVM cpuid leafs.
+
+function: define KVM_CPUID_FEATURES (0x40000001)
+
+returns::
+
+          ebx, ecx
+          eax = an OR'ed group of (1 << flag)
+
+where ``flag`` is defined as below:
+
+================================= =========== ================================
+flag                              value       meaning
+================================= =========== ================================
+KVM_FEATURE_CLOCKSOURCE           0           kvmclock available at msrs
+                                              0x11 and 0x12
+
+KVM_FEATURE_NOP_IO_DELAY          1           not necessary to perform delays 
+                                              on PIO operations
+
+KVM_FEATURE_MMU_OP                2           deprecated
+
+KVM_FEATURE_CLOCKSOURCE2          3           kvmclock available at msrs
+
+                                              0x4b564d00 and 0x4b564d01
+KVM_FEATURE_ASYNC_PF              4           async pf can be enabled by
+                                              writing to msr 0x4b564d02
+
+KVM_FEATURE_STEAL_TIME            5           steal time can be enabled by
+                                              writing to msr 0x4b564d03
+
+KVM_FEATURE_PV_EOI                6           paravirtualized end of interrupt
+                                              handler can be enabled by
+                                              writing to msr 0x4b564d04
+
+KVM_FEATURE_PV_UNHAULT            7           guest checks this feature bit
+                                              before enabling paravirtualized
+                                              spinlock support
+
+KVM_FEATURE_PV_TLB_FLUSH          9           guest checks this feature bit
+                                              before enabling paravirtualized
+                                              tlb flush
+
+KVM_FEATURE_ASYNC_PF_VMEXIT       10          paravirtualized async PF VM EXIT
+                                              can be enabled by setting bit 2
+                                              when writing to msr 0x4b564d02
+
+KVM_FEATURE_PV_SEND_IPI           11          guest checks this feature bit
+                                              before enabling paravirtualized 
+                                              sebd IPIs
+
+KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
+                                              per-cpu warps are expeced in
+                                              kvmclock
+================================= =========== ================================
+
+::
+
+      edx = an OR'ed group of (1 << flag)
+
+Where ``flag`` here is defined as below:
+
+================== ============ =================================
+flag               value        meaning
+================== ============ =================================
+KVM_HINTS_REALTIME 0            guest checks this feature bit to
+                                determine that vCPUs are never
+                                preempted for an unlimited time
+                                allowing optimizations
+================== ============ =================================
diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
deleted file mode 100644
index 97ca1940a0dc..000000000000
--- a/Documentation/virtual/kvm/cpuid.txt
+++ /dev/null
@@ -1,83 +0,0 @@
-KVM CPUID bits
-Glauber Costa <glommer@redhat.com>, Red Hat Inc, 2010
-=====================================================
-
-A guest running on a kvm host, can check some of its features using
-cpuid. This is not always guaranteed to work, since userspace can
-mask-out some, or even all KVM-related cpuid features before launching
-a guest.
-
-KVM cpuid functions are:
-
-function: KVM_CPUID_SIGNATURE (0x40000000)
-returns : eax = 0x40000001,
-          ebx = 0x4b4d564b,
-          ecx = 0x564b4d56,
-          edx = 0x4d.
-Note that this value in ebx, ecx and edx corresponds to the string "KVMKVMKVM".
-The value in eax corresponds to the maximum cpuid function present in this leaf,
-and will be updated if more functions are added in the future.
-Note also that old hosts set eax value to 0x0. This should
-be interpreted as if the value was 0x40000001.
-This function queries the presence of KVM cpuid leafs.
-
-
-function: define KVM_CPUID_FEATURES (0x40000001)
-returns : ebx, ecx
-          eax = an OR'ed group of (1 << flag), where each flags is:
-
-
-flag                               || value || meaning
-=============================================================================
-KVM_FEATURE_CLOCKSOURCE            ||     0 || kvmclock available at msrs
-                                   ||       || 0x11 and 0x12.
-------------------------------------------------------------------------------
-KVM_FEATURE_NOP_IO_DELAY           ||     1 || not necessary to perform delays
-                                   ||       || on PIO operations.
-------------------------------------------------------------------------------
-KVM_FEATURE_MMU_OP                 ||     2 || deprecated.
-------------------------------------------------------------------------------
-KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
-                                   ||       || 0x4b564d00 and 0x4b564d01
-------------------------------------------------------------------------------
-KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
-                                   ||       || writing to msr 0x4b564d02
-------------------------------------------------------------------------------
-KVM_FEATURE_STEAL_TIME             ||     5 || steal time can be enabled by
-                                   ||       || writing to msr 0x4b564d03.
-------------------------------------------------------------------------------
-KVM_FEATURE_PV_EOI                 ||     6 || paravirtualized end of interrupt
-                                   ||       || handler can be enabled by writing
-                                   ||       || to msr 0x4b564d04.
-------------------------------------------------------------------------------
-KVM_FEATURE_PV_UNHALT              ||     7 || guest checks this feature bit
-                                   ||       || before enabling paravirtualized
-                                   ||       || spinlock support.
-------------------------------------------------------------------------------
-KVM_FEATURE_PV_TLB_FLUSH           ||     9 || guest checks this feature bit
-                                   ||       || before enabling paravirtualized
-                                   ||       || tlb flush.
-------------------------------------------------------------------------------
-KVM_FEATURE_ASYNC_PF_VMEXIT        ||    10 || paravirtualized async PF VM exit
-                                   ||       || can be enabled by setting bit 2
-                                   ||       || when writing to msr 0x4b564d02
-------------------------------------------------------------------------------
-KVM_FEATURE_PV_SEND_IPI            ||    11 || guest checks this feature bit
-                                   ||       || before using paravirtualized
-                                   ||       || send IPIs.
-------------------------------------------------------------------------------
-KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will warn if no guest-side
-                                   ||       || per-cpu warps are expected in
-                                   ||       || kvmclock.
-------------------------------------------------------------------------------
-
-          edx = an OR'ed group of (1 << flag), where each flags is:
-
-
-flag                               || value || meaning
-==================================================================================
-KVM_HINTS_REALTIME                 ||     0 || guest checks this feature bit to
-                                   ||       || determine that vCPUs are never
-                                   ||       || preempted for an unlimited time,
-                                   ||       || allowing optimizations
-----------------------------------------------------------------------------------
-- 
2.20.1

