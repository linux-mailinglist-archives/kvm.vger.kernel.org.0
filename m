Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2CCB14B5FA
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgA1OBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:01:16 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59282 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbgA1OAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 09:00:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MfbPPBfVOsZ1ekqbduEWSsRYBXTtAjqiqdXfPqQdPuI=; b=aBQ9Hrv/71Hg26WLtVc5E2auPr
        2GVZK3Jem/WMCd+XFWJdaVxcFuZNej7dVqKOpzjW3z3176P3ZBWtwNXnirpuqn+I+nASxQKziHiPX
        drN3T03CZq7FsHD1IHKK3SsYjqr/WINVz6gHeK6DD6XwEY0PLg2l6cka31NEASl2Kmrq0bHctPHZQ
        /lNpx8z2c6ZFRzStR+dv/iUkEtbGYGTHf7Ri4ASls5f55llAKrHsml082OHDjjHDtaToYjfgdyCb9
        3azeYHt82sOALev1WwPGxWYWC3/IlkzukhQS2E9drF256+r/TU23DcUEy1feot3iAVFJMy3oy7rNF
        Kojul6SA==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRQ5-0007ir-V2; Tue, 28 Jan 2020 14:00:45 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRPp-001BOE-Kd; Tue, 28 Jan 2020 15:00:29 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 13/27] docs: kvm: convert devices/vcpu.txt to ReST
Date:   Tue, 28 Jan 2020 15:00:14 +0100
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

