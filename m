Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23367A9E1E
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjIUT4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjIUT4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:56:13 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B94D7D99
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 11:29:00 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-99c3d3c3db9so163940466b.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 11:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695320939; x=1695925739; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7/A5vuenmlkhrtFrS+dNGrMMk0S0NguCO8nxbIZO8MA=;
        b=za/bwEu58/1oy0dssB6qxp/PxP7piTIioozOFns9QMRcBS/tdc7hE2LNWsLF9L2fnd
         bHoyoNJ3N2s2jOO0MuCDsybChNPTupSeUuflcC2oYzk6PW+fu+La9kwYXVDx0lLLkAgA
         tXV0jBoT9h3B7JHp/C4ZLBYooDuTPymPPstVdkS6Qr+WanWFQ6aqoRbfjxrZzOm6fouz
         7kb66knVw1ArNWSQGF+orHvoiXZuZlcyK4UYj1+ypzHzLqGaa/kjct7Im1zZHzIt3aph
         R49sXrVAemKQmapH6GDHVAiSsjpqYaFnUMkD+YOqE7ouFnNgMpL18Ajz6F9c4T9h1d2O
         YHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695320939; x=1695925739;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7/A5vuenmlkhrtFrS+dNGrMMk0S0NguCO8nxbIZO8MA=;
        b=T5QaHNUEyuNqp/u/iTPZLz9MEf12Bc2RIonyxTJ845Et8CvwG7St0zTtiIwkrMJIcg
         c2WGj6I1ja4pZTaOhjLFRe64YC1SlY3Gbirup5FVXJusOh+qpNOeifmWXqp+NRH+6gyc
         Jj6HEpLZ9FQjd+3c4GjxggLkun5XlcwHRYf34fmnxNVpEGtnvHqHPLbcRvrftXYS20Y/
         jlxcxPHu/Dyp1Sm+NhOST7666XOREAAWKChD4RQz6XnIgLgQkWqf5wRn4biEDTFQWJmm
         f1h7pYiAk0HUQ6/n4MuKAUdibQuUPWNRVZjhpxyzoutiRHaC/Y5CIoyP5cGkeLSwY6Rg
         /1+g==
X-Gm-Message-State: AOJu0YyJSLnNrXeDznHozL7nNUZwOO7jJvzRLHwgz0bewC1zGk5n4zmb
        qLG9bX+IbYTHBBU3O3rfpi8RJtnFi0RXalqcAU8=
X-Google-Smtp-Source: AGHT+IGKNz73zo4UkMPomouZfO94XUGgOfRKCBkbrngSPaYsObeYHl9nQc8Iy0vty3o7VjdL8fmYiA==
X-Received: by 2002:a2e:8892:0:b0:2c0:d06:9e65 with SMTP id k18-20020a2e8892000000b002c00d069e65mr4701307lji.8.1695300505959;
        Thu, 21 Sep 2023 05:48:25 -0700 (PDT)
Received: from [172.20.41.70] (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id bg1-20020a170906a04100b009adce1c97ccsm1011913ejb.53.2023.09.21.05.48.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 05:48:25 -0700 (PDT)
Message-ID: <eef75622-0e4a-3605-5ec3-5d21c06d5c41@linaro.org>
Date:   Thu, 21 Sep 2023 14:48:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 2/8] KVM: arm64: Hoist PMUv3 check into KVM_ARM_VCPU_INIT
 ioctl handler
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230920195036.1169791-1-oliver.upton@linux.dev>
 <20230920195036.1169791-3-oliver.upton@linux.dev>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230920195036.1169791-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/9/23 21:50, Oliver Upton wrote:
> Test that the system supports PMUv3 before ever getting to
> kvm_reset_vcpu().
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/kvm/arm.c   | 3 +++
>   arch/arm64/kvm/reset.c | 5 -----
>   2 files changed, 3 insertions(+), 5 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

