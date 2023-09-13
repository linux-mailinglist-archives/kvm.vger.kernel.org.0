Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8E979E787
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 14:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240133AbjIMMDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 08:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbjIMMDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 08:03:44 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9056419AC
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 05:03:40 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id a1e0cc1a2514c-79414715edeso2098072241.0
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 05:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694606619; x=1695211419; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gWMUVlPMdZwPxM8OGL1HLsy3K8ryzTavoZi5zJxR92s=;
        b=UwTfB19Ez7Wtc0/zZ1sQdCylbMVU3BFP6CjulH6rHMbqo+KKCI2yzQae1zxbUxumoV
         b4+nAQNX2FBa6WFgQD8spC2Oa6ej7tH5Lm2QXzAFg1uzTt2slFWcrRYNO/Pdjt02JSVo
         KJldha509G+M1ZzUpwIYHcv9QzHQ6hRRfb9n2S6RutgW8hLk5GoT8a3ecVGAHSO2oFAb
         9Zb498y1OMMhFVxWC7agDa4Zf2z/80pM0ZuKlztCz2j3I0fgiJ7YuNDPckPNN7g0iVxb
         2kcs4iMD9Wdv+wtIfOkVrjk2UNmcSSck+fcQ0GpBU2UfE2CAlP+mTx7V8EOKIFHs01RB
         1ELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694606619; x=1695211419;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gWMUVlPMdZwPxM8OGL1HLsy3K8ryzTavoZi5zJxR92s=;
        b=WMgxHB6d0jY07/y3CwL6dmwFjUHp2qA4cP1yEx31JwRb9Dv9Zw9Ucz6E5kB7LJRiHf
         +TpmB0PLLDDh2o/BEQiLE8T6vlX1q4bQ+TOZB0OQlTfhfVKnQXs3lo9heGOsfn2JEY1G
         74ghUmYdrVGN+wADCfFPGZgF+tlnoFD5yneZ/rZDiSuPrkQMVZDzf3u6XvC9FqW+0QSK
         6Fr8nTz6NMGgaG3XLHrdoRLLF7uLchdh0Xd58GJ+rkVi977QbVDqyagdCTFIP8AQcIcS
         PbVE85habJa+v4hCcChAPaOJ71ZmwdECD7MB1DhxlIBxM/ZBE09RU05JuXcGDc17SFBF
         y5ZQ==
X-Gm-Message-State: AOJu0Yw4BgoWXaPIg/I+1EUXb4I4V2tlE6pg7KmzHbEVM4rAiRxMzf8H
        A8oKIpnFMgY+2l94OGkEI3OhnfnnMIW3Z0JkS5djwg==
X-Google-Smtp-Source: AGHT+IEj4asuOgWJLW73zrrxOPXYRDigNysM+h1qglN2GVf3TIz6gqi5aI8VyHhwVdcOkV9H5J4O2iBhR5+KYAXlsc0=
X-Received: by 2002:a05:6122:1820:b0:48d:3b80:fba9 with SMTP id
 ay32-20020a056122182000b0048d3b80fba9mr2280983vkb.11.1694606619560; Wed, 13
 Sep 2023 05:03:39 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 Sep 2023 17:33:28 +0530
Message-ID: <CA+G9fYtC0iTRSRj8WSw5KMDwrx4Z3Djo89OXXdHjna9r3qy3Kg@mail.gmail.com>
Subject: kvm: arm64: WARNING: CPU: 3 PID: 1 at arch/arm64/kvm/hyp/pgtable.c:453
 hyp_map_walker+0xa8/0x120
To:     open list <linux-kernel@vger.kernel.org>,
        kvmarm@lists.cs.columbia.edu, kvm list <kvm@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Cc:     Yu Zhao <yuzhao@google.com>, Reiji Watanabe <reijiw@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Shaoqin Huang <shahuang@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>, rananta@google.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following kernel warning noticed on arm64 Raspberry Pi 4 Model B and
