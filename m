Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A790D400819
	for <lists+kvm@lfdr.de>; Sat,  4 Sep 2021 01:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350418AbhICXM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 19:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349369AbhICXM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 19:12:58 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581DAC061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 16:11:58 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id h14-20020a0cffce000000b00372ea3f12a5so2334531qvv.9
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 16:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1IikKeiNBiI+661feqxQfbwdUTfKgQ/MgsLAZgB0GvY=;
        b=nnYsIrdngqs4rCZL60vqh/oslFzMghTxYs91Lvaxg9FUDbizKwLT/y5dBKvZItyjYB
         2SbHmreK5Dh/eAvEK7u0uZ8PQ0RhNw7IEbhqHi08gtDkIJRJfrHmmMTSPEFtqmkD8d0q
         hDUjQLrzl08MiCyVDUEK5nrAJMfdnGTqKwPwI7IAhnhgtFTbpk432m7oDb4Az2cLurKx
         ouqYjPK1Vfe/kpvWqf0i0zOjYDPgeSqIfxy/87KDQnfC52sgIVu/wJwohWGgwLQX4Zlq
         eWJSemqfNfIv5SCN3gp8SJG6mJed+nEMAHVilxzaA8XSMw69qqyGT0+qZF7jinl0RZPr
         LN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1IikKeiNBiI+661feqxQfbwdUTfKgQ/MgsLAZgB0GvY=;
        b=JHREhZwfqxyhGodVtSwVi8wcZlb5bBxFb/2QMk0ZFxPSybgnDqG7D4yTgokYseLKnu
         aZ0pW984aXcDBBtfaglXtTzzncrlPutM73hmYQCQpxmAEBxrmWkPBJYz5j6S+qJCYbhG
         XM++DKxsHQkcYeZktjAhUGL/DT+kmLuKWmETt0I+gSFq51sE1iJa60g3f50ZbE5DRb9d
         o68DsctTa9WYEWm7UvJspICxlIO+THP4tUNCruSELn6ZyrTz2yxik0piruf+QZPsKXjE
         RpJfS/TKaPf0zr5ia4UnHvul86kgEE79pDoO2qfRdzMkPsbK0Ubxg/qQJ9rg4If6v6m/
         bCRA==
X-Gm-Message-State: AOAM530wjgCTfstwzlV2ELHahXisLuCN9aF5BUPNLQdc84ThrEEVsg6v
        AHjInr4crVn74zSZYH+3hzQ1k2M/QI3UolEEn3On1kBKQSVmhlM6dYdyGhdE3czbsk6TDSNIQvR
        W5ik6Cl+Tp+9FCX/uhfVBIEUVkwvHlSNu8jzLxnLPPDp0huVEYZ9lCEVBAEQ5glQ=
X-Google-Smtp-Source: ABdhPJydyx6I9B32wXw0UwQZpNOLWE1nKUmlH3p8le+Vok/KTo3OivGxp8atC3n/FdlY3d/g7fuw77oUHxX1Rw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:54e:: with SMTP id
 ci14mr1567870qvb.3.1630710717409; Fri, 03 Sep 2021 16:11:57 -0700 (PDT)
Date:   Fri,  3 Sep 2021 16:11:52 -0700
Message-Id: <20210903231154.25091-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 0/2] KVM: selftests: enable the memslot tests in ARM64
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable memslot_modification_stress_test and memslot_perf_test in ARM64
(second patch). memslot_modification_stress_test builds and runs in
aarch64 without any modification. memslot_perf_test needs some nits
regarding ucalls (first patch).

Ricardo Koller (2):
  KVM: selftests: make memslot_perf_test arch independent
  KVM: selftests: build the memslot tests for arm64

 tools/testing/selftests/kvm/Makefile          |  2 +
 .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
 2 files changed, 36 insertions(+), 22 deletions(-)

-- 
2.33.0.153.gba50c8fa24-goog

