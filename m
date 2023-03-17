Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16FF6BE071
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 06:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjCQFGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 01:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjCQFGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 01:06:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D809E4A1E7
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 22:06:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z31-20020a25a122000000b00b38d2b9a2e9so4095019ybh.3
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 22:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679029604;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w+vwBZQ4cXLwZeDSUo6XQ4+Y+78q4qqtLXFPZEGCVUQ=;
        b=KbuTLGnltMuNZQ5sMF45pEMsyEzUo78gxBk3ywtddoj6JDGRKbN1BY4bYc/L3f6mop
         GhyXRFH8odKpFZUt4QSzS9Pvi3qdxPrJGzRNSxd6oU/8xS/l8M1nLMIQ+H8aQ93IDbwP
         6sDbk1IcwCF7YjzggNHpWhWx2oz4BqgKs0Lj+HuDpPXp/SZIXM56ZC5333kqgqkeV5xO
         ao/XPo4yUMYUIYz4yduWqAovQliIyw9uEmSxTxyYwGW3dz7ec5rcqXzQ2YUTBCJmx8Bw
         6qXKSICttfV2sihfU452YpIGJBwVO3uRGB76oGi1cwP/XgrRvBQ23zIRQOdYIUfT1Z9p
         EEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679029604;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w+vwBZQ4cXLwZeDSUo6XQ4+Y+78q4qqtLXFPZEGCVUQ=;
        b=MCJc2Q4vGdLpAJZDry2UXP+D0EkMfSJl44I75JPcW8DjRsDfl+BA3o/5muq4lIS2p+
         ek/pcGoqXX6d38bJtKJXPTH/3/TVpDXZhP8vzL31XxyPCfIoGCbu0a6DE17Mj6UxNsor
         /oOVQfPcXbBBpqIJmvovBBYH5mHOJpWS955aUNbRJkI3LplqFWWLB9TKfv4D7jXwySER
         j1ibWwvwhsB0nNEEyyOXmC9mUmYybsVhxUYO9JFwPvqBWE/GsTeivfj1AF9zO6dwEN2k
         niTqfT+mSaINgm3KmSRTRn7oTo40DuDL04bZK/WKLxQtGCteiLt+s4RUR588poO0O/z7
         gAyA==
X-Gm-Message-State: AO0yUKVHFVQNx6Ar9R3f3wBq1TvrNjcTOtRK+kNBKjVgd9BIcDhumSia
        /qw+c2+d+OPc8ewxVgpyrzj2qtfBKNp2cfA0pG03Y1JQ12GsgO8EPADkUFwOyynY0cjJg7dB2gr
        XTEluuob+lls5oz/1LhdaCrBQx3CQDttCwuAFBUei/5mthK9GBbRFg5VhcW3p6XBu+QphJ8A=
X-Google-Smtp-Source: AK7set/YoPAtT2ABNeHbY3weqdIX4biMtQPIuYq5sSnuILz3MjucdJN9sjsx84/fFa7D7o3kyaa2v5Fh19Y8IAjS4Q==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:aca8:0:b0:b26:884:c35e with SMTP
 id x40-20020a25aca8000000b00b260884c35emr1204754ybi.4.1679029603938; Thu, 16
 Mar 2023 22:06:43 -0700 (PDT)
Date:   Fri, 17 Mar 2023 05:06:31 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230317050637.766317-1-jingzhangos@google.com>
Subject: [PATCH v4 0/6] Support writable CPU ID registers from userspace
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
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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

---

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

---

Jing Zhang (5):
  KVM: arm64: Move CPU ID feature registers emulation into a separate
    file
  KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
  KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
  KVM: arm64: Introduce ID register specific descriptor
  KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3

Reiji Watanabe (1):
  KVM: arm64: Save ID registers' sanitized value per guest

 arch/arm64/include/asm/cpufeature.h |  25 +
 arch/arm64/include/asm/kvm_host.h   |  24 +-
 arch/arm64/kernel/cpufeature.c      |  26 +-
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/arm.c                |  24 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c  |   7 +-
 arch/arm64/kvm/id_regs.c            | 807 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 469 +---------------
 arch/arm64/kvm/sys_regs.h           |  43 ++
 include/kvm/arm_pmu.h               |   5 +-
 10 files changed, 930 insertions(+), 502 deletions(-)
 create mode 100644 arch/arm64/kvm/id_regs.c


base-commit: 96a4627dbbd48144a65af936b321701c70876026
-- 
2.40.0.rc1.284.g88254d51c5-goog

