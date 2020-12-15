Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9440C2DB3B5
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 19:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbgLOS0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 13:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730242AbgLOS0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 13:26:30 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E906C06179C
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 10:25:50 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id q18so13320076wrn.1
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 10:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P9W5y8DADPRKZkUbGunXJtu96lAIAcP0837WSjtLahI=;
        b=btAYlmnUnUqagsKsYUjGY7ndn+sm7FY87ZReVsvLEtUDcv+F0ueOTzzABDJVXTJktI
         5VrXxid7MoRrdLEqH7fmFa0ASIKvO8DU2NWUUJE0q29WfppiQn5Flxc7jdaQgZQj6KY+
         o+fKzQPIUxMyUZN9LaYNYGEnK22mkUpQwrgzHqorU3nRPRJdogLi/dB3GmHlyKfirAlt
         mnlzqKyHVG5kibt7AUjfZirId+QanfIb7pIsMO0KON0Y5IVQZpsoq2SP0R8pU4vu8DQe
         UOX9oNyu2yKOAydYeYNQrn0vbSQ5vDjBn4e6nR4jMuH4SCKfopdIHUwNxToHl9cgz1Ro
         Husw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P9W5y8DADPRKZkUbGunXJtu96lAIAcP0837WSjtLahI=;
        b=ApOrO4HS6Sh6GwKePgDKI6IN5FswG8wg86g0cnHH8r/1Ldm+3Y8/d6h19zbr1A0JMd
         mT35iHtJFbIUulLp7FhRRl8rS2jj5LV6h18bngRLwDx1XnILSixd5zXPCBg8H2QdAQ4a
         K6+fkxjdl47PaiSfqNnI+FGpa0eXjX2aC9noYPsKGtNcLehx64gqoF2zt7wjHfFoz8FT
         p4XJQnxNsYJ9sLTfqF2BtOslamvueQ6Zk/e6S3DCIFwsOQ5NeyOHqO4U80B5f74krCTd
         JKRD8nBJGM6pBgQdekmLNJPpqRfgGiKSAp+FTctpZGMk3ldGHBF561plqs/zJfNoV00C
         R/qA==
X-Gm-Message-State: AOAM532o/NDuDAsVrlBc9zSHGBS6yhJ8pnU2vfZOQR/CWDfwNdgYlwBp
        h71jgEj7fPW2J1aMENNFJ4k0KpoVqWbWTA==
X-Google-Smtp-Source: ABdhPJx32FVYKg43msran7gZJvxsjebq7zdSf7EVp9KWvcPpiiegrPRgt9OkvzFwpQm657nuVyESlw==
X-Received: by 2002:a5d:5227:: with SMTP id i7mr4135100wra.68.1608056748792;
        Tue, 15 Dec 2020 10:25:48 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id a21sm35825548wmb.38.2020.12.15.10.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 10:25:48 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v2 05/16] target/mips: Extract common helpers from
 helper.c to common_helper.c
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201214183739.500368-1-f4bug@amsat.org>
 <20201214183739.500368-6-f4bug@amsat.org>
 <c9164ee8-ef2a-269d-daf6-6e1efa5fc24e@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <7911deb3-cd31-f45f-453f-d6eae60f734f@amsat.org>
Date:   Tue, 15 Dec 2020 19:25:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <c9164ee8-ef2a-269d-daf6-6e1efa5fc24e@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 3:07 PM, Richard Henderson wrote:
> On 12/14/20 12:37 PM, Philippe Mathieu-Daudé wrote:
>> The rest of helper.c is TLB related. Extract the non TLB
>> specific functions to a new file, so we can rename helper.c
>> as tlb_helper.c in the next commit.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
>>  target/mips/internal.h |   2 +
>>  target/mips/cpu.c      | 215 +++++++++++++++++++++++++++++++++++++++--
>>  target/mips/helper.c   | 201 --------------------------------------
>>  3 files changed, 211 insertions(+), 207 deletions(-)
> 
> Subject and comment need updating for cpu.c.  Otherwise,
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Oops, fixed as:

  target/mips: Move common helpers from helper.c to cpu.c

  The rest of helper.c is TLB related. Extract the non TLB
  specific functions to cpu.c, so we can rename helper.c as
  tlb_helper.c in the next commit.

Thanks!

Phil.
