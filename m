Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68C1601A5C
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 22:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiJQUg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 16:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbiJQUf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 16:35:27 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70277F265
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 13:33:58 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id bu30so20257446wrb.8
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 13:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DpFRQZsOmdW9c3SZsmEc4FDFMxHFXWrDNqO8HToIKbM=;
        b=nnGtmLBJbg/Dz4Ev5W1kS5QWcbUVTCJXoo1L6aJO//jgQNOYYIEhlPRmkn68+Se74o
         QjjSpGBvOiYh4d9TRuOLTECVgySqc0PNKMJb9JvyfHV+43s8WdjiPM1qy3Ou4AW5fZWC
         /+fmop0FJnVq3MRuWhSb2stmWt126ME5XZDY4uF+GhB6QWbJBHOemSvk+jzipirrIpGT
         WafokMDYc8TUgjahhptVTgRfeYAS2U4Gp820AqthEvlZcHa6C4ULQC4uOSWiYVwKMGDA
         nMBYic6JpeLh8/Q1RqoRjzAn9UoLn6XnTzqUMQnTzQEALOenu8xGSH0Pek+CstMGdl7P
         aBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DpFRQZsOmdW9c3SZsmEc4FDFMxHFXWrDNqO8HToIKbM=;
        b=VThX73jSEOhah6rtMmnPOuyjBHr+5NnNTmqc5rl35ynYot9isr4SVemsh+YvvMTZce
         MPAaw2cBXNWt0fHw3lOFVpZ7dCLUJRYXHiA33fqaT6b4X/NaXvjPAKZO1SQX+K/Jh8fb
         PyTZa1g3eO2lJ0mOrqAhMj+lk1F6aLdjkvQh3RgEmm8XSJD5on6fsAt4NOnMJFQZ7tHc
         VESlnMrGAccJ9eiG13P8997dwDrVu/b6bqvgl8XEBClySQi+TSM7OlC4IWBUub8UXNY9
         mjT+K6AB3Ej+TUBCCRgEo6s0cdfT+JP3Cg9PCmSLwkGfWHlibcApGbktV4F2G+FU47ja
         Yrbw==
X-Gm-Message-State: ACrzQf1E2B9R5KgA80e4N7GES3U9dnbuxf6W2nrpPXAlfGEktKVQ7BCH
        P+YNuDQE8Ygidb4mAVsJLli9cQ==
X-Google-Smtp-Source: AMsMyM5ekRBaAlfTq0XCOYKDJstuADP7J5QGlNJnWuMqJYHe0SqM2mGL4/dvjME/dpR8t+4Mewhhjw==
X-Received: by 2002:a05:6000:704:b0:22e:c347:291c with SMTP id bs4-20020a056000070400b0022ec347291cmr6923792wrb.585.1666038756434;
        Mon, 17 Oct 2022 13:32:36 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id o13-20020a5d670d000000b0022cd0c8c696sm9383231wru.103.2022.10.17.13.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 13:32:36 -0700 (PDT)
Message-ID: <13211d56-db6e-33da-2624-20aec8a0b3c2@linaro.org>
Date:   Mon, 17 Oct 2022 22:32:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH] MAINTAINERS: git://github -> https://github.com for
 awilliam
Content-Language: en-US
To:     Palmer Dabbelt <palmer@rivosinc.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Conor Dooley <conor.dooley@microchip.com>
References: <20221013214636.30721-1-palmer@rivosinc.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221013214636.30721-1-palmer@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/22 23:46, Palmer Dabbelt wrote:
> Github deprecated the git:// links about a year ago, so let's move to
> the https:// URLs instead.
> 
> Reported-by: Conor Dooley <conor.dooley@microchip.com>
> Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> ---
> I've split these up by github username so folks can take them
> independently, as some of these repos have been renamed at github and
> thus need more than just a sed to fix them.
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Philippe Mathieu-Daudé <philmd@linaro.org>
