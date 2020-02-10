Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF34156F22
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 07:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgBJGDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 01:03:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36464 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbgBJGDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 01:03:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3atzUbHUpUbwJ3lq7O6PizLnLBeHoo1f0Hi0KPfYLDo=; b=QJLxhPB5Y0ribOiXGII8xFfdQ8
        sIE56jKaoX2Jeo0EjIORZIXvIbRmYWQlqbESHlKzzEJtOejy333Xs5pF0Z+6UIKTKPpntblRi2eD3
        GUMuFq+Q0R94hY2UwMrje113SE3CrtFpiJL+fB32rpJ6W6UM9oF+08H0BpXCwMAxxsWLQuQRY1+M6
        QNo08+EpRghAiKG1jGi+au9QlYtl5B/bUNFloD1CPQsAwMPP6s3hB8TsiWG8cR9WwgRZ0ERm7wCPy
        LzuFo1XmnNhnHCm2+TsPNKhZmNnRpZBTYB7WijJJ4heBAVOkKJpEeqQLG3q0PGePCaTJUu/FzvUFt
        AZl8F61Q==;
Received: from [80.156.29.194] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j12A5-0006V2-GP; Mon, 10 Feb 2020 06:03:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1j12A3-00C2Wk-Pa; Mon, 10 Feb 2020 07:03:11 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH 27/28] docs: kvm: review-checklist.txt: rename to ReST
Date:   Mon, 10 Feb 2020 07:03:05 +0100
Message-Id: <fbd068ed7445d0ea51052cb50d66cd8983e39b08.1581314317.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581314316.git.mchehab+huawei@kernel.org>
References: <cover.1581314316.git.mchehab+huawei@kernel.org>
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
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 Documentation/virt/kvm/index.rst                               | 2 ++
 .../virt/kvm/{review-checklist.txt => review-checklist.rst}    | 3 +++
 2 files changed, 5 insertions(+)
 rename Documentation/virt/kvm/{review-checklist.txt => review-checklist.rst} (95%)

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
similarity index 95%
rename from Documentation/virt/kvm/review-checklist.txt
rename to Documentation/virt/kvm/review-checklist.rst
index 499af499e296..1f86a9d3f705 100644
--- a/Documentation/virt/kvm/review-checklist.txt
+++ b/Documentation/virt/kvm/review-checklist.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================================
 Review checklist for kvm patches
 ================================
 
-- 
2.24.1

