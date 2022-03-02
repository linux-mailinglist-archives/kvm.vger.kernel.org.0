Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DC34CAEE9
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 20:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241985AbiCBTnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 14:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241941AbiCBTnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 14:43:11 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FE2625A
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 11:42:25 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id 3-20020a056e020ca300b002c2cf74037cso2018947ilg.6
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 11:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cX9WA5df082MaL6YQlObveNXhOQwwbEGGIC69Id9Gd8=;
        b=DeCwmX4IQwXit+I4vJycRK3mJTydJiAMZ5u/Epji9xY36tHN77sj0TZMuqTcgHp3gr
         QQArSuCtgV4Wmewc5HUQ5EmfrpPi3aFvtKtJ8oV53190c98VQKRRZUP6BwuNaLhuHyGB
         SPDBTvicndkXq6Hrfcj97oBaEfV/R2jFCURX2GujZc6+KuSSMl0UWz4h4Z6GobKaO3Dn
         24XBkZx9pPlLPBLCsKrOT1wZytLdqAaxKeyYKcDY3A8x7rznte9sM8NSWJAnl6khoyN+
         A3jEzjOTmtyov1x4JUBaO+2eQWfpO17V+1wYAoWPtJcRlQviT7iSuuZeTETXINMjK69e
         /cqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cX9WA5df082MaL6YQlObveNXhOQwwbEGGIC69Id9Gd8=;
        b=TpBkMVFYFEuCXlS00c1dbMKVXK8jyDduIsAqF7NcN5GgX2WD8KHGdAQCF1G1aNTk8Y
         8Qu3BLDGUtjHqjrD3n0vPK2wHMxiDll+kfbs3iS8VxghzUK9mBeLV035zQiYfufgwq5m
         OOQ57Do06x87BHab4X6pN2EX3fkbQV1Mdyci9Dmv8t8ispRo2lK7zLToKhW/o6SttEXv
         qhdX+rQfMzXHxRvIpeVt3tb4yabR3yW/6c035a9+6/pRZXVTTCSsjMsrcJZoGp4QtUu0
         aC5TBsHTRkzV1aARlLDyWQsIsKphFbxD+Q9N5fdmXY3qVl2jCBleeNa28kO/S/Rp59eB
         Ctbw==
X-Gm-Message-State: AOAM530Cl9NRQQl9wJv0wAkKSeZ09nfr7iEPy5JjRVQ4pCYzcvDEhEDb
        +WynP5Kdqq8KiJ4KYw6phMDN72g8h38=
X-Google-Smtp-Source: ABdhPJwvAURYuPUp4x9tRcIbgIK9XdrrzeX9a3e6SVZt4KQcoiT01lrx/qVGcIwMY+2QKiijsg/EXb087kA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1e0a:b0:2c3:fb26:e6c3 with SMTP id
 g10-20020a056e021e0a00b002c3fb26e6c3mr7257384ila.100.1646250144967; Wed, 02
 Mar 2022 11:42:24 -0800 (PST)
Date:   Wed,  2 Mar 2022 19:42:19 +0000
Message-Id: <20220302194221.1774513-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 0/2] KVM: arm: Drop documentation of 32-bit KVM
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM/ARM is no more. However, there are several places in the
documentation that reference 32-bit host support. Align the
documentation with the present state of KVM by removing all references
to the old KVM/ARM.

Note that AArch32 guests are still supported.

Applies cleanly to v5.17-rc6.

Oliver Upton (2):
  Documentation: KVM: Update documentation to indicate KVM is arm64-only
  Documentation: KVM: Move KVM/arm64 docs into aptly named directory

 Documentation/virt/kvm/api.rst                | 83 +++++++++----------
 Documentation/virt/kvm/arm/hyp-abi.rst        | 77 -----------------
 Documentation/virt/kvm/arm64/el2-abi.rst      | 75 +++++++++++++++++
 .../virt/kvm/{arm => arm64}/index.rst         |  8 +-
 .../virt/kvm/{arm => arm64}/psci.rst          |  0
 .../virt/kvm/{arm => arm64}/ptp_kvm.rst       |  4 +-
 .../virt/kvm/{arm => arm64}/pvtime.rst        |  0
 Documentation/virt/kvm/devices/vcpu.rst       |  4 +-
 Documentation/virt/kvm/index.rst              |  2 +-
 9 files changed, 125 insertions(+), 128 deletions(-)
 delete mode 100644 Documentation/virt/kvm/arm/hyp-abi.rst
 create mode 100644 Documentation/virt/kvm/arm64/el2-abi.rst
 rename Documentation/virt/kvm/{arm => arm64}/index.rst (76%)
 rename Documentation/virt/kvm/{arm => arm64}/psci.rst (100%)
 rename Documentation/virt/kvm/{arm => arm64}/ptp_kvm.rst (94%)
 rename Documentation/virt/kvm/{arm => arm64}/pvtime.rst (100%)

-- 
2.35.1.574.g5d30c73bfb-goog

