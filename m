Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB55E6ED0
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 23:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiIVVtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 17:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiIVVtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 17:49:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD04BE3E
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:49:32 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so3563619pjl.0
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=T+XRKCpg1B8aNlOY2e7DDXmhWthkytg/B3UerbZ/WHY=;
        b=MCWtKqspaNTzGw+DT/lAlTleDInBacSryLNglbVSklIFit2L30MvgTWXsOEsH/WpWA
         nE9grFkPrpbtlFX//l8VTg2QJzxuTFz9pCW8bSQkc66MqiOP/Dc8TkM+PDYrm2oca4GT
         zK++mgLEp8I+fTElnZhl3mMIp17FG1ren6Kl6xjz14bVNVq2U7MD8sSdZIUARRFBuG8Q
         x90RKBtimFYLtWUNxjz89CNpBgQSfWu/Yod6+JsHdTqYlSF8atW1wpfqgCAAjVYZnWqm
         lp0sYrmuXc9AKhtbAXoJPo6A1papse/Z2c1U4j0k13ldRIbLonUmFSdMzAVNkwoNjKVw
         qsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=T+XRKCpg1B8aNlOY2e7DDXmhWthkytg/B3UerbZ/WHY=;
        b=Xe9mtRebE53/CVIsDHKQEkljh2oZt4dDJblwuM6ZXwlB7G3soEyLoGIfDa6+JmYLZH
         NzwDoEbKH97mhv47WfeoFpitBDIX+UdR0len/VikRS3+k7OqR+oWZRj0XhBJUTPRkoW/
         KONnkhmT/6QSbwCFkUi0y125LqGOPLtLBhLmT8Zj+Pm7s8Bk3r2TxiqNwUYvYa/5eg6e
         GFV/8TTaX6U2LVdHRLXLe8RTNdyVq4O0KnD3dtQ+zdfvGw877bgHyNPCuUW7D15hS4Vz
         EdrBb+vo/1fcb/R9VjJazuRqvXpsYu9m3xEP8S+7+cnhaP7gWDfhmfL9pJVwio1R7NUn
         Z+Tg==
X-Gm-Message-State: ACrzQf2ER6nA3Szie5vBfi+N4jk86Y9ffetv6f6ejwnPGdNBwkv59aY0
        unvRaPMYaCCdZzrPR6rSZ2gMQf3aEII=
X-Google-Smtp-Source: AMsMyM6PaI2xUaEhg4auT3D+s+S09Pb742J+KSzZgLMnvTGQ4OFt0InBpoQ+5wG0tu0dxSZPV85lAQ==
X-Received: by 2002:a17:90b:17cd:b0:202:ee1c:9578 with SMTP id me13-20020a17090b17cd00b00202ee1c9578mr17652739pjb.87.1663883372199;
        Thu, 22 Sep 2022 14:49:32 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id pv7-20020a17090b3c8700b00203a4f70b90sm233145pjb.45.2022.09.22.14.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 14:49:31 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <e970fc04-600e-469d-e130-9f41fe87851f@amsat.org>
Date:   Thu, 22 Sep 2022 23:49:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v1 7/9] gdbstub: move sstep flags probing into AccelClass
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     mads@ynddal.dk, Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20220922145832.1934429-1-alex.bennee@linaro.org>
 <20220922145832.1934429-8-alex.bennee@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <20220922145832.1934429-8-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/9/22 16:58, Alex Bennée wrote:
> The support of single-stepping is very much dependent on support from
> the accelerator we are using. To avoid special casing in gdbstub move
> the probing out to an AccelClass function so future accelerators can
> put their code there.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Mads Ynddal <mads@ynddal.dk>
> ---
>   include/qemu/accel.h | 12 ++++++++++++
>   include/sysemu/kvm.h |  8 --------
>   accel/accel-common.c | 10 ++++++++++
>   accel/kvm/kvm-all.c  | 14 +++++++++++++-
>   accel/tcg/tcg-all.c  | 17 +++++++++++++++++
>   gdbstub/gdbstub.c    | 22 ++++------------------
>   6 files changed, 56 insertions(+), 27 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
