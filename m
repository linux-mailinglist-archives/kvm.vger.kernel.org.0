Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D7B14BC29
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgA1OvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:51:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58494 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgA1N6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 08:58:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Tz48VZFw6Pyql4H3D79rMXp5boRr/1YzcV0w5QihF6k=; b=hopKLxjKjkFnVYM9ik6ecCc17V
        ONOolIwShQs+7+37yz64TndXwjqqbhr9J7ji03CW5QBnSS7ZsnDXEK8DC+Cepsii7LmraHdpAmtn3
        4/kLSAYf7QjfjCQJlME9bC5/vbhnPODDvJt2KytGPAVlR00tslhA/E8zr+z8nVncLEhwrlY0ms7aG
        K4kl3jXQ3Xsxvp7DFfRfbgddA3r4No89mA+qv5fEDnY41s1/5kAbyRhwKv1i9gFqXUFO1QC1ajNk8
        /Q43gPueOq7DeFXdrjTxw+iSD54uqvJnnTf/HuCzhWygrkufNK4rBM5siHnA/5C1e72ZkS92SgxFn
        spfUzeuQ==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRO8-0006KQ-87; Tue, 28 Jan 2020 13:58:44 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRNr-001BLC-1u; Tue, 28 Jan 2020 14:58:27 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 27/27] docs: kvm: review-checklist.txt: rename to ReST
Date:   Tue, 28 Jan 2020 14:58:23 +0100
Message-Id: <c9e9bdbba907bde63f0bd611fc997b5e2829c2d8.1580219586.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1580219586.git.mchehab+huawei@kernel.org>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This file is already in ReST compatible format.
So, rename it and add to the kvm's index.rst.

While here, use the standard conversion for document titles.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/index.rst                                | 2 ++
 .../virt/kvm/{review-checklist.txt => review-checklist.rst}     | 1 +
 2 files changed, 3 insertions(+)
 rename Documentation/virt/kvm/{review-checklist.txt => review-checklist.rst} (97%)

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index 7c1be8910837..774deaebf7fa 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -21,6 +21,8 @@ KVM
    timekeeping
    vcpu-requests
 
+   review-checklist
+
    arm/index
 
    devices/index
diff --git a/Documentation/virt/kvm/review-checklist.txt b/Documentation/virt/kvm/review-checklist.rst
similarity index 97%
rename from Documentation/virt/kvm/review-checklist.txt
rename to Documentation/virt/kvm/review-checklist.rst
index 499af499e296..d52e0bf96121 100644
--- a/Documentation/virt/kvm/review-checklist.txt
+++ b/Documentation/virt/kvm/review-checklist.rst
@@ -1,3 +1,4 @@
+================================
 Review checklist for kvm patches
 ================================
 
-- 
2.24.1

