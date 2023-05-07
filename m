Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6496F966F
	for <lists+kvm@lfdr.de>; Sun,  7 May 2023 03:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjEGBSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 21:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjEGBSv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 21:18:51 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39B61435F
        for <kvm@vger.kernel.org>; Sat,  6 May 2023 18:18:50 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-24e2b2a27ebso3087118a91.3
        for <kvm@vger.kernel.org>; Sat, 06 May 2023 18:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683422330; x=1686014330;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SaJ3H7b41kfDY9IIs2ipVZrhE60mI19aWaLVFj/W8oM=;
        b=Z8XRGLj+rPkKJTCilNcN9cTw8uxzTvYGEptFHuAg5GkLCm3uvzkT/mNsgN2o4P/365
         Q/aar7RKSVJHnNtjJ1C9Qtky/3ZMaiROAr3vVJgoCSWU+YbOLbjoMAJrfDVR2hUF/VaE
         0gUNFyjQSjHW/73M2oI/2KP8IImIv+R9cmVvsGtao35IsBndQ97Bby9as5I21Ei9Yxht
         ZYRTuczM6NCS0YbyZMLSS+Bafwl/DSMY1leHiiCnhEt04k5PBGQZI1m5t5RIEK6xWcMW
         6JbhfP2xEDfC2qxOi3rEroPcbgb1JF+xL0v+dYUvlk6s4Kgya30tDtLN5NoXYlB3oeqj
         YwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683422330; x=1686014330;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SaJ3H7b41kfDY9IIs2ipVZrhE60mI19aWaLVFj/W8oM=;
        b=Kn3U3DrpSEOO6rkP0vBfmgnWlCwIDJtmd9Usfd2cG6ld05CD+N3Xr36HA6NA1nyNuw
         ikDJkTb1OV9CUDMMgqBgEx666A14rFZASNpoRgOpxPRJXqwOsy6E4T2ebz/8M8qlVAJg
         8eyvEcI7a6GD1OtZH2kDdXjhsl2sWODMhpcCwskipClN0BARlYf2AXD0/PtVKIxgBwtE
         kQ7F2N3BnFL98cTKMHERwyP3m740wwQNOBwZMhZ1uBrlUb7cwvaeGkUYeZwN05Ady5a7
         b9MvERBs/55voPJtzhtlWd3emtvQLjE0ZNrabDus9W/R7xHBr6v9nyx+r3wHOnc4gxrh
         DXbQ==
X-Gm-Message-State: AC+VfDx32viGHmfFn2zdMnCWf63LWFaVh53VhzdvfAUYQ2Hw6IwwKsFK
        edU3MeM5oQJaJmODOi7GWXk=
X-Google-Smtp-Source: ACHHUZ5UXiC6JqQhI5+TJkTFtYJ7dPBesnABOGQx6rNfHZvUBXj/16P4eFpu0QNQkocmL98R1wyWCA==
X-Received: by 2002:a17:90a:d681:b0:250:7347:39eb with SMTP id x1-20020a17090ad68100b00250734739ebmr342319pju.20.1683422330276;
        Sat, 06 May 2023 18:18:50 -0700 (PDT)
Received: from [172.27.232.43] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id g3-20020a655943000000b00528b78ddbcesm3541650pgu.70.2023.05.06.18.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 May 2023 18:18:49 -0700 (PDT)
Message-ID: <cc3f5744-e7b5-4202-a429-baf40a6b1667@gmail.com>
Date:   Sun, 7 May 2023 09:18:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not
 itlb_multihit
From:   Robert Hoo <robert.hoo.linux@gmail.com>
To:     Sean Christopherson <seanjc@google.com>,
        zhuangel570 <zhuangel570@gmail.com>
Cc:     lirongqing@baidu.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        kvm@vger.kernel.org, x86@kernel.org
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
 <b8facaa4-7dc3-7f2c-e25b-16503c4bfae7@gmail.com>
 <CANZk6aTqiOtJiriSUtZ3myod5hcbV8fb7NA8O2YmUo5PrFyTYw@mail.gmail.com>
 <ZFVAd+SRpnEkw5tx@google.com>
 <7e8ab4a6-ace9-c284-972c-b818f569cfbf@gmail.com>
Content-Language: en-US
In-Reply-To: <7e8ab4a6-ace9-c284-972c-b818f569cfbf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/2023 10:49 PM, Robert Hoo wrote:
> 
> And, what's the difference between "off" and "never"?
> 
Ah, after a night's sleep, my cognitive abilities are restored.
"never" intends to block any other settings if there's VM created.


