Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924742DB793
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 01:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgLPABG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 19:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgLOXtJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:49:09 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DFCC0613D3
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:48:29 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id v22so22890481edt.9
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QTlCH+KTC9pM4843RwYbGGPtfN8d89vbmF2KKIGX+ws=;
        b=caCwMa2iz/8L9GhAS7SVTMI2+TFOdrSnRRRYKpjsjbdLKm9+2whA6tcWFPcbSGkrjQ
         NKILjO3GKoSpM9NfFXb5wdtoJKV5hFp8R5lQe3t+s3jr5QPB1MccqqYmII4U6s5vHbsN
         9QF0vGuMgZ41zqWP3CCXBMtUHW6eKP4/HEM3Z7ebniQf0CyIqwx+gcAqJ/pWalA3GOtW
         G5LGKK3DYI0CEZd4FWgqGgvbVoNn2v8D3FQd7sULKqlh6sG+x/0Wk95Y9mHmyeJoMClY
         QJMtVDWLXYMLKNTDF1Qk01z/Com9AS4w/En8H+9N3wON4TjUFrIpxQ9XvPZNcKf3/uoj
         Vnjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QTlCH+KTC9pM4843RwYbGGPtfN8d89vbmF2KKIGX+ws=;
        b=cD/MJXEFKnfKD2XSTrIv0v+ltL4trRQOYS2R2SRaJm5wSstEViGy0rsAM/MitpYSwd
         0GceeGruPNzxN64dWYPK9k/jYJPuKkLRF8jzofO1v3fcCdWC8YDi8iAZImkQir1hWfIV
         vNQq1r0r6NOHT8svgQ9I/mRMPysGYiVC5wTFAVlq86pyJZQklF4b7OlvlEBLLngxFp6v
         DS1jZVK8yv6ysMFYYUNzDC+2J5D1xf4+T27d2VwfcfN05aQ8eB0jSSk3kzuU8Os04Ch3
         R8LHzGNNcJIheewJhAGzhIAlawAJYR4HzfSC4jU1hu/1AAl0nO8HUu1+izNrX4Bf0bu6
         amOA==
X-Gm-Message-State: AOAM530f/olyXo1jQ97Sc9CPjumte7UcGaiIvdcYrmhBW1SJpEurAOIW
        wbUU8ojc9IUCCQcAR7sH1ZM=
X-Google-Smtp-Source: ABdhPJyycqajtpR0u0zAS4YPV//nqbyq7wvRYDlBZfxN8AXs/Ttn9RMKbcmDvyro77glBbzhVsDVpw==
X-Received: by 2002:a05:6402:1593:: with SMTP id c19mr15929679edv.269.1608076107939;
        Tue, 15 Dec 2020 15:48:27 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id w10sm43285ejq.121.2020.12.15.15.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 15:48:27 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v2 03/24] target/mips/cpu: Introduce isa_rel6_available()
 helper
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-4-f4bug@amsat.org>
 <508441db-8748-1b55-5f39-e6a778c0bdc0@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <40e8df0f-01ab-6693-785b-257b8d3144bf@amsat.org>
Date:   Wed, 16 Dec 2020 00:48:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <508441db-8748-1b55-5f39-e6a778c0bdc0@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/20 12:27 AM, Richard Henderson wrote:
> On 12/15/20 4:57 PM, Philippe Mathieu-Daudé wrote:
>> +bool isa_rel6_available(const CPUMIPSState *env)
>> +{
>> +    if (TARGET_LONG_BITS == 64) {
>> +        return cpu_supports_isa(env, ISA_MIPS64R6);
>> +    }
>> +    return cpu_supports_isa(env, ISA_MIPS32R6);
>> +}
> 
> So... does qemu-system-mips64 support 32-bit cpus?

Well... TBH I never tested it :S It looks the TCG code
is compiled with 64-bit TL registers, the machine address
space is 64-bit regardless the CPU, and I see various
#ifdef MIPS64 code that look dubious with 32-bit CPU.

> 
> If so, this needs to be written
> 
>   if (TARGET_LONG_BITS == 64 && cpu_supports_isa(...)) {
>     return true;
>   }
> 
> Otherwise, this will return false for a mips32r6 cpu.

I see. Rel6 is new to me, so I'll have to look at the ISA
manuals before returning to this thread with an answer.

Thanks for reviewing the series!

Phil.
