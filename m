Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2562C280D2E
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 07:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgJBFuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 01:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbgJBFt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 01:49:59 -0400
Received: from mail.kernel.org (ip5f5ad59f.dynamic.kabel-deutschland.de [95.90.213.159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83ACB208B6;
        Fri,  2 Oct 2020 05:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601617798;
        bh=W+WftqWQvk0umhBnRI3lw/fTCzD2Ao+YYmSzLVqon2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzKP5ruiYQlxyOj9hJ23C9smv3IqrqMPl7+kBSTPF5bZQhFaYVkCIsuZrc7cxDPQt
         zD1oOYVmUpvYtK3MocRa6VRT9OJNpneVd9iB8SG0ww9jY2kOmLqxHC7v0ke7xqrm/6
         HfZBh2E45NdgW4IbfPG98PyFT6X+mv8rmv8tKquw=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kODx6-006hin-9U; Fri, 02 Oct 2020 07:49:56 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] docs: vcpu.rst: fix some build warnings
Date:   Fri,  2 Oct 2020 07:49:46 +0200
Message-Id: <b5385dd0213f1f070667925bf7a807bf5270ba78.1601616399.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601616399.git.mchehab+huawei@kernel.org>
References: <cover.1601616399.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As warned with make htmldocs:

	.../Documentation/virt/kvm/devices/vcpu.rst:70: WARNING: Malformed table.
	Text in column margin in table line 2.

	=======  ======================================================
	-ENODEV: PMUv3 not supported or GIC not initialized
	-ENXIO:  PMUv3 not properly configured or in-kernel irqchip not
	         configured as required prior to calling this attribute
	-EBUSY:  PMUv3 already initialized
	-EINVAL: Invalid filter range
	=======  ======================================================

The ':' character for two lines are above the size of the column.
Besides that, other tables at the file doesn't use ':', so
just drop them.

While here, also fix this warning also introduced at the same patch:

	.../Documentation/virt/kvm/devices/vcpu.rst:88: WARNING: Block quote ends without a blank line; unexpected unindent.

By marking the C code as a literal block.

Fixes: 8be86a5eec04 ("KVM: arm64: Document PMU filtering API")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/devices/vcpu.rst | 26 ++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index da7c2ef7dafc..2acec3b9ef65 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -67,25 +67,25 @@ irqchip.
 :Returns:
 
 	 =======  ======================================================
-	 -ENODEV: PMUv3 not supported or GIC not initialized
-	 -ENXIO:  PMUv3 not properly configured or in-kernel irqchip not
+	 -ENODEV  PMUv3 not supported or GIC not initialized
+	 -ENXIO   PMUv3 not properly configured or in-kernel irqchip not
 	 	  configured as required prior to calling this attribute
-	 -EBUSY:  PMUv3 already initialized
-	 -EINVAL: Invalid filter range
+	 -EBUSY   PMUv3 already initialized
+	 -EINVAL  Invalid filter range
 	 =======  ======================================================
 
-Request the installation of a PMU event filter described as follows:
+Request the installation of a PMU event filter described as follows::
 
-struct kvm_pmu_event_filter {
-	__u16	base_event;
-	__u16	nevents;
+    struct kvm_pmu_event_filter {
+	    __u16	base_event;
+	    __u16	nevents;
 
-#define KVM_PMU_EVENT_ALLOW	0
-#define KVM_PMU_EVENT_DENY	1
+    #define KVM_PMU_EVENT_ALLOW	0
+    #define KVM_PMU_EVENT_DENY	1
 
-	__u8	action;
-	__u8	pad[3];
-};
+	    __u8	action;
+	    __u8	pad[3];
+    };
 
 A filter range is defined as the range [@base_event, @base_event + @nevents),
 together with an @action (KVM_PMU_EVENT_ALLOW or KVM_PMU_EVENT_DENY). The
-- 
2.26.2

