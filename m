Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3547D67CE
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 12:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbjJYKEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 06:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbjJYKET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 06:04:19 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04357DD
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 03:04:17 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-538e8eca9c1so8192340a12.3
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 03:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698228255; x=1698833055; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E07m1KQ+cVLKozsbMNvcTmo++/R0dnqEoi53XpCZ9dw=;
        b=TL41LNcQemxt4QkrUEERtkPo22WLjkqAoBQ/g3EOevrl2d4jVoZz5DCdUURNmEdaEE
         uzUEZ2X3j6Mq3IvIo+dYCAyDOCB+yGQZwF92QAvuFkRuvquciqZUXdjZvYY3qBUTMsJi
         WI87UpBtebY2iVI8f8Zm8ZUwXNmMGhSTfARHf0ftVsOI9aVVxXiSMMeR2RDJ8x3rZhRq
         W59gIFa2DXfDKZByQzC8riSeg9J4kkCNnoaDAXTy46bVkhcpkLK7BzO+EsTlIJNsQ+4I
         bUzAijAioozw9SuZ4LAfqjBHmd6XQAkq4v/YbcJogXZcskSxqrOB/SpOeO68ObLjDw3e
         LLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698228255; x=1698833055;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E07m1KQ+cVLKozsbMNvcTmo++/R0dnqEoi53XpCZ9dw=;
        b=AptpbrQLwYMiJ/vfOUiqvvMllwvZSkTiRUM1V0bYb3Gg2JdiVdNcrmy2//RmJBod40
         sVrIW4Q76ofmmOiQNFWf9ay0YXEV+essy91n0O2lMcpP2taMMzSs+X5AbSYeH+F+oj/o
         E4+TUQsDL2Blfnxp1BfdA1J9QMqF1qWgv1VIltJEaxv+hrT1O+Mg8lv/SS9MarFyfcAj
         cMjQVnijsXkIix0c8eYAJAgvloqbkvUXbR3fk1aVuciurp9vnhUWhBGmgq/e8whpqO4H
         y/zev92lFaRvKeRjp5E28Iao6Nv//6bliym5V7ZsBjx+DJ75Zn1YiC8Dtihh7B1JRwX3
         BxvQ==
X-Gm-Message-State: AOJu0Ywcx6IhVjaInta8RheaX5V/WKDrJtvkmvxmByZDyq1T44yleXN3
        GhEWOLwnbZ1hmGh/HtbxKY/6Pw==
X-Google-Smtp-Source: AGHT+IFu4C4nJoDUS1cCKnTbVEqLEqleij3crCqPhRsgLwmGJyiWZWJpkv2dayHVAyIrh8+vGTvqvA==
X-Received: by 2002:a50:9e24:0:b0:53b:9948:cc1f with SMTP id z33-20020a509e24000000b0053b9948cc1fmr9452686ede.12.1698228255381;
        Wed, 25 Oct 2023 03:04:15 -0700 (PDT)
Received: from [192.168.69.115] (ghy59-h01-176-171-219-76.dsl.sta.abo.bbox.fr. [176.171.219.76])
        by smtp.gmail.com with ESMTPSA id u17-20020a509511000000b0053e163a1ca0sm9497669eda.1.2023.10.25.03.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 03:04:14 -0700 (PDT)
Message-ID: <9a8e0ab9-48cf-777b-92ac-cd515eec0cf9@linaro.org>
Date:   Wed, 25 Oct 2023 12:04:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v5 00/20] Support smp.clusters for x86 in QEMU
Content-Language: en-US
To:     Zhao Liu <zhao1.liu@linux.intel.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>
References: <20231024090323.1859210-1-zhao1.liu@linux.intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20231024090323.1859210-1-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhao,

On 24/10/23 11:03, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Hi list,
> 
> This is the our v5 patch series, rebased on the master branch at the
> commit 384dbdda94c0 ("Merge tag 'migration-20231020-pull-request' of
> https://gitlab.com/juan.quintela/qemu into staging").

Since the 4 first patches are not x86-specific (and are Acked
by Michael), I'll queue them to shorten your series. I'll let
Paolo look at the rest.

Regards,

Phil.
