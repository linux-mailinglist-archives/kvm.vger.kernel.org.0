Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2037D755DFC
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 10:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjGQINI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 04:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjGQINE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 04:13:04 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6E912D
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 01:13:02 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-31427ddd3fbso4022166f8f.0
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 01:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689581581; x=1692173581;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VT24UUIzDMth5tPZL5Y5vTEOs+P0BwYmDWZgKveF0+M=;
        b=K/iJhKX4wID4O6BHCkqoNDeKizzM0ai2C/JJVSYMd+iQ+t5gkYEyqR8OcId9s6Uw/g
         +AIOCIIHWgQP5i51DcuabWMLSpL4+g4yBFEaNnFvCFvlOvJtDRtBZSsu4q/eyraIhxnF
         34lFSWsMuYImH0tASUyIG9UN5kV+zySjXP1wgy3I0PiMTd8SGe0bBTaL1/3m+AIDIUri
         t2pJXylGN30xSlpLDQiAnrflPN5i2wyDLNiZpxqAYVBhvceI1p6Lvuk8qVu8Vmd37D5M
         py/+IAtS+moAn/+PGdzK6ETPGkvlELAfB3SP0bODnQ1hd3dVHt1OhCJkizrojhSmGnF9
         2zag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689581581; x=1692173581;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VT24UUIzDMth5tPZL5Y5vTEOs+P0BwYmDWZgKveF0+M=;
        b=efE5XpeQBLNnMZCxd2lrZdIPFVlqP6LHFzNnhKeJQ8BfCCZuJuIRjbWByhKPISAkLT
         FW1WqsOH9qZjBa0uH2p22C7OCLKL563pytXc8LYo7v/cRY84T5HVL1m+1WRKrEOYFkNp
         xDNyoX3Im79swiIQVYX2EXUMXqyG65dv2ialV1lC1/wyPmrfjTRUhk8IMLYLmmC1q9Fx
         H+r/H7RiLkqy6LpSLm/7/93xZWJEmU2iE1BFM+XtOY54DnGzY1ZpEG1SIo44McvR4eVe
         GfBmyBbJx08DTDf6C6NAiz6EhSjxYwgDcxf3RN0prsbwqi4mRt84callI0b1ojuD7ALN
         9urA==
X-Gm-Message-State: ABy/qLbhlGBzmi6ZFUv5nwr7P1YCfizLDsVpiF0FjpmJmqfBmr4w7vDX
        zXIMHEgRM2NVyy2MiAes8BwhXw==
X-Google-Smtp-Source: APBJJlHUSWcZYlPppSbFTXSEdHwpgpaTrSSog0KcOaUXq6539rjFQxsogmQ3Co+Knjkf78qoCa1SzQ==
X-Received: by 2002:adf:f206:0:b0:314:34dd:aaec with SMTP id p6-20020adff206000000b0031434ddaaecmr9504790wro.8.1689581581381;
        Mon, 17 Jul 2023 01:13:01 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.144.39])
        by smtp.gmail.com with ESMTPSA id b2-20020a5d4b82000000b0031432c2fb95sm18429372wrt.88.2023.07.17.01.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 01:13:00 -0700 (PDT)
Message-ID: <ef2dddcd-f4dd-da9b-c03f-ccd852bb8543@linaro.org>
Date:   Mon, 17 Jul 2023 10:12:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v6 02/11] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
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
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Zenghui Yu <zenghui.yu@linux.dev>,
        Gavin Shan <gshan@redhat.com>
References: <20230715005405.3689586-1-rananta@google.com>
 <20230715005405.3689586-3-rananta@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230715005405.3689586-3-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra, David,

On 15/7/23 02:53, Raghavendra Rao Ananta wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Use kvm_arch_flush_remote_tlbs() instead of
> CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL. The two mechanisms solve the same
> problem, allowing architecture-specific code to provide a non-IPI
> implementation of remote TLB flushing.
> 
> Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
> all architectures on kvm_arch_flush_remote_tlbs() instead of maintaining
> two mechanisms.
> 
> Opt to standardize on kvm_arch_flush_remote_tlbs() since it avoids
> duplicating the generic TLB stats across architectures that implement
> their own remote TLB flush.
> 
> This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
> path, but that is a small cost in comparison to flushing remote TLBs.
> 
> In addition, instead of just incrementing remote_tlb_flush_requests
> stat, the generic interface would also increment the
> remote_tlb_flush stat.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
> Acked-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 +++
>   arch/arm64/kvm/Kconfig            | 1 -
>   arch/arm64/kvm/mmu.c              | 6 +++---
>   virt/kvm/Kconfig                  | 3 ---
>   virt/kvm/kvm_main.c               | 2 --
>   5 files changed, 6 insertions(+), 9 deletions(-)

You are doing 2 changes in the same patch:

- Have ARM use kvm_arch_flush_remote_tlbs() instead of
   HAVE_KVM_ARCH_TLB_FLUSH_ALL,
- Drop the now unused HAVE_KVM_ARCH_TLB_FLUSH_ALL.

Commits should be atomic, to allow partial
revert or cherry-pick.

Preferably splitting this patch in 2:
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Regards,

Phil.

