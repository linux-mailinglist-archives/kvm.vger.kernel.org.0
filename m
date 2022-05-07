Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D252151E556
	for <lists+kvm@lfdr.de>; Sat,  7 May 2022 09:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446024AbiEGHuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 03:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358709AbiEGHuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 03:50:51 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ADC53A7B;
        Sat,  7 May 2022 00:47:05 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id x18so9468260plg.6;
        Sat, 07 May 2022 00:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nB3DYjKLYyYWfNZgZK9W2AdXK4sBfxt6y19hg7k0bWQ=;
        b=lLgerdUrwFgqY5KSmEGF55k1CT5IEVnAK48E+XmSLQo1aE2sZEi5rTZUO8FXExriiU
         LWJbsc9LYYcL+ngR+XKA2yuK1yoA7/9Jsc3HjPu5gDMSi5vJyclvLe0PZG6p6Lg4TbRG
         A+SpJsH65XtEoYe/YTzOz+DjUUX58V6iCqTR/0aFM78NdQ08CxV+DDki3lnUg/GK1gdf
         ZgZAc/FbBfNH5633KlK3kGu9fGMRVzLKdML2vx7VSjnU/jqmTv2ZA3v0L1Y7hI/dg1HM
         AglOAn7O4tq3Y0/ygxZtwz5MU3raEVnhW4fgU9y2pLwl2HnlCLeZjudZcxH2FLsgoqp9
         76WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nB3DYjKLYyYWfNZgZK9W2AdXK4sBfxt6y19hg7k0bWQ=;
        b=J6EVkZyZnSK9H/l9SAnGCrMA/rHW//7D+3MvxJPn/xz8/rwipd5gDrdFhfkgKxCS92
         DerZnxbuahSzDbxsfrKngIojLOravNk5XHr382uBvH11Rfsef29pJc/zLo0zjPY3Ffit
         0NNjbuXtYCN1wVm+B11jI1UNWG6bs5KUHND7Q6y96kkDMyG+ZY0onnnJ9HlLCfMmS5kI
         OctSdGMN9JHooT/y7D1pf0Ac6irqJIgVFn8bhbw1Ushqek8B+bgPUekn5bX65D/WWTdB
         mzvarsq1AtQRo9OTuhFoTFJfngj33mXMalmcCszZTbCkclfs7ESz63XMkoLSaaxXOK7G
         C1dQ==
X-Gm-Message-State: AOAM533ayNm5ny51LADsJjhIWxI3er422wdIoSqrZEzKMIfJ0/6tRKFR
        oVw9ZiAWcmxzG7l2Vvj9SUY=
X-Google-Smtp-Source: ABdhPJzoUA93BCaNMvFRM7dpjETpDp+8EsOq+q1oC8wEjIZ1U0lUhRyo2h6oynP6i2Cal4U4jL+7tg==
X-Received: by 2002:a17:902:a712:b0:158:e577:f82 with SMTP id w18-20020a170902a71200b00158e5770f82mr7528008plq.146.1651909625068;
        Sat, 07 May 2022 00:47:05 -0700 (PDT)
Received: from [30.22.112.212] ([205.204.117.91])
        by smtp.gmail.com with ESMTPSA id oo10-20020a17090b1c8a00b001d0ec9c93fesm4914540pjb.12.2022.05.07.00.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 00:47:04 -0700 (PDT)
Message-ID: <d06c57fb-5c54-e496-7c0b-f5a57912f082@gmail.com>
Date:   Sat, 7 May 2022 15:46:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v4 02/20] KVM: x86/mmu: Use a bool for direct
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-3-dmatlack@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
In-Reply-To: <20220422210546.458943-3-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/4/23 05:05, David Matlack wrote:
> The parameter "direct" can either be true or false, and all of the
> callers pass in a bool variable or true/false literal, so just use the
> type bool.
>
> No functional change intended.
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---


Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>

