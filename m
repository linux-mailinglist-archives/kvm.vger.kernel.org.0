Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5828F6797D4
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbjAXMYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbjAXMYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:24:03 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6B831E29
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:23:32 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id o17-20020a05600c511100b003db021ef437so10791495wms.4
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4YZP82TWB0gYIxyBfJd2bBTQ6gSPENAGra9+u7bu37U=;
        b=hC5hRhX8erR061tcBrG1cDH4KtgxTcpsiX6g7nlXUUDjVW3Z9IbjK835upAxAt7cAx
         nqmcY4yVYVEFowDQBV47yWLYHu3AiQ/48f9/G0/SzsSpwy5JYOzFkhq3NduxhEUTG69m
         YF/eTeUCZ2RAR1P4kjtctg2f75TOtbUCD2o/10TilcWQcbQtgrirt+SO0bKUn0QfrWqb
         2WGLQ1Bgf9Vll1jVbDJFeGT7bt7xHnu7G3opxstwXndBifa7OmCTYcjCWd5U2V0lyG8l
         OOH4csCFT9eutSg96JXHD8AbSC1xi9v7T+bqB29n5pWU06UWB7FBDpiA0Rl98JU3kBOV
         3giQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4YZP82TWB0gYIxyBfJd2bBTQ6gSPENAGra9+u7bu37U=;
        b=w0bTJayt7LScd0hSsJD+xcDrxLV7k7ux6ny9W861+gTBKeia71ZdNguPxN/hmbcoZY
         ecn6WG2iT8ZagFrJMo9xkMzl6xYwPqL5RNYn+8zP2AVWwBqcQkBpoBenPkKwQ54g4lts
         Mdau89+pUGbCcvQ5kScPB1lyW29qZA1iO4KoNl+7eEf8fGjUbRk4CBmwQ7m/fWFg5Zo2
         SZXyin23IaU5Oq3vGgEmz9NBUjvH1LYhAPEiYx7nckp854om8DZi8VXZK/vgdi0TQOZ1
         DukLUsrkWZ2eSUNuilxLLbt98e7D9PG9unqRWqpLiX6mc4od6WEqAUyrTMm+hGFyqUVs
         o60w==
X-Gm-Message-State: AFqh2kriWSfoRg4zEDKnmPMXSG0I4BX5ssqoahy2E/yZbeRsqi+9M8kD
        8V4NxzOQs2KuaU7ae8qZ5SUOrQ==
X-Google-Smtp-Source: AMrXdXtovW+GswSFT4Rar63QFnPkeqU04/X9iNgBQZdfqRFNIjzs0GNw01+oadFzXmo9l4WKHs6d7A==
X-Received: by 2002:a05:600c:510d:b0:3da:f719:50cd with SMTP id o13-20020a05600c510d00b003daf71950cdmr26422629wms.18.1674562983054;
        Tue, 24 Jan 2023 04:23:03 -0800 (PST)
Received: from [192.168.37.175] (173.red-88-29-178.dynamicip.rima-tde.net. [88.29.178.173])
        by smtp.gmail.com with ESMTPSA id o24-20020a05600c511800b003d9de0c39fasm18022546wms.36.2023.01.24.04.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 04:23:02 -0800 (PST)
Message-ID: <0e588044-b051-d80f-b5ad-811a3f677ba0@linaro.org>
Date:   Tue, 24 Jan 2023 13:23:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 11/32] qom: Move HMP commands from monitor/ to qom/
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, kraxel@redhat.com, kwolf@redhat.com,
        hreitz@redhat.com, marcandre.lureau@redhat.com,
        dgilbert@redhat.com, mst@redhat.com, imammedo@redhat.com,
        ani@anisinha.ca, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, jasowang@redhat.com, jiri@resnulli.us,
        berrange@redhat.com, thuth@redhat.com, quintela@redhat.com,
        stefanb@linux.vnet.ibm.com, stefanha@redhat.com,
        kvm@vger.kernel.org, qemu-block@nongnu.org
References: <20230124121946.1139465-1-armbru@redhat.com>
 <20230124121946.1139465-12-armbru@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230124121946.1139465-12-armbru@redhat.com>
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

On 24/1/23 13:19, Markus Armbruster wrote:
> This moves these commands from MAINTAINERS sections "Human
> Monitor (HMP)" and "QMP" to "QOM".
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   monitor/hmp-cmds.c | 19 -------------
>   monitor/misc.c     | 49 ---------------------------------
>   qom/qom-hmp-cmds.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 67 insertions(+), 68 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

