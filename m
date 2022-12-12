Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53B7649F72
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 14:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbiLLNJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 08:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbiLLNIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 08:08:53 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478D611C22
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 05:08:48 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z92so12767340ede.1
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 05:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hrsTHdTJbwls01AqE8UPAVwypoZK7MqNkS0vyWojDY0=;
        b=JAq03fHIf8UuWIJHvhpRM+Oi++N5xfDJubmTSXe4iFh8RjCZmBts2l5NWwEz/a5n9r
         tW2wQEX4fhpHI4JW2o6SvinEGHARdWRiFAq2k3rUq1II+ltsLB2wLI70zokFvxFJHmbk
         qPNeFccGX2EspzTx/gmm7DqfoXlkuuKMSKbqwDYY7pr/4JSkU5U1Ljg4nDADttNkS4JE
         /evkOmJe86hF+zSbt2ptqYc1iVAstcx5/2hERs0+93wQepQJ1KPuUN4dHBiqUAH8UNXo
         YHeztyJkSJaYXg0nQI22OTdiT5glecWt7B6K1hXmntJ9r8O4IhaS7ymptUu3XOr+zVeK
         sxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hrsTHdTJbwls01AqE8UPAVwypoZK7MqNkS0vyWojDY0=;
        b=5FaQDtPSDw1C+RpIu1bJnt5IFtUH+1n7WxM7R0oijxN0+w2c2JK/8NM/Tknx3hfINz
         dqDokexbCPoApMPQ7jtWGgpS9gUB6TzpWr8Ob43ZDBjaYSA4rHZ8kRaRLAmnRQShckPC
         9nwTCalbtxded28Uu8m9v7aWYhoHX2gptalfKH3Py7vS6G5wussKqhVNmZyLms2kzIpB
         bq/yiH4fWZmv1kdDdhUU1pWrINH2lMYb8taI1KKgC74QXGnCzV/37zL5z3uHZwRpxteU
         65N11jR5sev/m8WuS3S2dip12+WMfo71Ga4Dauay7pWsy8aFkE8/Bge0DEPX5eQSYXe7
         F/xQ==
X-Gm-Message-State: ANoB5pk1VSr5Y3xvp6xmhbiiInef00xhhllbYZCwfp3Qopp7bJqZyUm+
        VYNyM2qljjTMaQNzEcYXNoCuUYsL9Ww4iUqo5jAqGQ==
X-Google-Smtp-Source: AA0mqf4hhAV6qnhgB/a43t2zmLT85++iSw6RqiW6FztbKeqmmRQu+gMIQlhxBBJ5aKBrrMatWIl0Ylw2BekWCNITujc=
X-Received: by 2002:aa7:ca4c:0:b0:46c:24fc:ba0f with SMTP id
 j12-20020aa7ca4c000000b0046c24fcba0fmr24347150edt.140.1670850526482; Mon, 12
 Dec 2022 05:08:46 -0800 (PST)
MIME-Version: 1.0
References: <CAAhSdy0qihfFCXTV-QUjP-5XiQQqBC4_sP-swx77k6PC3uTmmw@mail.gmail.com>
 <CABgObfZ7Ar-t5m0+p=H1h0_bk-dJ5rYSVRCo6ZP5Wa0Qva2sLQ@mail.gmail.com>
