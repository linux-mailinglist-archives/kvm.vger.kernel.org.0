Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB521441B3A
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 13:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhKAMhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 08:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbhKAMhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 08:37:05 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDF5C061714
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 05:34:32 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v17so27906972wrv.9
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 05:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=y2Y8ilwyriUGgynMYA//pB8+mWDgGay/mxGbSkA0Eaw=;
        b=dWbZ5hl+TdK4c89/9/Zi3TeCysZvskdagk6cPPB/UOgyPuNIYJhHaNTwLjhTX96cfZ
         rONGHyASgQZcBVPl6XJb4hFnQU6VzT8tBTLsAmuzw2ow2wSS0S7qRhEhp+JZ1xrh++pQ
         USWPRap6wBGCT8nJhEQxW60dXU1fXMV43ewud+QlhicLqXBwqdzB26MEFzzYNxVOlJV0
         kUGtE+E7PbbALSqGQqMpCZuJCo/OqOvwbFTnX4THLD5Jyd20Zo+yDVje6BPSmiQeo7aF
         qvdBdlT3rV2xJXfHxhDatDNSq4Hg76ZtEKMxxlNFQsyKZHRb1vBvpvbOoxlg/lmJX5QZ
         abng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=y2Y8ilwyriUGgynMYA//pB8+mWDgGay/mxGbSkA0Eaw=;
        b=yuo5ZTuOp+8ZfqICvmAM0C0gjrkEJ1pnmfByOxTu37k8ruqjhjNhRKuAZ18kdzD3N/
         AC9QUdJNeaveZi8amMKXXZ+HrddFv8372I9SSQBB0lkYs/XsjQ5GnYhZZdD6BvwnXMay
         IPvRufuYOemv/Zh/8enPuVpoZyZeL0zfYNIvRBMWLsiu57Q0B6QOb/irK3Lh2LRmfu6h
         hvJHHbgICf4bos6zBp//6sTTszURDbmb8hHSpCWpFaSkQeRslxyUKL2M0rtrLoCgo8/A
         Qz3mRAjIN9LZ8b/VtQemsW/LMjFZePodc0XOC5nCkg+U45ZP1CACbZxZlLTkaaqUf1bK
         Ozww==
X-Gm-Message-State: AOAM5307vGbR/zxF/3aVMtrIMAPQmhkIPoPF5ocGQPjerspp+TS2ztZ1
        QRETGkTR9KlbhEXk/xSbmimoLwqN3WiUb8plRUdpPQ==
X-Google-Smtp-Source: ABdhPJyju/FbxRBXiA9b3A3dGPr7fMUwMbj02mX3uH1UpvPkV4V9+KVxHWflnZp/9M2Io/WVc9SRwGgvCE1MnXaRY+0=
X-Received: by 2002:a5d:628f:: with SMTP id k15mr24637104wru.363.1635770070888;
 Mon, 01 Nov 2021 05:34:30 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 1 Nov 2021 18:04:19 +0530
Message-ID: <CAAhSdy0TUZAgb5Wyp4Lnv30A1sJ009ATr9VTq49ow_C9-YVeBg@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv for 5.16 take #2
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        KVM General <kvm@vger.kernel.org>,
        Atish Patra <atish.patra@wdc.com>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

I had two warning fixes in the KVM RISC-V repo which I am
sending as part of this PR. Also, sorry if I sent the PR too late.

Please pull.

Best Regards,
Anup

The following changes since commit 9c6eb531e7606dc957bf0ef7f3eed8a5c5cb774d:

  Merge tag 'kvm-s390-next-5.16-1' of
git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
(2021-10-31 09:01:25 -0400)

are available in the Git repository at:

  git://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.16-2

for you to fetch changes up to bbd5ba8db7662dbfcc15204eb105cd0c2971a47c:

  RISC-V: KVM: fix boolreturn.cocci warnings (2021-11-01 17:35:17 +0530)

----------------------------------------------------------------
Minor cocci warning fixes:
1) Bool return warning fix
2) Unneeded semicolon warning fix

----------------------------------------------------------------
Bixuan Cui (1):
      RISC-V: KVM: fix boolreturn.cocci warnings

ran jianping (1):
      RISC-V: KVM: remove unneeded semicolon

 arch/riscv/kvm/mmu.c        | 18 +++++++++---------
 arch/riscv/kvm/vcpu.c       |  4 ++--
 arch/riscv/kvm/vcpu_exit.c  |  6 +++---
 arch/riscv/kvm/vcpu_sbi.c   |  2 +-
 arch/riscv/kvm/vcpu_timer.c |  4 ++--
 5 files changed, 17 insertions(+), 17 deletions(-)
