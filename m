Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24E41D7E58
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 18:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgERQZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 12:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgERQZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 12:25:23 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2205C061A0C
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 09:25:21 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h4so117639wmb.4
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 09:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g+OkLPH00natUE/QeEo1Oz57yS1HlKJlItfC1StyQqo=;
        b=qifUWqtLdWbTxI1zNUx+2H5Inz2Qn/OiRWatuoEM8sp168ruVfdMJMwassXPSoiUiy
         soVGgFZARyBMDihGcb8XVoRmJLtY8TynCyIcdGKoMy0GuXqxm9NFV4Bpl7fU32LBYN10
         WVagPmba0TP2u52pfB1zXyDjCrc8bjOFk28m+BSO+akX6vHDEbj3DqIGqAYt+Qg8BeOR
         77t5gcxyUisQXKMWKnnhFOS8o5GrWrvfbUan6HfUnvRzZ62Ya5tG+wx8/cIxLerTdja+
         2iIvYvagWe2ezq4blq1p/Gzk1c/c6xBvDGHN7jcEvs+viUAcJUIG4+4KBhn1AFpFG2BC
         gnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g+OkLPH00natUE/QeEo1Oz57yS1HlKJlItfC1StyQqo=;
        b=MvBCW2k5aoPh9BNEV2zuhXjx8/X3g4X2TW0Ipo+Mm3KXUV55gVqXTfc+2gZbEIkXRN
         Si7Ucnipr2FTbUhosKKbf8T/a8Rj9/7ADzVK8/3n5RsvUQZXv6U04iShWmelglHgB9Fz
         d1AHP0Tx6Flx+trpCFxAyZgcppv20T0PxMh/KTYjEJj4eoNwS/+JkdoJnhdO4DVOXI34
         AFhraM4hvLiybu5b2CCwhe/84NFMofs6xsGRuGtgfPkCmQ5Mht0MXQIpWoK0N3hIVQ4q
         37vmc3brBasPwWAJDQuFfO6gColHXE7QOm1pwHpJaPtvS9+88gEYDHITd8HQJSxDBavj
         IjCQ==
X-Gm-Message-State: AOAM532x6fTBFbiunexwir4C9pep2iS+gMlmBUiJemNoyrwQA+4ZNMym
        qrF9fWlici2YiPoX+HaQnUTwsf5b5k0=
X-Google-Smtp-Source: ABdhPJwgP6cEp+GRltPGLnvb5dZednwNrKy/G61xUoGcKIDYpxV/+qZajUU3wOBHNQQIR+cOefblOA==
X-Received: by 2002:a7b:c939:: with SMTP id h25mr171618wml.9.1589819120346;
        Mon, 18 May 2020 09:25:20 -0700 (PDT)
Received: from [192.168.1.38] (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id 37sm17501667wrk.61.2020.05.18.09.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 09:25:19 -0700 (PDT)
Subject: Re: [RFC PATCH v2 7/7] hw/core/loader: Assert loading ROM regions
 succeeds at reset
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
References: <20200518155308.15851-1-f4bug@amsat.org>
 <20200518155308.15851-8-f4bug@amsat.org>
 <CAFEAcA97bYXyN-GSXUk_OetroaHFExXFwYH1bhexHwRW0+NEVw@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <02f900f6-26e8-f809-5d96-2092db260cf3@amsat.org>
Date:   Mon, 18 May 2020 18:25:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA97bYXyN-GSXUk_OetroaHFExXFwYH1bhexHwRW0+NEVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/20 6:12 PM, Peter Maydell wrote:
> On Mon, 18 May 2020 at 16:53, Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>>
>> If we are unable to load a blob in a ROM region, we should not
>> ignore it and let the machine boot.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
>> RFC: Maybe more polite with user to use hw_error()?
>> ---
>>   hw/core/loader.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/hw/core/loader.c b/hw/core/loader.c
>> index 8bbb1797a4..4e046388b4 100644
>> --- a/hw/core/loader.c
>> +++ b/hw/core/loader.c
>> @@ -1146,8 +1146,12 @@ static void rom_reset(void *unused)
>>               void *host = memory_region_get_ram_ptr(rom->mr);
>>               memcpy(host, rom->data, rom->datasize);
>>           } else {
>> -            address_space_write_rom(rom->as, rom->addr, MEMTXATTRS_UNSPECIFIED,
>> -                                    rom->data, rom->datasize);
>> +            MemTxResult res;
>> +
>> +            res = address_space_write_rom(rom->as, rom->addr,
>> +                                          MEMTXATTRS_UNSPECIFIED,
>> +                                          rom->data, rom->datasize);
>> +            assert(res == MEMTX_OK);
> 
> We shouln't assert(), because this is easy for a user to trigger
> by loading an ELF file that's been linked to the wrong address.
> Something helpful that ideally includes the name of the ELF file
> and perhaps the address might be nice.
> 
> (But overall I'm a bit wary of this and other patches in the series
> just because they add checks that were previously not there, and
> I'm not sure whether users might be accidentally relying on
> the continues-anyway behaviour.)

I understand. Thanks for reviewing, I'll rework this one and the 
previous set_kernel_args().

> 
> thanks
> -- PMM
> 
