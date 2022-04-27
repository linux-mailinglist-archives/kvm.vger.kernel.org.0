Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4AC511D89
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242688AbiD0QVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 12:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242795AbiD0QUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 12:20:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B52552B1B
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RzItaAexJm8D+vfjQz5rKxOdybX8BYSOmObiCpIyc/0=;
        b=a3ZN4KfAl5pVShhkOCKJghtGoFYEHc5Bq9oG1hKZ/viZafbvjNzC1BLJF+I+QyroNZqhbz
        GSQ/fof4jhe7dWEWJX7FKzyRduvmVe7E5d7kj28o4tMqcV4LLv0T1olr/3hVbK+BMEd5+4
        ppaxw2ejqWHzTxqE8+xGVKiehE95+z8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-jtJopMA7P_m0e2ndFF6C3Q-1; Wed, 27 Apr 2022 12:16:58 -0400
X-MC-Unique: jtJopMA7P_m0e2ndFF6C3Q-1
Received: by mail-ej1-f72.google.com with SMTP id nc20-20020a1709071c1400b006f3726da7d3so1429632ejc.15
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:16:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RzItaAexJm8D+vfjQz5rKxOdybX8BYSOmObiCpIyc/0=;
        b=eykWrzGnn0/F6Cimv3kiwQN1emC7yg1ObNbjmf3ykrCUqT7y98xXTIl+j9/+24Nqmw
         kOV1IVJ3WLZ57Onb+x+ttfD32IRCOqv7P6lUOospSkF6XihpRw6Fnyn9NTEEfLTso12d
         Qjveb1B7dsxgClv3EMDtNDDDBWa+7su/uvJa4JKozAVHwZ8/uNznSTu3wPk9ppBaMVRJ
         DmwvCoGzbq0uEnjt8nI/EeF5ApUUaHtpw9Z+YnEXTAS5oEiFtgVldYONLMGRztb2MplK
         b8LCUTIXH7NiM0ftmmdcrEt2oDWBM9B42tJX8jIoN+Purl3Y0J1FGVARO24jev9x+0VI
         +Qig==
X-Gm-Message-State: AOAM530tZ/Nd4LxY4PXWNggtkzVqDNglaYWPesGlOh+GnxpWP5bCDCc7
        LKyz2FOXKN4bXAgAqyoSx15+1/Cal8qdpStoUYX7v+FOMQpo3vz9uBwDfIiqQ38a7HSVrSVD1oS
        zQ72TdDNlD9EP
X-Received: by 2002:a05:6402:5207:b0:426:1f0:b22 with SMTP id s7-20020a056402520700b0042601f00b22mr6744651edd.186.1651076216840;
        Wed, 27 Apr 2022 09:16:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwb75nHu6t51f1NDMxfZSRIItEiFS+6dOplwZZEazQUSBmfChxMq0wTDyn1DlO9plv/BGY99w==
X-Received: by 2002:a05:6402:5207:b0:426:1f0:b22 with SMTP id s7-20020a056402520700b0042601f00b22mr6744632edd.186.1651076216627;
        Wed, 27 Apr 2022 09:16:56 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id z19-20020a1709067e5300b006f39880d8e5sm4297615ejr.78.2022.04.27.09.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:16:55 -0700 (PDT)
Message-ID: <76dfc0b8-f892-c445-084c-62672293ca92@redhat.com>
Date:   Wed, 27 Apr 2022 18:16:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.17 5/7] KVM: x86/mmu: avoid NULL-pointer
 dereference on page freeing bugs
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155408.19352-1-sashal@kernel.org>
 <20220427155408.19352-5-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155408.19352-5-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 17:54, Sasha Levin wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> [ Upstream commit 9191b8f0745e63edf519e4a54a4aaae1d3d46fbd ]
> 
> WARN and bail if KVM attempts to free a root that isn't backed by a shadow
> page.  KVM allocates a bare page for "special" roots, e.g. when using PAE
> paging or shadowing 2/3/4-level page tables with 4/5-level, and so root_hpa
> will be valid but won't be backed by a shadow page.  It's all too easy to
> blindly call mmu_free_root_page() on root_hpa, be nice and WARN instead of
> crashing KVM and possibly the kernel.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/mmu/mmu.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7f009ebb319a..e7cd16e1e0a0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3239,6 +3239,8 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>   		return;
>   
>   	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> +	if (WARN_ON(!sp))
> +		return;
>   
>   	if (is_tdp_mmu_page(sp))
>   		kvm_tdp_mmu_put_root(kvm, sp, false);

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

