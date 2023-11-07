Return-Path: <kvm+bounces-827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C95857E32A4
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 02:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D9FB280E17
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 01:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DBAC20E7;
	Tue,  7 Nov 2023 01:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LK2qxz9D"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA58186E
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 01:40:04 +0000 (UTC)
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78603184
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 17:40:00 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6ce37683cf6so3204184a34.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 17:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699321199; x=1699925999; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xJleMQjaaLsKD3zymDLq2GG+Em4KcVhskoi6Q7RZmiw=;
        b=LK2qxz9DX84ChXK2vPzJdOx+3l3KNf1qXe8ervOo8XLikghzzLUmjszxQ0Y2rly38a
         AoMn59MG7fZ4odCk87Phet+4VYmu7RM08OowRSJu1V3PLqt09tBd5eW/s/WTr74f9bMo
         pS+r7VApPItrf8E2nLPeP4Bp/W34iTKs+gc/MURketD6mJujS+Aic0/FetcTc/moYao1
         KCowycRXK7Ul7orlqyI9p36xfckXyRm1IzRQKr7bxc9yF5ZtzNwKrgeQ9f3YXuNyz6eu
         UN9FHAwVAZsWPildPkfHDagczq5u/XHsEPMWNkiNC+lqUxWHjAqpXzHv7IuGal7zc1Dj
         YR3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699321199; x=1699925999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xJleMQjaaLsKD3zymDLq2GG+Em4KcVhskoi6Q7RZmiw=;
        b=RGwQKP/MOtTheXFMmc1hgX75R/dYP9MoXrFLTl5nfysrITHn3af7+6vpcdD+nmGeJj
         lTAKmfCljLxBHbS9wrqQJCdCQUOc58VNykOSC2srLzHlrv9SN1+OwHxtwhM2vtpTbLHd
         hzD9DF/hwZkCXdxAn4b7KR9sUx+c/C8l4k7RwoID6CM7lyieLEYkXSYbGOlZA386XCIB
         RoP32hULzfC68p3ywgIeeG8xSa3Llf3YuEeTi2ewvz2sLBREaWwjAavMzo0nTR3+b8jQ
         ZPvfqURp2W5hEIUH1AOuLFywXJb4/X+tMyoMMO25PudmxqBr4tQBZ95uGKflIKISteps
         3IfA==
X-Gm-Message-State: AOJu0YxztyO6bIqc/H1rSctemuEqe/Z0UTOUuuduzQ4utTz8RGqcolSC
	p/gA3XuSL5K4FSj00q1zYQtDm0IY6j1w+Yz4u2D43sQUwJ0=
X-Google-Smtp-Source: AGHT+IHZuWbCytkP8n4Amau66dg4WgfHSel/3swE8s+v2uWdPs0YkGJaZNGLV00cj0Ae+JV0sLY/HpwJ8DtyiDahvh8=
X-Received: by 2002:a05:6830:2054:b0:6c4:ac5b:aaea with SMTP id
 f20-20020a056830205400b006c4ac5baaeamr30873746otp.25.1699321199492; Mon, 06
 Nov 2023 17:39:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231106110336.358-1-philmd@linaro.org>
In-Reply-To: <20231106110336.358-1-philmd@linaro.org>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 7 Nov 2023 09:39:47 +0800
Message-ID: <CAJSP0QXN5LQ_56do2MOAXyHWwqstYPDEDgptN4h464mW7wnjqA@mail.gmail.com>
Subject: Re: [PULL 00/60] Misc HW/UI patches for 2023-11-06
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org, 
	qemu-block@nongnu.org, qemu-riscv@nongnu.org, qemu-ppc@nongnu.org, 
	qemu-arm@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Nov 2023 at 19:03, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org=
> wrote:
>
> The following changes since commit d762bf97931b58839316b68a570eecc6143c9e=
3e:
>
>   Merge tag 'pull-target-arm-20231102' of https://git.linaro.org/people/p=
maydell/qemu-arm into staging (2023-11-03 10:04:12 +0800)
>
> are available in the Git repository at:
>
>   https://github.com/philmd/qemu.git tags/misc-cpus-20231106
>
> for you to fetch changes up to a81b438ac3933419910cbdf2e2e8d87681de611e:
>
>   ui/sdl2: use correct key names in win title on mac (2023-11-06 11:07:32=
 +0100)
