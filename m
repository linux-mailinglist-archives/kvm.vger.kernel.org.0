Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1ACC297A53
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 04:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757121AbgJXCNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 22:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756727AbgJXCNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 22:13:34 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B522C0613D2
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 19:13:33 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id s21so4053568oij.0
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 19:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=0Ujqe4ZUZFtu/lYhqxeeV/BQscYr5R12aTQxmFkXZqQ=;
        b=RnL9+h3MHknkfWyccUeUFg+CuFhAHssEBLufs1jVN8iAXg7+elkF2mZSLEjRLAAp4I
         Fvqus6nnfgFlkX4FYfdqgPqe+/nAutGI8c2G1IAdi/kIvXRrWugrguUi/VM3oDI3vl8+
         goY8Nlvmw4piK+AIlMpVqTtOwhsyAMrr0mbOwoXLTHbLFIxdJSWNPGgr4CfzfL8FzC4q
         idUW6u00cHwfjTxnQV6srSNOVhvFWN+T4KkTf+Gpq9NrT41O0nGwROc/o4DJlHgTO4GZ
         yQ66Ic9cXdxyQPXL8d7f4fkuyLxbIxUd1Vmxx/PK1uMiLUU8efwDmznSvLQ0hOvUSFiX
         AZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=0Ujqe4ZUZFtu/lYhqxeeV/BQscYr5R12aTQxmFkXZqQ=;
        b=kd8f2eqDwE1hzcKNqe+rP4m55yDlSie18MAhuTSjFVFxJZRf9LBdHuAWhQLD5ZBu6x
         23bUEcghRZ/Knw/5d0DuSCgJPA5OEW6XoStKcNJ/7WNEr5yqhkxq1I2RYmtpCP4UmhM2
         pT9HbjX1FvsjAHTisvi8YjMdc76zTMZijF3y6tHpmD/vQ3UDMf0m62tc8GW9EzkEQ3CE
         c2TpDt4h4NlvTH7lWYd29wdIKiV+YamtG7VeGAFDd6m/yLOzgTRLnon0X1ou3dYshEaU
         o/K0CgChX8bnh7FAjNgZHe5j2XO+xUyxvOukdioFczaMFp4HvzjVLjky4AB0fM+qYdEx
         gvoQ==
X-Gm-Message-State: AOAM533L3eXNxyk5bzk/92WtpXNMRUJb2/Unys6LuCA87iKbBiQNndpV
        gS4s+0sPElcgEkzQpWPNKfNvnXACQm6td6qsuM0B8w==
X-Google-Smtp-Source: ABdhPJylPkgfbyKnnnP8iIPPmlxSrfJUSjgIrcloB7NBlcY8qCf2tlR3+0iPpZ3lSJ8/DSepEaoAnPT/pTnbAUpD86U=
X-Received: by 2002:a05:6808:605:: with SMTP id y5mr4332428oih.172.1603505612450;
 Fri, 23 Oct 2020 19:13:32 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Fri, 23 Oct 2020 21:13:21 -0500
Message-ID: <CAEUSe7_bptXLQQt5TkUoVitnFbnAF-KkyqQpcZnYuKgSGuBpPw@mail.gmail.com>
Subject: kvm: x86-32 fails to link with tdp_mmu
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello!

We found the following problem building torvalds/master, which
recently merged the for-linus tag from the KVM tree, when building
with gcc 7.3.0 and glibc 2.27 for x86 32-bits under OpenEmbedded:

|   LD      vmlinux.o
|   MODPOST vmlinux.symvers
|   MODINFO modules.builtin.modinfo
|   GEN     modules.builtin
|   LD      .tmp_vmlinux.kallsyms1
| arch/x86/kvm/mmu/tdp_mmu.o: In function `__handle_changed_spte':
| tdp_mmu.c:(.text+0x78a): undefined reference to `__umoddi3'
| /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/Mak=
efile:1164:
recipe for target 'vmlinux' failed
| make[1]: *** [vmlinux] Error 1
| /srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/Mak=
efile:185:
recipe for target '__sub-make' failed
| make: *** [__sub-make] Error 2

This builds fine for x86 (64 bits) and arm (32/64 bits) with the same
toolchain. This also builds correctly (outside OpenEmbedded) with
gcc-8, gcc-9 and gcc-10 for: x86 (32/64 bits), arm (32/64 bits), MIPS,
and RISCV; and gcc-8 and gcc-9 for ARC.

We first noticed this when 0adc313c4f20 was pushed, but reverting
f9a705ad1c07 ("Merge tag 'for-linus' of
git://git.kernel.org/pub/scm/virt/kvm/kvm") brought it back into
building.

A follow-up bisection led to faaf05b00aec ("kvm: x86/mmu: Support
zapping SPTEs in the TDP MMU"). In that commit, the problematic code
was:

        handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte=
,
                            iter->level);

which was later changed by f8e144971c68 ("kvm: x86/mmu: Add access
tracking for tdp_mmu") to:

        __handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_sp=
te,
                              iter->level);

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
