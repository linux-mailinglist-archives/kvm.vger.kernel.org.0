Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22964554C2A
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353487AbiFVOGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbiFVOGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:06:35 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C7737AA9;
        Wed, 22 Jun 2022 07:06:34 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id sb34so5452605ejc.11;
        Wed, 22 Jun 2022 07:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WxeHFPlfiSptfkzXY60BBTFs27kl7bS4qonpRA5K3SA=;
        b=T7qphS0ZRa134v/8ItGchQB9bogGth9+5pDqC2hUX7s6C0zH7zYuoVDdPuoEZvVhok
         sE8TcoXHH1m3cDpGrhMwP5aPbvry5T1tenDhgg6s+00ccl+qec9fmsQa3VSHCv85tuUV
         u7Zp9VqC5uvnf5aKFHSQONUqA2SWHhdZc0262grRx6E1iriI55QPfee4SZ9dxFO2hZZX
         NgDmhyM8bS8CvOev8gERKMIpNzrz0dTI+6GxQ7Ds972NKNw2Yia7OrPQkBu6LMBfQVBM
         HBwMWb4dD1DaGqEUDyoDX5Q6LBV8Ni+U5Uc+mtzdqRdJn+mz9XkbrYFYjC1ZQfs3CF/+
         2pYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WxeHFPlfiSptfkzXY60BBTFs27kl7bS4qonpRA5K3SA=;
        b=NTm8jkkexJApiDuk/yCa5QLiD8ygFi/O4gol3OPeebpGiwF5cz308+wRWIV7WAW7rA
         0WH8d623AwJljHAWOmxuYPZyCgwjVKw4jSh52HJ7DlruYL/acZgjxapTPaW2H2M6hZ/a
         IyTcO5UDcypFllm7kiHKEBzQTvtGTgfQ2WHTfKH5aYE0U8nAmecpxn6qEF0UbV3TNZh2
         taFxsUpiSJdFMKcEt6T6JDKYfG2gd8c2+P6KxYsBPWVDzoMlZz5VdpSV8LTSelyqcEgC
         CCDsQflt9j9pZjEWf/BS9Aevy9q6AejsyItLwRdEnDZm3zQ/4YHDvHgdbztISYVOnxyc
         FbGQ==
X-Gm-Message-State: AJIora8bm3JeLVYwyzxVcOeLgJuaLJMA7sGrQidQWutyGudZCx/pzHeH
        lPwjxUewX34iD3EVDFVDbN8=
X-Google-Smtp-Source: AGRyM1sD+9xzrrmv7BOEV1UN/1LyYHfkX2LTy6aXPGG/mcNyWY8NiWtb+z+dGzKS5l7haVgtNNE0zQ==
X-Received: by 2002:a17:906:9f26:b0:722:f998:7b2b with SMTP id fy38-20020a1709069f2600b00722f9987b2bmr1312998ejc.144.1655906793025;
        Wed, 22 Jun 2022 07:06:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id eg40-20020a05640228a800b004356d82b129sm10908572edb.80.2022.06.22.07.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 07:06:32 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <bb22c823-f12f-90d8-e8d6-0cddba95f60a@redhat.com>
Date:   Wed, 22 Jun 2022 16:06:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 03/22] KVM: x86/mmu: Stop passing @direct to
 mmu_alloc_root()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
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
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-4-dmatlack@google.com> <Yqt6rBPMxfwAPjp1@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yqt6rBPMxfwAPjp1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/16/22 20:47, Sean Christopherson wrote:
>> The argument @direct is vcpu->arch.mmu->root_role.direct, so just use
>> that.
> It's worth calling out that, unlike non-root page tables, it's impossible to have
> a direct root in an indirect MMU.  I.e. provide a hint as to why there's a need to
> pass @direct in the first place.
> 

I suppose there's *no* need to pass direct?  Also, there's the trivial 
(but less interesting) justification that kvm_mmu_load does

         if (vcpu->arch.mmu->root_role.direct)
                 r = mmu_alloc_direct_roots(vcpu);
         else
                 r = mmu_alloc_shadow_roots(vcpu);

and those are the only callers of mmu_alloc_root.

Paolo
