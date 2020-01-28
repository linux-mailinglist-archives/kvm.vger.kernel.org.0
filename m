Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE34014B5D7
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgA1OAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:00:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59366 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbgA1OAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 09:00:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vckRGT1a+50xrf38zV+HbwSHDdDQVhODH0o9Xm2cn8g=; b=rrs1VPIIVbr+Y9y298ws/9HrHG
        jfht9ve1xN9Wozx/momDeScw4XmhMrl/CVw4F2xOnwASR1YL/AjyQMSXyjx4R0lUThKHRZXOs+gel
        iT7+tAE8gRMa8ZZXERY3ndnEc44gn3RkZ30iCzwLAMScP7zlthlDLe0BofZbIRIVfCK0plBqzDTSC
        QLwVEq1ynKm12+UYXsfUpoMpt9ax1vB9vSVDx++RDTSpXfQgOCWGd8ke+J85f1dGK5l2/vEo1LsBL
        vvIFUqDa64CirLDAJAv9b34fzXDiXKbCPnVoxki4rvtY9FsRS2+kzKl1sLTNHTAlG+NLFwbjWcTy3
        bBeOjVew==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRQ6-0007iy-JT; Tue, 28 Jan 2020 14:00:46 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRPq-001BP2-0X; Tue, 28 Jan 2020 15:00:30 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 23/27] docs: kvm: Convert nested-vmx.txt to ReST format
Date:   Tue, 28 Jan 2020 15:00:24 +0100
Message-Id: <af45fd6f197d2bc69864c5532387d87be706293f.1580219586.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1580219586.git.mchehab+huawei@kernel.org>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
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
 .../kvm/{nested-vmx.txt => nested-vmx.rst}    | 35 ++++++++++---------
 2 files changed, 20 insertions(+), 16 deletions(-)
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
index 97eb1353e962..7f28a5d2c135 100644
--- a/Documentation/virt/kvm/nested-vmx.txt
+++ b/Documentation/virt/kvm/nested-vmx.rst
@@ -1,3 +1,4 @@
+==========
 Nested VMX
 ==========
 
@@ -41,9 +42,9 @@ No modifications are required to user space (qemu). However, qemu's default
 emulated CPU type (qemu64) does not list the "VMX" CPU feature, so it must be
 explicitly enabled, by giving qemu one of the following options:
 
-     -cpu host              (emulated CPU has all features of the real CPU)
+     - cpu host              (emulated CPU has all features of the real CPU)
 
-     -cpu qemu64,+vmx       (add just the vmx feature to a named CPU type)
+     - cpu qemu64,+vmx       (add just the vmx feature to a named CPU type)
 
 
 ABIs
@@ -75,6 +76,8 @@ of this structure changes, this can break live migration across KVM versions.
 VMCS12_REVISION (from vmx.c) should be changed if struct vmcs12 or its inner
 struct shadow_vmcs is ever changed.
 
+::
+
 	typedef u64 natural_width;
 	struct __packed vmcs12 {
 		/* According to the Intel spec, a VMCS region must start with
@@ -220,21 +223,21 @@ Authors
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

