Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A406D6662
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 16:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbjDDO5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 10:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235032AbjDDO4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:56:48 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47045580
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 07:56:24 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id m2so33131239wrh.6
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 07:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680620183;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obKEkwqIA/UnnZ7qcR4bdBjhT/6IB1/3ZLo8wtQ71b0=;
        b=ymxGALMqmeR3q85RJD29P/Fd/W4VOnPznkhxBCZAB0Z81aL79AcUy0nbR4+UxZRc/V
         NMeETudNfyggtu2xDFkpUuSfyTC7udWIXxny2EujN2Njo39E6MXkRxj7vkyWCQiV3s8M
         rH5S4wO8Dw1gVXZzwRvp3C04CfVpkX7/kGuRjtGTQ+0F8UkejvI5dQN8OOxlSK8COd4B
         vJSKGE3lsgASGVuv1rftPTBJvXqie6ug0mAtATb0x+AdQQGyR/NIS1GoJUD8eX6El0C7
         ShJOr7hlFHdM41X9ZDns+qlMEjFO7u48XngczegyOJS5ZQ0stpYGhF6GhfiCbFqdqFJV
         cNIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620183;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=obKEkwqIA/UnnZ7qcR4bdBjhT/6IB1/3ZLo8wtQ71b0=;
        b=laHhjN03DZ7rsh8iSH9DgGxANZct1wsQbiiSRtFXz2zzZbBBnGbxD5BRU5jDuJrkbT
         NZH0KXv5I3zvbrBzP70sbU49pseuFrOkv+wE5uNiyxsUSLsqtybxu8eez4apKPsfURTi
         +oGqDOO97eF2QjKGAwtB9pXhRq3xkirXLuFoLkRckTJDdl2W2GsHfmB4rBjHhMXsstvq
         5tL2D0rlEbn3baBci1Akklgl4RaBsg26KE8sWSKTEoDmHcJ7QA51Sd2Qx8KkcAhPYR1z
         HIdzOnYP5ySgel1zB+7Ux+aJw5hz7W1JmQzwxl9UK94J4qlNz+a5qmgQKDFdwKH1cBxv
         l3AA==
X-Gm-Message-State: AAQBX9dJQrsD/1Mxt0JZljsoF9TPhNfFW/U8y8yg+rWAQQt7TXwz3Lkv
        6GIRdmQjFS4atSwvZz3CcY7jnw==
X-Google-Smtp-Source: AKy350ZtPqbSE0MQbkP1p/Uyy9dFn4+jmrWqAORR28S/M6WWKDeFMqwgtz2A/3AgNe6EHQhLPDOcOg==
X-Received: by 2002:adf:ef10:0:b0:2e4:abb1:3e8d with SMTP id e16-20020adfef10000000b002e4abb13e8dmr2114466wro.54.1680620183073;
        Tue, 04 Apr 2023 07:56:23 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id f16-20020adffcd0000000b002d5a8d8442asm12430275wrs.37.2023.04.04.07.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:56:22 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 4943C1FFB7;
        Tue,  4 Apr 2023 15:56:22 +0100 (BST)
References: <20230403134920.2132362-1-alex.bennee@linaro.org>
 <20230403134920.2132362-6-alex.bennee@linaro.org>
 <ZCwsvaxRzx4bzbXo@redhat.com>
User-agent: mu4e 1.10.0; emacs 29.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Kevin Wolf <kwolf@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Ryo ONODERA <ryoon@netbsd.org>, qemu-block@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>, Warner Losh <imp@bsdimp.com>,
        Beraldo Leal <bleal@redhat.com>,
        Philippe =?utf-8?Q?Mat?= =?utf-8?Q?hieu-Daud=C3=A9?= 
        <philmd@linaro.org>, Kyle Evans <kevans@freebsd.org>,
        kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>, armbru@redhat.com
Subject: Re: [PATCH v2 05/11] qemu-options: finesse the recommendations
 around -blockdev
Date:   Tue, 04 Apr 2023 15:55:34 +0100
In-reply-to: <ZCwsvaxRzx4bzbXo@redhat.com>
Message-ID: <87ttxvlmqx.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Kevin Wolf <kwolf@redhat.com> writes:

> Am 03.04.2023 um 15:49 hat Alex Benn=C3=A9e geschrieben:
>> We are a bit premature in recommending -blockdev/-device as the best
>> way to configure block devices, especially in the common case.
>> Improve the language to hopefully make things clearer.
>>=20
>> Suggested-by: Michael Tokarev <mjt@tls.msk.ru>
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> Message-Id: <20230330101141.30199-5-alex.bennee@linaro.org>
>> ---
>>  qemu-options.hx | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/qemu-options.hx b/qemu-options.hx
>> index 59bdf67a2c..9a69ed838e 100644
>> --- a/qemu-options.hx
>> +++ b/qemu-options.hx
>> @@ -1143,10 +1143,14 @@ have gone through several iterations as the feat=
ure set and complexity
>>  of the block layer have grown. Many online guides to QEMU often
>>  reference older and deprecated options, which can lead to confusion.
>>=20=20
>> -The recommended modern way to describe disks is to use a combination of
>> +The most explicit way to describe disks is to use a combination of
>>  ``-device`` to specify the hardware device and ``-blockdev`` to
>>  describe the backend. The device defines what the guest sees and the
>> -backend describes how QEMU handles the data.
>> +backend describes how QEMU handles the data. The ``-drive`` option
>> +combines the device and backend into a single command line options
>> +which is useful in the majority of cases. Older options like ``-hda``
>> +bake in a lot of assumptions from the days when QEMU was emulating a
>> +legacy PC, they are not recommended for modern configurations.
>
> Let's not make the use of -drive look more advisable than it really is.
> If you're writing a management tool/script and you're still using -drive
> today, you're doing it wrong.
>
> Maybe this is actually the point where we should just clearly define
> that -blockdev is the only supported stable API (like QMP), and that
> -drive etc. are convenient shortcuts for human users with no
> compatibility promise (like HMP).

OK I'll drop this patch from today's PR and await a better description
in due course.

>
> What stopped us from doing so is that there are certain boards that
> don't allow the user to configure the onboard devices, but that look at
> -drive. These wouldn't provide any stable API any more after this
> change. However, if this hasn't been solved in many years, maybe it's
> time to view it as the board's problem, and use this change to motivate
> them to implement ways to configure the devices. Or maybe some don't
> even want to bother with a stable API, who knows.
>
> Kevin


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
