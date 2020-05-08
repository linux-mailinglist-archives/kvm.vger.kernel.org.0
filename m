Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5947C1CA9E7
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 13:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEHLqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 07:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726618AbgEHLqy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 07:46:54 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32A4C05BD43;
        Fri,  8 May 2020 04:46:53 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g14so936707wme.1;
        Fri, 08 May 2020 04:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Zeg1isCk/qA15Nm8XJ//2/bcp2eI0rlW3j2tOTx8cFg=;
        b=mNgMV+3to1jAspW72+9rQCzpUFmL0hFu8D4NSJ8zZIzOTKIkfwDygd2ZDsGbNsIa5n
         4ETE4ol86MfEZiXplLnakmSlK3LmKqlElweTKKbkf8D2sPCFsgVoL9Qtwud/AaTFiTtM
         haznP9anbYkKhm6aviLXazBGJGV3eek9G3a189H2I+n4bGu0yU4ur5Hc4VjyhsbkBkWZ
         sIFK6xxY60XnoXHFciqYPpq851WJLz0ER6ReF5UP2bW64EaQz93dSF/JKSo/gCcpWpwR
         y4jAbR9QUfNF/H9wOu8lk7biL0M5fPe5DVTQCkutPCnfMAET2hPDonKNbsGqSUZSs68G
         XsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Zeg1isCk/qA15Nm8XJ//2/bcp2eI0rlW3j2tOTx8cFg=;
        b=ucLZT8qJ9WdWCVyDKZ3WHPFnd+KxcRy7ySGOGZqACE2DT5MaJG90FKw8zFkMlYv64/
         f1VhfDWAeSFz140GD9qLUytZrCp9fAqt8YYOOJlXqIrPRhYrPgDIJoKQOHmkro/v5NCr
         cV3zjsYQa5AghfdpaIyuC1enKgRNFvvQ+n55K4EG5xOkHN00YIp5DPUJj6oPzT/O15Uy
         iL39yKz9/YGQF81uJTckQi9DBvO8ZF4i97sxuig3y6eYkCf1/gzPD4CZlAwnCDb996o4
         xiH8BtTPekw99LNXH3Qnkl+zeWOThd79GxR7CJojomes2+Xv1k+MfixGEFaye6rc8Gli
         lckg==
X-Gm-Message-State: AGi0Pubcv1tNG2D0x6m/FXw81NqKU2OuAhbwxHzoF1202Dt90BVqHf+V
        hu80fZEolsnBvXICCAdrbDopcZ09VMAoKggunEfwICTfOjo=
X-Google-Smtp-Source: APiQypJ3a/GnVTNavr/YqLa//bJaveHv64RQQCCDMj1MEEaZFVw5xhyEagcqDZxhFDFslNNb+pWju0btFqaBPQX2WdA=
X-Received: by 2002:a1c:f211:: with SMTP id s17mr17313372wmc.168.1588938412505;
 Fri, 08 May 2020 04:46:52 -0700 (PDT)