>
> Few checkpatch warnings in target/i386/hvf/x86_emu.c are deliberately ign=
ored.
> ----------------------------------------------------------------
> Misc hardware patch queue
>
> HW emulation:
> - PMBus fixes and tests (Titus)
> - IDE fixes and tests (Fiona)
> - New ADM1266 sensor (Titus)
> - Better error propagation in PCI-ISA i82378 (Philippe)
>
> Topology:
> - Fix CPUState::nr_cores calculation (Zhuocheng Ding and Zhao Liu)
>
> Monitor:
> - Synchronize CPU state in 'info lapic' (Dongli Zhang)
>
> QOM:
> - Have 'cpu-qom.h' target-agnostic (Philippe)
> - Call object_class_is_abstract once in cpu_class_by_name (Philippe)
>
> UI:
> - Use correct key names in titles on MacOS / SDL2 (Adrian)
>
> MIPS:
> - Fix MSA BZ/BNZ and TX79 LQ/SQ opcodes (Philippe)
>
> Nios2:
> - Create IRQs *after* vCPU is realized (Philippe)
>
> PPC:
> - Restrict KVM objects to system emulation (Philippe)
>
> X86:
> - HVF & KVM cleanups (Philippe)
>
> Various targets:
> - Use env_archcpu() to optimize (Philippe)
>
> Misc:
> - Few global variable shadowing removed (Philippe)
> - Introduce cpu_exec_reset_hold and factor tcg_cpu_reset_hold out (Philip=
pe)
> - Remove few more 'softmmu' mentions (Philippe)
> - Fix and cleanup in vl.c (Akihiko & Marc-Andr=C3=A9)
> - MAINTAINERS updates (Thomas, Daniel)
>
> ----------------------------------------------------------------
>
> Adrian Wowk (1):
>   ui/sdl2: use correct key names in win title on mac
>
> Akihiko Odaki (1):
>   vl: Free machine list
>
> Daniel P. Berrang=C3=A9 (1):
>   MAINTAINERS: update libvirt devel mailing list address
>
> Dongli Zhang (1):
>   target/i386/monitor: synchronize cpu state for lapic info
>
> Fiona Ebner (2):
>   hw/ide: reset: cancel async DMA operation before resetting state
>   tests/qtest: ahci-test: add test exposing reset issue with pending
>     callback
>
> Marc-Andr=C3=A9 Lureau (1):
>   vl: constify default_list
>
> Philippe Mathieu-Daud=C3=A9 (39):
>   tests/vm/ubuntu.aarch64: Correct comment about TCG specific delay
>   tests/unit/test-seccomp: Remove mentions of softmmu in test names
>   accel/tcg: Declare tcg_flush_jmp_cache() in 'exec/tb-flush.h'
>   accel: Introduce cpu_exec_reset_hold()
>   accel/tcg: Factor tcg_cpu_reset_hold() out
>   target: Unify QOM style
>   target: Mention 'cpu-qom.h' is target agnostic
>   target/arm: Move internal declarations from 'cpu-qom.h' to 'cpu.h'
>   target/ppc: Remove CPU_RESOLVING_TYPE from 'cpu-qom.h'
>   target/riscv: Remove CPU_RESOLVING_TYPE from 'cpu-qom.h'
>   target: Declare FOO_CPU_TYPE_NAME/SUFFIX in 'cpu-qom.h'
>   target/hexagon: Declare QOM definitions in 'cpu-qom.h'
>   target/loongarch: Declare QOM definitions in 'cpu-qom.h'
>   target/nios2: Declare QOM definitions in 'cpu-qom.h'
>   target/openrisc: Declare QOM definitions in 'cpu-qom.h'
>   target/riscv: Move TYPE_RISCV_CPU_BASE definition to 'cpu.h'
>   target/ppc: Use env_archcpu() in helper_book3s_msgsndp()
>   target/riscv: Use env_archcpu() in [check_]nanbox()
>   target/s390x: Use env_archcpu() in handle_diag_308()
>   target/xtensa: Use env_archcpu() in update_c[compare|count]()
>   target/i386/hvf: Use x86_cpu in simulate_[rdmsr|wrmsr]()
>   target/i386/hvf: Use env_archcpu() in simulate_[rdmsr/wrmsr]()
>   target/i386/hvf: Use CPUState typedef
>   target/i386/hvf: Rename 'CPUState *cpu' variable as 'cs'
>   target/i386/hvf: Rename 'X86CPU *x86_cpu' variable as 'cpu'
>   target/i386/kvm: Correct comment in kvm_cpu_realize()
>   target/mips: Fix MSA BZ/BNZ opcodes displacement
>   target/mips: Fix TX79 LQ/SQ opcodes
>   sysemu/kvm: Restrict kvmppc_get_radix_page_info() to ppc targets
>   hw/ppc/e500: Restrict ppce500_init_mpic_kvm() to KVM
>   target/ppc: Restrict KVM objects to system emulation
>   target/ppc: Prohibit target specific KVM prototypes on user emulation
>   target/nios2: Create IRQs *after* accelerator vCPU is realized
>   target/alpha: Tidy up alpha_cpu_class_by_name()
>   hw/cpu: Call object_class_is_abstract() once in cpu_class_by_name()
>   exec/cpu: Have cpu_exec_realize() return a boolean
>   hw/cpu: Clean up global variable shadowing

