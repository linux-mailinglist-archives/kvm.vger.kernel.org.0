Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9AA28237F
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 12:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgJCKEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 06:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgJCKEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 06:04:01 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A2AC0613D0
        for <kvm@vger.kernel.org>; Sat,  3 Oct 2020 03:04:01 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id x69so3766874oia.8
        for <kvm@vger.kernel.org>; Sat, 03 Oct 2020 03:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cG+rDiGufIRUZmngOUTf5V0P1gEN2vU/I0BKD4lYt1U=;
        b=HdJSC7mDbiLifLA6qFPvkUWJX0Cfc+6dls/6n6VrDuxJqkAIlTuLnRTeeccAZCwVEq
         WbRW1oCg1sZgeVV5YMgz5+gQR/KoLrI1UQvGKPwV5CEN2zoNmXM/Y8qqKPnnFkHjcBTN
         A4TW+urnAoa+fse2BW7gDWhVtwgWazBcDb8ZCYZVYH9dLDcFbePe6vObYCwKtSNiSffo
         ZVx77zc/+/D1RqLVe5T+pTqzja9KMwWUvT5fXgS3vmCV7lM2APa/mXGQxCyZhsewcmNV
         nO80LcoiyKmAzMqM6uqV7upkTS4QCMgJV7xAjrn90AiPr4B0Z5ywj8Iwwl71vldE3Nny
         owlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cG+rDiGufIRUZmngOUTf5V0P1gEN2vU/I0BKD4lYt1U=;
        b=mcFUs+K7La0285d13qyp/UZuPcjIv/3hYQ2NntJsBP2VqsD93875zG8z5evpMV7idN
         KkndXS52ImKBMjJBUZq0yrDc4mv3frbsOfe7tuqp6Ejxja/E7atbvFNspp9mI65O4+6b
         dk76Ha+uR4ogZsqA3Baw47Z9x/0ZuEcWVJ0XwaLGPxmk9rZwIVOL3TAjJE7F1yBF4fAx
         J3WdF3fvVGSWW22j6D5xDnYfThmQOCUeOObSrO05fkiER88kU4OgpBU2f9gOZZaDmsh8
         HZCeLMT8MZ+UqNYcwmbnuxV7EYAYKuSqdFpe2vwhBaMn1uF1CgLlI0Usl6l7xhLv7Fop
         Ngvw==
X-Gm-Message-State: AOAM531xinDJauhudP2Tqw1f1RZ1njW2Ml1LaA9lsr7ivVEf5+EI9C3G
        YiUBPrCLv79nsCQrrHJ6zt7UuA==
X-Google-Smtp-Source: ABdhPJwIeDtlbvhrW+UehIVEor+MVHY96lsLif2Knq/6uJbUXaH4H8RsDWtuRdpkBSxiFT5aLe+D9A==
X-Received: by 2002:aca:ef03:: with SMTP id n3mr3457690oih.67.1601719441143;
        Sat, 03 Oct 2020 03:04:01 -0700 (PDT)
Received: from [10.10.73.179] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id j21sm1162131otq.18.2020.10.03.03.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 03:04:00 -0700 (PDT)
Subject: Re: [PATCH v4 12/12] .travis.yml: Add a KVM-only Aarch64 job
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-13-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <bd4c4587-de23-7612-48c7-afc8b94ab9fb@linaro.org>
Date:   Sat, 3 Oct 2020 05:03:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929224355.1224017-13-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/20 5:43 PM, Philippe Mathieu-Daudé wrote:
> Add a job to build QEMU on Aarch64 with TCG disabled, so
> this configuration won't bitrot over time.
> 
> We explicitly modify default-configs/aarch64-softmmu.mak to
> only select the 'virt' and 'SBSA-REF' machines.

I really wish we didn't have to do this.

Can't we e.g. *not* list all of the arm boards explicitly in default-configs,
but use the Kconfig "default y if ..."?

Seems like that would let --disable-tcg work as expected.
One should still be able to create custom configs with e.g.
CONFIG_EXYNOS4=n or CONIFIG_ARM_V4=n, correct?


r~
