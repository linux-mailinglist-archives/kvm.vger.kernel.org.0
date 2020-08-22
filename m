Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A43E24E63A
	for <lists+kvm@lfdr.de>; Sat, 22 Aug 2020 10:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgHVIGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Aug 2020 04:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHVIGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Aug 2020 04:06:53 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31502C061573;
        Sat, 22 Aug 2020 01:06:53 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id t2so3593051wma.0;
        Sat, 22 Aug 2020 01:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nhZfeKpNSacQbwTrkcUeaFzZcY4FZUsrUpQMtrkrP2c=;
        b=YQV7DnC3V8PvPvptXW/BVERjjxjrNXBeychEiMxzqTFY+lGLNxR6aSk0ypAfQYyhL9
         XbSFgUa3IJsKKPTIzvHWGogGn662txyC9Q5euywi/Hhl8+mXePCd4GU4cEhe9RR9ORT9
         gLukSaM27MjShgntoLgntSyeUglxKzb6ErnHy+FcKVKGSShxCvX6FCuOoDG8oaeCa4Ak
         9QtOUzLAm/T77bXmFkuH0hwP4gZoG4Fju/V4uRRgB8voNUFQwE8CT04iZ5e3UFmDqanX
         yYj4jQ8enMcsa8GHKeSe2nmP1qi/Sgwxnxjqy5HuuwER3IXdGBV1m9UDsWHbO0lhbthX
         vsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=nhZfeKpNSacQbwTrkcUeaFzZcY4FZUsrUpQMtrkrP2c=;
        b=bqzhF1u9LX9Mf9KRCiaTdD/oIeoJuUh1/ZOKGykiDaAX1r3g7Pkdr4biw3M+IUPpU2
         4Itt9iGswp1QvNjmc5OLpsfS7/4RHTx1qBHXEvUzndfFqn7FtPZnQh/Dx3cZ/G+zuWwG
         4EmCMd4q4g3E3ww7OlM/OuiEYP1vtRZytG1+Uj8tzd2UZcO9d8LsRyE/44W8aC2OyBzF
         PJhE6UJIL6/usNUFXLqMlUlgTi3Ls7NUpYBUgeUkTxl7mqGfDZTGQyyzsWF93Ol+C6Vr
         1NmzA0XaDMO+i1EGEU3GjHxk2o2jx2x7aVp4B+AGLA5LCjAb8FW/9QqNN8lsTOvHC7bj
         OgAw==
X-Gm-Message-State: AOAM530t/tk/X5G6HVP2961c52PHnY+ADouY+cunFiyRvi31ffh9P8v5
        YTxT8wX/ELYdWjdLg2q6EoE=
X-Google-Smtp-Source: ABdhPJwYvtwRWEsSBMuzGRA2zYq/qq1QawjKPThni5wD8n7e8wcqJTjonTZVOCpTdhfeRZ487YrRXw==
X-Received: by 2002:a7b:c095:: with SMTP id r21mr7134017wmh.152.1598083611868;
        Sat, 22 Aug 2020 01:06:51 -0700 (PDT)
Received: from donizetti.lan ([2001:b07:6468:f312:1cc0:4e4e:f1a9:1745])
        by smtp.gmail.com with ESMTPSA id i4sm8804892wrw.26.2020.08.22.01.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 01:06:51 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, maz@kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.9-rc2
Date:   Sat, 22 Aug 2020 10:06:47 +0200
Message-Id: <20200822080647.722819-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit e792415c5d3e0eb52527cce228a72e4392f8cae2:

  KVM: MIPS/VZ: Fix build error caused by 'kvm_run' cleanup (2020-08-11 07:19:41 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to b5331379bc62611d1026173a09c73573384201d9:

  KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is not set (2020-08-21 18:06:43 -0400)

----------------------------------------------------------------
* PAE and PKU bugfixes for x86
* selftests fix for new binutils
* MMU notifier fix for arm64

----------------------------------------------------------------
Jim Mattson (2):
      kvm: x86: Toggling CR4.SMAP does not load PDPTEs in PAE mode
      kvm: x86: Toggling CR4.PKE does not load PDPTEs in PAE mode

Paolo Bonzini (1):
      KVM: x86: fix access code passed to gva_to_gpa

Will Deacon (2):
      KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()
      KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is not set

Yang Weijiang (1):
      selftests: kvm: Use a shorter encoding to clear RAX

 arch/arm64/include/asm/kvm_host.h               |  2 +-
 arch/arm64/kvm/mmu.c                            | 19 ++++++++++++++-----
 arch/mips/include/asm/kvm_host.h                |  2 +-
 arch/mips/kvm/mmu.c                             |  3 ++-
 arch/powerpc/include/asm/kvm_host.h             |  3 ++-
 arch/powerpc/kvm/book3s.c                       |  3 ++-
 arch/powerpc/kvm/e500_mmu_host.c                |  3 ++-
 arch/x86/include/asm/kvm_host.h                 |  3 ++-
 arch/x86/kvm/mmu/mmu.c                          |  3 ++-
 arch/x86/kvm/x86.c                              |  6 ++++--
 tools/testing/selftests/kvm/x86_64/debug_regs.c |  4 ++--
 virt/kvm/kvm_main.c                             |  3 ++-
 12 files changed, 36 insertions(+), 18 deletions(-)
