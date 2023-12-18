Return-Path: <kvm+bounces-4733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D6E2817715
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F27C728550A
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5981B49886;
	Mon, 18 Dec 2023 16:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C628RUO3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DBD42387
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 16:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pgonda.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d388c391faso10514595ad.2
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702915946; x=1703520746; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lukVt3shSrRcS1/ggYagmM+41rVSkPEbOO8O7jftz7o=;
        b=C628RUO388Y71l8XLSXA6RvOrSrgDCUm7b3+DsahACeCaiYhZb3PHD5CQ6T8XQLbsr
         ia5/ZqSSKwexJYFHpqXCPpDzbc+QklJMpqmU/AgaCrha/rWO8SMiOLR0Vcjbmrpxe5i2
         Vft12gXU/eCN/CrdaUKdX+026wK7bQgvdKsyuOExZ/HUmz+XWuSzeZCOkH/fxM4Efpni
         xzOTUkF7J3T+bM3wZ9lKu9pBVDBCm/zuPOLZUagrjyVHk8zvutWpvzevoEO+K9YTF/IP
         hUjbeyI54Fsrrv9+ssnWMzjYiYouNZRLZi1QZ0iuUZ/d5rENNJUXsWBNePo76Nx3MLxh
         UZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702915946; x=1703520746;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lukVt3shSrRcS1/ggYagmM+41rVSkPEbOO8O7jftz7o=;
        b=mGXbJmipcUaDVAR0DQTnAEEtX2nqhb5XWhUZfPQVBLCmGcVbpEOz+YF2WiTXiGbWsF
         e/Mkf8Fo+36eAOcSH2SI8/TYnsRpI++i2j7hMmifURQ1yyhbDDkru9WIODDcITzQw4fi
         bxHNlxOnW3tiYGkA0+04qGqzOYpq4+jjSrrFtgrRjXvbq9YuLMzCtbzt3An/kefzUk4u
         8fuBfUMakxEtaORCJSypNVu7o19/FinFuPIX096uUh1mRsOZaiXsQf2Gp6Fn/Xh3pNin
         FmHxd9bK0vgbeaL6v2776/ryHiSHStSz1adIDLYApzBce4k5jdIDeLeJkJmoxf0fLS1q
         Yhsg==
X-Gm-Message-State: AOJu0YxKlPQ/zl6CsgkJ6ieDE4rQswh/WMTLXOj8uoz50ypZztWmhH7C
	wsg4Jtkn6m36B8/D8ykxEoWuFvsu7uxE/hvqsnPSOzKGR1x3x2mPtTuSfNbalMGI7/Kbkc0QpCS
	/Jl2hvXt4c4UaoOkKiw0oiJm2YSokjRKDnh+KKfTRsDO4aUXTrcoXAFx29g==
X-Google-Smtp-Source: AGHT+IGguq01bKcmFRnSq13dz5p8WLczO6GaTqw/Deg2vFBN+3aXb7wuqTkgneoE5gbism0siPjww9mSTts=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:15:8aeb:e3fa:237c:63a5])
 (user=pgonda job=sendgmr) by 2002:a17:903:41cd:b0:1d2:ebcd:2341 with SMTP id
 u13-20020a17090341cd00b001d2ebcd2341mr2011377ple.9.1702915945416; Mon, 18 Dec
 2023 08:12:25 -0800 (PST)
Date: Mon, 18 Dec 2023 08:11:38 -0800
Message-Id: <20231218161146.3554657-1-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Subject: [PATCH V7 0/8] KVM: selftests: Add simple SEV test
From: Peter Gonda <pgonda@google.com>
To: kvm@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>, linux-kernel@vger.kernel.org, seanjc@google.com, 
	michael.roth@amd.com, thomas.lendacky@amd.com, joro@8bytes.org, 
	pbonzini@redhat.com, andrew.jones@linux.dev, vannapurve@google.com, 
	ackerleytng@google.com
Content-Type: text/plain; charset="UTF-8"

This patch series continues the work Michael Roth has done in supporting
SEV guests in selftests. It continues on top of the work Sean
Christopherson has sent to support ucalls from SEV guests. Along with a
very simple version of the SEV selftests Michael originally proposed.

