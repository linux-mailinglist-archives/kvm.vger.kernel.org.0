Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D470C228AE9
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731341AbgGUVSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:18:07 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37852 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731250AbgGUVQC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:02 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 8F6B8305D654;
        Wed, 22 Jul 2020 00:09:23 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 778D5304FA13;
        Wed, 22 Jul 2020 00:09:23 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 31/84] KVM: x86: export kvm_vcpu_ioctl_x86_set_xsave()
Date:   Wed, 22 Jul 2020 00:08:29 +0300
Message-Id: <20200721210922.7646-32-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 4d5be48b5239..b7eb223dc1aa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4224,8 +4224,8 @@ void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 
 #define XSAVE_MXCSR_OFFSET 24
 
-static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
-					struct kvm_xsave *guest_xsave)
+int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
+				 struct kvm_xsave *guest_xsave)
 {
 	u64 xstate_bv =
 		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f138d56450c0..5b6f1338de74 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -885,6 +885,8 @@ int kvm_arch_vcpu_set_guest_debug(struct kvm_vcpu *vcpu,
 				  struct kvm_guest_debug *dbg);
 void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 				  struct kvm_xsave *guest_xsave);
+int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
+				 struct kvm_xsave *guest_xsave);
 
 int kvm_arch_init(void *opaque);
 void kvm_arch_exit(void);
