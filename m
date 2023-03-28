Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAEB6CC958
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 19:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjC1Rfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 13:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjC1Rfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 13:35:30 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3251D514
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:35:26 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j24so13090805wrd.0
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680024925;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=12AHmjD6DHnQ1cCgPRQFVhfgHqTAtYo/JRfqhlfkpz4=;
        b=IuhcHpqPrMnp0mcUWzJQ+asWDSdrjhSw00Mu0aK12/jTzHJh77+agy8uRv02oTNmlu
         IV+kNty0F362Vp1S7yw+7aFSoKIZlo883iPer16pGsVck1rohFc9wJIPGLPI9yiN2Cxk
         gmCflVwGZRs5dBYCwNxCfOvvL+qAjzXyeZ3deZjMYEEslXY/jUPHWH4wshCsEL5lGRBX
         fwqyflMrh6hGmBllpxyS/t97IfebyDw6FGJUP5RF1XEicuwqmECUDGO9FKa31pTrdkzB
         ZXNjUk+i3p2dGN3X9074k6MHS3G/n8u9wEFMzvKpQzE+oG8tQ7hRZP21QxCNmSzk7LsQ
         qM9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680024925;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=12AHmjD6DHnQ1cCgPRQFVhfgHqTAtYo/JRfqhlfkpz4=;
        b=37exq0TphTjcTCn22Gt7y3bOOOccIUxjvTu+pwM27kdfs/iKQA3IR8ZCWhgoXmAxnu
         eT0IOvjLGOFGRf5hHwSGzRK6mcxgH03DBSJvcJmMHKKnBi1WwgOESNcMANGOZFnxcu+p
         4aHjH5BemP4P5B7gEUeSHLDCKSPG5nPwJzSdaReAY3ImWZWEei0BoHrOVv5OxQf3e4hn
         ZJL2ZZfmDvvF7EJ8NxhP4y+Ic4FwWFi7NLE7SoTT5GrzGc0X3L9ol230X7KdzVCIEBIf
         Ox68qyQw48w89pw63ZrMRdoPEzOCpLFD3g4hOv0sIcd+Xf7QGsNE1+eS7LMywkdauecT
         R7aw==
X-Gm-Message-State: AAQBX9doSZDSGn8+/r8ragvW6m3nymuojFTGYw20kPMir/rW1UAUPphb
        40+OJKHDTKu47YsIgIwxKqzVVQ==
X-Google-Smtp-Source: AKy350bzzBwK9ftlYjLbqBw5YCKObdgACkuL+dBd5KEu34TOfiIU6kyxWSAKWo9ggeBDQmlRGuQNTg==
X-Received: by 2002:adf:f44f:0:b0:2cf:e3c7:596e with SMTP id f15-20020adff44f000000b002cfe3c7596emr12674284wrp.35.1680024924931;
        Tue, 28 Mar 2023 10:35:24 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.210.212])
        by smtp.gmail.com with ESMTPSA id a3-20020adffb83000000b002c561805a4csm28087215wrr.45.2023.03.28.10.35.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 10:35:24 -0700 (PDT)
Message-ID: <236f1a9a-d524-104e-14e5-898ad8cf332b@linaro.org>
Date:   Tue, 28 Mar 2023 19:35:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH] KVM: Don't kfree(NULL) on kzalloc() failure in
 kvm_assign_ioeventfd_idx()
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org
References: <20230327175457.735903-1-mhal@rbox.co>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230327175457.735903-1-mhal@rbox.co>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/3/23 19:54, Michal Luczaj wrote:
> On kzalloc() failure, taking the `goto fail` path leads to kfree(NULL).
> Such no-op has no use. Move it out.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>   virt/kvm/eventfd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

