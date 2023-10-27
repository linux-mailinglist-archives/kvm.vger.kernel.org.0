Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C107DA200
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 22:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346603AbjJ0UuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 16:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbjJ0UuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 16:50:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2A210F3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:53 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9e6a4ff2fso21055025ad.1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698439790; x=1699044590; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EEVVIsdWWT2F4uMf1c4FvIiobmGg9JUhgceROHEWR+A=;
        b=KM//VnsNn9eRKvDQY5CbQMCsyot6SVvJBRSEFbCBEe3Ubg1X9gqXnF6n1n2SgLIzEj
         Q5l5ReWlTt3NvpdovcR9ZZ5UIXThZfSsA8EXafz31XVlD3zdAjcF7pJ9BQpJlvlikmrT
         3f5GuCPfxC70ejEcl4eZF85NsjzZkqn6GttHQpxVXFE13Ic9TNSZCxV7MsXJZ8ODxoiN
         yG22nYcIwafWSuy9KDvEQNjvqUNHmnH5NMbQty1FyP99BZ6ND4dCSWmIzqMWLXqejKPU
         Rx927EwVFuNGm3FpdOnshsPFyD5hEz00lwXuYqq8ECE2jq8eP8Yr6dTIEc/YdSNacEQa
         HE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698439790; x=1699044590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EEVVIsdWWT2F4uMf1c4FvIiobmGg9JUhgceROHEWR+A=;
        b=n/j0JfFRB98jlcSnFPONNuTJ4psGuJCF1C2Oe7kbJfd4knoLtO4rNXMYmnerqhOEWo
         sRCFutxEUIXIJPeL7fBmBm8YtuirNq4Oc3kEPhkxMT2lgPaVY4JzyzVryYNmbUqLFeHh
         o0s2NFqw5/Hcdw2SHNllzQieAbq4Y3bvzZL6vif65ILHQUssnqhGKrTc7JltEORkwjwP
         LZ5maM1VGnzKTsU5CVsS+cUANwzxSgyh+guY/PK764zVDkNSmKFoDMF/6YkOY8dkdyvQ
         8FljXzWcwEStTM/YrI0RyHbM+UmtMbeXCqyJIo3IvFvHU08WOpQXEkcJAJLfV8dHCLZL
         p0rw==
X-Gm-Message-State: AOJu0Yyz+CcilvrVudmTa7RAJoJAPVoCM23y9sPP2+pSKQQQ7WPgPeXp
        Np3DIazIO1JtRFMNuHA2p/ZdNmr6i9g=
X-Google-Smtp-Source: AGHT+IG04UfCML503rxDdENeI/UsmLklRO2aHvHgYtsD0qYmJgbWaUdx3sIsou8BPaqxlbnXBD9t5lxONX0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a411:b0:1c9:c879:ee82 with SMTP id
 p17-20020a170902a41100b001c9c879ee82mr61492plq.11.1698439790722; Fri, 27 Oct
 2023 13:49:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 13:49:31 -0700
In-Reply-To: <20231027204933.3651381-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027204933.3651381-8-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Xen changes for 6.7
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

Read the tag, I couldn't figure out how to summarize this one without simply
regurgitating the tag :-)

The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6d3:

  Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux into HEAD (2023-09-23 05:35:55 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-xen-6.7

for you to fetch changes up to 409f2e92a27a210fc768c5569851b4a419e6a232:

  KVM: x86/xen: ignore the VCPU_SSHOTTMR_future flag (2023-10-04 15:22:58 -0700)

----------------------------------------------------------------
KVM x86 Xen changes for 6.7:

 - Omit "struct kvm_vcpu_xen" entirely when CONFIG_KVM_XEN=n.

 - Use the fast path directly from the timer callback when delivering Xen timer
   events.  Avoid the problematic races with using the fast path by ensuring
   the hrtimer isn't running when (re)starting the timer or saving the timer
   information (for userspace).

 - Follow the lead of upstream Xen and ignore the VCPU_SSHOTTMR_future flag.

----------------------------------------------------------------
David Woodhouse (1):
      KVM: x86/xen: Use fast path for Xen timer delivery

Paul Durrant (1):
      KVM: x86/xen: ignore the VCPU_SSHOTTMR_future flag

Peng Hao (1):
      KVM: X86: Reduce size of kvm_vcpu_arch structure when CONFIG_KVM_XEN=n

 arch/x86/include/asm/kvm_host.h |  5 +++-
 arch/x86/kvm/cpuid.c            |  2 ++
 arch/x86/kvm/x86.c              |  2 ++
 arch/x86/kvm/xen.c              | 55 +++++++++++++++++++++++++++++++++++++----
 4 files changed, 58 insertions(+), 6 deletions(-)
