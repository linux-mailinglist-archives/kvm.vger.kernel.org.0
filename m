Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D542C3C8F
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgKYJmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:07 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57136 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728542AbgKYJmF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:05 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id DBC36305D50C;
        Wed, 25 Nov 2020 11:35:46 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C102D3072784;
        Wed, 25 Nov 2020 11:35:46 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 26/81] KVM: x86: export kvm_vcpu_ioctl_x86_set_xsave()
Date:   Wed, 25 Nov 2020 11:35:05 +0200
Message-Id: <20201125093600.2766-27-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the KVMI_VCPU_SET_XSAVE command.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c       | 4 ++--
 include/linux/kvm_host.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4fadd1ab20ae..f48603c8e44d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4514,8 +4514,8 @@ void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 
 #define XSAVE_MXCSR_OFFSET 24
 
-static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
-					struct kvm_xsave *guest_xsave)
+int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
+				 struct kvm_xsave *guest_xsave)
 {
 	u64 xstate_bv =
 		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6eec75f77d7e..db04dab23013 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -923,6 +923,8 @@ int kvm_arch_vcpu_set_guest_debug(struct kvm_vcpu *vcpu,
 				  struct kvm_guest_debug *dbg);
 void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 				  struct kvm_xsave *guest_xsave);
+int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
+				 struct kvm_xsave *guest_xsave);
 
 int kvm_arch_init(void *opaque);
 void kvm_arch_exit(void);
