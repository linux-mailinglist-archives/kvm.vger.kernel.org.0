Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A841C76C067
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 00:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjHAW0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 18:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjHAW0h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 18:26:37 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2090F1BCF
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 15:26:36 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1bbaa549bcbso5014467fac.3
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 15:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690928795; x=1691533595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aLZCqoRQcOktEsLifQk+vjPW/U/cqKGOg9FG7whue7A=;
        b=PxPmoTcCHw88abd1Yceck0AHNGjXgPVAhecUPv8Y8c8TM3VhwZNxfIKcx2KDlNWAkl
         /2V6X/4VqccEMmtzyEKyW7B5nwbLoMLiacX8H3qtK3FMi7aHz92wwHX2cg215mvLa79U
         6IOD2tE2h1pTk0M0oJM9o12Hd+3CHZlVFZqaxX/gdfuCvsY9hs7SdRRuuubOlktwMbj6
         zeAMVWw+G3gAmRWzuCGd7ullnbVJDxmRodxJUJjmDR0+0KhCeCYABDGDveuqZGAFVUe1
         HyHCkpdZwpIibmxyiL0CA3iz9+E7GryimZRztQlF5Qzbq1ItNUG/62kuyw8L4dR3qFso
         tRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690928795; x=1691533595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aLZCqoRQcOktEsLifQk+vjPW/U/cqKGOg9FG7whue7A=;
        b=QNfCxGrDHhYPATMAUrHu/K2z9xE2RjH4E1lx0dfm+WhSZqdntCyYxpOEMVbzqikNHg
         Ka1j3+sq+hKLBCI2vdXh/sCuy2z1cSM6Qy3UH4a+gft7jSyDaDkZjT+PJNpa/o+sQrri
         wc0wmsTVO/KRqv+QLvGIwpUKqUWf8yD4P6FPsG9tPN9LSwyrVGlovzohjBA0buEEcJy5
         wRPnnFuVoe+ZPVU2ufYBKMDQ/cBt7Ro0ThPElaqyS6jTMwMjqeYTjR1KFxSkKFiTC4i8
         fstJBlKnAHAIVErSdSXDQzgMmAx+3hVY0z3Wpqem+SEpU24znGGBpj8hJLqvm/ddZ8B3
         CJJA==
X-Gm-Message-State: ABy/qLZBiQFjsN/H/337l9N9XBR1ZcTRzKF4t1Yasvd9KZsaSG2PmPlh
        lSE/ESVgUFdsohDTy7evGbbMpg==
X-Google-Smtp-Source: APBJJlHT8CdaBi3LBcyMTRdJqroBd6BY6285JRx0YFJlO7dcIHPSMS7xrAPH/GEFLSAMLKP80G7AmQ==
X-Received: by 2002:a05:6871:a5:b0:1bb:4bad:ebce with SMTP id u37-20020a05687100a500b001bb4badebcemr18624551oaa.27.1690928795375;
        Tue, 01 Aug 2023 15:26:35 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e15-20020a9d6e0f000000b006b94904baf5sm5422429otr.74.2023.08.01.15.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 15:26:35 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 0/9] RISC-V: KVM: change get_reg/set_reg error codes
Date:   Tue,  1 Aug 2023 19:26:20 -0300
Message-ID: <20230801222629.210929-1-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

In this new version 3 new patches (6, 7, 8) were added by Andrew's
request during the v1 review.

We're now avoiding throwing an -EBUSY error if a reg write is done after
the vcpu started spinning if the value being written is the same as KVM
already uses. This follows the design choice made in patch 3, allowing
for userspace 'lazy write' of registers.

I decided to add 3 patches instead of one because the no-op check made
in patches 6 and 8 aren't just a matter of doing reg_val = host_val.
They can be squashed in a single patch if required.

Please check the version 1 cover-letter [1] for the motivation behind
this work. Patches were based on top of riscv_kvm_queue.

Changes from v1:
- patches 6,7, 8 (new):
  - make reg writes a no-op, regardless of vcpu->arch.ran_atleast_once
    state, if the value being written is the same as the host
- v1 link: https://lore.kernel.org/kvm/20230731120420.91007-1-dbarboza@ventanamicro.com/

[1] https://lore.kernel.org/kvm/20230731120420.91007-1-dbarboza@ventanamicro.com/

Daniel Henrique Barboza (9):
  RISC-V: KVM: return ENOENT in *_one_reg() when reg is unknown
  RISC-V: KVM: use ENOENT in *_one_reg() when extension is unavailable
  RISC-V: KVM: do not EOPNOTSUPP in set_one_reg() zicbo(m|z)
  RISC-V: KVM: do not EOPNOTSUPP in set KVM_REG_RISCV_TIMER_REG
  RISC-V: KVM: use EBUSY when !vcpu->arch.ran_atleast_once
  RISC-V: KVM: avoid EBUSY when writing same ISA val
  RISC-V: KVM: avoid EBUSY when writing the same machine ID val
  RISC-V: KVM: avoid EBUSY when writing the same isa_ext val
  docs: kvm: riscv: document EBUSY in KVM_SET_ONE_REG

 Documentation/virt/kvm/api.rst |  2 +
 arch/riscv/kvm/aia.c           |  4 +-
 arch/riscv/kvm/vcpu_fp.c       | 12 +++---
 arch/riscv/kvm/vcpu_onereg.c   | 68 +++++++++++++++++++++++-----------
 arch/riscv/kvm/vcpu_sbi.c      | 16 ++++----
 arch/riscv/kvm/vcpu_timer.c    | 11 +++---
 6 files changed, 71 insertions(+), 42 deletions(-)

-- 
2.41.0

