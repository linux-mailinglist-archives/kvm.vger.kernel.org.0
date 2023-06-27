Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F24B73FC1C
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 14:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjF0MnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 08:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjF0MnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 08:43:14 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87931269E
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 05:43:13 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-986d8332f50so567170866b.0
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 05:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687869792; x=1690461792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oiGMShFqsK5vy0r+ZoVprgd+7ONOa51b6TZq+l7w8nA=;
        b=N9jYqZxdR661UImV0f2eqz9etcpnHRQWFJOWqbKzx+pPrr0rGpTyRrmz5XuUcm1Jel
         baeVg/QwQJBCIEde+fmbP7LG4Izl1AuD0EKT+rEyp5sfJSH192El68xs7rbT6+K4WH9y
         IfQhrB0iGU5wf9XPYsYmDFUbqjvN0yAjtDAbR5RKLJJX7UPC2owKWr4ScVk8mulj3v1M
         rUlnRkKpW+k6Vp3tBKcP/u8zcAy+nchDJTbp1UFf/jwRX/gpGEnEqqlo9lImfk5IYIgt
         /E/zRUzGds4zgAE/1m6/1FiPOwoCYKzmruujyCiOPEFDktm5hG65u6lqnFuN24x3EXwg
         3F0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687869792; x=1690461792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oiGMShFqsK5vy0r+ZoVprgd+7ONOa51b6TZq+l7w8nA=;
        b=TTZngoVcScsxa81o2UhPL42y8o6GZshMZfCH+APgesbp0yBAQXZAM3jEOqwCFB+rjH
         h3Jy3edczaGy0Q/lfwteT4dbsjVxl0mGSa6Uk8ja48rQig7ScS71yOvK2BN1DhfsyTU7
         6DuefJPCSyv/1P6TSHEdKatxobLCNNay0tc/DUarfuNeihTyTZlYlUHyk9PreTNWWUv8
         Et/Gp37VyFbgrSEwJE+5dZTjoRgkam6El/33pGoCKP5jHJOOO1HRkyLuGC/3vMamao7t
         hp2h52dmKq5VhdUyl46ybWyQYq0UJU0/cuTJm8aKfuy5Nf+j6geheKBJPEdZvzvkUvrQ
         IA6g==
X-Gm-Message-State: AC+VfDxEESBjfLzLsas3xfCcy9MV+yPkbJd0oaxj/eTXFwo7thaoe0UI
        3Shucm9lCRfl0IchZUVBYCyWqQ==
X-Google-Smtp-Source: ACHHUZ6zoAvKTmIUPl7vS48VUGVb/8NUBU9FbZNA+3XvIM6YbbuEMppTKmcZbeQKq+uiXwT/1/ecVw==
X-Received: by 2002:a17:907:c0a:b0:96f:d345:d0f7 with SMTP id ga10-20020a1709070c0a00b0096fd345d0f7mr28092609ejc.62.1687869792013;
        Tue, 27 Jun 2023 05:43:12 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.199.204])
        by smtp.gmail.com with ESMTPSA id kg1-20020a17090776e100b0098e2eaec395sm3430672ejc.130.2023.06.27.05.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 05:43:11 -0700 (PDT)
Message-ID: <9d54d187-dd61-9d48-01bc-d0d6a44d119e@linaro.org>
Date:   Tue, 27 Jun 2023 14:43:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v3 15/16] accel: Rename 'cpu_state' -> 'cs'
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>, qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230624174121.11508-1-philmd@linaro.org>
 <20230624174121.11508-16-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230624174121.11508-16-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/6/23 19:41, Philippe Mathieu-Daudé wrote:
> Most of the codebase uses 'CPUState *cpu' or 'CPUState *cs'.
> While 'cpu_state' is kind of explicit, it makes the code
> harder to review. Simply rename as 'cs'.
> 
> Acked-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/i386/hvf/x86hvf.h |  18 +-
>   target/i386/hvf/x86hvf.c | 372 +++++++++++++++++++--------------------
>   2 files changed, 195 insertions(+), 195 deletions(-)

Per IRC chat:
Tested-by: Peter Maydell <peter.maydell@linaro.org>

