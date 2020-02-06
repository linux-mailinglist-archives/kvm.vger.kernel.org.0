Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F75154687
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgBFOuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:50:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55376 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgBFOuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=p2YhU3jfC3+pZD58yyGjx9QrnEOyUsPJA0xSIIWllRk=; b=ozWAERDBRN4qrVTFhZ54FriR5N
        bPtqlFAeTvEZmerQrDdJ2k7Ya98yuBSiUVu38hrKfSqqCO3LbET/h3yOrCFFaHSOqqz4t081CMyAu
        2k7iasgI4g2T0PHMmRb6l73epxHBOHCU1P/nmr29M+DcLNw6v875smdWAIaEOu/Sswgu2dZTvagui
        dbQYbbkS3ot+sC46pp3tMm1nh/KXtQmMquz+xFyUS4nQpxvIYI6P4UC5S3TXArODtOWnzIlgd+8V6
        vHSQJisLambL/OKlUetn1CRdKgjmo+W4fRGs0A0cG+lnVapHo4RiWp5FdQ6I7tV9KWXtSzaikFoCU
        XpK9RL4Q==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziUE-0004IV-VR; Thu, 06 Feb 2020 14:50:35 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziU6-002nLT-Rr; Thu, 06 Feb 2020 15:50:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 18/27] docs: kvm: convert arm/hyp-abi.txt to ReST
Date:   Thu,  6 Feb 2020 15:50:15 +0100
Message-Id: <cfa69adc7ba37f3337e5fccdc5f7066efa7ba595.1581000481.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Add proper markups for titles;
- Adjust whitespaces and blank lines to match ReST
  needs;
- Mark literal blocks as such.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../virt/kvm/arm/{hyp-abi.txt => hyp-abi.rst} | 28 +++++++++++++------
 Documentation/virt/kvm/arm/index.rst          |  1 +
 2 files changed, 20 insertions(+), 9 deletions(-)
 rename Documentation/virt/kvm/arm/{hyp-abi.txt => hyp-abi.rst} (79%)

diff --git a/Documentation/virt/kvm/arm/hyp-abi.txt b/Documentation/virt/kvm/arm/hyp-abi.rst
similarity index 79%
rename from Documentation/virt/kvm/arm/hyp-abi.txt
rename to Documentation/virt/kvm/arm/hyp-abi.rst
index a20a0bee268d..d1fc27d848e9 100644
--- a/Documentation/virt/kvm/arm/hyp-abi.txt
+++ b/Documentation/virt/kvm/arm/hyp-abi.rst
@@ -1,4 +1,8 @@
-* Internal ABI between the kernel and HYP
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================================
+Internal ABI between the kernel and HYP
+=======================================
 
 This file documents the interaction between the Linux kernel and the
 hypervisor layer when running Linux as a hypervisor (for example
@@ -19,25 +23,31 @@ and only act on individual CPUs.
 Unless specified otherwise, any built-in hypervisor must implement
 these functions (see arch/arm{,64}/include/asm/virt.h):
 
-* r0/x0 = HVC_SET_VECTORS
-  r1/x1 = vectors
+* ::
+
+    r0/x0 = HVC_SET_VECTORS
+    r1/x1 = vectors
 
   Set HVBAR/VBAR_EL2 to 'vectors' to enable a hypervisor. 'vectors'
   must be a physical address, and respect the alignment requirements
   of the architecture. Only implemented by the initial stubs, not by
   Linux hypervisors.
 
-* r0/x0 = HVC_RESET_VECTORS
+* ::
+
+    r0/x0 = HVC_RESET_VECTORS
 
   Turn HYP/EL2 MMU off, and reset HVBAR/VBAR_EL2 to the initials
   stubs' exception vector value. This effectively disables an existing
   hypervisor.
 
-* r0/x0 = HVC_SOFT_RESTART
-  r1/x1 = restart address
-  x2 = x0's value when entering the next payload (arm64)
-  x3 = x1's value when entering the next payload (arm64)
-  x4 = x2's value when entering the next payload (arm64)
+* ::
+
+    r0/x0 = HVC_SOFT_RESTART
+    r1/x1 = restart address
+    x2 = x0's value when entering the next payload (arm64)
+    x3 = x1's value when entering the next payload (arm64)
+    x4 = x2's value when entering the next payload (arm64)
 
   Mask all exceptions, disable the MMU, move the arguments into place
   (arm64 only), and jump to the restart address while at HYP/EL2. This
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index e039d9b1e076..134fa5fa77e5 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -7,4 +7,5 @@ ARM
 .. toctree::
    :maxdepth: 2
 
+   hyp-abi
    pvtime
-- 
2.24.1

