Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383C362EE7C
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 08:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241138AbiKRHfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 02:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiKRHfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 02:35:20 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E230487A4D
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 23:35:18 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id a14so7972120wru.5
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 23:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9x3aw57bHpLrIFGYlxPif4AzwsedVQK1l7WqxqYWzf0=;
        b=c3Xh0yhfutBq8FhwHo52bvKs4vLtLVegFeCcVLkQcE2VedRn3USvn6Y021aZi50g4Q
         nfLU/8i2ljYyB17Vd99ymZkwkvYcXKL3/5BZ6btUV12TjwyF7jUQptlhXM1u2q0QUT4g
         HA4SeCzCgae199TOIkMR5IeBIqb0aapr+3IofbU5hubI8gKkgsGzem0QZ/8kyOQ8Urca
         rBDmP1YzR5mKn/yb+Yf2HX2t1WsG9K16UVnyRrUuOtgtfBS2C7tr+ba0Lk9CEAxURhiR
         rB2dy6tzMam8pCXNT6oaLhooupnccvhwCEEpHJ9ZulglFyLpQUiczEpvf9ekMmBTpuub
         Pwsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9x3aw57bHpLrIFGYlxPif4AzwsedVQK1l7WqxqYWzf0=;
        b=hMJnNZCVs/vPIEAUXncGk/iUOkWoT70BXXEtnC1PtU6r49m+6yPhlqpRbmP6nHuDTE
         ClLr5RWna64DzIGOrUWAsY0rUcGVAf/bucFevx+O6vfZKqeyqcvWOQn6eBVThgVIpuCd
         GRg2saS7rXw51VIVMLdjvOJmZd+kmp/uU6SiGmBSEwaCOHmTrpIqZbnNwoF406oCiVfY
         M2/oK5+ECVnCio6PDFN2UM63rf4BQhobKwbtQgJBhlLE5/DhuBaXZOvblm1MMdfhl/md
         RQHYJqgnLvdlrVZqGejENipRBpK84vtWS7WCj8/Xuyn7eF5vcSLy+ir1RvxXEwRrdDR9
         M74Q==
X-Gm-Message-State: ANoB5plm71B61dEGTez5klhx+4sFga0kUfz0FwOfv7+n2wiwgX0xah+y
        vomXM3CYxsMqTnvday5zShcgCA==
X-Google-Smtp-Source: AA0mqf5BN/I4sgAkWdBkFzHzJodRSF2Z6F6KZRc3XDvC/o+A90sAabzAD/nVw0c7KZSZfldGJkdVeA==
X-Received: by 2002:adf:efd2:0:b0:236:e5a2:4f66 with SMTP id i18-20020adfefd2000000b00236e5a24f66mr3684011wrp.357.1668756917503;
        Thu, 17 Nov 2022 23:35:17 -0800 (PST)
Received: from [192.168.230.175] (34.red-88-29-175.dynamicip.rima-tde.net. [88.29.175.34])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb12000000b002365730eae8sm2803212wrr.55.2022.11.17.23.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 23:35:16 -0800 (PST)
Message-ID: <6febdfbb-1d13-bbfc-1dc5-4f8fa788fc48@linaro.org>
Date:   Fri, 18 Nov 2022 08:35:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v3 1/3] accel: introduce accelerator blocker API
Content-Language: en-US
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org
References: <20221111154758.1372674-1-eesposit@redhat.com>
 <20221111154758.1372674-2-eesposit@redhat.com>
 <e8e6fce8-9912-7684-d4c3-c30d731bfcd7@linaro.org>
In-Reply-To: <e8e6fce8-9912-7684-d4c3-c30d731bfcd7@linaro.org>
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

On 18/11/22 08:32, Philippe Mathieu-Daudé wrote:
> On 11/11/22 16:47, Emanuele Giuseppe Esposito wrote:
>> This API allows the accelerators to prevent vcpus from issuing
>> new ioctls while execting a critical section marked with the

Typo "executing".

>> accel_ioctl_inhibit_begin/end functions.
>>
>> Note that all functions submitting ioctls must mark where the
>> ioctl is being called with accel_{cpu_}ioctl_begin/end().
>>
>> This API requires the caller to always hold the BQL.
>> API documentation is in sysemu/accel-blocker.h
>>
>> Internally, it uses a QemuLockCnt together with a per-CPU QemuLockCnt
>> (to minimize cache line bouncing) to keep avoid that new ioctls
>> run when the critical section starts, and a QemuEvent to wait
>> that all running ioctls finish.
>>
>> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
>> ---
>>   accel/accel-blocker.c          | 154 +++++++++++++++++++++++++++++++++
>>   accel/meson.build              |   2 +-
>>   hw/core/cpu-common.c           |   2 +
>>   include/hw/core/cpu.h          |   3 +
>>   include/sysemu/accel-blocker.h |  56 ++++++++++++
>>   5 files changed, 216 insertions(+), 1 deletion(-)
>>   create mode 100644 accel/accel-blocker.c
>>   create mode 100644 include/sysemu/accel-blocker.h
> 
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> 

