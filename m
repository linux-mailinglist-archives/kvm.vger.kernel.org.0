Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B07C2D9A35
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 15:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438530AbgLNOmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 09:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732535AbgLNOmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 09:42:21 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3C1C0613CF
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 06:41:40 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id d26so3443341wrb.12
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 06:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZKgX/xWUpRlRKIYRtZXL3th3GM7iPy5bWOYaHuo6GfM=;
        b=VBoFP8QpE/zX+oxca7N9aGaOsezDnA2Hor/ID12WGZPhgpPi+0RlAMnwWXnVPK+8OJ
         I36kZhJ5qxXfa0TTViJdZvou+DHv4nnN5O1/Mr7c/iSUUwsxyy+NK0KFUPXZK2ssTLFz
         oQpjvjqyfGTFyJ6A7XUIZ3cgZQy+/iabcBf43oVwzsIUX/DaQi/yXLBdpx0kPeuQLW1S
         kDFpCVSDTFmSPhjE3FbrjZipGtQaflXOPTjn+p4meqfC2dYn+XMuit1Lgs0EVN0v2PQo
         OlUkV3NUjm3m/LrSBNwfa9PflisFFEzF1Emf6xweHy6bB4GuYtLUvStzHpqdKZDY+2CY
         A1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZKgX/xWUpRlRKIYRtZXL3th3GM7iPy5bWOYaHuo6GfM=;
        b=kL8TwpH+809L1gJduDN4QgfqP4i7ZVNW3atAf/CNhMXyxBllfWYFQC2khJSevytG66
         NF+LantEVou0j4iF9Bqr9uBqDMV6026PNDfT5GKMbfduiFAw/1D77uGE/bipI95JD3tI
         k/SPV0yMz1p5qRoH1in4WHnvxWyZXRoSdosqU+E1zGQiiMaigSxbOQLx6wyz2A/49G8e
         UbzoiB/CxNqmYM4xp8twmCHusQSQCpyAY6lPa/Uxls6AeOR28wrMyL0KHC85jykPFQWJ
         SKrFQFonp4XrLy8HxN6QibgiVhB0ZuOLdCNIQFGqEIn+Whx4o2OzklKZ04ltF/xOxYbn
         2IdQ==
X-Gm-Message-State: AOAM530LyfEEcY//3J2VnTYPm8+i+CrwuuM9jAgnFgXe+2RNaSNaAXnY
        BlIgsCLNRjlDYJJxUe/jWUI=
X-Google-Smtp-Source: ABdhPJzGbM1jR6fJjH6XoAs7sPvQmsUA0LRcWN4gUClg8diBNpJ2HJBQngAToMkZseyRCDVj9rrQGA==
X-Received: by 2002:adf:e9d2:: with SMTP id l18mr17870387wrn.179.1607956899494;
        Mon, 14 Dec 2020 06:41:39 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id h20sm34321446wrb.21.2020.12.14.06.41.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 06:41:38 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH 6/7] target/mips: Declare generic FPU functions in
 'fpu_translate.h'
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201207235539.4070364-1-f4bug@amsat.org>
 <20201207235539.4070364-7-f4bug@amsat.org>
 <23c1eb1b-31de-abdd-26ec-be0142d73eaf@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <31534064-6da7-b581-2f4a-e872352e84d1@amsat.org>
Date:   Mon, 14 Dec 2020 15:41:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <23c1eb1b-31de-abdd-26ec-be0142d73eaf@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/20 11:54 PM, Richard Henderson wrote:
> On 12/7/20 5:55 PM, Philippe Mathieu-Daudé wrote:
>> Some FPU translation functions / registers can be used by
>> ISA / ASE / extensions out of the big translate.c file.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
>>  target/mips/fpu_translate.h | 25 +++++++++++++++++++++++++
>>  target/mips/translate.c     | 14 ++++++++------
>>  2 files changed, 33 insertions(+), 6 deletions(-)
>>  create mode 100644 target/mips/fpu_translate.h
> 
> Is there a good reason for not putting these in translate.h?

None :)
