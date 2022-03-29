Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E164EA881
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 09:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbiC2HbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 03:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiC2HbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 03:31:10 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17444110C
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 00:29:28 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id o8so14095069pgf.9
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 00:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UTbD7jGgh/KLDDWua+lhKitl7ix/55ibmUsyIxaned4=;
        b=UEarIBkXggU6f1IDuuLRahcOyLDmhoTwhhFad0YQS6tczcmbGtfopV40XNg0dlMLV9
         5kE3fh2S0koV0yDrG3x5lFHmuc5mobUwE5bD2DMFbDfCAzYfhhYeRsrprilqKrN3zrHq
         1w7Pfts/TuEemwSOWKOH4G1E5Qby4wB1xCfe+Pfj/zWTaGpvk0T1OYPiQRsTGDfyx9id
         Q/x2xfJ8PJUeYs5uvJC7i9NQ4aBP42ucW5mOFhOvtXsT4966C9S3M2Q1WYSslEJ7Akdr
         pUEtEkn6i7WTWvf1jywickNrM6pC0HcBP+7Skped0Jwd/GAdpSxARqtAAqyPy2EpqVBv
         ediQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UTbD7jGgh/KLDDWua+lhKitl7ix/55ibmUsyIxaned4=;
        b=BtFz9itrpMTQbUakqxvdYohiV1wY4HBPo3fYchITY7lW3r+QaYHhYuHChLyQFeQuD0
         YIsULvxdFlfKkrOZDdvOSC7SSFa2mL99qyxKvgzwWo26AtwX+mN6PgkNVN8TJihII0zJ
         e8LFyLzs1DBMC+9+uFq1gGNEKuYKHogeK9hEuDli7ttMpVo16SO8CmvqOHriEc628aXx
         tfvtjlG2K2eXvlIf8cCQBS1XfPHsE7h/gWDrQe2FXGTZ3pbUiA42MAyaRgRkmEVPYUoz
         9hnqmSpZ6FPqju4xV5lah7gulk+I6NGvidhZCKzLhKeTHRTzuiRoOPD8CzIyJCcg1hpq
         DUbg==
X-Gm-Message-State: AOAM530IuNpKtfY3l45G7umf2pJJlQowEt/q0C7/FBAvrbUhjObjU1TV
        T/9F3/pzQqnLsV83y5Jb5FyTbA==
X-Google-Smtp-Source: ABdhPJwIkpl4g0Z0faxh1E9Z+gpMHgVpjDzUMRtKVIvn6DAguqbIiaRi5u4NO2ReAR8iEzODdyEFMA==
X-Received: by 2002:a63:211b:0:b0:382:6f4e:3408 with SMTP id h27-20020a63211b000000b003826f4e3408mr1061874pgh.515.1648538967322;
        Tue, 29 Mar 2022 00:29:27 -0700 (PDT)
Received: from localhost.localdomain ([122.171.166.231])
        by smtp.gmail.com with ESMTPSA id z6-20020a056a00240600b004e17ab23340sm19440564pfh.177.2022.03.29.00.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 00:29:26 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 0/3] Unexpected guest trap handling for KVM RISC-V selftests
Date:   Tue, 29 Mar 2022 12:59:08 +0530
Message-Id: <20220329072911.1692766-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Getting unexpected guest traps while running KVM RISC-V selftests should
cause the test to fail appropriately with VCPU register dump. This series
improves handling of unexpected traps along these lines.

These patches can also be found in riscv_kvm_selftests_unexp_trap_v1 branch
at: https://github.com/avpatel/linux.git

Anup Patel (3):
  KVM: selftests: riscv: Set PTE A and D bits in VS-stage page table
  KVM: selftests: riscv: Fix alignment of the guest_hang() function
  KVM: selftests: riscv: Improve unexpected guest trap handling

 .../selftests/kvm/include/riscv/processor.h   | 12 ++++---
 .../selftests/kvm/lib/riscv/processor.c       |  9 +++---
 tools/testing/selftests/kvm/lib/riscv/ucall.c | 31 +++++++++++++------
 3 files changed, 34 insertions(+), 18 deletions(-)

-- 
2.25.1

