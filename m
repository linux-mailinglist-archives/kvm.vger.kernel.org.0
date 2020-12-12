Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D052D8970
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 19:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439756AbgLLSwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Dec 2020 13:52:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407755AbgLLSwR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Dec 2020 13:52:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607799051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+A3phxBKaaaLjrjDmzMcORteXFYyi2v6m11ADHyJ5AE=;
        b=J2pxx60hie9jnLBebMm8L26YWttmV47tpvEaIQZP58ZAaqJBZJ3wARXg479ovdECXRUt+o
        QZW7zwRjM5NJhS+DRxnEKHHiTFhs/KxrN8o7hFk4QwN/FEoyqNUeXQ8k72ps4GyUn4hqRf
        9UIv6RNmpL4yDH39JGvPFjn2RywcfCY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-c1s9mzLFP_-x7xrl0AmGAg-1; Sat, 12 Dec 2020 13:50:50 -0500
X-MC-Unique: c1s9mzLFP_-x7xrl0AmGAg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57DFC10054FF;
        Sat, 12 Dec 2020 18:50:48 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-41.ams2.redhat.com [10.36.115.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76CF01F069;
        Sat, 12 Dec 2020 18:50:45 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     alexandru.elisei@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH 6/9] docs: kvm: devices/arm-vgic-v3: enhance KVM_DEV_ARM_VGIC_CTRL_INIT doc
Date:   Sat, 12 Dec 2020 19:50:07 +0100
Message-Id: <20201212185010.26579-7-eric.auger@redhat.com>
In-Reply-To: <20201212185010.26579-1-eric.auger@redhat.com>
References: <20201212185010.26579-1-eric.auger@redhat.com>
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
 Documentation/virt/kvm/devices/arm-vgic-v3.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index 5dd3bff51978..322de6aebdec 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -228,7 +228,7 @@ Groups:
 
     KVM_DEV_ARM_VGIC_CTRL_INIT
       request the initialization of the VGIC, no additional parameter in
-      kvm_device_attr.addr.
+      kvm_device_attr.addr. Must be called after all vcpu creations.
     KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
       save all LPI pending bits into guest RAM pending tables.
 
-- 
2.21.3

