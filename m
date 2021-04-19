Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2D3364853
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhDSQgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhDSQgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 12:36:20 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3474CC06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:35:50 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id i21-20020a05600c3555b029012eae2af5d4so8995990wmq.4
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=c6rsMVddYLlYCaJUI+XJS7F5KyY+OC2FMNBAbeGP8xs=;
        b=yRxrp+exFf2p7jqTepXrQW1PD54fbris5EMwRyYszAhjlxzUwYzUtvNfBjfQYWNp1d
         rM243FMVHyH6mzrjzcNyktMW7zFcqac23PfNU1xL1Dwx4zEI27TM5N3Zz+n0Nknk7Vxl
         leNBjE8RNxiJ7Wp+uLD6YehHA5iBO/lJr/1POrrGIC4fb/2oaKP40G+PpDuCwlPZ7qu1
         TU/J0anV/S5DMYTdUQU3VMVxiG5cSKc107hv0SnM4zaut0KVdPlJPKyHihDm6nZnxRr2
         VL7O5dy22+UsgGWWh9Xyf/FANcz8bTQoZ3/tHRZRHbb2nKI4zyKEPoLZJVLfoCvXF+TA
         1rtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=c6rsMVddYLlYCaJUI+XJS7F5KyY+OC2FMNBAbeGP8xs=;
        b=tZQYBegzS0GTWXpEM5KYWnFUksoznp+9HdXdF79gZjnYLosNimn82ST9BZR0Ymzi1/
         hFd018jX7J35YUwDxvSdOdCVwryk3eSQh15mfVd7R0XGWrlt/v9ZE0qFRs5CxMVE3ZmZ
         3IUc7YD2aueDhxKQOf6KzTWQEXaegdPhIMI5cy+oyCBteWPI+3BkOwrGoi6hsNuAGSzx
         Fzwe1Ks6Wb+oISpO5oP9mFOKM5YnvD4Dx7h1+77g2pKp4+tAXPpGxcQiFJBFHAi5rrXN
         OA1HXGOg514U/+d3thoBtWobDLPbRhmpHLylZ4AZZcuz78wz5oWpdsBDVFu7MxmxWhjo
         Drjw==
X-Gm-Message-State: AOAM530we+Qkt0sw/YIDCkpsnTxktqtdFAeq0pknlLv+oKlgog5iEhL0
        3L2O+J5haZ/ShW+EQQj3Gmu6EQ==
X-Google-Smtp-Source: ABdhPJyLVwj1jDMESEtrneaKRIgUWvr8tKmYJIZ6Oacu/z43ykTFoYHh2TAiZUlyfQz/dMdhWsuaXw==
X-Received: by 2002:a1c:9d90:: with SMTP id g138mr22127778wme.156.1618850148861;
        Mon, 19 Apr 2021 09:35:48 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id c18sm23350795wrn.92.2021.04.19.09.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 09:35:47 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 194171FF7E;
        Mon, 19 Apr 2021 17:35:47 +0100 (BST)
References: <20210401144152.1031282-1-mlevitsk@redhat.com>
 <20210401144152.1031282-3-mlevitsk@redhat.com>
User-agent: mu4e 1.5.11; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: Re: [PATCH 2/2] gdbstub: implement NOIRQ support for single step on
 KVM, when kvm's KVM_GUESTDBG_BLOCKIRQ debug flag is supported.
