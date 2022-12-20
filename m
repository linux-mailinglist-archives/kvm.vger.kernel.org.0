Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D8565236A
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 16:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbiLTPDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 10:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiLTPDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 10:03:30 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBEEE4C
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 07:03:29 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id v7so9005395wmn.0
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 07:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bz/2kucdrDSxkmvn1W2aAaF8zJ8ugW62aj07JXMobU4=;
        b=Q27fza7y9d4lEwty1nKb5lQa1gSM7x9D4vvdKwjJOtBuLkhQiUvurbx8OOtUbVUuG7
         soaxfk8G+j3J/5v/rFR2v8qHy+5rZqptq5To4d8xzr0JxETYWw9rXdZ2Gu5pvVXQJU+q
         eEI2jfA/kHCcNMUxv7Jo0mchkVY5V4TTNnx0MlwU8D8aRWgOze68GS0uBvZLU59+ZaCa
         u8089nqfaTh7afcZrs3hUCXVbtJFGEJn8ayp/4uacomS0jA31hOPHGp5QjANfnVgF/7L
         Lf30cUQG6ei9pAtM4xcZMgNG11rFb/TbripCwr0TVEAD4ZKAHVlSlfOo4yo5/xKdONlX
         tcfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bz/2kucdrDSxkmvn1W2aAaF8zJ8ugW62aj07JXMobU4=;
        b=px5vwEWHFzMqY44364lJmC9WHLmIrkrdWmCWv/ImAeg+rloOUUn6feT2f1i+ww+jf4
         nTtaALUJRvRBair4EMGXGtQG9tjefmTQasLaBTE34wfD4Yikvin2dT2RhA1J3D4FJthh
         Ps4B58GG//+J9EIAmEDMQnMRoN/GYk+9ZTSTqfX31DaYI4X/P2T2vYK3mRc00Nt8qXr2
         KSfqr6IrtIPMmgFQdMSxe/qVshJIv5wQL0rb6Zs5f86GgoRoAAPOEbCz1rrBV9L7B9D1
         Va5miEISI1bzAvLtRidjDK30EE3U5sMUgr/oYCAf2X1Tdg87Pc+nQQmH8RMP9qurTUGt
         YWrw==
X-Gm-Message-State: ANoB5plaRJfIxFa9zuJ5HIJm71N/db4hufaAu/Usuvrd0z7DqOLW4J0t
        je4a2cadRF6koNcChOFQeB8=
X-Google-Smtp-Source: AA0mqf6dlW4Vp3LpAu/sYONb4tuVd+eAzsxXZfijqGYHwCj5TvMif5sM4m/DVb8KU6Ye/0a4x7hpCQ==
X-Received: by 2002:a05:600c:1e24:b0:3d2:3b4d:d619 with SMTP id ay36-20020a05600c1e2400b003d23b4dd619mr20070611wmb.15.1671548608258;
        Tue, 20 Dec 2022 07:03:28 -0800 (PST)
Received: from [192.168.6.89] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id g12-20020a05600c4ecc00b003cf9bf5208esm25911543wmq.19.2022.12.20.07.03.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 07:03:27 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <8815bd0e-ff26-a2c3-4307-49eaffbabafe@xen.org>
Date:   Tue, 20 Dec 2022 15:03:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] KVM: x86/xen: Fix memory leak in
 kvm_xen_write_hypercall_page()
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, seanjc@google.com, pbonzini@redhat.com
References: <20221216005204.4091927-1-mhal@rbox.co>
 <94fb9782-816d-e7a1-81f2-b5a3fa563bbd@xen.org>
 <53159d2b-edcd-d9bd-b7a0-e72463e901cc@rbox.co>
Organization: Xen Project
In-Reply-To: <53159d2b-edcd-d9bd-b7a0-e72463e901cc@rbox.co>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/12/2022 14:25, Michal Luczaj wrote:
> On 12/20/22 15:10, Paul Durrant wrote:
>> I'd prefer dropping this hunk...
>> ...
> 
> Sure, sending v2.
> 
> Should I use your @xen.org or @gmail.com for suggested-by tag?
> 

@xen.org

Looks like my config has lost a Reply-To somewhere along the way. I'll 
go and find it.

   Paul