MIME-Version: 1.0
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com> <1588500367-1056-14-git-send-email-chenhc@lemote.com>
In-Reply-To: <1588500367-1056-14-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Fri, 8 May 2020 13:46:39 +0200
Message-ID: <CAHiYmc4sNYYO=diSrXFUyWY15FeyNPiOXqQStnnEMF9As7h=QA@mail.gmail.com>
Subject: Re: [PATCH V3 13/14] KVM: MIPS: Add more MMIO load/store instructions emulation
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        linux-mips@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D0=BD=D0=B5=D0=B4, 3. =D0=BC=D0=B0=D1=98 2020. =D1=83 12:16 Huacai Chen <c=
henhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> This patch add more MMIO load/store instructions emulation, which can
> be observed in QXL and some other device drivers:
>
> 1, LWL, LWR, LDW, LDR, SWL, SWR, SDL and SDR for all MIPS;
> 2, GSLBX, GSLHX, GSLWX, GSLDX, GSSBX, GSSHX, GSSWX and GSSDX for
>    Loongson-3.
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/mips/kvm/emulate.c | 480 ++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 470 insertions(+), 10 deletions(-)
>
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index 3946499..71316fa 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -1604,6 +1604,7 @@ enum emulation_result kvm_mips_emulate_store(union =
mips_instruction inst,
>         enum emulation_result er;
>         u32 rt;
>         void *data =3D run->mmio.data;
> +       unsigned int imme;
>         unsigned long curr_pc;
>
>         /*
> @@ -1661,6 +1662,211 @@ enum emulation_result kvm_mips_emulate_store(unio=
n mips_instruction inst,
>                           vcpu->arch.gprs[rt], *(u8 *)data);
>                 break;
>
> +       case swl_op:
> +               run->mmio.phys_addr =3D kvm_mips_callbacks->gva_to_gpa(
> +                                       vcpu->arch.host_cp0_badvaddr) & (=
~0x3);
> +               run->mmio.len =3D 4;
> +               imme =3D vcpu->arch.host_cp0_badvaddr & 0x3;
> +               switch (imme) {
> +               case 0:
> +                       *(u32 *)data =3D ((*(u32 *)data) & 0xffffff00) |
> +                                       (vcpu->arch.gprs[rt] >> 24);
> +                       break;
> +               case 1:
> +                       *(u32 *)data =3D ((*(u32 *)data) & 0xffff0000) |
> +                                       (vcpu->arch.gprs[rt] >> 16);
> +                       break;
> +               case 2:
> +                       *(u32 *)data =3D ((*(u32 *)data) & 0xff000000) |
> +                                       (vcpu->arch.gprs[rt] >> 8);
> +                       break;
> +               case 3:
> +                       *(u32 *)data =3D vcpu->arch.gprs[rt];
> +                       break;
> +               default:
> +                       break;
> +               }
> +
> +               kvm_debug("[%#lx] OP_SWL: eaddr: %#lx, gpr: %#lx, data: %=
#x\n",
> +                         vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
> +                         vcpu->arch.gprs[rt], *(u32 *)data);
> +               break;
> +
> +       case swr_op:
> +               run->mmio.phys_addr =3D kvm_mips_callbacks->gva_to_gpa(
> +                                       vcpu->arch.host_cp0_badvaddr) & (=
~0x3);
> +               run->mmio.len =3D 4;
> +               imme =3D vcpu->arch.host_cp0_badvaddr & 0x3;
> +               switch (imme) {
> +               case 0:
> +                       *(u32 *)data =3D vcpu->arch.gprs[rt];
> +                       break;
> +               case 1:
> +                       *(u32 *)data =3D ((*(u32 *)data) & 0xff) |
> +                                       (vcpu->arch.gprs[rt] << 8);
> +                       break;
> +               case 2:
> +                       *(u32 *)data =3D ((*(u32 *)data) & 0xffff) |
> +                                       (vcpu->arch.gprs[rt] << 16);
> +                       break;
> +               case 3:
> +                       *(u32 *)data =3D ((*(u32 *)data) & 0xffffff) |
> +                                       (vcpu->arch.gprs[rt] << 24);
> +                       break;
> +               default:
> +                       break;
> +               }
> +
> +               kvm_debug("[%#lx] OP_SWR: eaddr: %#lx, gpr: %#lx, data: %=
#x\n",
> +                         vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
> +                         vcpu->arch.gprs[rt], *(u32 *)data);
> +               break;
> +
> +       case sdl_op:
> +               run->mmio.phys_addr =3D kvm_mips_callbacks->gva_to_gpa(
> +                                       vcpu->arch.host_cp0_badvaddr) & (=
~0x7);
> +
> +               run->mmio.len =3D 8;
> +               imme =3D vcpu->arch.host_cp0_badvaddr & 0x7;
> +               switch (imme) {
> +               case 0:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xffffffffffff=
ff00) |
> +                                       ((vcpu->arch.gprs[rt] >> 56) & 0x=
ff);
> +                       break;
> +               case 1:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xffffffffffff=
0000) |
> +                                       ((vcpu->arch.gprs[rt] >> 48) & 0x=
ffff);
> +                       break;
> +               case 2:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xffffffffff00=
0000) |
> +                                       ((vcpu->arch.gprs[rt] >> 40) & 0x=
ffffff);
> +                       break;
> +               case 3:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xffffffff0000=
0000) |
> +                                       ((vcpu->arch.gprs[rt] >> 32) & 0x=
ffffffff);
> +                       break;
> +               case 4:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xffffff000000=
0000) |
> +                                       ((vcpu->arch.gprs[rt] >> 24) & 0x=
ffffffffff);
> +                       break;
> +               case 5:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xffff00000000=
0000) |
> +                                       ((vcpu->arch.gprs[rt] >> 16) & 0x=
ffffffffffff);
> +                       break;
> +               case 6:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xff0000000000=
0000) |
> +                                       ((vcpu->arch.gprs[rt] >> 8) & 0xf=
fffffffffffff);
> +                       break;
> +               case 7:
> +                       *(u64 *)data =3D vcpu->arch.gprs[rt];
> +                       break;
> +               default:
> +                       break;
> +               }
> +
> +               kvm_debug("[%#lx] OP_SDL: eaddr: %#lx, gpr: %#lx, data: %=
llx\n",
> +                         vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
> +                         vcpu->arch.gprs[rt], *(u64 *)data);
> +               break;
> +
> +       case sdr_op:
> +               run->mmio.phys_addr =3D kvm_mips_callbacks->gva_to_gpa(
> +                                       vcpu->arch.host_cp0_badvaddr) & (=
~0x7);
> +
> +               run->mmio.len =3D 8;
> +               imme =3D vcpu->arch.host_cp0_badvaddr & 0x7;
> +               switch (imme) {
> +               case 0:
> +                       *(u64 *)data =3D vcpu->arch.gprs[rt];
> +                       break;
> +               case 1:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xff) |
> +                                       (vcpu->arch.gprs[rt] << 8);
> +                       break;
> +               case 2:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xffff) |
> +                                       (vcpu->arch.gprs[rt] << 16);
> +                       break;
> +               case 3:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xffffff) |
> +                                       (vcpu->arch.gprs[rt] << 24);
> +                       break;
> +               case 4:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xffffffff) |
> +                                       (vcpu->arch.gprs[rt] << 32);
> +                       break;
> +               case 5:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xffffffffff) =
|
> +                                       (vcpu->arch.gprs[rt] << 40);
> +                       break;
> +               case 6:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xffffffffffff=
) |
> +                                       (vcpu->arch.gprs[rt] << 48);
> +                       break;
> +               case 7:
> +                       *(u64 *)data =3D ((*(u64 *)data) & 0xffffffffffff=
ff) |
> +                                       (vcpu->arch.gprs[rt] << 56);
> +                       break;
> +               default:
> +                       break;
> +               }
> +
> +               kvm_debug("[%#lx] OP_SDR: eaddr: %#lx, gpr: %#lx, data: %=
llx\n",
> +                         vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
> +                         vcpu->arch.gprs[rt], *(u64 *)data);
> +               break;
> +
> +#ifdef CONFIG_CPU_LOONGSON64
> +       case sdc2_op:
> +               rt =3D inst.loongson3_lsdc2_format.rt;
> +               switch (inst.loongson3_lsdc2_format.opcode1) {
> +               /*
> +                * Loongson-3 overridden sdc2 instructions.
> +                * opcode1              instruction
> +                *   0x0          gssbx: store 1 bytes from GPR
> +                *   0x1          gsshx: store 2 bytes from GPR
> +                *   0x2          gsswx: store 4 bytes from GPR
> +                *   0x3          gssdx: store 8 bytes from GPR
> +                */
> +               case 0x0:
> +                       run->mmio.len =3D 1;
> +                       *(u8 *)data =3D vcpu->arch.gprs[rt];
> +
> +                       kvm_debug("[%#lx] OP_GSSBX: eaddr: %#lx, gpr: %#l=
x, data: %#x\n",
> +                                 vcpu->arch.pc, vcpu->arch.host_cp0_badv=
addr,
> +                                 vcpu->arch.gprs[rt], *(u8 *)data);
> +                       break;
> +               case 0x1:
> +                       run->mmio.len =3D 2;
> +                       *(u16 *)data =3D vcpu->arch.gprs[rt];
> +
> +                       kvm_debug("[%#lx] OP_GSSSHX: eaddr: %#lx, gpr: %#=
lx, data: %#x\n",
> +                                 vcpu->arch.pc, vcpu->arch.host_cp0_badv=
addr,
> +                                 vcpu->arch.gprs[rt], *(u16 *)data);
> +                       break;
> +               case 0x2:
> +                       run->mmio.len =3D 4;
> +                       *(u32 *)data =3D vcpu->arch.gprs[rt];
> +
> +                       kvm_debug("[%#lx] OP_GSSWX: eaddr: %#lx, gpr: %#l=
x, data: %#x\n",
> +                                 vcpu->arch.pc, vcpu->arch.host_cp0_badv=
addr,
> +                                 vcpu->arch.gprs[rt], *(u32 *)data);
> +                       break;
> +               case 0x3:
> +                       run->mmio.len =3D 8;
> +                       *(u64 *)data =3D vcpu->arch.gprs[rt];
> +
> +                       kvm_debug("[%#lx] OP_GSSDX: eaddr: %#lx, gpr: %#l=
x, data: %#llx\n",
> +                                 vcpu->arch.pc, vcpu->arch.host_cp0_badv=
addr,
> +                                 vcpu->arch.gprs[rt], *(u64 *)data);
> +                       break;
> +               default:
> +                       kvm_err("Godson Exteneded GS-Store not yet suppor=
ted (inst=3D0x%08x)\n",
> +                               inst.word);
> +                       break;
> +               }
> +               break;
> +#endif
>         default:
>                 kvm_err("Store not yet supported (inst=3D0x%08x)\n",
>                         inst.word);
> @@ -1695,6 +1901,7 @@ enum emulation_result kvm_mips_emulate_load(union m=
ips_instruction inst,
>         enum emulation_result er;
>         unsigned long curr_pc;
>         u32 op, rt;
> +       unsigned int imme;
>
>         rt =3D inst.i_format.rt;
>         op =3D inst.i_format.opcode;
> @@ -1747,6 +1954,162 @@ enum emulation_result kvm_mips_emulate_load(union=
 mips_instruction inst,
>                 run->mmio.len =3D 1;
>                 break;
>
> +       case lwl_op:
> +               run->mmio.phys_addr =3D kvm_mips_callbacks->gva_to_gpa(
> +                                       vcpu->arch.host_cp0_badvaddr) & (=
~0x3);
> +
> +               run->mmio.len =3D 4;
> +               imme =3D vcpu->arch.host_cp0_badvaddr & 0x3;
> +               switch (imme) {
> +               case 0:
> +                       vcpu->mmio_needed =3D 3;  /* 1 byte */
> +                       break;
> +               case 1:
> +                       vcpu->mmio_needed =3D 4;  /* 2 bytes */
> +                       break;
> +               case 2:
> +                       vcpu->mmio_needed =3D 5;  /* 3 bytes */
> +                       break;
> +               case 3:
> +                       vcpu->mmio_needed =3D 6;  /* 4 bytes */
> +                       break;
> +               default:
> +                       break;
> +               }
> +               break;
> +
> +       case lwr_op:
> +               run->mmio.phys_addr =3D kvm_mips_callbacks->gva_to_gpa(
> +                                       vcpu->arch.host_cp0_badvaddr) & (=
~0x3);
> +
> +               run->mmio.len =3D 4;
> +               imme =3D vcpu->arch.host_cp0_badvaddr & 0x3;
> +               switch (imme) {
> +               case 0:
> +                       vcpu->mmio_needed =3D 7;  /* 4 bytes */
> +                       break;
> +               case 1:
> +                       vcpu->mmio_needed =3D 8;  /* 3 bytes */
> +                       break;
> +               case 2:
> +                       vcpu->mmio_needed =3D 9;  /* 2 bytes */
> +                       break;
> +               case 3:
> +                       vcpu->mmio_needed =3D 10; /* 1 byte */
> +                       break;
> +               default:
> +                       break;
> +               }
> +               break;
> +
> +       case ldl_op:
> +               run->mmio.phys_addr =3D kvm_mips_callbacks->gva_to_gpa(
> +                                       vcpu->arch.host_cp0_badvaddr) & (=
~0x7);
> +
> +               run->mmio.len =3D 8;
> +               imme =3D vcpu->arch.host_cp0_badvaddr & 0x7;
> +               switch (imme) {
> +               case 0:
> +                       vcpu->mmio_needed =3D 11; /* 1 byte */
> +                       break;
> +               case 1:
> +                       vcpu->mmio_needed =3D 12; /* 2 bytes */
> +                       break;
> +               case 2:
> +                       vcpu->mmio_needed =3D 13; /* 3 bytes */
> +                       break;
> +               case 3:
> +                       vcpu->mmio_needed =3D 14; /* 4 bytes */
> +                       break;
> +               case 4:
> +                       vcpu->mmio_needed =3D 15; /* 5 bytes */
> +                       break;
> +               case 5:
> +                       vcpu->mmio_needed =3D 16; /* 6 bytes */
> +                       break;
> +               case 6:
> +                       vcpu->mmio_needed =3D 17; /* 7 bytes */
> +                       break;
> +               case 7:
> +                       vcpu->mmio_needed =3D 18; /* 8 bytes */
> +                       break;
> +               default:
> +                       break;
> +               }
> +               break;
> +
> +       case ldr_op:
> +               run->mmio.phys_addr =3D kvm_mips_callbacks->gva_to_gpa(
> +                                       vcpu->arch.host_cp0_badvaddr) & (=
~0x7);
> +
> +               run->mmio.len =3D 8;
> +               imme =3D vcpu->arch.host_cp0_badvaddr & 0x7;
> +               switch (imme) {
> +               case 0:
> +                       vcpu->mmio_needed =3D 19; /* 8 bytes */
> +                       break;
> +               case 1:
> +                       vcpu->mmio_needed =3D 20; /* 7 bytes */
> +                       break;
> +               case 2:
> +                       vcpu->mmio_needed =3D 21; /* 6 bytes */
> +                       break;
> +               case 3:
> +                       vcpu->mmio_needed =3D 22; /* 5 bytes */
> +                       break;
> +               case 4:
> +                       vcpu->mmio_needed =3D 23; /* 4 bytes */
> +                       break;
> +               case 5:
> +                       vcpu->mmio_needed =3D 24; /* 3 bytes */
> +                       break;
> +               case 6:
> +                       vcpu->mmio_needed =3D 25; /* 2 bytes */
> +                       break;
> +               case 7:
> +                       vcpu->mmio_needed =3D 26; /* 1 byte */
> +                       break;
> +               default:
> +                       break;
> +               }
> +               break;
> +
> +#ifdef CONFIG_CPU_LOONGSON64
> +       case ldc2_op:
> +               rt =3D inst.loongson3_lsdc2_format.rt;
> +               switch (inst.loongson3_lsdc2_format.opcode1) {
> +               /*
> +                * Loongson-3 overridden ldc2 instructions.
> +                * opcode1              instruction
> +                *   0x0          gslbx: store 1 bytes from GPR
> +                *   0x1          gslhx: store 2 bytes from GPR
> +                *   0x2          gslwx: store 4 bytes from GPR
> +                *   0x3          gsldx: store 8 bytes from GPR
> +                */
> +               case 0x0:
> +                       run->mmio.len =3D 1;
> +                       vcpu->mmio_needed =3D 27; /* signed */
> +                       break;
> +               case 0x1:
> +                       run->mmio.len =3D 2;
> +                       vcpu->mmio_needed =3D 28; /* signed */
> +                       break;
> +               case 0x2:
> +                       run->mmio.len =3D 4;
> +                       vcpu->mmio_needed =3D 29; /* signed */
> +                       break;
> +               case 0x3:
> +                       run->mmio.len =3D 8;
> +                       vcpu->mmio_needed =3D 30; /* signed */
> +                       break;
> +               default:
> +                       kvm_err("Godson Exteneded GS-Load for float not y=
et supported (inst=3D0x%08x)\n",
> +                               inst.word);
> +                       break;
> +               }
> +               break;
> +#endif
> +
>         default:
>                 kvm_err("Load not yet supported (inst=3D0x%08x)\n",
>                         inst.word);
> @@ -2612,28 +2975,125 @@ enum emulation_result kvm_mips_complete_mmio_loa=
d(struct kvm_vcpu *vcpu,
>
>         switch (run->mmio.len) {
>         case 8:
> -               *gpr =3D *(s64 *)run->mmio.data;
> +               switch (vcpu->mmio_needed) {
> +               case 11:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffffffffffffff) |
> +                               (((*(s64 *)run->mmio.data) & 0xff) << 56)=
;
> +                       break;
> +               case 12:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffffffffffff) |
> +                               (((*(s64 *)run->mmio.data) & 0xffff) << 4=
8);
> +                       break;
> +               case 13:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffffffffff) |
> +                               (((*(s64 *)run->mmio.data) & 0xffffff) <<=
 40);
> +                       break;
> +               case 14:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffffffff) |
> +                               (((*(s64 *)run->mmio.data) & 0xffffffff) =
<< 32);
> +                       break;
> +               case 15:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffffff) |
> +                               (((*(s64 *)run->mmio.data) & 0xffffffffff=
) << 24);
> +                       break;
> +               case 16:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffff) |
> +                               (((*(s64 *)run->mmio.data) & 0xffffffffff=
ff) << 16);
> +                       break;
> +               case 17:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ff) |
> +                               (((*(s64 *)run->mmio.data) & 0xffffffffff=
ffff) << 8);
> +                       break;
> +               case 18:
> +               case 19:
> +                       *gpr =3D *(s64 *)run->mmio.data;
> +                       break;
> +               case 20:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ff00000000000000) |
> +                               ((((*(s64 *)run->mmio.data)) >> 8) & 0xff=
ffffffffffff);
> +                       break;
> +               case 21:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffff000000000000) |
> +                               ((((*(s64 *)run->mmio.data)) >> 16) & 0xf=
fffffffffff);
> +                       break;
> +               case 22:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffffff0000000000) |
> +                               ((((*(s64 *)run->mmio.data)) >> 24) & 0xf=
fffffffff);
> +                       break;
> +               case 23:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffffffff00000000) |
> +                               ((((*(s64 *)run->mmio.data)) >> 32) & 0xf=
fffffff);
> +                       break;
> +               case 24:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffffffffff000000) |
> +                               ((((*(s64 *)run->mmio.data)) >> 40) & 0xf=
fffff);
> +                       break;
> +               case 25:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffffffffffff0000) |
> +                               ((((*(s64 *)run->mmio.data)) >> 48) & 0xf=
fff);
> +                       break;
> +               case 26:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffffffffffffff00) |
> +                               ((((*(s64 *)run->mmio.data)) >> 56) & 0xf=
f);
> +                       break;
> +               default:
> +                       *gpr =3D *(s64 *)run->mmio.data;
> +               }
>                 break;
>
>         case 4:
> -               if (vcpu->mmio_needed =3D=3D 2)
> -                       *gpr =3D *(s32 *)run->mmio.data;
> -               else
> +               switch (vcpu->mmio_needed) {
> +               case 1:
>                         *gpr =3D *(u32 *)run->mmio.data;
> +                       break;
> +               case 2:
> +                       *gpr =3D *(s32 *)run->mmio.data;
> +                       break;
> +               case 3:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffffff) |
> +                               (((*(s32 *)run->mmio.data) & 0xff) << 24)=
;
> +                       break;
> +               case 4:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffff) |
> +                               (((*(s32 *)run->mmio.data) & 0xffff) << 1=
6);
> +                       break;
> +               case 5:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ff) |
> +                               (((*(s32 *)run->mmio.data) & 0xffffff) <<=
 8);
