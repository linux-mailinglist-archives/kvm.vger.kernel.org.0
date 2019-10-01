Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D95C3001
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 11:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387567AbfJAJVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 05:21:14 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:44200 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387492AbfJAJVN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Oct 2019 05:21:13 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iFEL7-00019A-Vi; Tue, 01 Oct 2019 11:21:02 +0200
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 4/4] KVM: arm/arm64: vgic: Use the appropriate TRACE_INCLUDE_PATH
Date:   Tue,  1 Oct 2019 10:20:38 +0100
Message-Id: <20191001092038.17097-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001092038.17097-1-maz@kernel.org>
References: <20191001092038.17097-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com, christoffer.dall@arm.com, yamada.masahiro@socionext.com, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

Commit 49dfe94fe5ad ("KVM: arm/arm64: Fix TRACE_INCLUDE_PATH") fixes
TRACE_INCLUDE_PATH to the correct relative path to the define_trace.h
and explains why did the old one work.

The same fix should be applied to virt/kvm/arm/vgic/trace.h.

Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/trace.h b/virt/kvm/arm/vgic/trace.h
index 55fed77a9f73..4fd4f6db181b 100644
--- a/virt/kvm/arm/vgic/trace.h
+++ b/virt/kvm/arm/vgic/trace.h
@@ -30,7 +30,7 @@ TRACE_EVENT(vgic_update_irq_pending,
 #endif /* _TRACE_VGIC_H */
 
 #undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH ../../../virt/kvm/arm/vgic
+#define TRACE_INCLUDE_PATH ../../virt/kvm/arm/vgic
 #undef TRACE_INCLUDE_FILE
 #define TRACE_INCLUDE_FILE trace
 
-- 
2.20.1

