Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6D42CF1EB
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 17:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgLDQ3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 11:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgLDQ3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 11:29:39 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83D5C0613D1
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 08:28:59 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id z24so5723313oto.6
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 08:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s/K/Z1mU174+bqILLTQa5GQtSbllWYCoyDJq8pLRWUs=;
        b=mmXBGzKPxVKZBz6+V+ztZUYe22UlZo+cKJWbcol8wKgU+vrICSzzfxb1D8ithAMckd
         n7W2JK2GzntOhFEoEmA+q4rCrpsNoNiIVXt1Oow42dZ/B6zrXb5dKo1wyGBPJ4qV9iNC
         PjLLXIAxlkc0J9BACu18lI83xRz7L858iYgxeisD3RtCbp/guCwC1D71oyjoJw22mrhx
         /T/BaY9yl0NcO8hYR9h3aZErk3vsoAYszrVXMpPdFTSBey9fnQiG3E3q7uTwfs8dq6PU
         xYmMjeiwTQP8YaCj9n4BNCkr1TKUYW/VUYQ7wdwLDSe/uy0f9eqytjXodS9u2vOQ5aIU
         7hTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s/K/Z1mU174+bqILLTQa5GQtSbllWYCoyDJq8pLRWUs=;
        b=YCn+tq/lAyD8Rzt7zEOhThFPn8+46OfyvaH4OnokLdhTc1xVv9Jrz7+R72cz8myW5y
         9eWRuj9h9skrosKfWbXNaPKQ/HLC3Ilx8r0xa131pRArf7OA83c3nC2sMnMl/1Vo2M4T
         S+5qWLgPeXiETnwf4SLVHimAJUZsnrRiQv2XB0UNtSsPcSIeykOKupI1FYyC2quIKq6K
         lyEJJ5vSv+ecoIDj078ci5QvAK7kYW+o+dNXyBIEtidMIqM8s7+jhbv7dfZ5KrFy/W94
         im7tydxEfvR9giXCuiy/my3uh2jVEe0oWbMMhpIg5NAexGfuVcR6fYI04G+65LUO0BsK
         GeRw==
X-Gm-Message-State: AOAM530WU4yvX+YQ44Kq4I2II5IkRWacvtbZ8yrdWTCiv54PExlZKzmz
        lEf2I6igSrmPCMd6u0M6WJeHWYz04mhun7ve
X-Google-Smtp-Source: ABdhPJy8jHi956LTYxapRjhjvfcFUICeFKrtbEDUKfTdYkuX+/gTpCCIEdWfxJNxdp8n+XwoeXvYIw==
X-Received: by 2002:a9d:7d92:: with SMTP id j18mr4203985otn.17.1607099339170;
        Fri, 04 Dec 2020 08:28:59 -0800 (PST)
Received: from [172.24.51.127] (168.189-204-159.bestelclientes.com.mx. [189.204.159.168])
        by smtp.gmail.com with ESMTPSA id k20sm734786oig.35.2020.12.04.08.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 08:28:58 -0800 (PST)
Subject: Re: [PATCH 6/9] target/mips: Alias MSA vector registers on FPU scalar
 registers
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-7-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <ac68e51c-650a-55df-c050-c22a1df355b5@linaro.org>
Date:   Fri, 4 Dec 2020 10:28:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201202184415.1434484-7-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
> Commits 863f264d10f ("add msa_reset(), global msa register") and
> cb269f273fd ("fix multiple TCG registers covering same data")
> removed the FPU scalar registers and replaced them by aliases to
> the MSA vector registers.
> While this might be the case for CPU implementing MSA, this makes
> QEMU code incoherent for CPU not implementing it. It is simpler
> to inverse the logic and alias the MSA vector registers on the
> FPU scalar ones.

How does it make things incoherent?  I'm missing how the logic has actually
changed, as opposed to an order of assignments.


r~
