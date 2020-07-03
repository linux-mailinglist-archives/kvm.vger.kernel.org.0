Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E202140D2
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 23:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGCV3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 17:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgGCV3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 17:29:19 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A1BC08C5DD;
        Fri,  3 Jul 2020 14:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=LEnyADWq/NophE7qSmBDDcjekGbN+O2yg5twkO086Ws=; b=Ohk6zx8UKR9hjpJwDA+AHyUcse
        0veg3vAUlr1Lou7KeF2FRi9/P+fF07lrd3F5dC+03oh6eoMKw+DgxtHKKEv7zdu4jos2gkz0zFGuH
        arNR1YP13zwB67hzPHIMGPyzBplFSesAC0NZx+ld0CH/eebc5S/np4OUBheEWSJpw9k9UonFjAxul
        Rz6gdNzE9j0880c3uyKVusR+9/juD6K5m7g6YAPDkNqGWjaJT8fpLJVdxeTc2pnKJp/HBaUbyLIKW
        5IWFcbSxkopPbeJC+tIC94OA+Wc4ej4Hoi9OgDJGQRqryTlnWiO64a0+F8s48MExSoUtplv9yC4qz
        5DVaz5jg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jrTFE-0006KB-O3; Fri, 03 Jul 2020 21:29:17 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 1/2] Documentation: virt: kvm/api: drop doubled words
Date:   Fri,  3 Jul 2020 14:29:06 -0700
Message-Id: <20200703212906.30655-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703212906.30655-1-rdunlap@infradead.org>
References: <20200703212906.30655-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop multiple doubled words.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
 Documentation/virt/kvm/api.rst |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-next-20200701.orig/Documentation/virt/kvm/api.rst
+++ linux-next-20200701/Documentation/virt/kvm/api.rst
@@ -65,7 +65,7 @@ not be freed until both the parent (orig
 put their references to the VM's file descriptor.
 
 Because a VM's resources are not freed until the last reference to its
-file descriptor is released, creating additional references to a VM via
+file descriptor is released, creating additional references to a VM
 via fork(), dup(), etc... without careful consideration is strongly
 discouraged and may have unwanted side effects, e.g. memory allocated
 by and on behalf of the VM's process may not be freed/unaccounted when
@@ -536,7 +536,7 @@ X86:
 	========= ===================================
 	  0       on success,
 	 -EEXIST  if an interrupt is already enqueued
-	 -EINVAL  the the irq number is invalid
+	 -EINVAL  the irq number is invalid
 	 -ENXIO   if the PIC is in the kernel
 	 -EFAULT  if the pointer is invalid
 	========= ===================================
@@ -3167,7 +3167,7 @@ not mandatory.
 
 The information returned by this ioctl can be used to prepare an instance
 of struct kvm_vcpu_init for KVM_ARM_VCPU_INIT ioctl which will result in
-in VCPU matching underlying host.
+VCPU matching underlying host.
 
 
 4.84 KVM_GET_REG_LIST
@@ -5855,7 +5855,7 @@ features of the KVM implementation.
 :Architectures: ppc
 
 This capability, if KVM_CHECK_EXTENSION indicates that it is
-available, means that that the kernel has an implementation of the
+available, means that the kernel has an implementation of the
 H_RANDOM hypercall backed by a hardware random-number generator.
 If present, the kernel H_RANDOM handler can be enabled for guest use
 with the KVM_CAP_PPC_ENABLE_HCALL capability.
@@ -5866,7 +5866,7 @@ with the KVM_CAP_PPC_ENABLE_HCALL capabi
 :Architectures: x86
 
 This capability, if KVM_CHECK_EXTENSION indicates that it is
-available, means that that the kernel has an implementation of the
+available, means that the kernel has an implementation of the
 Hyper-V Synthetic interrupt controller(SynIC). Hyper-V SynIC is
 used to support Windows Hyper-V based guest paravirt drivers(VMBus).
 
@@ -5881,7 +5881,7 @@ by the CPU, as it's incompatible with Sy
 :Architectures: ppc
 
 This capability, if KVM_CHECK_EXTENSION indicates that it is
-available, means that that the kernel can support guests using the
+available, means that the kernel can support guests using the
 radix MMU defined in Power ISA V3.00 (as implemented in the POWER9
 processor).
 
@@ -5891,7 +5891,7 @@ processor).
 :Architectures: ppc
 
 This capability, if KVM_CHECK_EXTENSION indicates that it is
-available, means that that the kernel can support guests using the
+available, means that the kernel can support guests using the
 hashed page table MMU defined in Power ISA V3.00 (as implemented in
 the POWER9 processor), including in-memory segment tables.
 
@@ -5996,7 +5996,7 @@ run->kvm_valid_regs or run->kvm_dirty_re
 
 If KVM_CAP_ARM_USER_IRQ is supported, the KVM_CHECK_EXTENSION ioctl returns a
 number larger than 0 indicating the version of this capability is implemented
-and thereby which bits in in run->s.regs.device_irq_level can signal values.
+and thereby which bits in run->s.regs.device_irq_level can signal values.
 
 Currently the following bits are defined for the device_irq_level bitmap::
 
