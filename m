Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2242E137030
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 15:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgAJOyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 09:54:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44383 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728121AbgAJOyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 09:54:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578668084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zRIDXBcFA1npKL3bY9kDF0a2tZ99w/hj73UnpskP22g=;
        b=Iw/PRM+psFyub7kbGNQ0jIaU1aUzyKq2aGymROD16bMEh/kLL7xwmSeLR+aPMdUROU6zWu
        F2i/NRXRyxe2reFckhPfYzNthyOi6bMlhWl/zpaw0F/+o5nBdoUiW2f3Y0ibk7oYCC/U1U
        VrCvgtj1OSPZNqVjW0IbbHQd3ij2y58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-XZnWUPIoPGqsUdeBvjoPIw-1; Fri, 10 Jan 2020 09:54:42 -0500
X-MC-Unique: XZnWUPIoPGqsUdeBvjoPIw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E91B8C71A0;
        Fri, 10 Jan 2020 14:54:41 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-117-108.ams2.redhat.com [10.36.117.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C87D77BA5F;
        Fri, 10 Jan 2020 14:54:35 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 04/16] arm/arm64: gicv3: Add some re-distributor defines
Date:   Fri, 10 Jan 2020 15:54:00 +0100
Message-Id: <20200110145412.14937-5-eric.auger@redhat.com>
In-Reply-To: <20200110145412.14937-1-eric.auger@redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PROPBASER, PENDBASE and GICR_CTRL will be used for LPI management.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 lib/arm/asm/gic-v3.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 6beeab6..ffb2e26 100644
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
@@ -36,6 +37,11 @@
 #define GICR_ICENABLER0			GICD_ICENABLER
 #define GICR_IPRIORITYR0		GICD_IPRIORITYR
=20
+#define GICR_PROPBASER                  0x0070
+#define GICR_PENDBASER                  0x0078
+#define GICR_CTLR			GICD_CTLR
+#define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
+
 #define ICC_SGI1R_AFFINITY_1_SHIFT	16
 #define ICC_SGI1R_AFFINITY_2_SHIFT	32
 #define ICC_SGI1R_AFFINITY_3_SHIFT	48
--=20
2.20.1

