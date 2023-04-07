Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35246DB6B9
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjDGXBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjDGXBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:01:40 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69155C648
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:01:39 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso8835895pjc.1
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680908499;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TyPr1D+jmxon9z6cKE0o6xLl1ClF9NGYyNAHslJg3cw=;
        b=qw2wYpt5HKJz5r2a7OsRAzIXXkpT+qRLgdZ/nuCwMrIJrOzNH3fD9ex8LmkqgpG98t
         P7PSjtCmHjdONgfStzQ+Ft1yGw+mfPAJthFu3pkWjLS+Cx48M7Vchp8/VYXnCx8F0Q2l
         rMqzBqzxBQ+l/wpnRRrS/rTAmA759a2Cy1DvVHxMSI3cQ01dOcepbymKuIRh7i5+Rj3y
         2E5GOExso1G5XPyhGSXfoim2hbUkG2QTnQTTe8bwyEhXxDoEojVOcZO2EHhYS1wbqqGZ
         YjJzG7gBuAZ1vZfTsQ5mtob4797mWInf+aP3yIRHgPoJedv7oF+XRHI69l3pt0FE3cNd
         WV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680908499;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TyPr1D+jmxon9z6cKE0o6xLl1ClF9NGYyNAHslJg3cw=;
        b=qPTcmvX5TfNTKU6zlURobLPDqDyaRPq4l2CkHx1URTWaGjaDL8SDAuidIpcyr0QtFj
         29o0xqb2LJPjW05XU1m5LCh7aokDycbGncfDHwMBr0U0SRyVNlAXPWGu/9fh1UCCv03U
         nBSe4FnX3kL/gQbZ/EsfbmLN8J8k/3g8op1gC70cCQ2pyELcBxdMnu4VnoxKvXflU8Wo
         s3e6ZalkRv87XgkqsIWyEEZi34iUWRf99SDWaJYo6GqTHMj92MWPmNTQqC2VM3XfqaAR
         HzdarCOvi1BTBOdAV6yfSmF01sVBL7jmZOiTrc3Vv9Nldl4H0tVHOknpFoQeu4KiYYz0
         xhUA==
X-Gm-Message-State: AAQBX9dLcFXlvHazwDPZtANXyVfrVbT7NICkqlaTo5wdTXmD1cpIfFcw
        VY3dQO7ygmPXRO57DvrRbcjEHg==
X-Google-Smtp-Source: AKy350ZQLIgsGvtQbrBz25NftlqZ9SOXyQK0RAxFlNjlFwKEYf49WMV87F8ttHZLtHbQzsn5rLkPTA==
X-Received: by 2002:a17:90a:34c2:b0:246:6b3e:38dc with SMTP id m2-20020a17090a34c200b002466b3e38dcmr1539291pjf.10.1680908498904;
        Fri, 07 Apr 2023 16:01:38 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id l2-20020a17090aec0200b0023fda235bb5sm3162546pjy.33.2023.04.07.16.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:01:38 -0700 (PDT)
Message-ID: <ba69b6b3-1b4f-6cc0-34a6-4c19fa3dbb8d@linaro.org>
Date:   Fri, 7 Apr 2023 16:01:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 03/14] accel: Fix a leak on Windows HAX
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-4-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405101811.76663-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 03:18, Philippe Mathieu-Daudé wrote:
> hThread is only used on the error path in hax_kick_vcpu_thread().
> 
> Fixes: b0cb0a66d6 ("Plumb the HAXM-based hardware acceleration support")
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   target/i386/hax/hax-all.c | 3 +++
>   1 file changed, 3 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
