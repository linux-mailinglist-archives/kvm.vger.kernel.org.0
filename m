Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6C45B1A7B
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 12:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiIHKva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 06:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiIHKv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 06:51:28 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654B2F5C48
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 03:51:27 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id c10so9914133ljj.2
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 03:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Ps3lqStzHySPsxXJuGxo0vZdDPyhFg6keE7WeVb52JA=;
        b=o/ruHuZsbRb3J4aRBZSNXOgC0gbQJiJQr5k8dC92i0jMhf4DWYiRJfo+94HIhCkSv3
         /HokU7euLiM46BwzGLn18PdHnMEmhjQ22T2l9e2PEYMIp/Dzv3ee4+Z8khE0tVYKjjC5
         RRyvFN0+9G5E+N0fKvZ0CbSsELx+4GZqMSNdA3KOvpN0NdTMazePQa8e4JY+draSONWD
         NKONpCiI8VbPQ4ftetNBDNKgF4G2obYeIhDAKZZ1kPWF5KxflbrX+wfDLp5PJsdicUJz
         tG3xAxGZn5FUM+Fevz9VzBu7oLiD4/7J7FrK0i0tlOKmsMbEnOo5L5LJpu/5RCBbrrWk
         raHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ps3lqStzHySPsxXJuGxo0vZdDPyhFg6keE7WeVb52JA=;
        b=6rglXwRYrAU9KSLzGxmgI5FNTpZmaXHyOOsxB1khvXwarjWvkx+6OfiIIkj48OyyKh
         AaZPcu11vPo+PUbaK4h+NgfTauImfJHsxNCsDMB1MAEqEJB4KCe50OHLiVRRiTdYtQAY
         uklfukt6LUaChBslEmjs9kWynQqstWmpqj/w30D/vQ6dwVD8TDWJJIfv/glgpxF1Di/K
         mR1V2M/+DxsYBZnMmvIFAM7xLW2gwUt/g1Ubix1jdYZm5Hs/PW0JjMyFf1PhbMqf1lcH
         Kb70PhlTCEipO1SAY2OojQYkmLSONvTDLhKIhvgzuevLvWN7Jqq10tPNaKRa1JokjmZj
         Vn9g==
X-Gm-Message-State: ACgBeo0ilqp16XnG2HP/SuxxM03TkOb/8Lc5x1sPPFUIdi7jClY2ixi9
        W4N+T2sb2StwATTD5KFb3LFIMw==
X-Google-Smtp-Source: AA6agR7L+QQqZcc4iA8yVL5wfSIRSeMTKBKrT1SGqVSWUuzNvpwI8LZVG/KWcNq8Zx8VBagz06spwA==
X-Received: by 2002:a2e:bc21:0:b0:25e:c921:f7d7 with SMTP id b33-20020a2ebc21000000b0025ec921f7d7mr2224729ljf.91.1662634285764;
        Thu, 08 Sep 2022 03:51:25 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id x19-20020a056512079300b00492d270db5esm2986308lfr.242.2022.09.08.03.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 03:51:25 -0700 (PDT)
Message-ID: <4b648759-1e0d-db2c-5fc6-bf586bff775e@linaro.org>
Date:   Thu, 8 Sep 2022 12:51:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH v3 1/7] dt-bindings: bus: add CDX bus device tree
 bindings
Content-Language: en-US
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>, Rob Herring <robh@kernel.org>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "mani@kernel.org" <mani@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-2-nipun.gupta@amd.com>
 <1662486402.681939.780022.nullmailer@robh.at.kernel.org>
 <DM6PR12MB3082B9C670B5F58215259A76E8419@DM6PR12MB3082.namprd12.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <DM6PR12MB3082B9C670B5F58215259A76E8419@DM6PR12MB3082.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/09/2022 05:13, Gupta, Nipun wrote:
>>
>> If you already ran 'make dt_binding_check' and didn't see the above
>> error(s), then make sure 'yamllint' is installed and dt-schema is up to
>> date:
>>
>> pip3 install dtschema --upgrade
>>
>> Please check and re-submit.
> 
> I did run make dt_binding_check, but did not see the issue.
> Will update the dtschema and fix this.

Regardless whether you saw it or not, the example DTS is incorrect...
Even if there are no errors, please do not add incorrect DTS.

Best regards,
Krzysztof
