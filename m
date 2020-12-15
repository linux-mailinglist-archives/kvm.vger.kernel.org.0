Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4972DAEA0
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgLOOK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbgLOOKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 09:10:45 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40B9C0617A6
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:09:57 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id l207so23446003oib.4
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ecayntQDo1x+F25YKQ63YC5+lE3CV+QHl2rJeTtz5lw=;
        b=My2UM26pw7sgEoSCvu/ocU340lzzf/6arnVKIdQS8grRSw2Pm8uaiXRj3dvpzHex1Z
         sXwRZJBdgNdtBhG/9vi6t+X6PWg0CAct+eY6ws5B4dx0flJaFSZ/1bnzTQ3gSmME1r1G
         Ic5uf75mmUh9LvjsUWo54Tr/ZG3Qf7Ui/9OT5KX5+Jy+zFLlHLdaSK9Egg1L28WACbLc
         gdTbKz3qMbhxEwkMyJOPmTpj66mg+7vaITFpgoQrH0a5sVA3ep99cIt4uPEcf5SbqU8Z
         idHtqjK9W54UwiC7XQ4AoFhAYTSJubwnvN6rSpfUFOX/7InBBDb+xjVbKdhbiGVo947/
         sG9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ecayntQDo1x+F25YKQ63YC5+lE3CV+QHl2rJeTtz5lw=;
        b=exBq0Vpf1oeCDo3NPNdD/UL/WMmWhQt9B60sJSnIjuJJDONZErgsugb86jywRbdpjW
         ExZt1JjVS6tVMV8tCIvMWYt9M/JzZya3scryA9eWVUQHi+O+BtwgyZcszJUZLWP2tvCg
         e+D5WJYRsFmqNSH8XHvu21GAa4LZhqyYyXDh6R2YEzRV/4BvCSYnE4m0OWaKTinswpTH
         vWlZYvVAdG7I2B2x5NBpOTAMbQXJKC2H4uA1+1oxmmghDtDnGjvuNWcUfJNSWKc97Vei
         i/jiZVqugRbY28ftBtB0yqRQBXH2qSvrE+aTwtlSRVTsLaaP1oXxDECUpIDLtiy09dN2
         lh+w==
X-Gm-Message-State: AOAM532iJiHEo0nlmxdS426SXIUXi/dcyuwvwR7UTva/0BKdkDUZ5atK
        6FVhIY0GOVUxxMd5tPzVQLnt1g==
X-Google-Smtp-Source: ABdhPJyg4XreSkxXZJCpdyoXSX9GadX58IVReFW1lxN1UArO8sNj8lB81tYJL2K2fau9Ur5op87UDQ==
X-Received: by 2002:aca:eb44:: with SMTP id j65mr21577458oih.19.1608041397269;
        Tue, 15 Dec 2020 06:09:57 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id y35sm431688otb.5.2020.12.15.06.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 06:09:56 -0800 (PST)
Subject: Re: [PATCH v2 11/16] target/mips: Replace gen_exception_end(EXCP_RI)
 by gen_rsvd_instruction
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201214183739.500368-1-f4bug@amsat.org>
 <20201214183739.500368-12-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <7c64072d-4999-1af6-bbe2-eeaea3553af4@linaro.org>
Date:   Tue, 15 Dec 2020 08:09:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214183739.500368-12-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:37 PM, Philippe Mathieu-Daudé wrote:
> gen_reserved_instruction() is easier to read than
> generate_exception_end(ctx, EXCP_RI), replace it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.c | 724 ++++++++++++++++++++--------------------
>  1 file changed, 362 insertions(+), 362 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

