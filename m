Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A7C60C5E
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 22:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfGEU3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 16:29:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54772 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEU3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 16:29:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so7255465wme.4;
        Fri, 05 Jul 2019 13:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=M3dkrI3CMPn3rN9TDQJJwhfDQQ8sL5SyNtyTfXwJzzo=;
        b=Mc08+EVTa3nQ+N8+MKpSDN7Tab6Zpb0xuoryurg+TQJ5MpCPe55jIGSYqXHmkRNBFu
         qn2ONSrBwuQfL0mvmLQ6Bhhcgee1NJUfT3TdvTvzBc9HrnGx1yrEvvu/cS35/D5FB2Wj
         rJhxT5ZtTQzjov88N9PHw5SOHq0KLL+WX1BcbcO7zTks51pbK5K8UKWrLSQHUSzAlTai
         Tip4FJku2QFicbOdQNjYKN+l4pVtTmdfGAq7JGE5k56H1CHXLes6K8eJXTBN0a7FpGcP
         fDG7JvlI1AtyqQXi5gMPAdzcNphkuoeeVPdtXpR1bCCBlm3AodwZvYtY1uVBC4/dqmtj
         3B7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=M3dkrI3CMPn3rN9TDQJJwhfDQQ8sL5SyNtyTfXwJzzo=;
        b=QDrFtWkK+wqRrkkJ8DfO7ehe9ePx+EK3n++me6r9xz5XklGm1T9WD7A49zuKPu7O9c
         WQ3FQXZQU1pDLPojSHa+qiCPXfdGjxMs8kLLv2vuDFwk1f9mSk9YaQ7tM4aEgcp2/mlo
         NhSYpJwBziW69R7cjXui7Owh2IFXXOZgIY3OF1DumyAeeyHv5tzFnjmIEOIZJ8c55iFR
         PHi5VelCKs6wyI+H7CR2LByGsM3aP1P6T2+F/i7+LENeBtCG66otwPh/mpCchTdJk1m/
         PqH83T/Q07gl2aTDPrBVnGwW92G8p2HOluS1g/HHGM6oslO/gcYJTKC6u5qZieeiuwno
         ij3Q==
X-Gm-Message-State: APjAAAVStODeIJD8bRG+B2l0021onk+AgJCi9t5k4FhGsIZ95nXwenH1
        WQcYdNzv9r2VwJpoE9aPjzWt6bDJ9/M=
X-Google-Smtp-Source: APXvYqy1vKnVPyrO0/F6dzES3KaiZnIr+MsNh3p70HMZ3qLIwOqc5RJ4dxIhIsB2sHolVwCuhmXupQ==
X-Received: by 2002:a05:600c:20c3:: with SMTP id y3mr4739636wmm.3.1562358572643;
        Fri, 05 Jul 2019 13:29:32 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id h11sm11090408wrx.93.2019.07.05.13.29.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 13:29:31 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] Final KVM changes for 5.2
Date:   Fri,  5 Jul 2019 22:29:30 +0200
Message-Id: <1562358570-30670-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 6fbc7275c7a9ba97877050335f290341a1fd8dbf:

  Linux 5.2-rc7 (2019-06-30 11:25:36 +0800)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e644fa18e2ffc8895ca30dade503ae10128573a6:

  KVM: arm64/sve: Fix vq_present() macro to yield a bool (2019-07-05 12:07:51 +0200)

----------------------------------------------------------------
x86 bugfix patches and one compilation fix for ARM.

----------------------------------------------------------------
Liran Alon (2):
      KVM: nVMX: Allow restore nested-state to enable eVMCS when vCPU in SMM
      KVM: nVMX: Change KVM_STATE_NESTED_EVMCS to signal vmcs12 is copied from eVMCS

Paolo Bonzini (1):
      KVM: x86: degrade WARN to pr_warn_ratelimited

Wanpeng Li (1):
      KVM: LAPIC: Fix pending interrupt in IRR blocked by software disable LAPIC

Zhang Lei (1):
      KVM: arm64/sve: Fix vq_present() macro to yield a bool

 arch/arm64/kvm/guest.c                          |  2 +-
 arch/x86/kvm/lapic.c                            |  2 +-
 arch/x86/kvm/vmx/nested.c                       | 30 ++++++++++++++++---------
 arch/x86/kvm/x86.c                              |  6 ++---
 tools/testing/selftests/kvm/x86_64/evmcs_test.c |  1 +
 5 files changed, 26 insertions(+), 15 deletions(-)
