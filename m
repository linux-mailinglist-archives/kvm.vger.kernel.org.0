Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6299C3FCBAE
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 18:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240319AbhHaQng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 12:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240584AbhHaQn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 12:43:26 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4269AC061796
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 09:42:31 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h186-20020a3785c3000000b00425f37f792aso2089719qkd.22
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 09:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=R0rwLatZLldNW7q/mE9bVILdLCL4f7JwM3XDs6++eBg=;
        b=nQnHpVWc4lsinOZ661uLOi6p1BeHteUoJ+9fiw5/ubivFiMsw2t+gBCT/pNW1CBHok
         1HsNN1qO4JDOjoLmUd2MB8Fr96X1mERIBr/jbqhXYX/rScgjAtOCpiZZvYkgAC8IqqHf
         +P2B5b48tihUX6yY2B6g4tLGA6egUS6wyFFDIrKwwS/BBoag0lRyoLoW9KHWe7dfG08u
         Ze6qUsopq4pFNKbzTPswfKmAXCmInPk+qT2xuIUKsfmFRxONGYZgMAqi9z6Jxao/5/uo
         eglFrY7RrTyyExOXMMigTKAG/tN5rov8G3YqCY1MhwsDW16ncFXrPmnBiuaxC0rCWlfD
         8TgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=R0rwLatZLldNW7q/mE9bVILdLCL4f7JwM3XDs6++eBg=;
        b=iZcPvjKIB2JATerbM/xJnSoM1YxGZWfRrsgfVmQKlbNATbp08wpJoWwQtT6tO6ifDE
         hUqI3shra6tuTd8C9q1M2KrR7AcDb4m21CEGEotfMDNkGBsqUPyS3OgPSfMaWkNTS2d/
         m7vVZmLvYxOdC49GgHXyKhcRdpOLHArKnwiCqKD0CJvSQJkQd+PSD++e7Tim8F2ut960
         qSdzpYbvEnJwKKKfsrf7YWr8rGyRbtrhoM//1hSgINjtk8wjXEHMNM6l/Fq2V/y9xcyJ
         AHkpw8uDo9oxe7hTFSQintleXuY9FhVa8ZzpS1DbUFkZuEJ/Qa3AOKXko8I0+5obBeJf
         vykg==
X-Gm-Message-State: AOAM530au9sCIu5Tq2PkXudFybuiS7jHPNo5hTX2bobtrK1h0fiOrtOF
        Ucj0IBWCX2WAMUDlM22ZKhhYPZcJ3Ig=
X-Google-Smtp-Source: ABdhPJzgPYcbpT5y/YADtEpvA4HETDnCDrqlmu24L8dMiW7GyycOoAfxD5ICQrhkE7tR1SFcY+pGecIuXe0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:ddbd:588d:571:702a])
 (user=seanjc job=sendgmr) by 2002:a05:6214:c3:: with SMTP id
 f3mr29784262qvs.1.1630428150469; Tue, 31 Aug 2021 09:42:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 31 Aug 2021 09:42:22 -0700
In-Reply-To: <20210831164224.1119728-1-seanjc@google.com>
Message-Id: <20210831164224.1119728-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210831164224.1119728-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 1/3] Revert "KVM: x86: mmu: Add guest physical address check
 in translate_gpa()"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert a misguided illegal GPA check when "translating" a non-nested GPA.
The check is woefully incomplete as it does not fill in @exception as
expected by all callers, which leads to KVM attempting to inject a bogus
exception, potentially exposing kernel stack information in the process.

 WARNING: CPU: 0 PID: 8469 at arch/x86/kvm/x86.c:525 exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
 CPU: 1 PID: 8469 Comm: syz-executor531 Not tainted 5.14.0-rc7-syzkaller #0
 RIP: 0010:exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
 Call Trace:
  x86_emulate_instruction+0xef6/0x1460 arch/x86/kvm/x86.c:7853
  kvm_mmu_page_fault+0x2f0/0x1810 arch/x86/kvm/mmu/mmu.c:5199
  handle_ept_misconfig+0xdf/0x3e0 arch/x86/kvm/vmx/vmx.c:5336
  __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6021 [inline]
  vmx_handle_exit+0x336/0x1800 arch/x86/kvm/vmx/vmx.c:6038
  vcpu_enter_guest+0x2a1c/0x4430 arch/x86/kvm/x86.c:9712
  vcpu_run arch/x86/kvm/x86.c:9779 [inline]
  kvm_arch_vcpu_ioctl_run+0x47d/0x1b20 arch/x86/kvm/x86.c:10010
  kvm_vcpu_ioctl+0x49e/0xe50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3652

The bug has escaped notice because practically speaking the GPA check is
useless.  The GPA check in question only comes into play when KVM is
walking guest page tables (or "translating" CR3), and KVM already handles
illegal GPA checks by setting reserved bits in rsvd_bits_mask for each
PxE, or in the case of CR3 for loading PTDPTRs, manually checks for an
illegal CR3.  This particular failure doesn't hit the existing reserved
bits checks because syzbot sets guest.MAXPHYADDR=1, and IA32 architecture
simply doesn't allow for such an absurd MAXPHADDR, e.g. 32-bit paging
doesn't define any reserved PA bits checks, which KVM emulates by only
incorporating the reserved PA bits into the "high" bits, i.e. bits 63:32.

Simply remove the bogus check.  There is zero meaningful value and no
architectural justification for supporting guest.MAXPHYADDR < 32, and
properly filling the exception would introduce non-trivial complexity.

This reverts commit ec7771ab471ba6a945350353617e2e3385d0e013.

Fixes: ec7771ab471b ("KVM: x86: mmu: Add guest physical address check in translate_gpa()")
Cc: stable@vger.kernel.org
Reported-by: syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4853c033e6ce..4b7908187d05 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -334,12 +334,6 @@ static bool check_mmio_spte(struct kvm_vcpu *vcpu, u64 spte)
 static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
                                   struct x86_exception *exception)
 {
-	/* Check if guest physical address doesn't exceed guest maximum */
-	if (kvm_vcpu_is_illegal_gpa(vcpu, gpa)) {
-		exception->error_code |= PFERR_RSVD_MASK;
-		return UNMAPPED_GVA;
-	}
-
         return gpa;
 }
 
-- 
2.33.0.259.gc128427fd7-goog

