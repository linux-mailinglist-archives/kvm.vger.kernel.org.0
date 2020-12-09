Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EA42D3755
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 01:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbgLIACc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 19:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgLIACb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 19:02:31 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC6EC06179C
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 16:01:45 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id y24so532119otk.3
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 16:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UGN7ce97iUS7xAaf8PkOshizvLaxeAOhvlK2XGp9GOE=;
        b=crUfvHi76u6O6k4edlAzkgUWdET/mI7l0yOaSGM7IEWQaOdae+DNUokx7Rd560H2js
         z5AGCX30DgosZ6RXKAU7n+LTgGDT+Pg22DcQ5mrbkSW4gRxQ0Rv3QA6zcYTqV1hCPS6U
         t1c5DsZN/0tlOZCVlVgxNrN05F+R04iaMopshYfYp39rbeT7j0uYxyEXSz2UjZRFpQ2x
         zUMUfH5sSy2xudPGt6k61SbcXZKraQIGIVRr723WSvhpAbucjN/nh4jzzMhdx0beEG7P
         lXljI7L85QAnD3YG03/5a5rM9kWcV8u2rn7kK2xhZcGCNIa3MsLes66gI7rlehZUGopM
         JSqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UGN7ce97iUS7xAaf8PkOshizvLaxeAOhvlK2XGp9GOE=;
        b=WaVUBQRykAAxGxqPZVWL79QggZh1j5Xxy8goFWD7XcAerqWfq2YMwDRE0d/HFgDtcz
         uW5cP9Gu6eq8U8RKE/AhvLeBlz/cX7WZqjLGd1PDcP4L8W3ZmfkI1hAL9m2t72ozOzlp
         rtVHMQcwDgkYr338c8RUxU6rO1goTsC6VYP3imDZerSo1xQKExZNaOckn9h70/wgxqH2
         8prJzhGf8wdBD4eWbo9ZNXCr9JDJ7qX7hqoSUxbX44Uf6tnnetMAsQZtvEk/6K6aRgVo
         YPyQHtPpW3n2EYZIxZ25kI5hkJBXSVcqWKlzb2nKlF435TQsg9NhLyZ/dJkhkoRdn/Yb
         wbKA==
X-Gm-Message-State: AOAM530Ko59iUjCYVBU0rs0fvmhsMFqf/jW+cJZICJ/yx+XtJPLZtwlP
        mLQUHCidhMLYphf37jNlFI7Ppw==
X-Google-Smtp-Source: ABdhPJx1tD5000NPvzfRDTSmKInCaJQiH6pyx/1il3ephVK6HxuyYDpis062nEqE1/M8Dg73zqVl/g==
X-Received: by 2002:a9d:590c:: with SMTP id t12mr498539oth.308.1607472105139;
        Tue, 08 Dec 2020 16:01:45 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id p4sm92014oib.24.2020.12.08.16.01.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 16:01:44 -0800 (PST)
Subject: Re: [PATCH 14/17] target/mips: Declare gen_msa/_branch() in
 'translate.h'
From:   Richard Henderson <richard.henderson@linaro.org>
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20201208003702.4088927-1-f4bug@amsat.org>
 <20201208003702.4088927-15-f4bug@amsat.org>
 <45ab33e0-f00e-097a-74fb-4c7c42e29e33@linaro.org>
Message-ID: <b0cf35c4-a086-b704-5710-0f05bf7921bb@linaro.org>
Date:   Tue, 8 Dec 2020 18:01:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <45ab33e0-f00e-097a-74fb-4c7c42e29e33@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/20 5:56 PM, Richard Henderson wrote:
> On 12/7/20 6:36 PM, Philippe Mathieu-Daudé wrote:
>> Make gen_msa() and gen_msa_branch() public declarations
>> so we can keep calling them once extracted from the big
>> translate.c in the next commit.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
>>  target/mips/translate.h | 2 ++
>>  target/mips/translate.c | 4 ++--
>>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Actually, I think this should be dropped, and two other patches rearranged.


r~


