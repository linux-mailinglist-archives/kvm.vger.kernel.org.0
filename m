Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD9173D90C
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 10:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjFZIAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 04:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjFZIAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 04:00:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122B383;
        Mon, 26 Jun 2023 01:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E0EF60C98;
        Mon, 26 Jun 2023 08:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF8FC433C0;
        Mon, 26 Jun 2023 08:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687766445;
        bh=T1tbJfkjS5eRGUlVA1w5bl75ZKTGbikg5TvYBsK6vz8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KJnDkEszUl7KXjyHcJ5/tG2RlxctOopFKXBN1BOSbBDWWj3y6ozdYa8ErGAg2IvZX
         740EmJFTMZHtGWUW4LP6h+ZTAQu4oZ18h+6+zZYudyaCXwfcF6zDvwRd1MWqvK+i5j
         2npqZqqt8Xp4fwlbPa8Z7/J9U9GzkC1gaPQdpjknZWbhW68E0I2dKnsCil/32M8mr1
         XwCEGi4YhUiL94o7NGxLQwVHvBb9OIXpAdncCmGFYMGE5PdnqKyeYeoXmHV1+PnMs0
         m8xYP8VbGosYmM7LLl2L2zkB4sMWcZtL2opbBt9CytWnLRG2wRmJgEKMc24wMfQ8Yq
         8WcFGIMHpPMWA==
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2b69923a715so18035851fa.0;
        Mon, 26 Jun 2023 01:00:44 -0700 (PDT)
X-Gm-Message-State: AC+VfDzrG3oxNIl15xJGXv7/kREncNRyy/YVOOiVwfaU+8dffC43yvd6
        iLGVYPg/LHL/wSF3TOHGAm0jedeNFx7Vy9QL2Hs=
X-Google-Smtp-Source: ACHHUZ6AOZleqFybI7INzAGKqyntRgvsIgQSBHFa+k2iErhcP/yXQTlyHzdCpuCKuhf/7wkwySyPSMR/9dQI1JynCrg=
X-Received: by 2002:a2e:961a:0:b0:2b5:7af9:f399 with SMTP id
 v26-20020a2e961a000000b002b57af9f399mr13939696ljh.45.1687766443006; Mon, 26
 Jun 2023 01:00:43 -0700 (PDT)
MIME-Version: 1.0
References: <1596005919-29365-5-git-send-email-chenhc@lemote.com>
 <20230616071831.1452507-1-yuzhao@google.com> <20230616082322.GA7323@alpha.franken.de>
 <ZI0R76Fx25Q2EThZ@google.com> <CAAhV-H7Hdw6Ye46OOoNyXtZfO9smMiPz+hRLq8vEvmgQCMGuFQ@mail.gmail.com>
 <CAOUHufYfEijFPPOXS43URKksQzd-YAPfekej9suH07w2etQ3SA@mail.gmail.com>
In-Reply-To: <CAOUHufYfEijFPPOXS43URKksQzd-YAPfekej9suH07w2etQ3SA@mail.gmail.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Mon, 26 Jun 2023 16:00:30 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5LYRA92XaaeZ5=fo0xiYzQ-2Ejg8yzY_XavYLdYau9BA@mail.gmail.com>
Message-ID: <CAAhV-H5LYRA92XaaeZ5=fo0xiYzQ-2Ejg8yzY_XavYLdYau9BA@mail.gmail.com>
Subject: Re: [PATCH 5/5] MAINTAINERS: Update KVM/MIPS maintainers
To:     Yu Zhao <yuzhao@google.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        jiaxun.yang@flygoat.com, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, pbonzini@redhat.com, robh+dt@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Zhao,

On Sun, Jun 18, 2023 at 10:51=E2=80=AFAM Yu Zhao <yuzhao@google.com> wrote:
>
> On Sat, Jun 17, 2023 at 8:13=E2=80=AFPM Huacai Chen <chenhuacai@kernel.or=
g> wrote:
> >
> > On Sat, Jun 17, 2023 at 9:52=E2=80=AFAM Yu Zhao <yuzhao@google.com> wro=
te:
> > >
> > > On Fri, Jun 16, 2023 at 10:23:22AM +0200, Thomas Bogendoerfer wrote:
> > > > On Fri, Jun 16, 2023 at 01:18:31AM -0600, Yu Zhao wrote:
> > > > > On Tue, Jul 28, 2020 at 23:58:20PM -0700, Huacai Chen wrote:
> > > > > > James Hogan has become inactive for a long time and leaves KVM =
for MIPS
> > > > > > orphan. I'm working on KVM/Loongson and attempt to make it upst=
ream both
> > > > > > in kernel and QEMU, while Aleksandar Markovic is already a main=
tainer of
> > > > > > QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have=
 already
