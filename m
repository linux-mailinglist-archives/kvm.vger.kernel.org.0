Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915032D1B16
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgLGUsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:20 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42602 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727229AbgLGUsS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:18 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 1D790305D512;
        Mon,  7 Dec 2020 22:46:16 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id F284E3072784;
        Mon,  7 Dec 2020 22:46:15 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 26/81] KVM: x86: export kvm_vcpu_ioctl_x86_set_xsave()
Date:   Mon,  7 Dec 2020 22:45:27 +0200
Message-Id: <20201207204622.15258-27-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the KVMI_VCPU_SET_XSAVE command.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/x86.c              | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ec0e2a7764ad..65bce8aeede5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1516,6 +1516,8 @@ bool kvm_rdpmc(struct kvm_vcpu *vcpu);
 
 void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 				  struct kvm_xsave *guest_xsave);
+int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
+				 struct kvm_xsave *guest_xsave);
 
 bool kvm_inject_pending_exception(struct kvm_vcpu *vcpu);
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
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
