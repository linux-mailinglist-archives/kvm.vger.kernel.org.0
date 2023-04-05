Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6A06D8232
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbjDEPly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238948AbjDEPlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:41:49 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED6C59E2
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:41:37 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id eg48so142035785edb.13
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 08:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680709278;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0zzr6cTFmvu41xGvkX3ynHFnsazzApiaL5O6eEkx7fA=;
        b=sMFIjIjnnwNF0sTCPKuEyz8bLRM3djqT/oFnM99BElii62mqZw4Wjsj7MlzQ0OOoo2
         g7OiOD5u9R9RaqLA69nV5QL47P/6obgw4myqEpGkxfX2zYOrtv6NukeZsICyHwvQ2CuS
         teXFMUnw7V26AV28A/drXjy0UZVo4c0/TBgbsamfJr+f+PlwYDV8F75AFnukA2RIdEQj
         l1jhlFkcxNSDtB6iq6WAUk0CYIDaXIMy571nqoSdtHES6VGvtmYOdcVmv+NyRlDGKfCE
         gfc5tIBo6hM0QA+EWShBWzbJncbvyNxvQ0Odhp/YGD7IXKmEJHc5XECaAiJWz7w4ZjZ/
         iFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680709278;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0zzr6cTFmvu41xGvkX3ynHFnsazzApiaL5O6eEkx7fA=;
        b=IFf88VvQJFz9m8EX9C2zKnasa3y6ScYqu7j/f+OltRsYJ0iA4jtsqsE0f8J2msc+9r
         frcA/hWfOAPsUfWEYa0xA4qrP3R0pcgx4+lMI5F1g9JX0Rm4xU0NeCbRrNHuoPxPb4Hx
         RyKfGbpJzc26uFfvVhcwaP6OYSSr9yDqHwJY9CNmGvYsPHW6L5lhA3H7kpGOkS2S4nld
         q+cTsyHwHruOJH9DSJ1HyJBDQwp/ltcASrmDUg1+vJmtSNnxLKLiO5/sIG65lBj/Wf0Y
         kV22Vqqd+WJVQV830/pEnZ2h4jmZr6kk93hbtxl7zxzt6TQBhiYnHG/zUyquU5LBS8xC
         zCAg==
X-Gm-Message-State: AAQBX9cCLiz3u4/tROhZUVOA5mpOaaqgBHnidvf3pj9VrH6g8ScfnYor
        P4pwa5v058/l4GBTNBOtsKkQRTZM8kvKXI3brr4=
X-Google-Smtp-Source: AKy350amAhbPH0pTQTEoisMpn3bLBeJsG//QsgrjsfLtkEy4Th2iRzkvi30CqssDiNNFRiXbsJ5L+g==
X-Received: by 2002:a17:907:6e17:b0:922:ae30:3c23 with SMTP id sd23-20020a1709076e1700b00922ae303c23mr3526275ejc.18.1680709277722;
        Wed, 05 Apr 2023 08:41:17 -0700 (PDT)
Received: from ?IPV6:2003:f6:af39:8900:5941:dee7:da1a:b514? (p200300f6af3989005941dee7da1ab514.dip0.t-ipconnect.de. [2003:f6:af39:8900:5941:dee7:da1a:b514])
        by smtp.gmail.com with ESMTPSA id q6-20020a056402518600b005028c376d50sm6179202edd.71.2023.04.05.08.41.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 08:41:17 -0700 (PDT)
Message-ID: <f8d26a55-2371-241e-6165-24b6a04c2243@grsecurity.net>
Date:   Wed, 5 Apr 2023 17:41:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v4 6/9] x86/access: Try forced emulation
 for CR0.WP test as well
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20230404165341.163500-1-seanjc@google.com>
 <20230404165341.163500-7-seanjc@google.com>
 <6fcaf791-da24-fae7-af03-3e19a781fd26@grsecurity.net>
 <ZC2FwphMDTz3ESLQ@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZC2FwphMDTz3ESLQ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.04.23 16:29, Sean Christopherson wrote:
> On Wed, Apr 05, 2023, Mathias Krause wrote:
>> On 04.04.23 18:53, Sean Christopherson wrote:
>>> @@ -1127,6 +1128,10 @@ static int check_toggle_cr0_wp(ac_pt_env_t *pt_env)
>>>  
>>>  	err += do_cr0_wp_access(&at, 0);
>>>  	err += do_cr0_wp_access(&at, AC_CPU_CR0_WP_MASK);
>>
>>> +	if (!(invalid_mask & AC_FEP_MASK)) {
>>
>> Can we *please* change this back to 'if (is_fep_available()) {'...? I
>> really would like to get these tests exercised by default if possible.
> 
> "by default" is a bit misleading IMO.  The vast majority of developers almost
> certainly do not do testing with FEP enabled.

Fair enough. But with "by default if possible" I meant, if kvm.ko was
already loaded with force_emulation_prefix=1, the CR0.WP access tests
should automatically make use of it -- much like it's done in other
tests, like x86/emulator.c, x86/emulator64.c and x86/pmu.c. Or do you
want to change these tests to get a new "force_emulation" parameter as
well and disable the automatic detection and usage of FEP support in
tests completely? That would be quite counter-intuitive to reach a good
test coverage goal.

> 
>> Runtime slowdown is no argument here, as that's only a whopping two
>> emulated accesses.
>>
>> What was the reason to exclude them? Less test coverage can't be it,
>> right? ;)
> 
> The goal is to reach a balance between the cost of maintenance, principle of least
> surprise, and test coverage.  Ease of debugging also factors in (if the FEP version
> fails but the non-FEP versions does not), but that's largely a bonus.

It's a bonus on the test coverage side, IMHO. If the FEP version fails
but the non-FEP one doesn't, apparently something is broken somewhere
and should be fixed.

> 
> Defining a @force_emulation but then ignoring it for a one-off test violates the
> principle of least suprise.

Do we need additional parameters for PKU / SMEP / SMAP / LA57 as well or
leave the automatic detection in place? </rhetorical question>

We only need the "force_emulation" parameter because the ac_test_bump()
loop is so much slower with forced emulation. That's the only reason for
it to exists. We can rename it to "full" and do the force emulation
tests for ac_test_exec() if FEP is available. But just excluding some
(cheap) tests because some command line argument wasn't provided would
be surprising to me. Tests should be simple to use, IMO.

> 
> Plumbing a second param/flag into check_toggle_cr0_wp() would, IMO, unnecessarily
> increase the maintenance cost.  Ditto for creating a more complex param.

Fully agree, no need for additional parameters. The existing one should
simply be renamed to "full" and just control ac_test_exec()'s behavior.

> 
> As for test coverage side, I doubt that honoring @force_emulation reduces test
> coverage in practice.  As above, most developers likely do not test with FEP.

Well, I do ;)

>  I
> doubt most CI setups that run KUT enable FEP either.  And if CI/developers do
> automatically enable FEP, I would be shocked/saddened if adding an additional
> configuration is more difficult than overiding a module param.  E.g. I will soon
> be modifying my scripts to do both.

Well, the force emulation access tests take a significant amount of time
to run, so will likely be disabled for CI systems that run on a free
tier basis. But do we need to disable the possibility to run the corner
case test as well? I don't think so. If some CI system already takes the
effort to manually load kvm.ko with force_emulation_prefix=1, it should
get these additional cheap tests automatically instead of having the
need to carry additional patches to get them.

Thanks,
Mathias
