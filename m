Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E51C228E95
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 05:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731859AbgGVD0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 23:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731781AbgGVD0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 23:26:42 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A306C061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 20:26:42 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id k4so624376pjs.1
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 20:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8f11LQRDquKuMiFPe6+BACiHYk45SezXe4Dzf/I8q6U=;
        b=gIDdgnMNs+VR8E9uNl+dWnQ7GbI+ZPDxpHzPKyL3a4qix4mzg7BHKCRv7H67pIcP3v
         a4PjDqgyOyrKyTsGttc0+4U4jP0GwEyiYrlveCbVBqzobMKZsxJNmKFm97zMfZ7imeeP
         RwXvHvKrVOFPvy2DL8EU5TjDc9tV84A9k5e9ZvmamA6zQgneKJxl8T8Or7DGql2WFobQ
         YRXzO9kJY1n/CZKSCwUGoHsMwVYiZvZuGEXMfE6/xM4vuBsv/IQ2snvKfLeBGjhQm3Dh
         ui8rRPR3PoV2uZPTdENg5euw925+D8NFROfPAQDDfgluCs8EL4EfqtergPak3Tqz+iAD
         KLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8f11LQRDquKuMiFPe6+BACiHYk45SezXe4Dzf/I8q6U=;
        b=og8ZGtcg5sGa1055Pb62WPu3u7TH/YfWsQmhpngu752Mhu6gwdAExaJXunozijNS7W
         B8WYeOzhUbooN6JdJj2dSDfMSEV73jN/ce4P158EaL4Y5s2NRzSjkenx+5EFIf89cX50
         wAdVnswlpzJCjbUppm+txhf090lfT1oU+FJz9zHRANVgLrAeg4MEvZfI2u/4WhNgLPKT
         J7FBxaRKcr/4qHc0hs1r7Nu2jJPSGL3WP4tkBF6pM1wMschU+L9pIEkzghkMhpv4CF+r
         DIQprgzB/Xa9on60z6bo1gG10BF4A/XW7PmKu+t8uXrMlnQcvR1QspHTyAwGJmFank+Y
         15dA==
X-Gm-Message-State: AOAM531Dw8LGuCXJQFMryMAF1O25NC2nZlSU7aKoBk7rOIGXquPZye8g
        Bvsl7cWfeSC2R3Ztpz61bRhTec1Ny47oCjZVOeI2zMF3RuMXPRWN+mebRczxX3H5oppsGv2H9yW
        KnUte/JffTp0/8Q8WswktZcztOgpA85JXRVqa2OWNBxLdUgDkRUEi5/4dmQ==
X-Google-Smtp-Source: ABdhPJw1U8f7yFISRUxehIDZqzFSsmWJlKf3RnZkQvTgcdTETzW6neSxCOCxc1E5WAOTiOtx3x/wA15iu/4=
X-Received: by 2002:a62:52cd:: with SMTP id g196mr26998369pfb.178.1595388401915;
 Tue, 21 Jul 2020 20:26:41 -0700 (PDT)
Date:   Wed, 22 Jul 2020 03:26:24 +0000
Message-Id: <20200722032629.3687068-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v3 0/5] KVM_{GET,SET}_TSC_OFFSET ioctls
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To date, VMMs have typically restored the guest's TSCs by value using
the KVM_SET_MSRS ioctl for each vCPU. However, restoring the TSCs by
value introduces some challenges with synchronization as the TSCs
continue to tick throughout the restoration process. As such, KVM has
some heuristics around TSC writes to infer whether or not the guest or
host is attempting to synchronize the TSCs.

Instead of guessing at the intentions of a VMM, it'd be better to
provide an interface that allows for explicit synchronization of the
guest's TSCs. To that end, this series introduces the
KVM_{GET,SET}_TSC_OFFSET ioctls, yielding control of the TSC offset to
userspace.

v2 => v3:
 - Mark kvm_write_tsc_offset() as static (whoops)

v1 => v2:
 - Added clarification to the documentation of KVM_SET_TSC_OFFSET to
   indicate that it can be used instead of an IA32_TSC MSR restore
   through KVM_SET_MSRS
 - Fixed KVM_SET_TSC_OFFSET to participate in the existing TSC
   synchronization heuristics, thereby enabling the KVM masterclock when
   all vCPUs are in phase.

Oliver Upton (4):
  kvm: x86: refactor masterclock sync heuristics out of kvm_write_tsc
  kvm: vmx: check tsc offsetting with nested_cpu_has()
  selftests: kvm: use a helper function for reading cpuid
  selftests: kvm: introduce tsc_offset_test

Peter Hornyack (1):
  kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls

 Documentation/virt/kvm/api.rst                |  31 ++
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/vmx/vmx.c                        |   2 +-
 arch/x86/kvm/x86.c                            | 147 ++++---
 include/uapi/linux/kvm.h                      |   5 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/test_util.h |   3 +
 .../selftests/kvm/include/x86_64/processor.h  |  15 +
 .../selftests/kvm/include/x86_64/svm_util.h   |  10 +-
 .../selftests/kvm/include/x86_64/vmx.h        |   9 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  11 +
 .../selftests/kvm/x86_64/tsc_offset_test.c    | 362 ++++++++++++++++++
 14 files changed, 550 insertions(+), 49 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_offset_test.c

-- 
2.28.0.rc0.142.g3c755180ce-goog