Date:   Mon, 19 Apr 2021 17:29:25 +0100
In-reply-to: <20210401144152.1031282-3-mlevitsk@redhat.com>
Message-ID: <871rb69qqk.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Maxim Levitsky <mlevitsk@redhat.com> writes:

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  accel/kvm/kvm-all.c  | 25 +++++++++++++++++++
>  gdbstub.c            | 59 ++++++++++++++++++++++++++++++++++++--------
>  include/sysemu/kvm.h | 13 ++++++++++
>  3 files changed, 87 insertions(+), 10 deletions(-)
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index b6d9f92f15..bc7955fb19 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -147,6 +147,8 @@ bool kvm_vm_attributes_allowed;
>  bool kvm_direct_msi_allowed;
>  bool kvm_ioeventfd_any_length_allowed;
>  bool kvm_msi_use_devid;
> +bool kvm_has_guest_debug;
> +int kvm_sstep_flags;
>  static bool kvm_immediate_exit;
>  static hwaddr kvm_max_slot_size =3D ~0;
>=20=20
> @@ -2186,6 +2188,25 @@ static int kvm_init(MachineState *ms)
>      kvm_ioeventfd_any_length_allowed =3D
>          (kvm_check_extension(s, KVM_CAP_IOEVENTFD_ANY_LENGTH) > 0);
>=20=20
> +    kvm_has_guest_debug =3D
> +        (kvm_check_extension(s, KVM_CAP_SET_GUEST_DEBUG) > 0);
> +
> +    kvm_sstep_flags =3D 0;
> +
> +    if (kvm_has_guest_debug) {
> +        /* Assume that single stepping is supported */
> +        kvm_sstep_flags =3D SSTEP_ENABLE;
> +
> +        int guest_debug_flags =3D
> +            kvm_check_extension(s, KVM_CAP_SET_GUEST_DEBUG2);
> +
> +        if (guest_debug_flags > 0) {
> +            if (guest_debug_flags & KVM_GUESTDBG_BLOCKIRQ) {
> +                kvm_sstep_flags |=3D SSTEP_NOIRQ;
> +            }
> +        }
> +    }
> +
>      kvm_state =3D s;
>=20=20
>      ret =3D kvm_arch_init(ms, s);
> @@ -2796,6 +2817,10 @@ int kvm_update_guest_debug(CPUState *cpu, unsigned=
 long reinject_trap)
