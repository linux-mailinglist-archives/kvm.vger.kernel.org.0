Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822AE66D6BB
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 08:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbjAQHMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 02:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235679AbjAQHM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 02:12:28 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94AF222C0
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 23:12:26 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id q8so9689380wmo.5
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 23:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=flhtnoGh+xu6jpyJuLr/+tQvx7XmKBf8L5zhtbdTJXY=;
        b=zKrhN7kWO6HNp568SQ9LluSkqKnwNlmENYT87CYw2LtGH0mvQCm0Iq1c4ZFe44C+Mu
         T/IOc73pIfYKvU+N+SVh4pL5qHipQKChAxik3IMsa8ZzSG4PNjLHtjq66nbQpVsxbalb
         UGu++RRbakLIsHdaeVQIiMajaXS3RN0qBLYEU5y1QrlEpiwN+vLJa8BnsU8aRpsvGxyG
         2uHKvDbc23PPBj/6UuyG0OoH84dQTonY4U4yx59WEFTUBPEyB4cIj4peP2UhVlnIn3IM
         BjMFWcjBmKRNTTev3xgSs4Y2su0cSl3P0MCFXcA1pc4H3+RmjJ/Cz3GKldjdItdgwPur
         DhSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=flhtnoGh+xu6jpyJuLr/+tQvx7XmKBf8L5zhtbdTJXY=;
        b=ResMd765It8lgg9T3MXulmG6UA6qQjJ1YGxt/yNHn5W72Xtj3PW2qjqQvxkYGnGE3P
         mYeiCATKvy5A8bXU716gyMused861NwHRKSouuGDFtDVeRiAXIihXO4lqoStBXCZ8BK/
         ez/SI4mQV2P/KOHt3QsaGJwfEdCPEszKIbGBOaA8J0r+BRpgBtdYWCIrj1gfsmnvcbGj
         vFUiWgn3RI2ZfIyiqWWjf+Wa7gW1h884cdwrEbydtkCKgDehmVadfsutIKqL6x3mCugX
         3oZsAsfh5OPFPKxvgMwxVr3CXjf2HrJ2Wy7wOYB6lFmCIqeYQ6n9sCY/t69qpO0yZMPa
         Th1A==
X-Gm-Message-State: AFqh2kpBgXsumbQo8+Cc7T0IcIMfMSmeMRXkrK1iehB1WtaaFPu2nAJ+
        nCJuP2Md4xB9XU94LAwlzMmCVQ==
X-Google-Smtp-Source: AMrXdXsiy9YBZbMRbpjhOe17v3FMxsjxQ22ikNGjhCKQ24IHTXQilLrb0zTVHtv7Krfpwfjjm/7DMA==
X-Received: by 2002:a1c:7514:0:b0:3d9:f559:1f7e with SMTP id o20-20020a1c7514000000b003d9f5591f7emr10716581wmc.20.1673939545359;
        Mon, 16 Jan 2023 23:12:25 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id m5-20020adfe0c5000000b002bdfe3aca17sm5574566wri.51.2023.01.16.23.12.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 23:12:25 -0800 (PST)
Message-ID: <9a83580f-2409-dea7-82a1-667aa13dd65c@linaro.org>
Date:   Tue, 17 Jan 2023 08:12:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [kvm-unit-tests PATCH] configure: Show the option in case it is
 not known
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <andrew.jones@linux.dev>
References: <20230112095523.938919-1-thuth@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230112095523.938919-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/1/23 10:55, Thomas Huth wrote:
> When mis-typing one of the options of the configure script, it shows
> you the list of valid options, but does not tell you which option was
> wrong. Then it can take a while until you figured out where the typo is.
> Let's help the user here a little bit by printing which option had not
> been understood.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   configure | 2 ++
>   1 file changed, 2 insertions(+)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


