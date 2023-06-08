Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FB472899B
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 22:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbjFHUmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 16:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbjFHUmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 16:42:13 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42547E4D
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 13:42:11 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-653bed78635so775991b3a.0
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 13:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686256931; x=1688848931;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OJc7v2gd1zqw9e9bXf/VJ7wneJW7ODsFhMJ4UoXicLA=;
        b=iFL9SJTHPhDtJAMHT5UcHxie49cfExl7x/YdNXtwsgagji48BOma96AV8tdHcdTiNy
         a1vShxLaY/FyfFzHTCD3z18X1lL+idX0cFKVNEuAryukWPFBSzYNR1s+/Z2FOSTki3OZ
         gZXB57arsO9wgclWML5w5uR4NM8TjK2afXA/8+gOQnogugAHr/VTZe9hQvdoKOcgYS0n
         h7Pyyyze7Urfs3xb4C682RXJ91ZcTKedPprQXyOZC8QglK4XB5Af4gFHqavoHrDWkykS
         THxK6FCQPP1k99ce5pXXIJt/NHtiHvueMMvZD9MQf+/Sq5oqWrfaa0CH4MlhziEgbye1
         SbIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686256931; x=1688848931;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OJc7v2gd1zqw9e9bXf/VJ7wneJW7ODsFhMJ4UoXicLA=;
        b=PVWevf3k035O89OBvOTeFKT/4bsQWrQ4SAug+45ys67/zdXpyeXjvnlndq8IohO4Pv
         hZL7r5zhXANA+nS8UJU8IrwetovufC39LYf09pEkpOBqDzoQL9ET4fYm+1ZFGmZ2Yt1s
         tzY+FBRidapncIs+d056g4Ar9rbABxa3bIDoi+uGl2kce/UUcvSYmRSx+nA9X9vdn3qR
         NoamnhIKf3KnWsMWPl34qTrbxYYctB+7o5EzPXFczQ2/UKWeOZ8NdHrVbkOvRU48RcFG
         /blPm0jfWK+/EwMtexfy8FYQAaDU0XuNHoTKivB9EYtfz8OZ21dgvZJ+68ST54jgLZkG
         8rdQ==
X-Gm-Message-State: AC+VfDzWu7jm5t6u1IDxsc2lrQNTnAP6+Pcay6PAb92YrO9RYU555TKQ
        z0+zDGWKUAKXifcL2mQQrr0=
