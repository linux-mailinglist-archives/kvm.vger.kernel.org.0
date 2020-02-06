Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14AD15468F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgBFOum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:50:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55578 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbgBFOuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Xb2eNgwrC898oYbNqzuMV7ovBYhNc/yn4b5J/jn4QTY=; b=dGYyz5GfgFKIEyiHigh5cXYP1J
        fVd5GKitRvzT67FNvqGS2fX2AO5F7ddD95DxNM9+EtWfaJ7TOHy0QDDfz0stUhRQLelU8kV4O9asN
        u0Y+r2KmvNlaCUc1BO/qgh29bWjQkCY8f28n7EAidV5QHjV4RLod7u23vL8dAFVcm9JKUFXhjnZg0
        txbGDkb9qs4ttvv3WYujw6y2lPxO4bg+yvt+T/ki7qTuwTqBtAilCKzV/xMHGW5asJUMLYqXlC9+k
        Ds0i1WkAWzHnbfN5Tv1Tbxoq4p8nqYTsqKR1FMPNf/Rgkr118xur509Fk6uXjIuacqod2uZDvGdmD
        VgdKLXAg==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziUI-0004In-Tw; Thu, 06 Feb 2020 14:50:38 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziU7-002nMK-7u; Thu, 06 Feb 2020 15:50:27 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 27/27] docs: kvm: review-checklist.txt: rename to ReST
Date:   Thu,  6 Feb 2020 15:50:24 +0100
Message-Id: <8efe2cb409b6aaea2f01f4167db3c13e816129c5.1581000481.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
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

