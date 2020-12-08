Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D406B2D364E
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731513AbgLHWb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731508AbgLHWb0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:31:26 -0500
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0CBC06179C
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:30:46 -0800 (PST)
Received: by mail-oo1-xc43.google.com with SMTP id j8so277933oon.3
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FtsA+SIdCVeMyfZ6t+7fEmlWWZGVJv/mo4mraUSfad0=;
        b=ecB2zr2/2QcaXiCklV9z4arwizskcfvWWnbksmfqBWUUnxSupevt2UlQzqz3TZNLZL
         diK2guz+OTJrTZUY4ORYW85xOBpqG7QlrxJFjElDELespFVbq7h4vslP7+ZQqjATs2yx
         xXxnWEa5Ov6rhLLjVy4934eqcuPOsPFWtPWzF0oDAek0q+B5jkALnkXZpBkFbR5Pdn1n
         mAp37hZY21uO4SMigIq6B4c9ExyU6Ti8x4f8fQQBSzo3wD9vnIu+6IbSywLA7j6NDYyz
         7ZUkIGcCVi7hJ94uo1f45blSqDbQj4u2kSCTnLW86Bu+kn4oZj17nprkeb4Whrea8qDb
         tkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FtsA+SIdCVeMyfZ6t+7fEmlWWZGVJv/mo4mraUSfad0=;
        b=jD4HZrAfsx/9JNnrw9j4d1IDNyKSCLW/MWsRl3adZg1VBUtODTDY48RPgaURweGaTp
         u0Es9Sayw69rjUv/gnzsDujKKeqFOODxHcKptcvwRawNxYep1ltPK56VaGFafKyavk1O
         jJlLFHBxgSU7p6iVDl0jeP9MJaiz4gpA693rFQZ0cgTilgl/lHrpFy9b36VXVyfUslAj
         bdU3u3Qvt4CJu1Omx/SXYdjQ7Cn8ZhkhIeUGihs/KHd9Jf3fK8DMtFD7G+lsP50oS7SP
         tjyIWGeSn178+VdHvWk4ClawL/9K7uc08Ve6Hy1oDFcq0v2MIN9M3d05ABh+WRhlQ1kI
         rPgQ==
X-Gm-Message-State: AOAM531afX6+I1BK3A6+QBxuUzlMhK9W4C2d/sLxptPWcJstMCyELtDN
        Pf4KnOIG7LGMXZ4XZKGrbuLq5w==
X-Google-Smtp-Source: ABdhPJxDrmINjfjD2DIXWmsoz03HNiTRGgmZ+l4aex8+eeEpuTTshrCp1x7W4mMnsEYctLJOV4LJNA==
X-Received: by 2002:a05:6820:3d8:: with SMTP id s24mr168535ooj.52.1607466645631;
        Tue, 08 Dec 2020 14:30:45 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id p8sm36164oig.22.2020.12.08.14.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:30:45 -0800 (PST)
Subject: Re: [RFC PATCH 19/19] target/mips: Only build TCG code when
 CONFIG_TCG is set
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-20-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <12015101-5a06-4353-1f85-dd651e050b78@linaro.org>
Date:   Tue, 8 Dec 2020 16:30:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-20-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
> We are very close to build with '--enable-kvm --disable-tcg' :)
> ---
>  target/mips/meson.build | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
