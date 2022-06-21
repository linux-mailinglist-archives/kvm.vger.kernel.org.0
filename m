Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026805532CC
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 15:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351014AbiFUNB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 09:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351222AbiFUNBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 09:01:14 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128FA2B25E;
        Tue, 21 Jun 2022 06:00:42 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z11so13100151edp.9;
        Tue, 21 Jun 2022 06:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c2lxo27whQqfjrSMb1N0kIfN8nfAtbXW7B4jSIuP+t4=;
        b=Gb9VTbQdlr4aP/69yyWuIBp2c7G7jnTP5dpOffH6aerBanwB6a7Z4ViKmSNr7lpjPi
         8cvXnOqAQ846OIuAX/bYv0uHq46h56XrvfyXfg7maOOFKWuOwPQqXqLOidPK87ORWZxJ
         SEHMewgROEv4Bco+01+fj2QUvL4Go+hNU8dg/2nDLhcFqOcRivmA9loGUzoW6QZmqqns
         QKeE/TXSmuIFptGBVlz6F4IHo0Q5Zza9lpfjXa9epzD26Uui/adeTHGRgAzcteWendTs
         1QKAItKDfYOsMfN39QYNkdsLNqppDY0bikLdc4LwQSz6Tg5eTOvwObd9CiPDmJ+GZH2Q
         bxtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c2lxo27whQqfjrSMb1N0kIfN8nfAtbXW7B4jSIuP+t4=;
        b=Za0lCijac1Y/RbI+MPu4wvHXPVUqq8InvNRGbFgPTCHJwe6/Fp/DDSu/v/e/kAs3G8
         bPrtb57W8Ml0iuEtrL8+dnVlcuzL6IgQdipJyH73ja3GYSisrYM9oopbqFx1FncRGDbo
         pBiYLih8cfNKeI1w+bJcwbthopHdYw0uX9H4HuRGWke1kpX4j6XqYQVWunKsA9ez7GYt
         6siibUv13cunB2cVv0hb9LWPzDr+uVJZjK409A4xEsm4KUHMSDyMyfhUI9bSzwtJM6Tt
         L4Tx3LS9WF4vAcsqHwtE8ARar14X0RpNTDckX2RI136zRjNEEAnT4SUewV3BfPrrugOd
         o2aA==
X-Gm-Message-State: AJIora9PveQiHfwD5cjcqXbIva9McMuOTDGWNET5dmtK0/5626o4vk8p
        A0MGq8q4jeq2jyFvpv4zZlSKnfHa2cA=
X-Google-Smtp-Source: AGRyM1s/gLOIJenRxHO4SWxvQvKXccl0hO78cht0LFAt+dhry6ZvIXDFfAZC7bez1j/oqVrNJOksOA==
X-Received: by 2002:a05:6402:1d48:b0:42d:d1a2:7c6d with SMTP id dz8-20020a0564021d4800b0042dd1a27c6dmr35675400edb.43.1655816440614;
        Tue, 21 Jun 2022 06:00:40 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id p6-20020a17090653c600b00722e0b1fa8esm1469868ejo.164.2022.06.21.06.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 06:00:40 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <eab4d1d8-913d-71b8-b48e-01ff83bc128f@redhat.com>
Date:   Tue, 21 Jun 2022 15:00:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v7 00/39] KVM: x86: hyper-v: Fine-grained TLB flush + L2
 TLB flush features
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220613133922.2875594-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220613133922.2875594-1-vkuznets@redhat.com>
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

On 6/13/22 15:38, Vitaly Kuznetsov wrote:
> Changes since v6:
> - Rebase to the latest kvm/queue [8baacf67c76c], newly introduced
>    selftests had to be adapted to the overhauled API [blame Sean].
> - Rename 'entry' to 'flush_all_entry' in hv_tlb_flush_enqueue() [Max].
> - Add "KVM: selftests: Rename 'evmcs_test' to 'hyperv_evmcs'" patch.
> - Collect R-b tags.
> 
> Original description:
> 
> Currently, KVM handles HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} requests
> by flushing the whole VPID and this is sub-optimal. This series introduces
> the required mechanism to make handling of these requests more
> fine-grained by flushing individual GVAs only (when requested). On this
> foundation, "Direct Virtual Flush" Hyper-V feature is implemented. The
> feature allows L0 to handle Hyper-V TLB flush hypercalls directly at
> L0 without the need to reflect the exit to L1. This has at least two
> benefits: reflecting vmexit and the consequent vmenter are avoided + L0
> has precise information whether the target vCPU is actually running (and
> thus requires a kick).

I haven't reviewed the selftests part yet, but for the rest I only had 
two very small comments.

Paolo

