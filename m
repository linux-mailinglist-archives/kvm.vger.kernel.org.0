Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8854373C20
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 15:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhEENRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 09:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhEENRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 09:17:04 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E616C061574
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 06:16:06 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a4so2818586ejk.1
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 06:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2lFLFRQm4fCCdqDjMXfujz0lGPJ5VlnyqEnFt69QnpA=;
        b=CjmFs6ITbNZqFSsufsmFgc6YQckZtEMIys/ta7D3PEb9TGW7Dj2r+Pf/gnbTNd1p7m
         OymT0yiI2WHs+k9y3nC/z1TfLlYjCigemADmaweg9GeIL7j67/9XhpygF5QIq0kLSu3t
         ffz8KnDIASoGbnCMvBxnLNaja8pqCiAImYX4b0RUlotRZogiiWyZ/qGUTeybBlNbXM8z
         2TeifZ/z9gpalNH36rRfDqAQEUoBowkognZzyzbaoilyiLRSvz+cHFm4bl+4ODJyZepc
         QfnTyvqF3LBo2Inb/XPQpStPIfO53wqEXQXUq+mjSXbf0bvzt/WvjfkSVNbm8+IG1Sgh
         wpSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2lFLFRQm4fCCdqDjMXfujz0lGPJ5VlnyqEnFt69QnpA=;
        b=eDywYDHqoukNvlRdFbXjtmdQNmgnPFwXXIIN/Pmi7vLdC10Dil7WGaiBx4lsrGbT0c
         kVQNAsOn0TWrnsuWtiDSoON4ECoqgWhZaWoEIySC3mRx2VqTfcJb2RGwl5WoUwRoWoEb
         GbTHc9Ubt/ylSRIPSGQgLOTl2/KbARPZlFitwj+cv2E3b2HqAR7yagcYTKNm5Kyqz9DJ
         +QIYR1D+ySHgUBokZF+ObKWvykCcW60pHBv0IW5wIn86Vk/vcwe1hGc0NVUOKmxEJIdA
         cMxl5uoZRUE9LVoh+ZISBxgV244MKeGlaGD89KwczngwYbXsr9JJkiY41N9SbQfdkhyt
         swBg==
X-Gm-Message-State: AOAM530t1kqvQudYlWYq3+oiaZ1d49K0+8FB5cvaecxWypi8XrpMCirD
        +UwnHzS5j7v/bTSwnE8FkbI=
X-Google-Smtp-Source: ABdhPJzbrUaXBKfv38nLwFDZXKAtcTVz3m0ZUWLpxXZsM0N0K3+shW+KUrhNFucUF1AfrruPmE3ZPQ==
X-Received: by 2002:a17:906:4ad0:: with SMTP id u16mr27354750ejt.19.1620220565015;
        Wed, 05 May 2021 06:16:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u8sm15757308edo.71.2021.05.05.06.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 06:16:04 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH kvm-unit-tests] libcflat: provide long division routines
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Bill Wendling <morbo@google.com>
References: <20210505131412.654238-1-pbonzini@redhat.com>
Message-ID: <941e5f21-7d0b-2e67-21d1-3c425a43f489@redhat.com>
Date:   Wed, 5 May 2021 15:16:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210505131412.654238-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/21 15:14, Paolo Bonzini wrote:
> The -nostdlib flag disables the driver from adding libclang_rt.*.a
> during linking. Adding a specific library to the command line such as
> libgcc then causes the linker to report unresolved symbols, because the
> libraries that resolve those symbols aren't automatically added.
> 
> libgcc however is only needed for long division (64-bit by 64-bit).
> Instead of linking the whole of it, implement the routines that are
> needed.
> 
> Reported-by: Bill Wendling <morbo@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Oops, I didn't actually remove libgcc!

diff --git a/Makefile b/Makefile
index 24b7917..ddebcae 100644
--- a/Makefile
+++ b/Makefile
@@ -25,8 +25,6 @@ cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
  #make sure env CFLAGS variable is not used
  CFLAGS =
  
-libgcc := $(shell $(CC) --print-libgcc-file-name)
-
  libcflat := lib/libcflat.a
  cflatobjs := \
  	lib/argv.o \
diff --git a/arm/Makefile.common b/arm/Makefile.common
index 55478ec..38385e0 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -58,9 +58,7 @@ OBJDIRS += lib/arm
  libeabi = lib/arm/libeabi.a
  eabiobjs = lib/arm/eabi_compat.o
  
-libgcc := $(shell $(CC) $(machine) --print-libgcc-file-name)
-
-FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libgcc) $(libeabi)
+FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
  %.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
  %.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o)
  	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 55f7f28..52bb7aa 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -37,12 +37,10 @@ COMMON_CFLAGS += -O1
  # stack.o relies on frame pointers.
  KEEP_FRAME_POINTER := y
  
-libgcc := $(shell $(CC) -m$(bits) --print-libgcc-file-name)
-
  # We want to keep intermediate file: %.elf and %.o
  .PRECIOUS: %.elf %.o
  
-FLATLIBS = lib/libcflat.a $(libgcc)
+FLATLIBS = lib/libcflat.a
  %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
  	$(CC) $(CFLAGS) -nostdlib -o $@ -Wl,-T,$(SRCDIR)/x86/flat.lds \
  		$(filter %.o, $^) $(FLATLIBS)


