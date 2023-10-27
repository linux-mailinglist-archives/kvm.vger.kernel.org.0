Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2057DA1FA
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 22:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346542AbjJ0Utq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 16:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346508AbjJ0Utm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 16:49:42 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB70F1B5
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:40 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-58b2d243b26so2039877a12.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698439780; x=1699044580; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=q924ZKafcGMtYjaz9067ugqgo78NK3y25v5Mf4ZhCmY=;
        b=A19CJkNL+R6BQ3FSzy9dskrnQ21J/FjnmTzxbB6h058aRZ20Q2zk6MIQ2m02Ve+ruR
         dbDIO3mXZpqb58qGdpukOF9j4y9RBl4xOHPf8CJkTPJFjRwkIwDty2CQVMXJYplb+VFr
         6KETSt5406snSFOrlJvT+802FUIUqYSP/WTjVYOK/KLn1nBHPm3qIVPEgcKO5xdSb2OX
         ayQvmaTwaUFEDD/h2u3oHWQSohIf8rk1JAQUcCtuCG2Akg048m2fkVenz4jyol5oFHhy
         etMVLoLz3zURNXJS6VE57Ez6taiweVjOpVEF5MvuZfwVNU/X2Gszbg6RRxkmiaRs4yHm
         FbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698439780; x=1699044580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q924ZKafcGMtYjaz9067ugqgo78NK3y25v5Mf4ZhCmY=;
        b=KrVQMeoU6DfBZJ7VWrVOL3aDkAo4gCX4XdfO066Bk2seEuT6ES2teBUUImZL0TCOkM
         CCjCKrPs+6ag/e1+SsvLBP4QWFQzV1m1oPqxejcmmnuqSJnCF2SvXGT4RvlVwJKERI0J
         QDccghTXX8votT4+qNR37yLaZA1CUYfbN/wtega9iLC6VoNqjeeqDlACc1c2VtvZDr8o
         UwU8/3T3I/jJZpkr89OG6LuuDEjTwUJz6d0XAJHY26o730T3pXXwG0Tr3vcTxoG1cQ5E
         RYG/DMPYGtzBMnmzx0fc5Za1IS+Ov/HCH5GC95DKtqn012sDg91s8MTObDRzHOFka9uA
         efRg==
X-Gm-Message-State: AOJu0YwWGE0jHJGcnFkjEuiEuTO1dLV5Sug0ljt95dWrkAK3rKqr6Nya
        97P1mo0gPZCi7gkTLzdLkJZcoAi3TxE=
X-Google-Smtp-Source: AGHT+IEj4bAb8dK2BzVGD39zdLbuAwlui3krRgA4EDUmXaajvJ7+6XJkqRDRYH7+AfAiD2c5ji90qocVmGw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3c43:0:b0:5ad:e23f:3e18 with SMTP id
 i3-20020a633c43000000b005ade23f3e18mr65252pgn.10.1698439780372; Fri, 27 Oct
 2023 13:49:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 13:49:26 -0700
In-Reply-To: <20231027204933.3651381-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027204933.3651381-3-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Documentation updates for 6.7
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Doc updates for 6.7.  The bulk is a cleanup of the kvm_mmu_page docs, which are
sadly already stale because I neglected to update the docs when removing the
TDP MMU's async root zapping :-(

The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6d3:

  Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux into HEAD (2023-09-23 05:35:55 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-docs-6.7

for you to fetch changes up to b35babd3abea081de0611ce0d5b85281c18c52c7:

  KVM: x86/pmu: Add documentation for fixed ctr on PMU filter (2023-09-27 14:23:51 -0700)

----------------------------------------------------------------
KVM x86 Documentation updates for 6.7:

 - Fix various typos, notably a confusing reference to the non-existent
   "struct kvm_vcpu_event" (the actual structure is kvm_vcpu_events, plural).

 - Update x86's kvm_mmu_page documentation to bring it closer to the code
   (this raced with the removal of async zapping and so the documentation is
   already stale; my bad).

 - Document the behavior of x86 PMU filters on fixed counters.

----------------------------------------------------------------
Jinrong Liang (1):
      KVM: x86/pmu: Add documentation for fixed ctr on PMU filter

Michal Luczaj (1):
      KVM: Correct kvm_vcpu_event(s) typo in KVM API documentation

Mingwei Zhang (6):
      KVM: Documentation: Add the missing description for guest_mode in kvm_mmu_page_role
      KVM: Documentation: Update the field name gfns and its description in kvm_mmu_page
      KVM: Documentation: Add the missing description for ptep in kvm_mmu_page
      KVM: Documentation: Add the missing description for tdp_mmu_root_count into kvm_mmu_page
      KVM: Documentation: Add the missing description for mmu_valid_gen into kvm_mmu_page
      KVM: Documentation: Add the missing description for tdp_mmu_page into kvm_mmu_page

 Documentation/virt/kvm/api.rst     | 36 +++++++++++++++++++++++--------
 Documentation/virt/kvm/x86/mmu.rst | 43 ++++++++++++++++++++++++++++++--------
 2 files changed, 61 insertions(+), 18 deletions(-)
