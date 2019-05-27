Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CAB2B943
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 18:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfE0Q4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 12:56:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45550 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbfE0Q4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 12:56:15 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9D4C0308FB9D;
        Mon, 27 May 2019 16:56:14 +0000 (UTC)
Received: from thuth.com (ovpn-116-235.ams2.redhat.com [10.36.116.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAFE7608A4;
        Mon, 27 May 2019 16:56:09 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: Remove obsolete address of the FSF
Date:   Mon, 27 May 2019 18:56:06 +0200
Message-Id: <20190527165606.28295-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 27 May 2019 16:56:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The FSF moved from the "Temple Place" to "51 Franklin Street" quite
a while ago already, so we should not refer to the old address in
the source code anymore. Anyway, instead of replacing it with the
new address, let's rather add proper SPDX identifiers here instead.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/x86/kvm/irq.c        | 10 +---------
 arch/x86/kvm/irq.h        | 10 +---------
 arch/x86/kvm/irq_comm.c   |  9 +--------
 virt/kvm/arm/arch_timer.c | 10 +---------
 virt/kvm/irqchip.c        | 10 +---------
 5 files changed, 5 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 007bc654f928..4b7b8e44df0f 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * irq.c: API for in kernel interrupt controller
  * Copyright (c) 2007, Intel Corporation.
@@ -7,17 +8,8 @@
  * under the terms and conditions of the GNU General Public License,
  * version 2, as published by the Free Software Foundation.
  *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
  * Authors:
  *   Yaozu (Eddie) Dong <Eddie.dong@intel.com>
- *
  */
 
 #include <linux/export.h>
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index fd210cdd4983..a904c9b3b76a 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * irq.h: in kernel interrupt controller related definitions
  * Copyright (c) 2007, Intel Corporation.
@@ -6,17 +7,8 @@
  * under the terms and conditions of the GNU General Public License,
  * version 2, as published by the Free Software Foundation.
  *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
  * Authors:
  *   Yaozu (Eddie) Dong <Eddie.dong@intel.com>
- *
  */
 
 #ifndef __IRQ_H
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 3cc3b2d130a0..ff95fd893e04 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * irq_comm.c: Common API for in kernel interrupt controller
  * Copyright (c) 2007, Intel Corporation.
@@ -6,14 +7,6 @@
  * under the terms and conditions of the GNU General Public License,
  * version 2, as published by the Free Software Foundation.
  *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
  * Authors:
  *   Yaozu (Eddie) Dong <Eddie.dong@intel.com>
  *
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 7fc272ecae16..151495d7dec7 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2012 ARM Ltd.
  * Author: Marc Zyngier <marc.zyngier@arm.com>
@@ -5,15 +6,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
 #include <linux/cpu.h>
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 79e59e4fa3dc..bcc3fc5d018a 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * irqchip.c: Common API for in kernel interrupt controllers
  * Copyright (c) 2007, Intel Corporation.
@@ -8,15 +9,6 @@
  * under the terms and conditions of the GNU General Public License,
  * version 2, as published by the Free Software Foundation.
  *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
- *
  * This file is derived from virt/kvm/irq_comm.c.
  *
  * Authors:
-- 
2.21.0

