Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D3D55A85B
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 11:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbiFYIzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jun 2022 04:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiFYIzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jun 2022 04:55:09 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839FD3CA7C;
        Sat, 25 Jun 2022 01:55:08 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id pk21so9229909ejb.2;
        Sat, 25 Jun 2022 01:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jaUOMA46tSqgmaqzzLhut0J/UsQ1nhHZ/vUSRQo5a1o=;
        b=LNdtdAaP1nkJ8tXLFpBAW+vWVcHY1vhPqM6t2dyYMz3YpcBzlJMTKGKlYDEaSt2nTO
         7SjcTYb6tK59rwE6XKxpNDuwihUWDIAwxR/kmChhxhqDPuTuxvTwa2kikbJCDQLGeiof
         Mexn6b6P2fMGaLglt+GB5rCh/zGkMDfjeNqTGAs6HYu2g9Km+/364OdkPC3/35mufffF
         0K++RcTDSYp31VGE4Iadxis8wPDCkY0Rrg2TdsbJzjghP1CAcecNcB8y+CCzVTvv0PDI
         v5XKy2IgpWPjRcKYqjf60IhgbCGErhzvmrnSTs92rao/KgxRa6vtejvwM7EWs/9WOddz
         hJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jaUOMA46tSqgmaqzzLhut0J/UsQ1nhHZ/vUSRQo5a1o=;
        b=k9d6W+dBeuAbeuEYJVkf0Le9VvvwwOiNXBiK1hTgtjREqRz71i4URHvN56JDaxzFoS
         DQyRfUVPjDGG6T+fsE8l6V/OhF0ey4YejtoIJEwYd9ltV3InLEzHpH4VV1C9RbYFqzis
         o8mO0JW+5mLXgBm5JQNBH43qCf66FzgBgYdcveh49PPZraBjVFu8RuZGjSin2CU80Ktk
         iXaaTLUDgk9AuvI/5eWw8xcKScoRfiNug8FTe6ktPO+VRqhILO68d10igV5ZObM/zbLf
         EBz3KntO1N5vfrdNkf23jfYd1/6NFo2Xgej2YeOFnmIp0MkhFt0AmsEnO2bBzLsn1eCK
         cgtg==
X-Gm-Message-State: AJIora9zAk6Ko/Gpp3geERuzw9JBjLin7lbcdVT4P7S1xdnO+gKJYkAL
        dJ4vnZOZau1v4Zx0o85VElDUR7YFvcg=
X-Google-Smtp-Source: AGRyM1u2+hP4PXZIfCHZyNpeXg0OuVQvCS/EE38+MmPOmtdACxl8YxiL2LU6RGp+hAdGvuEHT1ww1A==
X-Received: by 2002:a17:907:c0f:b0:726:3172:5eea with SMTP id ga15-20020a1709070c0f00b0072631725eeamr2984951ejc.110.1656147306869;
        Sat, 25 Jun 2022 01:55:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id e5-20020a056402088500b0043566884333sm3678708edy.63.2022.06.25.01.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jun 2022 01:55:06 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f0a0ab85-d6de-8f7e-d0be-6c6abffebb33@redhat.com>
Date:   Sat, 25 Jun 2022 10:55:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/3] KVM: x86/mmu: Cleanups for eager page splitting
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
References: <20220624171808.2845941-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220624171808.2845941-1-seanjc@google.com>
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

On 6/24/22 19:18, Sean Christopherson wrote:
> Eager page splitting cleanups for a few minor things that were noted in
> code review but didn't make it into the committed code.
> 
> The last patch in particular is a bit more urgent than I first realized.
> I had forgotten that pte_list_desc is now 128 bytes, and I also had a
> brain fart and thought it was just allocating pointers, i.e. 8 bytes.
> In other words, I was thinking the 513 object buffer was "only" wasting
> ~8kb per VM, whereas it actually costs ~64kb per VM.
> 
> Sean Christopherson (3):
>    KVM: x86/mmu: Avoid subtle pointer arithmetic in kvm_mmu_child_role()
>    KVM: x86/mmu: Use "unsigned int", not "u32", for SPTEs' @access info
>    KVM: x86/mmu: Buffer nested MMU split_desc_cache only by default
>      capacity
> 
>   arch/x86/kvm/mmu/mmu.c | 53 ++++++++++++++++++++++++++++--------------
>   1 file changed, 35 insertions(+), 18 deletions(-)
> 
> 
> base-commit: 4b88b1a518b337de1252b8180519ca4c00015c9e

Queued 2+3.

Paolo