Please take a look at the following CI failure:

cc -m64 -mcx16 -Ilibqemu-arm-bsd-user.fa.p -I. -I.. -Itarget/arm
-I../target/arm -I../common-user/host/x86_64 -I../bsd-user/include
-Ibsd-user/freebsd -I../bsd-user/freebsd -I../bsd-user/host/x86_64
-Ibsd-user -I../bsd-user -I../bsd-user/arm -Iqapi -Itrace -Iui
-Iui/shader -I/usr/local/include/capstone
-I/usr/local/include/glib-2.0 -I/usr/local/lib/glib-2.0/include
-I/usr/local/include -fcolor-diagnostics -Wall -Winvalid-pch -Werror
-std=3Dgnu11 -O2 -g -fstack-protector-strong -Wundef -Wwrite-strings
-Wmissing-prototypes -Wstrict-prototypes -Wredundant-decls
-Wold-style-definition -Wtype-limits -Wformat-security -Wformat-y2k
-Winit-self -Wignored-qualifiers -Wempty-body -Wnested-externs
-Wendif-labels -Wexpansion-to-defined -Wmissing-format-attribute
-Wno-initializer-overrides -Wno-missing-include-dirs
-Wno-shift-negative-value -Wno-string-plus-int
-Wno-typedef-redefinition -Wno-tautological-type-limit-compare
-Wno-psabi -Wno-gnu-variable-sized-type-not-at-end -Wthread-safety
-iquote . -iquote /tmp/cirrus-ci-build -iquote
/tmp/cirrus-ci-build/include -iquote
/tmp/cirrus-ci-build/host/include/x86_64 -iquote
/tmp/cirrus-ci-build/host/include/generic -iquote
/tmp/cirrus-ci-build/tcg/i386 -pthread -D_GNU_SOURCE
-D_FILE_OFFSET_BITS=3D64 -D_LARGEFILE_SOURCE -fno-strict-aliasing
-fno-common -fwrapv -fPIE -DNEED_CPU_H
'-DCONFIG_TARGET=3D"arm-bsd-user-config-target.h"'
'-DCONFIG_DEVICES=3D"arm-bsd-user-config-devices.h"' -MD -MQ
libqemu-arm-bsd-user.fa.p/bsd-user_main.c.o -MF
libqemu-arm-bsd-user.fa.p/bsd-user_main.c.o.d -o
libqemu-arm-bsd-user.fa.p/bsd-user_main.c.o -c ../bsd-user/main.c
../bsd-user/main.c:121:36: error: use of undeclared identifier 'cpus';
did you mean 'cpu'?
QTAILQ_REMOVE_RCU(&cpus, cpu, node);
^~~~
cpu

https://gitlab.com/qemu-project/qemu/-/jobs/5472832586

Thanks,
Stefan

