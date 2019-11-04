Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0275DEF0E8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 00:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730174AbfKDXAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 18:00:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51756 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730133AbfKDXAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 18:00:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572908416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+St/beuhRsF58YDE5+DYdZxQDc75u5Mr+KI9l9PvbEo=;
        b=c1FO6TPxHsQPlteQopWBhd+rdFY3cIgtHi0L9VVcE8/vw3UGrBFzxfbiGMgkJpOZKym/6L
        gevGtP4Kpolhuf/F0Uiw+WKqj2x5t9BETq6SQuCcMSPBEeo7CqBCGf5b8UR58Pvxg534np
        gDXD3of2uPcdzcHS13NQUj1Ef/eHu0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-CGX2VpKtOe6go1JKpAHU7Q-1; Mon, 04 Nov 2019 18:00:12 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C74BA66F;
        Mon,  4 Nov 2019 23:00:11 +0000 (UTC)
Received: from mail (ovpn-121-157.rdu2.redhat.com [10.10.121.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 029CA5D9CD;
        Mon,  4 Nov 2019 23:00:06 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 05/13] KVM: monolithic: add more section prefixes
Date:   Mon,  4 Nov 2019 17:59:53 -0500
Message-Id: <20191104230001.27774-6-aarcange@redhat.com>
In-Reply-To: <20191104230001.27774-1-aarcange@redhat.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: CGX2VpKtOe6go1JKpAHU7Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add more section prefixes because with the monolithic KVM model the
section checker can now do a more accurate static analysis at build
time and this allows to build without
CONFIG_SECTION_MISMATCH_WARN_ONLY=3Dn.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/powerpc/kvm/book3s.c | 2 +-
 arch/x86/kvm/x86.c        | 4 ++--
 include/linux/kvm_host.h  | 8 ++++----
 virt/kvm/arm/arm.c        | 2 +-
 virt/kvm/kvm_main.c       | 6 +++---
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index ec2547cc5ecb..e80e9504722a 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -1067,7 +1067,7 @@ int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned ir=
qchip, unsigned pin)
=20
 #endif /* CONFIG_KVM_XICS */
=20
-static int kvmppc_book3s_init(void)
+static __init int kvmppc_book3s_init(void)
 {
 =09int r;
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb963e6b2e54..5e98fa6b7bf8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9272,7 +9272,7 @@ void kvm_arch_hardware_disable(void)
 =09drop_user_return_notifiers();
 }
=20
-int kvm_arch_hardware_setup(void)
+__init int kvm_arch_hardware_setup(void)
 {
 =09int r;
=20
@@ -9303,7 +9303,7 @@ void kvm_arch_hardware_unsetup(void)
 =09kvm_x86_hardware_unsetup();
 }
=20
-int kvm_arch_check_processor_compat(void)
+__init int kvm_arch_check_processor_compat(void)
 {
 =09return kvm_x86_check_processor_compatibility();
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 719fc3e15ea4..426bc2f485a9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -616,8 +616,8 @@ static inline void kvm_irqfd_exit(void)
 {
 }
 #endif
-int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
-=09=09  struct module *module);
+__init int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
+=09=09    struct module *module);
 void kvm_exit(void);
=20
 void kvm_get_kvm(struct kvm *kvm);
@@ -867,9 +867,9 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu=
);
=20
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
-int kvm_arch_hardware_setup(void);
+__init int kvm_arch_hardware_setup(void);
 void kvm_arch_hardware_unsetup(void);
-int kvm_arch_check_processor_compat(void);
+__init int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 86c6aa1cb58e..65f7f0f6868d 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1726,7 +1726,7 @@ void kvm_arch_exit(void)
 =09kvm_perf_teardown();
 }
=20
-static int arm_init(void)
+static __init int arm_init(void)
 {
 =09int rc =3D kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
 =09return rc;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d6f0696d98ef..1b7fbd138406 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4246,13 +4246,13 @@ static void kvm_sched_out(struct preempt_notifier *=
pn,
 =09kvm_arch_vcpu_put(vcpu);
 }
=20
-static void check_processor_compat(void *rtn)
+static __init void check_processor_compat(void *rtn)
 {
 =09*(int *)rtn =3D kvm_arch_check_processor_compat();
 }
=20
-int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
-=09=09  struct module *module)
+__init int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
+=09=09    struct module *module)
 {
 =09int r;
 =09int cpu;

