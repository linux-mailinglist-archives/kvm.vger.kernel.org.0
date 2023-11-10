Return-Path: <kvm+bounces-1401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 166D47E75FE
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 01:37:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F1851C20DBD
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D0F7EB;
	Fri, 10 Nov 2023 00:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W+crt5p0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B6D36C
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 00:37:46 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99F8D5B
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:37:45 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc5ef7e815so14233605ad.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 16:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699576665; x=1700181465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+LGSbmax67eOY26Ujwp3uPRvs7lMuMeMZ8sMWFX4nEw=;
        b=W+crt5p03v9hmS4OnQZhrhK2zd5nvXdVGZYu6cxj7fvl83/DyI8y0sFFDvhpLQJadS
         yRdzYCdiJeNBC5GL/HqoYsR4M6SUWVFFKZWgbmp+ysoi6I65ytm01g0og5TLyWRpcfuy
         G2BaYP+9Q3kfrgTeg4ul0Y+Y4VOXEco9v/tNbc1+SXOX2jJ8KwHIxkSB4S85eaOszAYX
         vIXqTJt57KFmgskajAaiNDk5oNkRzI/3fhTAGXpFV6Hh/S7Ywtu7b/PfvaP3m5d/V2ub
         4XIvR19mnofZmKQn4w0hUEl5hG4wwIDV4bqq6ijk18J32vAj/BO5qsqN7OMnturLt/El
         5nkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699576665; x=1700181465;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+LGSbmax67eOY26Ujwp3uPRvs7lMuMeMZ8sMWFX4nEw=;
        b=M7tsjVh5al+XXdQcPM/HZ4mlx0rDx559kP3ffoVGO2vNJuwWwYMiY7xqpw2hCRgb+g
         eYlV/hso8oJ4Jk2e1dYb8htEOlbQzioyuJamuoKs/4bGpPM6xhoIrtD5yO89+00H+pH5
         +HvSs2aeT4o3kQkyTM43cO9rSIbRNzRpx1yitxhRzHQ+zw3CO2Qix7cExM/o/Nv5W/uE
         7qKvaNBlS2DJtolzTW9C5QKNQFqP9abbh24r7I7CVscv/jIWqXL4H6NVAJtTmiE9oVmP
         nA+HWXSjp/R6IR1Wyl9HBWlXSGBN5Q5u76NLFrzd9EfXwMyhSCDjrMAJ/UFmw8t0XqHJ
         hjQQ==
X-Gm-Message-State: AOJu0Ywodw5tNWBRFgb6ja3ngaJkv/yXRAkMh1bNzeR4jO4q1RC+qTmW
	+X81x9n7EEIEQDOQIEWSbtAEu4i9vnU=
X-Google-Smtp-Source: AGHT+IG/7BR/bVgac0iyHRbkVYTFyj9QAWxK4SZ9Hsf+60bfWwLuN4JrhnYjogalBg02XIbV5VfpylQGo5Mm
X-Received: from jackyli.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3b51])
 (user=jackyli job=sendgmr) by 2002:a17:902:f80e:b0:1cc:2a6f:ab91 with SMTP id
 ix14-20020a170902f80e00b001cc2a6fab91mr848597plb.0.1699576665105; Thu, 09 Nov
 2023 16:37:45 -0800 (PST)
Date: Fri, 10 Nov 2023 00:37:30 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231110003734.1014084-1-jackyli@google.com>
Subject: [RFC PATCH 0/4] KVM: SEV: Limit cache flush operations in sev guest
 memory reclaim events
From: Jacky Li <jackyli@google.com>
To: Sean Christpherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ovidiu Panait <ovidiu.panait@windriver.com>, Liam Merwick <liam.merwick@oracle.com>, 
	Ashish Kalra <Ashish.Kalra@amd.com>, David Rientjes <rientjes@google.com>, 
	David Kaplan <david.kaplan@amd.com>, Peter Gonda <pgonda@google.com>, 
	Mingwei Zhang <mizhang@google.com>, kvm@vger.kernel.org, Jacky Li <jackyli@google.com>
Content-Type: text/plain; charset="UTF-8"

The cache flush operation in sev guest memory reclaim events was
originally introduced to prevent security issues due to cache
incoherence and untrusted VMM. However when this operation gets
triggered, it causes performance degradation to the whole machine.

This cache flush operation is performed in mmu_notifiers, in particular,
in the mmu_notifier_invalidate_range_start() function, unconditionally
on all guest memory regions. Although the intention was to flush
cache lines only when guest memory was deallocated, the excessive
invocations include many other cases where this flush is unnecessary.

This RFC proposes using the mmu notifier event to determine whether a
cache flush is needed. Specifically, only do the cache flush when the
address range is unmapped, cleared, released or migrated. A bitmap
module param is also introduced to provide flexibility when flush is
needed in more events or no flush is needed depending on the hardware
platform.

Note that the cache flush operation in memory reclamation only targets
SEV/SEV-ES platforms and no cache flush is needed in SEV-SNP VMs.
Therefore the patch series does not apply to the SEV-SNP context.

Jacky Li (4):
  KVM: SEV: Drop wbinvd_on_all_cpus() as kvm mmu notifier would flush
    the cache
  KVM: SEV: Plumb mmu_notifier_event into sev function
  KVM: SEV: Limit the call of WBINVDs based on the event type of mmu
    notifier
  KVM: SEV: Use a bitmap module param to decide whether a cache flush is
    needed during the guest memory reclaim

 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/svm/sev.c          | 62 ++++++++++++++++++++++++---------
 arch/x86/kvm/svm/svm.h          |  3 +-
 arch/x86/kvm/x86.c              |  5 +--
 include/linux/kvm_host.h        |  3 +-
 include/linux/mmu_notifier.h    |  4 +++
 virt/kvm/kvm_main.c             | 14 +++++---
 7 files changed, 68 insertions(+), 26 deletions(-)

-- 
2.43.0.rc0.421.g78406f8d94-goog


