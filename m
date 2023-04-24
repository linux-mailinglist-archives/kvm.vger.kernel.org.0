Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E7E6ED395
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjDXRfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjDXRfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:35:36 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3287D89
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:35 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-51f10b8b27dso2864940a12.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682357735; x=1684949735;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M7itdtr9KAKg/Dp8bZQ5zB+4ZLhAmVuBRHE2wM175kU=;
        b=oF2j7Ebpi4Wj9eQRHbbXahA7TaaYISMgGv0DAbeFRXnKiYhAjvolwhClivD4h0KaEq
         60S49IDk45L7OnQ4tjZ66UZP1NGk0Bt9JMXW5gfmCZsTduSIzLTCgLpbWlhP0lrCmDIY
         9rXaHnFpWW++avg9Za8pJpTajPHuZV3YotiEPSdD++GuGPSfooPq3NHKyo3HiN+v7aNr
         ZD+Z3GesDOkhv87YmwdjFX2+Af/xRRnzBhXMLJzoyjXdQ5QlEr64mTst4tAB+mbFyphV
         vqopzu6+K0JAtFquvtx8HrgW2sY15JbEfqmh7oPJ1kHszPa8RgZDUUJlcY8lzZIRytLS
         4EaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682357735; x=1684949735;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M7itdtr9KAKg/Dp8bZQ5zB+4ZLhAmVuBRHE2wM175kU=;
        b=fwCEmG9jFn3wMcHWquYR8SgP6UTPOwYOJwWCYt2Y2A+9rde8p3PEKTX4eUjc8VCu5G
         nqPWOAc97dp/yAHwjLVCltiIKfwWQXEf5TY8uihhFbT8WF5qhoCLaMIAPjJrJByOVfcQ
         0J2MlFFH2TR515tBNpzbKJDjl5K4ZkS64Yolg5K/KXJt8770Ly8ZC0E2i4RA9rBPaqQG
         HNir/CGFJKutB46VVl15xUzKy88o1tIORsbwr3GU1Zc9P4c3ipIyob2TnJ3r60o7fcOi
         8yW77E3wWS/BhHAU946NynQZXZ0xuSg9mJwCbJWjpIreGLZIVSI+VeNvCVtkLfdoprfA
         qfew==
X-Gm-Message-State: AAQBX9e8NjFlZak8F1RJHTWMxmMpsUUGpScMewwR4CAod01+QfcRZZCo
        HgGbmYx0hIMEbX5W02HuJX2fS/Z/MOE=
X-Google-Smtp-Source: AKy350Z28iU4eKAM8KLGUwjx+bLyvg+xIHJOoTsMuixIsDIhfySjPrlj3WRb7hTpldtdmKjYYFgV3SzJsrA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:451e:0:b0:51b:8838:48b8 with SMTP id
 s30-20020a63451e000000b0051b883848b8mr3336591pga.0.1682357735222; Mon, 24 Apr
 2023 10:35:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 24 Apr 2023 10:35:23 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424173529.2648601-1-seanjc@google.com>
Subject: [GIT PULL] KVM: Non-x86 changes for 6.4
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Non-x86, a.k.a. generic, KVM changes for 6.4.  Nothing particularly
interesting, just a random smattering of one-off patches.

The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7:

  KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:18:07 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.4

for you to fetch changes up to b0d237087c674c43df76c1a0bc2737592f3038f4:

  KVM: Fix comments that refer to the non-existent install_new_memslots() (2023-03-24 08:20:17 -0700)

----------------------------------------------------------------
Common KVM changes for 6.4:

 - Drop unnecessary casts from "void *" throughout kvm_main.c

 - Tweak the layout of "struct kvm_mmu_memory_cache" to shrink the struct
   size by 8 bytes on 64-bit kernels by utilizing a padding hole

 - Fix a documentation format goof that was introduced when the KVM docs
   were converted to ReST

 - Constify MIPS's internal callbacks (a leftover from the hardware enabling
   rework that landed in 6.3)

----------------------------------------------------------------
Jun Miao (1):
      KVM: Fix comments that refer to the non-existent install_new_memslots()

Li kunyu (1):
      kvm: kvm_main: Remove unnecessary (void*) conversions

Mathias Krause (1):
      KVM: Shrink struct kvm_mmu_memory_cache

Sean Christopherson (1):
      KVM: MIPS: Make kvm_mips_callbacks const

Shaoqin Huang (1):
      KVM: Add the missed title format

 Documentation/virt/kvm/api.rst     |  1 +
 Documentation/virt/kvm/locking.rst |  2 +-
 arch/mips/include/asm/kvm_host.h   |  2 +-
 arch/mips/kvm/vz.c                 |  2 +-
 include/linux/kvm_host.h           |  4 ++--
 include/linux/kvm_types.h          |  2 +-
 virt/kvm/kvm_main.c                | 26 ++++++++++++--------------
 7 files changed, 19 insertions(+), 20 deletions(-)