In-Reply-To: <CABgObfZ7Ar-t5m0+p=H1h0_bk-dJ5rYSVRCo6ZP5Wa0Qva2sLQ@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 12 Dec 2022 18:38:34 +0530
Message-ID: <CAAhSdy0c5_oa27axsG_YnZmJqoTVXAeR2XQ=sqvLtBMaB3wB1Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.2
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022 at 5:06 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On Wed, Dec 7, 2022 at 11:33 AM Anup Patel <anup@brainfault.org> wrote:
> >
> > Hi Paolo,
> >
> > We have the following KVM RISC-V changes for 6.2:
> > 1) Allow unloading KVM module
> > 2) Allow KVM user-space to set mvendorid, marchid, and mimpid
> > 3) Several fixes and cleanups
> >
> > Please pull.
> >
> > Regards,
> > Anup
>
> Hmm, I looked at them more closely and I noticed something weird in
> the author date:
>
> git log --format='%an %ad %s' origin/master..6ebbdecff6ae
> Anup Patel Wed Dec 7 09:17:49 2022 +0530 RISC-V: KVM: Add ONE_REG
> interface for mvendorid, marchid, and mimpid
> Anup Patel Wed Dec 7 09:17:43 2022 +0530 RISC-V: KVM: Save mvendorid,
> marchid, and mimpid when creating VCPU
> Anup Patel Wed Dec 7 09:17:38 2022 +0530 RISC-V: Export
> sbi_get_mvendorid() and friends
> Anup Patel Wed Dec 7 09:17:27 2022 +0530 RISC-V: KVM: Move sbi related
> struct and functions to kvm_vcpu_sbi.h
> Anup Patel Wed Dec 7 09:17:19 2022 +0530 RISC-V: KVM: Use switch-case
> in kvm_riscv_vcpu_set/get_reg()
> Anup Patel Wed Dec 7 09:17:12 2022 +0530 RISC-V: KVM: Remove redundant
> includes of asm/csr.h
> Anup Patel Wed Dec 7 09:17:05 2022 +0530 RISC-V: KVM: Remove redundant
> includes of asm/kvm_vcpu_timer.h
> Anup Patel Wed Dec 7 09:16:51 2022 +0530 RISC-V: KVM: Fix reg_val
> check in kvm_riscv_vcpu_set_reg_config()
> Christophe JAILLET Wed Dec 7 09:16:39 2022 +0530 RISC-V: KVM: Simplify
> kvm_arch_prepare_memory_region()
> Anup Patel Wed Dec 7 09:16:21 2022 +0530 RISC-V: KVM: Exit run-loop
> immediately if xfer_to_guest fails
> Bo Liu Wed Dec 7 09:16:11 2022 +0530 RISC-V: KVM: use vma_lookup()
> instead of find_vma_intersection()
> XiakaiPan Wed Dec 7 09:16:02 2022 +0530 RISC-V: KVM: Add exit logic to main.c
>
> Something in your workflow has eaten the actual date when these were
> posted to the mailing list.
>
> For example, https://lore.kernel.org/lkml/CAAhSdy0t1XGTENidgNQkQ5m5emZOes+-2RXTPLEJ0tEZXuX2hA@mail.gmail.com/t/
> shows Bo Liu's patch as being sent on November 1st.
>
> Please keep the author information from the mailing list messages, and
> also please try to update the KVM/RISC-V tree as soon as patches are
> ready and tested, i.e. earlier than the week before the merge window.
> (Seeing '6.1-rc8' as the base for the pull request is often a sign of
> something wrong with the workflow; see
>
> It's a small set of changes, so I'm going to defer this pull request
> to the second week of the merge window.

Should I send another PR ?
OR
Should I re-create the kvm-riscv-6.2-1 tag ?

Regards,
Anup

>
> Paolo
>
> > The following changes since commit 76dcd734eca23168cb008912c0f69ff408905235:
> >
> >   Linux 6.1-rc8 (2022-12-04 14:48:12 -0800)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.2-1
> >
> > for you to fetch changes up to 6ebbdecff6ae00557a52539287b681641f4f0d33:
> >
> >   RISC-V: KVM: Add ONE_REG interface for mvendorid, marchid, and
> > mimpid (2022-12-07 09:17:49 +0530)
> >
> > ----------------------------------------------------------------
> > KVM/riscv changes for 6.2
> >
> > - Allow unloading KVM module
> > - Allow KVM user-space to set mvendorid, marchid, and mimpid
> > - Several fixes and cleanups
> >
> > ----------------------------------------------------------------
> > Anup Patel (9):
> >       RISC-V: KVM: Exit run-loop immediately if xfer_to_guest fails
> >       RISC-V: KVM: Fix reg_val check in kvm_riscv_vcpu_set_reg_config()
> >       RISC-V: KVM: Remove redundant includes of asm/kvm_vcpu_timer.h
> >       RISC-V: KVM: Remove redundant includes of asm/csr.h
> >       RISC-V: KVM: Use switch-case in kvm_riscv_vcpu_set/get_reg()
> >       RISC-V: KVM: Move sbi related struct and functions to kvm_vcpu_sbi.h
> >       RISC-V: Export sbi_get_mvendorid() and friends
> >       RISC-V: KVM: Save mvendorid, marchid, and mimpid when creating VCPU
> >       RISC-V: KVM: Add ONE_REG interface for mvendorid, marchid, and mimpid
> >
> > Bo Liu (1):
> >       RISC-V: KVM: use vma_lookup() instead of find_vma_intersection()
> >
> > Christophe JAILLET (1):
> >       RISC-V: KVM: Simplify kvm_arch_prepare_memory_region()
> >
> > XiakaiPan (1):
> >       RISC-V: KVM: Add exit logic to main.c
> >
> >  arch/riscv/include/asm/kvm_host.h     | 16 +++----
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h |  6 +++
> >  arch/riscv/include/uapi/asm/kvm.h     |  3 ++
> >  arch/riscv/kernel/sbi.c               |  3 ++
> >  arch/riscv/kvm/main.c                 |  6 +++
> >  arch/riscv/kvm/mmu.c                  |  6 +--
> >  arch/riscv/kvm/vcpu.c                 | 85 ++++++++++++++++++++++++++---------
> >  arch/riscv/kvm/vcpu_sbi_base.c        | 13 +++---
> >  arch/riscv/kvm/vcpu_sbi_hsm.c         |  1 -
> >  arch/riscv/kvm/vcpu_sbi_replace.c     |  1 -
> >  arch/riscv/kvm/vcpu_sbi_v01.c         |  1 -
> >  11 files changed, 97 insertions(+), 44 deletions(-)
> >
>
