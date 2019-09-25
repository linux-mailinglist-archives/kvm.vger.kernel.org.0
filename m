Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB198BD951
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 09:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437171AbfIYHsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 03:48:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437378AbfIYHsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 03:48:38 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 092B388305
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 07:48:38 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id c188so1484883wmd.9
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 00:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IS7JBZ9zrqGVDeRJNFg8m1nKnd2cfm4f/OwgwdjTPRw=;
        b=WsjLdnGz5ehNzbbpbB/+oQtyHioPL+sRueuGX4wXeVfN2yzE1kh+5Y1KcPSFakC+rg
         DDxpirnChlFxQa1TRCOC+LdUn8dRPBhtGUxd8dUZqL8DWv6BFY+acEeIHzK/lL7GUiQQ
         NSOGDhU0NfqqnMCgCBV/l5O3TVZ2H2/ypJfS08RJfTOHQMVMlyCMO+qh2vuNY7fiCqoo
         iPjyZkjSOEbw3E+7gzeqJ5ip+PBcV6sv+sXHQSXiz/ENCKZK3QHeoinwKEGj1OxwJbLu
         Fec2B8y+ph0m0zWgvuzHNHMBeXknJghUnSprKNJrRW8C150AvaBO/SQRrdPBq72R2bSv
         Q1hg==
X-Gm-Message-State: APjAAAUhE/QseIDH2+ucLOK8i/jG+l8KeKxzmRyMwwgomDWna2zKtZJs
        z/JHRUgT79MLoFZLSTX5JH8voz8l8hj/CeSC7iUxUruNCi3vyWSvHA1SQbEGLfsOboDkewDkgJo
        OnAgtGAIuqHMh
X-Received: by 2002:a5d:4307:: with SMTP id h7mr7531882wrq.393.1569397716630;
        Wed, 25 Sep 2019 00:48:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxEpJogKzLfOpsHXL9nPwehQ4M6oLQikRQicx68vJp+AA1DzSOcYm+nBkEmeMRY8Vw9e5ddRg==
X-Received: by 2002:a5d:4307:: with SMTP id h7mr7531843wrq.393.1569397716293;
        Wed, 25 Sep 2019 00:48:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id d28sm7228325wrb.95.2019.09.25.00.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 00:48:35 -0700 (PDT)
Subject: Re: [PATCH] selftests: kvm: Fix libkvm build error
To:     Shuah Khan <skhan@linuxfoundation.org>, rkrcmar@redhat.com,
        shuah@kernel.org
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190924201451.31977-1-skhan@linuxfoundation.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <dbfb9d46-488a-b940-c86f-79ad750a324a@redhat.com>
Date:   Wed, 25 Sep 2019 09:48:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924201451.31977-1-skhan@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/19 22:14, Shuah Khan wrote:
> Fix the following build error:
> 
> libkvm.a(assert.o): relocation R_X86_64_32 against `.rodata.str1.1' can not be used when making a PIE object; recompile with -fPIC
> 
> Add -fPIC to CFLAGS to fix it.

This is wrong, these testcases cannot be position-independent 
executables.  Can you include the failing command line from "V=1" 
output?

The problem seems to be that these definitions are not working properly:

no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
        $(CC) -Werror $(KBUILD_CPPFLAGS) $(CC_OPTION_CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)

LDFLAGS += -pthread $(no-pie-option)

Thanks,

Paolo

> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>  tools/testing/selftests/kvm/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 62c591f87dab..b4a55d300e75 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -44,7 +44,7 @@ INSTALL_HDR_PATH = $(top_srcdir)/usr
>  LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
>  LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
>  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
> -	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
> +	-fno-stack-protector -fPIC -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>  	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(UNAME_M) -I..
>  
>  no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
> 

