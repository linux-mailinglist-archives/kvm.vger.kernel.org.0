Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86C32823A3
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 12:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgJCKhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 06:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCKhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 06:37:04 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9FBC0613D0
        for <kvm@vger.kernel.org>; Sat,  3 Oct 2020 03:37:04 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id m13so3906417otl.9
        for <kvm@vger.kernel.org>; Sat, 03 Oct 2020 03:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VYwFI82HcYrq3ZgcNxh+7SPF1EvBaUooAvpT377YG+U=;
        b=kkuIbLNu/anD0Jaybii3oWCIfTglSY8QcWy0VEMk7kYxqR9SBZJg3GzDBNyVA3hs0X
         f8O7ItiVpZmFG0PDKDAtFf2ngs0jLSvRmYPcmu7cl3EiO/llS3gB/zwZpsjhdRILz6n4
         4CkEqwyCXw4uqKTUQZH8MnHnlQ7cbZpYrBvl8js/GMI53RiRSguS85jV34MbvWtQgORz
         cu9IGG84PAvnSSRfmQ7apvGD9kERUJHLzvOqbt2GbkSYIXKF4MkItCO0qdxdJ1+qYzdl
         2aqsRubeKaHyq1/Egd/Y+fDGY3B4H7YaBBOT0PrrHnVtz9y/336rnOCZhJ1etRp+bTbx
         Qm9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VYwFI82HcYrq3ZgcNxh+7SPF1EvBaUooAvpT377YG+U=;
        b=CufJVldOwODV+Yql2tze428qvuGMJpKmdm+wTfdzt1HmAO5uhDW5MDzUoMr62A4WNq
         zlnZosd30nxEFhb8Z66HL5emEkofO/ymBGx/9IUTq+0X3JvgGDcoG9x/DqALWpZ31PN5
         n2OUhhlOp0B5kilLGglic8QCGwtgdyjghJEdJnsaWZ9zhJ5gn92XT8aEEQxGxVVYIDPR
         pOKsZsfkK84nwi8RRXjqQ/6SYwdZ47ErQO462Nf0+1Fke9Afd9+2QLrFbM3Re7f1LPJW
         8owR7rrQr//ujNefzr5cq0VjBcKCkSKnGeq7XCxC3SsLWjknHFnxsJk75g9tbg7NgVRW
         lL4w==
X-Gm-Message-State: AOAM531VKLe/kXEeb7ReUe5204YDbbTX+ZJ0zpI+UyKgCeJ/YS9/1p48
        iWGXB+D9s7uQXq/Ujp+dGKJ5dyQgVEU5SQ1f
X-Google-Smtp-Source: ABdhPJyykWKhd6FiYjB5gw31NYFOzxdDlvz9ehjm7fFSXkcbpSlhgQsBUp9IHtz7QKHbMQdlKaIsEg==
X-Received: by 2002:a9d:7d8a:: with SMTP id j10mr4589711otn.27.1601721424036;
        Sat, 03 Oct 2020 03:37:04 -0700 (PDT)
Received: from [10.10.73.179] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id m187sm896465oia.39.2020.10.03.03.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 03:37:03 -0700 (PDT)
Subject: Re: [PATCH v4 12/12] .travis.yml: Add a KVM-only Aarch64 job
To:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-13-philmd@redhat.com>
 <bd4c4587-de23-7612-48c7-afc8b94ab9fb@linaro.org>
 <c7140a42-043c-9bc5-88c8-2cdad9ae2a14@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <01fa70d1-0f11-78a1-aeb6-885e91501429@linaro.org>
Date:   Sat, 3 Oct 2020 05:37:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c7140a42-043c-9bc5-88c8-2cdad9ae2a14@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/3/20 5:14 AM, Thomas Huth wrote:
> On 03/10/2020 12.03, Richard Henderson wrote:
>> On 9/29/20 5:43 PM, Philippe Mathieu-Daudé wrote:
>>> Add a job to build QEMU on Aarch64 with TCG disabled, so
>>> this configuration won't bitrot over time.
>>>
>>> We explicitly modify default-configs/aarch64-softmmu.mak to
>>> only select the 'virt' and 'SBSA-REF' machines.
>>
>> I really wish we didn't have to do this.
>>
>> Can't we e.g. *not* list all of the arm boards explicitly in default-configs,
>> but use the Kconfig "default y if ..."?
>>
>> Seems like that would let --disable-tcg work as expected.
>> One should still be able to create custom configs with e.g.
>> CONFIG_EXYNOS4=n or CONIFIG_ARM_V4=n, correct?
> 
> But that would be different from how we handle all other targets currently...

So?  Does that automatically mean they're golden?
Perhaps they should be doing it the other way around too.


> IMHO we shoud go into a different direction instead, e.g. by adding a
> "--kconfig-dir" switch to the configure script. If it has not been specified,
> the configs will be read from default-configs/ (or maybe we should then rename
> it to configs/default/). But if the switch has been specified with a directory
> as parameter, the config files will be read from that directory instead. We
> could then have folders like:
> 
> - configs/default (current default-configs)
> - configs/no-tcg (all machines that work without tcg)
> - configs/lean-kvm (for "nemu"-style minimalistic settings)
> 
> etc.
> 
> What do you think?

I don't really understand the suggestion.  My first reaction is that this is
more confusing than --disable-tcg, and trying to automatically dtrt with that.


r~
