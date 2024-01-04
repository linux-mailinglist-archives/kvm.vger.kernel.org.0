Return-Path: <kvm+bounces-5672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1C04824911
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 20:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A154028311A
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6EB42C6BF;
	Thu,  4 Jan 2024 19:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gbXGLFp2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FCE2C697
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 19:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d3fa2e42cdso5720725ad.2
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 11:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704396788; x=1705001588; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FSDd+X5ZTaifU0WBy/goS6knyn7TCHcpTbMdTcRHCko=;
        b=gbXGLFp2/cDsjSakRjPTir7m5/vHhSde16CAYVeKUQE5j7LjrLvOg9Sf+Ihz34uggV
         g3MjDpEzAZ1i23B/Xs/ZMFcHRA6vF6/TaMCzE8Ly+kwT6G6/+2z9VgUvfcjm3TeBNA3Z
         xKESg+081UcLoUyV5OBbZw0rEYnNY7xeYEH/7Ogbjo1BT5HzEnQhXurl/nDNGbGvg37s
         EgbL4xzlm18N6yjGB5VkzCHs4zb7odnsQXYH1JxS7CE0L3wydII42E+1uygI8QsSaSd7
         8i4zLl7L2srPUcaPHDhBQ4yb5A969t6qf0jOtySECmLXIN/3XWc2rxVPRZj8r3lpiKLi
         Y4NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704396788; x=1705001588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FSDd+X5ZTaifU0WBy/goS6knyn7TCHcpTbMdTcRHCko=;
        b=L3+Fz0HTWBkuPZ7qaGRfd/wfWCsIdf7NOJ86kRXOn3TCXXJ5RcHwUa/SYvfmNEn4ds
         O9z04D50Nw0ZkldShQI6JDu8jJBYKy+FUfBlGSw0dkKg4ky8axkP0CFynSyCWPE/lGRe
         bUJFJaRXcx8v8iV/MC6wgv5j/zBvkM2qSyv4eXyEnKPh0+8hXBi+E0i+MbcY3VxsSu7I
         IRmZgEe2G/4mHFhkVAaRxWS9r7xU9KywT89MNKe1LNzaEWPIUXl5bRWPYBsA3ajgilys
         SeGLpCt5/Pne9RZostFeVofUjdQ/9oJ49fpmYwsn+D+D6KTDtl34vwhZzLGC73+3W3gk
         rDnw==
X-Gm-Message-State: AOJu0YyLa7Rzmpw7vTXv0NeLgc1tqHxUH4McOALjc5IgYlj42jJVV8kk
	wx22mVp0ON6PADeDHEYoeFpMYy+LRmT9vLFXPQ==
X-Google-Smtp-Source: AGHT+IFv2oSqlNc5jamhAo/kLS21SNU3OZ12m5EFia9r0UiYgCr2UvPWhxtW5MqqwZB4CDzEZquxIVS8Zxs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f0c4:b0:1d3:4343:7b0 with SMTP id
 v4-20020a170902f0c400b001d3434307b0mr5618pla.2.1704396788013; Thu, 04 Jan
 2024 11:33:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  4 Jan 2024 11:32:56 -0800
In-Reply-To: <20240104193303.3175844-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240104193303.3175844-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240104193303.3175844-2-seanjc@google.com>
Subject: [GIT PULL] KVM: non-x86 changes for 6.8
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a few minor changes that aren't (just) x86.  The
vmemdup_array_user() patches were sent as a series, and the s390 folks were
quick on the draw with acks, so it was easiest for all involved to just grab
everything in one shot.

The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b2f:

  selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:58:25 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.8

for you to fetch changes up to 1f829359c8c37f77a340575957686ca8c4bca317:

  KVM: Harden copying of userspace-array against overflow (2023-12-01 08:00:53 -0800)

----------------------------------------------------------------
Common KVM changes for 6.8:

 - Use memdup_array_user() to harden against overflow.

 - Unconditionally advertise KVM_CAP_DEVICE_CTRL for all architectures.

----------------------------------------------------------------
Philipp Stanner (3):
      KVM: x86: Harden copying of userspace-array against overflow
      KVM: s390: Harden copying of userspace-array against overflow
      KVM: Harden copying of userspace-array against overflow

Wei Wang (1):
      KVM: move KVM_CAP_DEVICE_CTRL to the generic check

 arch/arm64/kvm/arm.c       | 1 -
 arch/powerpc/kvm/powerpc.c | 1 -
 arch/riscv/kvm/vm.c        | 1 -
 arch/s390/kvm/guestdbg.c   | 4 ++--
 arch/s390/kvm/kvm-s390.c   | 1 -
 arch/x86/kvm/cpuid.c       | 4 ++--
 virt/kvm/kvm_main.c        | 6 +++---
 7 files changed, 7 insertions(+), 11 deletions(-)

