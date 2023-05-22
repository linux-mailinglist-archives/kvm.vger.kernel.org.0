Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593CC70CDAB
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 00:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbjEVWSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 18:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjEVWSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 18:18:40 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C179E
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:18:38 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d11e07868so3091770b3a.3
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684793918; x=1687385918;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dc4gy2OJK1GSTndBVdU+FFnqd/hG/qmsMHmmQ43RlTM=;
        b=AFHEVsY780/IwFzkk7gl9k4v8g6D9HZiZaUXfNElQY6niQTrix3aP1UzgnFTGQLVQv
         d9o7n9Ax6Vq+22Jz+ERm4gSA+r1RZx9E2UPvEoO8KtSzYXGXEQrkzPV7c8AeciYX/ARf
         oT60n0NsIPYyTtHZkhP3KTuecCnSkZE8uIlAsUhPZHGEBF5vKpODV/XuuC+iswFocfz2
         9PFpz1m4/in5yb6JmR7WSCdByCXyLXA+qN4c9IHKSWXZhkbGFGYc/MdcU8NYOZ8aA6uI
         Fzc+X5DPXUlecoWJUGLOD1QwCiIoF+ArbPEnKRshX1/bC2xW2ebcCHAiKvT1UE9YWZhX
         4lkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684793918; x=1687385918;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dc4gy2OJK1GSTndBVdU+FFnqd/hG/qmsMHmmQ43RlTM=;
        b=BH1b80sX+04Xbohih1Em3bQQlCX2zhaTMnTTEh2smEi8Hnjf1gf4HnFuVHbQ9/lPev
         3+ySjS1UArUWJO2BNdRC+l55fLKO/ydpONOm/6tni18LsQLjSeMe9STR0AguCz6N6zdR
         qy3grgUulAPXGNYDKINgXmsT9sj1vMQRxI/qWwTz98NbD3+uzqS7XzxUf/t05M0xiUVH
         TODl4ItOqtifL18T3DBFjkXXcsilvwSHGZ1dxlBEWsLfh8TBcR+wDYz5fj6eF8RzYAwr
         hg9b1tTtA7U2hDtuoVrGeUlpDQGlLevkF3uRJoq+SEbmPZkvgbu5k8pywNoXuesgvBgU
         SCxw==
X-Gm-Message-State: AC+VfDyzZ3U/EovzaJ4hRV1ig11VtVgS/Dz6VJlUOR7a+FBXPD86/so8
        DErm1Rp1/el9n9jtPq2+5XboMGMZEtZCBDn0WzRFCfYJzRR2Oi77Ih4Mk6CfxWLGDl85EHD23t4
        0r6Rt67abdyvRVUZ32PPV+m+Hq5xXvDKWiHE8sbAvLEnYTb0WNJqovSTlxtRUuWRzocpR46s=
X-Google-Smtp-Source: ACHHUZ6H5hIJqaC36GavRELQjAZAMqYhtwqAgC0dtBDJCIhgGHV1be0gt84M9UzPvMWCYsJMLWWczAhZCIVn8PqDrQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:15c7:b0:641:31b1:e787 with
 SMTP id o7-20020a056a0015c700b0064131b1e787mr5038528pfu.5.1684793918271; Mon,
 22 May 2023 15:18:38 -0700 (PDT)
Date:   Mon, 22 May 2023 22:18:30 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230522221835.957419-1-jingzhangos@google.com>
Subject: [PATCH v10 0/5] Support writable CPU ID registers from userspace
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

* v9 - v10
  - Rebased to v6.4-rc3
  - Addressed some review comments from v8/v9.

* v8 -> v9
  - Rebased to v6.4-rc2.
  - Don't create new file id_regs.c and don't move out id regs from
    sys_reg_descs array to reduce the changes.

* v7 -> v8
  - Move idregs table sanity check to kvm_sys_reg_table_init.
  - Only allow userspace writing before VM running.
  - No lock is hold for guest access to idregs.
  - Addressed some other comments from Reiji and Oliver.

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
[7] https://lore.kernel.org/all/20230424234704.2571444-1-jingzhangos@google.com
[8] https://lore.kernel.org/all/20230503171618.2020461-1-jingzhangos@google.com
[9] https://lore.kernel.org/all/20230517061015.1915934-1-jingzhangos@google.com

---

Jing Zhang (5):
  KVM: arm64: Save ID registers' sanitized value per guest
  KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
  KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
  KVM: arm64: Reuse fields of sys_reg_desc for idreg
  KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3

 arch/arm64/include/asm/cpufeature.h |   1 +
 arch/arm64/include/asm/kvm_host.h   |  34 +-
 arch/arm64/kernel/cpufeature.c      |   2 +-
 arch/arm64/kvm/arm.c                |  24 +-
 arch/arm64/kvm/sys_regs.c           | 469 +++++++++++++++++++++++-----
 arch/arm64/kvm/sys_regs.h           |  22 +-
 include/kvm/arm_pmu.h               |   5 +-
 7 files changed, 437 insertions(+), 120 deletions(-)


base-commit: 44c026a73be8038f03dbdeef028b642880cf1511
-- 
2.40.1.698.g37aff9b760-goog

