Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243BA726A0B
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 21:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjFGTqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 15:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjFGTp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 15:45:58 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DA61FF7
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 12:45:58 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-65a971d7337so711514b3a.1
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 12:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686167157; x=1688759157;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aPgsero69xFwJck0QKcCtV9CkkDCHybrauN68WHLy4A=;
        b=0A1Gsrces1skjswFsF50lVK2JnRk4tWOxR3MV+vcU6MJ2VWsqnwLTGQTi5DUD6N4Tm
         AJqBBH8FlWGmBNje8EQDCdql8N3cksHKiTRBxIhvaymhDkRV8zNLBNn/G+nYmvsbgjnZ
         STTQwiqz1grZqjk7XeQRIoJ9XdKxKpuVTPPtNCwpCQWABAytR+77MQ0Vg5vGq06osEQh
         yqPq+QKph9ugRXDTZshpK9pQZscYfiSAPtLYluUenFItsEid0QoRfBEDAUKbjR0ORjGX
         gxnSOzJ1nxT82tsjGK4RviJ/p8RCpLY8HZyW3jKypnYe4mWIITRS9pgrQfKMurJns8qv
         b74w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686167157; x=1688759157;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aPgsero69xFwJck0QKcCtV9CkkDCHybrauN68WHLy4A=;
        b=BT3LQlLE3OAjbEp7QKnwmikel81/yIGuCLMA9mzZ/Zmn/Krvhhvh3TZQB3FnX5Ry2H
         dzFv3tt8UsoN2vaoLM69hqUgoYIWkQ/RFTsLUjiY6Kkoh4Sb4yFN6HnqR+ViTmUe3tQq
         UY465ZTv8EEcSYwrzDOIqoH+ZH0zTzpfXBbe24lTnu7ld8DUaj96TDDnEbda5tS3szgp
         ViccBE8/mQ9RBuuBv2WfKYaiwLVVaeCbj24rZt/GAwclWOb6VLVZhJvuP5TF5CM6/BQc
         jstvUekA45elklTia/H5Wlik9CT37qti20wQfAk21OLFJr2q13jaCILHxhYCpdveuMq5
         66DA==
X-Gm-Message-State: AC+VfDyHkcdP2BJzKGuBBjXsAVBpgAyc5bMGSxHcuH+lNGzpelb6SekI
        b3Jd4mqPVvm2yzKKXVtPcAFG7uwhZ43GIQaY9CtOoOEHsB2t8CDeSe+UAEL6Zl3yNKV47hOIzrz
        PUsUwO/9AiOm76zPbHQu1xssAPXmSFJcLVOwXrR0yI/tpsCYK+ukVWmQJ0tFHu6Pxey4TVRA=
X-Google-Smtp-Source: ACHHUZ6Jdfp4KijOKoJc8iKkNnAT7j0Cg3mZuagkHodcduTq2g3SvL98qNbl8Vxb4j+cbgqMwwZpEe1BEtzg62RjVg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2e0e:b0:64f:5406:d5a2 with
 SMTP id fc14-20020a056a002e0e00b0064f5406d5a2mr25720pfb.0.1686167157264; Wed,
 07 Jun 2023 12:45:57 -0700 (PDT)
Date:   Wed,  7 Jun 2023 19:45:50 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607194554.87359-1-jingzhangos@google.com>
Subject: [PATCH v4 0/4] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2}
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
        Suraj Jitindar Singh <surajjs@amazon.com>,
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
ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2}_EL1.

It is based on below series [2] which add infrastructure for writable idregs.

---

* v3 -> v4
  - Rebase on v11 of writable idregs series at [2].

* v2 -> v3
  - Rebase on v6 of writable idregs series.
  - Enable writable for ID_AA64PFR0_EL1 and ID_AA64MMFR{0, 1, 2}_EL1.

* v1 -> v2
  - Rebase on latest patch series [1] of enabling writable ID register.

[1] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[2] https://lore.kernel.org/all/20230602005118.2899664-1-jingzhangos@google.com

[v1] https://lore.kernel.org/all/20230326011950.405749-1-jingzhangos@google.com
[v2] https://lore.kernel.org/all/20230403003723.3199828-1-jingzhangos@google.com
[v3] https://lore.kernel.org/all/20230405172146.297208-1-jingzhangos@google.com

---

Jing Zhang (4):
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1
  KVM: arm64: Enable writable for ID_DFR0_EL1
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2}_EL1

 arch/arm64/kvm/sys_regs.c | 78 +++++++++++++++++++++++++++++++++------
 1 file changed, 67 insertions(+), 11 deletions(-)


base-commit: 01b532e41af091a48287dd45f763db4b887bcdfc
-- 
2.41.0.rc0.172.g3f132b7071-goog

