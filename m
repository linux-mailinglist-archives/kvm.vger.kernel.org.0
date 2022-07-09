Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CEA56C61E
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 05:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiGIDAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 23:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIC77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 22:59:59 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDB87AB21
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 19:59:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d5so270457plo.12
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 19:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+wfnHbZqha+Bnbae0/WVZKsuUJrB7fybdYg9Vfg9MfA=;
        b=aUxyPdXKSwd0UinnwmEnUJ3e4lJl/uGAGrPQOIHOvoKrX2HFgl1tHixPc2A1/3jmjc
         AU8WbfjbJb1p0vM1gZMezxccJIcNg3o5xfyxEBwzl1hnAwOZmSdhLk33Acy61qbtcPIO
         DbH0IR1sR3g2aNCKNPvYLYrDRH7pw1wJFiDnVzqaSVEkIIu5geIeJsZfdq60//s8y+PR
         NQSZsKLlwHIrrfo5uaoIR8wm1LczJ/7I2OfK5MAD1GH/KZqk2VHbD08HfI5sQgEwVGMQ
         IE/r2922aK0OsZvTvoGARRG7qCnT2qkQUklP/8iStdK9HNSmwcgmJqjj+jfxUG/IGvVd
         SSjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+wfnHbZqha+Bnbae0/WVZKsuUJrB7fybdYg9Vfg9MfA=;
        b=RiPBKLC4MXiHZkdI38GUxqg9z1xkGkI1RxzODXdRT/bdaMIgng0IWRYhBZX0UuyKb8
         RiHkqALvcR2Y52zttWXWHGqRxwY95usFnsv4PW/bqc3Ez9H2bAqVMBfFCAI38glHUadF
         etl1PiyPx6GYkGPgk85xlerx7RiQehh+OHI+l5tfNYy8gA4miVh94GAwB5ISaRwe15+X
         C8MEutMxAkbDNsXNVuhsQ81LieBBR757/e2ArdWY43vCC6Se21Fvsx1S0aPZmCmiJlVs
         FcoKeNFAPQrWn8us7rABezx619QpoJPm5LodK4MS1xZbRIAswXzWu1GpQZgsTpZy/hOu
         XVuA==
X-Gm-Message-State: AJIora9K8ZCRwc/5FwWQw88+HiSVsZMgJdD7LTbVTCgqgg9u2Gqt/iHq
        mk0Cm9vMtD7EK3KiYd8FEkU7mA==
X-Google-Smtp-Source: AGRyM1t+bFbUEmHhT3R+sE2kPW09HXQQ3FsxckmcSw30y6vbNnROnMT1YAyv4bXb813fJvJ94G9xyw==
X-Received: by 2002:a17:90b:3ec2:b0:1ee:d9c3:53ce with SMTP id rm2-20020a17090b3ec200b001eed9c353cemr3438524pjb.189.1657335596424;
        Fri, 08 Jul 2022 19:59:56 -0700 (PDT)
Received: from [192.168.138.227] ([122.255.60.245])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090a2f8800b001e31fea8c85sm2050578pjd.14.2022.07.08.19.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 19:59:56 -0700 (PDT)
Message-ID: <89098547-6e30-96b0-2e7a-f131999c5528@linaro.org>
Date:   Sat, 9 Jul 2022 08:29:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH RFC v2 0/2] arm: enable MTE for QEMU + kvm
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220707161656.41664-1-cohuck@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20220707161656.41664-1-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/22 21:46, Cornelia Huck wrote:
> If I'm not misunderstanding things, we need a way to fault in a page together
> with the tag; doing that in one go is probably the only way that we can be
> sure that this is race-free on the QEMU side.

That's my understanding as well.


r~
