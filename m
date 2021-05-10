Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6978B378270
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 12:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhEJKfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 06:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232394AbhEJKea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 06:34:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 937936191F;
        Mon, 10 May 2021 10:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620642492;
        bh=FKJ2BSwW7gr1uZrtyjei+5LqG3f0DEatUOETKXaA9GU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VB4LDqHWa0jICnzjz6LZ8EPfuGQiGos/TUnZer+Q7Cns5TyW0eko830dk0vao5Gxh
         ur9RgxRQNl7i8qBqhdxZI528ZDztPyzP4BLYGVyv3zjFBv3UDFfGpg/nRkyRRG+Ztx
         OtAbXlomPxG8gQvr4sSupinHn/8qM+yN26+Ez/0pr23gaVlsgZV8+SF8+mUzmyFDbS
         O3UC5XfmjGjFn+2RINooSZluHbfAn4cNULRUlmudessoCnNQBi/ll2MdYScMKjitOb
         /+6YqywSgdDQEW5rrwuzBxhD5Zqvsbsr4+PugQEq9VL5dS6Iwu162pqZzZz39wPsZe
         QrxRPJLbpjxPg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lg38z-000UYW-NH; Mon, 10 May 2021 12:28:09 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 52/53] docs: virt: kvm: avoid using UTF-8 chars
Date:   Mon, 10 May 2021 12:27:04 +0200
Message-Id: <5dae95d7e1cc267c3de9499e3962b97dd998049a.1620641727.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620641727.git.mchehab+huawei@kernel.org>
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While UTF-8 characters can be used at the Linux documentation,
the best is to use them only when ASCII doesn't offer a good replacement.
So, replace the occurences of the following UTF-8 characters:

	- U+00a0 (' '): NO-BREAK SPACE
	- U+2013 ('–'): EN DASH
	- U+2014 ('—'): EM DASH

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/api.rst                | 28 +++++++++----------
 .../virt/kvm/running-nested-guests.rst        | 12 ++++----
 2 files changed, 20 insertions(+), 20 deletions(-)

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
diff --git a/Documentation/virt/kvm/running-nested-guests.rst b/Documentation/virt/kvm/running-nested-guests.rst
index bd70c69468ae..e9dff3fea055 100644
--- a/Documentation/virt/kvm/running-nested-guests.rst
+++ b/Documentation/virt/kvm/running-nested-guests.rst
@@ -26,12 +26,12 @@ this document is built on this example)::
 
 Terminology:
 
-- L0 – level-0; the bare metal host, running KVM
+- L0 - level-0; the bare metal host, running KVM
 
-- L1 – level-1 guest; a VM running on L0; also called the "guest
+- L1 - level-1 guest; a VM running on L0; also called the "guest
   hypervisor", as it itself is capable of running KVM.
 
-- L2 – level-2 guest; a VM running on L1, this is the "nested guest"
+- L2 - level-2 guest; a VM running on L1, this is the "nested guest"
 
 .. note:: The above diagram is modelled after the x86 architecture;
           s390x, ppc64 and other architectures are likely to have
@@ -39,7 +39,7 @@ Terminology:
 
           For example, s390x always has an LPAR (LogicalPARtition)
           hypervisor running on bare metal, adding another layer and
-          resulting in at least four levels in a nested setup — L0 (bare
+          resulting in at least four levels in a nested setup - L0 (bare
           metal, running the LPAR hypervisor), L1 (host hypervisor), L2
           (guest hypervisor), L3 (nested guest).
 
@@ -167,11 +167,11 @@ Enabling "nested" (s390x)
     $ modprobe kvm nested=1
 
 .. note:: On s390x, the kernel parameter ``hpage`` is mutually exclusive
-          with the ``nested`` paramter — i.e. to be able to enable
+          with the ``nested`` paramter - i.e. to be able to enable
           ``nested``, the ``hpage`` parameter *must* be disabled.
 
 2. The guest hypervisor (L1) must be provided with the ``sie`` CPU
-   feature — with QEMU, this can be done by using "host passthrough"
+   feature - with QEMU, this can be done by using "host passthrough"
    (via the command-line ``-cpu host``).
 
 3. Now the KVM module can be loaded in the L1 (guest hypervisor)::
-- 
2.30.2

