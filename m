Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B533E156F24
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 07:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbgBJGDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 01:03:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36458 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbgBJGDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 01:03:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=v0HoWkcIfPjQPsHagVx5eBe/TlRMM8+XhIwobLt5XOw=; b=QwGtCIII2TMvX3zAHgzKxUcYny
        o7K2r1kZWJFL+aJROK5R4rngdQo51C5XDS9BIW8KRst0dOTDkg0sPeAuuL6h2aLH9Tudcy1dLY/jv
        zO1bZFm4CUUEHcDzBbjHSOzmu6IMV7MbmMp3VMrZeLovF7V3f/E4NBpchsPY5o8nD2f3lU/dCLr5r
        VLL329/b6hwDTob4K9Yso33+T1o/00Cx+mHYBjR8RF67JtoDE/UAI6Aos6kpyyPUsdg5x4ISFqWau
        lxBL9ykAf/+HRg35LNXccjj6TnW9kMIYudIBtqCI6gnOuo2yf6tqXRSdcFCPg8hIhJdarF12KObVJ
        b6T0nyuA==;
Received: from [80.156.29.194] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j12A5-0006Uw-Di; Mon, 10 Feb 2020 06:03:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1j12A2-00C2Wa-Oe; Mon, 10 Feb 2020 07:03:11 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH 25/28] docs: kvm: Convert s390-diag.txt to ReST format
Date:   Mon, 10 Feb 2020 07:03:03 +0100
Message-Id: <a8eca63055ab37b7dd876f76518a0ba517687f62.1581314317.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581314316.git.mchehab+huawei@kernel.org>
References: <cover.1581314316.git.mchehab+huawei@kernel.org>
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
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 Documentation/virt/kvm/index.rst                    |  1 +
 .../virt/kvm/{s390-diag.txt => s390-diag.rst}       | 13 ++++++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)
 rename Documentation/virt/kvm/{s390-diag.txt => s390-diag.rst} (90%)

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
similarity index 90%
rename from Documentation/virt/kvm/s390-diag.txt
rename to Documentation/virt/kvm/s390-diag.rst
index 7c52e5f8b210..eaac4864d3d6 100644
--- a/Documentation/virt/kvm/s390-diag.txt
+++ b/Documentation/virt/kvm/s390-diag.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============================
 The s390 DIAGNOSE call on KVM
 =============================
 
@@ -16,12 +19,12 @@ DIAGNOSE calls by the guest cause a mandatory intercept. This implies
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