Juno-r2 devices while booting the mainline 6.6.0-rc1 kernel.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Boot log:
---------
Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd083]
[    0.000000] Linux version 6.6.0-rc1 (tuxmake@tuxmake)
(aarch64-linux-gnu-gcc (Debian 13.2.0-2) 13.2.0, GNU ld (GNU Binutils
for Debian) 2.41) #1 SMP PREEMPT @1694546723
[    0.000000] KASLR disabled due to lack of seed
[    0.000000] Machine model: Raspberry Pi 4 Model B
...
[    0.181598] kvm [1]: IPA Size Limit: 44 bits
[    0.184681] ------------[ cut here ]------------
[    0.184689] WARNING: CPU: 3 PID: 1 at
arch/arm64/kvm/hyp/pgtable.c:453 hyp_map_walker+0xa8/0x120
[    0.184726] Modules linked in:
[    0.184740] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 6.6.0-rc1 #1
[    0.184753] Hardware name: Raspberry Pi 4 Model B (DT)
[    0.184759] pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.184772] pc : hyp_map_walker+0xa8/0x120
[    0.184787] lr : hyp_map_walker+0x3c/0x120
[    0.184800] sp : ffff80008352b850
[    0.184806] x29: ffff80008352b850 x28: ffff8000823f4008 x27: 0000000000000003
[    0.184829] x26: ffff000040c46000 x25: ffff000040c46000 x24: 0000000000000004
[    0.184849] x23: fffffffffffff000 x22: ffff80008352bbc0 x21: ffff800082ec1b20
[    0.184868] x20: 00400000ff844753 x19: ffff80008352b8e8 x18: ffffffffffffffff
[    0.184888] x17: ffff80008327c990 x16: 0000000083346a16 x15: 0000000000000000
[    0.184907] x14: 0000000000000000 x13: 0000000000000000 x12: ffff80008389ffff
[    0.184927] x11: 0000000000000000 x10: ffff0000fbfff010 x9 : ffff80008008cefc
[    0.184946] x8 : ffff80008352bad8 x7 : ffff80008352bbc0 x6 : ffff80008352bbc0
[    0.184964] x5 : 0000000000000000 x4 : 0000000000002000 x3 : 0000ffffffffffff
[    0.184983] x2 : 00400000feef1090 x1 : 0000000000000003 x0 : 00400000ff844750
[    0.185004] Call trace:
[    0.185009]  hyp_map_walker+0xa8/0x120
[    0.185024]  __kvm_pgtable_walk+0x2e0/0x320
[    0.185038]  __kvm_pgtable_walk+0x100/0x320
[    0.185052]  __kvm_pgtable_walk+0x100/0x320
[    0.185065]  __kvm_pgtable_walk+0x100/0x320
[    0.185077]  kvm_pgtable_walk+0xd0/0x170
[    0.185091]  kvm_pgtable_hyp_map+0x94/0x120
[    0.185105]  __create_hyp_mappings+0x68/0xc0
[    0.185119]  __create_hyp_private_mapping+0xe4/0x140
[    0.185131]  create_hyp_io_mappings+0x94/0x120
[    0.185143]  vgic_v2_probe+0xc4/0x218
[    0.185154]  kvm_vgic_hyp_init+0xcc/0x200
[    0.185163]  kvm_arm_init+0x6c4/0x1068
[    0.185181]  do_one_initcall+0x5c/0x2b8
[    0.185192]  kernel_init_freeable+0x1fc/0x3f8
[    0.185208]  kernel_init+0x2c/0x1f8
[    0.185222]  ret_from_fork+0x10/0x20
[    0.185235] ---[ end trace 0000000000000000 ]---
[    0.185248] ------------[ cut here ]------------
[    0.185252] WARNING: CPU: 3 PID: 1 at
arch/arm64/kvm/hyp/pgtable.c:470 hyp_map_walker+0x100/0x120
[    0.185272] Modules linked in:
[    0.185280] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G        W
   6.6.0-rc1 #1
