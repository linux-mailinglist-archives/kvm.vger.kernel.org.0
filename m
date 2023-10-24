Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5790D7D4923
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 09:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjJXH63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 03:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjJXH61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 03:58:27 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C75310E
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 00:58:26 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-5b8a88038b4so1730829a12.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 00:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1698134305; x=1698739105; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TqVph8BGnQIvj3qNLjA65fQXyMZdDqQskG5rQpKkD6g=;
        b=ku+fjtpwc4Xq1Lpatr3FZkJ87cKLrabCLdE8upcBHrr1NAIgovpZP4gEsZvWpbCaZt
         9LXzpv8/Lo6zZ/v8Bx5S+tk8jdgXADwi+LAsW5bWD53rB1lwxnNLua9aXrYJn7ef0iEW
         nNwFtJQUIzGFnrP8R0l8CKuMnvay7XNQEv4NHDTMHey+Y/EnL0Qz6+sSObhi9ASQBqKj
         boGwYvCUHA+Sp4Hj6OnsCTnrXnq+8Jid2uVxTWj0DvrBoMCdrCFdVKnBcPdEDEBlS0ZB
         GVy6Cx8BDZIpJQFK9AvI++I5/qLfdTGBBMowznsdSb2SKU96JBOxdvekyfA7ifieJgw0
         TrSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698134305; x=1698739105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TqVph8BGnQIvj3qNLjA65fQXyMZdDqQskG5rQpKkD6g=;
        b=ke8hVjcgc39PDn7tG8kA28c/q9u7Z5f1k73kCsn1HsCKcO5sha1ww1/bkGRSTQmi70
         rAPN54k+VQqXQ0E7Z6IhujqgCP3ZytClwUDguAPI9nOFxrhjp5gOWTvEJN5/n99DTlNT
         vevln+f/+5IlbE/m5tBWsJpQ4ailFsG2mAU1ZC8Fj4SFiuqcOA9fvgfgiUWZ6elMZwhi
         icnnEVw/bWGoGx3c7X/r45pacUS+5AwlwFJ+6cUFRfLagRU+DXbBm128LYTvAP1ISxmH
         syd5v74YJN+gg9Q3ckucyHemHXdJxzJM0XzKBGOGtGpKzqKwmc5bTkR7EN0GJ/e+QwI2
         ppDA==
X-Gm-Message-State: AOJu0Yw0ao3tMwFMdomRoeL43DD4++0pgdgJnvvawR4v0e42RVdp5eBX
        T3z2pUG9SJQIk/0u5/djH5rTXkfPONHpRintYcO5Jg==
X-Google-Smtp-Source: AGHT+IFxB82dfpwIVZCEtc3Jh13RV+6u4BgREa2RlRY5g1UQgKDkuIsw9FCzZGmL6kyd/1KimQ51A8qhmZD58A9UmkE=
X-Received: by 2002:a17:90a:3902:b0:27c:f4a9:7e20 with SMTP id
 y2-20020a17090a390200b0027cf4a97e20mr19464291pjb.15.1698134305304; Tue, 24
 Oct 2023 00:58:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy2p0h8i=GPBx+=ZJVr_PSwOHhTqanJQmOc0O0bw1ffrmw@mail.gmail.com>
In-Reply-To: <CAAhSdy2p0h8i=GPBx+=ZJVr_PSwOHhTqanJQmOc0O0bw1ffrmw@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 24 Oct 2023 13:28:13 +0530
Message-ID: <CAAhSdy3rDz+TKV339Ab2fiLym_W-p7Eq1Q95ovxUuCxT0qi6iA@mail.gmail.com>
Subject: Re: KVM/riscv changes for 6.7
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Tue, Oct 24, 2023 at 1:25=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.7:
> 1) Smstateen and Zicond support for Guest/VM
> 2) Virtualized senvcfg CSR for Guest/VM
> 3) Added Smstateen registers to the get-reg-list selftests
> 4) Added Zicond to the get-reg-list selftests
> 5) Virtualized SBI debug console (DBCN) for Guest/VM
> 6) Added SBI debug console (DBCN) to the get-reg-list selftests
>
> Please pull.
>
> Please note that the following four patches are part of the
> shared tag kvm-riscv-shared-tag-6.7 provided to Palmer:
>  - dt-bindings: riscv: Add Zicond extension entry
>  - RISC-V: Detect Zicond from ISA string
>  - dt-bindings: riscv: Add smstateen entry
>  - RISC-V: Detect Smstateen extension

