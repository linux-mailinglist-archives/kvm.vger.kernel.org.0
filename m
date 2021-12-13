Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078E14733BB
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 19:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241756AbhLMSOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 13:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238474AbhLMSOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 13:14:38 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A7AC061574;
        Mon, 13 Dec 2021 10:14:38 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r25so54497725edq.7;
        Mon, 13 Dec 2021 10:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=50euq+cG/vcQRPIfg8teXOk2oPJ4jzE199hwQRYlI14=;
        b=qUkxdzzVPemsxNwAeSQo41N6ibgK2KjmQj25TUS4Y/uYZxhCj0r+uZkOwSjxgypMYy
         /GdvaRJnPId4zqzxQuZWlTELtkwSd3/RSTnRWXgXdrjhH6tsElXC28cQ9U60h1tDLikm
         cM4GEcaRgpYUvwrXL/875+xZiQ6gK2iFBd74t7mHhPTRTbL3teP/bFbo5bml8Tg68DDQ
         VIP2BNTGUZlR27lIT/2oOTbQw21bW6SeHR0sCpgk63gVVnTZYeTY0q+b9Ro8Z9v8QrTh
         ng/0Ai0wMO6YlwDIkjNVqAiSbgVYst/7Y8/O7iyK8y78te/61PZZ4v+mGIBHm7KjaGHO
         AfLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=50euq+cG/vcQRPIfg8teXOk2oPJ4jzE199hwQRYlI14=;
        b=mtEqWSig8caY/PIc6eZWhCqAqAjI/g2vVhW+9qrRuQMsBu1aWw27UefWQSuHlKRiTX
         hVzM0uQM32BIekeEOjjpUAIpSEDQAAFe7T3d8AtyIhU+s2WIJ4QiaLqkODTSQK3+9oP9
         NP4yaMPrPmbp70CQ1/HO1JDn5s4uoroncidoE8LrLMQcp9e7kVbwmPvROm9ZAlpIS4sJ
         XqqEX3Hc7+CHxpI0nB/r7+nTmrshER0diNY+2Nd/KnR+SDCVanoq3b+jjOmTUJ+8t9cs
         M4+/n8rEMYKKfRiOzBJaUedR5CdTMllsZzIjRvqm8Rx9kxayTxB6ZImPrfdHIcRqtCCY
         fH0w==
X-Gm-Message-State: AOAM532vhAU5PSqdX/JqluRXcvbU7cbpCIY0hp/+j1QVJ1vGILnC6ves
        koWxkzJYjSd4hpeBFiGEHPk=
X-Google-Smtp-Source: ABdhPJzbra1qn1rRVcfdx10qy2UGNdWw3/8qNkzlkGBmgv6ZnyBkQM1K5nXC1lIlnrYxi9YyQ76dzA==
X-Received: by 2002:a17:906:478e:: with SMTP id cw14mr64247ejc.46.1639419276863;
        Mon, 13 Dec 2021 10:14:36 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id cb20sm3077977edb.19.2021.12.13.10.14.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 10:14:36 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <0151dccd-d7a8-cf69-3f85-6474cb39d36b@redhat.com>
Date:   Mon, 13 Dec 2021 19:14:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: linux-next: manual merge of the kvm tree with the tip tree
Content-Language: en-US
To:     broonie@kernel.org, KVM <kvm@vger.kernel.org>
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
References: <20211213174628.178270-1-broonie@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213174628.178270-1-broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/21 18:46, broonie@kernel.org wrote:
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> diff --cc arch/arm64/kvm/Makefile
> index 0bcc378b79615,04a53f71a6b63..0000000000000
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@@ -10,9 -10,7 +10,7 @@@ include $(srctree)/virt/kvm/Makefile.kv
>    obj-$(CONFIG_KVM) += kvm.o
>    obj-$(CONFIG_KVM) += hyp/
>    
> - kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
> - 	 $(KVM)/vfio.o $(KVM)/irqchip.o $(KVM)/binary_stats.o \
> - 	 arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>   -kvm-y += arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
> ++kvm-y := arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \

This is mostly okay, but it needs to be "+=" instead of ":=".

Paolo
