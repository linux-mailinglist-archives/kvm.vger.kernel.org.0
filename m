Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45183626726
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 06:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiKLF3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 00:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiKLF3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 00:29:12 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E38A10563
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 21:29:07 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id q1so5922189pgl.11
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 21:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q5gU8ipiRrz8dtkFTDLWFTjOXTZAEzfd68uklGNyxIQ=;
        b=EsTcS/5gFSUpcGEYuuw2MGupOY8zjopRu0ktKqja7Dj6kFaFr5ZxZTsgNGVL3TDH3O
         T0D8Y5J/QHqver1RNfGmBRzlhyh0xOFhQk750LXsWEdMMIPXC70dvKJQqX31E0/UyTzR
         AXdS6eSb5jXwkpUwNrbjQUKFlXmN6y9vLRrF8dVI1cSmyHiYvrSCoCTMeDd70zZ1Tft6
         jHQAIqIgfZv0TkafOOVqQqlbaKviSfFh3eMjElAWFmKOqIFfdE7IY0HqqmQ/WMS4SGG3
         cOstR0jkru4i8Csf/UNpYQBFT9FpSElmEAMXG3mmJVaevLcJKiS6wG1VV+2kkinQOQzj
         RG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q5gU8ipiRrz8dtkFTDLWFTjOXTZAEzfd68uklGNyxIQ=;
        b=akGYKkUhIsyeSFuYkoGtvVH6yka6TILVoiheXuZo8+Vh3pJU/mrOEYaTR3TorcPCzc
         Cb5y3lwjRiSMkU7RGEz7wvwOworey0uTauGO+R+VI9T6PQ0wncHr2YjHeGQQGAs5FY+V
         lnljoi+GpKFfo4+682YbJ1TWjAAUjPsRxZ4fRy+7T5slPP7WIM/13mo898SBDrdK04sM
         T5iDUajWy9CW9EQsKtGpSFYgUkQ3dBB8fdaIE5eUrOSj9vI3VTxYVcktaHFKyeBl4Yia
         bi0d4QJeRs1QUJU2px+2uVBUJu02x+P3cmJFRrIE9ioi1Obhi+wS3GzXOFaFgMRnswQs
         eMUg==
X-Gm-Message-State: ANoB5pn6c8QkD6FVBiVhVS8fHlBlN42ApRvNVKjP6aVnUpje8qVNPdAv
        kQFAPMHAZPRX75GPx/WkZ9eR7w==
X-Google-Smtp-Source: AA0mqf5nYyjlASOS9piFe90wdi4YeHxP3ydP5US24xV2Sg8mf4qxnEKSccJW83HBVHf8OxSdOh9xkw==
X-Received: by 2002:a63:e00d:0:b0:464:45b5:745c with SMTP id e13-20020a63e00d000000b0046445b5745cmr4430453pgh.118.1668230946854;
        Fri, 11 Nov 2022 21:29:06 -0800 (PST)
Received: from ?IPV6:2001:44b8:2176:c800:8228:b676:fb42:ee07? (2001-44b8-2176-c800-8228-b676-fb42-ee07.static.ipv6.internode.on.net. [2001:44b8:2176:c800:8228:b676:fb42:ee07])
        by smtp.gmail.com with ESMTPSA id a4-20020aa795a4000000b0056d7cc80ea4sm2476240pfk.110.2022.11.11.21.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 21:29:06 -0800 (PST)
Message-ID: <97d50924-66c3-80d7-30cf-f157da6477aa@linaro.org>
Date:   Sat, 12 Nov 2022 15:29:00 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 04/20] target/arm: ensure KVM traps set appropriate
 MemTxAttrs
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     f4bug@amsat.org, Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:ARM KVM CPUs" <qemu-arm@nongnu.org>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20221111182535.64844-1-alex.bennee@linaro.org>
 <20221111182535.64844-5-alex.bennee@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20221111182535.64844-5-alex.bennee@linaro.org>
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

On 11/12/22 04:25, Alex Bennée wrote:
> Although most KVM users will use the in-kernel GIC emulation it is
> perfectly possible not to. In this case we need to ensure the
> MemTxAttrs are correctly populated so the GIC can divine the source
> CPU of the operation.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> ---
> v3
>    - new for v3
> v5
>    - tags
>    - use MEMTXATTRS_PCI
> ---

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
