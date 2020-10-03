Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6AF282327
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 11:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgJCJcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 05:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCJcl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 05:32:41 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9546C0613D0
        for <kvm@vger.kernel.org>; Sat,  3 Oct 2020 02:32:41 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id y5so3833679otg.5
        for <kvm@vger.kernel.org>; Sat, 03 Oct 2020 02:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lf+b6wz5aJcxLTuNyvH2xK88mrxNPbARWcfCoU54kpw=;
        b=K5Sjw0MTIeUlLlww3BOw6xcDB1/Qz4tk4Vph1UaEbLckM5ohrGn9M+oF6h1/5lnmhJ
         RPfzadY1+eClwFonL2SgiyOn9+397r7bktSIF55VTVf0uRA45T4G3HsKNuWKOZjw/AIO
         wc39cNiFzTALYhYhqD9bpIrC/UELcrLyhDY1oYoW7NDYStby0cK8sG2u0CXVIioF56Je
         AIRFbwa+KmMZRdQPFGPalKhoNU7sXWHuI8+3fXmMFt9rbAPbMG7Nv6eCPOOH3V59YEEz
         GXmk52dcQFBYuAKi8aDR52+f4N4sTyeh4QWohkU+Y1bSow2yZyYAsLJf8VYeojjS6sVW
         XmJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lf+b6wz5aJcxLTuNyvH2xK88mrxNPbARWcfCoU54kpw=;
        b=tYYXKQ77OuhBt73nYZ6tTJQCyPszpG/7cWTtADCB4LeVqH1na2LxQh3gLakH+HFHgT
         vw1eba/q3KBBDXtm1ZSpfJm02TlSeCbLoIJBAYjKYFzAkWluNMD8XJaEMEW5DJ10pT8p
         QXUvQj3/OLLweevIYYQDnmSm72arLdyJ78l4+qOO7DoagnENplpXlVoNbrlJsirflSn+
         rwYUBUvH0ZxVcJvEt9HVGnBb4rMqi23HJ5lj7nNbh8FhUn+BaYHivYECiTPuis6HrXNU
         g50iaii3sW4kX8TZOFOUVQzpaAKjb3rT4qDyR7orvh/6BNAHl1YSAhgtJGJJPc93zdfg
         diGg==
X-Gm-Message-State: AOAM53269useRZ1fOdj0pOqvzYA0rFa7Rggch8Cqf0lS045ZyMBqr7tZ
        yapXNu9108as/MaNBzNSEYUahA==
X-Google-Smtp-Source: ABdhPJyYmIU4ZCcxWQ7wTs+cZZk1NiROSUjjIuOHFA8sUv7v1AcsT8YCeOpCVq5eAsoY07+30gxZGQ==
X-Received: by 2002:a9d:70d8:: with SMTP id w24mr4662130otj.275.1601717561171;
        Sat, 03 Oct 2020 02:32:41 -0700 (PDT)
Received: from [10.10.73.179] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id s13sm1085739otq.5.2020.10.03.02.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 02:32:40 -0700 (PDT)
Subject: Re: [PATCH v4 02/12] meson: Allow optional target/${ARCH}/Kconfig
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>, Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-3-philmd@redhat.com>
 <31a173bf-6aa3-1ce8-7d14-5e8f11e2a279@linaro.org>
 <0303fe78-5ae1-2115-247c-71807ce74e12@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <af1779ad-bd09-d1dd-6790-e7004b59c0de@linaro.org>
Date:   Sat, 3 Oct 2020 04:32:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0303fe78-5ae1-2115-247c-71807ce74e12@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/3/20 4:15 AM, Paolo Bonzini wrote:
> On 03/10/20 11:13, Richard Henderson wrote:
>>> +    target_kconfig = 'target' / config_target['TARGET_BASE_ARCH'] / 'Kconfig'
>>> +    minikconf_input = ['default-configs' / target + '.mak', 'Kconfig']
>>> +    if fs.is_file(target_kconfig)
>> Missing a meson.current_source_dir()?
>> Leastwise that was a comment that Paolo had for me.
> 
> Not sure, but it was the only way I thought the BSD build could fail;
> unless the capstone submodule really was not present in Peter's checkout
> and submodule update was disabled.

I don't think the build actually failed, I think it was just the cmake warning
from the missing method: to which Peter objected.

FWIW with and without source_dir work for me when testing, and I'm about to
include it in the v3 pull for an abundance of caution.


r~
