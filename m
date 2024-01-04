Return-Path: <kvm+bounces-5676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACE0C82491B
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 20:34:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49E8628706F
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E6B82D78C;
	Thu,  4 Jan 2024 19:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YfF/ayWH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9CB2D619
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 19:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cdacf76cb0so489768a12.0
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 11:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704396797; x=1705001597; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qZ35PN1q0iHckVfOzQt0Lv822iNpMobObRVnp2fKDjw=;
        b=YfF/ayWHN/NrlItWHhH0FTRZyhrRHiPytRG+758ReyXVHcRhBEPWX3YiYMRHaCwaKS
         lw7VNm6T2U4al//R1kJ0nCRqKnCet4sF/GIGmTN7fB5GYsRE6Ypfww8IMD/EPofjP37i
         ws2cq1zq1oJ6UGSJhR4mileBrNC4WmsSK8eC7Nbrrfn7VyYcPxlnLobEonxbiw3WH4g4
         Q4PoLBhJYYGoO8Ik3Monqcis7InePQCe+xlw3EUyxK/ST6k8antfrqUVaIMSWcmG2cxI
         VuU14m8Uw7X3nhUMwAE7JqwOAbXYzCB6gY55O9ZXr03MA1+BrQZyUQQoMeZTVADdDhYF
         0xJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704396797; x=1705001597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qZ35PN1q0iHckVfOzQt0Lv822iNpMobObRVnp2fKDjw=;
        b=mMjPk5kCPr+NZ/r4b55aa04as/cBntWpj6wW+yHBunhFOWuAUs4jKCZjdagcSTuNso
         bZ6KVtSPK1X+iqPUgrl1ZLP6umJQz1AlM/W9naVM69fSrRCobjF7ypRe42gNzQ1AXzW6
         k7t9KC5VLT2PgG6h7Mv0TYiwgSW4ACj3UAImBcTsycHLquhR+PQbu0lR/heXf6UnRnR8
         dPBX3PO0kvEcU0SLd9DwjHUBZTsrblbfeYzhPGKRM52EzKNoFNwDDU9dDcqsDBqazH5N
         tSqbwhu6b60P28uZd931GWvJmdc9b2V2n4hE6itLmDlRBCamFLoqZ3rMU/gOb2WaQqTm
         rFDg==
X-Gm-Message-State: AOJu0YziSNVQVJ3yjEyJmYtyexYJvngxKgCKVhfQL1dGT9R9FOB1sJR8
	MgvLxpWXJEaO7oFdc8XDsh9irusEKytuNARo7w==
X-Google-Smtp-Source: AGHT+IFMSLHqDb0XH6/g+3+Pq7bzImZElei5ftF8PNypaXTFrE0IU4NyQZ5QoQyoNoZXLH2A48LJxAOxLIM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:692:b0:5ce:d4a7:b8f2 with SMTP id
 ca18-20020a056a02069200b005ced4a7b8f2mr12821pgb.10.1704396796866; Thu, 04 Jan
 2024 11:33:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  4 Jan 2024 11:33:00 -0800
In-Reply-To: <20240104193303.3175844-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240104193303.3175844-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240104193303.3175844-6-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.8
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Two minor fixes from David, plus your series to clean up the "bool shared" mess.

The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b2f:

  selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:58:25 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.8

for you to fetch changes up to e59f75de4e501e87de7743fec29dd247a6ae6cd3:

  KVM: x86/mmu: fix comment about mmu_unsync_pages_lock (2023-12-01 07:52:09 -0800)

----------------------------------------------------------------
KVM x86 MMU changes for 6.8:

 - Fix a relatively benign off-by-one error when splitting huge pages during
   CLEAR_DIRTY_LOG.

 - Fix a bug where KVM could incorrectly test-and-clear dirty bits in non-leaf
   TDP MMU SPTEs if a racing thread replaces a huge SPTE with a non-huge SPTE.

 - Relax the TDP MMU's lockdep assertions related to holding mmu_lock for read
   versus write so that KVM doesn't pass "bool shared" all over the place just
   to have precise assertions in paths that don't actually care about whether
   the caller is a reader or a writer.

----------------------------------------------------------------
David Matlack (2):
      KVM: x86/mmu: Fix off-by-1 when splitting huge pages during CLEAR
      KVM: x86/mmu: Check for leaf SPTE when clearing dirty bit in the TDP MMU

Paolo Bonzini (4):
      KVM: x86/mmu: remove unnecessary "bool shared" argument from functions
      KVM: x86/mmu: remove unnecessary "bool shared" argument from iterators
      KVM: x86/mmu: always take tdp_mmu_pages_lock
      KVM: x86/mmu: fix comment about mmu_unsync_pages_lock

 Documentation/virt/kvm/locking.rst |  7 ++-
 arch/x86/include/asm/kvm_host.h    | 11 +++--
 arch/x86/kvm/mmu/mmu.c             |  8 ++--
 arch/x86/kvm/mmu/tdp_mmu.c         | 95 +++++++++++++++++---------------------
 arch/x86/kvm/mmu/tdp_mmu.h         |  3 +-
 5 files changed, 57 insertions(+), 67 deletions(-)

