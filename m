Return-Path: <kvm+bounces-6032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 208CB82A5B5
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 03:01:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10EA11C21E68
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 02:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6B5DA44;
	Thu, 11 Jan 2024 02:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LRgSy5UF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F6C7EA
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 02:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5ecfd153ccfso84405357b3.2
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 18:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704938452; x=1705543252; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HzOU3SyoPVJ6Dww3XOn2Ne2tHVPGDMAiBtAU3lr6VwM=;
        b=LRgSy5UFAFUcGu2SaZfg7qp5wXkBcbAN8sb4Qvaiyr8XmZXhZLhIvSo4ox7udaCJ5N
         TnIS/6lrntKL6pN02SOBOEIRUJnjI7qEn11LObq7TqdU4dUMyjZi5UU1IbasjANLWIxt
         x7K70I3csgrdyBbkxK4AtqPO+yKw48JCie7Rwk6FidCWsvw4Fk5lUV07UvqbMbpyuVqZ
         wonrgfdlrDYLVvtiSFaf3hPqXZgPQ/JJNnzwnBcesBoa2lmr7JZ9MyyPYgDehHqFPCCB
         aOT9JSm5mw/dF6zVXx3xU+yeiT/qTIcS35wtW5w/JvsF5Z8YbzeK4hbrJ9UCndWDmqH+
         s6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704938452; x=1705543252;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HzOU3SyoPVJ6Dww3XOn2Ne2tHVPGDMAiBtAU3lr6VwM=;
        b=pbvVshjE7y7JYoOY9EXE1UvkqnrFa4v3so8fAkn3CHM47c04oGJKyMUteXWwOtO1oU
         HZEGp2qYTqUQfFbcs4FX5B8Maf+wNJ6vVN4CMz4X7MpcNb19vJncZ7vnMwVTV89cYMZ8
         6lwUz/5DAmWtDMYL8ki7FO+1bZBVV9Vs5vlBbKHSAMPcNvXvHHsB28JSfjr/ue5tYwAG
         NJ/VzRksWG+sRxjnPXdV+3osH3AStjzDvUJJpd+54fv5wpl/KLwnL9IJIsJghq+zyuUU
         p/Zlv646tGNem43Dch0e/XnaTpBFuYn5LrF9rHlsxR2idrkLMS+H+pSf/RmJChlYVPan
         f0sw==
X-Gm-Message-State: AOJu0Yw8Iyw5Kqup/OipdlkKSvlu1sKY58VbDY/uOm4gyw1bmXu5+94f
	S8TRwBGan4VFx+i+WabA+jF/wiu+Z0n8Fiqrvw==
X-Google-Smtp-Source: AGHT+IFsBiQQOb+e4YvDeAqxVv4bZiqvjH7FaF7AN/tnvugHNZDSEcFWL/8rNIK1XhXSy0giwLh7EMuDJw8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:dd12:0:b0:5e8:4440:c52e with SMTP id
 e18-20020a81dd12000000b005e84440c52emr311775ywn.7.1704938452584; Wed, 10 Jan
 2024 18:00:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 10 Jan 2024 18:00:40 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111020048.844847-1-seanjc@google.com>
Subject: [PATCH 0/8] KVM: x86/mmu: Allow TDP MMU (un)load to run in parallel
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pattara Teerapong <pteerapong@google.com>
Content-Type: text/plain; charset="UTF-8"

This series is the result of digging into why deleting a memslot, which on
x86 forces all vCPUs to reload a new MMU root, causes noticeably more jitter
in vCPUs and other tasks when running with the TDP MMU than the Shadow MMU
(with TDP enabled).

Patch 1 addresses the most obvious issue by simply zapping at a finer
granularity so that if a different task, e.g. a vCPU, wants to run on the
pCPU doing the zapping, it doesn't have to wait for KVM to zap an entire
1GiB region, which can take a hundreds of microseconds (or more).  The
shadow MMU checks for need_resched() (and mmu_lock contention, see below)
every 10 zaps, which is why the shadow MMU doesn't induce the same level
of jitter.

On preemptible kernels, zapping at 4KiB granularity will also cause the
zapping task to yield mmu_lock much more aggressively if a writer comes
along.  That _sounds_ like a good thing, and most of the time it is, but
sometimes bouncing mmu_lock can be a big net negative:
https://lore.kernel.org/all/20240110012045.505046-1-seanjc@google.com

While trying to figure out whether or not frequently yielding mmu_lock
would be a negative or positive, I ran into extremely high latencies for
loading TDP MMU roots on VMs with large-ish numbers of vCPUs, e.g. a vCPU
could end up taking more than a second to 

Long story short, the issue is that the TDP MMU acquires mmu_lock for
write when unloading roots, and again when loading a "new" root (in quotes
because most vCPUs end up loading an existing root).  With a decent number
of vCPUs, that results in a _lot_ mmu_lock contention, as every vCPU will
take and release mmu_lock for write to unload its roots, and then again to
load a new root.  Due to rwlock's fairness (waiting writers block new
readers), the contention can result in rather nasty worst case scenarios.

Patches 6-8 fix the issues by taking mmu_lock for read.  The free path is
very straightforward and doesn't require any new protection (IIRC, the only
reason we didn't pursue this when reworking the TDP MMU zapping back at the
end of 2021 was because we had bigger issues to solve).  Allocating a new
root with mmu_lock held for read is a little harder, but still fairly easy.
KVM only needs to ensure that it doesn't create duplicate roots, because
everything that needs mmu_lock to ensure ordering must take mmu_lock for
write, i.e. is still mutually exclusive with new roots coming along.

Patches 2-5 are small cleanups to avoid doing work for invalid roots, e.g.
when zapping SPTEs purely to affect guest behavior, there's no need to zap
invalid roots because they are unreachable from the guest.

All told, this significantly reduces mmu_lock contention when doing a fast
zap, i.e. when deleting memslots, and takes the worst case latency for a
vCPU to load a new root from >3ms to <100us for large-ish VMs (100+ vCPUs)
For small and medium sized VMs (<24 vCPUs), the vast majority of loads
takes less than 1us, with the worst case being <10us, versus >200us without
this series.

Note, I did all of the latency testing before the holidays, and then
managed to lose almost all of my notes, which is why I don't have more
precise data on the exact setups and latency bins.  /facepalm

Sean Christopherson (8):
  KVM: x86/mmu: Zap invalidated TDP MMU roots at 4KiB granularity
  KVM: x86/mmu: Don't do TLB flush when zappings SPTEs in invalid roots
  KVM: x86/mmu: Allow passing '-1' for "all" as_id for TDP MMU iterators
  KVM: x86/mmu: Skip invalid roots when zapping leaf SPTEs for GFN range
  KVM: x86/mmu: Skip invalid TDP MMU roots when write-protecting SPTEs
  KVM: x86/mmu: Check for usable TDP MMU root while holding mmu_lock for
    read
  KVM: x86/mmu: Alloc TDP MMU roots while holding mmu_lock for read
  KVM: x86/mmu: Free TDP MMU roots while holding mmy_lock for read

 arch/x86/kvm/mmu/mmu.c     |  33 +++++++---
 arch/x86/kvm/mmu/tdp_mmu.c | 124 ++++++++++++++++++++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.h |   2 +-
 3 files changed, 111 insertions(+), 48 deletions(-)


base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
-- 
2.43.0.275.g3460e3d667-goog