>=20=20
>      if (cpu->singlestep_enabled) {
>          data.dbg.control |=3D KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLES=
TEP;
> +
> +        if (cpu->singlestep_enabled & SSTEP_NOIRQ) {
> +            data.dbg.control |=3D KVM_GUESTDBG_BLOCKIRQ;
> +        }
>      }
>      kvm_arch_update_guest_debug(cpu, &data.dbg);
>=20=20
> diff --git a/gdbstub.c b/gdbstub.c
> index 054665e93e..f789ded99d 100644
> --- a/gdbstub.c
> +++ b/gdbstub.c
> @@ -369,12 +369,11 @@ typedef struct GDBState {
>      gdb_syscall_complete_cb current_syscall_cb;
>      GString *str_buf;
>      GByteArray *mem_buf;
> +    int sstep_flags;
> +    int supported_sstep_flags;
>  } GDBState;
>=20=20
> -/* By default use no IRQs and no timers while single stepping so as to
> - * make single stepping like an ICE HW step.
> - */
> -static int sstep_flags =3D SSTEP_ENABLE|SSTEP_NOIRQ|SSTEP_NOTIMER;
> +static GDBState gdbserver_state;
>=20=20
>  /* Retrieves flags for single step mode. */
>  static int get_sstep_flags(void)
> @@ -386,11 +385,10 @@ static int get_sstep_flags(void)
>      if (replay_mode !=3D REPLAY_MODE_NONE) {
>          return SSTEP_ENABLE;
>      } else {
> -        return sstep_flags;
> +        return gdbserver_state.sstep_flags;
>      }
>  }
>=20=20
> -static GDBState gdbserver_state;
>=20=20
>  static void init_gdbserver_state(void)
>  {
> @@ -400,6 +398,23 @@ static void init_gdbserver_state(void)
>      gdbserver_state.str_buf =3D g_string_new(NULL);
>      gdbserver_state.mem_buf =3D g_byte_array_sized_new(MAX_PACKET_LENGTH=
);
>      gdbserver_state.last_packet =3D g_byte_array_sized_new(MAX_PACKET_LE=
NGTH + 4);
> +
> +
> +    if (kvm_enabled()) {
> +        gdbserver_state.supported_sstep_flags =3D
>  kvm_get_supported_sstep_flags();

This falls over as soon as you build something without KVM support (like
a TCG only build or an emulation only target):

  [10/1152] Compiling C object libqemu-riscv32-softmmu.fa.p/gdbstub.c.o
  FAILED: libqemu-riscv32-softmmu.fa.p/gdbstub.c.o=20
  cc -Ilibqemu-riscv32-softmmu.fa.p -I. -I../.. -Itarget/riscv -I../../targ=
et/riscv -Idtc/libfdt -I../../dtc/libfdt -I../../capstone/include/capstone =
-Iqapi -Itrace -Iui -Iui/shader -I/usr/include/pixman-1 -I/usr/include/libd=
rm -I/usr/include/spice-server -I/usr/include/spice-1 -I/usr/include/glib-2=
.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -fdiagnostics-color=3Dauto =
-pipe -Wall -Winvalid-pch -Werror -std=3Dgnu99 -O2 -g -isystem /home/alex/l=
src/qemu.git/linux-headers -isystem linux-headers -iquote . -iquote /home/a=
lex/lsrc/qemu.git -iquote /home/alex/lsrc/qemu.git/include -iquote /home/al=
ex/lsrc/qemu.git/disas/libvixl -iquote /home/alex/lsrc/qemu.git/tcg/i386 -i=
quote /home/alex/lsrc/qemu.git/accel/tcg -pthread -U_FORTIFY_SOURCE -D_FORT=
IFY_SOURCE=3D2 -m64 -mcx16 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_LARGEF=
ILE_SOURCE -Wstrict-prototypes -Wredundant-decls -Wundef -Wwrite-strings -W=
missing-prototypes -fno-strict-aliasing -fno-common -fwrapv -Wold-style-dec=
laration -Wold-style-definition -Wtype-limits -Wformat-security -Wformat-y2=
k -Winit-self -Wignored-qualifiers -Wempty-body -Wnested-externs -Wendif-la=
bels -Wexpansion-to-defined -Wimplicit-fallthrough=3D2 -Wno-missing-include=
-dirs -Wno-shift-negative-value -Wno-psabi -fstack-protector-strong -DLEGAC=
Y_RDMA_REG_MR -fPIC -isystem../../linux-headers -isystemlinux-headers -DNEE=
D_CPU_H '-DCONFIG_TARGET=3D"riscv32-softmmu-config-target.h"' '-DCONFIG_DEV=
ICES=3D"riscv32-softmmu-config-devices.h"' -MD -MQ libqemu-riscv32-softmmu.=
fa.p/gdbstub.c.o -MF libqemu-riscv32-softmmu.fa.p/gdbstub.c.o.d -o libqemu-=
riscv32-softmmu.fa.p/gdbstub.c.o -c ../../gdbstub.c
  ../../gdbstub.c: In function =E2=80=98init_gdbserver_state=E2=80=99:
  ../../gdbstub.c:404:49: error: implicit declaration of function =E2=80=98=
kvm_get_supported_sstep_flags=E2=80=99; did you mean =E2=80=98hvf_get_suppo=
rted_cpuid=E2=80=99? [-Werror=3Dimplicit-function-declaration]
           gdbserver_state.supported_sstep_flags =3D kvm_get_supported_sste=
p_flags();
                                                   ^~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
                                                   hvf_get_supported_cpuid
  ../../gdbstub.c:404:49: error: nested extern declaration of =E2=80=98kvm_=
get_supported_sstep_flags=E2=80=99 [-Werror=3Dnested-externs]
  ../../gdbstub.c: In function =E2=80=98gdbserver_start=E2=80=99:
  ../../gdbstub.c:3536:27: error: implicit declaration of function =E2=80=
=98kvm_supports_guest_debug=E2=80=99; did you mean =E2=80=98kvm_update_gues=
t_debug=E2=80=99? [-Werror=3Dimplicit-function-declaration]
       if (kvm_enabled() && !kvm_supports_guest_debug()) {
                             ^~~~~~~~~~~~~~~~~~~~~~~~
                             kvm_update_guest_debug
  ../../gdbstub.c:3536:27: error: nested extern declaration of =E2=80=98kvm=
_supports_guest_debug=E2=80=99 [-Werror=3Dnested-externs]
  cc1: all warnings being treated as errors


> +    } else {
> +        gdbserver_state.supported_sstep_flags =3D
> +            SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
> +    }
> +
> +    /*
> +     * By default use no IRQs and no timers while single stepping so as =
to
> +     * make single stepping like an ICE HW step.
> +     */
> +
> +    gdbserver_state.sstep_flags =3D SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_N=
OTIMER;
> +    gdbserver_state.sstep_flags &=3D gdbserver_state.supported_sstep_fla=
gs;
> +
>  }
>=20=20
>  #ifndef CONFIG_USER_ONLY
> @@ -2023,24 +2038,43 @@ static void handle_v_commands(GdbCmdContext *gdb_=
ctx, void *user_ctx)
>=20=20
>  static void handle_query_qemu_sstepbits(GdbCmdContext *gdb_ctx, void *us=
er_ctx)
>  {
> -    g_string_printf(gdbserver_state.str_buf, "ENABLE=3D%x,NOIRQ=3D%x,NOT=
IMER=3D%x",
> -                    SSTEP_ENABLE, SSTEP_NOIRQ, SSTEP_NOTIMER);
> +    g_string_printf(gdbserver_state.str_buf, "ENABLE=3D%x", SSTEP_ENABLE=
);
> +
> +    if (gdbserver_state.supported_sstep_flags & SSTEP_NOIRQ) {
> +        g_string_append_printf(gdbserver_state.str_buf, ",NOIRQ=3D%x",
> +                               SSTEP_NOIRQ);
> +    }
> +
> +    if (gdbserver_state.supported_sstep_flags & SSTEP_NOTIMER) {
> +        g_string_append_printf(gdbserver_state.str_buf, ",NOTIMER=3D%x",
> +                               SSTEP_NOTIMER);
> +    }
> +
>      put_strbuf();
>  }
>=20=20
>  static void handle_set_qemu_sstep(GdbCmdContext *gdb_ctx, void *user_ctx)
>  {
> +    int new_sstep_flags;
>      if (!gdb_ctx->num_params) {
>          return;
>      }
>=20=20
> -    sstep_flags =3D gdb_ctx->params[0].val_ul;
> +    new_sstep_flags =3D gdb_ctx->params[0].val_ul;
> +
> +    if (new_sstep_flags  & ~gdbserver_state.supported_sstep_flags) {
> +        put_packet("E22");
> +        return;
> +    }
> +
> +    gdbserver_state.sstep_flags =3D new_sstep_flags;
>      put_packet("OK");
>  }
>=20=20
>  static void handle_query_qemu_sstep(GdbCmdContext *gdb_ctx, void *user_c=
tx)
>  {
> -    g_string_printf(gdbserver_state.str_buf, "0x%x", sstep_flags);
> +    g_string_printf(gdbserver_state.str_buf, "0x%x",
> +                    gdbserver_state.sstep_flags);
>      put_strbuf();
>  }
>=20=20
> @@ -3499,6 +3533,11 @@ int gdbserver_start(const char *device)
>          return -1;
>      }
>=20=20
> +    if (kvm_enabled() && !kvm_supports_guest_debug()) {
> +        error_report("gdbstub: KVM doesn't support guest debugging");
> +        return -1;
> +    }
> +
<snip>

Otherwise it looks fine as far as it goes, however it would be nice to
have some sort of test in for this. The gdbstub has a hand-rolled gdb
script in tests/guest-debug/test-gdbstub.py but it's not integrated with
the rest of the testing.

As I suspect you need a) KVM enabled, b) a recent enough kernel and c)
some sort of guest kernel that is going to enable timers and IRQs this
might be something worth porting to the acceptance tests.

We have an example in tests/acceptance/reverse_debugging.py which is run
as part of check-acceptance. It's TCG only but perhaps is a template for
how such a test could be implemented.

--=20
Alex Benn=C3=A9e