> > > > > > made some contributions in kernel and QEMU. If possible, we wan=
t to take
> > > > > > the KVM/MIPS maintainership.
> > > > > >
> > > > > > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > > > > Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.c=
om>
> > > > > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > > > > ---
> > > > > >  MAINTAINERS | 4 +++-
> > > > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > > > index bddc79a..5f9c2fd 100644
> > > > > > --- a/MAINTAINERS
> > > > > > +++ b/MAINTAINERS
> > > > > > @@ -9441,9 +9441,11 @@ F: arch/arm64/kvm/
> > > > > >  F:       include/kvm/arm_*
> > > > > >
> > > > > >  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> > > > > > +M:       Huacai Chen <chenhc@lemote.com>
> > > > > > +M:       Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > > > > >  L:       linux-mips@vger.kernel.org
> > > > > >  L:       kvm@vger.kernel.org
> > > > > > -S:       Orphan
> > > > > > +S:       Maintained
> > > > > >  F:       arch/mips/include/asm/kvm*
> > > > > >  F:       arch/mips/include/uapi/asm/kvm*
> > > > > >  F:       arch/mips/kvm/
> > > > >
> > > > > Hi,
> > > > >
> > > > > Is kvm/mips still maintained? Thanks.
> > > > >
> > > > > I tried v6.4-rc6 and hit the following crash. It seems it has bee=
n broken since
> > > > >
> > > > >   commit 45c7e8af4a5e3f0bea4ac209eea34118dd57ac64
> > > > >   Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > > > >   Date:   Mon Mar 1 16:29:57 2021 +0100
> > > > >
> > > > >       MIPS: Remove KVM_TE support
> > > >
> > > > ok, I see what I missed when removing TE support, d'oh. Does the pa=
tch
> > > > below fix the issue for you ?
> > >
> > > Thanks!
> > >
> > > It made some progress but somehow crashed the guest kernel.
> > >
> > > $ qemu-system-mips64el --version
> > > QEMU emulator version 7.2.2 (Debian 1:7.2+dfsg-7)
> > > Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project develope=
rs
> > >
> > > # w/o KVM
> > >
> > >   # malta: working (but slow)
> > >
> > >     $ qemu-system-mips64el -nographic -kernel lede-malta-le64-vmlinux=
-initramfs.elf
> > >     [    0.000000] Linux version 4.9.58 (buildbot@builds) (gcc versio=
n 5.5.0 (LEDE GCC 5.5.0 r5218-f90f94d) ) #0 SMP Wed Nov 1 21:08:14 2017
> > >     ...
> > >
> > >   # loongson3-virt: hanged
> > >
> > >     $ qemu-system-mips64el -M loongson3-virt -m 512m -nographic -kern=
el vmlinuz-6.1.0-9-loongson-3 -initrd initrd.gz
> > >     [    0.000000] Linux version 6.1.0-9-loongson-3 (debian-kernel@li=
sts.debian.org) (gcc-12 (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for=
 Debian) 2.40) #1 SMP PREEMPT Debian 6.1.27-1 (2023-05-08)
> > >     ...
> > >     [    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x000=
000009fffffff]
> > >
> > > # w/ KVM
> > >
> > >   # malta: qemu error
> > >
> > >     $ sudo qemu-system-mips64el -M accel=3Dkvm -nographic -kernel led=
e-malta-le64-vmlinux-initramfs.elf
> > >     qemu-system-mips64el: KVM guest kernels must be linked in useg. D=
id you forget to enable CONFIG_KVM_GUEST?
> > >
> > >   # loongson3-virt: qemu error
> > >
> > >     $ sudo qemu-system-mips64el -M loongson3-virt,accel=3Dkvm -m 512m=
 -nographic -kernel vmlinuz-6.1.0-9-loongson-3 -initrd initrd.gz
> > >     qemu-system-mips64el: ../../accel/kvm/kvm-all.c:2310: kvm_init: A=
ssertion `TARGET_PAGE_SIZE <=3D qemu_real_host_page_size()' failed.
> > >     Aborted
> > >
> > > $ qemu-system-mips64el --version
> > > QEMU emulator version 8.0.2 (Debian 1:8.0.2+dfsg-1)
> > > Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project develope=
rs
> > >
> > > # w/o KVM
> > >
> > >   # malta: no change
> > >   # loongson3-virt: no change
> > >
> > > # w/ KVM
> > >
> > >   # loongson3-virt: the same qemu error
> > >
> > >   # malta: booted very fast but guest crashed:
> > >
> > > $ sudo qemu-system-mips64el -M accel=3Dkvm -nographic -kernel lede-ma=
lta-le64-vmlinux-initramfs.elf
> > > [    0.000000] Linux version 4.9.58 (buildbot@builds) (gcc version 5.=
5.0 (LEDE GCC 5.5.0 r5218-f90f94d) ) #0 SMP Wed Nov 1 21:08:14 2017
>
> ...
>
> > > [    0.402570] Kernel panic - not syncing: Fatal exception
> > > [    0.404311] Rebooting in 1 seconds..
> > > [    2.385408] Reboot failed -- System halted
> > >
> > > openwrt/malta: https://downloads.openwrt.org/snapshots/targets/malta/=
le64/
> > > debian/loongson-3: https://deb.debian.org/debian/dists/sid/main/insta=
ller-mips64el/current/images/
> > > debian/malta: not working
> >
> > I have reproduced the problem, and I hope I can fix it in a few days,
>
> That's great. Thanks a lot!
I fixed the KVM problems on Loongson [1][2][3]. However, you have
tried [1] but still have problems, while [2] and [3] are specific to
Loongson, so maybe you are still unable to use KVM.

[1] https://lore.kernel.org/linux-mips/20230626074919.1871944-1-chenhuacai@=
loongson.cn/T/#u
[2] https://lore.kernel.org/linux-mips/20230626075014.1872632-1-chenhuacai@=
loongson.cn/T/#u
[3] https://lore.kernel.org/linux-mips/20230626075047.1872818-1-chenhuacai@=
loongson.cn/T/#u

Huacai