> ---
>   arm/Makefile.arm  |   1 +
>   lib/ldiv32.c      | 105 ++++++++++++++++++++++++++++++++++++++++++++++
>   x86/Makefile.i386 |   2 +-
>   3 files changed, 107 insertions(+), 1 deletion(-)
>   create mode 100644 lib/ldiv32.c
> 
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index d379a28..687a8ed 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -23,6 +23,7 @@ cstart.o = $(TEST_DIR)/cstart.o
>   cflatobjs += lib/arm/spinlock.o
>   cflatobjs += lib/arm/processor.o
>   cflatobjs += lib/arm/stack.o
> +cflatobjs += lib/ldiv32.o
>   
>   # arm specific tests
>   tests =
> diff --git a/lib/ldiv32.c b/lib/ldiv32.c
> new file mode 100644
> index 0000000..e9d434f
> --- /dev/null
> +++ b/lib/ldiv32.c
> @@ -0,0 +1,105 @@
> +#include <inttypes.h>
> +
> +extern uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem);
> +extern int64_t __moddi3(int64_t num, int64_t den);
> +extern int64_t __divdi3(int64_t num, int64_t den);
> +extern uint64_t __udivdi3(uint64_t num, uint64_t den);
> +extern uint64_t __umoddi3(uint64_t num, uint64_t den);
> +
> +uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem)
> +{
> +	uint64_t quot = 0;
> +
> +	/* Trigger a division by zero at run time (trick taken from iPXE).  */
> +	if (den == 0)
> +		return 1/((unsigned)den);
> +
> +	if (num >= den) {
> +		/* Align den to num to avoid wasting time on leftmost zero bits.  */
> +		int n = __builtin_clzll(den) - __builtin_clzll(num);
> +		den <<= n;
> +
> +		do {
> +			quot <<= 1;
> +			if (num >= den) {
> +				num -= den;
> +				quot |= 1;
> +			}
> +			den >>= 1;
> +		} while (n--);
> +	}
> +
> +	if (p_rem)
> +		*p_rem = num;
> +
> +	return quot;
> +}
> +
> +int64_t __moddi3(int64_t num, int64_t den)
> +{
> +	uint64_t mask = num < 0 ? -1 : 0;
> +
> +	/* Compute absolute values and do an unsigned division.  */
> +	num = (num + mask) ^ mask;
> +	if (den < 0)
> +		den = -den;
> +
> +	/* Copy sign of num into result.  */
> +	return (__umoddi3(num, den) + mask) ^ mask;
> +}
> +
> +int64_t __divdi3(int64_t num, int64_t den)
> +{
> +	uint64_t mask = (num ^ den) < 0 ? -1 : 0;
> +
> +	/* Compute absolute values and do an unsigned division.  */
> +	if (num < 0)
> +		num = -num;
> +	if (den < 0)
> +		den = -den;
> +
> +	/* Copy sign of num^den into result.  */
> +	return (__udivdi3(num, den) + mask) ^ mask;
> +}
> +
> +uint64_t __udivdi3(uint64_t num, uint64_t den)
> +{
> +	uint64_t rem;
> +	return __udivmoddi4(num, den, &rem);
> +}
> +
> +uint64_t __umoddi3(uint64_t num, uint64_t den)
> +{
> +	uint64_t rem;
> +	__udivmoddi4(num, den, &rem);
> +	return rem;
> +}
> +
> +#ifdef TEST
> +#include <assert.h>
> +#define UTEST(a, b, q, r) assert(__udivdi3(a, b) == q && __umoddi3(a, b) == r)
> +#define STEST(a, b, q, r) assert(__divdi3(a, b) == q && __moddi3(a, b) == r)
> +int main()
> +{
> +	UTEST(1, 1, 1, 0);
> +	UTEST(2, 2, 1, 0);
> +	UTEST(5, 3, 1, 2);
> +	UTEST(10, 3, 3, 1);
> +	UTEST(120, 3, 40, 0);
> +	UTEST(120, 1, 120, 0);
> +	UTEST(0x7FFFFFFFFFFFFFFFULL, 17, 0x787878787878787, 8);
> +	UTEST(0x7FFFFFFFFFFFFFFFULL, 0x787878787878787, 17, 8);
> +	UTEST(0x8000000000000001ULL, 17, 0x787878787878787, 10);
> +	UTEST(0x8000000000000001ULL, 0x787878787878787, 17, 10);
> +	UTEST(0, 5, 0, 0);
> +
> +	STEST(0x7FFFFFFFFFFFFFFFULL, 17, 0x787878787878787, 8);
> +	STEST(0x7FFFFFFFFFFFFFFFULL, -17, -0x787878787878787, 8);
> +	STEST(-0x7FFFFFFFFFFFFFFFULL, 17, -0x787878787878787, -8);
> +	STEST(-0x7FFFFFFFFFFFFFFFULL, -17, 0x787878787878787, -8);
> +	STEST(33, 5, 6, 3);
> +	STEST(33, -5, -6, 3);
> +	STEST(-33, 5, -6, -3);
> +	STEST(-33, -5, 6, -3);
> +}
> +#endif
> diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
> index c04e5aa..960e274 100644
> --- a/x86/Makefile.i386
> +++ b/x86/Makefile.i386
> @@ -3,7 +3,7 @@ bits = 32
>   ldarch = elf32-i386
>   COMMON_CFLAGS += -mno-sse -mno-sse2
>   
> -cflatobjs += lib/x86/setjmp32.o
> +cflatobjs += lib/x86/setjmp32.o lib/ldiv32.o
>   
>   tests = $(TEST_DIR)/taskswitch.flat $(TEST_DIR)/taskswitch2.flat \
>   	$(TEST_DIR)/cmpxchg8b.flat $(TEST_DIR)/la57.flat
> 

