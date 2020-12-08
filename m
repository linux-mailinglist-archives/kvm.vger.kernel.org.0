Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB8F2D35AE
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbgLHV4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 16:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbgLHV4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 16:56:40 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCF2C0613D6
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 13:56:00 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id v85so176491oia.6
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 13:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ykm1CW81/1yVrovVuyB6hv6LMEyheoG0djpb+ytEzLg=;
        b=CohF/Y9Hqo9Ac2AUx2gO8PT4OyUy6EF18fpcoa+n6NtdqI3jo5MHZ/1lUJSmqmI8jd
         /A+u55gO4pID1FLicSRys3f7cKZWFarcVoJz6/rLYiUwr+EwpiIzVmpSpc82FETxgn6N
         uqu3Z2cg0N8w3F2/JO/+Dz5tVG3RxkgH+EwP9gCLPWSjeLG8qCTfC0qWgv8FQG8R0uIB
         9a6qo1J9w/F/Wk52FXwvJh8TQ8LKL69QHxkl33CMEO6V/fqc69msV6Z54dEa7TGb1wQc
         lLBOdlJU9fyqu8n0q/DTNWI2lKM2P8m+gtK0KqL2sPDDFAYE5igIcw5WLj6BEgtwLf5W
         /eLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ykm1CW81/1yVrovVuyB6hv6LMEyheoG0djpb+ytEzLg=;
        b=SqQkRYTH6pbLZk/LXn9l9n9zQQ0mUZSI7NToOXgfVDITabzwC3eg9Mogow1+uCl6N6
         1mgMeMX6+MATxTqz5F/VFN2NJwx8drZ5lLZ8qboYD8lC6zZp/fR0aVaPgv/QtIFTKjCj
         cH9OQveqceAJi7iWpZUwYsnDri/z0XRPJ6NRYTkIlhYe8idRw5CPUoKwg8XmLbazHaRU
         FE3XQtI2a7hwraSDwwNVVAgCCQKCWE4baEMTCoyn6gc0+U8O0KZqVHtvgDU84gilaMU8
         MApF09Q3U7GLHh0LYxKkL+BYeUuRxYY5i8jEC4YeO7piToRjdBzUaQrZV+vCI0dGfaaj
         a4dQ==
X-Gm-Message-State: AOAM532naJiwDi0DmwdvjLgLhRmnZkPcs/2QKrCeV/2hpJ1eKRC2HEwh
        MCOOPA3CvbpZ2perrBC0e9RbTQ==
X-Google-Smtp-Source: ABdhPJwyiBxLWMbeoV6IkX5eBT3+OCDE8cmPzhVHxVRYy67mswfM9jpwzc/L0i0X7tmXoLgWUd5ULg==
X-Received: by 2002:aca:4e0a:: with SMTP id c10mr4493910oib.14.1607464559477;
        Tue, 08 Dec 2020 13:55:59 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id v8sm16120otp.10.2020.12.08.13.55.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:55:58 -0800 (PST)
Subject: Re: [PATCH 09/19] target/mips: Move mips_cpu_add_definition() from
 helper.c to cpu.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-10-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <0d2371ed-2904-622a-9a49-f96ec731b3b6@linaro.org>
Date:   Tue, 8 Dec 2020 15:55:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-10-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/cpu.c    | 33 +++++++++++++++++++++++++++++++++
>  target/mips/helper.c | 33 ---------------------------------
>  2 files changed, 33 insertions(+), 33 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
