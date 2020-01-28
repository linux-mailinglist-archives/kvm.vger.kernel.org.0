Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B20C214BC4D
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgA1Ovw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:51:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58442 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgA1N6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 08:58:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Z/uTEaWAPqmykjmqaZJAVwB7XFP3pqrhmBP5QoZS5Zs=; b=qEbvsb3c9peFLMbHQQ9ZRF6NlP
        WuYjK8ErWzE4qOhhh2tmvF8j/+6CwwMOeimHwgVQVBLkQ3mxKBPMQIKiGCn4YV6taBFhaujIaTAqV
        1XqXiPeC/9jdn2SXqEOElJHHbRP8WzGwJHbAcji8zQF2IVJXwnxqcwpCkBVGYTToBzs5Tk1gku9hg
        0bo7iA1ZzeY3kcsEgD9VVb/KwQlEOMe5ib51HifNEccolbS0BRVNLpupgWYZB3z/tgXkU6bjM/hVh
        b+8mJR/6Jb8FiZTlSxXihBjiZY3QokThFsXo8SJ5FHGk0dw8mTFK402b56A4K95ZgkYNwuEaS8D3A
        3u1c+u3Q==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRO7-0006Hr-0n; Tue, 28 Jan 2020 13:58:43 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRNq-001BKt-Vp; Tue, 28 Jan 2020 14:58:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 25/27] docs: kvm: Convert s390-diag.txt to ReST format
Date:   Tue, 28 Jan 2020 14:58:21 +0100
Message-Id: <614882a25b34203f6e1de2982b2d619bf1cfddc1.1580219586.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1580219586.git.mchehab+huawei@kernel.org>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This file is almost in ReST format. Just one change was
needed:

    - Add markups for a literal block and change its indentation.

While here, use the standard markup for the document title.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/index.rst                      |  1 +
 .../virt/kvm/{s390-diag.txt => s390-diag.rst}         | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)
 rename Documentation/virt/kvm/{s390-diag.txt => s390-diag.rst} (91%)

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index d0e17e717461..e5ea75f97d52 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -17,6 +17,7 @@ KVM
    msr
    nested-vmx
    ppc-pv
+   s390-diag
    vcpu-requests
 
    arm/index
diff --git a/Documentation/virt/kvm/s390-diag.txt b/Documentation/virt/kvm/s390-diag.rst
similarity index 91%
rename from Documentation/virt/kvm/s390-diag.txt
rename to Documentation/virt/kvm/s390-diag.rst
index 7c52e5f8b210..db6eb7a06b2a 100644
--- a/Documentation/virt/kvm/s390-diag.txt
+++ b/Documentation/virt/kvm/s390-diag.rst
@@ -1,3 +1,4 @@
+=============================
 The s390 DIAGNOSE call on KVM
 =============================
 
@@ -16,12 +17,12 @@ DIAGNOSE calls by the guest cause a mandatory intercept. This implies
 all supported DIAGNOSE calls need to be handled by either KVM or its
 userspace.
 
-All DIAGNOSE calls supported by KVM use the RS-a format:
+All DIAGNOSE calls supported by KVM use the RS-a format::
 
---------------------------------------
-|  '83'  | R1 | R3 | B2 |     D2     |
---------------------------------------
-0        8    12   16   20           31
+  --------------------------------------
+  |  '83'  | R1 | R3 | B2 |     D2     |
+  --------------------------------------
+  0        8    12   16   20           31
 
 The second-operand address (obtained by the base/displacement calculation)
 is not used to address data. Instead, bits 48-63 of this address specify
-- 
2.24.1

