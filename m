Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41E4553EBE
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 00:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354923AbiFUWwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 18:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiFUWwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 18:52:36 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434762F008
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:52:35 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x4so8078905pfq.2
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hEJHXTVLwkTpuWUzKJ0Wfx9WmvDXmOs4Rv2uPf9F4Js=;
        b=D3Kc4W7OvAoEI5hUlTGgrx4MCCIxGu9ous6K14y0/pPAVG7cwugH+DQDNFtwS2AFpF
         xFv7uK2tNxzWXK3gXvgHxQ6nxTO2KXhdvoywaOskkg9kujUSqmUOTjZ6ti6CiNQyWfFb
         bJZUdAVaqLavYCjCWm4izTbVvqr+ZOtrhEKfyViauMIy1MC7IUnqCA2FT0tFvU1pLdX5
         kqEkQ0bEInVu0JRMEOcbshUpCgEeWfXrWlbGWNUJORVhtFSYEradM28UMt4aOdODJVAk
         i7B3sTyAbCTCl3RHLGI0Y9MjUSK3u8YRLLeVrc2ZfrhumhYHzedP6PYBkcHkjHCULXM9
         7kZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hEJHXTVLwkTpuWUzKJ0Wfx9WmvDXmOs4Rv2uPf9F4Js=;
        b=jEcdAVnl8qYu5tFsTTonlRibkYu4WJq1tdAG/OGBbERiEKemO6YFlYDiaikj2Ytqb8
         3TLKJKaqCst5VYw1SjeL0oo68YqbeDctJxSTJ4CZ0NAYHkTf4wyxtBVNzIVhwlOQN0b3
         yxdLnemgJdxmEgMsJqblB6SRD4RBaM8oi8fMPtcY5pLDrQ09tNh57EUfxmkzc6xls/Rw
         XV2Ue48937MRxbxRXvFSYeRHXe9WDyMkp2IA2zvWR3vLX5lJIZh/L6Tnn+gFFMdOONAt
         jNwsbntnrgR0gcrwoqrcfGiImmgJ6hgLdm2GM6T9oOr3GhS8QJnzDi3MfEdoNAU+OhZT
         PElg==
X-Gm-Message-State: AJIora+yR+VhRqZUwlLH9tLrTvSTuktZuErSkxDaTD0d+4gGqVen3R3k
        DoUXOA8DCgwIlUNTbbgxRdDZJg==
X-Google-Smtp-Source: AGRyM1s6wNQc7ZfAaEgCrgntnZ3sArIfiE+t4bpEKBUKMp6gTJkbl6VDAQCdJN3uj+Gd2+eGLFNlTQ==
X-Received: by 2002:a63:91ca:0:b0:40d:1a2b:d42e with SMTP id l193-20020a6391ca000000b0040d1a2bd42emr234054pge.379.1655851954562;
        Tue, 21 Jun 2022 15:52:34 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id y5-20020a170902d64500b001641a68f1c7sm11164970plh.273.2022.06.21.15.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:52:34 -0700 (PDT)
Date:   Tue, 21 Jun 2022 15:52:31 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 22/23] arm64: Add support for efi in
 Makefile
