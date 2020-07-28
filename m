Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F362314A0
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 23:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgG1Vbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 17:31:45 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:60375 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728149AbgG1Vbp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jul 2020 17:31:45 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2020 17:31:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595971903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UjpEBnWwNeMyM4AXLo8va3vZKuvKlfpizEQ8IIwLYbM=;
        b=Xqi43ehve4DRlwRjEehMe5gjsKY4SUdSkeZWey0yEKJQ0SNRzLSfmPLFzThOVYoTGMjfWW
        1ZnRdQoGIQ9g+8Bl42VeRi9DCUHm+lV1KTboa5FWz3R/ap5ryGgXLL12UyFPqxjtX5gI5y
        danilnSuoFmUfUfoJGLT/U/L5SYQKv0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-gwi6qt2VNIOFg2TWH7BvBQ-1; Tue, 28 Jul 2020 17:25:23 -0400
X-MC-Unique: gwi6qt2VNIOFg2TWH7BvBQ-1
Received: by mail-wm1-f69.google.com with SMTP id a5so303455wmj.5
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 14:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UjpEBnWwNeMyM4AXLo8va3vZKuvKlfpizEQ8IIwLYbM=;
        b=keMoZ5/gRZQJyNFT6zVDUzF03NJ8Me8MTFaTlJCGffkNId1/erq5eoIA5OyS+NiiCW
         a61qZgGzk6iMMmaiNYUm+J+qBJfdRYb+YObin4BJvAIrVbxsi0O7DRvkDXjwd6VrN+Lz
         L3PN/Kvw1ln4o1RIYslYPdb9kbrrHSZnPi2bMhqbrm2V9VOl+D3JFXaHhz0tzcR/eeKK
         a7ae5GnWORI7TCrpo+/99yAvl5vALP6pr5obIoiMmJiRvwbXLkrM5q3lsOIrcDVRAfuW
         mD+o/TB3atvorhJty6bSs+L5+pzr865+JoUFVl9a29Nn57f/7aEgY1HIt1Aj2eUdSxSr
         nqOg==
X-Gm-Message-State: AOAM5304gaB0xxrPOzUzubNhd+BsWHYLz9/7gFxSj4ChQv/X6WrPY78V
        H681NRkoySyu8AMdiQa4h5GpxO8f1zwwDjjN9ht8DHipP0a20Fd02Z20r6j4eNoVBCt2nH3ALZb
        iNyzgPEvXbFbW
X-Received: by 2002:a1c:2109:: with SMTP id h9mr5541034wmh.174.1595971522628;
        Tue, 28 Jul 2020 14:25:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvS4Yoat8bT0HyeCP4HpI77T+segRt+fHEYM4hC3RLBuQTzQc+DrZBzPSyirYQqHWAZtm+xg==
X-Received: by 2002:a1c:2109:: with SMTP id h9mr5541021wmh.174.1595971522363;
        Tue, 28 Jul 2020 14:25:22 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id f15sm155948wmj.39.2020.07.28.14.25.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 14:25:21 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] arm64: Compile with -mno-outline-atomics
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com
References: <20200728121751.15083-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <07b701a3-927c-abd1-2177-e18eade53224@redhat.com>
Date:   Tue, 28 Jul 2020 23:25:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200728121751.15083-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/20 14:17, Andrew Jones wrote:
> GCC 10.1.0 introduced the -moutline-atomics option which, when
> enabled, use LSE instructions when the processor provides them.
> The option is enabled by default and unfortunately causes the
> following error at compile time:
> 
>  aarch64-linux-gnu-ld: /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a(lse-init.o): in function `init_have_lse_atomics':
>  lse-init.c:(.text.startup+0xc): undefined reference to `__getauxval'
> 
> This is happening because we are linking against our own libcflat which
> doesn't implement the function __getauxval().
> 
> Disable the use of the out-of-line functions by compiling with
> -mno-outline-atomics.
> 
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  Makefile           | 11 +++++------
>  arm/Makefile.arm64 |  3 +++
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 3ff2f91600f6..0e21a49096ba 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -17,6 +17,11 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
>  
>  .PHONY: arch_clean clean distclean cscope
>  
> +# cc-option
> +# Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
> +cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> +              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
> +
>  #make sure env CFLAGS variable is not used
>  CFLAGS =
>  
> @@ -43,12 +48,6 @@ OBJDIRS += $(LIBFDT_objdir)
>  #include architecture specific make rules
>  include $(SRCDIR)/$(TEST_DIR)/Makefile
>  
> -# cc-option
> -# Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
> -
> -cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> -              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
> -
>  COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
>  COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
>  COMMON_CFLAGS += -Wignored-qualifiers -Werror
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index dfd0c56fe8fb..dbc7524d3070 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -9,6 +9,9 @@ ldarch = elf64-littleaarch64
>  arch_LDFLAGS = -pie -n
>  CFLAGS += -mstrict-align
>  
> +mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
> +CFLAGS += $(mno_outline_atomics)
> +
>  define arch_elf_check =
>  	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
>  		$(error $(shell $(OBJDUMP) -R $(1) 2>&1)))
> 

Queued, thanks.

Paolo

