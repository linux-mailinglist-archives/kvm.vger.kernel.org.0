Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7682CDBF3
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501958AbgLCRJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501954AbgLCRJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 12:09:41 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3205C061A4E
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 09:09:01 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id t9so2936308oic.2
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 09:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lUXhP2BLApSFe26Hqd8EPuBUDi8Kp9hGIASjSzt0ujM=;
        b=WIKcLd/OiCXi1vc0o3Fe2Li3FepJ7ZKtQgR4d0dFtqc67lDREOzGds0LbFGalFU9CA
         8hx0djUwjzb+qoojTmHoTP6GW/UmLJ1hZY/BTk/kzHuqIaOOBjTAh1vN54yAWe9ZTzlb
         6keAafoxWthce6o/2EFaafhEK9usdNpFlUyLJ0iKlmXt4lmg5Sv66w/6e1IORXxGlV+L
         V7i1BD56Gzf3HEOdHvROnuwXOia5jNSawn037PnoPQH1Gqe4h+Ql6zzAqdZXARz7MMv3
         WkbvqeMcd2kaYBTdn0pH7S9RDfT8ZiUxoN7USFWO11vISKsLxTTXypxMOcGGEJlQUzfM
         uCpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lUXhP2BLApSFe26Hqd8EPuBUDi8Kp9hGIASjSzt0ujM=;
        b=O7J7ebe0VKvJNB3RKxi6n03VYij2UFxnY0hFRsdNAvaqM8MyAOtEwjpqj7SYlOvOYk
         pJqfDWaRgvA0RbB2u5sTg4BHTprceBkaJN49JF7mCLQ1whEXbkInkm44XjPqc50Y86KB
         3pGaiRDVoDMOgXmRoOcObpoPVh7EfKvO/jkZqpIot9tnFOT0OL+TeMh9tp58CMQ2cw0W
         w9EjX0TS7+rPDQOasC417YPIh2tz/ybZHJHCbtpvl3vJwo1kmEttDeZ06ca6e+sTvYRM
         HtfhQ76yLlFiQ5TzAj0TtHWm10UxeOAn69dBg9kaogBgp2KVDhcizRPgHmxBIJbVQMB+
         lp8w==
X-Gm-Message-State: AOAM531oDlAjwyLSSmCofW4V+97h4poaPr6w4oV5wZdXtwMa7d3CRSfJ
        QIXu/3pNrxJDPkSdnxiMaR9Xuw==
X-Google-Smtp-Source: ABdhPJzd87IgBEvNamtifDm/ZyjgyBN03fsigayNL610Fj0QqkozKvKAs43FU8o4x4JF8jDVlc6kCA==
X-Received: by 2002:aca:dec2:: with SMTP id v185mr103992oig.6.1607015341193;
        Thu, 03 Dec 2020 09:09:01 -0800 (PST)
Received: from [172.24.51.127] (168.189-204-159.bestelclientes.com.mx. [189.204.159.168])
        by smtp.gmail.com with ESMTPSA id q3sm446639oij.27.2020.12.03.09.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 09:09:00 -0800 (PST)
Subject: Re: [PATCH 1/9] target/mips: Introduce ase_msa_available() helper
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-2-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <b4cbe312-8dc8-d3e4-e5d2-8fe50f52e3fb@linaro.org>
Date:   Thu, 3 Dec 2020 11:08:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201202184415.1434484-2-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
> Instead of accessing CP0_Config3 directly and checking
> the 'MSA Present' bit, introduce an explicit helper,
> making the code easier to read.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/internal.h  |  6 ++++++
>  target/mips/kvm.c       | 12 ++++++------
>  target/mips/translate.c |  8 +++-----
>  3 files changed, 15 insertions(+), 11 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