Message-ID: <YrJLr6nFZJ30sC9Q@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-23-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-23-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:56:04PM +0100, Nikos Nikoleris wrote:
> Users can now build kvm-unit-tests as efi apps by supplying an extra
> argument when invoking configure:
> 
> $> ./configure --enable-efi
> 
> This patch is based on an earlier version by
> Andrew Jones <drjones@redhat.com>
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  configure           | 15 ++++++++++++---
>  arm/Makefile.arm    |  6 ++++++
>  arm/Makefile.arm64  | 18 ++++++++++++++----
>  arm/Makefile.common | 45 ++++++++++++++++++++++++++++++++++-----------
>  4 files changed, 66 insertions(+), 18 deletions(-)
> 
> diff --git a/configure b/configure
> index 86c3095..beef655 100755
> --- a/configure
> +++ b/configure
> @@ -195,14 +195,19 @@ else
>      fi
>  fi
>  
> -if [ "$efi" ] && [ "$arch" != "x86_64" ]; then
> +if [ "$efi" ] && [ "$arch" != "x86_64" ] && [ "$arch" != "arm64" ]; then
>      echo "--[enable|disable]-efi is not supported for $arch"
>      usage
>  fi
>  
>  if [ -z "$page_size" ]; then
> -    [ "$arch" = "arm64" ] && page_size="65536"
> -    [ "$arch" = "arm" ] && page_size="4096"
> +    if [ "$efi" = 'y' ] && [ "$arch" = "arm64" ]; then
> +        page_size="4096"
> +    elif [ "$arch" = "arm64" ]; then
> +        page_size="65536"
> +    elif [ "$arch" = "arm" ]; then
> +        page_size="4096"
> +    fi
>  else
>      if [ "$arch" != "arm64" ]; then
>          echo "--page-size is not supported for $arch"
> @@ -217,6 +222,10 @@ else
>          echo "arm64 doesn't support page size of $page_size"
>          usage
>      fi
> +    if [ "$efi" = 'y' ] && [ "$page_size" != "4096" ]; then
> +        echo "efi must use 4K pages"
> +        exit 1
> +    fi
>  fi
>  
>  [ -z "$processor" ] && processor="$arch"
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index 01fd4c7..2ce00f5 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -7,6 +7,10 @@ bits = 32
>  ldarch = elf32-littlearm
>  machine = -marm -mfpu=vfp
>  
> +ifeq ($(CONFIG_EFI),y)
> +$(error Cannot build arm32 tests as EFI apps)
> +endif
> +
>  # stack.o relies on frame pointers.
>  KEEP_FRAME_POINTER := y
>  
> @@ -32,6 +36,8 @@ cflatobjs += lib/arm/stack.o
>  cflatobjs += lib/ldiv32.o
>  cflatobjs += lib/arm/ldivmod.o
>  
> +exe = flat
> +
>  # arm specific tests
>  tests =
>  
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 6feac76..550e1b2 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -27,11 +27,21 @@ cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
>  
>  OBJDIRS += lib/arm64
>  
> +ifeq ($(CONFIG_EFI),y)
> +# avoid jump tables before all relocations have been processed
> +arm/efi/reloc_aarch64.o: CFLAGS += -fno-jump-tables
> +cflatobjs += arm/efi/reloc_aarch64.o
> +
> +exe = efi
> +else
> +exe = flat
> +endif
> +
>  # arm64 specific tests
> -tests = $(TEST_DIR)/timer.flat
> -tests += $(TEST_DIR)/micro-bench.flat
> -tests += $(TEST_DIR)/cache.flat
> -tests += $(TEST_DIR)/debug.flat
> +tests = $(TEST_DIR)/timer.$(exe)
> +tests += $(TEST_DIR)/micro-bench.$(exe)
> +tests += $(TEST_DIR)/cache.$(exe)
> +tests += $(TEST_DIR)/debug.$(exe)
>  
>  include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>  
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 5be42c0..a8007f4 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -4,14 +4,14 @@
>  # Authors: Andrew Jones <drjones@redhat.com>
>  #
>  
> -tests-common  = $(TEST_DIR)/selftest.flat
> -tests-common += $(TEST_DIR)/spinlock-test.flat
> -tests-common += $(TEST_DIR)/pci-test.flat
> -tests-common += $(TEST_DIR)/pmu.flat
> -tests-common += $(TEST_DIR)/gic.flat
> -tests-common += $(TEST_DIR)/psci.flat
> -tests-common += $(TEST_DIR)/sieve.flat
> -tests-common += $(TEST_DIR)/pl031.flat
> +tests-common  = $(TEST_DIR)/selftest.$(exe)
> +tests-common += $(TEST_DIR)/spinlock-test.$(exe)
> +tests-common += $(TEST_DIR)/pci-test.$(exe)
> +tests-common += $(TEST_DIR)/pmu.$(exe)
> +tests-common += $(TEST_DIR)/gic.$(exe)
> +tests-common += $(TEST_DIR)/psci.$(exe)
> +tests-common += $(TEST_DIR)/sieve.$(exe)
> +tests-common += $(TEST_DIR)/pl031.$(exe)
>  
>  tests-all = $(tests-common) $(tests)
>  all: directories $(tests-all)
> @@ -54,6 +54,9 @@ cflatobjs += lib/arm/smp.o
>  cflatobjs += lib/arm/delay.o
>  cflatobjs += lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
>  cflatobjs += lib/arm/timer.o
> +ifeq ($(CONFIG_EFI),y)
> +cflatobjs += lib/efi.o
> +endif
>  
>  OBJDIRS += lib/arm
>  
> @@ -61,6 +64,25 @@ libeabi = lib/arm/libeabi.a
>  eabiobjs = lib/arm/eabi_compat.o
>  
>  FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
> +
> +ifeq ($(CONFIG_EFI),y)
> +%.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
> +%.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o)
> +	$(CC) $(CFLAGS) -c -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
> +		-DPROGNAME=\"$(@:.so=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
> +	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
> +		$(filter %.o, $^) $(FLATLIBS) $(@:.so=.aux.o) \
> +		$(EFI_LIBS)
> +	$(RM) $(@:.so=.aux.o)
> +
> +%.efi: %.so
> +	$(call arch_elf_check, $^)
> +	$(OBJCOPY) \
> +		-j .text -j .sdata -j .data -j .dynamic -j .dynsym \
> +		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
> +		-j .reloc \
> +		-O binary $^ $@
> +else
>  %.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
>  %.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o)
>  	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
> @@ -74,13 +96,14 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
>  	$(call arch_elf_check, $^)
>  	$(OBJCOPY) -O binary $^ $@
>  	@chmod a-x $@
> +endif
>  
>  $(libeabi): $(eabiobjs)
>  	$(AR) rcs $@ $^
>  
>  arm_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,flat,elf} $(libeabi) $(eabiobjs) \
> -	      $(TEST_DIR)/.*.d lib/arm/.*.d
> +	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi} $(libeabi) $(eabiobjs) \
> +	      $(TEST_DIR)/.*.d $(TEST_DIR)/efi/.*.d lib/arm/.*.d
>  
>  generated-files = $(asm-offsets)
> -$(tests-all:.flat=.o) $(cstart.o) $(cflatobjs): $(generated-files)
> +$(tests-all:.$(exe)=.o) $(cstart.o) $(cflatobjs): $(generated-files)
> -- 
> 2.25.1
>

Reviewed-by: Ricardo Koller <ricarkol@google.com>
