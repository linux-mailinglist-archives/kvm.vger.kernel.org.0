Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED916618DC7
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 02:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiKDBse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 21:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKDBsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 21:48:30 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5520B64FA;
        Thu,  3 Nov 2022 18:48:29 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d24so3605675pls.4;
        Thu, 03 Nov 2022 18:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kI2bio8wmQ0tUqhuEplLTLsBHSGHlrsvdLcA5KYXd1o=;
        b=okJIUsjhGpoSr7ebbtfgAqH0GYDYyL7dOwFsAvIpPQxaUkfj0UP2ubzMSszKzLoSJN
         v6PakLQ+XxWm79MGsDUXql9IQEZxdMTWbKG81FTHJSY9kzQGK+YsR1OvwDbkE09D1VlJ
         4dw4AZi5O9K8lqfRcZFGFnYrPVqUMUcNoMABhjUk0b4JfdXLO0pshLnVS/0Z74PotUp/
         mlKcoIwavTTTQ18DLNZ1g2AW+XuW2afaA+rYfxRqMHWRPYZsUyIvJriVnnZSrEQKK6le
         XI6Un19ShxQI7Ey405lypQalZbGVguAIjN21YMsahXg364hurzORypaF2/fKRwCkV3D2
         vW7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kI2bio8wmQ0tUqhuEplLTLsBHSGHlrsvdLcA5KYXd1o=;
        b=MiSI2kqH/1/OgZsrpZSQFBwlwG1nQRptRW6y+na6yGUeqvwj0WqOwX8oodnJXmEOOn
         /2wcntJde8fboD2Z/RsJcn7jMXLOXEq9V4e5TJFUyK5zqZztDmRF7UNGy2H0fhW1EcwY
         +jNv4OrUCR8HN1qJSADdm/ZegDbLJZeujMNIk8fj2/6asl2n2lHZD9zwJw20k618H5F6
         23uco0JKdtqHeoFCIjMiP63qFW0iXG0pRHAecGs+91MqjAzdxrD/r3aYaYnUvsmyXDiU
         u7odNtPAQwy+MzfmKIgGPJ3grTjdaB/0QV75hMwtRvS7Kq8di3iZtan1XdixB8f0fsNm
         GvoA==
X-Gm-Message-State: ACrzQf1CA5UqTfW72bnmHLQe09VUbG58wG+2ritSETKe9KnDwTMTf7Oq
        pEfWc4iewYtipWKZA2xMUCo=
X-Google-Smtp-Source: AMsMyM5IldMoiS3xXBLh2Vh0OIVV2RvQ8KbcaI/UFxFMESQqDNIp1EYyZ1RDviZLejrZpnABGqs7Zg==
X-Received: by 2002:a17:902:f686:b0:187:16a0:fd2b with SMTP id l6-20020a170902f68600b0018716a0fd2bmr27368685plg.91.1667526508865;
        Thu, 03 Nov 2022 18:48:28 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-15.three.co.id. [180.214.232.15])
        by smtp.gmail.com with ESMTPSA id m5-20020a17090b068500b002132f3e71c6sm592915pjz.52.2022.11.03.18.48.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 18:48:28 -0700 (PDT)
Message-ID: <4b2b78c6-9903-1247-9d16-fc6270aa34fc@gmail.com>
Date:   Fri, 4 Nov 2022 08:48:21 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] kvm/arm: Fix pvtime documentation
To:     Marc Zyngier <maz@kernel.org>
Cc:     Usama Arif <usama.arif@bytedance.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        steven.price@arm.com, mark.rutland@arm.com,
        fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com
References: <20221103131210.3603385-1-usama.arif@bytedance.com>
 <24d81fe9-7cd1-71eb-8c35-0739f638b3df@gmail.com>
 <86fsf0qc1w.wl-maz@kernel.org>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <86fsf0qc1w.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 22:42, Marc Zyngier wrote:
> No, this is the correct course of action. There isn't any point in
> having an *unrelated* change in a separate series. This is a
> standalone change, posted as a standalone patch.
> 
>> Please reroll your series [2] with suggestion applied.
> 
> Or not.
> 

You mean the series before this patch have already been applied,
right?

-- 
An old man doll... just what I always wanted! - Clara