V7
 * Thanks to Sean for the branch: 
 https://github.com/sean-jc/linux/tree/x86/sev_selftests_for_peter. This
 series is now based on that.
 * I kept is_pt_protected because without it the page tables are never
 readable. Its used for the elf loading in kvm_vm_elf_load().

V6
 * Updated SEV VM create function based on Seanjc's feedback and new
   changes to VM creation functions.
 * Removed pte_me_mask based on feedback.
 * Fixed s_bit usage based on TDX
 * Fixed bugs and took Ackerly's code for enc_region setup code.

V5
 * Rebase onto seanjc@'s latest ucall pool series.
 * More review changes based on seanjc:
 ** use protected instead of encrypted outside of SEV specific files
 ** Swap memcrypt struct for kvm_vm_arch arch specific struct
 ** Make protected page table data agnostic of address bit stealing specifics
    of SEV
 ** Further clean up for SEV library to just vm_sev_create_one_vcpu()
 * Due to large changes moved more authorships from mroth@ to pgonda@. Gave
   originally-by tags to mroth@ as suggested by Seanjc for this.

V4
 * Rebase ontop of seanjc@'s latest Ucall Pool series:
   https://lore.kernel.org/linux-arm-kernel/20220825232522.3997340-8-seanjc@google.com/
 * Fix up review comments from seanjc
 * Switch authorship on 2 patches because of significant changes, added
 * Michael as suggested-by or originally-by.

V3
 * Addressed more of andrew.jones@ in ucall patches.
 * Fix build in non-x86 archs.

V2
 * Dropped RFC tag
 * Correctly separated Sean's ucall patches into 2 as originally
   intended.
 * Addressed andrew.jones@ in ucall patches.
 * Fixed ucall pool usage to work for other archs

V1
 * https://lore.kernel.org/all/20220715192956.1873315-1-pgonda@google.com/

Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: seanjc@google.com
Cc: michael.roth@amd.com
Cc: thomas.lendacky@amd.com
Cc: joro@8bytes.org
Cc: pbonzini@redhat.com
Cc: andrew.jones@linux.dev
Cc: vannapurve@google.com
Cc: ackerleytng@google.com

Michael Roth (2):
  KVM: selftests: Make sparsebit structs const where appropriate
  KVM: selftests: add support for protected vm_vaddr_* allocations

Peter Gonda (6):
  KVM: selftests: Extend VM creation's @mode to allow control of VM
    subtype
  KVM: selftests: add hooks for managing protected guest memory
  KVM: selftests: Allow tagging protected memory in guest page tables
  KVM: selftests: add library for creating/interacting with SEV guests
  KVM: selftests: Update ucall pool to allocate from shared memory
  KVM: selftests: Add simple sev vm testing

 include/uapi/linux/kvm.h                      |   2 +-
 tools/arch/arm64/include/asm/kvm_host.h       |   7 +
 tools/arch/riscv/include/asm/kvm_host.h       |   7 +
 tools/arch/s390/include/asm/kvm_host.h        |   7 +
 tools/arch/x86/include/asm/kvm_host.h         |  15 ++
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/include/kvm_util_base.h     | 113 +++++++---
 .../testing/selftests/kvm/include/sparsebit.h |  58 +++--
 .../selftests/kvm/include/x86_64/processor.h  |   2 +
 .../selftests/kvm/include/x86_64/sev.h        |  27 +++
 tools/testing/selftests/kvm/lib/guest_modes.c |   2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 103 ++++++---
 tools/testing/selftests/kvm/lib/sparsebit.c   |  48 ++---
 .../testing/selftests/kvm/lib/ucall_common.c  |   3 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  31 ++-
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 202 ++++++++++++++++++
 .../selftests/kvm/x86_64/sev_all_boot_test.c  |  59 +++++
 17 files changed, 585 insertions(+), 103 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/kvm_host.h
 create mode 100644 tools/arch/riscv/include/asm/kvm_host.h
 create mode 100644 tools/arch/s390/include/asm/kvm_host.h
 create mode 100644 tools/arch/x86/include/asm/kvm_host.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c

-- 
2.43.0.472.g3155946c3a-goog


