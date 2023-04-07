Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B9A6DB707
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDGXNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDGXNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:13:48 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572A2E063
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:13:20 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id bg9so269760plb.2
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680909197;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+ItnoDxjRyq5NxF6TJi+AQI7ZLK0+7Nql3EFIwnRinE=;
        b=tBpx2Whb4QzegaMnt95h9v7OIs3R0veH7QI0AUG8m9HbqbV69oRmE1Lp3HyvnMwLin
         McrVCRHDPd0x2sKbwU88FmIlMhQnR+/8x5bkAEnXgzjwWrTRhDDlXblkJAD/Gz648Xwc
         5Raj8RHXLDPLqPir8wxUa9xK9fb7aGTo1JHNiEa3mGeWRYIsyKtHdFiZJYaxFCiRB9Sw
         e3YuDa9UieI9e3U+MI+GMOtmitZ6G286gVAMwWk6LF3ANI4RVLMGHfTrXI4s+jKap2JY
         LvI5E5XUdmS2/NCFq1bHDfM8/DxpdIw7Sp0m9wmFWfggE3O13TldNX65vBYEOTNlWaI7
         hICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680909197;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ItnoDxjRyq5NxF6TJi+AQI7ZLK0+7Nql3EFIwnRinE=;
        b=W0wQrvUfWaiiQOh//aBx8ilRULfnoONerklcPbpJUuFsXlKH/hYyc35UsE2eiGmvg0
         EZL15whyHV5oeS5Wv9b7ySJdldk8lYOqnQANr8n83GfW43/sUsK83SMh8I1J2CSrkcAF
         ym9zAlnATR0lql1dIl+NEAup6QSW8Kv195bJu5J3wgu1bjryuigpF0tV7zn+kOZx0gcs
         lDxp2aYett6eddGaNJ4ypwSh4Mef87FObrt8k796USh55Yel5DxHayXWtIa1rrGK0xnB
         5bXILdMgp2IJXIsnCEP75gDtL/gaV++ZD4zbTcnXjfU+saIMn0VYGtwdqNIzUUyRkXXz
         AAdw==
X-Gm-Message-State: AAQBX9fY/WCn2uJiB2R5eK+S3F4TgcyBDV40b5FEZpjh0e3tNlHEVceh
        hGjh+FPgLkDUDnovoBLJ+z2c0A==
X-Google-Smtp-Source: AKy350Y3lzjtZw4RK/yOE1pq/rsEAaEwouoQEVbujzz2mrQjMkOvcprqVjsdpaOumVHAhvkYih/Nlw==
X-Received: by 2002:a17:902:f544:b0:1a1:b8cc:59da with SMTP id h4-20020a170902f54400b001a1b8cc59damr5210653plf.33.1680909197678;
        Fri, 07 Apr 2023 16:13:17 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id x22-20020a170902821600b001a199972508sm3382209pln.124.2023.04.07.16.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:13:17 -0700 (PDT)
Message-ID: <9a1a1a4a-ef80-61a8-8d2c-55817fd12496@linaro.org>
Date:   Fri, 7 Apr 2023 16:13:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 13/14] accel: Inline WHPX get_whpx_vcpu()
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-14-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405101811.76663-14-philmd@linaro.org>
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
> No need for this helper to access the CPUState::accel field.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   target/i386/whpx/whpx-all.c | 29 ++++++++++-------------------
>   1 file changed, 10 insertions(+), 19 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
