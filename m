Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2462214BC38
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgA1Ovg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:51:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58454 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgA1N6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 08:58:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/hfBTm+pwI/qMUzI6610HUXH01FV0FRb49kTIzGz0Ww=; b=t9ykKbpknrNnDM3UctKfI8f4Y7
        4PkIUnKL+6+v2tP0G+057NZ6Y2DzDsc+qu4gH+GDr3WyjLtwaKdFYUGU2PMjUkesdUlxy6JJED1+6
        UWn3pF3fth6sR8cpJNwoKYrpewCCjQNLqnDoemlKL6VfFHt3sfCt/9sj6LujaIm4sg0Ax2dMdaOF8
        muO8pzKpt9LNPt00uVMMRLbSnQzgwQgtIw/UvukvLZJ+6WpqTL+ksP6C/D1F1nITgSGRhznrjys+s
        jBkPf+50m9rMJCJ5dSfuRBVuioGIx3wzOotXI814povNgISLktSrvM090/naE8+JDdfS3KAj4UyY2
        ABVNuEcQ==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRO7-0006Hx-1I; Tue, 28 Jan 2020 13:58:43 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRNq-001BJE-2o; Tue, 28 Jan 2020 14:58:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 01/27] docs: kvm: add arm/pvtime.rst to index.rst
Date:   Tue, 28 Jan 2020 14:57:57 +0100
Message-Id: <8efe846ddd76d97a62a150a997619e5d7d992774.1580219586.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1580219586.git.mchehab+huawei@kernel.org>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add this file to a new kvm/arm index.rst, in order for it to
be shown as part of the virt book.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/arm/index.rst | 10 ++++++++++
 Documentation/virt/kvm/index.rst     |  2 ++
 2 files changed, 12 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/index.rst

diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
new file mode 100644
index 000000000000..e039d9b1e076
--- /dev/null
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -0,0 +1,10 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===
+ARM
+===
+
+.. toctree::
+   :maxdepth: 2
+
+   pvtime
diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index ada224a511fe..488c6370a447 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -10,3 +10,5 @@ KVM
    amd-memory-encryption
    cpuid
    vcpu-requests
+
+   arm/index
-- 
2.24.1