X-Google-Smtp-Source: ACHHUZ6eV8Cg3uXBSyDetZpxlRVx+tS8gqRI4k8h37IQMzMrSLgRCaMDbvwv31xXOT8jQJsFtdyhLA==
X-Received: by 2002:a17:903:41d0:b0:1af:df8e:d534 with SMTP id u16-20020a17090341d000b001afdf8ed534mr3591931ple.27.1686256930335;
        Thu, 08 Jun 2023 13:42:10 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.113])
        by smtp.gmail.com with ESMTPSA id d15-20020a170902cecf00b001ab09f5ca61sm1841183plg.55.2023.06.08.13.42.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2023 13:42:09 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 28/32] arm64: Add support for efi in
 Makefile
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230530160924.82158-29-nikos.nikoleris@arm.com>
Date:   Thu, 8 Jun 2023 13:41:58 -0700
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <197A5432-65EA-49A7-AD6D-1AFCB58D30D0@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-29-nikos.nikoleris@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On May 30, 2023, at 9:09 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> =
wrote:
>=20
> Users can now build kvm-unit-tests as efi apps by supplying an extra
> argument when invoking configure:
>=20
> $> ./configure --enable-efi
>=20
> This patch is based on an earlier version by
> Andrew Jones <drjones@redhat.com>
>=20
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
> configure           | 17 +++++++++++++----
> arm/Makefile.arm    |  6 ++++++
> arm/Makefile.arm64  | 18 ++++++++++++++----
> arm/Makefile.common | 45 ++++++++++++++++++++++++++++++++++-----------
> 4 files changed, 67 insertions(+), 19 deletions(-)
>=20
> diff --git a/configure b/configure
> index c36fd290..b665f7d5 100755
> --- a/configure
> +++ b/configure
> @@ -86,7 +86,7 @@ usage() {
>               pl011,mmio32,ADDR
>                           Specify a PL011 compatible UART at address =
ADDR. Supported
>                           register stride is 32 bit only.
> -    --[enable|disable]-efi Boot and run from UEFI (disabled by =
default, x86_64 only)
> +    --[enable|disable]-efi Boot and run from UEFI (disabled by =
default, x86_64 and arm64 only)
>    --[enable|disable]-werror
>                           Select whether to compile with the -Werror =
compiler flag
> EOF
> @@ -208,14 +208,19 @@ else
>     fi
> fi
>=20
> -if [ "$efi" ] && [ "$arch" !=3D "x86_64" ]; then
> +if [ "$efi" ] && [ "$arch" !=3D "x86_64" ] && [ "$arch" !=3D "arm64" =
]; then
>     echo "--[enable|disable]-efi is not supported for $arch"
>     usage
> fi
>=20
> if [ -z "$page_size" ]; then
> -    [ "$arch" =3D "arm64" ] && page_size=3D"65536"
> -    [ "$arch" =3D "arm" ] && page_size=3D"4096"
> +    if [ "$efi" =3D 'y' ] && [ "$arch" =3D "arm64" ]; then
> +        page_size=3D"4096"
> +    elif [ "$arch" =3D "arm64" ]; then
> +        page_size=3D"65536"
> +    elif [ "$arch" =3D "arm" ]; then
> +        page_size=3D"4096"
> +    fi
> else
>     if [ "$arch" !=3D "arm64" ]; then
>         echo "--page-size is not supported for $arch"
> @@ -230,6 +235,10 @@ else
>         echo "arm64 doesn't support page size of $page_size"
>         usage
>     fi
> +    if [ "$efi" =3D 'y' ] && [ "$page_size" !=3D "4096" ]; then
> +        echo "efi must use 4K pages"
> +        exit 1
> +    fi
> fi
>=20
> [ -z "$processor" ] && processor=3D"$arch"
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index 01fd4c7b..2ce00f52 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -7,6 +7,10 @@ bits =3D 32
> ldarch =3D elf32-littlearm
> machine =3D -marm -mfpu=3Dvfp
>=20
> +ifeq ($(CONFIG_EFI),y)
> +$(error Cannot build arm32 tests as EFI apps)
> +endif
> +
> # stack.o relies on frame pointers.
> KEEP_FRAME_POINTER :=3D y
>=20
> @@ -32,6 +36,8 @@ cflatobjs +=3D lib/arm/stack.o
> cflatobjs +=3D lib/ldiv32.o
> cflatobjs +=3D lib/arm/ldivmod.o
>=20
> +exe =3D flat
> +
> # arm specific tests
> tests =3D
>=20
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 6dff6cad..eada7f9a 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -31,11 +31,21 @@ endif
>=20
> OBJDIRS +=3D lib/arm64
>=20
> +ifeq ($(CONFIG_EFI),y)
> +# avoid jump tables before all relocations have been processed
> +arm/efi/reloc_aarch64.o: CFLAGS +=3D -fno-jump-tables
> +cflatobjs +=3D arm/efi/reloc_aarch64.o
> +
> +exe =3D efi
> +else
> +exe =3D flat
> +endif
> +
> # arm64 specific tests
> -tests =3D $(TEST_DIR)/timer.flat
> -tests +=3D $(TEST_DIR)/micro-bench.flat
> -tests +=3D $(TEST_DIR)/cache.flat
> -tests +=3D $(TEST_DIR)/debug.flat
> +tests =3D $(TEST_DIR)/timer.$(exe)
> +tests +=3D $(TEST_DIR)/micro-bench.$(exe)
> +tests +=3D $(TEST_DIR)/cache.$(exe)
> +tests +=3D $(TEST_DIR)/debug.$(exe)
>=20
> include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>=20
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 647b0fb1..a133309d 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -4,14 +4,14 @@
> # Authors: Andrew Jones <drjones@redhat.com>
> #
>=20
> -tests-common  =3D $(TEST_DIR)/selftest.flat
> -tests-common +=3D $(TEST_DIR)/spinlock-test.flat
> -tests-common +=3D $(TEST_DIR)/pci-test.flat
> -tests-common +=3D $(TEST_DIR)/pmu.flat
> -tests-common +=3D $(TEST_DIR)/gic.flat
> -tests-common +=3D $(TEST_DIR)/psci.flat
> -tests-common +=3D $(TEST_DIR)/sieve.flat
> -tests-common +=3D $(TEST_DIR)/pl031.flat
> +tests-common  =3D $(TEST_DIR)/selftest.$(exe)
> +tests-common +=3D $(TEST_DIR)/spinlock-test.$(exe)
> +tests-common +=3D $(TEST_DIR)/pci-test.$(exe)
> +tests-common +=3D $(TEST_DIR)/pmu.$(exe)
> +tests-common +=3D $(TEST_DIR)/gic.$(exe)
> +tests-common +=3D $(TEST_DIR)/psci.$(exe)
> +tests-common +=3D $(TEST_DIR)/sieve.$(exe)
> +tests-common +=3D $(TEST_DIR)/pl031.$(exe)
>=20
> tests-all =3D $(tests-common) $(tests)
> all: directories $(tests-all)
> @@ -54,6 +54,9 @@ cflatobjs +=3D lib/arm/smp.o
> cflatobjs +=3D lib/arm/delay.o
> cflatobjs +=3D lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
> cflatobjs +=3D lib/arm/timer.o
> +ifeq ($(CONFIG_EFI),y)
> +cflatobjs +=3D lib/efi.o
> +endif
>=20
> OBJDIRS +=3D lib/arm
>=20
> @@ -61,6 +64,25 @@ libeabi =3D lib/arm/libeabi.a
> eabiobjs =3D lib/arm/eabi_compat.o
>=20
> FLATLIBS =3D $(libcflat) $(LIBFDT_archive) $(libeabi)
> +
> +ifeq ($(CONFIG_EFI),y)
> +%.so: EFI_LDFLAGS +=3D -defsym=3DEFI_SUBSYSTEM=3D0xa --no-undefined
> +%.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds =
$(cstart.o)
> + $(CC) $(CFLAGS) -c -o $(@:.so=3D.aux.o) $(SRCDIR)/lib/auxinfo.c \
> + -DPROGNAME=3D\"$(@:.so=3D.efi)\" -DAUXFLAGS=3D$(AUXFLAGS)
> + $(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds =
\
> + $(filter %.o, $^) $(FLATLIBS) $(@:.so=3D.aux.o) \
> + $(EFI_LIBS)
> + $(RM) $(@:.so=3D.aux.o)
> +
> +%.efi: %.so
> + $(call arch_elf_check, $^)
> + $(OBJCOPY) \
> + -j .text -j .sdata -j .data -j .dynamic -j .dynsym \
> + -j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
> + -j .reloc \
> + -O binary $^ $@

I really appreciate your work Nikos, and I might be late since I see =
Drew
already applied it to his queue. So consider this email, my previous =
one, and
others that might follow more as grievances that can easily be addressed =
later.

So: It would=E2=80=99ve been nice to keep the symbols and debug =
information in a
separate file. Something like:

diff --git a/arm/Makefile.common b/arm/Makefile.common
index d60cf8c..f904702 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -69,7 +69,7 @@ FLATLIBS =3D $(libcflat) $(LIBFDT_archive) $(libeabi)
 ifeq ($(CONFIG_EFI),y)
 %.so: EFI_LDFLAGS +=3D -defsym=3DEFI_SUBSYSTEM=3D0xa --no-undefined
 %.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o)
-       $(CC) $(CFLAGS) -c -o $(@:.so=3D.aux.o) $(SRCDIR)/lib/auxinfo.c =
\
+       $(CC) $(CFLAGS) -c -g -o $(@:.so=3D.aux.o) =
$(SRCDIR)/lib/auxinfo.c \
                -DPROGNAME=3D\"$(@:.so=3D.efi)\" -DAUXFLAGS=3D$(AUXFLAGS)
        $(LD) $(EFI_LDFLAGS) -o $@ -T =
$(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
                $(filter %.o, $^) $(FLATLIBS) $(@:.so=3D.aux.o) \
@@ -78,6 +78,9 @@ ifeq ($(CONFIG_EFI),y)
   %.efi: %.so
        $(call arch_elf_check, $^)
+       $(OBJCOPY) --only-keep-debug $^ $@.debug
+       $(OBJCOPY) --strip-debug $^
+       $(OBJCOPY) --add-gnu-debuglink=3D$@.debug $^
        $(OBJCOPY) \
                -j .text -j .sdata -j .data -j .dynamic -j .dynsym \
                -j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* =
\=
