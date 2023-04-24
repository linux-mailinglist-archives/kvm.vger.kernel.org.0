Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD8A6ED8EB
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 01:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjDXXrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 19:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjDXXrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 19:47:11 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAFB49F3
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 16:47:08 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63d30b08700so26372962b3a.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 16:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682380028; x=1684972028;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6Ot+Rlnm7hn0ij7rFbhHCvuqwiEfbByzG62dXdUvoFM=;
        b=C7G+CTI+zTaYdXEebMpoh3NA7eElM3eZcBitcG3FWy623s36A3AFCzEkoqO+5X70zG
         Hn4qOxvU+H8ktV/dvTpDC8F8e4kCT/kkmmvjUFwN43rBcc29BjM3raapLyCM+c47OcQZ
         ZKxas7fxqwOTLFnkvlKa1SBh2gqw9e4KWfQA9xRq56L8tvTXPELZOdaF/BzpbizVNSwW
         CiLoltdtJWNpdyrFK3XLwwAZA2hk4q3LFtd8/wrndrSyx9RwcHvmE25PlBCSCQS4Tjlz
         TRTA2nvnLqel0piqWvuxKJpkrXPz3JtdQegjNrmCuK08YwnFUP96Bv/HlJIr9767SsL9
         uETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682380028; x=1684972028;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Ot+Rlnm7hn0ij7rFbhHCvuqwiEfbByzG62dXdUvoFM=;
        b=E+XLTFyZXeGf1LKOmkg7S0y9tApMYf8WeKIB/L9yCFC04yHz+3BSjpjatIQc2WcNys
         cO4GI+QsOu8HmVkfJYEFbRKwwbTTtHJRxJDeHtfJeMKZDO8LyShwNd09FcGEil0h9Lus
         G2uevz9hjKDjZ3HR0NFb59fxWddXo+nRivsZW9TfE9xmdj/NlTr7NOxE7SUt7gvObxTS
         ar3reETD8TiLOvr99Gur1zgW1YDRQJXITjZmCMr426B4rQxvPswwp2nBqjv4EGXnFkKj
         W/h7ZNTpC0dzfcldaxNwxxF7pahuUpQ4ZeDQ2NTUbQECVfGFMVQoxBZUA0P8LIFQNs7a
         tgQA==
X-Gm-Message-State: AAQBX9c9LMfivHm2F5A1Vevd/CHaBpo7lPPBGTxPD0Gt3epnt+TujwaQ
        MV2oUtXnYl9/JW0DLMB04ik7cRfH/3s5VDOQfAHmMqO1zVKpfrpzoRwVXGAyRaRHgNQpaA745Wo
        cEvxyziI1DW+XiUhTx3kXNC5oJioJIa9Svkji+hNcNaE8z8NEnlBww42hEK7/7qCLarlia1Y=
X-Google-Smtp-Source: AKy350YA2bOuxPuU0rjoWOaZFXNoIaerjZaOX9j0+SAeMzgaYiYyYu3xvNxbQC5ZlX/uH0ik+Rf1lqGSKK19ZJ/R6g==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:3481:b0:246:ac5c:ba3f with
 SMTP id p1-20020a17090a348100b00246ac5cba3fmr3352874pjb.0.1682380028103; Mon,
 24 Apr 2023 16:47:08 -0700 (PDT)
Date:   Mon, 24 Apr 2023 23:46:58 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424234704.2571444-1-jingzhangos@google.com>
Subject: [PATCH v7 0/6] Support writable CPU ID registers from userspace
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
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

This patchset refactors/adds code to support writable per guest CPU ID feature
registers. Part of the code/ideas are from
https://lore.kernel.org/all/20220419065544.3616948-1-reijiw@google.com .
No functional change is intended in this patchset. With the new CPU ID feature
registers infrastructure, only writtings of ID_AA64PFR0_EL1.[CSV2|CSV3],
ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon are allowed as KVM does before.

Writable (Configurable) per guest CPU ID feature registers are useful for
creating/migrating guest on ARM CPUs with different kinds of features.

