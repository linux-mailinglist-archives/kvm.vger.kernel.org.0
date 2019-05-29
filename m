Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5B02E917
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 01:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfE2XYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 19:24:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49264 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfE2XYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 19:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pLa6QBXDUlkvKl0F9KmB92FN1yBU20l3+fc3LLX9/Ow=; b=TUTbNEI2sFRqzFdX8mAEDw+ZKk
        XtHS4RpAgwYG5mZM22U1r6M0vo9yBLzdpBWxLG+Wua96AfW4fGlJvlNU4cwOADtGPiZmrkKWvTbCA
        +YlWRB5YJuvFtbYIZXOusbPxpxpK7XsazwynFvbwvZf9cNf3WTWLfqLh+qA00YXjPTsZuDlOCdtga
        duJk804hRhhdM7AAVrd8q+J05abzsvq5dJZOHHiK+GjqJam/lkUK4JruIWmnniYsXhPKSyxV8wube
        cTsvAcSBdajn4t+NWdFdqsXfNt6brPC/m0bcxjACGqdLnz+bast5CItihyQj2txojtCoXFRwIv9JW
        P1hLrtIA==;
Received: from 177.132.232.81.dynamic.adsl.gvt.net.br ([177.132.232.81] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hW7vL-0005Rw-HW; Wed, 29 May 2019 23:23:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hW7vI-0007xI-NZ; Wed, 29 May 2019 20:23:56 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        Matan Ziv-Av <matan@svgalib.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-pm@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 09/22] docs: mark orphan documents as such
Date:   Wed, 29 May 2019 20:23:40 -0300
Message-Id: <e0bf4e767dd5de9189e5993fbec2f4b1bafd2064.1559171394.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1559171394.git.mchehab+samsung@kernel.org>
References: <cover.1559171394.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sphinx doesn't like orphan documents:

    Documentation/accelerators/ocxl.rst: WARNING: document isn't included in any toctree
    Documentation/arm/stm32/overview.rst: WARNING: document isn't included in any toctree
    Documentation/arm/stm32/stm32f429-overview.rst: WARNING: document isn't included in any toctree
    Documentation/arm/stm32/stm32f746-overview.rst: WARNING: document isn't included in any toctree
    Documentation/arm/stm32/stm32f769-overview.rst: WARNING: document isn't included in any toctree
    Documentation/arm/stm32/stm32h743-overview.rst: WARNING: document isn't included in any toctree
    Documentation/arm/stm32/stm32mp157-overview.rst: WARNING: document isn't included in any toctree
    Documentation/gpu/msm-crash-dump.rst: WARNING: document isn't included in any toctree
    Documentation/interconnect/interconnect.rst: WARNING: document isn't included in any toctree
    Documentation/laptops/lg-laptop.rst: WARNING: document isn't included in any toctree
    Documentation/powerpc/isa-versions.rst: WARNING: document isn't included in any toctree
    Documentation/virtual/kvm/amd-memory-encryption.rst: WARNING: document isn't included in any toctree
    Documentation/virtual/kvm/vcpu-requests.rst: WARNING: document isn't included in any toctree

So, while they aren't on any toctree, add :orphan: to them, in order
to silent this warning.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/accelerators/ocxl.rst                 | 2 ++
 Documentation/arm/stm32/overview.rst                | 2 ++
 Documentation/arm/stm32/stm32f429-overview.rst      | 2 ++
 Documentation/arm/stm32/stm32f746-overview.rst      | 2 ++
 Documentation/arm/stm32/stm32f769-overview.rst      | 2 ++
 Documentation/arm/stm32/stm32h743-overview.rst      | 2 ++
 Documentation/arm/stm32/stm32mp157-overview.rst     | 2 ++
 Documentation/gpu/msm-crash-dump.rst                | 2 ++
 Documentation/interconnect/interconnect.rst         | 2 ++
 Documentation/laptops/lg-laptop.rst                 | 2 ++
 Documentation/powerpc/isa-versions.rst              | 2 ++
 Documentation/virtual/kvm/amd-memory-encryption.rst | 2 ++
 Documentation/virtual/kvm/vcpu-requests.rst         | 2 ++
 13 files changed, 26 insertions(+)

diff --git a/Documentation/accelerators/ocxl.rst b/Documentation/accelerators/ocxl.rst
index 14cefc020e2d..b1cea19a90f5 100644
--- a/Documentation/accelerators/ocxl.rst
+++ b/Documentation/accelerators/ocxl.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ========================================================
 OpenCAPI (Open Coherent Accelerator Processor Interface)
 ========================================================
