Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EC32D99D9
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 15:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbgLNOY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 09:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440167AbgLNOXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 09:23:47 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE51CC0613D6
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 06:23:06 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id w5so12865834wrm.11
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 06:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ERyFYHof5EYrvcGCUi6qgiCMzjpIgSAjI9dhBaUg8g8=;
        b=VEwcH78Sn7hRGSE9A0fQinEtrjY4w236Cfg7YX+0VtawWw9fLPxdHRJDilxcPYF4ZN
         LAuk3J3U+924ekIpKDp3j7D6X1PWFERRGTyoqLncFFErJnnsWeAmyooz46GIjhSjJbJI
         FtEVFtRwU2CBz8nTGMLwJ21Kc5R9x5PHtiZW/a8xEnBpFsdqEm0KXyhuGGSsBJ2/MnDM
         4yk1VedlBWbGvjIVenjhjxC6R/iO924vGizGgh95oR/u6nAyvor9VJ4vnS7g+OvCkyfb
         ckIkaiCMP2HRrESmSwNj/EFSFYUnHOdplBuz+4R91Cu1/eHWh/dA+bq2jdvb3KB3PaH5
         795A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ERyFYHof5EYrvcGCUi6qgiCMzjpIgSAjI9dhBaUg8g8=;
        b=BqJ59MmKAOFzYVAbtZl4Ny74pKCd/Upzv4FQGjUywPwRXTVoBQ8FUUpa1iFcRPrlNc
         bCOwguVKxtwsM+gzar4XmPeRAEEZunCm+WC/8m15Qu/kwU8yLAeeUqrmgyYE+Bh8PDeh
         9KIG/HrrBJSUfKSD7KpazS9V6o8Vb0tUhBwXlApNjAubBAMfARhg4WLY1ofdAeVhCKZe
         WAraYf+clXs3eZq44thVSQYthnApxxg9xb6nFJSVaEW2J4VmEwPy8k8Txp7MqCJGubvN
         vXsR/FtZ/jvMej3CWrHnEFXljhL9tU1mgZE8/4d/GVhEd5L+kML9+y90UtvzkbISqpU7
         B2pg==
X-Gm-Message-State: AOAM532uhKkvysexO4XZWIGho7699cwjH8Ws/4BOTGkZJQ5bAAYtgcMh
        fZ9UVprXoZcYNkye1hdqxww=
X-Google-Smtp-Source: ABdhPJzcSCCL9TAEgdTEz74BprnBdj7iErtqUTpz0FfbTAj8CGU5q1fTaq+S/iLTcc0pmP357pYSkw==
X-Received: by 2002:a5d:610d:: with SMTP id v13mr29598918wrt.425.1607955785737;
        Mon, 14 Dec 2020 06:23:05 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id d9sm31203997wrs.26.2020.12.14.06.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 06:23:05 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH 11/19] target/mips: Extract common helpers from helper.c
 to common_helper.c
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-12-f4bug@amsat.org>
 <ac8afc12-2ab4-a2a3-81b5-b9d75314bf6f@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <a6fea84e-8b4e-4181-42c7-5cc016581e7f@amsat.org>
Date:   Mon, 14 Dec 2020 15:23:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <ac8afc12-2ab4-a2a3-81b5-b9d75314bf6f@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/20 11:06 PM, Richard Henderson wrote:
> On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
>> The rest of helper.c is TLB related. Extract the non TLB
>> specific functions to a new file, so we can rename helper.c
>> as tlb_helper.c in the next commit.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
>> Any better name? xxx_helper.c are usually TCG helpers.
> 
> *shrug* perhaps cpu_common.c, no "helper" at all?
> Perhaps just move these bits to cpu.c?

Sounds good, thanks :)
