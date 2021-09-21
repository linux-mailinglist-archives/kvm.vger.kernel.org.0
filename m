Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B3F412AE5
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238117AbhIUCCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbhIUB5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:45 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9ABCC0C7519
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 18:01:37 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id x12-20020a056602160c00b005d61208080cso6508099iow.6
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 18:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AZxEc7laRqt6V8YHSa5vqSWjCI5HaoGZ4mJ7JHaw6Zc=;
        b=cX0LKE7fT40auep7yCqW5ITglnAAxckVqperzelP1kE2yjjWPnEwOKa2XxUssnw8yb
         WD5SJDXKkO8FUuuGzW1uOKkRDqcvTsAf0pRjUIEyMSaO3PiAtbWd826EGXRErXepOoHo
         /BzV0MmpeIMvRdDXXut1PLDZGgdYSsrt0LyNTTO+KtcusiUMNC+HsAumskEYnWGBqWrx
         R6tCipSjUt2ryLtkwA75ZsQtFJ0+OnDzMix6S1OTtRaGx4PJlcT4PHKL2r0FO/DYxhTd
         a3A+qzPkmNr7rwm+uV6npNsmyuqgxgtxxfefDyTgeA+IsijrziHcTdB01h0QdarPcnNW
         qX2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=AZxEc7laRqt6V8YHSa5vqSWjCI5HaoGZ4mJ7JHaw6Zc=;
        b=P2Jp6JAeBZpqTczYaDxy8CKj6FaO9RicWly4haw7wNeU9ALO8rFgXGRd6IoEJGdHFr
         wGrn6hah4+PEhUDPbyPecKXhtZX//KBt5OtqqLqgVyRHa0xWCz4rJ+ka3A1jOerIjPot
         bM73yWHs6CK56bMx2xyQ7EAMPxA4BW1i1bAQmz3gvgQclZzk/KPCJh1IaC8JNx9LlraD
         StFRjJh0t6RE9zTwiuWEk5RoKUH510BvLaTj1t/f0j65P3fogv5IMs4ii9gxt3ioCIh5
         bdCwc4y1DFQnf6QkocXVMiml3d8Au51bCydpp9YSDcLDWPPtikEO/VNmKUzm9yrg1ENJ
         5yww==
X-Gm-Message-State: AOAM531VEmKxExJOitQtteAxlv70Hyx055jq3rWeqDs6eOFKZVBe2l3X
        ftTBrypET3thTveeko2WHuOKWWwk8Fx72Fbtp4RCb5VikpSxCp3yDxf5wyC663msfmi0rdU6QD4
        sRbCJRAXp7roN49XgYWLMQSqNr/3UHcZjAhHihgy3uo4I5ykgb33LA70SGQ==
X-Google-Smtp-Source: ABdhPJy+6CqPGc9baw+MQq8vlxCxkzBOaf9TIcRw3XWtgq5EF7mdn/4X+ydpnjNH9l2D2xO8RuWumIS+V/M=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:9082:: with SMTP id x2mr21487329jaf.44.1632186096964;
 Mon, 20 Sep 2021 18:01:36 -0700 (PDT)
Date:   Tue, 21 Sep 2021 01:01:18 +0000
Message-Id: <20210921010120.1256762-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH 0/2] selftests: KVM: Fix some compiler warnings
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Building KVM selftests for arm64 using clang throws a couple compiler
warnings. This series addresses the warnings found insofar that
selftests can be built quietly for arm64 with clang.

Series applies cleanly to 5.15-rc2.

Oliver Upton (2):
  selftests: KVM: Fix compiler warning in demand_paging_test
  selftests: KVM: Fix 'asm-operand-width' warnings in steal_time.c

 tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
 tools/testing/selftests/kvm/steal_time.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.33.0.464.g1972c5931b-goog

