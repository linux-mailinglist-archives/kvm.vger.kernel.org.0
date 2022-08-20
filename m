Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F23159AC63
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 10:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240765AbiHTIDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 04:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiHTIDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 04:03:10 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90EDABF19
        for <kvm@vger.kernel.org>; Sat, 20 Aug 2022 01:03:08 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-333b049f231so174972047b3.1
        for <kvm@vger.kernel.org>; Sat, 20 Aug 2022 01:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=QkwKuzBI7l8iu+4vGZrCJGX2wlxUTNgTxUbkf6ZqWvw=;
        b=q29S+XdSjKJaSSfq+QNYqVDNumYRTIiOmiSGRfiJ1gGCnc6wAFm6LsIqDokL/7B+sG
         DIr5JmUb/Kr/EWAIGzdvutAhF9B+ErkDH6vdmadOzwvBiiR+6KmnRyqD6jgMd9k6G78S
         9w/Di0gKtzBhfAJNK0C8pbVQB9soX9T1dnLsLMHt5p/Zauf635HvpX19I0bj5iyeO21/
         oM1rviYP3zPRujAjUlWZuLQoQSinRF9qsIw9Nrvx4i42MrEE4a8MRHi7WLmwiveZ87GM
         X4b55vMDL3EXv7D6CEpzEfftTqNVywXfGcfVXfAygtlzCT/p99AjTjr2ZuWC+CiB94R4
         pjZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=QkwKuzBI7l8iu+4vGZrCJGX2wlxUTNgTxUbkf6ZqWvw=;
        b=J6LHEUxwhUtd90u2AFCCtSKP9fbG1aZV+LHv41w3tOLHJC/Kq/Tk/Cj/G7rs6cDJfs
         dWXoE+lyRZDC6loodpKV68EfjmmLY5IWqz4HpsPOS/Kbz+7V+449HtDF5K9ba/n0G/ti
         POXjOX5Gf1w68vvAAhPdZm0MoZd/lMhBne7YIvfaHieaVgl42kdCJcA6UHMNF6qeTl77
         fiKcvcNu/FzI5is/r4PtYuvjnPtIECdeRk9W31r6EMYUFLEim9nukr8ZFUJ3PzgzbBAQ
         getOqaEPOwlv3ntDFtsMeUgGtMJg4an304Rx0rgyIQh9ilbzRuI92SLp/wW+KQ+cJGcy
         9ogg==
X-Gm-Message-State: ACgBeo3+qRcxewoH8/y0/oJghG3V61YNTRvXv6/sOBSnYMcbWqQ3bwZk
        yUt0isOY1LDzkGEeRvtc6k1BqteSFeKn/XWAyb4rQg==
X-Google-Smtp-Source: AA6agR7Vg3h9nu/w3AWm3bt0NH9grArU/uBvyFFdE6kBRMTd70+JJAVSYhUSKPZin2LvX6SZrZxRbJ/w24PRVjWG54I=
X-Received: by 2002:a5b:104:0:b0:68e:c5d0:d042 with SMTP id
 4-20020a5b0104000000b0068ec5d0d042mr11268029ybx.315.1660982587794; Sat, 20
 Aug 2022 01:03:07 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 20 Aug 2022 13:31:55 +0530
Message-ID: <CAAhSdy2oDoytypnjNFodEY7q_E0OVmrh=GkihQE_K5MnPcK_Sg@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.0, take #1
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

We have two minor fixes for 6.0:
1) Fix unused variable warnings in vcpu_timer.c
2) Move extern sbi_ext declarations to a header

Please pull.

Regards,
Anup

The following changes since commit 568035b01cfb107af8d2e4bd2fb9aea22cf5b868:

  Linux 6.0-rc1 (2022-08-14 15:50:18 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.0-1

for you to fetch changes up to 3e5e56c60a14776e2a49837b55b03bc193fd91f7:

  riscv: kvm: move extern sbi_ext declarations to a header (2022-08-19
23:22:47 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.0, take #1

- Fix unused variable warnings in vcpu_timer.c
- Move extern sbi_ext declarations to a header

----------------------------------------------------------------
Conor Dooley (2):
      riscv: kvm: vcpu_timer: fix unused variable warnings
      riscv: kvm: move extern sbi_ext declarations to a header

 arch/riscv/include/asm/kvm_vcpu_sbi.h | 12 ++++++++++++
 arch/riscv/kvm/vcpu_sbi.c             | 12 +-----------
 arch/riscv/kvm/vcpu_timer.c           |  4 ----
 3 files changed, 13 insertions(+), 15 deletions(-)
