Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D2214BC0F
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbgA1Ou5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:50:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58484 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgA1N6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 08:58:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MfbPPBfVOsZ1ekqbduEWSsRYBXTtAjqiqdXfPqQdPuI=; b=CCjM22PSEzorvo4GHpNnagyNlq
        xBF/1TnUeLHMrOXFIX3fMm1RwvQOO4zFvYqePgwGLe/Cem7R4uqdDpHy7K9Uf8V5Nkl+BLluP2KVt
        txv+OkPOX8vF4MVUJlIgv1UgI4trEZK0Re3tsLVDAcqOx5hkT2x7evYnKCl1N5MwcPDv+0XMFF8gu
        0TSI5GUho3EUIGJRRR2uDYn+wUivA6+yUyVyEd9ySL/9atfdPUv+ENB6vGJidVfLe2eUUDpG7jqhs
        cZ8LA94GQ5Nrgl/avCTaQdjspTdJ2q05wwrbdG2m/oLw1XS5m7mf6rRZuSXIzeFdP0PViDwHh7B4p
        8Msmfmjg==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRO8-0006KS-1K; Tue, 28 Jan 2020 13:58:44 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRNq-001BK1-H7; Tue, 28 Jan 2020 14:58:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 13/27] docs: kvm: convert devices/vcpu.txt to ReST
Date:   Tue, 28 Jan 2020 14:58:09 +0100
Message-Id: <b53d6dcb4e2e8f705750379b339bd534770cfd7d.1580219586.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1580219586.git.mchehab+huawei@kernel.org>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Use standard title markup;
- adjust lists;
- mark code blocks as such.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/devices/index.rst      |  1 +
 .../virt/kvm/devices/{vfio.txt => vfio.rst}   | 23 +++++++++++--------
 2 files changed, 14 insertions(+), 10 deletions(-)
 rename Documentation/virt/kvm/devices/{vfio.txt => vfio.rst} (74%)

diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/kvm/devices/index.rst
index 5a61838f0e61..cbbadda080d0 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -13,3 +13,4 @@ Devices
    mpic
    s390_flic
    vcpu
+   vfio
diff --git a/Documentation/virt/kvm/devices/vfio.txt b/Documentation/virt/kvm/devices/vfio.rst
similarity index 74%
rename from Documentation/virt/kvm/devices/vfio.txt
rename to Documentation/virt/kvm/devices/vfio.rst
index 528c77c8022c..07a1acde25e4 100644
--- a/Documentation/virt/kvm/devices/vfio.txt
+++ b/Documentation/virt/kvm/devices/vfio.rst
@@ -1,8 +1,10 @@
+===================
 VFIO virtual device
 ===================
 
 Device types supported:
-  KVM_DEV_TYPE_VFIO
+
+  - KVM_DEV_TYPE_VFIO
 
 Only one VFIO instance may be created per VM.  The created device
 tracks VFIO groups in use by the VM and features of those groups
@@ -23,14 +25,15 @@ KVM_DEV_VFIO_GROUP attributes:
 	for the VFIO group.
   KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE: attaches a guest visible TCE table
 	allocated by sPAPR KVM.
-	kvm_device_attr.addr points to a struct:
+	kvm_device_attr.addr points to a struct::
 
-	struct kvm_vfio_spapr_tce {
-		__s32	groupfd;
-		__s32	tablefd;
-	};
+		struct kvm_vfio_spapr_tce {
+			__s32	groupfd;
+			__s32	tablefd;
+		};
 
-	where
-	@groupfd is a file descriptor for a VFIO group;
-	@tablefd is a file descriptor for a TCE table allocated via
-		KVM_CREATE_SPAPR_TCE.
+	where:
+
+	- @groupfd is a file descriptor for a VFIO group;
+	- @tablefd is a file descriptor for a TCE table allocated via
+	  KVM_CREATE_SPAPR_TCE.
-- 
2.24.1

