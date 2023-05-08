Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4346FB41C
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbjEHPqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbjEHPq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:46:27 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99918A7F
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:46:10 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-50bc37e1525so9159141a12.1
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560769; x=1686152769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jUVLsDDlPYa2SU2dN9bpO2osVx95VzZWFNjjVgRl+Ho=;
        b=Xx9+9aGlG6Phcw+wOhGgrcbji75Gu8kEfqvipzaYCuhoDqgsJJXbRB/yv31w/OKadU
         KEXP9kIEYtTIyP4G8Mzgc1TegMWx4G4VjHmm5yJo4Pnfq8ui5T+M1TGE9QiRFk0ZfAvz
         RQhj8O5y1YRPY/nZVY8TPkhbJjYQFzKRfWJHQ0YlUTpDHW0z1EW7Jdcdiq/1aThZVv4v
         NY8/7ARjc1bQb+FBeo1+DtEGg4J3kLQO+1xpAJnvnlpaFcB4LooIIl4g5PsdzmjPMbda
         fEoaYsxXwMFfa0D4XehxYFBB1xPHsNexoLOC96WWeW8MyZMhyO/QCpeoqbHipigPeJJ1
         wLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560769; x=1686152769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUVLsDDlPYa2SU2dN9bpO2osVx95VzZWFNjjVgRl+Ho=;
        b=jn7qodNnBC+a2frZsdcP4+uCAnz4yX04qRiUuG1AQmMw9AdOHEeIhMOmuqjG0SEMHp
         RKzFhCiOtBz6AY87VY6iTYvwRsfVWYU6OnCporpazqdvm+nN4RtJRT8Pl0RedQpp/Dtp
         s/+tSppj9NHGh4xzR29QxQYi97T0kiKA9BvBzvR1NQbUlwD8PMUfWaOVnrU22o4ZgwsD
         AFtdHmNPa+eOkB34EgBTeCW7NPcx8Bfi15MxqLU2ybd5uEIwE/uQ73oKhIHxBKXFGg5l
         rioS57NiFgV6pmlJ+WDr3wYdz/rpLJKQ17zrQwvzAoB8ldwkJb1jug2nZifnQOP8IyVd
         UzeQ==
X-Gm-Message-State: AC+VfDycf/bJpHIgBujGMypL29kyH797i1EolBfsVJ41dcr0bNRa3+0D
        pPuT6vynAesOklYwirQMo/UBLA==
X-Google-Smtp-Source: ACHHUZ4QqtDy1SXwC081R/kAxp4+8CoP+HK/lfWQvGHcJmHus5f6z/qpLZXAhvJoz3Q7VtGRQpenhg==
X-Received: by 2002:aa7:d5ce:0:b0:50b:cf07:ad0 with SMTP id d14-20020aa7d5ce000000b0050bcf070ad0mr7313945eds.37.1683560769282;
        Mon, 08 May 2023 08:46:09 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id j19-20020aa7ca53000000b0050bc27a4967sm6213551edt.21.2023.05.08.08.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:46:08 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.1 0/5] KVM CR0.WP series backport
Date:   Mon,  8 May 2023 17:45:57 +0200
Message-Id: <20230508154602.30008-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a backport of the CR0.WP KVM series[1] to Linux v6.1, pretty
much the same as for v6.2.

I used 'ssdd 10 50000' from rt-tests[2] as a micro-benchmark, running on
a grsecurity L1 VM. Below table shows the results (runtime in seconds,
lower is better):

                        legacy     TDP    shadow
    Linux v6.1.23        7.65s    8.23s    68.7s
    + patches            3.36s    3.36s    69.1s

The KVM unit test suite showed no regressions.

Please consider applying.

Thanks,
Mathias

[1] https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/
[2] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git


Mathias Krause (3):
  KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP
    enabled
  KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
  KVM: VMX: Make CR0.WP a guest owned bit

Paolo Bonzini (1):
  KVM: x86/mmu: Avoid indirect call for get_cr3

Sean Christopherson (1):
  KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission
    faults

 arch/x86/kvm/kvm_cache_regs.h  |  2 +-
 arch/x86/kvm/mmu.h             | 26 ++++++++++++++++++-
 arch/x86/kvm/mmu/mmu.c         | 46 ++++++++++++++++++++++++++--------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/pmu.c             |  4 +--
 arch/x86/kvm/vmx/nested.c      |  4 +--
 arch/x86/kvm/vmx/vmx.c         |  6 ++---
 arch/x86/kvm/vmx/vmx.h         | 18 +++++++++++++
 arch/x86/kvm/x86.c             | 12 +++++++++
 9 files changed, 99 insertions(+), 21 deletions(-)

-- 
2.39.2

