Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A3676B6C7
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 16:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbjHAOGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 10:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232681AbjHAOGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 10:06:31 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141F72D52
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 07:06:10 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-317b31203c7so133557f8f.2
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 07:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690898764; x=1691503564;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=efUA6vslzW4BixuLDSNjlPOcP3SvRE+kgN7KrACt+/k=;
        b=Axh34Hd/ohWuSKLzSZ1DNgK7hw4l/xfgeoOAID24sUK030wvGmN9H9J7/Z2rw/17In
         i10FKLuFxffcYsit55naOfLh0APWD04lZewGSrIbSDIU6B0cIVrq6F1UnC5pHXgHEetB
         Nxt8e6pOkhUgMll2R0kG3JouACq1O3YIHvkckNXFiNkP4bT71CKzxohVdHnHFZaLJeyn
         MS619/RR7jIkobHBo2SX9PvkW1lpAI0GIEU3N5XMBYvcEnWpq9qV8D7dT1pkH5HkH3vT
         CpNb8p0c7jO9ERkX3kOYpr7b2d96POY9q1jpLEDPSesugOQz4QvSiOVFcEPU7KqtDats
         dDCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690898764; x=1691503564;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=efUA6vslzW4BixuLDSNjlPOcP3SvRE+kgN7KrACt+/k=;
        b=K4YLHPsotpI24ujSP6p0UUGKAFPEOO8nOJ0RzE59MvmC8OEa/TqnBsr4UhOTDKguty
         HloWKC1LKnYRTt7FufA9uUVTAqkJEXT+D3HQcriTncl5W8sWhNdHrHAgnN+J6YRGeLs/
         i5uFq5mLPfrJaszsZhL8vvbgl0iX+YMq2T3EbiIh2GNXm7aRGWvkea+NggvgCtT7IsYL
         HZ0HDv46quwWJJgDnjBtGs7PrH+LjVROCstfZSdot+mhMOjAyy61uJhpGwdEq/SE0m0c
         H1hfXi+JHsajq8gGdzu2bvmvBKwNgs8kmu3zYyfc6ipy9kb+9adMQEP5ovfi2y1HrTbH
         W5Zw==
X-Gm-Message-State: ABy/qLYRbsoY5s3xOdpeLd0E4rX6DfATznvTCzwQLhsfdwK5o75h4hg9
        NnWlgSg5hiS+txhJHdBMdb4gzA==
X-Google-Smtp-Source: APBJJlHaOenCMDdiREO8Rrd1x+K6N4CaLlmGLlgqD+cFlglH97b7LJK/zl2oyXmX4o0L8Nezv4eT0Q==
X-Received: by 2002:a5d:62cf:0:b0:313:f4e2:901d with SMTP id o15-20020a5d62cf000000b00313f4e2901dmr2276127wrv.22.1690898764065;
        Tue, 01 Aug 2023 07:06:04 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.174.59])
        by smtp.gmail.com with ESMTPSA id w10-20020a5d4b4a000000b003143ba62cf4sm15998878wrs.86.2023.08.01.07.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 07:06:03 -0700 (PDT)
Message-ID: <f4bc87d4-afe3-75ae-26b8-eb9ce732c850@linaro.org>
Date:   Tue, 1 Aug 2023 16:06:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v3 04/12] KVM: x86/mmu: Avoid pointer arithmetic when
 iterating over SPTEs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20230729004722.1056172-1-seanjc@google.com>
 <20230729004722.1056172-5-seanjc@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230729004722.1056172-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/7/23 02:47, Sean Christopherson wrote:
> Replace the pointer arithmetic used to iterate over SPTEs in
> is_empty_shadow_page() with more standard interger-based iteration.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

