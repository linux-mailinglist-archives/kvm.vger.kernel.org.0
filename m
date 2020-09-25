Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09B0278160
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 09:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbgIYHRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 03:17:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47156 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727132AbgIYHRL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 03:17:11 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601018229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PNpwrA8lXOvHab/9QCkiz1jy97WA5iVNthaa2NHSm0g=;
        b=h1D61jko0yjk+8QlvQ49xvmk3OviRHuEDoa6ZrNAOQrVMj8vE8AhfPFzdzZC48+WixjAK6
        lt0GUb2YipGFZ1Ts3oSSv4FCGsPxjwQjTRQiqL/vxLFlUw9/MBNZH2jLXIemxpF6mX8EXM
        LHJ0rOHVNZtSNLlSQJSfn/InHcTimsA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-MG7ZzTUBNLahbmi9bl5zxQ-1; Fri, 25 Sep 2020 03:17:03 -0400
X-MC-Unique: MG7ZzTUBNLahbmi9bl5zxQ-1
Received: by mail-wm1-f72.google.com with SMTP id s24so496664wmh.1
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 00:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PNpwrA8lXOvHab/9QCkiz1jy97WA5iVNthaa2NHSm0g=;
        b=qv3Tmw4Ssvqt2y/cwceKk4pbROBsO2J5odfm7Z2dMxwzfKIqLf0CDdI4TWWsNHW99z
         e6elLT7SXdQhauOeoDGpuJrCW2/hmsHgTrqMqS8gfSkw0sS6Q887t4pDWuz4GjUQYDzx
         iJY+GTwhqIkUy+TnXwaaJgufZn+TmT/KOYCdQ7QN830CdueF43e0EGwITGfgMpHkNmIN
         6s4a/9f8Mzvp5I/CnUYGwFYcBBhTRantWAUtelgFtvz+uVi+E/R9vsqymLoCnnOdN1Nh
         bkVIsZO9qAGCSAtiSq+0M7kvDri86tnk3WlokIrs03mn8DhxXxOnQXZXCqmD6yz2awbT
         ScSA==
X-Gm-Message-State: AOAM5320t9SbFtx6klw/Z5NttNytv//hs+TVQekvk8eS5rZMz12MBUfe
        fC1LWlBuRR4fANoJdK9Rmy/6dZiF9ICNzqLneiru18/iJTs4aJV2Mjm15Y1AI5W85FRMlW6dMx4
        A11WeAfmrGiUj
X-Received: by 2002:adf:ec90:: with SMTP id z16mr2734724wrn.145.1601018221503;
        Fri, 25 Sep 2020 00:17:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDhvIZou+0OaNn+/6RrZTfn4XEB6Vgx6udwTFWZmSQw2PZsRw/+5bwv8MDOgaODUknADHsnQ==
X-Received: by 2002:adf:ec90:: with SMTP id z16mr2734696wrn.145.1601018221170;
        Fri, 25 Sep 2020 00:17:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id n4sm1721900wrp.61.2020.09.25.00.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 00:17:00 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] configure: Test if compiler supports -m16
 on x86
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>
References: <20200924182401.95891-1-r.bolshakov@yadro.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <36271d1b-70b5-a6d8-41df-d1c94a9c6504@redhat.com>
Date:   Fri, 25 Sep 2020 09:17:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924182401.95891-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 20:24, Roman Bolshakov wrote:
> -m16 option is available only since GCC 4.9.0 [1]. That causes a build
> failure on centos-7 [2] that has GCC 4.8.5.
> 
> Fallback to -m32 if -m16 is not available.
> 
> 1. http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59672
> 2. https://gitlab.com/bonzini/kvm-unit-tests/-/jobs/755368387
> 
> Fixes: 2616ad934e2 ("x86: realmode: Workaround clang issues")
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>

This is a simpler way to do it:

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 5567d66..781dba6 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -72,7 +72,7 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
 	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
 	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
 
-$(TEST_DIR)/realmode.o: bits = 16
+$(TEST_DIR)/realmode.o: bits := $(if $(call cc-option,-m16,""),16,32)
 
 $(TEST_DIR)/kvmclock_test.elf: $(TEST_DIR)/kvmclock.o

It's a tiny bit slower because the check is done on every compilation,
but only if realmode.o is stale.

It passes CI (https://gitlab.com/bonzini/kvm-unit-tests/-/pipelines/194356382)
so I plan to commit it.

Paolo

> ---
>  configure           | 11 +++++++++++
>  x86/Makefile.common |  4 ++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/configure b/configure
> index f930543..7dc2e3b 100755
> --- a/configure
> +++ b/configure
> @@ -16,6 +16,7 @@ pretty_print_stacks=yes
>  environ_default=yes
>  u32_long=
>  wa_divide=
> +m16_support=
>  vmm="qemu"
>  errata_force=0
>  erratatxt="$srcdir/errata.txt"
> @@ -167,6 +168,15 @@ EOF
>    rm -f lib-test.{o,S}
>  fi
>  
> +# check if -m16 is supported
> +if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
> +  cat << EOF > lib-test.c
> +int f(int a, int b) { return a + b; }
> +EOF
> +  m16_support=$("$cross_prefix$cc" -m16 -c lib-test.c >/dev/null 2>&1 && echo yes)
> +  rm -f lib-test.{o,c}
> +fi
> +
>  # require enhanced getopt
>  getopt -T > /dev/null
>  if [ $? -ne 4 ]; then
> @@ -224,6 +234,7 @@ ENVIRON_DEFAULT=$environ_default
>  ERRATATXT=$erratatxt
>  U32_LONG_FMT=$u32_long
>  WA_DIVIDE=$wa_divide
> +M16_SUPPORT=$m16_support
>  EOF
>  
>  cat <<EOF > lib/config.h
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 5567d66..553bf49 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -72,7 +72,11 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
>  	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
>  	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
>  
> +ifeq ($(M16_SUPPORT),yes)
>  $(TEST_DIR)/realmode.o: bits = 16
> +else
> +$(TEST_DIR)/realmode.o: bits = 32
> +endif
>  
>  $(TEST_DIR)/kvmclock_test.elf: $(TEST_DIR)/kvmclock.o
>  
> 

