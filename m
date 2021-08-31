Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279293FC5E3
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 13:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbhHaKcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 06:32:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27433 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240974AbhHaKcE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 06:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630405869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nlTta2mV56SuSv99vIPxNi96qiLFa1ReRjcQibp4doM=;
        b=IDDWxOvjDFHJWTFgJmXSTE8CLVBkZdWouJvNo/TX7iuPlH1vkhVoP1ULj9br9ESZcyFai0
        Qb3UrVH4pCWWmCxBsLOfYa6L9TEmJaG6a7Ncl6k/CjLALf001mauR4pt1g8VY8hRhyOf8K
        g9ptTFnOAdARIglpMYmF+4tDVChQ1vs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-8vugZP3uOuyXKKPjSJcmBw-1; Tue, 31 Aug 2021 06:31:07 -0400
X-MC-Unique: 8vugZP3uOuyXKKPjSJcmBw-1
Received: by mail-ed1-f69.google.com with SMTP id h4-20020aa7c604000000b003c423efb7efso414224edq.12
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 03:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nlTta2mV56SuSv99vIPxNi96qiLFa1ReRjcQibp4doM=;
        b=pnHKTRey47AgU5A95PmABz4tUDrYZnOP/TBTQKA8SgPE7ZUnBKOGTSC/syhAgBfcym
         M08I8mBdtATf16OQU4BQzkRmWE9ck3klfN/nuyO+PUITcqe+lxN64MgM4EQvHYkrSHfO
         X2cCp3Uv4h+mb/q0riPGf4DGLMo245sgoVb0OJeIDlU6xfltBfhI5LWIJPWKvLEZmqdU
         LwqscZHoLkctUxA3d/5ZV81251g4p4FnBuU3yhyszdjWVBxEdJtPo4YnIactSWwquGrb
         3Mt/tE9TrDjUZ5lNzpmu6LspDjIUj+m8NGwd2UL9IhO4EucVMIyhZpHSR07GdiN9MDkv
         VD7g==
X-Gm-Message-State: AOAM532m8kmmVuyRx2jfX7Ms8O+JvhjY4Q3UsxTx6gr2rAGPnV/SJZ1I
        qP9Uqei86O138vX5JeI5BSRxC0p/xCPt+VAKhrp+Ot2D8y/NYmU/tTiu12mHMBfGnt4C9Yr3Zsw
        qt/2T85euNQX5
X-Received: by 2002:a17:906:7714:: with SMTP id q20mr30212540ejm.551.1630405866694;
        Tue, 31 Aug 2021 03:31:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGRQ1Wk+s/heU7vlVpz0mWTK9xZSWwumaWbeEA4+OaCKfHDVL3AyBzGxbfpO4PLRayfleP3g==
X-Received: by 2002:a17:906:7714:: with SMTP id q20mr30212520ejm.551.1630405866552;
        Tue, 31 Aug 2021 03:31:06 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id i13sm9128821edc.48.2021.08.31.03.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 03:31:06 -0700 (PDT)
Date:   Tue, 31 Aug 2021 12:31:03 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, jacobhxu@google.com, jingzhangos@google.com,
        pshier@google.com, rananta@google.com, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH] arm64: Link with -z notext
Message-ID: <20210831103103.mrb74fv6eml7hfiw@gator.home>
References: <20210819223047.2813268-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819223047.2813268-1-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021 at 03:30:47PM -0700, Ricardo Koller wrote:
> Building the tests on arm64 fails when using LLD (the LLVM linker):
> 
>   ld.lld: error: can't create dynamic relocation R_AARCH64_ABS64 against
>   local symbol in readonly segment; recompile object files with -fPIC or
>   pass '-Wl,-z,notext' to allow text relocations in the output
>   >>> defined in lib/libcflat.a(processor.o)
>   >>> referenced by processor.c
>   >>>               processor.o:(vector_names) in archive lib/libcflat.a
> 
> The reason is that LLD defaults to errors for text relocations. The GNU
> LD defaults to let it go. In fact, the same error can be reproduced when
> using GNU LD with the '-z text' arg (to error on text relocations):
> 
>   aarch64-linux-gnu-ld: read-only segment has dynamic relocations
> 
> Fix this link error by adding `-z notext` into the arm64 linker flags.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/Makefile.arm64 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index dbc7524..e8a38d7 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -7,6 +7,7 @@ bits = 64
>  ldarch = elf64-littleaarch64
>  
>  arch_LDFLAGS = -pie -n
> +arch_LDFLAGS += -z notext
>  CFLAGS += -mstrict-align
>  
>  mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
> -- 
> 2.33.0.rc2.250.ged5fa647cd-goog
>

Applied to arm/queue and merged to master.

Thanks,
drew 