> +                       break;
> +               case 6:
> +               case 7:
> +                       *gpr =3D *(s32 *)run->mmio.data;
> +                       break;
> +               case 8:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ff000000) |
> +                               ((((*(s32 *)run->mmio.data)) >> 8) & 0xff=
ffff);
> +                       break;
> +               case 9:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffff0000) |
> +                               ((((*(s32 *)run->mmio.data)) >> 16) & 0xf=
fff);
> +                       break;
> +               case 10:
> +                       *gpr =3D (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0x=
ffffff00) |
> +                               ((((*(s32 *)run->mmio.data)) >> 24) & 0xf=
f);
> +                       break;
> +               default:
> +                       *gpr =3D *(s32 *)run->mmio.data;
> +               }
>                 break;
>
>         case 2:
> -               if (vcpu->mmio_needed =3D=3D 2)
> -                       *gpr =3D *(s16 *) run->mmio.data;
> -               else
> +               if (vcpu->mmio_needed =3D=3D 1)
>                         *gpr =3D *(u16 *)run->mmio.data;
> +               else
> +                       *gpr =3D *(s16 *)run->mmio.data;
>
>                 break;
>         case 1:
> -               if (vcpu->mmio_needed =3D=3D 2)
> -                       *gpr =3D *(s8 *) run->mmio.data;
> +               if (vcpu->mmio_needed =3D=3D 1)
> +                       *gpr =3D *(u8 *)run->mmio.data;
>                 else
> -                       *gpr =3D *(u8 *) run->mmio.data;
> +                       *gpr =3D *(s8 *)run->mmio.data;
>                 break;
>         }
>
> --
> 2.7.0
>

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
