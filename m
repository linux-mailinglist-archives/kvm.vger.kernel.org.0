Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620F83D2139
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 11:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhGVJJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 05:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhGVJJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 05:09:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA69561241;
        Thu, 22 Jul 2021 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626947415;
        bh=7GVxSxRgZIdzJ6lnFwYXsdv5PMPY/E7tcirIbBJXBrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOV2+oe/EB+zEoZKuZkr29tu7wY9G+uROJzRJRHmZXBRX9h+sbJ9zs59MdKoN+Uph
         cm5K6Mf3vBqd14eSOOJvMOAf4naDGi+zSg1OHBBxBBdIl/jZl6v58LSgdf4yTu0xec
         tKoTnwYnb7sLCYW/inTegMlDciZEzvKCsUqIsKcKB6GzX4XSpV88zvlA0TdBzdHkcI
         tTJtIPpBQeNy84UZNZLTh81q0fAH6h4unvfjTUNQWImo1qjprSMD39LtL69PG2K7aS
         2u9DGlWrPv+FFJaDtihsgXUXKBiQI0FAqkHwBq031Z7STlADDfeZcsUxxByNEg5JmG
         inMmQd5XaFc9A==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1m6VLD-008lGn-Fv; Thu, 22 Jul 2021 11:50:07 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] docs: virt: kvm: api.rst: replace some characters
Date:   Thu, 22 Jul 2021 11:50:03 +0200
Message-Id: <ff70cb42d63f3a1da66af1b21b8d038418ed5189.1626947264.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1626947264.git.mchehab+huawei@kernel.org>
References: <cover.1626947264.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The conversion tools used during DocBook/LaTeX/html/Markdown->ReST
conversion and some cut-and-pasted text contain some characters that
aren't easily reachable on standard keyboards and/or could cause
troubles when parsed by the documentation build system.

Replace the occurences of the following characters:

	- U+00a0 (' '): NO-BREAK SPACE
	  as it can cause lines being truncated on PDF output

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/api.rst | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c7b165ca70b6..3a6118540747 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -855,7 +855,7 @@ in-kernel irqchip (GIC), and for in-kernel irqchip can tell the GIC to
 use PPIs designated for specific cpus.  The irq field is interpreted
 like this::
 
-  bits:  |  31 ... 28  | 27 ... 24 | 23  ... 16 | 15 ... 0 |
+  bits:  |  31 ... 28  | 27 ... 24 | 23  ... 16 | 15 ... 0 |
   field: | vcpu2_index | irq_type  | vcpu_index |  irq_id  |
 
 The irq_type field has the following values:
@@ -2149,10 +2149,10 @@ prior to calling the KVM_RUN ioctl.
 Errors:
 
   ======   ============================================================
-  ENOENT   no such register
-  EINVAL   invalid register ID, or no such register or used with VMs in
+  ENOENT   no such register
+  EINVAL   invalid register ID, or no such register or used with VMs in
            protected virtualization mode on s390
-  EPERM    (arm64) register access not allowed before vcpu finalization
+  EPERM    (arm64) register access not allowed before vcpu finalization
   ======   ============================================================
 
 (These error codes are indicative only: do not rely on a specific error
@@ -2590,10 +2590,10 @@ following id bit patterns::
 Errors include:
 
   ======== ============================================================
-  ENOENT   no such register
-  EINVAL   invalid register ID, or no such register or used with VMs in
+  ENOENT   no such register
+  EINVAL   invalid register ID, or no such register or used with VMs in
            protected virtualization mode on s390
-  EPERM    (arm64) register access not allowed before vcpu finalization
+  EPERM    (arm64) register access not allowed before vcpu finalization
   ======== ============================================================
 
 (These error codes are indicative only: do not rely on a specific error
@@ -3112,13 +3112,13 @@ current state.  "addr" is ignored.
 Errors:
 
   ======     =================================================================
-  EINVAL     the target is unknown, or the combination of features is invalid.
-  ENOENT     a features bit specified is unknown.
+  EINVAL     the target is unknown, or the combination of features is invalid.
+  ENOENT     a features bit specified is unknown.
   ======     =================================================================
 
 This tells KVM what type of CPU to present to the guest, and what
-optional features it should have.  This will cause a reset of the cpu
-registers to their initial values.  If this is not called, KVM_RUN will
+optional features it should have.  This will cause a reset of the cpu
+registers to their initial values.  If this is not called, KVM_RUN will
 return ENOEXEC for that vcpu.
 
 The initial values are defined as:
@@ -3239,8 +3239,8 @@ VCPU matching underlying host.
 Errors:
 
   =====      ==============================================================
-  E2BIG      the reg index list is too big to fit in the array specified by
-             the user (the number required will be written into n).
+  E2BIG      the reg index list is too big to fit in the array specified by
+             the user (the number required will be written into n).
   =====      ==============================================================
 
 ::
@@ -3288,7 +3288,7 @@ specific device.
 ARM/arm64 divides the id field into two parts, a device id and an
 address type id specific to the individual device::
 
-  bits:  | 63        ...       32 | 31    ...    16 | 15    ...    0 |
+  bits:  | 63        ...       32 | 31    ...    16 | 15    ...    0 |
   field: |        0x00000000      |     device id   |  addr type id  |
 
 ARM/arm64 currently only require this when using the in-kernel GIC
-- 
2.31.1

