Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7502D35A2
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 22:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgLHVyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 16:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgLHVyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 16:54:11 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A73C0613D6
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 13:53:31 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id x203so473095ooa.9
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 13:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NStUY/qLk9bu6L+y0GrWZhiL3GnQYL84Qz+hTcrhUBU=;
        b=iGYD/ijLzODNWCUcr1z62gKp332+R5ij3BuEbr04mj/Nk8eeZsNG5L5by0MJWkopAZ
         p1M0Sy6rDiQfyVoxIbBFHSx67H1P2PL/voYDNQLiwXuCWJISosUY8We+zAdOeSZldEfJ
         U2174otlSp7Oy5tnTVCb5yDz4H5KMHHyxpo365KUtxX0+IZ5AdDTf3sZ6CnbEhwnT3aV
         S/XyGjgXUknzbP5d4G6bB2Nzd0A1aR/7BPTXc0uqE4czX/bE7KiwheuAIprucxY+VPBq
         t2CF3pJvNMRc1PxSbY2JZrY26stdvPMkUFHIGe1pR685BV115AnY1uR4TxdSf9nh+C6J
         m7jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NStUY/qLk9bu6L+y0GrWZhiL3GnQYL84Qz+hTcrhUBU=;
        b=IXT2Qr8iXYmCwONlRnaeO7n5nh6h42G72Tlf6XgrzO/LZiZnrVuliGEX6BpZs/SvqB
         gOHwbizHOTcLRsAr/aTdFgTreDzGADQIH/r4FxIwoVgpCn9/mZCCMGlm1mR7ciKZncyR
         G/NynLGPS9bSGguTHSoArsah+sF99rqMT1kSu8I4B57VXVHQ4+evWyayS4pVISX5jzCa
         P6Exx4QfWmeVHgXQGPHDOeQILcWTZV9qCRpB7dH7BeSQUBpMx/bwrSHJPsxdv6PxfmqS
         XID+sArHdEXP6Eph0/oOzEq4BYRf1y6q3FEaZHyAwsJ7VAIy3iBHHoQfKhetr8RJVgZq
         N7Lg==
X-Gm-Message-State: AOAM530VUt8sCzyGkZW4uygnI0w/78TId+o3SqBL47rIKI4lac8fo5NJ
        KM6YfbeSpO7b00ZQem+2V9To5w==
X-Google-Smtp-Source: ABdhPJyEKfCiY0bGmx6HepSAva6E5lZxzE8O7K/xAi7N4YY1wjhs/wYc7SiQ2pHrj6mGa+53CRBZsA==
X-Received: by 2002:a4a:d043:: with SMTP id x3mr20993oor.19.1607464411181;
        Tue, 08 Dec 2020 13:53:31 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id b91sm14253otc.13.2020.12.08.13.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:53:30 -0800 (PST)
Subject: Re: [PATCH 08/19] target/mips: Extract cpu_supports*/cpu_set*
 translate.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-9-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <c7adb225-43bb-21be-fd43-3985554301d9@linaro.org>
Date:   Tue, 8 Dec 2020 15:53:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-9-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> Move cpu_supports*() and cpu_set_exception_base() from
> translate.c to cpu.c.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/cpu.c       | 18 ++++++++++++++++++
>  target/mips/translate.c | 18 ------------------
>  2 files changed, 18 insertions(+), 18 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
