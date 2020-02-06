Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50C01546D2
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgBFOvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:51:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbgBFOuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=XosaEvF5KfBIIrC0UH6xsRambxzgg5W02cFwNp6pBOU=; b=SxnVs9o4vezqnoIY9++vdzM7sW
        kamK6k89M+nrW8oelGpUmWb6h1mFPPfOzujl5fB2NC07NWfsOK1LTX4pNlWovVOAoAUaNinxWwpEQ
        ubnnXXaGNnsL2ChjFsajlACPdDrdB7/L82uQLGTK7pmHNrP8br9+HKpMfvjlgajBIMktPmx6cZtw1
        RMcptMRq1b4ifvpeDnBxsUBOPQ5w7n8BMKucmXtLQrRFlu0eNvWf2A9fL7FOSMNgwPcFTcqZveTXv
        TSwPiIFbtKDdoA2/lplqRXHwOfgZKpv96lit+8EEHdC25dq7C2sohvJwd72JXJ/7evg1HsdRMXLJ5
        SU2KkZHg==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziUE-0004IU-K1; Thu, 06 Feb 2020 14:50:34 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziU7-002nLs-1k; Thu, 06 Feb 2020 15:50:27 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 23/27] docs: kvm: Convert nested-vmx.txt to ReST format
Date:   Thu,  6 Feb 2020 15:50:20 +0100
Message-Id: <ad6afb424e24e76da703e04afd3f6f3877fced8b.1581000481.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This file is almost in ReST format. Just a small set of
changes were needed:

    - Add markups for lists;
    - Add markups for a literal block;
    - Adjust whitespaces.

While here, use the standard markup for the document title.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/index.rst              |  1 +
 .../kvm/{nested-vmx.txt => nested-vmx.rst}    | 37 +++++++++++--------
 2 files changed, 22 insertions(+), 16 deletions(-)
 rename Documentation/virt/kvm/{nested-vmx.txt => nested-vmx.rst} (90%)

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index 95e2487d38f4..123385d0a74a 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -15,6 +15,7 @@ KVM
    locking
    mmu
    msr
+   nested-vmx
    vcpu-requests
 
    arm/index
diff --git a/Documentation/virt/kvm/nested-vmx.txt b/Documentation/virt/kvm/nested-vmx.rst
similarity index 90%
rename from Documentation/virt/kvm/nested-vmx.txt
rename to Documentation/virt/kvm/nested-vmx.rst
index 97eb1353e962..592b0ab6970b 100644
--- a/Documentation/virt/kvm/nested-vmx.txt
+++ b/Documentation/virt/kvm/nested-vmx.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==========
 Nested VMX
 ==========
 
@@ -41,9 +44,9 @@ No modifications are required to user space (qemu). However, qemu's default
 emulated CPU type (qemu64) does not list the "VMX" CPU feature, so it must be
 explicitly enabled, by giving qemu one of the following options:
 
-     -cpu host              (emulated CPU has all features of the real CPU)
+     - cpu host              (emulated CPU has all features of the real CPU)
 
-     -cpu qemu64,+vmx       (add just the vmx feature to a named CPU type)
+     - cpu qemu64,+vmx       (add just the vmx feature to a named CPU type)
 
 
 ABIs
@@ -75,6 +78,8 @@ of this structure changes, this can break live migration across KVM versions.
 VMCS12_REVISION (from vmx.c) should be changed if struct vmcs12 or its inner
 struct shadow_vmcs is ever changed.
 
+::
+
 	typedef u64 natural_width;
 	struct __packed vmcs12 {
 		/* According to the Intel spec, a VMCS region must start with
@@ -220,21 +225,21 @@ Authors
 -------
 
 These patches were written by:
-     Abel Gordon, abelg <at> il.ibm.com
-     Nadav Har'El, nyh <at> il.ibm.com
-     Orit Wasserman, oritw <at> il.ibm.com
-     Ben-Ami Yassor, benami <at> il.ibm.com
-     Muli Ben-Yehuda, muli <at> il.ibm.com
+    - Abel Gordon, abelg <at> il.ibm.com
+    - Nadav Har'El, nyh <at> il.ibm.com
+    - Orit Wasserman, oritw <at> il.ibm.com
+    - Ben-Ami Yassor, benami <at> il.ibm.com
+    - Muli Ben-Yehuda, muli <at> il.ibm.com
 
 With contributions by:
-     Anthony Liguori, aliguori <at> us.ibm.com
-     Mike Day, mdday <at> us.ibm.com
-     Michael Factor, factor <at> il.ibm.com
-     Zvi Dubitzky, dubi <at> il.ibm.com
+    - Anthony Liguori, aliguori <at> us.ibm.com
+    - Mike Day, mdday <at> us.ibm.com
+    - Michael Factor, factor <at> il.ibm.com
+    - Zvi Dubitzky, dubi <at> il.ibm.com
 
 And valuable reviews by:
-     Avi Kivity, avi <at> redhat.com
-     Gleb Natapov, gleb <at> redhat.com
-     Marcelo Tosatti, mtosatti <at> redhat.com
-     Kevin Tian, kevin.tian <at> intel.com
-     and others.
+    - Avi Kivity, avi <at> redhat.com
+    - Gleb Natapov, gleb <at> redhat.com
+    - Marcelo Tosatti, mtosatti <at> redhat.com
+    - Kevin Tian, kevin.tian <at> intel.com
+    - and others.
-- 
2.24.1