Forgot "GIT PULL" prefix in the email. Please disregard this email.
Apologies for the noise.

Regards,
Anup

>
> Regards,
> Anup
>
> The following changes since commit 94f6f0550c625fab1f373bb86a6669b45e9748=
b3:
>
>   Linux 6.6-rc5 (2023-10-08 13:49:43 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.7-1
>
> for you to fetch changes up to d9c00f44e5de542340cce1d09e2c990e16c0ed3a:
>
>   KVM: riscv: selftests: Add SBI DBCN extension to get-reg-list test
> (2023-10-20 16:50:39 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.7
>
> - Smstateen and Zicond support for Guest/VM
> - Virtualized senvcfg CSR for Guest/VM
> - Added Smstateen registers to the get-reg-list selftests
> - Added Zicond to the get-reg-list selftests
> - Virtualized SBI debug console (DBCN) for Guest/VM
> - Added SBI debug console (DBCN) to the get-reg-list selftests
>
> ----------------------------------------------------------------
> Andrew Jones (3):
>       MAINTAINERS: RISC-V: KVM: Add another kselftests path
>       KVM: selftests: Add array order helpers to riscv get-reg-list
>       KVM: riscv: selftests: get-reg-list print_reg should never fail
>
> Anup Patel (11):
>       RISC-V: Detect Zicond from ISA string
>       dt-bindings: riscv: Add Zicond extension entry
>       RISC-V: KVM: Allow Zicond extension for Guest/VM
>       KVM: riscv: selftests: Add senvcfg register to get-reg-list test
>       KVM: riscv: selftests: Add smstateen registers to get-reg-list test
>       KVM: riscv: selftests: Add condops extensions to get-reg-list test
>       RISC-V: Add defines for SBI debug console extension
>       RISC-V: KVM: Change the SBI specification version to v2.0
>       RISC-V: KVM: Allow some SBI extensions to be disabled by default
>       RISC-V: KVM: Forward SBI DBCN extension to user-space
>       KVM: riscv: selftests: Add SBI DBCN extension to get-reg-list test
>
> Mayuresh Chitale (7):
>       RISC-V: Detect Smstateen extension
>       dt-bindings: riscv: Add smstateen entry
>       RISC-V: KVM: Add kvm_vcpu_config
>       RISC-V: KVM: Enable Smstateen accesses
>       RISCV: KVM: Add senvcfg context save/restore
>       RISCV: KVM: Add sstateen0 context save/restore
>       RISCV: KVM: Add sstateen0 to ONE_REG
>
>  .../devicetree/bindings/riscv/extensions.yaml      |  12 ++
>  MAINTAINERS                                        |   1 +
>  arch/riscv/include/asm/csr.h                       |  18 ++
>  arch/riscv/include/asm/hwcap.h                     |   2 +
>  arch/riscv/include/asm/kvm_host.h                  |  18 ++
>  arch/riscv/include/asm/kvm_vcpu_sbi.h              |   7 +-
>  arch/riscv/include/asm/sbi.h                       |   7 +
>  arch/riscv/include/uapi/asm/kvm.h                  |  12 ++
>  arch/riscv/kernel/cpufeature.c                     |   2 +
>  arch/riscv/kvm/vcpu.c                              |  76 +++++--
>  arch/riscv/kvm/vcpu_onereg.c                       |  72 ++++++-
>  arch/riscv/kvm/vcpu_sbi.c                          |  61 +++---
>  arch/riscv/kvm/vcpu_sbi_replace.c                  |  32 +++
>  tools/testing/selftests/kvm/riscv/get-reg-list.c   | 233 +++++++++++++--=
------
>  14 files changed, 418 insertions(+), 135 deletions(-)
