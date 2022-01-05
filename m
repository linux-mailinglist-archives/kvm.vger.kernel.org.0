Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDDD484FCF
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 10:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238775AbiAEJLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 04:11:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33137 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238778AbiAEJLO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 04:11:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641373873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wGXuV03c1XyCUjItCLnIsyd8BI3JnVSWBblM+WpqoH8=;
        b=fA4Rlxe3qKLyNCbAo2AlUtPrPE49VAkNx0Gdh7VY0SlezuxWhfr1YImTnx34Lq9W+NNcVA
        2/oxKQ5Uxqn7fqNFhOWzB0ZF9GtqSyJBa2l2vEbznTnkTESGo/nlrJCnuGhazyo/jqjSqT
        nw9Fqg0E72ZF7ABcLKSubCQSd+eiVYE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-ek-LnTIbOa-6Gzzk6uieyg-1; Wed, 05 Jan 2022 04:11:12 -0500
X-MC-Unique: ek-LnTIbOa-6Gzzk6uieyg-1
Received: by mail-ed1-f71.google.com with SMTP id y10-20020a056402358a00b003f88b132849so27671616edc.0
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 01:11:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wGXuV03c1XyCUjItCLnIsyd8BI3JnVSWBblM+WpqoH8=;
        b=F2bYmn86jD4t6SGUIUFFCQp1AKShjsw9m7Gd24HJGd+SiewBj8rhRZk0bi9Sa8L7Vo
         Gsoxuu4k7k7oE06Zuc+DCpzvgP29iG4YVFNgYWLI9J31CQMp8w3kA9nhp7iDGx9wlGNC
         C9LVLMdfWibjFhnEWVOnqd00xNkNq54K8viQeP7ZGxm4lipPl9u9216VCS5uHJPApCUs
         /EAmaaWTYEaIy4zSkDkP58LXb4PrR/1mlYYyGrjdEATiSbhhuACERpuT2uKtMhWyw7rU
         59E3c2xf26u/N4RVl6oQOnjct9slWFHAwoFiPWYPozasRaSU+4ACOx8VW4g8XvBwHRsd
         6BeQ==
X-Gm-Message-State: AOAM531sCpE8YCGGT4PKyVqtlSzvGhdLMAderjJRRNfNvahVWY16v4WX
        ku5ACUgD/+yD+oUC/ngn514S714XFUtElx/UsKVVBrgWwj6hE06eRZyeeB/UWXy3PpIio8UYN/9
        O5q3cdZ9i9UiH
X-Received: by 2002:a17:906:cec5:: with SMTP id si5mr43790756ejb.17.1641373871355;
        Wed, 05 Jan 2022 01:11:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxj6BBCCUzfRQ9E8WIhaByAQU1q2z68Us8hyGT7uWXlHr551Ke+nkWueqXord49AuXdZQfWiQ==
X-Received: by 2002:a17:906:cec5:: with SMTP id si5mr43790742ejb.17.1641373871189;
        Wed, 05 Jan 2022 01:11:11 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id u14sm15475720edv.92.2022.01.05.01.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 01:11:10 -0800 (PST)
Message-ID: <ceb63787-b057-13db-4624-b430c51625f1@redhat.com>
Date:   Wed, 5 Jan 2022 10:10:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com> <87mtkdqm7m.fsf@redhat.com>
 <20220103104057.4dcf7948@redhat.com> <875yr1q8oa.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <875yr1q8oa.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/3/22 13:56, Vitaly Kuznetsov wrote:
>   'allowlist' of things which can change (and put
> *APICids there) and only fail KVM_SET_CPUID{,2} when we see something
> else changing.

We could also go the other way and only deny changes that result in 
changed CPU caps.  That should be easier to implement since we have 
already a mapping from CPU capability words to CPUID leaves and registers.

Paolo

