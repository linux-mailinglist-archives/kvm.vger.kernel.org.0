Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C42714BBDD
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgA1Otx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:49:53 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59296 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgA1OAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 09:00:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pdZ8qcVwJgau11WErg9V3Yc+VhPbjBFzGGVo//flLAo=; b=sySpSqJoeSAZ6nqHqhBfl+XL21
        5TpZr0mZuhA3gjKteTVLv/eqBXj3j7v3SR1IaT6AyaLkVi3P4i120VOT1GYEelIixnpAIOMp3avUF
        dWcV5qIF8XF9ZnBIr9iXJTJe7MY/1z3Z31t0hDyHWgbw23m7VunkcFNqCC8Lm8sxfmfcEZhjKd/Hx
        nbff9DxLcKkcvU9gyzcTNaaEfwwssfyhaayE8Ohm4Rhd5zovUeG4zPiap29IglIpc4Wuh7PJgtMEK
        Gm8rcvGV2v6NOPWzyyspbvE4H4nXlHJNNtTz/xOxOdik+kQXZGDOgtULAm98Rq3XeAtvhaMKEr/Lk
        l7p89GIA==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRQ5-0007ij-Uh; Tue, 28 Jan 2020 14:00:45 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRPp-001BOd-RL; Tue, 28 Jan 2020 15:00:29 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 18/27] docs: kvm: convert arm/hyp-abi.txt to ReST
Date:   Tue, 28 Jan 2020 15:00:19 +0100
Message-Id: <707c15ba05c14b49801e29840154ee1aed5cd910.1580219586.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1580219586.git.mchehab+huawei@kernel.org>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
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
 .../virt/kvm/arm/{hyp-abi.txt => hyp-abi.rst} | 26 ++++++++++++-------
 Documentation/virt/kvm/arm/index.rst          |  1 +
 2 files changed, 18 insertions(+), 9 deletions(-)
 rename Documentation/virt/kvm/arm/{hyp-abi.txt => hyp-abi.rst} (80%)

diff --git a/Documentation/virt/kvm/arm/hyp-abi.txt b/Documentation/virt/kvm/arm/hyp-abi.rst
similarity index 80%
rename from Documentation/virt/kvm/arm/hyp-abi.txt
rename to Documentation/virt/kvm/arm/hyp-abi.rst
index a20a0bee268d..cf74b5b87df6 100644
--- a/Documentation/virt/kvm/arm/hyp-abi.txt
+++ b/Documentation/virt/kvm/arm/hyp-abi.rst
@@ -1,4 +1,6 @@
-* Internal ABI between the kernel and HYP
+=======================================
+Internal ABI between the kernel and HYP
+=======================================
 
 This file documents the interaction between the Linux kernel and the
 hypervisor layer when running Linux as a hypervisor (for example
@@ -19,25 +21,31 @@ and only act on individual CPUs.
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

