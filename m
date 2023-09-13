Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5233279E395
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239333AbjIMJ0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjIMJ0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:26:31 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B57199D
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:26:27 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-401d10e3e54so71356015e9.2
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694597185; x=1695201985; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yLISRO2NpFaWpuzAOfeLhFfzsbM5UOXgPxP4XVkK9rk=;
        b=TuHcicnB1ijgNFy2GM2eVPirMDNeU7ZL8PgzIdiFJCMyrNeJnezydFE+gFbk9t86Ie
         m1pBK9KJ6KWJLzujmbSGjaqI6YxLRnw4UkHOjOs9fAuI4oSLJjXtHtwQ7PqPa8hcGKJW
         wrsibr7bd+/FvhBTPf+8C5+Okyw0odzMv406oBhzeyeQBKXopfQCxUw0egwCHHPsu0Mq
         SBBytczoencx/XWes+Oxv9IFGpba5FIUK5R+V1hcj6DoTAqK8kS1pHdjTfnvNnjuWw2C
         59E3I+2k96Y04LZ5uCUfqgtwThY9pJNH/lchUaz+FntdkZYGHV0i6n6id0YT3EZzXkRL
         4IYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694597185; x=1695201985;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yLISRO2NpFaWpuzAOfeLhFfzsbM5UOXgPxP4XVkK9rk=;
        b=w7UfSC6OHbm8YH4KEzKh2IO1YBEYN9/ywudjoKb38QifLEh+nHdLAjKfelBswUw/pA
         rkykxdhlembDiGw5RW+0UHWyLwcc+uslxJAfUQBvRu9bk8rQzgL6qoJ9UuSegHdwOWoY
         g3eolJrkx/LGCiCKThJez8Qt4vearI9APJVdDu8Vo79sGrY8zIieW5f2Hk0MQ5HUA1Gl
         GAipL7Iah95hz1UHkVhYReZ9CetPN2oPSTslrbKJbsEn/GdFRNUZjt2mAVZ8Yfoi5zYt
         vf8/FFutolmuszNo2fJesAfFEnNxx8lt5VvvvayDrjlt247IZVYXR6OIbkTyePXia7p5
         pEpg==
X-Gm-Message-State: AOJu0Yx7F+UzQc15WwE6V/tmgj1c4AkmRF+BLPFbBErnxOs+JBFDJtWW
        OEMXVLlIyaS8ONwg1NhXNBH6XQ==
X-Google-Smtp-Source: AGHT+IGMHC9p6kuHQ8IbOAh5/8MheSazUleuAXtpc8L9LVHcBmReZlslzrUEi5/yuLbJlDxqT7pHtA==
X-Received: by 2002:a7b:c3cc:0:b0:3fe:1232:93fa with SMTP id t12-20020a7bc3cc000000b003fe123293famr1612854wmj.22.1694597185677;
        Wed, 13 Sep 2023 02:26:25 -0700 (PDT)
Received: from [192.168.69.115] (176-131-211-241.abo.bbox.fr. [176.131.211.241])
        by smtp.gmail.com with ESMTPSA id r6-20020a05600c35c600b003fbe791a0e8sm1530210wmq.0.2023.09.13.02.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 02:26:25 -0700 (PDT)
Message-ID: <6cee629b-c1f6-7466-7881-4cc5296f497d@linaro.org>
Date:   Wed, 13 Sep 2023 11:26:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4 0/3] target/i386: Restrict system-specific features
 from user emulation
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>
References: <20230911211317.28773-1-philmd@linaro.org>
 <fabf2451-e8ad-8171-b583-16b238c578e7@redhat.com>
 <111b9277-59b6-7252-6ddd-13edff9b2505@linaro.org>
 <CABgObfaz+Tdb6YzwbAeRH=zdXtzVK7VLFv2Lc-MxQMAxbhwnfg@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <CABgObfaz+Tdb6YzwbAeRH=zdXtzVK7VLFv2Lc-MxQMAxbhwnfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/23 19:25, Paolo Bonzini wrote:

>      > However, the dependency of user-mode emulation on KVM is really an
>      > implementation detail of QEMU.  It's very much baked into
>     linux-user and
>      > hard to remove, but I'm not sure it's a good idea to add more #ifdef
>      > CONFIG_USER_ONLY around KVM code.
> 
>     Do you rather v3 then?
> 
>     https://lore.kernel.org/qemu-devel/20230911142729.25548-1-philmd@linaro.org/ <https://lore.kernel.org/qemu-devel/20230911142729.25548-1-philmd@linaro.org/>
> 
> 
> No, if we want a small patch it is better to replace kvm_enabled() with 
> CONFIG_KVM, and also follow Kevin's suggestion to make it fail at 
> compile time.

For target common code (shared between user/system), CONFIG_KVM is not
a replacement for !CONFIG_USER_ONLY, since it can be always enabled;
which is why we defer to runtime check with kvm_enabled().

> Having stub prototypes was done because we expected the compiler to 
> remove the dead code.
> 
> Paolo

