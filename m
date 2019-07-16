Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0A36A852
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 14:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbfGPMK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 08:10:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39052 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732614AbfGPMK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 08:10:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QMIwWOkDZhbSv1tkbP0QuYT8NwD+Tfglqh9iJvnHnzE=; b=PMq353v4CT0VW90etLR7KOscpe
        xpy1QtJgOkbJoU82rCCQ6vmm/uWDpNpPomezrPSUxi2/XgLu5xjneIGNHDO8z5fD3ivHNTUMBFap3
        M76YI6ZNcOwIBb6bcZTcU+V/MhWAqNCjUCcE65C8iVt70PiyyFzwnvgBmm0V/kt/XgVF0+TT6+Y+E
        MPo7rwSsqCaphU0JiPCQfw+rIr5ZYxb5hKFj+hDrVWQR5WxWfF3Z1/OWr45KGM0T/hAixCHW9xnZO
        i9Qfg9Gn+1EPYAp6jh3NicGFU8h2TDBbkPQKoO9m5lHeAzDQ2lBiRQMDlLWra/8WWXFDYUrt286B0
        yC1VqIag==;
Received: from [189.27.46.152] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hnMIL-0004hx-8J; Tue, 16 Jul 2019 12:10:57 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hnMIJ-0000Rr-0k; Tue, 16 Jul 2019 09:10:55 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 14/14] docs: virtual: add it to the documentation body
Date:   Tue, 16 Jul 2019 09:10:53 -0300
Message-Id: <4f3cb004a5597926ccf930e123cb063cd99f1cea.1563277838.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1563277838.git.mchehab+samsung@kernel.org>
References: <cover.1563277838.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As files are getting converted to ReST, add them to the
documentation body.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/index.rst             | 1 +
 Documentation/virtual/kvm/index.rst | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/index.rst b/Documentation/index.rst
index 68ae2a4d689d..2df5a3da563c 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -115,6 +115,7 @@ needed).
    target/index
    timers/index
    watchdog/index
+   virtual/index
    input/index
    hwmon/index
    gpu/index
diff --git a/Documentation/virtual/kvm/index.rst b/Documentation/virtual/kvm/index.rst
index 0b206a06f5be..ada224a511fe 100644
--- a/Documentation/virtual/kvm/index.rst
+++ b/Documentation/virtual/kvm/index.rst
@@ -9,3 +9,4 @@ KVM
 
    amd-memory-encryption
    cpuid
+   vcpu-requests
-- 
2.21.0

