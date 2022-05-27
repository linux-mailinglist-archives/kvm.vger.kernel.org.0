Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE46B5366A1
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 19:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353466AbiE0RjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 13:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349787AbiE0RjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 13:39:04 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6049F33E81;
        Fri, 27 May 2022 10:39:02 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id n10so10108992ejk.5;
        Fri, 27 May 2022 10:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ggveh8SHmhpA1CVcf0zBPWcv+UcsxT6FgKOr4ooxOYo=;
        b=Evf0N1zWEen/eXiewcsrPqwDfrr2IHxHHo5C5FIQjlI1MHI9HPKvaeyOQWS3Tv3oqT
         0NDs3/pofgXeGLCwPORL6uJGVuNDYvQeABMVA40MQKeZu9C3+CRrBjjxRpQw/sG0eEJj
         Lyv9jKbfnHkZ8w+gtiSLnEILT+MZwC/4VdKcFpBCg4u/OP/GAlHDsfOM6PnYY7wZTQ0X
         ErDSpQZk17x955zBYkL3Sw40jkClyFUUdRs8KFMVJCI78Y/WnyTR29SbeUGtrMILyuhA
         r4XC7E1Ogh/LcXNinEfYGGImRoRW23fvEVSnteFMhv/d44JULuhM6h7aUZGkojHV/5GH
         6eUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ggveh8SHmhpA1CVcf0zBPWcv+UcsxT6FgKOr4ooxOYo=;
        b=pKmCN/ue6h5MztF5t9v4nJ4hmO9w7k/5reT5INt0r2rBl9dQFEQqL9I208yafO6t7h
         riRBz15FA4mwaiAmlxQTCsw33i4J3raeSh4eELwjYXZRa2UdOrq4Tnh8wGStJ//hmNy6
         9D9cp6zFUyVdMgRf92potY8xOM0Xf30D5B57GdpeLY/Cng6BXk5LoIYWf9f01snew+RG
         EliUox68l31d/C2+ImAKclSqWacOBidAIEImye+Cwm76exYsWuv5OCENkk8YZHU58eJ6
         714UkS59GkSc7IfSQ+kg83hZlAHiNXY861yeChkra0429+12e3HyADD/CFID6JqcR3EK
         y5zw==
X-Gm-Message-State: AOAM531wsvTocDN2fjnI6HaXWTTwpwd2sPHwuUUr4PDbRjRq89VKwK3+
        MK/YW63QIz4URqInbvuLcyI=
X-Google-Smtp-Source: ABdhPJx1YFuKKQ2dMek9laQU40XyS4LAyRysafHjGrIj5dc9r5FKPsvmV6NSObq24MR31ZtWFi1mmQ==
X-Received: by 2002:a17:907:168d:b0:6fe:e7b7:e52 with SMTP id hc13-20020a170907168d00b006fee7b70e52mr22869451ejc.330.1653673140738;
        Fri, 27 May 2022 10:39:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id y8-20020a056402358800b0042617ba63b3sm2422735edc.61.2022.05.27.10.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 10:39:00 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <2d2a9789-083c-7e58-4628-8ebd024bee1f@redhat.com>
Date:   Fri, 27 May 2022 19:38:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v6 047/104] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <653230043fdb2d20e871e79e73f757134ca92eeb.1651774250.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <653230043fdb2d20e871e79e73f757134ca92eeb.1651774250.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/22 20:14, isaku.yamahata@intel.com wrote:
> +/*
> + * Private page can't be release on mmu_notifier without losing page contents.
> + * The help, callback, from backing store is needed to allow page migration.
> + * For now, pin the page.
> + */
> +static bool kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> +				    struct kvm_page_fault *fault, int *r)
> +{
> +	hva_t hva = gfn_to_hva_memslot(fault->slot, fault->gfn);
> +	struct page *page[1];
> +	unsigned int flags;
> +	int npages;
> +
> +	fault->map_writable = false;
> +	fault->pfn = KVM_PFN_ERR_FAULT;
> +	*r = -1;
> +	if (hva == KVM_HVA_ERR_RO_BAD || hva == KVM_HVA_ERR_BAD)
> +		return true;
> +
> +	/* TDX allows only RWX.  Read-only isn't supported. */
> +	WARN_ON_ONCE(!fault->write);
> +	flags = FOLL_WRITE | FOLL_LONGTERM;
> +
> +	npages = pin_user_pages_fast(hva, 1, flags, page);
> +	if (npages != 1)
> +		return true;
> +
> +	fault->map_writable = true;
> +	fault->pfn = page_to_pfn(page[0]);
> +	return false;
> +}
> +

This function is present also in the memfd notifier series.  For the 
next postings, can you remove all the KVM bits from the series and 
include it yourself?

Thanks,

Paolo

