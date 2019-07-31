Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F05907CC5C
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 20:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730616AbfGaS4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 14:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730373AbfGaS4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 14:56:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1D2F206A2;
        Wed, 31 Jul 2019 18:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564599359;
        bh=PDZTaahLi5kNA//H1J256ixuWFOspp8vVvyZEl42Tck=;
        h=Date:From:To:Cc:Subject:From;
        b=k9Nkw8SsGExyRYJS3Oi123MRSYnyHm8voniX5T4u0GMTgAaATttDL8KApYyK/3/Fx
         Y7vatCjQ6dAL3zsolVdeFJj4mbxuSDI4yEd2p1pSfKYJuerjlqdYsJz2R9s7DqmVf9
         6mqT5BmDt4vIl0Q2rSO+Rp2QzDzGV+Q7oYP2XIX4=
Date:   Wed, 31 Jul 2019 20:55:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krm <rkrcmar@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: remove kvm_arch_has_vcpu_debugfs()
Message-ID: <20190731185556.GA703@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need for this function as all arches have to implement
kvm_arch_create_vcpu_debugfs() no matter what, so just remove this call
as it is pointless.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krm" <rkrcmar@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <x86@kernel.org>
Cc: <kvm@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: new patch in the series

 arch/mips/kvm/mips.c       | 5 -----
 arch/powerpc/kvm/powerpc.c | 5 -----
 arch/s390/kvm/kvm-s390.c   | 5 -----
 arch/x86/kvm/debugfs.c     | 5 -----
 include/linux/kvm_host.h   | 1 -
 virt/kvm/arm/arm.c         | 5 -----
 virt/kvm/kvm_main.c        | 3 ---
 7 files changed, 29 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 2cfe839f0b3a..948ef36ca87c 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -150,11 +150,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return 0;
 }
 
-bool kvm_arch_has_vcpu_debugfs(void)
-{
-	return false;
-}
-
 int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
 	return 0;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 0dba7eb24f92..78d166672492 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -452,11 +452,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return -EINVAL;
 }
 
-bool kvm_arch_has_vcpu_debugfs(void)
-{
-	return false;
-}
-
 int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
 	return 0;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3f520cd837fb..4dd49bda8d25 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2516,11 +2516,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return rc;
 }
 
-bool kvm_arch_has_vcpu_debugfs(void)
-{
-	return false;
-}
-
 int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
 	return 0;
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 329361b69d5e..9bd93e0d5f63 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -8,11 +8,6 @@
 #include <linux/debugfs.h>
 #include "lapic.h"
 
-bool kvm_arch_has_vcpu_debugfs(void)
-{
-	return true;
-}
-
 static int vcpu_get_timer_advance_ns(void *data, u64 *val)
 {
 	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5c5b5867024c..52596a27ab27 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -861,7 +861,6 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
 
-bool kvm_arch_has_vcpu_debugfs(void);
 int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu);
 
 int kvm_arch_hardware_enable(void);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index f645c0fbf7ec..cc85259a243d 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -144,11 +144,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-bool kvm_arch_has_vcpu_debugfs(void)
-{
-	return false;
-}
-
 int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
 	return 0;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 887f3b0c2b60..ac0a2f6a50a4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2596,9 +2596,6 @@ static int kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 	char dir_name[ITOA_MAX_LEN * 2];
 	int ret;
 
-	if (!kvm_arch_has_vcpu_debugfs())
-		return 0;
-
 	if (!debugfs_initialized())
 		return 0;
 
-- 
2.22.0