[    0.185290] Hardware name: Raspberry Pi 4 Model B (DT)
[    0.185296] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.185308] pc : hyp_map_walker+0x100/0x120
[    0.185321] lr : hyp_map_walker+0x3c/0x120
[    0.185334] sp : ffff80008352b850
[    0.185339] x29: ffff80008352b850 x28: ffff8000823f4008 x27: 0000000000000003
[    0.185358] x26: ffff000040c46000 x25: ffff000040c46000 x24: 0000000000000004
[    0.185377] x23: fffffffffffff000 x22: ffff80008352bbc0 x21: ffff800082ec1b20
[    0.185396] x20: 00400000ff844753 x19: ffff80008352b8e8 x18: ffffffffffffffff
[    0.185415] x17: ffff80008327c990 x16: 0000000083346a16 x15: 0000000000000000
[    0.185435] x14: 0000000000000000 x13: 0000000000000000 x12: ffff80008389ffff
[    0.185454] x11: 0000000000000000 x10: ffff0000fbfff010 x9 : ffff80008008cefc
[    0.185472] x8 : ffff80008352bad8 x7 : ffff80008352bbc0 x6 : ffff80008352bbc0
[    0.185491] x5 : 0000000000000000 x4 : 0000000000002000 x3 : 0000ffffffffffff
[    0.185510] x2 : 00400000feef1090 x1 : 0000000000000003 x0 : 00400000ff844750
[    0.185529] Call trace:
[    0.185534]  hyp_map_walker+0x100/0x120
[    0.185547]  __kvm_pgtable_walk+0x2e0/0x320
[    0.185561]  __kvm_pgtable_walk+0x100/0x320
[    0.185574]  __kvm_pgtable_walk+0x100/0x320
[    0.185587]  __kvm_pgtable_walk+0x100/0x320
[    0.185600]  kvm_pgtable_walk+0xd0/0x170
[    0.185614]  kvm_pgtable_hyp_map+0x94/0x120
[    0.185627]  __create_hyp_mappings+0x68/0xc0
[    0.185639]  __create_hyp_private_mapping+0xe4/0x140
[    0.185650]  create_hyp_io_mappings+0x94/0x120
[    0.185662]  vgic_v2_probe+0xc4/0x218
[    0.185672]  kvm_vgic_hyp_init+0xcc/0x200
[    0.185681]  kvm_arm_init+0x6c4/0x1068
[    0.185696]  do_one_initcall+0x5c/0x2b8
[    0.185707]  kernel_init_freeable+0x1fc/0x3f8
[    0.185722]  kernel_init+0x2c/0x1f8
[    0.185733]  ret_from_fork+0x10/0x20
[    0.185745] ---[ end trace 0000000000000000 ]---
[    0.185760] kvm [1]: Cannot map VCTRL into hyp


Links,
 - https://lkft.validation.linaro.org/scheduler/job/6780041#L587
 - https://qa-reports.linaro.org/lkft/linux-mainline-master-sanity/build/v6.6-rc1-33-g3669558bdf35/testrun/19913903/suite/log-parser-boot/test/check-kernel-exception/details/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2VJFncJcwoozdfQkO3ZUjZq4KTd/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2VJFncJcwoozdfQkO3ZUjZq4KTd/config

metadata:
  git_ref: master
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline
  git_sha: 3669558bdf354cd352be955ef2764cde6a9bf5ec
  git_describe: v6.6-rc1-33-g3669558bdf35
  kernel_version: 6.6.0-rc1
  kernel-config:
    https://storage.tuxsuite.com/public/linaro/lkft/builds/2VJFncJcwoozdfQkO3ZUjZq4KTd/config
  artifact-location:
    https://storage.tuxsuite.com/public/linaro/lkft/builds/2VJFncJcwoozdfQkO3ZUjZq4KTd/
  toolchain: gcc-13


--
Linaro LKFT
https://lkft.linaro.org
