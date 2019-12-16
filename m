Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B7D120241
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 11:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfLPKWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 05:22:24 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:43777 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbfLPKWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 05:22:24 -0500
Received: from mail-qv1-f50.google.com ([209.85.219.50]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1Mdevh-1i7Slb1FYH-00ZetK; Mon, 16 Dec 2019 11:22:22 +0100
Received: by mail-qv1-f50.google.com with SMTP id d17so2506779qvs.2;
        Mon, 16 Dec 2019 02:22:21 -0800 (PST)
X-Gm-Message-State: APjAAAVnixKY2K1AijPtPI8cn5PBubZxuBTsML7F40/fB/Yd/AGqYu4x
        UwgunJK4+kd1JmgWGcwoLb1NJWGzX6Cm02dbXAE=
X-Google-Smtp-Source: APXvYqxPGSK6LeyO+gRi/v38BhaWvjYVHEXiuyvyhofiGg3YMMrBq53W9Xc9WoTfO3zKoL1kD1MAvEvJdd8d1f9tMg8=
X-Received: by 2002:a0c:e7c7:: with SMTP id c7mr3192857qvo.222.1576491740858;
 Mon, 16 Dec 2019 02:22:20 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYuO7vMjsqkyXHZSU-pKEk0L0t9kQTfnd5xopVADyGwprw@mail.gmail.com>
In-Reply-To: <CA+G9fYuO7vMjsqkyXHZSU-pKEk0L0t9kQTfnd5xopVADyGwprw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 16 Dec 2019 11:22:04 +0100
X-Gmail-Original-Message-ID: <CAK8P3a38ZhQcA0Vj-EtNzmH7+iuoOhPrQUzN-avxJn9iU2K5=Q@mail.gmail.com>
Message-ID: <CAK8P3a38ZhQcA0Vj-EtNzmH7+iuoOhPrQUzN-avxJn9iU2K5=Q@mail.gmail.com>
Subject: Re: mainline-5.5.0-rc1: do_mount_root+0x6c/0x10d - kernel crash while
 mounting rootfs
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:skxAi3myck29pudFFtj7zTCUAssaNOTHAcJszHz89Z8cvZ8g8KM
 2WJZAaKR7U6VpPJFQ18WMfcUKjqgxSYM+muAwKsh94vvSXeMDR9QkrtVWY3VPB3lYpoPo1W
 oQLclGQqX/YhymFmwK4rVNT/9X6vG6zvqNiFAN4RM2OFkvgA5dM3WZZJ4uHeXBg/S0vOkDp
 Fv6Vvqa3cfZ9WY76gpTng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:o04HCeEeGtw=:nqN2I7636F+bGurANvbLYF
 gauWg/sMYpQcGbzCdS/VQ/xPDikArki9PXQpoWJzq+S0diOB7vTSh5SSzzFIlU3FWE2If1JXG
 JKUeFHiH1X3qdv3ONxfVA9GQ6qDvxLY3fN7eVjsqtCiRkep30G7CKzuNLSopsNjAp/2SI1UpF
 0fokUBbY8fEKLTBXTtbVNevYBZYlgcCRhO5xF+VfSsWsG75TkURUSinNLSDFuSdKbTrNvSyPW
 W0Nu5VAGmtkHihwNwdsSoi6ett5mmJ5iNNzRU50npV5DsOnMkGuXo/0yEiH+MVDbl+oQZ6C4Q
 HqDUCnIZXQpLePgsDGbPUAFMzet41A7w/6q4xlPd9qjbgjrK1miLsQ1ethJSgS/BvVsyc98nh
 jrxrpXqnMHjywN/RQNHHXC2+5IWYfgCx1SjAgS4n8PYVDkvhzGyBbpDocQEUmh3HTVppPR9Qy
 pYpH/Wj7oazaJ4yHvBJOFGzuH0PS72t2gJoI4XMd45yZKRsYsJ7bzK9wYCC+ddBs7csMs5h4b
 yYl+0KPGedh2MHkVrU0KkUgrv6pK8iBB8apktQhD3hTSDbM4FBw0gUNdIEaHRyB3N4kXi9gry
 Q5ciO94hOlTs84qWqaTiy1sCYNJBwZJeuL3oT6ZzbnX28kqOTAwZgh3F/07Yd7jd+TsEXvN1p
 5O723T+TVvB5GlJaRw15jlcp1C2SQk5MW9lWYjhMuhdt1UyOHttyQPhZ9y9kw5GK/oK6EOLA2
 ttpaOOKlE9nKko3BaZQmfcbX7wnK8tpofM4gl7buOSZYB6w2zSeyPF62JNlQawiQ6S77siL8+
 7LvlVZZjNKtuIz/lVuDuNQEUeGlipU3Pt3YEwIyMrGvo9lnJjXhrT11r/rdiuvHFUKRDCwfgh
 dX7/AWyjsp0FCmsG6pMw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 10:15 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> The following kernel crash reported on qemu_x86_64 boot running
> 5.5.0-rc1 mainline kernel.

I looked for too long at v5.5-rc1 completely puzzled by how you got to this
object code before realizing that this is a git snapshot between -rc1 and -rc2.

The code in question was changed by a recent series from Dominik Brodowski,
the main difference being commit cccaa5e33525 ("init: use do_mount() instead
of ksys_mount()").

It looks like the NULL-check in ksys_mount()/copy_mount_options() is missing
from the new mount_block_root, so it passes a NULL pointer into strncpy().

Something like this should fix it (not tested):

diff --git a/init/do_mounts.c b/init/do_mounts.c
index f55cbd9cb818..be6c8dae6ec0 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -392,16 +392,20 @@ static int __init do_mount_root(const char
*name, const char *fs,
 {
        struct super_block *s;
        char *data_page;
-       struct page *p;
+       struct page *p = NULL;
        int ret;

-       /* do_mount() requires a full page as fifth argument */
-       p = alloc_page(GFP_KERNEL);
-       if (!p)
-               return -ENOMEM;
+       if (data) {
+               /* do_mount() requires a full page as fifth argument */
+               p = alloc_page(GFP_KERNEL);
+               if (!p)
+                       return -ENOMEM;

-       data_page = page_address(p);
-       strncpy(data_page, data, PAGE_SIZE - 1);
+               data_page = page_address(p);
+               strncpy(data_page, data, PAGE_SIZE - 1);
+       } else {
+               data_page = NULL;
+       }

        ret = do_mount(name, "/root", fs, flags, data_page);
        if (ret)
@@ -417,7 +421,9 @@ static int __init do_mount_root(const char *name,
const char *fs,
               MAJOR(ROOT_DEV), MINOR(ROOT_DEV));

 out:
-       put_page(p);
+       if (p)
+               put_page(p);
+
        return ret;
 }

> Regressions detected on arm64, arm, qemu_x86_64, and qemu_i386.
> Where as x86_64 and i386 boot pass on devices.
>
> qemu_x86_64 kernel crash log,
> -------------------------------------------
> [    1.680229] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [    1.681148] #PF: supervisor read access in kernel mode
> [    1.681150] #PF: error_code(0x0000) - not-present page
> [    1.681150] PGD 0 P4D 0
> [    1.681150] Oops: 0000 [#1] SMP NOPTI
> [    1.681150] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.5.0-rc1 #1
> [    1.681150] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.12.0-1 04/01/2014
> [    1.681150] RIP: 0010:strncpy+0x12/0x30
> [    1.681150] Code: 89 e5 48 83 c6 01 0f b6 4e ff 48 83 c2 01 84 c9
> 88 4a ff 75 ed 5d c3 90 55 48 85 d2 48 89 f8 48 89 e5 74 1e 48 01 fa
> 48 89 f9 <44> 0f b6 06 41 80 f8 01 44 88 01 48 83 de ff 48 83 c1 01 48
> 39 d1
> [    1.681150] RSP: 0018:ffffacea40013e00 EFLAGS: 00010286
> [    1.681150] RAX: ffff9eff78f4f000 RBX: ffffd91104e3d3c0 RCX: ffff9eff78f4f000
> [    1.681150] RDX: ffff9eff78f4ffff RSI: 0000000000000000 RDI: ffff9eff78f4f000
> [    1.681150] RBP: ffffacea40013e00 R08: ffff9eff78f4f000 R09: 0000000000000000
> [    1.681150] R10: ffffd91104e3d3c0 R11: 0000000000000000 R12: 0000000000008001
> [    1.681150] R13: 00000000fffffff4 R14: ffffffffa5d9aa89 R15: ffff9eff78f4e000
> [    1.681150] FS:  0000000000000000(0000) GS:ffff9eff7bc00000(0000)
> knlGS:0000000000000000
> [    1.681150] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.681150] CR2: 0000000000000000 CR3: 0000000113010000 CR4: 00000000003406f0
> [    1.681150] Call Trace:
> [    1.681150]  do_mount_root+0x6c/0x10d
> [    1.681150]  mount_block_root+0x103/0x226
> [    1.681150]  ? do_mknodat+0x16e/0x200
> [    1.681150]  ? set_debug_rodata+0x17/0x17
> [    1.681150]  mount_root+0x114/0x133
> [    1.681150]  prepare_namespace+0x139/0x16a
> [    1.681150]  kernel_init_freeable+0x21b/0x22f
> [    1.681150]  ? rest_init+0x250/0x250
> [    1.681150]  kernel_init+0xe/0x110
> [    1.681150]  ret_from_fork+0x27/0x50
> [    1.681150] Modules linked in:
> [    1.681150] CR2: 0000000000000000
> [    1.681150] ---[ end trace d7ad8453a7546454 ]---
> [    1.681150] RIP: 0010:strncpy+0x12/0x30
> [    1.681150] Code: 89 e5 48 83 c6 01 0f b6 4e ff 48 83 c2 01 84 c9
> 88 4a ff 75 ed 5d c3 90 55 48 85 d2 48 89 f8 48 89 e5 74 1e 48 01 fa
> 48 89 f9 <44> 0f b6 06 41 80 f8 01 44 88 01 48 83 de ff 48 83 c1 01 48
> 39 d1
> [    1.681150] RSP: 0018:ffffacea40013e00 EFLAGS: 00010286
> [    1.681150] RAX: ffff9eff78f4f000 RBX: ffffd91104e3d3c0 RCX: ffff9eff78f4f000
> [    1.681150] RDX: ffff9eff78f4ffff RSI: 0000000000000000 RDI: ffff9eff78f4f000
> [    1.681150] RBP: ffffacea40013e00 R08: ffff9eff78f4f000 R09: 0000000000000000
> [    1.681150] R10: ffffd91104e3d3c0 R11: 0000000000000000 R12: 0000000000008001
> [    1.681150] R13: 00000000fffffff4 R14: ffffffffa5d9aa89 R15: ffff9eff78f4e000
> [    1.681150] FS:  0000000000000000(0000) GS:ffff9eff7bc00000(0000)
> knlGS:0000000000000000
> [    1.681150] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.681150] CR2: 0000000000000000 CR3: 0000000113010000 CR4: 00000000003406f0
> [    1.681150] BUG: sleeping function called from invalid context at
> /usr/src/kernel/include/linux/percpu-rwsem.h:38
> [    1.681150] in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid:
> 1, name: swapper/0
> [    1.681150] INFO: lockdep is turned off.
> [    1.681150] irq event stamp: 2360074
> [    1.681150] hardirqs last  enabled at (2360073):
> [<ffffffffa48f4c8c>] get_page_from_freelist+0x21c/0x1430
> [    1.681150] hardirqs last disabled at (2360074):
> [<ffffffffa4601eab>] trace_hardirqs_off_thunk+0x1a/0x1c
> [    1.681150] softirqs last  enabled at (2359990):
> [<ffffffffa5800338>] __do_softirq+0x338/0x43a
> [    1.681150] softirqs last disabled at (2359975):
> [<ffffffffa4701828>] irq_exit+0xb8/0xc0
> [    1.681150] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G      D
>   5.5.0-rc1 #1
> [    1.681150] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.12.0-1 04/01/2014
> [    1.681150] Call Trace:
> [    1.681150]  dump_stack+0x7a/0xa5
> [    1.681150]  ___might_sleep+0x163/0x250
> [    1.681150]  __might_sleep+0x4a/0x80
> [    1.681150]  exit_signals+0x33/0x2d0
> [    1.681150]  do_exit+0xb6/0xcd0
> [    1.681150]  ? prepare_namespace+0x139/0x16a
> [    1.681150]  ? kernel_init_freeable+0x21b/0x22f
> [    1.681150]  ? rest_init+0x250/0x250
> [    1.681150]  rewind_stack_do_exit+0x17/0x20
> [    1.736632] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x00000009
> [    1.737579] Kernel Offset: 0x23600000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>
> Full log,
> qemu_x86_64,
> https://lkft.validation.linaro.org/scheduler/job/1054430#L573
> qemu_i386:
> https://lkft.validation.linaro.org/scheduler/job/1054335#L571
>
> metadata:
>   git branch: master
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>   git commit: 9603e22104439ddfa6a077f1a0e5d8c662beec6c
>   git describe: v5.5-rc1-308-g9603e2210443
>   make_kernelversion: 5.5.0-rc1
>   kernel-config:
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-mainline/2325/config
>   build-url: https://ci.linaro.org/job/openembedded-lkft-linux-mainline/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-lkft/2325/
>   build-location:
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-mainline/2325
>
> --
> Linaro LKFT
> https://lkft.linaro.org
