Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E9D5EE240
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 18:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiI1QuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 12:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiI1Qt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 12:49:58 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB6F5F12E
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:49:56 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l9-20020a17090a4d4900b00205e295400eso2194121pjh.4
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=1IKxUFSNGwoHqldMuM/VV8u5bnK1GBzBpKzhno/gxDc=;
        b=VwkX2QDF2fcPkBjR8c7JzIsSE3xgGMWLyWrV2sthj9RF9UJ7JwDlTt9Ji39uZABrOh
         cO3icN5brfa8WxRMitTmeYWlV1cM3EEfjXnXtweF6bBiOIMUZcLfKl3Cb5DPFzE9NhrT
         XUg5S5JMhQzIzeQ43sHc8sftCZgL4aJST8LTclpwOj8tua2YrsBO8gTAmQj7diy2GLd+
         tP4zwwGGVQYpKsuyzlJycn/w/cima+Wyi9VcmR/lxiKIr2HukZ/K04RFvvFJUvGqBCqD
         HEQQiiEm97IGTxbdhsuob7QtDrcxgHs3urEzMjJtiEXGbSxY6k67qkaPdxzv93uQUbDS
         wkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=1IKxUFSNGwoHqldMuM/VV8u5bnK1GBzBpKzhno/gxDc=;
        b=P9t2fiDYnIYc41B0vxHJhJ1UHu94vX69rDSuo9as3pSRu+Eyz13OF0fpk9JO/VAapl
         y2CG4C5EORy5H8oQprYdLR4F7t1Hq9LFIoVbCxbcnOGH4itEew7PCQglbm3txEZwapeX
         hawgjBWRHJnN002kxrOJCWdIvsjcUSKOuZKf+sAxtAlfEGWoOScGhlrgS/dzB3QkI3gV
         ouGH393DyPCywGFWip4iXheQLzTsA8/FEsZ4KenM9x4BmdoDz5i1it/y2OXIipH9cVdT
         Qe85y/wtTGsu0aN1ctjSA6qOW/iEgybIKdujzunT8YhNN5P/0Fuqd7fB0JuzldCHBfCX
         thng==
X-Gm-Message-State: ACrzQf3Z+JAcBrDPCF/ehthwRwt+eIJBExdiCZ+qRUrnkcUaBDzLosi4
        /TXNpW0/VllwK5uc20fX6b2EkedGVcTBPw==
X-Google-Smtp-Source: AMsMyM5YtuxXU5wQl7XxYYlu3Og1sw6rGDOx5wOUbC10CN/TflfwVT8jKwT5rQDamh4FdtRlgG4Bng==
X-Received: by 2002:a17:903:247:b0:179:b5e1:54b7 with SMTP id j7-20020a170903024700b00179b5e154b7mr728324plh.84.1664383796387;
        Wed, 28 Sep 2022 09:49:56 -0700 (PDT)
Received: from ?IPV6:2602:47:d49d:ec01:986f:cb56:6709:4057? ([2602:47:d49d:ec01:986f:cb56:6709:4057])
        by smtp.gmail.com with ESMTPSA id m1-20020a17090a34c100b00205f4db8120sm1618576pjf.4.2022.09.28.09.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 09:49:55 -0700 (PDT)
Message-ID: <eb65b452-828b-0875-586a-e7ea5595092c@linaro.org>
Date:   Wed, 28 Sep 2022 09:49:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 04/15] target/arm: ensure KVM traps set appropriate
 MemTxAttrs
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20220927141504.3886314-1-alex.bennee@linaro.org>
 <20220927141504.3886314-5-alex.bennee@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20220927141504.3886314-5-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/22 07:14, Alex Bennée wrote:
> Although most KVM users will use the in-kernel GIC emulation it is
> perfectly possible not to. In this case we need to ensure the
> MemTxAttrs are correctly populated so the GIC can divine the source
> CPU of the operation.
> 
> Signed-off-by: Alex Bennée<alex.bennee@linaro.org>
> 
> ---
> v3
>    - new for v3
> ---
>   target/arm/kvm.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
