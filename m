Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6757567EB
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 17:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjGQP2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 11:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjGQP1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 11:27:54 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817B81996
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:27:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c0d62f4487cso4079175276.0
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689607645; x=1692199645;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z+GoOgxgwqzG8TiJ0AXDkgFfXlL5tU7wLHV5OMoSBQw=;
        b=ADYRa1t6AtRHEcHbwJ6vPTV4QHdiGXiNBh2VvuC3GHyRATt9vkXRfOf9C1xqttp9k/
         B7wG81ICFtphg1VJqQ4BOrXJtT+ufIiCu3GFlIIs2RG4Aa8Hu1aM2KitlSnm+dN13gO4
         ZuaQVX1OHoc3o+hx3YfYg6ledLUZQumssa91UJia1zw5LhoPW/lDGcCsGmHl4gs1OrL6
         t0kqxpPh+LPkSmmesDSw/8G97Y2BUlYBAtIdD8WRcxUTdwZ6ol/rYRAJHal/lnmE08l2
         91v4s3ZBNfoI2PBp0Mx97QVRH8+tUNFdoZKhH+liRDwHoCGjEYb1JL8uRXaydFBxBipb
         NU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607645; x=1692199645;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z+GoOgxgwqzG8TiJ0AXDkgFfXlL5tU7wLHV5OMoSBQw=;
        b=AXXk9r4RwTl9mbohMe6NQhlZDDkQd3EOKj+Q7jc0ziA0vMMf7Pwr3TUiUW2hA8gNhe
         KGq4TaZo3XWnSOs2UxOLchgJiWXqqTdZImFyvjiHS/Bid7HeOjNXlb1mgNlko6tzZdxg
         ulVugev31oUocXDyEtX9rAqBrL7VwBLObaVjMR5zZfhCZvqGrrU97msfIMifJloEhtpy
         SE9oOvDEPWQQg0zjVXIgBiHRt63GQBTq6FfPD+HMr03Jhk+4Un8IDsQE+AfBiCWQNrI8
         rj5Km/bcXZ+ki+Yx3i9RDUsLDFpgSDwDcCQRk/a/LOmFO94LABGisf9Gof0O5RZCzV7x
         QXLg==
X-Gm-Message-State: ABy/qLb4+/NHUsX+kZG2UHjeHhzNtc+IH0fVtNO0nqd6kYWX+L49xvzF
        RLK4r9M29f0Jyfqi/81u65IKKe8/ten5kAB9ABdxv1IQerwseDk9uHarYLPQ53L8VnSYtKicHOV
        78Y04fTsv51vvFnqNkbaHEwjBvSzS9aXwldZLBKPI/xeK3nVs0pzGpfQvhYlRmPxR1M0GjcY=
X-Google-Smtp-Source: APBJJlGi+t+Jvz5YnzmYs2pb+P74IDdQheGqP83Hl+qUs/2Tdm5fbiUccEVezqIwu/5WgDEpXDFGz/Yty21s9i3pIQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:40d6:0:b0:ca1:179e:5d7d with SMTP
 id n205-20020a2540d6000000b00ca1179e5d7dmr120332yba.3.1689607644948; Mon, 17
 Jul 2023 08:27:24 -0700 (PDT)
Date:   Mon, 17 Jul 2023 15:27:17 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717152722.1837864-1-jingzhangos@google.com>
Subject: [PATCH v6 0/6] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2, 3}
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
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

This patch series enable userspace writable for below idregs:
ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2, 3}_EL1.

It is based on v6.5-rc1 which contains infrastructure for writable idregs.

A selftest is added to verify that KVM handles the writings from user space
correctly.

A relevant patch from Oliver is picked from [3].

---

* v5 -> v6
  - Override the type of field AA64DFR0_EL1_DebugVer to be FTR_LOWER_SAFE by the
    discussion of Oliver and Suraj.

* v4 -> v5
  - Rebase on v6.4-rc1 which contains infrastructure for writable idregs.
  - Use guest ID registers values for the sake of emulation.
  - Added a selftest to verify idreg userspace writing.

* v3 -> v4
  - Rebase on v11 of writable idregs series at [2].

* v2 -> v3
  - Rebase on v6 of writable idregs series.
  - Enable writable for ID_AA64PFR0_EL1 and ID_AA64MMFR{0, 1, 2}_EL1.

* v1 -> v2
  - Rebase on latest patch series [1] of enabling writable ID register.

[1] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[2] https://lore.kernel.org/all/20230602005118.2899664-1-jingzhangos@google.com
[3] https://lore.kernel.org/kvmarm/20230623205232.2837077-1-oliver.upton@linux.dev

[v1] https://lore.kernel.org/all/20230326011950.405749-1-jingzhangos@google.com
[v2] https://lore.kernel.org/all/20230403003723.3199828-1-jingzhangos@google.com
[v3] https://lore.kernel.org/all/20230405172146.297208-1-jingzhangos@google.com
[v4] https://lore.kernel.org/all/20230607194554.87359-1-jingzhangos@google.com
[v5] https://lore.kernel.org/all/20230710192430.1992246-1-jingzhangos@google.com

---

Jing Zhang (4):
  KVM: arm64: Use guest ID register values for the sake of emulation
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (1):
  KVM: arm64: Reject attempts to set invalid debug arch version

 arch/arm64/kvm/sys_regs.c                     |  80 +++++++--
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/set_id_regs.c       | 163 ++++++++++++++++++
 3 files changed, 230 insertions(+), 14 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
-- 
2.41.0.255.g8b1d071c50-goog

