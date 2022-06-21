Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BBA553EB9
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 00:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354615AbiFUWvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 18:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiFUWvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 18:51:41 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD0E2F008
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:51:40 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c205so7681023pfc.7
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=azlAAGz618kiomZlrecMnLLAJbtZMZPGRWZS5TwAPYo=;
        b=fEWglGipZEemPrLunm+CRK5rgLUflGaMubsoz2U7KEniqt3+EM6rpj7cPX3pSs9Ya9
         54jxpPsud5cpFV7eTM0L+eJXhsQNOCjJavWClKa8kBIONrHNfBqGQ6W/ac0/eO9eqeVZ
         QXN+DpkMPuON3MRW5kMF3XcSPKuzLb0fYaW+XsepGISySuslsAm3xRpGqZ1R0TL6HnNy
         hrAePqrnpTaNA1qRWPLK7NnyeZJDohcVFmWXT10B2UMvi5PzoTSaWQgEF+nqO0liawWY
         JoLa1FDphy5P1pqVzNxHM7TsalO3eFcondTLN1EuNOxhug2RucOdyj4QtoCF09CH/rBx
         1TFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=azlAAGz618kiomZlrecMnLLAJbtZMZPGRWZS5TwAPYo=;
        b=sjzLE0bWUOhBsZYamcOFfXdyLyzUCv6+0r/TXmJABv0tkMPRoZfBuflkbqh3X7C1+E
         oKoHkfUX3ycpPpDFJqx3dt9cpaZ/Mz42cIkrxHtgl9DxkL+AmYj40pvnQK5U6g1zbNu5
         azmz9W6r1IRvsDMrU+R3/OSY2Jg2MaXrRLiy1NE4/2IU5OUYQ1vEH5Xb7CmmevbAFPCd
         R2StZSfFLFmN0ys71kKI/GVkAGQWryreK2hyo/3aj8yKji4Sd3LMYLWbC7v1QDv6O4Pj
         3MszkYEoom/cBS/naWWTi4UPFlM2qo3a+uecIb7WX+b+K770zkg1csPGQI2cAkft0wGP
         yKvw==
X-Gm-Message-State: AJIora+/RJCA8ot4UsbUVBPhhehO23S/d6gLeOZhBi5GHyOD3XVsv17T
        kUKDT7smWOIlrAQLcrOsGc9CGQ==
X-Google-Smtp-Source: AGRyM1uUCiS+VpM0QdIssRacWqApw+iKZL2xRzxEwVEA6qhWlcXLcQ57DL3+AaXvgp8pgRULjTNQKQ==
X-Received: by 2002:a05:6a00:1acc:b0:525:345d:cdcf with SMTP id f12-20020a056a001acc00b00525345dcdcfmr6820314pfv.76.1655851899588;
        Tue, 21 Jun 2022 15:51:39 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id y5-20020a170902d64500b001641a68f1c7sm11164351plh.273.2022.06.21.15.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:51:39 -0700 (PDT)
Date:   Tue, 21 Jun 2022 15:51:35 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 22/23] arm64: Add support for efi in
 Makefile
Message-ID: <YrJLd9mreN4cb3NE@google.com>
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

nit: not really needed as x86 doesn't allow other page sizes, arm64
already forces 4096 above, and arm32 doesn't support efi.

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
