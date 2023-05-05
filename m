Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62496F8555
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjEEPOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjEEPON (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:14:13 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795F01BCA
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 08:14:12 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-306f9df5269so1316716f8f.3
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 08:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683299651; x=1685891651;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N3NPH94Yx/QPAffV0bad+mAebajq5nDGGYextPZCJzI=;
        b=PFxgc7wS3mou3oxYaYSGVDmBfkufWROuoQNrXG+QvM2cXI7j/whlwVbYqtLYavSBIp
         6DnC0aLKBBu8/wIcU2I09EFBiz5/wnFWjyJLK7CiT3TYulwRAJuP26BoqKozYl0+k6JH
         ZLHLWNjMLuOzvxVhnHoN3DajX5mndn4nhJyULRKkESUfP8Qo/+57APb+flrC3H/C34t9
         BPtMOQHRROaaJ9qqj04aYjzBNjgLF5uhBeG+2UjZl6XU4JAezWRduqmrCmwqt/5yebVJ
         a9H+alvwgBu2iYP61f3onYbrkrXqDc+XwMnaDC/icxcuU00qt/HcJicJAbNpoXK3wkPN
         ypmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683299651; x=1685891651;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N3NPH94Yx/QPAffV0bad+mAebajq5nDGGYextPZCJzI=;
        b=VtcKYFLMY7EMtbdFF8NkBSYxSw5QjmIvmLO5SLEmez9pdOfJVTOgItkt72sj/l4x9/
         CGYuN29Hm4YXAKu4O9VZTPSlgeYIsMjTlWwNoDIqQiFtSw3Ty85T5NSWfWO514//AXL6
         I/tyJFXmv4V7UbMSXsH25efk4c5vgC1Nh9VaWdPYXMMiX7aZLbC5XT97sfAGQEQUdfu0
         myphguiaTzt7ol0NBIiJE5S46X5wKZ9RYFocg/Vsd2Ovr4yuBwIN19wj2KhxOU7yAo6h
         Tsr2rwdNVP4K11NBOhCMXU/EXzmivKod6SaBCjcoFVvkauqKbcDzex4FcaFeDV1XB6en
         Z3YQ==
X-Gm-Message-State: AC+VfDzNS+OXm4IOaJwdldqD+7wcqvSg5I0H9HjdAb3rCw3JJPwBFyGG
        1buUNoO8rXcmZArHraDwoa04ZQ==
X-Google-Smtp-Source: ACHHUZ4YGH1z0rJ5fkXsOhmOw4x5Iw8YJXBi/jPB3DyHWHSgwqO3EAsGAhjgUrFM17WwJIoXcnTBkw==
X-Received: by 2002:a1c:721a:0:b0:3f1:7277:eaa with SMTP id n26-20020a1c721a000000b003f172770eaamr1381890wmc.31.1683299650978;
        Fri, 05 May 2023 08:14:10 -0700 (PDT)
Received: from [192.168.20.44] ([212.241.182.8])
        by smtp.gmail.com with ESMTPSA id e12-20020adfe7cc000000b002c54c9bd71fsm2645318wrn.93.2023.05.05.08.14.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 May 2023 08:14:10 -0700 (PDT)
Message-ID: <c46fdc5b-8145-c87f-5976-d5c7dae79695@linaro.org>
Date:   Fri, 5 May 2023 16:14:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 1/1] arm/kvm: add support for MTE
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>, quintela@redhat.com
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>, Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Andrea Bolognani <abologna@redhat.com>
References: <20230428095533.21747-1-cohuck@redhat.com>
 <20230428095533.21747-2-cohuck@redhat.com> <87sfcj99rn.fsf@secure.mitica>
 <64915da6-4276-1603-1454-9350a44561d8@linaro.org> <871qjzcdgi.fsf@redhat.com>
 <2c70f6a6-9e13-3412-8e65-43675fda4d95@linaro.org> <87sfcc16ot.fsf@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <87sfcc16ot.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/4/23 16:01, Cornelia Huck wrote:
> I'm wondering whether we should block migration with MTE enabled in
> general... OTOH, people probably don't commonly try to migrate with tcg,
> unless they are testing something?

Yes, savevm/loadvm is an extremely useful tcg debugging tool.


r~
