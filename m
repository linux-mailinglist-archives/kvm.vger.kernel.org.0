Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29A275ECC
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 08:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfGZGPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 02:15:33 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42909 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfGZGPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 02:15:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id t132so24231270pgb.9;
        Thu, 25 Jul 2019 23:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2eXHJpIRWye4bPwuDirO2Zr+vPpMtK87LAgbJuPvgPM=;
        b=cpes4jrHl6j/M0cf8Bec137LgnO2EY6+o1K0CEzzSHFjg3LzQ68/I5TU45zizvQcQR
         nG2BbuODPbsJkOogD74DbA7LbVjcLqTnGfuk+pMdaQ9EFf28/+4JWgbd7LU222xeJIW4
         t/x5/inPW0qQ/FPmCJAgD2d276yrZScRDI3llv2TCJ4M8NHuWt4eiWg0wSU2Lifr8Bwd
         ZrEgS+UdmB7dNoIwnq01YU5/S07u+UP4FruzW7QCt0RCVu2/qL4RFwKjfuS3/aq98TyF
         A3gtE95/odxbuk7W12YWifHMTa1fJ3BwOob3h2ERVJ3P2X1CfOLvdxa7sfQ3+LfqaKgB
         5vnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2eXHJpIRWye4bPwuDirO2Zr+vPpMtK87LAgbJuPvgPM=;
        b=McLvadzRj2bpRGaf3aFzctJ/3egLq8OngHowMdfLrk+qkAu3hip4Sy3XqwB9QlpByN
         t4ReuL2Sx5fKR3W60ij+NE0JDvkRNgndv/9tEzY9WYDOeu62hRLcBebCibzZqf+5sHsE
         Wn/xe6bKlKenMo5hE4tHqXvAwSpI1yzKeiwA+kWP8x/d4ahHRiLRZ4kOPNY5JPpb2rI/
         T7Aitk7q5KbyImFVlgD1a4rCohxIyzcc9fdtTwOmN2cWuswjZ2S9fNOvMOWrjm6JsV7P
         Vyy6T8WiD4yMig+g9q/TAgf20D8oCAU1lnRk87Rnd6usPaRVM/sFrmLUkanJUfvXJdgu
         WjOA==
X-Gm-Message-State: APjAAAVIZlwePrLWlwvT/VMjh3hcLb9ms60NExRSEjaQShqlS5dBYl11
        SoE14L1NRV1hgfzW7KrqCZa5n0dQcoo=
X-Google-Smtp-Source: APXvYqxsXqPaQ5SDvQbR44We14GfhEW8lxzz6hAu3EFgkpcrQqRlkzr0oNoJTakQIUe5/AfaoWtzRQ==
X-Received: by 2002:a62:1a8e:: with SMTP id a136mr20204870pfa.22.1564121732080;
        Thu, 25 Jul 2019 23:15:32 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id e189sm26690085pgc.15.2019.07.25.23.15.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 25 Jul 2019 23:15:31 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Nadav Amit <namit@vmware.com>
Subject: [PATCH RESEND] KVM: X86: Use IPI shorthands in kvm guest when support
Date:   Fri, 26 Jul 2019 14:15:27 +0800
Message-Id: <1564121727-30020-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

IPI shorthand is supported now by linux apic/x2apic driver, switch to 
IPI shorthand for all excluding self and all including self destination 
shorthand in kvm guest, to avoid splitting the target mask into serveral 
PV IPI hypercalls.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Nadav Amit <namit@vmware.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
Note: rebase against tip tree's x86/apic branch

 arch/x86/kernel/kvm.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b7f34fe..87b73b8 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -34,7 +34,9 @@
 #include <asm/hypervisor.h>
 #include <asm/tlb.h>
 
+static struct apic orig_apic;
 static int kvmapf = 1;
+DECLARE_STATIC_KEY_FALSE(apic_use_ipi_shorthand);
 
 static int __init parse_no_kvmapf(char *arg)
 {
@@ -507,12 +509,18 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 
 static void kvm_send_ipi_allbutself(int vector)
 {
-	kvm_send_ipi_mask_allbutself(cpu_online_mask, vector);
+	if (static_branch_likely(&apic_use_ipi_shorthand))
+		orig_apic.send_IPI_allbutself(vector);
+	else
+		kvm_send_ipi_mask_allbutself(cpu_online_mask, vector);
 }
 
 static void kvm_send_ipi_all(int vector)
 {
-	__send_ipi_mask(cpu_online_mask, vector);
+	if (static_branch_likely(&apic_use_ipi_shorthand))
+		orig_apic.send_IPI_all(vector);
+	else
+		__send_ipi_mask(cpu_online_mask, vector);
 }
 
 /*
@@ -520,6 +528,8 @@ static void kvm_send_ipi_all(int vector)
  */
 static void kvm_setup_pv_ipi(void)
 {
+	orig_apic = *apic;
+
 	apic->send_IPI_mask = kvm_send_ipi_mask;
 	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
 	apic->send_IPI_allbutself = kvm_send_ipi_allbutself;
-- 
2.7.4

