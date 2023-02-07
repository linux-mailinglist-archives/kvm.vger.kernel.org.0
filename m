Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9541068DA93
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 15:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjBGOYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 09:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjBGOYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 09:24:07 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5927A15C86
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 06:24:05 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d14so13708480wrr.9
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 06:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hax/XOz6L1HwvWdYp3TmUzlLwg3i5L7wNEbwhLs97i0=;
        b=xU9L/CufPrpEJQeoIEKk0f/LfRTnrb7OAI6AXlB3jyvC+uC1U3x31QS3OfRr5nkWkW
         VyRXFPW0dfSN2KIW2Eng6wRZRJInd8eWf/rK4zzBYbCAonM0jUN9IdvySGw33IQbgGX9
         0PCiGswnmieURiPujlf2PGkNKFKC2PqdbAnKl33rPLeOlK7d2zyKZrf2pk2sPMl6EHew
         EcPqa41rs8uo2Ml8HHrA5kkvIpG+BUosxGZReonv2ZdWg5jpGYqkQ/ccdraJhFU62eFP
         EULN9atVYJFenlNUxboxpvGsOzpZNPhk3dC0notwCPNKUREOhvsEBd8UuDrOvLUE25PF
         aw2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hax/XOz6L1HwvWdYp3TmUzlLwg3i5L7wNEbwhLs97i0=;
        b=qQkeEyc9rSexmOat1529huAsEBXszq+URpjfyn9HUuGRomdJXWXwHDKwnQAyhITXxN
         54/p5yE4hiQv6uYC4eaMkhNjTP6yuh/jWH4RtM1GS8h2jPCD/kO3MxGOSLSW6taEfjI0
         zj48jL1xoyC+g0IkiVl4PLBJkwBO18IBV53uOTu3WJgzIPLH/XZhlWoyRwF8mbsVKYLP
         uKhDUXwjuZAGzSOIBFtFRcmvXjrrNX0bQSrN5rX9jch5rHvdnNj4vska6vJnc65UmSxA
         hwPSvQLF02HcFpvw00sVH98z0xCKkMJPWm7dhhI+xzXkeW2zNwnKZS6DqVx0uqL3CIjD
         E82Q==
X-Gm-Message-State: AO0yUKVLHr80+naVeQgm9K/MW/HtIWR3eUbjlwV3aYZHPPju6jZosLlt
        ecdB72sJZ0GuKmrybhZY9tToqQ+UXmcE4JIX
X-Google-Smtp-Source: AK7set80AjZcNd2rjhy7uAaSO0ToODxDqACZphTSdCMAQyP7LWCQTgU7JuXFttMtB11ILszB/K+yeA==
X-Received: by 2002:adf:ea03:0:b0:2c3:ee27:457a with SMTP id q3-20020adfea03000000b002c3ee27457amr2929067wrm.33.1675779844002;
        Tue, 07 Feb 2023 06:24:04 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id j5-20020a5d5645000000b002c3efee2f4bsm3224188wrw.80.2023.02.07.06.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 06:24:02 -0800 (PST)
Message-ID: <5e82a829-0348-e73f-4351-21caa396e402@linaro.org>
Date:   Tue, 7 Feb 2023 15:24:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2] gdbstub: move update guest debug to accel ops
Content-Language: en-US
To:     Mads Ynddal <mads@ynddal.dk>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Mads Ynddal <m.ynddal@samsung.com>
References: <20230207131721.49233-1-mads@ynddal.dk>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230207131721.49233-1-mads@ynddal.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/2/23 14:17, Mads Ynddal wrote:
> From: Mads Ynddal <m.ynddal@samsung.com>
> 
> Continuing the refactor of a48e7d9e52 (gdbstub: move guest debug support
> check to ops) by removing hardcoded kvm_enabled() from generic cpu.c
> code, and replace it with a property of AccelOpsClass.
> 
> Signed-off-by: Mads Ynddal <m.ynddal@samsung.com>
> ---
>   accel/kvm/kvm-accel-ops.c  |  5 +++++
>   cpu.c                      | 11 ++++++++---
>   include/sysemu/accel-ops.h |  1 +
>   3 files changed, 14 insertions(+), 3 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

