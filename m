Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B40ADA59
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 15:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404923AbfIINtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 09:49:22 -0400
Received: from foss.arm.com ([217.140.110.172]:50722 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404916AbfIINtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 09:49:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7B5E1AED;
        Mon,  9 Sep 2019 06:49:21 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DC553F59C;
        Mon,  9 Sep 2019 06:49:19 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 12/17] KVM: arm/arm64: vgic: Make function comments match function declarations
Date:   Mon,  9 Sep 2019 14:48:02 +0100
Message-Id: <20190909134807.27978-13-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
References: <20190909134807.27978-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

Since commit 503a62862e8f ("KVM: arm/arm64: vgic: Rely on the GIC driver to
parse the firmware tables"), the vgic_v{2,3}_probe functions stopped using
a DT node. Commit 909777324588 ("KVM: arm/arm64: vgic-new: vgic_init:
implement kvm_vgic_hyp_init") changed the functions again, and now they
require exactly one argument, a struct gic_kvm_info populated by the GIC
driver. Unfortunately the comments regressed and state that a DT node is
used instead. Change the function comments to reflect the current
prototypes.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-v2.c | 7 ++++---
 virt/kvm/arm/vgic/vgic-v3.c | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 96aab77d0471..e67945020b45 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -354,10 +354,11 @@ int vgic_v2_map_resources(struct kvm *kvm)
 DEFINE_STATIC_KEY_FALSE(vgic_v2_cpuif_trap);
 
 /**
- * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
- * @node:	pointer to the DT node
+ * vgic_v2_probe - probe for a VGICv2 compatible interrupt controller
+ * @info:	pointer to the GIC description
  *
- * Returns 0 if a GICv2 has been found, returns an error code otherwise
+ * Returns 0 if the VGICv2 has been probed successfully, returns an error code
+ * otherwise
  */
 int vgic_v2_probe(const struct gic_kvm_info *info)
 {
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 0c653a1e5215..30955d162a01 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -570,10 +570,11 @@ static int __init early_gicv4_enable(char *buf)
 early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
 
 /**
- * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
- * @node:	pointer to the DT node
+ * vgic_v3_probe - probe for a VGICv3 compatible interrupt controller
+ * @info:	pointer to the GIC description
  *
- * Returns 0 if a GICv3 has been found, returns an error code otherwise
+ * Returns 0 if the VGICv3 has been probed successfully, returns an error code
+ * otherwise
  */
 int vgic_v3_probe(const struct gic_kvm_info *info)
 {
-- 
2.20.1

