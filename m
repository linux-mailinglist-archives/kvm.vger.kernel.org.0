Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF17F1EFC51
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 17:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgFEPPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 11:15:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47798 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726742AbgFEPPr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 11:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591370145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2LZ042NKXuZSk37xPV2YBjm3wEqnukBdV4tzmVILjAs=;
        b=eISPYu0MdZPmdmFuYB30WGby2lrEjqv+Y3UCCYadMJMWJ3Fp7xOiGJEYFr4xm/OmyRMgio
        KQMX1psTP2bVgY6l9zsYHYi3wEIam7ZLiOuRHokJTNUmwCTSgNNIqfQrbKHjVow/KyN9IY
        +dYtuIvRhILsCZg0o0D08f9R3rQRj3s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-Ik3o4_DiOSGBjnAbMEY3Jg-1; Fri, 05 Jun 2020 11:15:44 -0400
X-MC-Unique: Ik3o4_DiOSGBjnAbMEY3Jg-1
Received: by mail-wr1-f70.google.com with SMTP id e7so3910736wrp.14
        for <kvm@vger.kernel.org>; Fri, 05 Jun 2020 08:15:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2LZ042NKXuZSk37xPV2YBjm3wEqnukBdV4tzmVILjAs=;
        b=Kq2HiBO1o5iwb9J381T6kBO17NT0vKXsGmrI8b4kdyqhA3kdA6Dc3kq2mI6E+4F8Nf
         tp2zVxBmaweH1mQbcgbFSiwS4MAbbyvGPs2Ve3+S+YEsP4nkb8boqt0WP66AaDtH2kXq
         l2xWfTYO36k+W1PDzLpuqjO0yVOFsYvfkT+Xn5CSDowgi6HKxeFzUySzFRJsfl/7beVm
         VbM1Ubv8tJW3yE7/SsgSpqC4XduluH/ZXjhvb8qTcwpm7WdAwJ9pMd9GVAZcHOs/8yQ5
         OPuk/6uYDW+bfNf2dHLZIbWFtoL3rD2yXzmYW+Dtoh33gl4AQJvb84PTE1Cm+UwD3/+/
         SJ0Q==
X-Gm-Message-State: AOAM532CjkXhq9ueTpRdF6GX736pxHkstQTDDFSaOWH9BThEDUMpZ7r1
        r+PtzAnAQupocSEw2zshh5yoqT06XzrYciJ93IVdeDBGKoGx6KEHYN0NFrJUUkj3JS3OzmIpPyL
        fUvDQBLDtmayx
X-Received: by 2002:adf:f5ca:: with SMTP id k10mr9823888wrp.305.1591370143008;
        Fri, 05 Jun 2020 08:15:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXxwZl8T7LVrTQ8PhwkZAl8jHVWXIG49L1Dn2Zy1Lxyv0P2h706pufSNF6CZ9zbfegOCGfxw==
X-Received: by 2002:adf:f5ca:: with SMTP id k10mr9823862wrp.305.1591370142776;
        Fri, 05 Jun 2020 08:15:42 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.243.176])
        by smtp.gmail.com with ESMTPSA id z25sm11517310wmf.10.2020.06.05.08.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 08:15:41 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Fix "make ARCH=x86_64" build with
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Bandeira Condotta <mcondotta@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <20200605142028.550068-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3a229624-c452-c86d-395d-2baa7392cb62@redhat.com>
Date:   Fri, 5 Jun 2020 17:15:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200605142028.550068-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/20 16:20, Vitaly Kuznetsov wrote:
> Marcelo reports that kvm selftests fail to build with
> "make ARCH=x86_64":
> 
> gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99
>  -fno-stack-protector -fno-PIE -I../../../../tools/include
>  -I../../../../tools/arch/x86_64/include  -I../../../../usr/include/
>  -Iinclude -Ilib -Iinclude/x86_64 -I.. -c lib/kvm_util.c
>  -o /var/tmp/20200604202744-bin/lib/kvm_util.o
> 
> In file included from lib/kvm_util.c:11:
> include/x86_64/processor.h:14:10: fatal error: asm/msr-index.h: No such
>  file or directory
> 
>  #include <asm/msr-index.h>
>           ^~~~~~~~~~~~~~~~~
> compilation terminated.
> 
> "make ARCH=x86", however, works. The problem is that arch specific headers
> for x86_64 live in 'tools/arch/x86/include', not in
> 'tools/arch/x86_64/include'.
> 
> Fixes: 66d69e081b52 ("selftests: fix kvm relocatable native/cross builds and installs")
> Reported-by: Marcelo Bandeira Condotta <mcondotta@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index b4ff112e5c7e..4a166588d99f 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -83,7 +83,11 @@ LIBKVM += $(LIBKVM_$(UNAME_M))
>  INSTALL_HDR_PATH = $(top_srcdir)/usr
>  LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
>  LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
> +ifeq ($(ARCH),x86_64)
> +LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
> +else
>  LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
> +endif
>  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
>  	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>  	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
> 

Queued, thanks.

Paolo

