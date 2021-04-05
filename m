Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18029354565
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 18:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242504AbhDEQk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 12:40:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41444 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242489AbhDEQkY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Apr 2021 12:40:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617640818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q2vyb2KEZ7b1rOARt2VnTGJGBkqDHtOIhkMjjuhsVvY=;
        b=cgeM1ttzQf5BV0GSdWiB0Lc2SbqyNS+h1ihKqYpeFV2ywJiKUQduR7pRTuW2ePRAdKeXYC
        7edQJIK7cyqvZwoQuUvNaAHCDXyy2ys5IJBmFLFBY0hIhkxXY5WCR4InyXhm+kU68Z4dqB
        JazeYp1hjAu7007sxwG8Wz/lIMpZzT0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-_4Q0O9tSMOaCB-9TEMrOYg-1; Mon, 05 Apr 2021 12:40:14 -0400
X-MC-Unique: _4Q0O9tSMOaCB-9TEMrOYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAACC87A83A;
        Mon,  5 Apr 2021 16:40:12 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3B6019715;
        Mon,  5 Apr 2021 16:40:05 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        pbonzini@redhat.com
Subject: [PATCH v6 5/9] docs: kvm: devices/arm-vgic-v3: enhance KVM_DEV_ARM_VGIC_CTRL_INIT doc
Date:   Mon,  5 Apr 2021 18:39:37 +0200
Message-Id: <20210405163941.510258-6-eric.auger@redhat.com>
In-Reply-To: <20210405163941.510258-1-eric.auger@redhat.com>
References: <20210405163941.510258-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_arch_vcpu_precreate() returns -EBUSY if the vgic is
already initialized. So let's document that KVM_DEV_ARM_VGIC_CTRL_INIT
must be called after all vcpu creations.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- Must be called after all vcpu creations ->
  Must be called after all VCPUs have been created as per
  Alexandru's suggestion
---
 Documentation/virt/kvm/devices/arm-vgic-v3.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index 5dd3bff51978..51e5e5762571 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -228,7 +228,7 @@ Groups:
 
     KVM_DEV_ARM_VGIC_CTRL_INIT
       request the initialization of the VGIC, no additional parameter in
-      kvm_device_attr.addr.
+      kvm_device_attr.addr. Must be called after all VCPUs have been created.
     KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
       save all LPI pending bits into guest RAM pending tables.
 
-- 
2.26.3

