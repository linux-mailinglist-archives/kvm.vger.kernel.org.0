Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988592CFC8B
	for <lists+kvm@lfdr.de>; Sat,  5 Dec 2020 19:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgLESXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Dec 2020 13:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728436AbgLESXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Dec 2020 13:23:44 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E880CC09424C
        for <kvm@vger.kernel.org>; Sat,  5 Dec 2020 04:44:10 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id b62so8007517otc.5
        for <kvm@vger.kernel.org>; Sat, 05 Dec 2020 04:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7pqtYgdwXmYfAHYPXWQqFh15eA/495et8ob7D3TO0UU=;
        b=gx9da9HbvMFtqFhUy6bKOcSiI87OSeNPqa+cqypPQCcT8qTZdsJPRkxpzUoI+hIr+S
         kytNGJVLb+T7GWd4HOaXCuSVSiFpNb6+sVNIBQzFspY+qnZ09YXIbSDYhSWLZmeta5Tx
         xCjc/6ax5SzH3TVmfMjuWgv7aF0Q6IED/XK98QaIzmyFIW4aljxoB1vyZPX7NW10CBfy
         FmG3qt1yTXlhZobBXNRL3QKaL06nksN6TrzGJxqrwkHphP6AdiHtyFCt2/LM72KS45wk
         sxjhPVN63c3Lj6ZjUJbOgriLojNNKrs9odKzmBHt/8KCGL3VqXg8MQruC4kOLEdkh8ob
         11lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7pqtYgdwXmYfAHYPXWQqFh15eA/495et8ob7D3TO0UU=;
        b=rcKXNZx+oxbV1X+SSCPocCTF9s4mYpEEerBaYiJX4aqPob1qItyigAqNtdbSuLKRqZ
         ADQc1VDYsg0M27dcw1VgDxp3R94D3MYNr4Q87Kh6vJJa2WSrjVtI5AOmRuwGCXPoDgUS
         /j+9WTPqzK7Z5LpRrVs0E65pZTFV0i80cBg3eE0twbkbCOH3qBQZKVJWfMcRwiPJ+PKN
         f80f9p4x6NpydAUowIe13K7ZXdJ4Du4WEcnTWc+uzTJqe2JbPpcjqcLHByaBmgf9cgSY
         Y8kxk3aO++6Ptd02rOM5wJNYvb/jOMzCFUVH5UKq4rhGXWJUdD1Dkyd19UWyQZktL4bE
         //VA==
X-Gm-Message-State: AOAM533//mSqMqwHe6aqdjtltH0545EzBMYa0FkDhjbTOLX3UvP8btpF
        9y/BkDRn8wqUv274wqej0vDqqF35btOs+con
X-Google-Smtp-Source: ABdhPJynM06YJZeVUYZ6qFfHrP0O/aYP5k5Q6uvu6UKtv4bIy+hOxezr/UifeM1Sq0xD4+bpryLflg==
X-Received: by 2002:a9d:1290:: with SMTP id g16mr6970247otg.69.1607172250239;
        Sat, 05 Dec 2020 04:44:10 -0800 (PST)
Received: from [172.24.51.127] (168.189-204-159.bestelclientes.com.mx. [189.204.159.168])
        by smtp.gmail.com with ESMTPSA id g188sm1383708oia.19.2020.12.05.04.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Dec 2020 04:44:09 -0800 (PST)
Subject: Re: [PATCH 6/9] target/mips: Alias MSA vector registers on FPU scalar
 registers
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-7-f4bug@amsat.org>
 <ac68e51c-650a-55df-c050-c22a1df355b5@linaro.org>
 <f528a49d-2476-8e8f-e6e8-afc115864b1b@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <666cfaee-9663-0550-6cff-2def63f0664a@linaro.org>
Date:   Sat, 5 Dec 2020 06:44:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f528a49d-2476-8e8f-e6e8-afc115864b1b@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 4:40 PM, Philippe Mathieu-Daudé wrote:
> Back to the patch, instead of aliasing FPU registers to the MSA ones
> (even when MSA is absent), we now alias the MSA ones to the FPU ones
> (only when MSA is present). This is what I call the "inverted logic".
> 
> BTW the point of this change is simply to be able to extract the MSA
> code out of the huge translate.c.

Yes, I see that at the end of the series.  Have a

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
