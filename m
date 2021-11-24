Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AF145C414
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351284AbhKXNpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345928AbhKXNmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:42:16 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909E2C0698C7;
        Wed, 24 Nov 2021 04:21:01 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z6so1696328plk.6;
        Wed, 24 Nov 2021 04:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xUvUOJeaDFWG0kCntPaGnPejZW29ujn3LDMRhDQ7kP8=;
        b=gKaMj2W9QFCwd0YsFcprPM9iGY5KGI1sDYTS8S7oo3W7YQ+4rhwrKoUWZ3z25i2SWs
         9qppVN+O35uRn+PX/sFeoOgMwxRJUFCPAP/vYnOxodRkzjDKLcw3sFt7Jd2jBOptsEoJ
         rMJY9ITVsAR8BaufPVflDgtb8GyjKRPmKaL1tsMNFNBhFWZr4OJH44eAGrN20/xaocb0
         HAihhb8fxKr63n3tqGXlWtcCY9mbCJLagDY6RE1HM4oUq2hD3HK1bg9FyDpskU/zqG0T
         l+0FeAf0w08QLmltOGJXbGxuSgrUKe9Ek9S11hHYpCgviKp7DaqAVp8i1hAxqDbKlWVM
         1u/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xUvUOJeaDFWG0kCntPaGnPejZW29ujn3LDMRhDQ7kP8=;
        b=o5vwAFa7SY3EPSTFzvztAAHU40UlxBLsmlQeO9UF4vOMoU+uoTi0SdQtDXiBYy4wX1
         2UUBdrqPPFjpbyU6whitrRKyi/0yYBXU2OoyXmdqPs+lQa9iTq/dqIXcVuJpwSvXoIVb
         aAlTIQ8Tt6Y/5WyYTEgrx7AV8R8K/a+fEaFCYWQuo6u/PoA8v0A8uhYA9kSJk3ujV26D
         MwTldcaiZ0cQgCWieNU8p5Tut7KicGTCS+4Ray8+XDWwkZROpXtshLsl9N3tahwW4QI1
         /9k5HSt4ttX7Fgnaqg3xZLlW1UXISe4u0tnPNUlIVZ7ftA0s55QAotZHXzDGJNyf3vhY
         le0w==
X-Gm-Message-State: AOAM532TXthcEyuWgRUV6d1KSTyVX9nZj7QXR5EvLYXYI6rtfX9em28b
        8NwrFV3BsN08N4ssdyciMYqoE9q0NPI=
X-Google-Smtp-Source: ABdhPJxSvkao1rbgzHDAqBrYxWCGtUgMxc0rOvfp/8357ycGugGC9yTYDMi2FlOoz+QqSajiC43PuA==
X-Received: by 2002:a17:903:31d1:b0:141:f14b:6ebd with SMTP id v17-20020a17090331d100b00141f14b6ebdmr17569423ple.75.1637756460889;
        Wed, 24 Nov 2021 04:21:00 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id e14sm18448429pfv.18.2021.11.24.04.21.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:21:00 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 00/12] KVM: X86: misc fixes and cleanup
Date:   Wed, 24 Nov 2021 20:20:42 +0800
Message-Id: <20211124122055.64424-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

This pacheset has misc fixes and cleanups with loose dependence to each
other.  It includes a prevous patch that inverts and renames
gpte_is_8_bytes.

Ohter patches focus on the usage of vcpu->arch.walk_mmu and
vcpu->arch.mmu, root_level, lpage_level.

Patch 1,4,5,6,7 fixes something, but I don't think path4,5,6,7 are worth
in stable tree.

Lai Jiangshan (12):
  KVM: X86: Fix when shadow_root_level=5 && guest root_level<4
  KVM: X86: Add parameter struct kvm_mmu *mmu into mmu->gva_to_gpa()
  KVM: X86: Remove mmu->translate_gpa
  KVM: X86: Use vcpu->arch.walk_mmu for kvm_mmu_invlpg()
  KVM: X86: Change the type of a parameter of kvm_mmu_invalidate_gva()
    and mmu->invlpg() to gpa_t
  KVM: X86: Add huge_page_level to __reset_rsvds_bits_mask_ept()
  KVM: X86: Add parameter huge_page_level to kvm_init_shadow_ept_mmu()
  KVM: VMX: Use ept_caps_to_lpage_level() in hardware_setup()
  KVM: X86: Rename gpte_is_8_bytes to has_4_byte_gpte and invert the
    direction
  KVM: X86: Remove mmu parameter from load_pdptrs()
  KVM: X86: Check root_level only in fast_pgd_switch()
  KVM: X86: Walk shadow page starting with shadow_root_level

 Documentation/virt/kvm/mmu.rst  |   8 +--
 arch/x86/include/asm/kvm_host.h |  23 ++++----
 arch/x86/kvm/mmu.h              |  16 ++++-
 arch/x86/kvm/mmu/mmu.c          | 100 +++++++++++++++-----------------
 arch/x86/kvm/mmu/mmu_audit.c    |   5 +-
 arch/x86/kvm/mmu/mmutrace.h     |   2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  55 ++++--------------
 arch/x86/kvm/mmu/tdp_mmu.c      |   2 +-
 arch/x86/kvm/svm/nested.c       |   4 +-
 arch/x86/kvm/svm/svm.c          |   2 +-
 arch/x86/kvm/vmx/capabilities.h |   9 +++
 arch/x86/kvm/vmx/nested.c       |  12 ++--
 arch/x86/kvm/vmx/vmx.c          |  12 +---
 arch/x86/kvm/x86.c              |  55 +++++++++++-------
 14 files changed, 145 insertions(+), 160 deletions(-)

-- 
2.19.1.6.gb485710b

