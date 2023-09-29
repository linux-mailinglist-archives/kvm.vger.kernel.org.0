Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179627B3CD7
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 01:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbjI2XCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 19:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjI2XCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 19:02:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF0FE5
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 16:02:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d81c02bf2beso21584444276.2
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 16:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696028571; x=1696633371; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=l+fkj5o8NdAMoFJOi2KLH7y3vot4itlHCFiGIMD59jA=;
        b=uua0IWpSql/yzLfrG4oq6xTH70/LZTaoVGJSdG71mweB4j8sWvYduMSmDsgSGn3VRt
         kFY8CbrshSXRP9lioiMW5pQgE+SpMLMnIHXVeitnS7U4HhfWybEQgUd1WpocTYTs0XFx
         69oU/oVELWB2s835bpmPAWdbxpoacwGHmimlY5261rq0QpOiMRwErZ6JJp1A6fZFNoZp
         LxpniqFy65+YEVYIij+lglC7pCWCIKXBgDeQCWU0FstxUsGdvjZvk0KxMjtiB7NsyJZx
         KnR7wT+VELaHasjdNbpHkcHnsVDzh+cUC1F9heOHRuYvbSAGIgx0+SFUQijWI2LM2A4U
         ntpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696028571; x=1696633371;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l+fkj5o8NdAMoFJOi2KLH7y3vot4itlHCFiGIMD59jA=;
        b=P0+MnuhdoZSq3k4n12nJjUnKV1R9FjyFuCgeAWI7VSTzPH2gJ/T7Jr+HRr49Z5Ya/f
         h8W7ZKiBRBgrLUJdc1W4Qg4sPMyIS29/EO4dO8S+CoTUn9DMnTVkNfTD0sJuWvu3I/KH
         O9zsHHN6rBDmfrPL81sE2MNXcUHlY7TGppLVeoCsK7To9dqJdsZhQMhHaNUTlv5kihrp
         iz4VLJjHM5RcyeudCI7OPCIXnM9/h+faMBbYELbAtzayVPljxrNd+riIWBBdz+EiwR1M
         QPQDdX6wiRQ67K6VjOsr4w/HHrNlHvhiYmA1NOB6yGpUfU0lu+j8MamgDnN2Q+N3yoxj
         ZdLA==
X-Gm-Message-State: AOJu0YzOPJBsmplluYnPw8A03zldLm0kkVsyQ3DdGKcT3301BJSvUs+d
        zg/8ZL+ZcZ7U/F3aCeUe7xAnPVZggoHrhrwRXnowW8HQXOVqdlqq5b6WkJu70jqfIWQ703Fpit0
        1pUavZU2RDK4iyd7afA33nD/YGg5QI2hkZWFL3zAPJzRKL1DVb0shG0gaYS7q5TY=
X-Google-Smtp-Source: AGHT+IGtGogDpHxVc73qFrG5fYQVvjIjKGTfPfR7W+a1hT8Cvv2Zdiql72qFZi5Lm5a8OP1j4dFiZsaS5ij2Dg==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:6902:136b:b0:d81:4107:7a1 with SMTP
 id bt11-20020a056902136b00b00d81410707a1mr85877ybb.2.1696028571352; Fri, 29
 Sep 2023 16:02:51 -0700 (PDT)
Date:   Fri, 29 Sep 2023 16:02:43 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230929230246.1954854-1-jmattson@google.com>
Subject: [PATCH v4 0/3] KVM: x86: Update HWCR virtualization
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, "'Sean Christopherson '" <seanjc@google.com>,
        "'Paolo Bonzini '" <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>
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

Allow HWCR.McStatusWrEn to be cleared once set, and allow
HWCR.TscFreqSel to be set as well.

v1 -> v2: KVM no longer sets HWCR.TscFreqSel
          HWCR.TscFreqSel can be cleared from userspace
          Selftest modified accordingly
v2 -> v3: kvm_set_msr_common() changes simplified
v3 -> v4: kvm_set_msr_common() changes further simplified
          HWCR.TscFreqSel can be modified from the guest
	  Targets reordered in selftest Makefile

Jim Mattson (3):
  KVM: x86: Allow HWCR.McStatusWrEn to be cleared once set
  KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
  KVM: selftests: Test behavior of HWCR

 arch/x86/kvm/x86.c                            | 11 ++--
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/hwcr_msr_test.c      | 52 +++++++++++++++++++
 3 files changed, 60 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c

-- 
2.42.0.582.g8ccd20d70d-goog

