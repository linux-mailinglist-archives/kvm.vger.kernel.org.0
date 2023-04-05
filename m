Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA4B6D7616
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237193AbjDEIBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236881AbjDEIBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:01:32 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3BD30ED
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:01:31 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id er13so97971619edb.9
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 01:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680681690;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xzrb5s5Br9RP5gDexFG3RQ5eudtMvMoggpl4KjXHbVg=;
        b=YKjhZXg7cjthEPx+qwGYDUhrI0Z5JwNEX6Pv+yyCXc8uMiBzyAM4BqKbBF4bJJc1VR
         1aBQzDeTjvO0Iu8ysky6Ye5hNYaIlCwM2Tjl/SDBjaqGNtgnVKa3eiLfSb0vuHt+8I7D
         BCGkgZ894blWnlUTzJgjmvyJ/nJwSKdEBg/SbpOzxJtoDGLKPaeSBX5CPpqLCHP47BHi
         BQ3yR07B0n8sw/luFcyd+Qab59W0eo1dx4DtzjglWUNFJFP0Qp2uOEP8o+RMJkT8u4hj
         0lsgScOIVenWjHTPWNYlK2wrwddtU+N0Z2y8tjeLBL+w/nz/zUhfb4kFrSOVgksXpsPd
         OMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680681690;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xzrb5s5Br9RP5gDexFG3RQ5eudtMvMoggpl4KjXHbVg=;
        b=VRp2YARn/zQVNhtd0vjVWxujMMgBch0MP3qXz6eWeh2UliHrYbskCEmWcop7q2uFFc
         /fr2bGzDLXm6YXjrC4ZH4YCKdTPt++cel1nPF/jOMw5DphjKYs5Ni6Bq1h9uwN9nmPFj
         35sGaKHXhD+FZy5bjGPYcOkhcQHnhPRwThKVtr1Rtt0stB/GK5s0XEhKlINyVZCSmlkd
         P08M0y3lYrVb8XDZfBeN7wXJaiNAKU+UjLnViD3IEGGHoTljfWHNnhMk3gbubOVrusbt
         O4YgPTfktExUWf5SPmJ5mR/cLWkoHk8kqmU7QisCdYALWmFh0VmV52mWwq7jOYVsRgPM
         oapw==
X-Gm-Message-State: AAQBX9fhcHoxEF96KTUrPcIK3FZeV7VZCkhUwazrmB94w+SoU/eRXQ+9
        PMN5gJLndGQhYw9a/BHyTWjWScMdDYHkrumzRD4=
X-Google-Smtp-Source: AKy350bfQ+TvlGX3ohLGA9iH1k26vzGyGjvA0Aoe0tbFiJXWhzfA20Wirf84meQDwnHGVgIQCX/YbQ==
X-Received: by 2002:a17:906:11d9:b0:932:29a7:56ee with SMTP id o25-20020a17090611d900b0093229a756eemr1384440eja.12.1680681690187;
        Wed, 05 Apr 2023 01:01:30 -0700 (PDT)
Received: from ?IPV6:2003:f6:af39:8900:5941:dee7:da1a:b514? (p200300f6af3989005941dee7da1ab514.dip0.t-ipconnect.de. [2003:f6:af39:8900:5941:dee7:da1a:b514])
        by smtp.gmail.com with ESMTPSA id gx20-20020a1709068a5400b00931faf03db0sm6995439ejc.27.2023.04.05.01.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 01:01:29 -0700 (PDT)
Message-ID: <d92e7d91-042f-745c-26e2-7b23c499119d@grsecurity.net>
Date:   Wed, 5 Apr 2023 10:01:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v3 3/4] x86/access: Forced emulation
 support
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20230403105618.41118-1-minipli@grsecurity.net>
 <20230403105618.41118-4-minipli@grsecurity.net> <ZCtpgGaRN+B91B3G@google.com>
 <ddadeb78-52ff-4120-499e-e2bdac31a036@grsecurity.net>
 <ZCxR/Q2VwDWd/fzt@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZCxR/Q2VwDWd/fzt@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.04.23 18:36, Sean Christopherson wrote:
> On Tue, Apr 04, 2023, Mathias Krause wrote:
>> Testing bare metal on a NUC12 (i7-1260P) with kvm.ko loaded with
>> force_emulation_prefix=1 and not excluding AC_FEP_BIT from ac_test_bump()
>> gives me a runtime of little over 41s with EPT enabled and, funnily, only 9s
>> with EPT disabled, as that implicitly excludes the CR4.PKE tests, reducing
>> the number of tests to run by a factor of 10 (~38 million tests down do 3.8
>> million).
> 
> Ah, right, fancy new features.  Running on an Icelake, i.e. with 5-level paging
> and PKRU support, is indeed quite painful.

Jepp.

> 
> After much fiddling, I think the best option is to add a separate config entry
> to enable FEP, and have that entry be nodefault, i.e. a "manual" testcase.  Ditto
> for the nVMX #PF variant.  That will allow CI and other runners to enable the
> test for compatible configs, e.g. when running on bare metal, without causing
> problems for existing setups.  Well, unless there are setups that do a generic
> "-g nodefault", but x86 doesn't currently have any nodefault tests so that's
> quite unlikely.

Yeah, that works too. I was also thinking of a commandline parameter to
allow ac_test_bump() to take the FEP bit into account to allow testing
forced emulation, but not by default.

> 
> The only downside is that the CR0.WP testcase will also become manual only.  We
> could obviously have it ignore the opt-in flag, but there's value is containing
> it to the opt-in testcase, e.g. it becomes very obvious that emulation is relevant
> to the failure when the FEP version fails but the non-FEP version does not.

Well, I think there's much more value in doing the CR0.WP emulation
tests by default than there is to bind them to the "manual" test.
They're fast, only two accesses, so runtime is no argument here. They
also test an important aspects of KVM's MMU role, so we shouldn't bury
these behind a "nodefault" flag.

I'd rather see the command line option be a toggle for the access bits
permutation test only, which are dog slow with forced emulation.

>  And
> I also think we should mark the VPID-based variants nodefault, as they have 4+
> minute runtimes in VMs, i.e. we should encourage use of "-g nodefault" in CI when
> appropriate.

Ok, no objection from my side, as I have no dog in that fight ;)

> 
> I'll post a v4, there are other cleanups needed in the access test, e.g. the darn
> thing doesn't use report_summary() and so actually getting it to report a SKIP is
> impossible.

I think that's just because it's such an old test that predates the
reporting infrastructure. But yeah, it could get some spring cleanup,
like dropping the #defines for true and false ;)

Thanks,
Mathias
