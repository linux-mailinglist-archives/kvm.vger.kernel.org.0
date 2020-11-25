Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B88B2C3CA6
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgKYJm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:27 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57212 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728364AbgKYJmG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:06 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id BE4DD305D50B;
        Wed, 25 Nov 2020 11:35:46 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 9F7743072785;
        Wed, 25 Nov 2020 11:35:46 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 25/81] KVM: x86: export kvm_vcpu_ioctl_x86_get_xsave()
Date:   Wed, 25 Nov 2020 11:35:04 +0200
Message-Id: <20201125093600.2766-26-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This function is needed for the KVMI_VCPU_GET_XSAVE command.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c       | 4 ++--
 include/linux/kvm_host.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 741505f405b1..4fadd1ab20ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4497,8 +4497,8 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 	}
 }
 
-static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
-					 struct kvm_xsave *guest_xsave)
+void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
+				  struct kvm_xsave *guest_xsave)
 {
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		memset(guest_xsave, 0, sizeof(struct kvm_xsave));
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c640ea9d7ba..6eec75f77d7e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -921,6 +921,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_set_guest_debug(struct kvm_vcpu *vcpu,
 				  struct kvm_guest_debug *dbg);
+void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
+				  struct kvm_xsave *guest_xsave);
 
 int kvm_arch_init(void *opaque);
 void kvm_arch_exit(void);
