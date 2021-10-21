Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490E043615D
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 14:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhJUMVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 08:21:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58295 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231748AbhJUMVS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 08:21:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634818742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zd9X4kJySNLoJ8Ppj29kUsFq4oKh9GPumZUthxZxjSI=;
        b=KxHG9mTqL3ahth9YT49iDupEMzxkqX2kpQiQQjvwDxoJffLgcn+YjVt7Mqd5eAbsdpgdze
        pgPIoalUKQ63yVB04ysNg2RHehLQCeWRTCOPMDJE1faHiuUmzSiPrAGjv6V+3aiEBv0Zu2
        M9taqOIVBOgvJMK9EFa0AZmZtQ/GgOQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-GhJOSjnwN3OUei1DyexUFw-1; Thu, 21 Oct 2021 08:18:23 -0400
X-MC-Unique: GhJOSjnwN3OUei1DyexUFw-1
Received: by mail-ed1-f70.google.com with SMTP id p20-20020a50cd94000000b003db23619472so81553edi.19
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 05:18:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Zd9X4kJySNLoJ8Ppj29kUsFq4oKh9GPumZUthxZxjSI=;
        b=CQyS7hCHbRbcAREL8W9NiZyDEYRJs/0cu9c6ovt6f39RvtEdPRHkIE/hTtuPXE13TB
         nkkE5r8Esu1Rtqm3kqpga8SHX8mzjdYVOe0hx09Bp5W9Y8BCkkTyqA/KZcS0lPHbNmeE
         WR3hJRbon5OaBgek1ZRRvUB92Qn0KBeN6S5E0PiWKPQAwGN9nSl6HyCBJVz/kw9zd6fh
         6Yn859QvBaIhZxEmIIeD6ABHsGXzMQTecksWhHE2WtxCgcKNBMjd4pM1Pla9yw4Nj8QQ
         7uJbpYnPxqCTkJqM+ebBrNaUJa13AdMop0Rzt5v0Nf0Jd/r9z+MkcuEl4zOTvY9UWkUT
         /QTQ==
X-Gm-Message-State: AOAM532EHCvhGAFhLzbyo5ETeP9fZyZTPb0vwevmVrDDkgESjJLpF5dV
        dm8VxbULOnI9IKhmK7eYPs4s2XhZj99NTN7uTMxck3gva+FHESKH473FqQfe97OgZ84PEraxLj3
        ssHEU/9EpnyvF
X-Received: by 2002:a17:906:254b:: with SMTP id j11mr6808900ejb.513.1634818683363;
        Thu, 21 Oct 2021 05:18:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytEpmfnDKcxFNHgYn23PL49Reg55UlSfeSZvp3Cq+CrLLsTXfDXlrlbFs+daaWBI53MQvpGA==
X-Received: by 2002:a17:906:254b:: with SMTP id j11mr6808878ejb.513.1634818683134;
        Thu, 21 Oct 2021 05:18:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id q14sm2889195edj.42.2021.10.21.05.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 05:18:02 -0700 (PDT)
