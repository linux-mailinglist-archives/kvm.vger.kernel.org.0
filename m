Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CD061312
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 23:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfGFVi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 17:38:56 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44108 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbfGFViz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 17:38:55 -0400
Received: by mail-lj1-f195.google.com with SMTP id k18so12314886ljc.11
        for <kvm@vger.kernel.org>; Sat, 06 Jul 2019 14:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cjzJT+Ug2ljIH+eSeawQbtkAq5PwdGtNp/nTgDIdoFk=;
        b=V9Srk96lJmI+I1DCntkuM0AyIq6ydmZa6ScG2spce+9ttK+z+1D2dTgtpJneKqad4I
         1nm+O2GigCPMFDUSH8SIoQGioEnFRp/zcGYh4LhMc1Gk+7+JHELYRDCNQDJr3T9lH60t
         MftEk/rwA+slBTfPUjj/GdK83sD+mvFMftQQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cjzJT+Ug2ljIH+eSeawQbtkAq5PwdGtNp/nTgDIdoFk=;
        b=K13rFORXLOS1cl2fc4w5cGdSEsQyhHVrz9UIClhcru9ora0CCMPhxJ5EXal+qWtsLA
         MZcqj5jrzr3lmi2CcamMsm8LtdFvjQnkA6Hr6hLmhxNcZ7XE0chcwlnxklFfqrXGB+uG
         vUyDQuJKFYJVMmtpJ//GZGwup1WtNLPKJWLcoxKwkQtuluKedPJiSd/kCHQ5j6BpRqaU
         07pr9+8r9KQ6+5beLikHm7liCj7d5OlXpPzsRJiYCP68y5sAuM7fUmAs+Lc6LY8OUusP
         klhY+Tfj3/l1JhT60YHtN0pPjxoPHyVV7GctSYJcQt4GCrKCy2wOmvRdGCYqKS1gcxgi
         PRqQ==
X-Gm-Message-State: APjAAAXRVK2D69KFI0bkJPnbhn6O8B4A5riani/PNS9YL7r672LHkqXy
        ZKeiobJ+6Ppz0eA2T6XdHnR3RQ==
X-Google-Smtp-Source: APXvYqw3xRdjUvkdGLRSIcoY1bNsDkHY0zejAiAFzDMTkZ32HpoDR4zyyPJfjAlDbxXYX8e/J5l7jA==
X-Received: by 2002:a2e:9ec9:: with SMTP id h9mr5659575ljk.90.1562449132999;
        Sat, 06 Jul 2019 14:38:52 -0700 (PDT)
Received: from luke-XPS-13.home (77-255-206-190.adsl.inetia.pl. [77.255.206.190])
        by smtp.gmail.com with ESMTPSA id j3sm1322449lfp.34.2019.07.06.14.38.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 06 Jul 2019 14:38:52 -0700 (PDT)
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
X-Google-Original-From: Luke Nowakowski-Krijger <lnowakow@neg.ucsd.edu>
To:     linux-kernel-mentees@lists.linuxfoundation.org
Cc:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>,
        pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Documentation: kvm: Convert cpuid.txt to .rst
Date:   Sat,  6 Jul 2019 14:38:14 -0700
Message-Id: <e8cd24f40cdd23ed116679f4c3cfcf8849879bb4.1562448500.git.lnowakow@eng.ucsd.edu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1562448500.git.lnowakow@eng.ucsd.edu>
References: <cover.1562448500.git.lnowakow@eng.ucsd.edu>
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
the information much more clean. 

Signed-off-by: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
---
 Documentation/virtual/kvm/cpuid.rst | 99 +++++++++++++++++++++++++++++
 Documentation/virtual/kvm/cpuid.txt | 83 ------------------------
 2 files changed, 99 insertions(+), 83 deletions(-)
 create mode 100644 Documentation/virtual/kvm/cpuid.rst
 delete mode 100644 Documentation/virtual/kvm/cpuid.txt

