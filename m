Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060AB76EB85
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 16:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbjHCOBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 10:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbjHCOAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 10:00:47 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0132126
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 07:00:29 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6b9ec15e014so990523a34.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 07:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691071229; x=1691676029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NQaNaGtQ40+Jka02M1oSRNm1RIoWACu+SlEJicdyxEM=;
        b=DlSRoqeENBrFcwX9dE6OwcY6K7wFkfwe7L/ho8wPYFmLeomO/RZNObL/mmx0PMPfg1
         6OJPycAzpOaJSr1NduIbCap+p/ciW0Ldzsm6UewhAAbGap9Uur0wTyH6hX56M6/UoWsv
         yAyV/rgOwhjfW57lcOVSR9Ty5T81agjAaskH1qlrB5mrbAjE4AX1NmwZxu3jvHmbcdjj
         eQct/88s/att3lrA9ziYQGqn7/xDYQjCsxBZzBXxlj/PK5v+kv1O2i3Ty/AwkwAFX/vr
         UuFiwkpFY6jWiz+knrKg1ETtXSHLtCY6j30fbCecoXgMyENNonNfKMrU4rO1lsgjpNW0
         Rl4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071229; x=1691676029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NQaNaGtQ40+Jka02M1oSRNm1RIoWACu+SlEJicdyxEM=;
        b=TKqiGgEL3lG56qtwyu8Kz6huDlYq03gE4dEk4Eot/mSOZu5MZA8Ha/QYRLnZ3n68xf
         O3p/aOcnYUXEC4Jb5yL0IX71jadVnfEzCmbHsK+JZU2ZsT8qCR4QBb26dsz7cBG2Qh5P
         ilG0ulLOK7MrClRjZB50IGwDHu+SwLUjD//yfg/PvBmsbg4uwc7XeW6OgcsnvCYN61/6
         ++ZN308PNQM2y3yxQ58m9SgxUGNk4m88SbeT1sfFfYwjnzF3jcvIVCWYYG2rmuEGwud5
         yqektqPVGbYjkQwYDLEhPT94GJTKx0XSqzsnHg4Wfg/zDXyantmN7g3ZYkKhkZ847vUg
         Ul8Q==
X-Gm-Message-State: ABy/qLYQDo6Y6GhiQ/2FHHBZfZbZg1VaX6j7MdoKRji+7jmXJ432wB51
        JvsTN0Pl2LuRDXXbFI8cLkEpXg==
X-Google-Smtp-Source: APBJJlFFP2zIvK0oB3QfIua9uP4ZwDxCuwMJLNe7KcVfKUFXQF0/e91jR8mHMyJZjtc0Omqqx4ZKjw==
X-Received: by 2002:a05:6830:1250:b0:6b4:5ed3:8246 with SMTP id s16-20020a056830125000b006b45ed38246mr19720778otp.2.1691071228829;
        Thu, 03 Aug 2023 07:00:28 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e14-20020a0568301e4e00b006b29a73efb5sm11628otj.7.2023.08.03.07.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:28 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 00/10] RISC-V: KVM: change get_reg/set_reg error codes
Date:   Thu,  3 Aug 2023 11:00:12 -0300
Message-ID: <20230803140022.399333-1-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This version has changes in the document patch, as suggested by Andrew
in v2. It also has a new patch (patch 9) that handles error code changes
in vcpu_vector.c.

Patches rebased on top of kvm_riscv_queue.

Changes from v2:
- patch 9 (new):
  - change kvm error codes for vector registers
- patch 10 (former 9):
  - rewrite EBUSY doc to mention that the error code indicates that it
    is not allowed to change the reg val after the vcpu started.
- v2 link: https://lore.kernel.org/kvm/20230801222629.210929-1-dbarboza@ventanamicro.com/

Andrew Jones (1):
  RISC-V: KVM: Improve vector save/restore errors

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
 arch/riscv/kvm/vcpu_vector.c   | 60 ++++++++++++++++--------------
 7 files changed, 104 insertions(+), 69 deletions(-)

-- 
2.41.0

