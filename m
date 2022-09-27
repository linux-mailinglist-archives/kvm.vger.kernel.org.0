Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020AB5EC5AA
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 16:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiI0OO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 10:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiI0OOU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 10:14:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9281BBEEB
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 07:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664288058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IItujQZ35XQTMm72F5CS3qT+KUforvi0ITP4MY95tpA=;
        b=Mf9q7c3iDu5pFTFyMNuJn7LPwV3sD8YIKwi/nawYdIe4hi58oFgIhHQ9Nbl0yyCERmWCQi
        teHy7nBB4KV1uqzWfZ4iWDLY9vmSBQlG1qxR/MNRVhVgdKScGD8ifxM0Jaasd7lfK/ZGr+
        uoRfW8sFg2oHZnqMGGSEMChEqJVu7f0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-300-kPzW9J2UP_OZpqsZE9b2IQ-1; Tue, 27 Sep 2022 10:14:15 -0400
X-MC-Unique: kPzW9J2UP_OZpqsZE9b2IQ-1
Received: by mail-ed1-f69.google.com with SMTP id m3-20020a056402430300b004512f6268dbso8004033edc.23
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 07:14:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=IItujQZ35XQTMm72F5CS3qT+KUforvi0ITP4MY95tpA=;
        b=TAsYYu0ILBS30nPqppo1xmcN75GAxhF3HdIw7HenL59OZ7OVn+ETtASVvtRFbexzdE
         aDd17zccIDScxvz18ZD+62q+IUqZ+mzRvZCxiEEN10YOGcUlFe7EL15VJPkzRWf1BBR6
         I8FHsdH5qgaXlos3b1/SlBj/B5Ik8oebY6qyHCjxJwt0d+WS0EMA+1lc2YRBpP9Pja/a
         wTKOjszbxRx/RZCoepkRun3KTZAXVDYnY436iLTBCJvZGSpo57iw0KtOQMYer9H3kpMP
         mRgNUguibM6qNrUpR6UL5uubD7ZbbitZXVTTR/qtv6/+k3o4DG1F33bsNE7qDf6z0QyZ
         oHrA==
X-Gm-Message-State: ACrzQf2EwxNIa1K7wUjHmLd9KxQ5QQShru3tSkWQL6N3oB1bzNEh6hJ6
        Hw7XvForAKTc1lFh25U/n//rOaSs6JTBb49uX1Mpfhz7pUF0JBe8SeG2egZqsoly8HZGoHGiceS
        Z484DkAm5Gn5l
X-Received: by 2002:a05:6402:348b:b0:450:28be:d6b0 with SMTP id v11-20020a056402348b00b0045028bed6b0mr28200039edc.386.1664288054096;
        Tue, 27 Sep 2022 07:14:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7++mzqnIxUsS43wA9ObPXRDKnSIFoQzY8nL0EHeF3fapNOLDyXXX8+GtCqSbbapkgwyLL+Ow==
X-Received: by 2002:a05:6402:348b:b0:450:28be:d6b0 with SMTP id v11-20020a056402348b00b0045028bed6b0mr28200026edc.386.1664288053860;
        Tue, 27 Sep 2022 07:14:13 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id l25-20020a056402125900b0045791398df4sm1305213edw.92.2022.09.27.07.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 07:14:13 -0700 (PDT)
Message-ID: <6d30dcc4-4f44-091c-08a3-037c6152281b@redhat.com>
Date:   Tue, 27 Sep 2022 16:14:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: x86: Hide IA32_PLATFORM_DCA_CAP[31:0] from the guest
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        seanjc@google.com
References: <20220922231854.249383-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220922231854.249383-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/22 01:18, Jim Mattson wrote:
> The only thing reported by CPUID.9 is the value of
> IA32_PLATFORM_DCA_CAP[31:0] in EAX. This MSR doesn't even exist in the
> guest, since CPUID.1:ECX.DCA[bit 18] is clear in the guest.
> 
> Clear CPUID.9 in KVM_GET_SUPPORTED_CPUID.
> 
> Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 75dcf7a72605..675eb9ae3948 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -897,8 +897,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   			entry->edx = 0;
>   		}
>   		break;
> -	case 9:
> -		break;
>   	case 0xa: { /* Architectural Performance Monitoring */
>   		union cpuid10_eax eax;
>   		union cpuid10_edx edx;

Queued, thanks.

Paolo

