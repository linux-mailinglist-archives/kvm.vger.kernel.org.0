Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D00D381DF1
	for <lists+kvm@lfdr.de>; Sun, 16 May 2021 12:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhEPKUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 May 2021 06:20:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231480AbhEPKTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 May 2021 06:19:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8941961242;
        Sun, 16 May 2021 10:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621160317;
        bh=vfreIcvlPF/8OZus3kXkczSP81akAE9RkS16w+hHttA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwEBNtghW9V/jdln44alW/pcRzsAKaWn4I/FBghqmMFEbIuQ7jbjvX7EwOm4sZAtv
         U7plEhjM+Kpzj5sEyxEjZLAu/XL1lWRuZYeDJ+AwA5SoIj7fMOPbh8Md4LGXl2674a
         BXHfTHf5UM2qWrOJvM4hURQCGiu12+xLYon2xqrxGP91Pb6JDQh1sVTYfWFawDCssJ
         KhzbNsv8V320MvZpvPcYpNjv09gnSI2z+ei5vfB1EKGaxt1QDIp4SSpHka1MzzF+Ne
         XpP8fKHN7lFZeLw6ObJDJ6AAmhRcWRS0A6ipXLQXt0QwaJxZiRGlFa66Fo8IfVIXF5
         FymixdsGColjw==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1liDr1-003o96-Of; Sun, 16 May 2021 12:18:35 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 15/16] docs: virt: kvm: api.rst: replace some characters
Date:   Sun, 16 May 2021 12:18:32 +0200
Message-Id: <19f884773a95649e7b11609d8d3075f30db00aef.1621159997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621159997.git.mchehab+huawei@kernel.org>
References: <cover.1621159997.git.mchehab+huawei@kernel.org>
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
index 22d077562149..295daf6178f8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -850,7 +850,7 @@ in-kernel irqchip (GIC), and for in-kernel irqchip can tell the GIC to
 use PPIs designated for specific cpus.  The irq field is interpreted
 like this::
 
-  bits:  |  31 ... 28  | 27 ... 24 | 23  ... 16 | 15 ... 0 |
+  bits:  |  31 ... 28  | 27 ... 24 | 23  ... 16 | 15 ... 0 |
   field: | vcpu2_index | irq_type  | vcpu_index |  irq_id  |
 
 The irq_type field has the following values:
@@ -2144,10 +2144,10 @@ prior to calling the KVM_RUN ioctl.
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
@@ -2585,10 +2585,10 @@ following id bit patterns::
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
@@ -3107,13 +3107,13 @@ current state.  "addr" is ignored.
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
@@ -3234,8 +3234,8 @@ VCPU matching underlying host.
 Errors:
 
   =====      ==============================================================
-  E2BIG      the reg index list is too big to fit in the array specified by
-             the user (the number required will be written into n).
+  E2BIG      the reg index list is too big to fit in the array specified by
+             the user (the number required will be written into n).
   =====      ==============================================================
 
 ::
@@ -3283,7 +3283,7 @@ specific device.
 ARM/arm64 divides the id field into two parts, a device id and an
 address type id specific to the individual device::
 
-  bits:  | 63        ...       32 | 31    ...    16 | 15    ...    0 |
+  bits:  | 63        ...       32 | 31    ...    16 | 15    ...    0 |
   field: |        0x00000000      |     device id   |  addr type id  |
 
 ARM/arm64 currently only require this when using the in-kernel GIC
-- 
2.31.1

