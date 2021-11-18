Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941E04559A0
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343592AbhKRLLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbhKRLLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:11:04 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AC1C061570;
        Thu, 18 Nov 2021 03:08:04 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u17so4926632plg.9;
        Thu, 18 Nov 2021 03:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pt7Rg5JOojm2j33JkoMJz/6LSNwEcfgC+W0f8ruyci8=;
        b=YoQ9ssDfho+NMrYaV8TRA6bXZmwY7baUz7caqD3pEO+JVGgo3/gq7Eq8XHUdqcBduG
         Pyqb4PLUl/ofndGnREymTJpYH1lBCINZrFifSPf8DGa5VQKND3YYOolpBm3wyU0cWj5d
         lRDtWqebxc3TK6ZQBos6pK1tS9TT2Zmao1uHG+Q2r7nclooBTKoFr/G7zrDHv0AQ4XR9
         bBCtjglMGPQ5Nrelk5D4YH8Q6/y2ypdScWIc3Xrl+uaJuFn8Tec3vdF8qQxxJ3Zldjxs
         XO1bCDfiUcdARFUYEZ+qOxRy2t7E/lqYuOOBJUYgQeOjF/N8crLx83wxk4k7r2WhtVYv
         JzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pt7Rg5JOojm2j33JkoMJz/6LSNwEcfgC+W0f8ruyci8=;
        b=RT3bUK6UYhe+HOmnBa3LxO39OZRJDoWxkzs4uig0KwJgFfRzv7m2r/254Bl6w130pf
         tiiDn+0+AORDvQ1BS6KnYoSu7sXzJQpftIIjQ57cYsvklSxPjVmtX0uh39YFlnSSd1u/
         OqHq+qLGXW39OsxhcHqOvBAJp2By1m/OFuHhD8DXDMeNxX5dystutezo/uyHjjjCo1Xj
         xHbNuMmyloM6mYba/wh1qOcqfzmNxgPqAbOhbcDge5DadgR/5VovFFw0AWsobKE1MFqB
         LatzEHmvhHQRIbhPMSfe0I24LbSDJcJorhOH7PNsccdRVbGofFzNil6cXnLGFsMRZ8Nv
         daUA==
X-Gm-Message-State: AOAM533x5cj5slY38fHmOzkH4/odRXKn+Jy3wVsdNQ/Uzb+7n6t25Kql
        8Xl7P+B2EsPPiZ6Bl3um3YsnuBbNH8A=
X-Google-Smtp-Source: ABdhPJzadb/OPNOvSmZ4/zeD6NPMG21jL1wncFgHv93i0FgQbE3IzVX6uKXBJBd+ECUcqjhnnI0i1A==
X-Received: by 2002:a17:902:7d96:b0:142:6a63:c1cd with SMTP id a22-20020a1709027d9600b001426a63c1cdmr64050271plm.88.1637233684097;
        Thu, 18 Nov 2021 03:08:04 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id mp12sm7981012pjb.39.2021.11.18.03.08.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:08:03 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 00/15] KVM: X86: Miscellaneous cleanups
Date:   Thu, 18 Nov 2021 19:07:59 +0800
Message-Id: <20211118110814.2568-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

All are just cleanups and independent to each other except the last 3
patches.

Lai Jiangshan (15):
  KVM: VMX: Use x86 core API to access to fs_base and inactive gs_base
  KVM: VMX: Avoid to rdmsrl(MSR_IA32_SYSENTER_ESP)
  KVM: VMX: Update msr value after kvm_set_user_return_msr() succeeds
  KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()
  KVM: VMX: Add document to state that write to uret msr should always
    be intercepted
  KVM: VMX: Use kvm_set_msr_common() for MSR_IA32_TSC_ADJUST in the
    default way
  KVM: VMX: Change comments about vmx_get_msr()
  KVM: SVM: Rename get_max_npt_level() to get_npt_level()
  KVM: SVM: Allocate sd->save_area with __GFP_ZERO
  KVM: X86: Skip allocating pae_root for vcpu->arch.guest_mmu when
    !tdp_enabled
  KVM: X86: Fix comment in __kvm_mmu_create()
  KVM: X86: Remove unused declaration of __kvm_mmu_free_some_pages()
  KVM: X86: Remove useless code to set role.gpte_is_8_bytes when
    role.direct
  KVM: X86: Calculate quadrant when !role.gpte_is_8_bytes
  KVM: X86: Always set gpte_is_8_bytes when direct map

 Documentation/virt/kvm/mmu.rst  |  2 +-
 arch/x86/include/asm/kvm_host.h | 11 ------
 arch/x86/kernel/process_64.c    |  2 ++
 arch/x86/kvm/mmu/mmu.c          | 12 ++++---
 arch/x86/kvm/svm/svm.c          | 12 +++----
 arch/x86/kvm/vmx/nested.c       |  8 +----
 arch/x86/kvm/vmx/vmx.c          | 64 +++++++++++++++++++--------------
 7 files changed, 53 insertions(+), 58 deletions(-)

-- 
2.19.1.6.gb485710b

