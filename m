Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC0343656D
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhJUPPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhJUPOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 11:14:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B61C061228;
        Thu, 21 Oct 2021 08:12:37 -0700 (PDT)
Date:   Thu, 21 Oct 2021 15:12:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634829155;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0NTROuTrxysii/cbgbkl4mlTs4GZTqB2r9whkq88NTk=;
        b=lkWCeW6Jbgskzpt1mV4TCmMURpx3pYSRJP2pkZlYDicRASvtLp9A6lYHaFSkuM7rds1JFd
        CMtfEXN4a+OZf5pCps2fIHujzNxWfqcdYER00eYPbkd0bAPPXKrItYwiXs+FAfSBgvt76g
        tG1mJsv5fqvgcvHYr9RymXBW7i/QS2H6M2m/czNbTyBJw+adOI2nGAdr8M6ue09krLZ0vO
        pUiVC1FM6l/Z4Tz2F3C7B4QubB5uc53xvpNuVwKKEvwLaha1PkxDzpdeBc6oJkyzadNkN5
        dsHDNy0JTa/Guo7xH+QjC24vfWFz5zZjvAArpvTCvU/j3mre9D64WH38U10XhQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634829155;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0NTROuTrxysii/cbgbkl4mlTs4GZTqB2r9whkq88NTk=;
        b=+XC9cDs4zdmPyxK9aGaRKW6iYOw3g60wam2mE1SatVS+lO8JSFKQwATSb/6+Nm3KM85acv
        h+KIulIevkGwX0AA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/fpu] x86/KVM: Convert to fpstate
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211013145322.451439983@linutronix.de>
References: <20211013145322.451439983@linutronix.de>
MIME-Version: 1.0
Message-ID: <163482915474.25758.16816942540201658748.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following commit has been merged into the x86/fpu branch of tip:

Commit-ID:     1c57572d754fc54e0b8ac0df5350969ce6292d12
Gitweb:        https://git.kernel.org/tip/1c57572d754fc54e0b8ac0df5350969ce6292d12
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 13 Oct 2021 16:55:33 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 20 Oct 2021 22:34:14 +02:00

x86/KVM: Convert to fpstate

Convert KVM code to the new register storage mechanism in preparation for
dynamically sized buffers.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Link: https://lkml.kernel.org/r/20211013145322.451439983@linutronix.de
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 96936a2..0eb1021 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10403,7 +10403,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	vcpu_load(vcpu);
 
-	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
+	fxsave = &vcpu->arch.guest_fpu->fpstate->regs.fxsave;
 	memcpy(fpu->fpr, fxsave->st_space, 128);
 	fpu->fcw = fxsave->cwd;
 	fpu->fsw = fxsave->swd;
@@ -10426,7 +10426,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	vcpu_load(vcpu);
 
-	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
+	fxsave = &vcpu->arch.guest_fpu->fpstate->regs.fxsave;
 
 	memcpy(fxsave->st_space, fpu->fpr, 128);
 	fxsave->cwd = fpu->fcw;
