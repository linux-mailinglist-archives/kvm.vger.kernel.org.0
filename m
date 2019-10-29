Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1591BE9138
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 22:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbfJ2VGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 17:06:18 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:51146 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbfJ2VGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 17:06:18 -0400
Received: by mail-pl1-f202.google.com with SMTP id x8so154262plo.17
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2019 14:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KVJFtVpqqhp4AY3I8pC3DfiDcxLh4ZkmI6tduNedXL0=;
        b=p9TMSKZfgq/t5pQXP4CREpVCRzpU1NAMTSDrRNiqTsrYJWLsxN51PhLVg4RtslW4XF
         J5/PVAj1O25kiMMnHmzCgi0KSAgCaZINTvQOXI96evlcCYSUUblQllvFhP0mkxH7L+Du
         ksD/prGRjqCw81XeYczoCGtd0br9ardXDZl4A0cm4LXzQLHamXfv+M2xtFYAEWKL7zL3
         M/YvrL+ziGTUe3BvO0wo+hcyA40rYca6y1vC9MkL7A8uBzrlX0fdCsVmRBKPvVYuCour
         W2AkGvoJKBl8og7xvHj8o0lBw4nLVOLGnenWKHHWjBoEt2OmNtcicNmQycWHr3x7HYYk
         +/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KVJFtVpqqhp4AY3I8pC3DfiDcxLh4ZkmI6tduNedXL0=;
        b=kTx4wcxTKfx8K4Ieffc23BJ7e6PWRvUnTRQDZeFyNm8Plb5IWPjGEEwXPUkolY75K8
         h7WC5FUzZ4/k/HG40f1o0jPr4NGIv0mJWxb11qKg36Dm5eWKerGKtI4mDfL2Z+XdRaxx
         jILWFCl7jNFtYZEvVC1tNeniR9oDjYa/ec39TPL8KOSq4V0fOcTDI/jDy0g5FKUHcg77
         gwMCLsHGoyWlO1cawB8jEbO3Sk3wRE5Kngo59Lwj4jKu06cP1IFYcES539syhN3pbQLj
         tw+gBE7FUwOBqsFJsBuFnbz1+FW0+RQujz1BqcW0JILYqJAXOY9EWX9uXdjg96PfrRns
         o5lw==
X-Gm-Message-State: APjAAAWWmv/zKAxbDvrV/qu2z/MFBiLG4BJggHSP9opeM9ex3Ok6nbCP
        iOg/EXYfoJ23BCuCUrwtFrcUsa+Tyl53moxaFQWs/k2UHWwA6zO2FW0shw6TJ/AEkl489iVI8fE
        DFsftgwBsgiPeQxH3PSsZdblhiiE8pqUGsHVBQU/QS+NBUozk6LBJo3jYqfZ+IUdSD79N
X-Google-Smtp-Source: APXvYqyhJMGCE9atB/e6U3SiOicShlXOKi4pnyRCqFsi0ALfN7aKrQSf7f06pbjo+Tfz6hhSHSgpIrbgSgIhKmKV
X-Received: by 2002:a63:ec4f:: with SMTP id r15mr29082700pgj.17.1572383177448;
 Tue, 29 Oct 2019 14:06:17 -0700 (PDT)
Date:   Tue, 29 Oct 2019 14:05:54 -0700
In-Reply-To: <20191029210555.138393-1-aaronlewis@google.com>
Message-Id: <20191029210555.138393-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191029210555.138393-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH 3/4] kvm: vmx: Rename function find_msr() to vmx_find_msr_index()
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename function find_msr() to vmx_find_msr_index() to share
implementations between vmx.c and nested.c in an upcoming change.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: I544afb762ceccb72e950bb62ac2e649a8b0cfec9
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 arch/x86/kvm/vmx/vmx.h |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c0160ca9ddba..39c701730297 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -835,7 +835,7 @@ static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 	vm_exit_controls_clearbit(vmx, exit);
 }
 
-static int find_msr(struct vmx_msrs *m, unsigned int msr)
+int vmx_find_msr_index(struct vmx_msrs *m, u32 msr)
 {
 	unsigned int i;
 
@@ -869,7 +869,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 		}
 		break;
 	}
-	i = find_msr(&m->guest, msr);
+	i = vmx_find_msr_index(&m->guest, msr);
 	if (i < 0)
 		goto skip_guest;
 	--m->guest.nr;
@@ -877,7 +877,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
 
 skip_guest:
-	i = find_msr(&m->host, msr);
+	i = vmx_find_msr_index(&m->host, msr);
 	if (i < 0)
 		return;
 
@@ -936,9 +936,9 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
 	}
 
-	i = find_msr(&m->guest, msr);
+	i = vmx_find_msr_index(&m->guest, msr);
 	if (!entry_only)
-		j = find_msr(&m->host, msr);
+		j = vmx_find_msr_index(&m->host, msr);
 
 	if ((i < 0 && m->guest.nr == NR_MSR_ENTRIES) ||
 		(j < 0 &&  m->host.nr == NR_MSR_ENTRIES)) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0c6835bd6945..34b5fef603d8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -334,6 +334,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
+int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
-- 
2.24.0.rc0.303.g954a862665-goog

