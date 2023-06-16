Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEC6732956
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 09:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242726AbjFPHzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 03:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245526AbjFPHzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 03:55:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1B6272A;
        Fri, 16 Jun 2023 00:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C94460F97;
        Fri, 16 Jun 2023 07:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1B8C433CD;
        Fri, 16 Jun 2023 07:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686902114;
        bh=5MAFU9ZdTtSFnKEYh2P4fhNGE5T+Jl+yV+3oc8BBvb4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TIRq9iWICeIWto5tAmUUfnGprcoLUzfbCyAYSsbglEUXMY/4YwSPwkUmo+xRyXiyW
         QtioeoNBEOXvXoG8J6TG7AfEWMakxHM1qX65EvjvTcDeKcLGUT1VtKY+N/+dJWl4Qx
         M78Q9RIqbHJtRV8X0sK12dVYQwXgsfIc2BSTVi7Px4xXOIajqVfQKm8ct8U9UR5idU
         ML4r+EcOVQCIPxNkq8SVvjUf3Cn3WjphoAc00Q3pnyJyBmtoidlTZVZzwmlypKJD8V
         xFyrrTqYYpSpn/de+BTHengk0f4lrfrFmu7jkb3ixcvjHzdLci7G/Rcr9nO5zvjso3
         XjL/Q7YJ1jiVw==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-51a2fa4a45eso514630a12.0;
        Fri, 16 Jun 2023 00:55:14 -0700 (PDT)
X-Gm-Message-State: AC+VfDynNFC1ZcyXrGOa6lB22ZUoDa0SaKGNcu29uD6OP3gR356nBi9H
        GworOu9SyslVL48QcOuldzQJC/j9b4SzsBcmQPA=
X-Google-Smtp-Source: ACHHUZ7dlnpB4OXyBQMB6LvoPEGTMQAnaBYWnwWyzhGsxd7RRk8Ct9fMr9qxwI96hZX4J/Oo/rlTPxJGLV87D9NZ2jA=
X-Received: by 2002:a05:6402:447:b0:51a:2559:cacc with SMTP id
 p7-20020a056402044700b0051a2559caccmr684657edw.19.1686902112850; Fri, 16 Jun
 2023 00:55:12 -0700 (PDT)
MIME-Version: 1.0
References: <1596005919-29365-5-git-send-email-chenhc@lemote.com> <20230616071831.1452507-1-yuzhao@google.com>
In-Reply-To: <20230616071831.1452507-1-yuzhao@google.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Fri, 16 Jun 2023 15:55:00 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5YiJqGuSrMHSK7NuiefLyQhOnvOqbm4SO73ZY+dem4+A@mail.gmail.com>
Message-ID: <CAAhV-H5YiJqGuSrMHSK7NuiefLyQhOnvOqbm4SO73ZY+dem4+A@mail.gmail.com>
Subject: Re: [PATCH 5/5] MAINTAINERS: Update KVM/MIPS maintainers
To:     Yu Zhao <yuzhao@google.com>
Cc:     aleksandar.qemu.devel@gmail.com, tsbogend@alpha.franken.de,
        jiaxun.yang@flygoat.com, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, pbonzini@redhat.com,
        robh+dt@kernel.org, zhangfx@lemote.com
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

On Fri, Jun 16, 2023 at 3:18=E2=80=AFPM Yu Zhao <yuzhao@google.com> wrote:
>
> On Tue, Jul 28, 2020 at 23:58:20PM -0700, Huacai Chen wrote:
> > James Hogan has become inactive for a long time and leaves KVM for MIPS
> > orphan. I'm working on KVM/Loongson and attempt to make it upstream bot=
h
> > in kernel and QEMU, while Aleksandar Markovic is already a maintainer o=
f
> > QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have already
> > made some contributions in kernel and QEMU. If possible, we want to tak=
e
> > the KVM/MIPS maintainership.
> >
> > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > ---
> >  MAINTAINERS | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index bddc79a..5f9c2fd 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9441,9 +9441,11 @@ F:     arch/arm64/kvm/
> >  F:   include/kvm/arm_*
> >
> >  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> > +M:   Huacai Chen <chenhc@lemote.com>
> > +M:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> >  L:   linux-mips@vger.kernel.org
> >  L:   kvm@vger.kernel.org
> > -S:   Orphan
> > +S:   Maintained
> >  F:   arch/mips/include/asm/kvm*
> >  F:   arch/mips/include/uapi/asm/kvm*
> >  F:   arch/mips/kvm/
>
> Hi,
>
> Is kvm/mips still maintained? Thanks.
>
> I tried v6.4-rc6 and hit the following crash. It seems it has been broken=
 since
