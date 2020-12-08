Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB58B2D358A
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 22:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgLHVrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 16:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgLHVrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 16:47:16 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4D3C0613D6
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 13:46:36 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id 11so181884oty.9
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 13:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oty0wPSO21B92v+ceSRVXFqtyP7fp7aR2WeEKcmjgpE=;
        b=A6rzuDVMJjuhXbPneHmHFW7qT8EWEn9cndw0i57ZR6Ol4Eypncz972umaqmvRE95EA
         mNlAMFwhG74tex3DJVMvLyD3vF+CvL8y0Pbaaex9XRzN+miSsdDKISbn1cfZqcI0FM1G
         Cdn7htEcdZNZ2sSmIAWdvRxOLlVoTNNEQB3miB2Q5M7KM9q+5va/hk9wpYgo9qtTdU4d
         f2ZtkFFKAMbiwuWoNbMCeVvf8ybDgh/9NUnLMhT6HDScn/yfYpLE6ca4vW3uwUKafO0T
         8um2o1GuXrOvluQz3mGMX7BJtX5RcOJ0CM8RuElMv7cAYASfuWPv2DV6/KCGUStv8GD3
         7E/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oty0wPSO21B92v+ceSRVXFqtyP7fp7aR2WeEKcmjgpE=;
        b=ThOd8pzCzn6ReG4xbteM/eK9nd0p6UnDW1OXuC4mGVXf6cOW020XCuZS6lTpEds7QU
         3KkhM8zM6MXS4OpCBKYlWvIhP5W9XgGy8h8ALyw6B4oCM9L4iDunZpEr8xxXhB9+uSS/
         cKIhZnqfUM9NwRMc1dlmPOVpffJUI58D0q9DjAYegknme/LHfbmIQqoy0BQqotffqDP3
         DaZCMmshSrzOdO3c7ChDROOPDTz9zWpTqOH0B9bB1KvFHDZPXTn99JlaDFtVswF/qQiO
         SpPod5SFMxjOUicrb1p/xkyVGPv6XfLwsfbCHyDw4XhgH/XslKWoky5Kit6GvaIlQgK1
         2yQQ==
X-Gm-Message-State: AOAM532a7xMztK998cBqcAZLP7iWQHWg1O7dO5Bkcq4cvnfeEc/jzSne
        KzvdcXO95nBJduB9Fx71a2oM/A==
X-Google-Smtp-Source: ABdhPJx4jeU+EBSjliJjH96Xla46A3J91fakYZhPMpDfl55wM6KiAlcSFlDlF5YhMKC3GzvQJj8PxA==
X-Received: by 2002:a9d:2ab:: with SMTP id 40mr94611otl.280.1607463996134;
        Tue, 08 Dec 2020 13:46:36 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id m81sm4660oib.37.2020.12.08.13.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:46:35 -0800 (PST)
Subject: Re: [PATCH 01/19] hw/mips: Move address translation helpers to
 target/mips/
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-2-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <89d90ad5-d638-bdeb-c004-c84002e16d51@linaro.org>
Date:   Tue, 8 Dec 2020 15:46:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-2-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> Address translation is an architectural thing (not hardware
> related). Move the helpers from hw/ to target/.
> 
> As physical address and KVM are specific to system mode
> emulation, restrict this file to softmmu, so it doesn't
> get compiled for user-mode emulation.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  include/hw/mips/cpudevs.h  | 7 -------
>  target/mips/cpu.h          | 8 ++++++++
>  hw/mips/boston.c           | 1 -
>  {hw => target}/mips/addr.c | 2 +-
>  target/mips/translate.c    | 2 --
>  hw/mips/meson.build        | 2 +-
>  target/mips/meson.build    | 1 +
>  7 files changed, 11 insertions(+), 12 deletions(-)
>  rename {hw => target}/mips/addr.c (98%)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
