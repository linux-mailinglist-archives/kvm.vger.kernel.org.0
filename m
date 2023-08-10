Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFD67773A2
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbjHJJEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjHJJEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:04:20 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF2E2115
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:04:19 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3fe5c0e5747so3643335e9.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691658258; x=1692263058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tRRGt270hpgqI4zE1zgSatf0+H4Bh/F+VZZfxHZMxJQ=;
        b=oAEb/UVBkppyVSOHobReOPQ5YTJ38GSYmmwnXKvWBacyY35eiBK3BbweF9r2wySUml
         MEcisqaWbMu75RD/yi2+TApQnL2dFNUOP3LxnRpHcOKij/GZo0w0ruS8u+2sRfizq7K0
         RXpbZa5ou88CCBGxGOuZX1JLIdZicfZdY/CT8cY9pTtnS0KjgGk4/lotdDB2sxhQlLsF
         KS8SGcoWUwYCt9WiECBncj/W3XO/pC9wzUYaNE5W9koIsUJNRDyCxnF+WlJ36Zyyu8gs
         E3wn44pqQEnSVjV3WUZmbwDcfSycWhFbxh8XhXu2aO73sGromowt+6Napedljzo4dNil
         4yog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691658258; x=1692263058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRRGt270hpgqI4zE1zgSatf0+H4Bh/F+VZZfxHZMxJQ=;
        b=HsbEtaUcNSJi9KgA19H0nlogcn4ccJBotlIhiFheSZfjZeR2Ylb2HKvtP2RuUBdZ86
         KkBcSiWhK1vsrUuZB34QRrqonuaOM6OA0n1KuYBwNksa0C4BoaX8GekocDJhrv7XQOMp
         jX23O8KyjWgK2WwTWVvXn917uR0bqpy31KyWiFIlJSyVN300QfeUtvibTHypXrGmjSGO
         /D90Jw7pCviFZkfPd4BwIPlIWS60kClns7V0a7vPyQ1XsGMoa/2hTWVqzER9B9QWI1Hg
         MvyohcU0NylILTJxXDR3OjTi5QcuVySYhBwO8xvlmoacPHw7vPqpTHiyibK687tTjttl
         txsQ==
X-Gm-Message-State: AOJu0Yx3yUFrXzsKxC0iLDX498W1hu3C6ntpWbM0TEWOnQGxpfJ17rWu
        PExUPYdjpLCwLzDe3965Zl7cSg==
X-Google-Smtp-Source: AGHT+IEiyf6YzfxC02ypY0/hlAu3sZVgflth6mGPBaBQxUAqtG6jM0o50UoMEa2Wxjr8BGf/HBWSdg==
X-Received: by 2002:a05:600c:4fc8:b0:3fe:2120:eb7c with SMTP id o8-20020a05600c4fc800b003fe2120eb7cmr1225438wmq.0.1691658258110;
        Thu, 10 Aug 2023 02:04:18 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.158.65])
        by smtp.gmail.com with ESMTPSA id m22-20020a7bcb96000000b003fe2696ccfcsm1464479wmi.23.2023.08.10.02.04.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 02:04:17 -0700 (PDT)
Message-ID: <a645ce3e-dd24-8c06-5898-76f78828b608@linaro.org>
Date:   Thu, 10 Aug 2023 11:04:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v8 04/14] KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-5-rananta@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230808231330.3855936-5-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/8/23 01:13, Raghavendra Rao Ananta wrote:
> kvm_arch_flush_remote_tlbs() or CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
> are two mechanisms to solve the same problem, allowing
> architecture-specific code to provide a non-IPI implementation of
> remote TLB flushing.
> 
> Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
> all architectures on kvm_arch_flush_remote_tlbs() instead of
> maintaining two mechanisms.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   virt/kvm/Kconfig    | 3 ---
>   virt/kvm/kvm_main.c | 2 --
>   2 files changed, 5 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

