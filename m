Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7CA36C148
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 10:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhD0Izc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 04:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhD0Izb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 04:55:31 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76ACDC061574;
        Tue, 27 Apr 2021 01:54:47 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d124so40868532pfa.13;
        Tue, 27 Apr 2021 01:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lc0JibmTao8AKGkT7JZ2FXwTEuPr+frMt+B/PDjSSE8=;
        b=TGZBCwRXV1LRTPbiFQtrGRyVQOEM5H1azyCqdF1HLNTVlFMeWhJfoVtG1Udl49AfyP
         nr2t9oG+5umSt8DJ8sDEr5KoTd8bg7bRhuq1nY996z4vAKfu++91i3THyDNuS+/7y3k9
         cDGVXUoA3yJCQ7RNfYP3MLO4NfPunNCXmMIc48+rbLHg8L1ZDe9+Wy0WcXJUZRGNB7jI
         Hz3OkGNJN+xbgWER8lNbGjJeUajL7ClQmnm6UbIi97dq3vkwKmCpb5cptv9AGk4A5LsL
         EtClH1wU0pGdt+JII2RDZWPObzl64K640Ty7JaAViFS5mKKvg7CpNK6vI7pFVmYNfLeI
         i8Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lc0JibmTao8AKGkT7JZ2FXwTEuPr+frMt+B/PDjSSE8=;
        b=IoEd49kppv9OBe13LrvfxXkUQPv7enDiaSMUoHGhCTeW/JF4+jKqZAZ+ooq0xlKWC0
         7eInK2ViW4f27eGj4wb3FAr4vovYquGJ626BGBF++flUTNRFW9cUGle+aaJUxuzWL6zu
         Igrg2JNSc5ScgBR31UKH8uEaYFNe0wYp+2uvpAWi+6ycrV9bj/0ZxPQwwpHJ/TsIyzn3
         4CoiZdplJfyEedLUDJW9pDiBg53waMiy72fVcp9lbd43LVM5igtV3G6O/cZu3NVvw1xg
         RrZLzYFTCLLIogb0RxgVZcnZTuAhhwmE/t/RMWLDRoqQ5PEzd7OuCvIiYFiqh+A1Pfc/
         BEUQ==
X-Gm-Message-State: AOAM533tw5+gnDNF4hlVXlZPKDCzyjzOcNUtbFEvCYmGFRDwg+b86rN+
        SwCBaXmliDydUGtgtqd4mJo7PfT+9Qs=
X-Google-Smtp-Source: ABdhPJzv95F1Jql0YBu5i5K2nb+vSP8m8Kb2RegG8xCXbXp5Ni8f6c6jvmizCY1EbEsl8g1lT2MiVg==
X-Received: by 2002:a63:6c83:: with SMTP id h125mr20770557pgc.50.1619513686644;
        Tue, 27 Apr 2021 01:54:46 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id h19sm13021261pgm.40.2021.04.27.01.54.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Apr 2021 01:54:46 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/4] x86: Don't invoke asm_exc_nmi() on the kernel stack
Date:   Tue, 27 Apr 2021 07:09:45 +0800
Message-Id: <20210426230949.3561-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

In VMX, the NMI handler needs to be invoked after NMI VM-Exit.

Before the commit 1a5488ef0dcf6 ("KVM: VMX: Invoke NMI handler via
indirect call instead of INTn"), the work is done by INTn ("int $2").

But INTn microcode is relatively expensive, so the commit reworked
NMI VM-Exit handling to invoke the kernel handler by function call.
And INTn doesn't set the NMI blocked flag required by the linux kernel
NMI entry.  So moving away from INTn are very reasonable.

Yet some details were missed.  After the said commit applied, the NMI
entry pointer is fetched from the IDT table and called from the kernel
stack.  But the NMI entry pointer installed on the IDT table is
asm_exc_nmi() which expects to be invoked on the IST stack by the ISA.
And it relies on the "NMI executing" variable on the IST stack to work
correctly.  When it is unexpectedly called from the kernel stack, the
RSP-located "NMI executing" variable is also on the kernel stack and
is "uninitialized" and can cause the NMI entry to run in the wrong way.

During fixing the problem for KVM, I found that there might be the same
problem for early booting stage where the IST is not set up. asm_exc_nmi()
is not allowed to be used in this stage for the same reason about
the RSP-located "NMI executing" variable.

For both cases, we should use asm_noist_exc_nmi() which is introduced
in the patch 1 via renaming from an existing asm_xenpv_exc_nmi() and
which is safe on the kernel stack.

https://lore.kernel.org/lkml/20200915191505.10355-3-sean.j.christopherson@intel.com/

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: kvm@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>

Lai Jiangshan (4):
  x86/xen/entry: Rename xenpv_exc_nmi to noist_exc_nmi
  x86/entry: Use asm_noist_exc_nmi() for NMI in early booting stage
  KVM/VMX: Invoke NMI non-IST entry instead of IST entry
  KVM/VMX: fold handle_interrupt_nmi_irqoff() into its solo caller

 arch/x86/include/asm/idtentry.h |  4 +---
 arch/x86/kernel/idt.c           |  8 +++++++-
 arch/x86/kernel/nmi.c           | 12 ++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 27 ++++++++++++++-------------
 arch/x86/xen/enlighten_pv.c     |  9 +++------
 arch/x86/xen/xen-asm.S          |  2 +-
 6 files changed, 38 insertions(+), 24 deletions(-)

-- 
2.19.1.6.gb485710b

