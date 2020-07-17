Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A912243C1
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 21:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgGQTFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 15:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728459AbgGQTF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 15:05:27 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C34C0619D4
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 12:05:27 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id x9so13856019ljc.5
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 12:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EHhwNWLvCGKwFX6ZeCk25F8g9x2pupMKT7Bn+2O6siI=;
        b=UMpy7eBg0VQk13Zh0CsA8daqqCqMYLR/yLgZvVSL0lJ8/e5Ix44NjgigL3+q8XJArC
         +CoZF6icBgyJrPruDpKiDqs3SPz2T9oivrXhdcRHtNzZ1eOY09EfmGogrMEiKoqjN8Tf
         QfSD4InjPcIuMhztE9TSwtLzGwGlEqO2hK1TlNN3tpgoD/IpL93Q8TOpldntF8RTIa9i
         C8ukkczG2UxL4WrwjzmXVCfquGoET/KgUjsKal4Q1IavPiGqE2sp7z7Ky8vMrNAWrbHJ
         dh1pCRPAhK/qgJYywFwZzK5mejpW5pcI+fhWKbs7znm9DT4r7gpOB4C5y4W8oNfI1t7j
         EZsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EHhwNWLvCGKwFX6ZeCk25F8g9x2pupMKT7Bn+2O6siI=;
        b=SlN1N4mu/8zc3Zm8dAS1sPVeRHoub/+MKMbj1JCYPlSNcNKEeKo1zFrwp8scj/u/YW
         UnaqsU81gIkMhQuDPI49haUINwKRLpwH+L8nNR3+ax941CpXhRsdueicVYAzo1qU/Jon
         zsKoTK8UliLB0OGFqW5nbMddf892S7yTbvPWcnSaQFS8cPG0BqNIMwU5AdITaDnyhwXU
         Wc2NoNvDaCHKzQkShOqXIvo0PBzW6YP5McsSRhFpM+iF+/Z+s58L1Qii+TZEZc4nexDl
         BkBz33aakCUHc4+Ql1bdJHGUyFSfFV3ZFn9ebUa11rm6UCHK9PV3oHjMKn0MdPoY7pN5
         fHaA==
X-Gm-Message-State: AOAM532FAauXtWdKxWnzx/qYg18TwUNFyvasfDPfNGOjrr8RGK9oB8a8
        uwyXiM9KacL3JxKU+kdL0T9G5+1UxJ8Xa1jILFiUIg==
X-Google-Smtp-Source: ABdhPJzA2lclNj5LaSPAOhsYYmx7y36gm/usqNFraHHlhKV4rNqxpPH0IXWB5YiqK4pOf3QGE+Q7RO/aAlHNo2NWhrU=
X-Received: by 2002:a2e:9b42:: with SMTP id o2mr4877549ljj.102.1595012725372;
 Fri, 17 Jul 2020 12:05:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200712131003.23271-1-madhuparnabhowmik10@gmail.com>
 <20200712131003.23271-2-madhuparnabhowmik10@gmail.com> <20200712160856.GW9247@paulmck-ThinkPad-P72>
 <CA+G9fYuVmTcttBpVtegwPbKxufupPOtk_WqEtOdS+HDQi7WS9Q@mail.gmail.com>
 <CAA42JLY2L6xFju_qZsVguGtXvDMqfCKbO_h1K9NJPjmqJEav=Q@mail.gmail.com> <20200717170747.GW9247@paulmck-ThinkPad-P72>
In-Reply-To: <20200717170747.GW9247@paulmck-ThinkPad-P72>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 18 Jul 2020 00:35:12 +0530
Message-ID: <CA+G9fYvtYr0ri6j-auNOTs98xVj-a1AoZtUfwokwnvuFFWtFdQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: mmu: page_track: Fix RCU list API usage
To:     "Paul E. McKenney" <paulmck@kernel.org>,
        madhuparnabhowmik10@gmail.com
Cc:     Dexuan-Linux Cui <dexuan.linux@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Paolo Bonzini <pbonzini@redhat.com>, rcu@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        frextrite@gmail.com, lkft-triage@lists.linaro.org,
        Dexuan Cui <decui@microsoft.com>, juhlee@microsoft.com,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paul,

> I am not seeing this here.

Do you notice any warnings while building linux next master
for x86_64 architecture ?

> Could you please let us know what compiler
> and command-line options you are using to generate this?

We have two build systems one showing it as error and build breaks
and another one showing it as warning and build pass.
tool chain: gcc 9.3.0
build command:
make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Dx86 HOSTCC=3Dgcc
CC=3D"sccache gcc" O=3Dbuild

metadata:
    git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-ne=
xt.git,
    target_arch: x86,
    toolchain: gcc-9,
    git_short_log: aab7ee9f8ff0 (\Add linux-next specific files for 2020071=
7\),
    git_sha: aab7ee9f8ff0110bfcd594b33dc33748dc1baf46,
    git_describe: next-20200717,
    kernel_version: 5.8.0-rc5,

warning log,
--
make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Dx86 HOSTCC=3Dgcc
CC=3D"sccache gcc" O=3Dbuild
#
In file included from ../include/linux/pid.h:5,
                 from ../include/linux/sched.h:14,
                 from ../include/linux/kvm_host.h:12,
                 from ../arch/x86/kvm/mmu/page_track.c:14:
../arch/x86/kvm/mmu/page_track.c: In function =E2=80=98kvm_page_track_write=
=E2=80=99:
../include/linux/rculist.h:727:30: warning: left-hand operand of comma
expression has no effect [-Wunused-value]
  727 |  for (__list_check_srcu(cond),     \
      |                              ^
../arch/x86/kvm/mmu/page_track.c:232:2: note: in expansion of macro
=E2=80=98hlist_for_each_entry_srcu=E2=80=99
  232 |  hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~
../arch/x86/kvm/mmu/page_track.c: In function =E2=80=98kvm_page_track_flush=
_slot=E2=80=99:
../include/linux/rculist.h:727:30: warning: left-hand operand of comma
expression has no effect [-Wunused-value]
  727 |  for (__list_check_srcu(cond),     \
      |                              ^
../arch/x86/kvm/mmu/page_track.c:258:2: note: in expansion of macro
=E2=80=98hlist_for_each_entry_srcu=E2=80=99
  258 |  hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~
arch/x86/kvm/svm/svm.o: warning: objtool: svm_flush_tlb_gva()+0x12:
call without frame pointer save/setup
kernel/bpf/core.o: warning: objtool: ___bpf_prog_run.cold()+0x7: call
without frame pointer save/setup

ref:
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/643978120


>                                                         Thanx, Paul

- Naresh
