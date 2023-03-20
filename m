Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C8B6C149B
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 15:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjCTOXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 10:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjCTOXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 10:23:44 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BBA1C330
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:23:42 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id i10-20020a05600c354a00b003ee0da1132eso1036773wmq.4
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679322221;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wDFPVnK26gTPvQ7OQnmaMHAo8uxTCxn0wjupc66n0+g=;
        b=iupUAOLOVvIo5M2FeGbu2pABScMqZ1WtjEgwgzAmbLp8n1wBphdMsJVh/nBr2ctxaq
         niYu4FF+KJTk+QSzJev4lNK//Wy/Yhv2xD0lLuBLZslRJqBIMiTdxNYJxSEs1KxrsHJR
         HXKgVtUZ7tM96cRGbKte3pAoXlUVUeGIklTPLppMnqAsDyzgnvesrxlGGjLmAxHwP2Z8
         oOTJXlxwRgHOZRq+NQU2XjlOeW0QinUZw0n+V/hg5OrnJccCE8/JVuMQzPi0BC01UBxH
         +gRQI2RsNKHxJHJ8loygXyNNQB1Q6krKKZ6IgKVxC7ORtE9QtzBgoDcVrwecwQ2JsPM+
         E8LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679322221;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wDFPVnK26gTPvQ7OQnmaMHAo8uxTCxn0wjupc66n0+g=;
        b=tje68CDGxUsI55v8WqR5ed3fFgQBNwXYpn9f5H96iBNFui/emI4yvC5hNxgYdtxTkp
         uNJFHQH6lxG6Q3qkgDvE4xzShAd81HmknxU5jDd30f0JHJfk7EtqLO2nqOoVZjPdZldG
         EqroMUxGBbMa4/Bk1Cm4HIZ1eKoD8NGCw/NPisn8IetcZKjp8Izi30V4E7YoAiwgPiP3
         UGIZLiPVL29MM376VFg5dxVyilkwh4JqOzCcE8/I463eweE35xeZq01kxkPX/WRJo8zj
         Jt4G+ZD0RUvgTJA7+wbnzi5g8cpcrjRBARyCg7TxioOGwtHjE8UJkyizCbC5jDdLJuwc
         D13Q==
X-Gm-Message-State: AO0yUKWlVcWBmOtoUQ+kyIF80+zKdizZ9Pg7S6nvdDFCNz7KF851SaZs
        7jVHZWQ+q65Ffs7uhVQBuvTIzg==
X-Google-Smtp-Source: AK7set/aRqtnWw0m8lIYSvCcTJKy8bYXEjcr1/Crqm07tlo2b+OzQuFfio36H5QqfOmps9fL+g8D5g==
X-Received: by 2002:a05:600c:3b24:b0:3ed:296b:4899 with SMTP id m36-20020a05600c3b2400b003ed296b4899mr26844308wms.15.1679322220744;
        Mon, 20 Mar 2023 07:23:40 -0700 (PDT)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id p9-20020a1c5449000000b003dc1d668866sm16596895wmi.10.2023.03.20.07.23.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 07:23:40 -0700 (PDT)
Message-ID: <cdf53d5e-d74d-9316-f1bc-3efc36e1c3bc@linaro.org>
Date:   Mon, 20 Mar 2023 15:23:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH-for-8.1 4/5] bulk: Do not declare function prototypes
 using extern keyword
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, qemu-block@nongnu.org,
        Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        Tyrone Ting <kfting@nuvoton.com>, Hao Wu <wuhaotsh@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefan Weil <sw@weilnetz.de>, Riku Voipio <riku.voipio@iki.fi>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
References: <20230320134219.22489-1-philmd@linaro.org>
 <20230320134219.22489-5-philmd@linaro.org> <ZBhkIjelEtR7lckj@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <ZBhkIjelEtR7lckj@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/3/23 14:48, Daniel P. Berrangé wrote:
> On Mon, Mar 20, 2023 at 02:42:18PM +0100, Philippe Mathieu-Daudé wrote:
>> By default, C function prototypes declared in headers are visible,
>> so there is no need to declare them as 'extern' functions.
>> Remove this redundancy in a single bulk commit; do not modify:
>>
>>    - meson.build (used to check function availability at runtime)
>>    - pc-bios
>>    - libdecnumber
>>    - *.c
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   block/dmg.h                    |  8 +++----
>>   bsd-user/bsd-file.h            |  6 ++---
>>   crypto/hmacpriv.h              | 13 +++++------
>>   hw/xen/xen_pt.h                |  8 +++----
>>   include/crypto/secret_common.h | 14 +++++-------
>>   include/exec/page-vary.h       |  4 ++--
>>   include/hw/misc/aspeed_scu.h   |  2 +-
>>   include/hw/nvram/npcm7xx_otp.h |  4 ++--
>>   include/hw/qdev-core.h         |  4 ++--
>>   include/qemu/crc-ccitt.h       |  4 ++--
>>   include/qemu/osdep.h           |  2 +-
>>   include/qemu/rcu.h             | 14 ++++++------
>>   include/qemu/sys_membarrier.h  |  4 ++--
>>   include/qemu/uri.h             |  6 ++---
>>   include/sysemu/accel-blocker.h | 14 ++++++------
>>   include/sysemu/os-win32.h      |  4 ++--
>>   include/user/safe-syscall.h    |  4 ++--
>>   target/i386/sev.h              |  6 ++---
>>   target/mips/cpu.h              |  4 ++--
>>   tcg/tcg-internal.h             |  4 ++--
>>   tests/tcg/minilib/minilib.h    |  2 +-
>>   include/exec/memory_ldst.h.inc | 42 +++++++++++++++++-----------------
>>   roms/seabios                   |  2 +-
> 
> Accidental submodule commit.,
> 
>>   23 files changed, 84 insertions(+), 91 deletions(-)
>>
>> diff --git a/block/dmg.h b/block/dmg.h
>> index e488601b62..ed209b5dec 100644
>> --- a/block/dmg.h
>> +++ b/block/dmg.h
>> @@ -51,10 +51,10 @@ typedef struct BDRVDMGState {
>>       z_stream zstream;
>>   } BDRVDMGState;
>>   
>> -extern int (*dmg_uncompress_bz2)(char *next_in, unsigned int avail_in,
>> -                                 char *next_out, unsigned int avail_out);
>> +int (*dmg_uncompress_bz2)(char *next_in, unsigned int avail_in,
>> +                          char *next_out, unsigned int avail_out);
>>   
>> -extern int (*dmg_uncompress_lzfse)(char *next_in, unsigned int avail_in,
>> -                                   char *next_out, unsigned int avail_out);
>> +int (*dmg_uncompress_lzfse)(char *next_in, unsigned int avail_in,
>> +                            char *next_out, unsigned int avail_out);
> 
> These are variable declarations, so with this change you'll get multiple
> copies of the variable if this header is included from multiple source
> files. IOW, the 'extern' usage is correct.

Doh indeed, good catch, thanks.

>> diff --git a/roms/seabios b/roms/seabios
>> index ea1b7a0733..3208b098f5 160000
>> --- a/roms/seabios
>> +++ b/roms/seabios
>> @@ -1 +1 @@
>> -Subproject commit ea1b7a0733906b8425d948ae94fba63c32b1d425
>> +Subproject commit 3208b098f51a9ef96d0dfa71d5ec3a3eaec88f0a
> 
> Nope !

Oops...