diff --git a/Documentation/arm/stm32/overview.rst b/Documentation/arm/stm32/overview.rst
index 85cfc8410798..f7e734153860 100644
--- a/Documentation/arm/stm32/overview.rst
+++ b/Documentation/arm/stm32/overview.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ========================
 STM32 ARM Linux Overview
 ========================
diff --git a/Documentation/arm/stm32/stm32f429-overview.rst b/Documentation/arm/stm32/stm32f429-overview.rst
index 18feda97f483..65bbb1c3b423 100644
--- a/Documentation/arm/stm32/stm32f429-overview.rst
+++ b/Documentation/arm/stm32/stm32f429-overview.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 STM32F429 Overview
 ==================
 
diff --git a/Documentation/arm/stm32/stm32f746-overview.rst b/Documentation/arm/stm32/stm32f746-overview.rst
index b5f4b6ce7656..42d593085015 100644
--- a/Documentation/arm/stm32/stm32f746-overview.rst
+++ b/Documentation/arm/stm32/stm32f746-overview.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 STM32F746 Overview
 ==================
 
diff --git a/Documentation/arm/stm32/stm32f769-overview.rst b/Documentation/arm/stm32/stm32f769-overview.rst
index 228656ced2fe..f6adac862b17 100644
--- a/Documentation/arm/stm32/stm32f769-overview.rst
+++ b/Documentation/arm/stm32/stm32f769-overview.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 STM32F769 Overview
 ==================
 
diff --git a/Documentation/arm/stm32/stm32h743-overview.rst b/Documentation/arm/stm32/stm32h743-overview.rst
index 3458dc00095d..c525835e7473 100644
--- a/Documentation/arm/stm32/stm32h743-overview.rst
+++ b/Documentation/arm/stm32/stm32h743-overview.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 STM32H743 Overview
 ==================
 
diff --git a/Documentation/arm/stm32/stm32mp157-overview.rst b/Documentation/arm/stm32/stm32mp157-overview.rst
index 62e176d47ca7..2c52cd020601 100644
--- a/Documentation/arm/stm32/stm32mp157-overview.rst
+++ b/Documentation/arm/stm32/stm32mp157-overview.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 STM32MP157 Overview
 ===================
 
diff --git a/Documentation/gpu/msm-crash-dump.rst b/Documentation/gpu/msm-crash-dump.rst
index 757cd257e0d8..240ef200f76c 100644
--- a/Documentation/gpu/msm-crash-dump.rst
+++ b/Documentation/gpu/msm-crash-dump.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =====================
 MSM Crash Dump Format
 =====================
diff --git a/Documentation/interconnect/interconnect.rst b/Documentation/interconnect/interconnect.rst
index c3e004893796..56e331dab70e 100644
--- a/Documentation/interconnect/interconnect.rst
+++ b/Documentation/interconnect/interconnect.rst
@@ -1,5 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
+:orphan:
+
 =====================================
 GENERIC SYSTEM INTERCONNECT SUBSYSTEM
 =====================================
diff --git a/Documentation/laptops/lg-laptop.rst b/Documentation/laptops/lg-laptop.rst
index aa503ee9b3bc..f2c2ffe31101 100644
--- a/Documentation/laptops/lg-laptop.rst
+++ b/Documentation/laptops/lg-laptop.rst
@@ -1,5 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0+
 
+:orphan:
+
 LG Gram laptop extra features
 =============================
 
diff --git a/Documentation/powerpc/isa-versions.rst b/Documentation/powerpc/isa-versions.rst
index 812e20cc898c..66c24140ebf1 100644
--- a/Documentation/powerpc/isa-versions.rst
+++ b/Documentation/powerpc/isa-versions.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 CPU to ISA Version Mapping
 ==========================
 
diff --git a/Documentation/virtual/kvm/amd-memory-encryption.rst b/Documentation/virtual/kvm/amd-memory-encryption.rst
index 659bbc093b52..33d697ab8a58 100644
--- a/Documentation/virtual/kvm/amd-memory-encryption.rst
+++ b/Documentation/virtual/kvm/amd-memory-encryption.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ======================================
 Secure Encrypted Virtualization (SEV)
 ======================================
diff --git a/Documentation/virtual/kvm/vcpu-requests.rst b/Documentation/virtual/kvm/vcpu-requests.rst
index 5feb3706a7ae..c1807a1b92e6 100644
--- a/Documentation/virtual/kvm/vcpu-requests.rst
+++ b/Documentation/virtual/kvm/vcpu-requests.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =================
 KVM VCPU Requests
 =================
-- 
2.21.0

