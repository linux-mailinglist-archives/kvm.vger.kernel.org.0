Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED7FF9B84
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 22:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfKLVKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 16:10:44 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37006 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbfKLVKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 16:10:40 -0500
Received: by mail-wm1-f68.google.com with SMTP id b17so4502182wmj.2;
        Tue, 12 Nov 2019 13:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=ggJ1wueVMuwowaHeTZ0GC3WO2tlvDZKJl8chKJQFPkc=;
        b=PsrKIWwEywODV7XLDEwnDWYX0V4T9w2Mftx/GcjVlZAbot4zg+JZ5aENMi4bHATIWc
         K+4tnaZQ8IzUR5NJPcTKw8a7KyfsUckNE3cch77SeAEKeeUYN8lQwVoVNB2oDgtr88Ns
         kj/Oql8dFfClk1nJfV48ylRaj0VxCDPMhU1DUCCSyPW/8E8IHfgc7sN04kwkoGh412GV
         r4iJ6bT3p4SEXlnOPqlWigVDQifpMc0FZazQ10KGqcOcz1FbowtAZHtQzK93GsHE7/Ew
         3I2vF3dEDVDDb1VR7d1Dql87uwiAM7FMwZxJ1tbl5W6NeDBhmZaF6WkRpUp9x64SDujm
         kxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=ggJ1wueVMuwowaHeTZ0GC3WO2tlvDZKJl8chKJQFPkc=;
        b=aT++p+N1IpURCVQoeHI9EvM8J78MAfOPyzOZc0TZ0cCpN78T+1A8fSftlpm9cgSjyA
         4a41P6FqBgXVd+J2Sl2LhztbH8UQVcFpDWgEZhYVkub9pr5D+O2t3X7sqYMYWoTVuQnJ
         pufrds2pGaj4gPRFjI05TVUz2OZXWmeR8ssy62cqnXgYiEoqT/R/X0zglmHhySd8lmBL
         LkwnEw2KZ/TX6jbZM+hmuvvjFgxukb68GDGOgqj/oL7MR5xMusadELbtQgoNek9/X34Q
         RVjoWRfjHTzhg2Y+J8shoCwhjPOninapvP8beoPRvXg5CJgaYOIj2qVr+5ca4UQoEr94
         mCqw==
X-Gm-Message-State: APjAAAW/n6/YlLi1E86rWjksYnCMA5KW0gCozZp6sRhA/Im2kvbAZUit
        pBPgTitXSCsUhUW+MPHaMY7Bf7eL
X-Google-Smtp-Source: APXvYqy2aLhqqT/TL0rcyK1Ryn/w/sr+i15tLkfOG5tJp6IP8/oSH50xCw/il6DnUuQ16rUQ5Urj8Q==
X-Received: by 2002:a1c:9601:: with SMTP id y1mr5613615wmd.157.1573593037942;
        Tue, 12 Nov 2019 13:10:37 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id p25sm4132624wma.20.2019.11.12.13.10.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:10:37 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM patches for Linux 5.4-rc8
Date:   Tue, 12 Nov 2019 22:10:36 +0100
Message-Id: <1573593036-23271-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 31f4f5b495a62c9a8b15b1c3581acd5efeb9af8c:

  Linux 5.4-rc7 (2019-11-10 16:17:15 -0800)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to a78986aae9b2988f8493f9f65a587ee433e83bc3:

  KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved (2019-11-12 10:17:42 +0100)

----------------------------------------------------------------
Bugfixes: unwinding of KVM_CREATE_VM failure,
VT-d posted interrupts, DAX/ZONE_DEVICE,
module unload/reload.

----------------------------------------------------------------

I delayed sending this until today, because there is a conflict between
today's processor vulnerability mitigations and commit 8a44119a98be from
this pull request ("KVM: Fix NULL-ptr deref after kvm_create_vm fails"),
and I didn't want to mess up your processing of Thomas's pull request.
It's not a particularly hard conflict, but I'm including anyway a
resolution at the end of this email.

Paolo

Chenyi Qiang (1):
      KVM: X86: Fix initialization of MSR lists

Joao Martins (3):
      KVM: VMX: Consider PID.PIR to determine if vCPU has pending interrupts
      KVM: VMX: Do not change PID.NDST when loading a blocked vCPU
      KVM: VMX: Introduce pi_is_pir_empty() helper

Liran Alon (1):
      KVM: VMX: Fix comment to specify PID.ON instead of PIR.ON

Paolo Bonzini (2):
      KVM: Fix NULL-ptr deref after kvm_create_vm fails
      KVM: fix placement of refcount initialization

Sean Christopherson (1):
      KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved

 arch/x86/kvm/mmu.c       |  8 +++----
 arch/x86/kvm/vmx/vmx.c   | 23 +++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h   | 11 ++++++++++
 arch/x86/kvm/x86.c       | 56 ++++++++++++++++++++++--------------------------
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 48 +++++++++++++++++++++++++++++------------
 6 files changed, 96 insertions(+), 51 deletions(-)



diff --cc virt/kvm/kvm_main.c
index 4aab3547a165,0dac149ead16..000000000000
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@@ -715,15 -713,6 +735,11 @@@
  	return kvm;
  
  out_err:
 +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 +	if (kvm->mmu_notifier.ops)
 +		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
 +#endif
 +out_err_no_mmu_notifier:
- 	cleanup_srcu_struct(&kvm->irq_srcu);
- out_err_no_irq_srcu:
- 	cleanup_srcu_struct(&kvm->srcu);
- out_err_no_srcu:
  	hardware_disable_all();
  out_err_no_disable:
  	kvm_arch_destroy_vm(kvm);

