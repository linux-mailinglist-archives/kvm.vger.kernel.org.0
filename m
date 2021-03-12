Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DBB33950B
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 18:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhCLRdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 12:33:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49304 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232975AbhCLRcu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 12:32:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615570369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0uKBYh1tSc08YlThe5x4w/3MJ8XTaEMc9L9bVozy6w0=;
        b=Lt30PN2jNDd0ECY6jYd3bRdc2tfD1VUwHO4BSdEAU8OSb3O4VhlUmMeWq6uvKJkBjVu20s
        jJvUoXWRAqfoVf8iAbKKXF+nnknhomuH5L8jNALo9g7bjHQ+AC5Fw1KHTerC6w9O1vu4gv
        0rlk0+SLrVNXKiitreR8Q5xGwAx81Go=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-e4DdS6LpMvKnHEPfN2M5vA-1; Fri, 12 Mar 2021 12:32:45 -0500
X-MC-Unique: e4DdS6LpMvKnHEPfN2M5vA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A791893920;
        Fri, 12 Mar 2021 17:32:43 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EF491002388;
        Fri, 12 Mar 2021 17:32:39 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH v3 5/8] docs: kvm: devices/arm-vgic-v3: enhance KVM_DEV_ARM_VGIC_CTRL_INIT doc
Date:   Fri, 12 Mar 2021 18:31:59 +0100
Message-Id: <20210312173202.89576-6-eric.auger@redhat.com>
In-Reply-To: <20210312173202.89576-1-eric.auger@redhat.com>
References: <20210312173202.89576-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
2.26.2

