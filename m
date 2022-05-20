Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E69952EAAA
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 13:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346616AbiETLXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 07:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbiETLXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 07:23:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67BD1B36CE
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 04:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653045797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DhPW5VXQyaapTMu/BLT7e8mRErIyIOLdoT3nKh9o7zE=;
        b=K5l0n4FjjbG8o6TGuR/5g/g6AU5e21bNvlxG+EbMQk285nXhOTffduAyUA+vMkasTW/YA5
        xx+yGLlJJzU8/thsqqf1m+k5BjTBB88+Y4fa81CARNP+P2n6PIB1zxsLYVjLNtEW14DfqG
        9deyWr1895AJ6ptnkT9EIegMF+5Ug+E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-WgBOqz6yNy-U-sPyUKpLaA-1; Fri, 20 May 2022 07:23:12 -0400
X-MC-Unique: WgBOqz6yNy-U-sPyUKpLaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CABEA29AA2FD;
        Fri, 20 May 2022 11:23:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A206E1121314;
        Fri, 20 May 2022 11:23:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org
Subject: [PATCH] Documentation: kvm: reorder ARM-specific section about KVM_SYSTEM_EVENT_SUSPEND
Date:   Fri, 20 May 2022 07:23:11 -0400
Message-Id: <20220520112311.3307024-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 52 +++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3201933e52d9..6890c04ccde2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6170,32 +6170,6 @@ Valid values for 'type' are:
  - KVM_SYSTEM_EVENT_SUSPEND -- the guest has requested a suspension of
    the VM.
 
-For arm/arm64:
---------------
-
-   KVM_SYSTEM_EVENT_SUSPEND exits are enabled with the
-   KVM_CAP_ARM_SYSTEM_SUSPEND VM capability. If a guest invokes the PSCI
-   SYSTEM_SUSPEND function, KVM will exit to userspace with this event
-   type.
-
-   It is the sole responsibility of userspace to implement the PSCI
-   SYSTEM_SUSPEND call according to ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND".
-   KVM does not change the vCPU's state before exiting to userspace, so
-   the call parameters are left in-place in the vCPU registers.
-
-   Userspace is _required_ to take action for such an exit. It must
-   either:
-
-    - Honor the guest request to suspend the VM. Userspace can request
-      in-kernel emulation of suspension by setting the calling vCPU's
-      state to KVM_MP_STATE_SUSPENDED. Userspace must configure the vCPU's
-      state according to the parameters passed to the PSCI function when
-      the calling vCPU is resumed. See ARM DEN0022D.b 5.19.1 "Intended use"
-      for details on the function parameters.
-
-    - Deny the guest request to suspend the VM. See ARM DEN0022D.b 5.19.2
-      "Caller responsibilities" for possible return values.
-
 If KVM_CAP_SYSTEM_EVENT_DATA is present, the 'data' field can contain
 architecture specific information for the system-level event.  Only
 the first `ndata` items (possibly zero) of the data array are valid.
@@ -6211,6 +6185,32 @@ Previous versions of Linux defined a `flags` member in this struct.  The
 field is now aliased to `data[0]`.  Userspace can assume that it is only
 written if ndata is greater than 0.
 
+For arm/arm64:
+--------------
+
+KVM_SYSTEM_EVENT_SUSPEND exits are enabled with the
+KVM_CAP_ARM_SYSTEM_SUSPEND VM capability. If a guest invokes the PSCI
+SYSTEM_SUSPEND function, KVM will exit to userspace with this event
+type.
+
+It is the sole responsibility of userspace to implement the PSCI
+SYSTEM_SUSPEND call according to ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND".
+KVM does not change the vCPU's state before exiting to userspace, so
+the call parameters are left in-place in the vCPU registers.
+
+Userspace is _required_ to take action for such an exit. It must
+either:
+
+ - Honor the guest request to suspend the VM. Userspace can request
+   in-kernel emulation of suspension by setting the calling vCPU's
+   state to KVM_MP_STATE_SUSPENDED. Userspace must configure the vCPU's
+   state according to the parameters passed to the PSCI function when
+   the calling vCPU is resumed. See ARM DEN0022D.b 5.19.1 "Intended use"
+   for details on the function parameters.
+
+ - Deny the guest request to suspend the VM. See ARM DEN0022D.b 5.19.2
+   "Caller responsibilities" for possible return values.
+
 ::
 
 		/* KVM_EXIT_IOAPIC_EOI */
-- 
2.31.1

