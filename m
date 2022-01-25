Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE5549B115
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237868AbiAYKBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238379AbiAYJ7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:22 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD4FC06173B;
        Tue, 25 Jan 2022 01:59:17 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id j16so8192112plx.4;
        Tue, 25 Jan 2022 01:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fFdstgg2rUPcDb1ze6Gb3FBjJ5NhUjfUjZg63XhP3m8=;
        b=d+kNdAtMC6VO/K1pd0rlN3+UkQOHTSr4/8Gvkn1XwyLvTnRQ/TA3GNk3a2s1bCr2Gd
         3xuvmKQHZ3Fy9dVJw6BkE4phM9S95dvpNcR683U5+kTyWv8JQvTZmFLZVyvaluxvP1o5
         +Wpx8L1PAgT5V9HdJURbByv1VzZq1ANPnl28o6uHseAe0V1tJUF6/LKGT+nMvK/xt7y5
         ckk8STa/NEXmMkks/iqDTEARcLiofyLonnojaiQ26bLAnylen+NUHqpP/VwoCy70Oxrw
         G2myquSEOWdac1UHYok3RKBzxT1s2Y06/YTb1+IRAcchqE1v1j6GsmXeO23aUDER9Yyu
         wtpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fFdstgg2rUPcDb1ze6Gb3FBjJ5NhUjfUjZg63XhP3m8=;
        b=psNXcdOy0jAo8UoY/f0pN+V1p0iO9r5zgJECP2trw/Mqr+PtXg1rbM8H+vZQZzkhRR
         ADvCzkNhaQNK/2IKI2aznkE8ieCrSQy5U+W5RWG3WpQ94rMw/FxwEpVtb+Guw/ISznwo
         t/d1Phe/h9FxamdzKpf8vuEDv8OANsQteIfB5ys+Lk2auMFVpN/xxy4gJA3mOZ2nyrks
         lqyzi2mmxzDkjV/5QmMhEM9YLQ2buZLsuF2XvHooLgQiN+CU1NwaLE50wB2aGaFqMCHZ
         DJ8M6kFgfmgHzeGdO8/1RfSPv3FQeRVEvcLzzuLL6oLidWY8xxOLKuzDCddWEcGWuZQu
         eTXg==
X-Gm-Message-State: AOAM531zDRKPAE83yJXBk1a5O0GUC5/FbgaHoz37GMqWpQWfsPUc6C3a
        2Lu4Ae+l3G3RTVGf01Im+wQ=
X-Google-Smtp-Source: ABdhPJynTjSw3NN4RTxtz7nF2flKZPjtCXyUXoOuXHJABCpRtZ88n0dzVJCCdj/R1ZW5yc4xCGtwog==
X-Received: by 2002:a17:902:8695:b0:14a:f006:db03 with SMTP id g21-20020a170902869500b0014af006db03mr17647228plo.173.1643104757470;
        Tue, 25 Jan 2022 01:59:17 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:17 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/19] KVM: x86: Bulk removal of unused function parameters
Date:   Tue, 25 Jan 2022 17:58:50 +0800
Message-Id: <20220125095909.38122-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Hi,

This patch set is a follow up to a similar patch [1], and may
hopefully help to improve the code quality of KVM.

Basically, the cleanup is triggered by a compiler feature[2], but obviously
there are a lot of false positives here, and so far we may apply at least
this changset, which also helps the related developers to think more
carefully about why these functions were declared that way in the first
place or what is left after a series of loosely-coupled clean-ups.

[1] https://lore.kernel.org/kvm/20220124020456.156386-1-xianting.tian@linux.alibaba.com/
[2] ccflags-y += -Wunused-parameter

Thanks,
Like Xu

Jinrong Liang (19):
  KVM: x86/mmu: Remove unused "kvm" of kvm_mmu_unlink_parents()
  KVM: x86/mmu: Remove unused "kvm" of __rmap_write_protect()
  KVM: x86/mmu: Remove unused "vcpu" of
    reset_{tdp,ept}_shadow_zero_bits_mask()
  KVM: x86/tdp_mmu: Remove unused "kvm" of kvm_tdp_mmu_get_root()
  KVM: x86/mmu_audit: Remove unused "level" of audit_spte_after_sync()
  KVM: x86/svm: Remove unused "vcpu" of svm_check_exit_valid()
  KVM: x86/svm: Remove unused "vcpu" of nested_svm_check_tlb_ctl()
  KVM: x86/svm: Remove unused "vcpu" of kvm_after_interrupt()
  KVM: x86/sev: Remove unused "svm" of sev_es_prepare_guest_switch()
  KVM: x86/sev: Remove unused "kvm" of sev_unbind_asid()
  KVM: x86/sev: Remove unused "vector" of sev_vcpu_deliver_sipi_vector()
  KVM: x86/i8259: Remove unused "addr" of elcr_ioport_{read,write}()
  KVM: x86/ioapic: Remove unused "addr" and "length" of
    ioapic_read_indirect()
  KVM: x86/emulate: Remove unused "ctxt" of setup_syscalls_segments()
  KVM: x86/emulate: Remove unused "ctxt" of task_switch_{16, 32}()
  KVM: x86: Remove unused "vcpu" of kvm_arch_tsc_has_attr()
  KVM: x86: Remove unused "vcpu" of kvm_scale_tsc()
  KVM: Remove unused "kvm" of kvm_make_vcpu_request()
  KVM: Remove unused "flags" of kvm_pv_kick_cpu_op()

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/emulate.c          | 20 ++++++++------------
 arch/x86/kvm/i8259.c            |  8 ++++----
 arch/x86/kvm/ioapic.c           |  6 ++----
 arch/x86/kvm/mmu/mmu.c          | 23 ++++++++++-------------
 arch/x86/kvm/mmu/mmu_audit.c    |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.h      |  3 +--
 arch/x86/kvm/svm/nested.c       |  4 ++--
 arch/x86/kvm/svm/sev.c          | 12 ++++++------
 arch/x86/kvm/svm/svm.c          | 10 +++++-----
 arch/x86/kvm/svm/svm.h          |  4 ++--
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.c              | 25 ++++++++++++-------------
 arch/x86/kvm/x86.h              |  2 +-
 virt/kvm/kvm_main.c             |  9 ++++-----
 16 files changed, 63 insertions(+), 75 deletions(-)

-- 
2.33.1

