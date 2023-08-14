Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC1577B7C7
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 13:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjHNLv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 07:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjHNLvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 07:51:24 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12411EA;
        Mon, 14 Aug 2023 04:51:24 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-3a76cbd4bbfso4076550b6e.3;
        Mon, 14 Aug 2023 04:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013883; x=1692618683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v2vJq0VX4ItkqoKSCpNwc42J1U8uTSXSOUgRoMRwKmk=;
        b=CMCvbdHzjLDaE3gR3GCdb41fed1pC3kjgfQ7tXnqEEdhuhy5Jdf4Wa5DqEXIIB+bnG
         kXxUaFAquxx0kwerGQBdV5bAIFdrAPbjE5hS7ig8aK/FwuBO87fLP6qR7V79+1LRnHNJ
         +Xi0jgiYiMPtzxXuy5MsuSUVU57PRqZ85SVtCk2DA3cgViDAyWEQi9kIXuEta0DuNmqm
         t3nw2oPL9/hFf1t5HkYpnL8bwMNX2gEvkpgw94mttk1sLgS19ngkxxlMp21cLRFl5pmV
         hl+g4c3Vq6z21I8gNwfayKkXclqyArXP2qveiRkFvBvj2jV0PCtrXV2kuwhM+CCh5jfH
         qvfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013883; x=1692618683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v2vJq0VX4ItkqoKSCpNwc42J1U8uTSXSOUgRoMRwKmk=;
        b=ZC8pW/yj6UdtX6+yreU49HcYGwW7/7QjqfWHXdPTpOI0mdga6O+JcD9DrwihIfgIk9
         TKZ4rwhgtkZWJiaR75MsAimSS6Q84QVJT5UfVlE9O2wSnatzWYTAOtCbwX9xFv+Da5Er
         EjtIWO9okHmrSB7sdZtSAmripKWS/zSeJjCaTZQrdZA7bvdlHPr9j+Q+ppVcu/x4gz3C
         +4sfOto0+2J0iCUxhQ9+F1yNaDM5jw0FWiZ7D2dAWwl15Q0HmemN+q1NxgKolF73nTeH
         Wd0a1S0Nskoi86AMlhSlpYpOwEdGJelmVcS5HzZVW3GwOq3xBgW4n1NdqKP0GKD6bXPL
         Mdpw==
X-Gm-Message-State: AOJu0YzWmvBj+U8CIUsM682wwikTcipi37SxhySz6WK3yK3W+JfpvpHC
        Vq8m7R1pEXx0L5GnGB5BBPGuuh6ulmYTtQY4
X-Google-Smtp-Source: AGHT+IFnROxzVwMLul2ed951S7ei1LCDO4Zzv4Y7hhx8oC/xp6fKuKZUBBlwZ/q9z1NefGEjmYGJ7A==
X-Received: by 2002:a05:6808:b27:b0:3a7:540f:ca71 with SMTP id t7-20020a0568080b2700b003a7540fca71mr9995520oij.53.1692013883151;
        Mon, 14 Aug 2023 04:51:23 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x7-20020a63b207000000b0055386b1415dsm8407848pge.51.2023.08.14.04.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 04:51:22 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/11] KVM: selftests: Test the consistency of the PMU's CPUID and its features
Date:   Mon, 14 Aug 2023 19:50:57 +0800
Message-Id: <20230814115108.45741-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The KVM selftests show advantages over KUT in terms of finding defects through
flexible and varied guest settings from the KVM user space.

This patchset tests whether the Intel vPMU works properly with different Intel
CPUID.0xA configurations. It also provides test scaffolding and a sufficient
number of PMU test cases to subsequently offer adequate code coverage of AMD
vPMU or Intel complex features, such as LBR or PEBS, in selftests.

All patches have been tested on both Intel and AMD machines, with one exception
patch 11 "KVM: selftests: Test AMD Guest PerfMonV2" has not been tested on my
AMD machine, as does not support PerfMonV2.

Any feedback or suggestions are greatly appreciated.

Sincerely,
Jinrong Liang

Please note that following patch should be applied before this patch series:

https://lore.kernel.org/kvm/20230810090945.16053-2-cloudliang@tencent.com/

Changelog:

v3:
- Rebased to 74c2185c5b74(tag: kvm-x86-next-2023.08.02)  
- Add a new patch to test AMD PMU legacy four performance counters.
- Add a new patch to test AMD Guest PerfMonV2.
- Refactor code to simplify logic and improve readability.
- Use TEST_ASSERT_EQ() instead of ASSERT_EQ() when checking return values.
- Add vcpu_set_cpuid_property() helper for setting properties. (Sean)
- Add arch_event_is_supported() helper to check if an event is supported. (Sean)
- Add fixed_counter_is_supported() helper to check if a fixed counter is supported. (Sean)
- Drop macros that hides important details. (Sean)
- Use enumerations to avoid performance events magic numbers. (Sean)
- TEST_FAIL() instead of TEST_ASSERT() in run_vcpu() wrapper. (Sean)
- Update variable names for better readability and consistency. (Sean)
- Rename functions to better reflect their purpose. (Sean)
- Improve comments for better clarity and understanding of the code. (Sean, Jim)

v2:
https://lore.kernel.org/kvm/20230530134248.23998-1-cloudliang@tencent.com/T/

Jinrong Liang (11):
  KVM: selftests: Add vcpu_set_cpuid_property() to set properties
  KVM: selftests: Add pmu.h for PMU events and common masks
  KVM: selftests: Test Intel PMU architectural events on gp counters
  KVM: selftests: Test Intel PMU architectural events on fixed counters
  KVM: selftests: Test consistency of CPUID with num of gp counters
  KVM: selftests: Test consistency of CPUID with num of fixed counters
  KVM: selftests: Test Intel supported fixed counters bit mask
  KVM: selftests: Test consistency of PMU MSRs with Intel PMU version
  KVM: selftests: Add x86 feature and properties for AMD PMU in
    processor.h
  KVM: selftests: Test AMD PMU events on legacy four performance
    counters
  KVM: selftests: Test AMD Guest PerfMonV2

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/pmu.h        | 124 +++++
 .../selftests/kvm/include/x86_64/processor.h  |  11 +
 .../selftests/kvm/lib/x86_64/processor.c      |  14 +
 .../kvm/x86_64/pmu_basic_functionality_test.c | 505 ++++++++++++++++++
 5 files changed, 655 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/pmu.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c


base-commit: 74c2185c5b74fd0ae91133ad5afe8684f6a02b91
prerequisite-patch-id: 8718ffb8c05e453db9aae9896787cb6650d3cd52
-- 
2.39.3