>
>   commit 45c7e8af4a5e3f0bea4ac209eea34118dd57ac64
>   Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>   Date:   Mon Mar 1 16:29:57 2021 +0100
>
>       MIPS: Remove KVM_TE support
>
>       After removal of the guest part of KVM TE (trap and emulate), also =
remove
>       the host part.
>
> which deletes kvm_mips_commpage_init() and leaves vcpu->arch.cop0 NULL.
I think your analysis is correct, are you interested in fixing it?

Huacai

>
> (Or probably I've missed something.)
>
>   $ sudo qemu-system-mips64el -M accel=3Dkvm -nographic
>   CPU 2 Unable to handle kernel paging request at virtual address 0000000=
000000300, epc =3D=3D ffffffff81148288, ra =3D=3D ffffffff81148228
>   Oops[#1]:
>   CPU: 2 PID: 339 Comm: qemu-system-mip Not tainted 6.4.0-rc6-00049-g62d8=
779610bb #3
>   $ 0   : 0000000000000000 0000000034109ce1 0000000000400004 ffffffff81b5=
0200
>   $ 4   : 8000000001d71c00 0000000000000001 0000000000000000 000000000000=
0000
>   $ 8   : 000000a64082989c 000000000000001f 000000000000000a 000000000000=
0060
>   $12   : ffffffff81935390 eb0ffdb582d1ed00 0000000000000001 000000000000=
0000
>   $16   : 0000000000000000 8000000005193330 8000000005193330 80000000058b=
6000
>   $20   : 80000000058b4a00 ffffffff81b5f110 0000000000000000 ffffffffffff=
ffff
>   $24   : 0000000000000001 ffffffff811331a0
>   $28   : 80000000021e8000 80000000021ebc90 000000fff1369160 ffffffff8114=
8228
>   Hi    : 0000000000000000
>   Lo    : 00000000083e6217
>   epc   : ffffffff81148288 kvm_vz_vcpu_setup+0xa8/0x2d8
>   ra    : ffffffff81148228 kvm_vz_vcpu_setup+0x48/0x2d8
>   Status: 34109ce3      KX SX UX KERNEL EXL IE
>   Cause : 0080000c (ExcCode 03)
>   BadVA : 0000000000000300
>   PrId  : 000d9602 (Cavium Octeon III)
>   Modules linked in:
>   Process qemu-system-mip (pid: 339, threadinfo=3D0000000029889cef, task=
=3D0000000070662173, tls=3D000000fff1371140)
>   Stack : 8000000005193330 80000000058b4a00 80000000058b4000 ffffffff8114=
2184
>           80000000021ebcd8 eb0ffdb582d1ed00 ffffffff81b50000 ffffffff81b5=
0000
>           800000000537e000 0000000000000000 800000000537e920 800000000519=
3330
>           ffffffff81c10000 ffffffff8113fd94 0000000000000cc0 000000000ffd=
c000
>           000000ffdc000000 000000ffdc000010 0000000000000255 800000000341=
6700
>           8000000005923ff8 0000000000000000 0000000000000000 000000000000=
0000
>           8000000004775000 800000004d91dd68 0000000000000000 eb0ffdb582d1=
ed00
>           0000000000000801 0000000000000255 ffffffff81b526a8 000000000000=
0001
>           0000000000000001 ffffffff812c4b84 8000000002238180 000000000000=
0255
>           0000000000000000 eb0ffdb582d1ed00 000000ffdc000010 800000000371=
7200
>           ...
>   Call Trace:
>   [<ffffffff81148288>] kvm_vz_vcpu_setup+0xa8/0x2d8
>   [<ffffffff81142184>] kvm_arch_vcpu_create+0x12c/0x1c0
>   [<ffffffff8113fd94>] kvm_vm_ioctl+0x5e4/0xda0
>   [<ffffffff812ef070>] sys_ioctl+0xb8/0x100
>   [<ffffffff81125930>] syscall_common+0x34/0x58
>
>   Code: 3c040040  24840004  00441025 <fe020300> 40626001  3c04ff80  00441=
024  3c048000  7c42f803
>
>   ---[ end trace 0000000000000000 ]---
