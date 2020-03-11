Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2798181A34
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 14:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgCKNv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 09:51:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30166 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729714AbgCKNv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 09:51:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583934716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HV5vvbw31wyEYrQ32o2dc0uwSfN4maLDv7794Qu4y+I=;
        b=ZFfipMu4JgdgHjRSL5pvZ95mEt+g1gqal6X+6/gPWfvXZaN8uU6LyoGIxBrFPs85kwzGGU
        LkvWwQuec7raT9C0N7ta72Tuaiq5KsXaP0GIVvx6LJq0pbg9IKtRj0Jojs16oibyu7zYSO
        W2uBz6KBbpChgif2GENfOjEF1fjzgQ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-gfMbWxfiNsewb4CrSNSEmA-1; Wed, 11 Mar 2020 09:51:52 -0400
X-MC-Unique: gfMbWxfiNsewb4CrSNSEmA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D3D7189F762;
        Wed, 11 Mar 2020 13:51:50 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4371F5C13D;
        Wed, 11 Mar 2020 13:51:42 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v6 04/13] arm/arm64: gicv3: Add some re-distributor defines
Date:   Wed, 11 Mar 2020 14:51:08 +0100
Message-Id: <20200311135117.9366-5-eric.auger@redhat.com>
In-Reply-To: <20200311135117.9366-1-eric.auger@redhat.com>
References: <20200311135117.9366-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PROPBASER, PENDBASE and GICR_CTRL will be used for LPI management.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

---

v3 -> v4:
- replace some spaces by tabs and added Zenghui's R-b
---
 lib/arm/asm/gic-v3.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index e2736a1..47df051 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -18,6 +18,7 @@
  * We expect to be run in Non-secure mode, thus we define the
  * group1 enable bits with respect to that view.
  */
+#define GICD_CTLR			0x0000
 #define GICD_CTLR_RWP			(1U << 31)
 #define GICD_CTLR_ARE_NS		(1U << 4)
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
@@ -38,6 +39,11 @@
 #define GICR_ICACTIVER0			GICD_ICACTIVER
 #define GICR_IPRIORITYR0		GICD_IPRIORITYR
=20
+#define GICR_PROPBASER			0x0070
+#define GICR_PENDBASER			0x0078
+#define GICR_CTLR			GICD_CTLR
+#define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
+
 #define ICC_SGI1R_AFFINITY_1_SHIFT	16
 #define ICC_SGI1R_AFFINITY_2_SHIFT	32
 #define ICC_SGI1R_AFFINITY_3_SHIFT	48
--=20
2.20.1