diff --git a/Documentation/virtual/kvm/cpuid.rst b/Documentation/virtual/kvm/cpuid.rst
new file mode 100644
index 000000000000..1a03336a500e
--- /dev/null
+++ b/Documentation/virtual/kvm/cpuid.rst
@@ -0,0 +1,99 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+KVM CPUID bits
+==============
+
+:Author: Glauber Costa <glommer@redhat.com>, Red Hat Inc, 2010
+
+A guest running on a kvm host, can check some of its features using
+cpuid. This is not always guaranteed to work, since userspace can
+mask-out some, or even all KVM-related cpuid features before launching
+a guest.
+
+KVM cpuid functions are:
+
+function: **KVM_CPUID_SIGNATURE (0x40000000)**
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
+function: **define KVM_CPUID_FEATURES (0x40000001)**
+
+returns::
+
+          ebx, ecx
+          eax = an OR'ed group of (1 << flag)
+
+where ``flag`` is defined as below:
+
++--------------------------------+------------+---------------------------------+
+| flag                           | value      | meaning                         |
++================================+============+=================================+
+| KVM_FEATURE_CLOCKSOURCE        | 0          | kvmclock available at msrs      |
+|                                |            | 0x11 and 0x12                   |
++--------------------------------+------------+---------------------------------+
+| KVM_FEATURE_NOP_IO_DELAY       | 1          | not necessary to perform delays |
+|                                |            | on PIO operations               |
++--------------------------------+------------+---------------------------------+
+| KVM_FEATURE_MMU_OP             | 2          | deprecated                      |
++--------------------------------+------------+---------------------------------+
+| KVM_FEATURE_CLOCKSOURCE2       | 3          | kvmclock available at msrs      |
+|                                |            | 0x4b564d00 and 0x4b564d01       |
++--------------------------------+------------+---------------------------------+
+| KVM_FEATURE_ASYNC_PF           | 4          | async pf can be enabled by      |
+|                                |            | writing to msr 0x4b564d02       |
++--------------------------------+------------+---------------------------------+
+| KVM_FEATURE_STEAL_TIME         | 5          | steal time can be enabled by    |
+|                                |            | writing to msr 0x4b564d03       |
++--------------------------------+------------+---------------------------------+
+| KVM_FEATURE_PV_EOI             | 6          | paravirtualized end of interrupt|
+|                                |            | handler can be enabled by       |
+|                                |            | writing to msr 0x4b564d04.      |
++--------------------------------+------------+---------------------------------+
+| KVM_FEATURE_PV_UNHAULT         | 7          | guest checks this feature bit   |
+|                                |            | before enabling paravirtualized |
+|                                |            | spinlock support                |
++--------------------------------+------------+---------------------------------+
+| KVM_FEATURE_PV_TLB_FLUSH       | 9          | guest checks this feature bit   |
+|                                |            | before enabling paravirtualized |
+|                                |            | tlb flush                       |
++--------------------------------+------------+---------------------------------+
+| KVM_FEATURE_ASYNC_PF_VMEXIT    | 10         | paravirtualized async PF VM EXIT|
+|                                |            | can be enabled by setting bit 2 |
+|                                |            | when writing to msr 0x4b564d02  |
++--------------------------------+------------+---------------------------------+
+| KVM_FEATURE_PV_SEND_IPI        | 11         | guest checks this feature bit   |
+|                                |            | before enabling paravirtualized |
+|                                |            | sebd IPIs                       |
++--------------------------------+------------+---------------------------------+
+| KVM_FEATURE_CLOCSOURCE_STABLE  | 24         | host will warn if no guest-side |
+| _BIT                           |            | per-cpu warps are expeced in    |
+|                                |            | kvmclock                        |
++--------------------------------+------------+---------------------------------+
+
+::
+
+      edx = an OR'ed group of (1 << flag)
+
+Where ``flag`` here is defined as below:
+
++--------------------------------+------------+---------------------------------+
+| flag                           | value      | meaning                         |
++================================+============+=================================+
+| KVM_HINTS_REALTIME             | 0          | guest checks this feature bit to|
+|                                |            | determine that vCPUs are never  |
+|                                |            | preempted for an unlimited time |
+|                                |            | allowing optimizations          |
++--------------------------------+------------+---------------------------------+
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

