Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D085AE0D9
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 09:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbiIFHUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 03:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238443AbiIFHUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 03:20:51 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFD84E84E
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 00:20:49 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id bt10so16046046lfb.1
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 00:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=5SiZzQ3jsxp5inXo69JQyki2t9Pq/3JOTXDE+sx+9Mo=;
        b=sPzvD7Hy6bAykcdTBo8dqmF2y4Dzh6E4HA5SmL+5yiUvW3yQzSnd/yPYaJPgMXLGpA
         xQUw1HkSdbqLkoYlUQtEo3pEFFCP539FpvxP6NOVVS2E+o3W4p2ZQes/x4p8iXs6cM+h
         CDUYJ0a1XXkNV0YMko/CYuB2sB5nL9bIABKfqvxM3MILYsPdTs0uLmULyFHeB1BKrc83
         OtMaSfzLFiXJ0SsWRs54CtcUfe8d0URDskOVBIKxvIRvl9zN2rSmaSLiOirmCEWs5y4N
         5tl++9bJf5M7xQ0/nvE2veVNUfUvNH3IS6e5FBW44EGo2gK/bzoBL6K37A2UyKL0L3uQ
         cMTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=5SiZzQ3jsxp5inXo69JQyki2t9Pq/3JOTXDE+sx+9Mo=;
        b=kUMw8dSXL8Yf/mNNIZTK1mhFAmOdAHUygtvTeEZEBFPDPx70cIypceylRndrfZxK6H
         eRLE++hEtBbZxxl2u7jWOuYK6JqJt67K8FvdQLm3H1EVqhiuN3Kum8sJFFSqFrv+Fblr
         kKxTfdKPTLyZIfe5doAdqf7mLXtPA5Ha6Er3oO9sBKzZK/aA5xhTH6I9OJPqhjbi5MwC
         MOBCbovUKAIMtRGVrAsgrkI9ZWNHL8+9Mvm1rMHU1O4cAWFrXnP/lBy92Lsur644hbuZ
         i3zqHA/VkTSYTd+/q3sSlJ1nVgVCA+uy2JxCFPrCMsfI+XzGiSYbjvk0cWyzSdrTFspa
         RPVw==
X-Gm-Message-State: ACgBeo3fucDHqkw2x89uwyst3TCFysZVPf0iZm3jN6zNkL2rnpf4gJCb
        wEl8VKD3y0bDUktVFZej5eWvtQ==
X-Google-Smtp-Source: AA6agR6ii0gwUVUWsZmlqNu0o8/iYY3SOGZORmJ8unVFiOExBClnZ/qQSXqCJsY4kKGElWZLfuTPDw==
X-Received: by 2002:a05:6512:ba2:b0:494:6d93:e9ee with SMTP id b34-20020a0565120ba200b004946d93e9eemr12674578lfv.378.1662448848104;
        Tue, 06 Sep 2022 00:20:48 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id d14-20020a196b0e000000b0048d1101d0d6sm1550002lfa.121.2022.09.06.00.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 00:20:47 -0700 (PDT)
Message-ID: <5b0317d9-16d8-bf86-3f5a-602489c9831c@linaro.org>
Date:   Tue, 6 Sep 2022 09:20:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH v2 1/6] Documentation: DT: Add entry for CDX
 controller
Content-Language: en-US
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-2-nipun.gupta@amd.com>
 <93f080cd-e586-112f-bac8-fa2a7f69efb3@linaro.org>
 <DM6PR12MB308211F26296F3B816F3F005E87F9@DM6PR12MB3082.namprd12.prod.outlook.com>
 <8712e2ff-80e1-02e9-974a-c9ffcf83ffab@linaro.org>
 <DM6PR12MB3082867B1BDCBBC9C25F560EE87E9@DM6PR12MB3082.namprd12.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <DM6PR12MB3082867B1BDCBBC9C25F560EE87E9@DM6PR12MB3082.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/09/2022 09:03, Gupta, Nipun wrote:
>> On 05/09/2022 16:05, Gupta, Nipun wrote:
>>>>> +
>>>>> +    cdxbus: cdxbus@@4000000 {
>>>>
>>>> Node names should be generic, so "cdx"
>>>
>>> Would be using bus: cdxbus@4000000.
>>> Kindly correct me if this does not seem to be correct.
>>
>> I don't understand it. I asked to change cdxbus to cdx, but you said you
>> will be using "bus" and "cdxbus"? So what exactly are you going to use?
>> And how does it match generic node name recommendation?
> 
> I was also confused with the name suggestion as in one of the mail you
> sent out later, you mentioned:
> " Eh, too fast typing, obviously the other part of the name... node names
> should be generic, so just "bus"."
> 
> That is why needed to confirm. To me now "cdx: cdx@4000000" makes sense.
> Hope this seems correct?

If cdx is a name of some standard bus or interface (just like i2c, pci,
can), then feel free to use "cdx". If on the other hand it is just name
of your devices (specific to Xilinx), then more appropriate feels "bus",
because cdx would be specific. Anyway one of these two.

Best regards,
Krzysztof