Message-ID: <1f0144a6-3eb5-ad58-e1c2-68c8fcc29841@redhat.com>
Date:   Thu, 21 Oct 2021 14:18:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 05/17] x86 UEFI: Boot from UEFI
Content-Language: en-US
To:     Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <20211004204931.1537823-6-zxwang42@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211004204931.1537823-6-zxwang42@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/21 22:49, Zixuan Wang wrote:
> From: Zixuan Wang <zixuanwang@google.com>
> 
> This commit provides initial support for x86 test cases to boot from
> UEFI:
> 
>     1. UEFI compiler flags are added to Makefile
>     2. A new TARGET_EFI macro is added to turn on/off UEFI startup code
>     3. Previous Multiboot setup code is refactored and updated for
>        supporting UEFI, including the following changes:
>        1. x86/efi/crt0-efi-x86_64.S: provides entry point and jumps to
>           setup code in lib/efi.c.
>        2. lib/efi.c: performs UEFI setup, calls arch-related setup
>           functions, then jumps to test case main() function
>        3. lib/x86/setup.c: provides arch-related setup under UEFI
> 
> To build test cases for UEFI, please first install the GNU-EFI library.
> Check x86/efi/README.md for more details.
> 
> This commit is tested by a simple test calling report() and
> report_summayr(). This commit does not include such a test to avoid
> unnecessary files added into git history. To build and run this test in
> UEFI (assuming file name is x86/dummy.c):
> 
>     ./configure --target-efi
>     make x86/dummy.efi
>     ./x86/efi/run ./x86/dummy.efi
> 
> To use the default Multiboot instead of UEFI:
> 
>     ./configure
>     make x86/dummy.flat
>     ./x86/run ./x86/dummy.flat
> 
> Some x86 test cases require additional fixes to work in UEFI, e.g.,
> converting to position independent code (PIC), setting up page tables,
> etc. This commit does not provide these fixes, so compiling and running
> UEFI test cases other than x86/dummy.c may trigger compiler errors or
> QEMU crashes. These test cases will be fixed by the follow-up commits in
> this series.
> 
> The following code is ported from github.com/rhdrjones/kvm-unit-tests
>     - ./configure: 'target-efi'-related code
> 
> See original code:
>     - Repo: https://github.com/rhdrjones/kvm-unit-tests
>     - Branch: target-efi
> 
> Co-developed-by: Varad Gautam <varad.gautam@suse.com>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> Signed-off-by: Zixuan Wang <zixuanwang@google.com>

This is missing

diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
index 340c561..7d19d55 100644
--- a/x86/Makefile.i386
+++ b/x86/Makefile.i386
@@ -2,6 +2,7 @@ cstart.o = $(TEST_DIR)/cstart.o
  bits = 32
  ldarch = elf32-i386
  exe = flat
+bin = elf
  COMMON_CFLAGS += -mno-sse -mno-sse2

  cflatobjs += lib/x86/setjmp32.o lib/ldiv32.o

for 32-bit tests to build; and also:

diff --git a/configure b/configure
index b6c09b3..6f4a8f0 100755
--- a/configure
+++ b/configure
@@ -265,6 +265,11 @@ if [ -f "$srcdir/$testdir/run" ]; then
      ln -fs "$srcdir/$testdir/run" $testdir-run
  fi

+testsubdir=$testdir
+if [ -n "$target_efi" ]; then
+    testsubdir=$testdir/efi
+fi
+
  # check if uint32_t needs a long format modifier
  cat << EOF > lib-test.c
  __UINT32_TYPE__
@@ -291,8 +301,11 @@ if test ! -e Makefile; then
      ln -s "$srcdir/Makefile" .

      echo "linking tests..."
-    mkdir -p $testdir
+    mkdir -p $testsubdir
      ln -sf "$srcdir/$testdir/run" $testdir/
+    if test "$testdir" != "$testsubdir"; then
+        ln -sf "$srcdir/$testsubdir/run" $testsubdir/
+    fi
      ln -sf "$srcdir/$testdir/unittests.cfg" $testdir/
      ln -sf "$srcdir/run_tests.sh"

@@ -332,6 +345,7 @@ OBJDUMP=$cross_prefix$objdump
  AR=$cross_prefix$ar
  ADDR2LINE=$cross_prefix$addr2line
  TEST_DIR=$testdir
+TEST_SUBDIR=$testsubdir
  FIRMWARE=$firmware
  ENDIAN=$endian
  PRETTY_PRINT_STACKS=$pretty_print_stacks
diff --git a/run_tests.sh b/run_tests.sh
index 9f233c5..f61e005 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -31,7 +31,7 @@ specify the appropriate qemu binary for ARCH-run.
  EOF
  }

-RUNTIME_arch_run="./$TEST_DIR/run"
+RUNTIME_arch_run="./$TEST_SUBDIR/run"
  source scripts/runtime.bash

  # require enhanced getopt


As of this patch tests don't seem to work correctly, but at least the 
build machinery works (they build and ./x86/efi/run starts them).

./run_tests.sh does not work, either.

Paolo

