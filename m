Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8BB6983E9
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 19:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBOS5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 13:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBOS47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 13:56:59 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0530D3BD86
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 10:56:59 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id bt4-20020a17090af00400b002341621377cso3223059pjb.2
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 10:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2ty6Go6imRL7ziN4P5mkkosy0GQ2+LjZUs26ivjwRjQ=;
        b=U2vhKVdoN9iFSmXrjkqJK4FePEI44f52W/rAgGrDQp6w+nrkZoqao9XDa9j+nD15af
         JC7OJhnjRJwCoiNJu0lMjxjsJmilNNmUkSlqSxeeCcJiYbDFPXDdb0rR2nS5jm8AZM5B
         QdM4UdUJIRBFUygs2mdtCgjOqZkwe7QasHkjVf16iFsg+1/2CvbooULsEnlBwgsqf+ph
         EQiAGIt3mhpwSDXOoodsuyeLM0jewBsROA1dVbKygIEOw++TEL/y8sfS8yQKSKgGDCNS
         bltQ7wPrJ7eecjBX56Q/r5QIGpi96kyGSJUhrNiBWqe2+5BQlnM/LoFGGS48SAA7xaKs
         5JZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ty6Go6imRL7ziN4P5mkkosy0GQ2+LjZUs26ivjwRjQ=;
        b=yQZVccqO4fp5kzU14csmK7omGYCy56bk5w9/5NRUEBS+t8erkQgenZvM74ZUcpAfb3
         0VQDeyYl5w7j2iuLzg51/5UQWN9MQzakEOTHSws1qF9rAs+dzvnkoCbOk7q2/DA9yC5f
         kmFZeBcm4FNWggbiYV17vBTTf8pIyMv8cGYXb6dzz+UbSfw3vkLp3iY0R997zYmZpfLA
         EVYv316J/EDznbQNq0yU9UQQakRnuFPgGELpKiiLtEnoh57oTpMrutto8itRfz+zuiRi
         drK7pUIgkqsWMIS6444O6eMKME3zEOFO6vhByp3XXmZAIdrKfwSa5Nnoz8dE1lHSeNAL
         zNeQ==
X-Gm-Message-State: AO0yUKWGOP8TYrPtwdB1w55V/jdnsRti2WVX0PPpKJTGE+5YAyX1x3U8
        IYgS75iEiCTuLbFn/AuBSr5pxQ==
X-Google-Smtp-Source: AK7set+unld6jrOIAxw5cbdGNozT2yxZY3NSokKlDP7l6oTF0+nwdImKRxNhmj05ZwCJf5FuXI618g==
X-Received: by 2002:a17:903:182:b0:19a:723a:832f with SMTP id z2-20020a170903018200b0019a723a832fmr4817950plg.7.1676487418478;
        Wed, 15 Feb 2023 10:56:58 -0800 (PST)
Received: from [192.168.192.227] (rrcs-74-87-59-234.west.biz.rr.com. [74.87.59.234])
        by smtp.gmail.com with ESMTPSA id w14-20020a170902a70e00b0018997f6fc88sm12496392plq.34.2023.02.15.10.56.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 10:56:57 -0800 (PST)
Message-ID: <59eff7cc-cddc-bd5a-9d96-284172a515ba@linaro.org>
Date:   Wed, 15 Feb 2023 08:56:52 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/5] hw/timer/i8254: Factor i8254_pit_create() out and
 document
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20230215174353.37097-1-philmd@linaro.org>
 <20230215174353.37097-3-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230215174353.37097-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/23 07:43, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/timer/i8254.c         | 16 ++++++++++++++++
>   include/hw/timer/i8254.h | 24 +++++++++++++-----------
>   2 files changed, 29 insertions(+), 11 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
