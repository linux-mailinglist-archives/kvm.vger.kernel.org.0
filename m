Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B444588F9
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 06:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhKVFcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 00:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbhKVFca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 00:32:30 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D37C061574
        for <kvm@vger.kernel.org>; Sun, 21 Nov 2021 21:29:18 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id a9so30393289wrr.8
        for <kvm@vger.kernel.org>; Sun, 21 Nov 2021 21:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=IzITWkNY6G4KqlmKbWmvBujRViOrviBlPuMw4qeNio4=;
        b=IePkvHCFaamUXzPrIPWncNAEKNolntHYpueJ9bkOM7xzw6PizQj+kojfc866YBYzfi
         44HVdxziixR5wdCAaDellKDb0XKWUwZVDqFnyQzfPw55vyGBt1gWwxh4W7FAUPz69lem
         zUTsA8te8KeqUmeCvVHbOIuF757Pgps9bBJs8f9PPx4gkW1lpym4zHJTo3sEnEFFZcFA
         LGnVX5+VSIGhFZOzm35e5t+PtdX1nbXSkQZFgrKyQb2corvpbab+VMGJ3cYm68Hw6ial
         jj5voWFaMVYBsu/ZCN2Duk98l15Ez2Wx/korO8c5dgSk1m0chXn/jfyn0maeoYaggzSa
         xn+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=IzITWkNY6G4KqlmKbWmvBujRViOrviBlPuMw4qeNio4=;
        b=N6ONaXfMCEhmkFrJNFo3Cq0Ze7qiZgjFm2Uves59euRJjAuDnUD3Mj9zrdNcYE48ye
         2XcHVX5kHYBOwVClibFrlAR11zJYMWIR8ZkkPA1rY9XN3//DAhecnBnBHojvnBwYGLwz
         WCMBHyGLPuaJnM03tUYoMNNVu9rkTXCGurtSatlGEO+Q9gUG3xNJzbnhpy5pyr/tDwKo
         k6OcPmu/oCFPsip37TRg6CNWv4SvgoUC/HK+//59VOpW7FjXLge1kxT54Z8j1kFP5Nun
         9ZfnjikT4rlMthGCb1ssGo0WAmx1859oRsdZwyNRoSAo/do0Fj1mC/zxcfushWRn0jBz
         10Xw==
X-Gm-Message-State: AOAM531RIIEnxvADhwsGnGVymagNd2PhhI0L6C4UjEbo4PzySDj1pMfy
        FR+kIlXYaLn2jwWEuEGxEgIY8qf+BTy6KccGD0v3auD1dfr8MA==
X-Google-Smtp-Source: ABdhPJxqv6ThmF9ny5S/xJBGs1tYPB4GdadcxtNS23BFcgLQvVUPnmA1FmQTsI8O1vLV2aXsZoQhDChnI6Pq4Qvw8Kc=
X-Received: by 2002:a5d:4846:: with SMTP id n6mr33306950wrs.249.1637558956298;
 Sun, 21 Nov 2021 21:29:16 -0800 (PST)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 22 Nov 2021 10:59:05 +0530
Message-ID: <CAAhSdy0CZiBSdGaVrDWEeWe7PUXKpE4RLiYeCaEO2QTN3mT83g@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 5.16, take #1
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

This is the first set of fixes for 5.16. We only have two fixes
where first one adds missing kvm_arch_flush_shadow_memslot()
implementation whereas the second one fixes KVM_MAX_VCPUS
value.

Please pull.

Regards,
Anup

The following changes since commit 136057256686de39cc3a07c2e39ef6bc43003ff6:

  Linux 5.16-rc2 (2021-11-21 13:47:39 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-5.16-1

for you to fetch changes up to 74c2e97b01846eb237b7819a3e2944455cfdb26a:

  RISC-V: KVM: Fix incorrect KVM_MAX_VCPUS value (2021-11-22 10:36:19 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 5.16, take #1

- Fix incorrect KVM_MAX_VCPUS value

- Unmap stage2 mapping when deleting/moving a memslot
  (This was due to empty kvm_arch_flush_shadow_memslot())

----------------------------------------------------------------
Anup Patel (1):
      RISC-V: KVM: Fix incorrect KVM_MAX_VCPUS value

Sean Christopherson (1):
      KVM: RISC-V: Unmap stage2 mapping when deleting/moving a memslot

 arch/riscv/include/asm/kvm_host.h | 8 +++-----
 arch/riscv/kvm/mmu.c              | 6 ++++++
 2 files changed, 9 insertions(+), 5 deletions(-)
