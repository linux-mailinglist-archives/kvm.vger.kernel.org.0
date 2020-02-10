Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C71156F4F
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 07:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgBJGED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 01:04:03 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36310 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgBJGDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 01:03:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8GfzltQhS3v+ZlAaDJGjOA5DZ8pCcqwOMokM0PKMq0I=; b=UV5Hfzhxx/q9CXwJ+S2gPVFR02
        xGVsRspuI/Hs7JhCor9wCkWak8R55BUoiltwJ1+jX9DiIOVGiZEdCyHWQnpDk2v6Dkw0+wzykaalF
        nAVy5puQLGx7oI95Uuysare59M228Eu8OujSw27zXYa2ge9hDvj5qY86TpNcZEVZzASoMRLH/SAoO
        CBK7oJtUrbNDW94baXHod6TgkaqSGe3BUMFHo1PshH8lBLNS40A+iPs1h0vdLrwbs6NgqhIEnU2+d
        1MnJuaUHE+XsHBfLJ78JhcdoSd43SXOJBCCO3Jlf8qDswHhG5e6na0f7DEB6SbkscAtlWQKfulaOO
        AAX0I/Kw==;
Received: from [80.156.29.194] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j12A3-0006Tn-R8; Mon, 10 Feb 2020 06:03:11 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1j12A2-00C2Vb-63; Mon, 10 Feb 2020 07:03:10 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH 13/28] docs: kvm: convert devices/vfio.txt to ReST
Date:   Mon, 10 Feb 2020 07:02:51 +0100
Message-Id: <b3c9acd041a6097fb246aa5337737127e9c014a3.1581314317.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581314316.git.mchehab+huawei@kernel.org>
References: <cover.1581314316.git.mchehab+huawei@kernel.org>
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
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
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

