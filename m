Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F58D54430E
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 07:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238175AbiFIFVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 01:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiFIFVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 01:21:13 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7BF3A7814
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 22:21:11 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q26so20424384wra.1
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 22:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=3JvmTDsGJDO8gLLj4AkIUZGP939Dw1HwCVtV4Fo1fIc=;
        b=gvpL1tx8KEFZNPWGZCgk5FC/3L2U7PZMRwO9ausTf+jLLYmZwWAdvdIUejsm+2wTBx
         QauAaV9t6tSX2IayxvQU1LJIFVbnfta0gAOd8aFNxgJ87G1xNV21ncl5wcmbr/7y1myv
         CWAa/X8nB6ygdk/1nQ6m0x7FL6bBxjojSoPyq1pbIJHFYPkmI7WLjvHB/8vwgb2jMScc
         Mzp24FW8/IFCzNRRbOLSohAT0Dha4ewb7uI7TlUlQKzfZ+aZg5NbGzj4rCdlPTDS+7wp
         Glhm71qxTVSQH3Va5gVbKt7j5JpZ3PPzhPrVSLFv2cUXlWTBANcgObx5ZPRa1P01Gpop
         0hMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=3JvmTDsGJDO8gLLj4AkIUZGP939Dw1HwCVtV4Fo1fIc=;
        b=H8HLWwkSSFepPh/EDsQZN4wY6s3ONDVx/kGxL1/XRdJTPZPW0oX9p8te6Afi1HsaAI
         GcggJGAUbBPhEBAfIUjfsKYsVVDCPwtS2NNBOeZalKBhoFyd7nBnSUm4jQaHeBdgTohV
         G2LphXwlw3qSUAeCx3tXWg9pRLMLOoXq2JEeFnjfVduPQg1b83UvwbBzLX/Cvu0+O21S
         qo+ijbcyLR1IQ0MtdzFSe/QhZ3JnVwu2dsDT/+GUH20ePsw3AzXjUcMM3ZBwoI1KMJBd
         0P/Pd0RI8ZehudwoL5H9offpNEqE9ROw7VMuMEX2+3Cw14Y6/H6z8WJ6oZcUpb9fgsnz
         W1Lw==
X-Gm-Message-State: AOAM53037REl4FxOv85NeeaqAT4+doh+2hg9vAOsGefL/715zfaglbMA
        XSp8VWbC9m7pt309/Cux4sMCr30EktnHLOvMHHq4hmIltmOEMA==
X-Google-Smtp-Source: ABdhPJwwgl51ub88+ijPWwcfkn2THzzdQExCqu39kwCgVQUo9/VGLBkfRIBDJKUNmtB+lj/v62O5FE3nmVeTvZ5tt68=
X-Received: by 2002:adf:e30f:0:b0:210:346e:d5da with SMTP id
 b15-20020adfe30f000000b00210346ed5damr35611235wrj.313.1654752070224; Wed, 08
 Jun 2022 22:21:10 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 9 Jun 2022 10:50:55 +0530
Message-ID: <CAAhSdy3BY551VEP5D-_vj7nzhb9O_k69v99jMdjQ+OxWZpxzpA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 5.19, take #1
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

Two minor fixes were missed in 5.19 merge window which include:
1) Typo fix in arch/riscv/kvm/vmid.c
2) Remove broken reference pattern from MAINTAINERS entry

Please pull.

Regards,
Anup

The following changes since commit f2906aa863381afb0015a9eb7fefad885d4e5a56:

  Linux 5.19-rc1 (2022-06-05 17:18:54 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-5.19-1

for you to fetch changes up to 1a12b25274b9e54b0d2d59e21620f8cf13b268cb:

  MAINTAINERS: Limit KVM RISC-V entry to existing selftests
(2022-06-09 09:18:22 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 5.19, take #1

- Typo fix in arch/riscv/kvm/vmid.c

- Remove broken reference pattern from MAINTAINERS entry

----------------------------------------------------------------
Julia Lawall (1):
      RISC-V: KVM: fix typos in comments

Lukas Bulwahn (1):
      MAINTAINERS: Limit KVM RISC-V entry to existing selftests

 MAINTAINERS           | 1 -
 arch/riscv/kvm/vmid.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)
