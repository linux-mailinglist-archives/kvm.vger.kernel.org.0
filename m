Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A06A6E5C14
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 10:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjDRIcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 04:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjDRIcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 04:32:24 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9747ABA
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:31:55 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2a8c28158e2so13400051fa.0
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681806711; x=1684398711;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=osj8/GPz/P9GU1ONg/ztykGOl9NLJe8v5vmhnnZb1nk=;
        b=oTmaI/mQYXoAlp3y7f/sWO/7SWWAzv9Wz/F03Qmqt4TWZOT9Le2PJcDZmhXpjgN9yE
         zfTbPkZOR5gySiBELs/mzoGhuGC2IVcnKMs1vi7qEiWTKAykXH1e05vbqAB8ZvifqUsg
         Ue6NasczaNDhVfSQsMjCw9y3gB6QmwgY1+dOZdyYHYcFANQJIyf/pd4JkJzR1jCuqaKf
         EVlOzU/ZFXtcTVJi3h2v3zdiNTD04Fy01D1dHAQZ/FhEGUzRUVYDs3qQUnSk7lkUbA2L
         MU9xW7In4IFcnvxI87uMg/OsaDdfB+6BJjGmYDe8GJ98qSuY3WVvNrx0GYB5SSCxOHyt
         NySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681806711; x=1684398711;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=osj8/GPz/P9GU1ONg/ztykGOl9NLJe8v5vmhnnZb1nk=;
        b=FwY3AHUaAbqZ//+ZRrxzeTyHNnL3CCx6mkhCrZK6Ry57GuCwAJsXNpHQ3C5S3HiDlI
         WToQmQBC3R7FoZIkD6/81Ngqfti9VXuMpDUExoS9DVtCYEzNOEcZczxIPiyROixiOYFH
         MhMOtxWAUllO7ZiAdxft3SbkFrJ4sWlva0bky+nLlrsJT544SK8/fXABATyo7UGTigMU
         NL4RW/lzed4pWzOMhXLl7ZYtgnDYvbQZMzKUTrafdCwityDB+NTNs6wFp8dQnPe+QEqg
         7WVt+wzcdZGP5IoIlfriybvZwYRGQlc2Jmz+aXT9iyz6NJX1VwwNHg2TYSVAN0eQsgnX
         uAPw==
X-Gm-Message-State: AAQBX9cBO16HNHmLFsAW0KPBgBSOkKul6zmzg/uQCKvh2QlaB3DPZ8tN
        R1g33NQXgYc+z5unpL54RrFRhQ==
X-Google-Smtp-Source: AKy350bMzuY/up46E82EOf26CcpHsmw5xMPslGXecWSv6Ds2+dxK10LIDkAVAZmgOgLbSohMtROYfA==
X-Received: by 2002:ac2:4908:0:b0:4eb:e7f:945 with SMTP id n8-20020ac24908000000b004eb0e7f0945mr2367311lfi.41.1681806711278;
        Tue, 18 Apr 2023 01:31:51 -0700 (PDT)
Received: from [192.168.58.227] ([91.209.212.60])
        by smtp.gmail.com with ESMTPSA id q9-20020ac25109000000b004edb8fac1cesm1498986lfb.215.2023.04.18.01.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 01:31:50 -0700 (PDT)
Message-ID: <c9e06460-19ad-812c-cce0-b2a7a20e423c@linaro.org>
Date:   Tue, 18 Apr 2023 10:31:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 14/17] crypto: Create sm4_subword
Content-Language: en-US
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, Max Chou <max.chou@sifive.com>
References: <20230417135821.609964-1-lawrence.hunter@codethink.co.uk>
 <20230417135821.609964-15-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230417135821.609964-15-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/17/23 15:58, Lawrence Hunter wrote:
> From: Max Chou<max.chou@sifive.com>
> 
>      - Share sm4_subword between different targets.
> 
> Signed-off-by: Max Chou<max.chou@sifive.com>
> Reviewed-by: Frank Chang<frank.chang@sifive.com>
> ---
>   include/crypto/sm4.h           |  8 ++++++++
>   target/arm/tcg/crypto_helper.c | 10 ++--------
>   2 files changed, 10 insertions(+), 8 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
