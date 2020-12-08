Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C6F2D3644
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgLHW2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730547AbgLHW2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:28:16 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18D4C061793
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:27:36 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id k2so219403oic.13
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PpdHVvN0917X0EkRatA5q7S42TNEsvXRuKK3u2DR4V8=;
        b=fWsXa5jWNH9c0FhcbpUah3BECEsh9RGuSwtM4I1HyHNvbt3DSRed/E8S83S74ezLtO
         onf6R5T8h3t8ND74Z7McSA4hDKiOKswqrMvPF2uO+cReYTnho6d1ZCIleqXDtAea2nbN
         lJyqj1PgoGv999Q0VQ29z7pQNrhFOz71Q8BXF0B6AZpR/R5t1CxzpgtsgBNxGD/XxoVb
         wwFjPZWBVRN2EJWBa+lnKcGmICzkPaXTFlapTzHyl/aJRfLHwVCms0fk7rbyZjdXGbIX
         QE9xJL81fA0rZ/i4HW9+H1NcdtKiSpdabfX0Qn1Q8yDFDbc1+5W1Vch0yrnLqpsnA/1B
         UC6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PpdHVvN0917X0EkRatA5q7S42TNEsvXRuKK3u2DR4V8=;
        b=gOof1+hPdl1vl9C5lSlpbz6+KJsFLNrvQRTz26q1lNgdZBeGknKcrh4itMLRbihaJ/
         1N3Ffm9g460ee8tCn1UzvSB7rpz8oJKmpXTl+2BWtgNtVfXl+iNwBetOMrSusCXbOYf5
         apAWCYLVitsYRPJzCRUcdCQ1RIxSZXjENdbxGd1fb0Sn6qD4SWgrjihkIxcIUEFdl2Lv
         Kx3TzcRFqM6kUrc/u1B5oOt9siwaLkaewQ/6UzyxrdmiHMRa5T67Oz8RPJG6kVXvK7lN
         XJYfXoHixtiA7n9NaDVA47cCYGaKao3EfwL8NhbQzl6Hgouwdid/+r/124oNMvExqaS9
         Yx7A==
X-Gm-Message-State: AOAM531znEbfk6OzXAyUu08htR3kAkwHZQdXifJWj6Iedzb31NRffGg/
        Jp1aHshNhSmQ9osP+IoSUp3ttw==
X-Google-Smtp-Source: ABdhPJz8JSX+vMl1+W7sDBkNvPc52zfUwgDw3SlUzJZMmpacciWOtZ1VuUuhwDG+uz2cpS5szphF6Q==
X-Received: by 2002:aca:c7d4:: with SMTP id x203mr54089oif.21.1607466456126;
        Tue, 08 Dec 2020 14:27:36 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id s139sm37123oih.10.2020.12.08.14.27.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:27:35 -0800 (PST)
Subject: Re: [PATCH 16/19] target/mips: Inline cpu_mips_realize_env() in
 mips_cpu_realizefn()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-17-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <188bc845-e9ea-b7f1-79e0-6749055bfa15@linaro.org>
Date:   Tue, 8 Dec 2020 16:27:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-17-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/cpu.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
