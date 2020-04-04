Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD7919E5AD
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgDDOiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:38:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59854 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726189AbgDDOiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 10:38:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HJXgouF5hnW6c32QC5HW05D5OVof60jHODwykFGab7c=;
        b=FJEcvjRC3G/OSI/OrdjTEdAjCaoQYjzgxu8vTLxh7n7/fdnKokVJjjeYPRYclR/uVQ4nrZ
        WVvaW46L+jZlbNU07r4o6qGNgxI8vbbwlzN/8xLm/hSo7aOdZVCdKl+Cpg6UQYDSuqh/TL
        zPEfIO4ubS22z6RMgm269KPafFP3SLw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-vZ5SYYPXO0q_xL4SSS9zSg-1; Sat, 04 Apr 2020 10:38:08 -0400
X-MC-Unique: vZ5SYYPXO0q_xL4SSS9zSg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5085D107ACC7;
        Sat,  4 Apr 2020 14:38:07 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 660F51147D3;
        Sat,  4 Apr 2020 14:38:03 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PULL kvm-unit-tests 11/39] arm/arm64: gic: Move gic_state enumeration to asm/gic.h
Date:   Sat,  4 Apr 2020 16:37:03 +0200
Message-Id: <20200404143731.208138-12-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

The status of each interrupt are defined by the GIC architecture and
maintained by GIC hardware.  They're not specified to the timer HW.
Let's move this software enumeration to a more proper place.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c       | 7 -------
 lib/arm/asm/gic.h | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index dea364f5355d..94543f231ba9 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -17,13 +17,6 @@
 #define ARCH_TIMER_CTL_IMASK   (1 << 1)
 #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
=20
-enum gic_state {
-	GIC_STATE_INACTIVE,
-	GIC_STATE_PENDING,
-	GIC_STATE_ACTIVE,
-	GIC_STATE_ACTIVE_PENDING,
-};
-
 static void *gic_isactiver;
 static void *gic_ispendr;
 static void *gic_isenabler;
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 09826fd5bc29..a72e0cde4e9c 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -47,6 +47,13 @@
 #ifndef __ASSEMBLY__
 #include <asm/cpumask.h>
=20
+enum gic_state {
+	GIC_STATE_INACTIVE,
+	GIC_STATE_PENDING,
+	GIC_STATE_ACTIVE,
+	GIC_STATE_ACTIVE_PENDING,
+};
+
 /*
  * gic_init will try to find all known gics, and then
  * initialize the gic data for the one found.
--=20
2.25.1

