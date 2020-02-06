Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6CC515468B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgBFOul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:50:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55582 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727594AbgBFOuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Oubdpe6/C58Mfaf/vorfKBeZCdSFQ+I3zGJB/q18Nag=; b=SwDkiTm4fVlZhUrcHK7U3D+4ms
        FQw7aia81K/wvukwEvoR98ywjQzZ4AhzLpOWurB9fkSIqVnwvk6LylKdYHmbCcq1aDoAJ5sTVmDzt
        9aWMpkI7vCSa09K06xBoT0LRv36OspReP+wnqC+NrJmwIxYVdsZVNQ4ac9AJi7yZ1a+HkYQ9fbgGy
        LikHNeEPDKejMvL+35pCLNrO/F98D6XTVuVO8dThD5JQfafHTvNO4ZkQ9ITfEkSRBac2IUGoTWkW3
        znbRcqcLpQTOoAUfiIvkvnH5apSw4chPl9kG+edo9JC6Ink5jE0gVz9cQdLnkpcV8Xu9RRpLitl2Y
        GTWrzLiA==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziUI-0004Iq-UJ; Thu, 06 Feb 2020 14:50:38 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziU6-002nL7-LM; Thu, 06 Feb 2020 15:50:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 13/27] docs: kvm: convert devices/vcpu.txt to ReST
Date:   Thu,  6 Feb 2020 15:50:10 +0100
Message-Id: <3c02c923c84af973f6a783c10d86d7312f16e6c5.1581000481.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
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
 .../virt/kvm/devices/{vfio.txt => vfio.rst}   | 25 +++++++++++--------
 2 files changed, 16 insertions(+), 10 deletions(-)
 rename Documentation/virt/kvm/devices/{vfio.txt => vfio.rst} (72%)

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
similarity index 72%
rename from Documentation/virt/kvm/devices/vfio.txt
rename to Documentation/virt/kvm/devices/vfio.rst
index 528c77c8022c..2d20dc561069 100644
--- a/Documentation/virt/kvm/devices/vfio.txt
+++ b/Documentation/virt/kvm/devices/vfio.rst
@@ -1,8 +1,12 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
 VFIO virtual device
 ===================
 
 Device types supported:
-  KVM_DEV_TYPE_VFIO
+
+  - KVM_DEV_TYPE_VFIO
 
 Only one VFIO instance may be created per VM.  The created device
 tracks VFIO groups in use by the VM and features of those groups
@@ -23,14 +27,15 @@ KVM_DEV_VFIO_GROUP attributes:
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