This patchset uses kvm->arch.config_lock from Oliver's lock inversion fixes at
https://lore.kernel.org/linux-arm-kernel/20230327164747.2466958-1-oliver.upton@linux.dev/

---

* v6 -> v7
  - Rebased to v6.3-rc7.
  - Add helpers for idregs read/write.
  - Guard all idregs reads/writes.
  - Add code to fix features' safe value type which is different for KVM than
    for the host.

* v5 -> v6
  - Rebased to v6.3-rc5.
  - Reuse struct sys_reg_desc's reset() callback and field val for KVM.
    sanitisation function and writable mask instead of creating a new data
    structure for idregs.
  - Use get_arm64_ftr_reg() instead of exposing idregs ftr_bits array.

* v4 -> v5
  - Rebased to 2fad20ae05cb (kvmarm/next)
    Merge branch kvm-arm64/selftest/misc-6,4 into kvmarm-master/next
  - Use kvm->arch.config_lock to guard update to multiple VM scope idregs
    to avoid lock inversion
  - Add back IDREG() macro for idregs access
  - Refactor struct id_reg_desc by using existing infrastructure.
  - Addressed many other comments from Marc.

* v3 -> v4
  - Remove IDREG() macro for ID reg access, use simple array access instead
  - Rename kvm_arm_read_id_reg_with_encoding() to kvm_arm_read_id_reg()
  - Save perfmon value in ID_DFR0_EL1 instead of pmuver
  - Update perfmon in ID_DFR0_EL1 and pmuver in ID_AA64DFR0_EL1 atomically
  - Remove kvm_vcpu_has_pmu() in macro kvm_pmu_is_3p5()
  - Improve ID register sanity checking in kvm_arm_check_idreg_table()

* v2 -> v3
  - Rebased to 96a4627dbbd4 (kvmarm/next)
    Merge tag ' https://github.com/oupton/linux tags/kvmarm-6.3' from into kvmarm-master/next
  - Add id registere emulation entry point function emulate_id_reg
  - Fix consistency for ID_AA64DFR0_EL1.PMUVer and ID_DFR0_EL1.PerfMon
  - Improve the checking for id register table by ensuring that every entry has
    the correct id register encoding.
  - Addressed other comments from Reiji and Marc.

* v1 -> v2
  - Rebase to 7121a2e1d107 (kvmarm/next) Merge branch kvm-arm64/nv-prefix into kvmarm/next
  - Address writing issue for PMUVer

[1] https://lore.kernel.org/all/20230201025048.205820-1-jingzhangos@google.com
[2] https://lore.kernel.org/all/20230212215830.2975485-1-jingzhangos@google.com
[3] https://lore.kernel.org/all/20230228062246.1222387-1-jingzhangos@google.com
[4] https://lore.kernel.org/all/20230317050637.766317-1-jingzhangos@google.com
[5] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[6] https://lore.kernel.org/all/20230404035344.4043856-1-jingzhangos@google.com

---

Jing Zhang (6):
  KVM: arm64: Move CPU ID feature registers emulation into a separate
    file
  KVM: arm64: Save ID registers' sanitized value per guest
  KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
  KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
  KVM: arm64: Reuse fields of sys_reg_desc for idreg
  KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3

 arch/arm64/include/asm/cpufeature.h |   1 +
 arch/arm64/include/asm/kvm_host.h   |  60 ++-
 arch/arm64/kernel/cpufeature.c      |   2 +-
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/arm.c                |  24 +-
 arch/arm64/kvm/id_regs.c            | 692 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 525 ++++-----------------
 arch/arm64/kvm/sys_regs.h           |  28 +-
 include/kvm/arm_pmu.h               |   5 +-
 9 files changed, 857 insertions(+), 482 deletions(-)
 create mode 100644 arch/arm64/kvm/id_regs.c


base-commit: 6a8f57ae2eb07ab39a6f0ccad60c760743051026
-- 
2.40.0.634.g4ca3ef3211-goog

