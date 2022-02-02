Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC784A73F1
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 15:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242489AbiBBO4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 09:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345381AbiBBO4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 09:56:08 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA8DC06175B
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 06:55:58 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v13so38774938wrv.10
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 06:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ZrDOk96xIXTsGTfo9/ILISPypk5mowtPM4WNMZCWfgQ=;
        b=ZdJidn9E7ICenT1d16RsYRVZaqa2zhHEEXGEAFo2LGCKDiTcJIBYeFJrZvNfhsUAYb
         j3zRktgiN855jXtddVnr4XIxZlwdtSiQNZjRpHmCjFB2jTS6NdCvZPWZK4OwNbtnNXUT
         nsKHOVrI6VrZfR+QG+amXXS4iZWdQBViWITe/92eYozY9rXHr67g2Z+6wpKUa3YWi94U
         ow7o85flDptOsRm2XfU+zDYsO8HoFkfMn7i/IDQjXHofVngzZIhOv4fumzkTf64XZFEz
         kBStSYyqBE4XMGfeeZyiBuW3/lPHYXntwOYSxeKZSXaX0FMDnIfXKtpKi7NWg3nfggCA
         A5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ZrDOk96xIXTsGTfo9/ILISPypk5mowtPM4WNMZCWfgQ=;
        b=b2ayi6OHdR7OXlj3PZC+50KvdW3Bwrx8YASv4MKayjGxo6kuFR2NKrKR1dd2GujE/Q
         a9ahszWImdN9CeeseaWWd7dgpYsMkElqkgT/LjWG5vQFr78TuDOfcwL/VdtGVG24ArPP
         n9vP3GBMOdUp+OlLIz9+t2MRFJdCPvtpDCZ+cnOZkwtQYYXMCzJHehtc5Es2L6phFIZR
         Cd3BC1oHoNtHldoQQGrKXeLuFCOJ8eQ0t/k93n99yZ/gNPPLGqITP3X3+HHAMq8gJFDF
         8/bVQlOrJs6kFVi+SMWPryEIyZ45WCaiW9drMM18JQuaeTVRzm/xIu2uErADLE9j1z/W
         HHkQ==
X-Gm-Message-State: AOAM5329GPrUXSIQCvGelNvR2R5afGWDawnfJu0YAB62yEbsIWpFHsrT
        cDgCuChFU7sMgIU0ukDAcHSZVGwnqZY9qi7AYU/5Zg==
X-Google-Smtp-Source: ABdhPJyWyV1yDWmsFpu5+qSL7ud2Pox/KB7M7ZuabShU/yZR1x02qeWJ5TJkyHvk7pKtf9lMAqr3k/P+zhXZLyp+JYo=
X-Received: by 2002:adf:d08c:: with SMTP id y12mr26168596wrh.346.1643813756620;
 Wed, 02 Feb 2022 06:55:56 -0800 (PST)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 2 Feb 2022 20:25:44 +0530
Message-ID: <CAAhSdy0C_RMVShk=vv7FRgmVRspBkVQfiCLx-4B6pYtLU10vZA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 5.17, take #1
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

This is the first set of fixes for 5.17. We have three fixes namely
guest entry rework, sbi implementation version fix and counter
access fix.

Please pull.

Regards,
Anup

The following changes since commit b2d2af7e5df37ee3a9ba6b405bdbb7691a5c2dfc:

  kvm/x86: rework guest entry logic (2022-02-01 08:51:54 -0500)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-5.17-1

for you to fetch changes up to 403271548a840dd4f884088d6333e09f899be5ff:

  RISC-V: KVM: Fix SBI implementation version (2022-02-02 18:58:06 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 5.17, take #1

- Rework guest entry logic

- Make CY, TM, and IR counters accessible in VU mode

- Fix SBI implementation version

----------------------------------------------------------------
Anup Patel (1):
      RISC-V: KVM: Fix SBI implementation version

Mark Rutland (1):
      kvm/riscv: rework guest entry logic

Mayuresh Chitale (1):
      RISC-V: KVM: make CY, TM, and IR counters accessible in VU mode

 arch/riscv/kvm/vcpu.c          | 48 +++++++++++++++++++++++++++---------------
 arch/riscv/kvm/vcpu_sbi_base.c |  3 ++-
 2 files changed, 33 insertions(+), 18 deletions(-)
